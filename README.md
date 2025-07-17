# BlogManager Clean Architecture Starter

## 📌 Introduction  
This PowerShell script helps you quickly create a 5-layer Clean Architecture project structure in .NET Core within seconds.  
It automatically sets up projects, references, folders, base classes, and essential NuGet packages to give you a solid starting point for your application.

---

## 🚀 Features  
- Creates projects for **IOC, Domain, Data, Core** layers and the main solution project  
- Automatically configures project references (reference chain)  
- Installs necessary NuGet packages like Entity Framework Core and ASP.NET Core packages  
- Generates folder structure and base classes such as `BaseEntity`, `DbContext`, and `Paging`  
- Clean, scalable folder organization  
- Supports .NET 9.0 stable version  
- Easy and fast execution via a single PowerShell command

---

## 🎯 Prerequisites  
- [.NET SDK 9.0](https://dotnet.microsoft.com/en-us/download/dotnet/9.0)  
- PowerShell (version 5 or higher)  
- Windows OS (other OS support possible with script modification)

---

## 🧑‍💻 How to Use

1. Prepare your solution folder with the `.sln` file in place.  
2. Save the PowerShell script (e.g., `Setup-CleanArch.ps1`) in the solution folder.  
3. Open PowerShell and navigate to the solution folder.  
4. Run the script:

```powershell
.\Setup-CleanArch.ps1


5.Watch as projects, folders, and packages are created and installed.
📂 Output Project Structure
SolutionName/
├── SolutionName.sln
├── SolutionName.Core/
├── SolutionName.Data/
│   ├── Context/
│   │   └── SolutionNameContext.cs
│   ├── Repositories/
├── SolutionName.Domain/
│   ├── Interfaces/
│   ├── Enums/
│   ├── Models/
│   │   └── Common/
│   │       └── BaseEntity.cs
│   ├── ViewModels/
│       └── Common/
│           └── Paging.cs
├── SolutionName.IOC/

📦 Installed NuGet Packages
| Layer  | Packages                                                                     |
| ------ | ---------------------------------------------------------------------------- |
| Data   | Microsoft.EntityFrameworkCore.SqlServer, Microsoft.EntityFrameworkCore.Tools |
| Domain | Microsoft.AspNetCore.Http, Microsoft.EntityFrameworkCore                     |
| Core   | Microsoft.AspNetCore.Mvc.Razor                                               |

✍️ Customization
You can modify the script as needed to add new layers, folders, base classes, or install additional packages.

🛠️ Support and Contribution
If you have suggestions, issues, or questions, please open an issue in the repository.
Your contributions to improve this project are always welcome!

