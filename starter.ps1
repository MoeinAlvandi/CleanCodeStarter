# Find solution file
$solutionFile = Get-ChildItem -Filter *.sln | Select-Object -First 1
if (-not $solutionFile) {
    Write-Host "❌ No .sln file found in the current directory." -ForegroundColor Red
    exit 1
}

$solutionName = [System.IO.Path]::GetFileNameWithoutExtension($solutionFile.Name)
$layers       = @('IOC','Domain','Data','Core')
$framework    = 'net9.0'

Write-Host "✅ Solution detected: $solutionName"

# Create projects if not exist
foreach ($layer in $layers) {
    $projectName = "$solutionName.$layer"
    $projectDir  = $projectName
    $projectPath = Join-Path $projectDir "$projectName.csproj"

    if (-not (Test-Path $projectDir)) {
        Write-Host "📦 Creating classlib: $projectName ..."
        dotnet new classlib -n $projectName --framework $framework | Out-Null
        dotnet sln $solutionFile.FullName add $projectPath
        Remove-Item (Join-Path $projectDir 'Class1.cs') -Force
    } else {
        Write-Host "ℹ️ Project $projectName already exists."
    }
}

# Create DiContainer class in IOC
$IOCProject = "$solutionName.IOC"
$DiClass    = Join-Path $IOCProject "DiContainer.cs"
if (-not (Test-Path $DiClass)) {
@"
namespace $solutionName.IOC
{
    public class DiContainer
    {
    }
}
"@ | Out-File -FilePath $DiClass -Encoding UTF8 -Force
}

# Set references
$domainProj = "$solutionName.Domain\$solutionName.Domain.csproj"
$dataProj   = "$solutionName.Data\$solutionName.Data.csproj"
$coreProj   = "$solutionName.Core\$solutionName.Core.csproj"
$iocProj    = "$solutionName.IOC\$solutionName.IOC.csproj"

Write-Host "🔗 Adding references..."
dotnet add $dataProj reference $domainProj
dotnet add $coreProj reference $dataProj
dotnet add $iocProj reference $coreProj

# Detect Main Project and link IOC
$mainProj = Get-ChildItem -Filter "$solutionName.csproj" -Recurse | Select-Object -First 1
if ($mainProj) {
    dotnet add $mainProj.FullName reference $iocProj
    Write-Host "✅ Linked IOC to Main Project"
} else {
    Write-Host "⚠️ Main project not found. Add it manually." -ForegroundColor Yellow
}

# Install NuGet packages (latest stable)
Write-Host "📦 Installing NuGet packages..."

# Data layer
dotnet add $dataProj package Microsoft.EntityFrameworkCore.SqlServer
dotnet add $dataProj package Microsoft.EntityFrameworkCore.Tools

# Domain layer
dotnet add $domainProj package Microsoft.AspNetCore.Http
dotnet add $domainProj package Microsoft.EntityFrameworkCore

# Core layer
dotnet add $coreProj package Microsoft.AspNetCore.Mvc.Razor

Write-Host "🎯 All setup complete! (Projects, references, packages)"
# === Create Context folder and class in Data layer ===
$contextFolder = Join-Path "$solutionName.Data" "Context"
if (-not (Test-Path $contextFolder)) {
    New-Item -ItemType Directory -Path $contextFolder | Out-Null
    Write-Host "📂 Created folder: $contextFolder"
}

$contextClassName = "${solutionName}Context"
$contextFilePath = Join-Path $contextFolder "$contextClassName.cs"

if (-not (Test-Path $contextFilePath)) {
@"
using Microsoft.EntityFrameworkCore;

namespace $solutionName.Data.Context
{
    public class $contextClassName : DbContext
    {
        public $contextClassName(DbContextOptions<$contextClassName> options) : base(options)
        {
        }

        // DbSets go here
        // public DbSet<MyEntity> MyEntities { get; set; }
    }
}
"@ | Out-File -FilePath $contextFilePath -Encoding UTF8 -Force
    Write-Host "✅ Created $contextClassName in $contextFolder"
} else {
    Write-Host "ℹ️ Context class already exists."
}

# === Create Repositories folder in Data layer ===
$repoFolder = Join-Path "$solutionName.Data" "Repositories"
if (-not (Test-Path $repoFolder)) {
    New-Item -ItemType Directory -Path $repoFolder | Out-Null
    Write-Host "📂 Created folder: $repoFolder"
} else {
    Write-Host "ℹ️ Repositories folder already exists."
}

# === Create Models/Common folder in Domain layer ===
$modelsFolder = Join-Path "$solutionName.Domain" "Models"
$commonFolder = Join-Path $modelsFolder "Common"

if (-not (Test-Path $commonFolder)) {
    New-Item -ItemType Directory -Path $commonFolder -Force | Out-Null
    Write-Host "📂 Created folder structure: $commonFolder"
}

