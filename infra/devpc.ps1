$UserName = "adminuser"
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install nodejs azd dotnet-sdk python git vscode azure-cli  -y
$dockerUrl = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
$installerPath = "$env:TEMP\DockerDesktopInstaller1.exe"
Start-BitsTransfer -Source $dockerUrl -Destination $installerPath
# Install silently
Start-Process -FilePath $installerPath -ArgumentList "install --quiet --norestart" -Wait -NoNewWindow
# Optional: Add current user to docker-users group
$CurrentUser = "$env:USERDOMAIN\$env:USERNAME"
Add-LocalGroupMember -Group "docker-users" -Member $CurrentUser
