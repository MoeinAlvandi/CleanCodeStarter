# .NET Solution Setup & AssemblyInfo Fix

This PowerShell script automates the creation of a layered .NET solution architecture and provides tools to fix common AssemblyInfo duplicate attribute issues.

## Features

### 🏗️ Solution Architecture Setup
- **Automatic Project Detection**: Finds existing `.sln` files in the current directory
- **Layered Architecture**: Creates 4 standard layers (IOC, Domain, Data, Core)
- **Project References**: Automatically sets up proper project dependencies
- **NuGet Packages**: Installs essential packages for each layer
- **Folder Structure**: Creates organized folder hierarchy with common patterns

### 🔧 AssemblyInfo Duplicate Fix
- **CS0579 Error Resolution**: Detects and fixes duplicate AssemblyVersion attributes
- **Multiple Fix Modes**: Comment, Delete, or Report-only options
- **Project Integration**: Optionally disables auto-generation in .csproj files
- **Safe Processing**: Excludes obj/ and bin/ directories automatically

## Quick Start

### Basic Setup
```powershell
# Run in your solution directory
.\Setup-Solution.ps1
```

### Fix AssemblyInfo Issues
```powershell
# Comment out duplicate attributes (safest)
.\Fix-AssemblyInfo.ps1 -Mode Comment

# Delete redundant AssemblyInfo files
.\Fix-AssemblyInfo.ps1 -Mode Delete -NoPrompt

# Just report issues without fixing
.\Fix-AssemblyInfo.ps1 -Mode Report
```

## Created Architecture

The script creates a standard layered architecture:

```
YourSolution/
├── YourSolution.sln
├── YourSolution.IOC/
│   ├── DiContainer.cs
│   └── YourSolution.IOC.csproj
├── YourSolution.Domain/
│   ├── Models/
│   │   └── Common/
│   │       └── BaseEntity.cs
│   ├── ViewModels/
│   │   └── Common/
│   │       └── Paging.cs
│   └── YourSolution.Domain.csproj
├── YourSolution.Data/
│   ├── Context/
│   │   └── YourSolutionContext.cs
│   ├── Repositories/
│   └── YourSolution.Data.csproj
└── YourSolution.Core/
    └── YourSolution.Core.csproj
```

## Project Dependencies

The script establishes the following dependency chain:

```
Main Project → IOC → Core → Data → Domain
```

## Installed NuGet Packages

### Data Layer
- `Microsoft.EntityFrameworkCore.SqlServer`
- `Microsoft.EntityFrameworkCore.Tools`

### Domain Layer
- `Microsoft.AspNetCore.Http`
- `Microsoft.EntityFrameworkCore`

### Core Layer
- `Microsoft.AspNetCore.Mvc.Razor`

## AssemblyInfo Fix Parameters

### `-Mode` Options
- **`Comment`** (default): Comments out duplicate attributes with `//`
- **`Delete`**: Removes lightweight AssemblyInfo files entirely
- **`Report`**: Only reports issues without making changes

### Additional Parameters
- **`-Path`**: Specify root directory to scan (defaults to current directory)
- **`-NoPrompt`**: Skip confirmation prompts for batch processing
- **`-DisableGenerate`**: Add `<GenerateAssemblyInfo>false</GenerateAssemblyInfo>` to .csproj files

## Usage Examples

### Setup New Solution
```powershell
# Create new solution structure
.\Setup-Solution.ps1
```

### Fix Existing Issues
```powershell
# Safe fix - comment duplicates
.\Fix-AssemblyInfo.ps1

# Batch delete redundant files
.\Fix-AssemblyInfo.ps1 -Mode Delete -NoPrompt

# Scan specific directory
.\Fix-AssemblyInfo.ps1 -Path "C:\MyProject" -Mode Report

# Disable auto-generation in projects
.\Fix-AssemblyInfo.ps1 -DisableGenerate
```

## What Gets Created

### Base Entity Class
```csharp
public abstract class BaseEntity<T>
{
    public T Id { get; set; }
    public DateTime? LastChangeDate { get; set; }
    public DateTime CreatedDate { get; set; }
    public bool IsDeleted { get; set; }
}
```

### EF Core Context
```csharp
public class YourSolutionContext : DbContext
{
    public YourSolutionContext(DbContextOptions<YourSolutionContext> options) : base(options)
    {
    }
    // DbSets go here
}
```

### DI Container
```csharp
public class DiContainer
{
    // Dependency injection configuration
}
```

## Common Issues Resolved

- ✅ **CS0579**: Duplicate AssemblyVersion attributes
- ✅ **Missing Project References**: Automatically linked
- ✅ **Package Dependencies**: Essential packages installed
- ✅ **Folder Structure**: Consistent organization
- ✅ **EF Core Setup**: Ready-to-use DbContext

## Prerequisites

- .NET 9.0 or later
- PowerShell 5.1 or later
- Existing `.sln` file in the target directory

## Notes

- The script uses `.NET 9.0` as the target framework
- All projects are created as class libraries
- The main project is automatically detected and linked to IOC
- Existing projects and files are preserved (not overwritten)
- The script provides colorful console output for easy tracking

## Error Handling

The script includes robust error handling:
- Validates solution file existence
- Checks for existing projects before creation
- Safely processes AssemblyInfo files
- Excludes build artifacts (obj/, bin/)
- Provides clear status messages

## Contributing

Feel free to modify the script for your specific needs:
- Add more layers to the `$layers` array
- Modify the target framework in `$framework`
- Add additional NuGet packages
- Customize folder structures

## License

This script is provided as-is for educational and development purposes.