# Create BaseEntity.cs with generic and non-generic abstract classes
$baseEntityPath = Join-Path $commonFolder "BaseEntity.cs"
if (-not (Test-Path $baseEntityPath)) {
@"
using System;

namespace $solutionName.Domain.Models.Common
{
    public abstract class BaseEntity<T>
    {
        protected BaseEntity()
        {
            CreatedDate = DateTime.Now;
        }

        public T Id { get; set; }
        public DateTime? LastChangeDate { get; set; }
        public DateTime CreatedDate { get; set; }
        public bool IsDeleted { get; set; }
    }

    public abstract class BaseEntity : BaseEntity<int> { }
}
"@ | Out-File -FilePath $baseEntityPath -Encoding UTF8 -Force
    Write-Host "✅ Created BaseEntity class in $commonFolder"
} else {
    Write-Host "ℹ️ BaseEntity already exists."
}


# === Create ViewModels/Common folder in Domain layer ===
$viewModelsFolder = Join-Path "$solutionName.Domain" "ViewModels"
$vmCommonFolder = Join-Path $viewModelsFolder "Common"

if (-not (Test-Path $vmCommonFolder)) {
    New-Item -ItemType Directory -Path $vmCommonFolder -Force | Out-Null
    Write-Host "📂 Created folder structure: $vmCommonFolder"
}

# Create Paging.cs
$pagingFilePath = Join-Path $vmCommonFolder "Paging.cs"
if (-not (Test-Path $pagingFilePath)) {
@"
using System;

namespace $solutionName.Domain.ViewModels.Common
{
    public class Paging
    {

    }
}
"@ | Out-File -FilePath $pagingFilePath -Encoding UTF8 -Force
    Write-Host "✅ Created Paging class in $vmCommonFolder"
} else {
    Write-Host "ℹ️ Paging class already exists."
}


<#
.SYNOPSIS
    Detect and fix duplicate AssemblyVersion attributes (CS0579) in SDK-style .NET projects.

.DESCRIPTION
    Scans all C# projects under the current directory (or a provided path),
    finds user AssemblyInfo.cs files (excluding obj\ and bin\),
    detects duplicate assembly attributes, and offers to:
      - Comment out offending lines (default safe fix), OR
      - Remove the file if it's redundant.

.PARAMETER Path
    Root directory to scan. Defaults to current directory.

.PARAMETER Mode
    'Comment' (default) comments offending lines.
    'Delete' deletes AssemblyInfo.cs if it only contains attributes/usings.
    'Report' just reports; no changes.

.PARAMETER NoPrompt
    If set, performs the chosen Mode without asking per file.

.PARAMETER DisableGenerate
    If set, inserts <GenerateAssemblyInfo>false</GenerateAssemblyInfo> into each .csproj
    that had a user AssemblyInfo.cs file (use only if you want to manage attributes manually).

.EXAMPLE
    .\Fix-AssemblyInfo.ps1 -Mode Comment

.EXAMPLE
    .\Fix-AssemblyInfo.ps1 -Mode Delete -NoPrompt
#>

param(
    [string]$Path = (Get-Location).Path,
    [ValidateSet('Report','Comment','Delete')]
    [string]$Mode = 'Comment',
    [switch]$NoPrompt,
    [switch]$DisableGenerate
)

Write-Host "🔍 Scanning for AssemblyInfo.cs under: $Path" -ForegroundColor Cyan

# Patterns of attributes that cause duplicates
$dupPatterns = @(
    '[assembly:\s*AssemblyVersion',
    '[assembly:\s*AssemblyFileVersion',
    '[assembly:\s*AssemblyInformationalVersion'
)

# Gather all AssemblyInfo.cs outside obj/bin
$assemblyInfoFiles = Get-ChildItem -Path $Path -Recurse -Filter AssemblyInfo.cs |
    Where-Object { $_.FullName -notmatch '\\obj\\' -and $_.FullName -notmatch '\\bin\\' }

if (-not $assemblyInfoFiles) {
    Write-Host "✅ No user AssemblyInfo.cs files found. Nothing to fix." -ForegroundColor Green
    return
}

Write-Host "📄 Found $($assemblyInfoFiles.Count) candidate AssemblyInfo.cs file(s)."

# Helper: detect if file contains duplicate-causing attributes
function Test-HasDupAttributes {
    param([string]$Content)
    foreach ($pat in $dupPatterns) {
        if ($Content -match $pat) { return $true }
    }
    return $false
}

# Track projects that need GenerateAssemblyInfo disabled
$projectsNeedingDisable = [System.Collections.Generic.List[string]]::new()

