


## Developer PC Deployment Script

### Description
This script is designed to deploy a developer PC with all the essential tools required for modern development. The tools that will be installed include:
- .NET SDK
- Python
- Node.js
- Visual Studio Code (VSCode)
- Helm (under construction)
- Git
- Azure CLI
- Azure devloper CLI AZD
- Docker Desktop (under construction)

### Installation Instructions
Follow these steps to deploy the developer PC with the necessary tools:

### Prerequisites

Before proceeding on local pc, ensure you have one of the following environment set up:
- [Azure Developer CLI (AZD)](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd)

You can also use Azure Cloud Shell where AZD is preinstalled
- [Azure Cloud Shell](https://shell.azure.com)

#### Step 1: Clone the Repository
Run the following command to clone the repository:
```bash
git clone https://github.com/koenraadhaedens/AZD-WIN11-DEV-PC-DOCKER
```

#### Step 2: Change Directory
Navigate to the directory created by the git clone command:
```bash
cd AZD-WIN11-DEV-PC-DOCKER
```

#### Step 3: Provision the Environment
Run the following command to provision the environment:
```bash
azd provision
```

### Step 4: Connect to DevPc
Once the above steps are completed (+/- 15 minutes), your developer PC will be equipped with all the necessary tools to start your demo development projects

by default RDP port will be closed. If you have JIT just click the configure button, otherwise add the nsg rule manualy

. Happy coding!
```