foreach ($file in $assemblyInfoFiles) {
    Write-Host "`n─── File: $($file.FullName)" -ForegroundColor Yellow
    $content = Get-Content -Raw -Path $file.FullName

    $hasDup = Test-HasDupAttributes -Content $content
    if (-not $hasDup) {
        Write-Host "   ⚪ No duplicate version attributes found. Skipping." 
        continue
    }

    Write-Host "   ❌ Duplicate version attributes detected."

    # Find owning .csproj (closest parent)
    $proj = Get-ChildItem -Path $file.Directory.FullName -Filter *.csproj -File |
        Select-Object -First 1
    if (-not $proj) {
        # Walk up directories
        $dir = $file.Directory
        while (-not $proj -and $dir.Parent) {
            $dir = $dir.Parent
            $proj = Get-ChildItem -Path $dir.FullName -Filter *.csproj -File | Select-Object -First 1
        }
    }
    if ($proj) {
        Write-Host "   📌 Associated project: $($proj.Name)"
        $projectsNeedingDisable.Add($proj.FullName) | Out-Null
    } else {
        Write-Host "   ⚠️ Could not locate owning .csproj."
    }

    if ($Mode -eq 'Report') { continue }

    $doFix = $true
    if (-not $NoPrompt) {
        $resp = Read-Host "   Fix this file? (Y/n)"
        if ($resp -and $resp.ToLower() -ne 'y') { $doFix = $false }
    }
    if (-not $doFix) { continue }

    switch ($Mode) {
        'Comment' {
            Write-Host "   ✏️ Commenting duplicate attributes..."
            $lines = Get-Content -Path $file.FullName
            $changed = $false
            for ($i=0; $i -lt $lines.Count; $i++) {
                foreach ($pat in $dupPatterns) {
                    if ($lines[$i] -match $pat) {
                        if ($lines[$i] -notmatch '^\s*//') {
                            $lines[$i] = '// ' + $lines[$i]
                            $changed = $true
                        }
                        break
                    }
                }
            }
            if ($changed) {
                Set-Content -Path $file.FullName -Value $lines -Encoding UTF8
                Write-Host "   ✅ Updated: $($file.Name)"
            } else {
                Write-Host "   ℹ️ Nothing changed; attributes were already commented."
            }
        }
        'Delete' {
            # If file contains ONLY using/attrs/comments/whitespace, safe to delete
            $trimmed = ($content -split "`r?`n") | Where-Object { $_.Trim() -ne '' }
            if ($trimmed.Count -le 10 -and ($trimmed -join '') -notmatch 'class|namespace') {
                Write-Host "   🗑 Removing file (lightweight AssemblyInfo)."
                Remove-Item -Path $file.FullName -Force
            } else {
                Write-Host "   ⚠️ File not empty/simple; commenting instead."
                $Mode = 'Comment'
                # Re-run comment block inline
                $lines = Get-Content -Path $file.FullName
                for ($i=0; $i -lt $lines.Count; $i++) {
                    foreach ($pat in $dupPatterns) {
                        if ($lines[$i] -match $pat) {
                            if ($lines[$i] -notmatch '^\s*//') {
                                $lines[$i] = '// ' + $lines[$i]
                            }
                            break
                        }
                    }
                }
                Set-Content -Path $file.FullName -Value $lines -Encoding UTF8
                Write-Host "   ✅ Attributes commented instead of delete."
            }
        }
    }
}

# Optional: disable auto assembly info generation in affected projects
if ($DisableGenerate -and $projectsNeedingDisable.Count -gt 0) {
    Write-Host "`n⚙️ Disabling <GenerateAssemblyInfo> in affected projects..."
    $unique = $projectsNeedingDisable | Sort-Object -Unique
    foreach ($projPath in $unique) {
        [xml]$xml = Get-Content -Path $projPath
        $ns = $xml.Project.NamespaceURI
        $mgr = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
        if ($ns) { $mgr.AddNamespace('ns',$ns) }

        $propGroup = if ($ns) {
            $xml.Project.SelectSingleNode('ns:PropertyGroup[1]',$mgr)
        } else {
            $xml.Project.PropertyGroup[0]
        }

        if (-not $propGroup) {
            $propGroup = $xml.CreateElement('PropertyGroup',$ns)
            [void]$xml.Project.AppendChild($propGroup)
        }

        $node = if ($ns) {
            $propGroup.SelectSingleNode('ns:GenerateAssemblyInfo',$mgr)
        } else {
            $propGroup.GenerateAssemblyInfo
        }

        if (-not $node) {
            $node = $xml.CreateElement('GenerateAssemblyInfo',$ns)
            $node.InnerText = 'false'
            [void]$propGroup.AppendChild($node)
            $xml.Save($projPath)
            Write-Host "   ✏️ Updated $projPath (GenerateAssemblyInfo=false)"
        } elseif ($node.InnerText -ne 'false') {
            $node.InnerText = 'false'
            $xml.Save($projPath)
            Write-Host "   ✏️ Updated $projPath (GenerateAssemblyInfo=false)"
        } else {
            Write-Host "   ℹ️ Already disabled: $projPath"
        }
    }
}

Write-Host "`n🎯 Scan & fix complete." -ForegroundColor Green

