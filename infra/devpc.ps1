$UserName = "adminuser"

Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

try {
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
} catch {
    Write-Host "Failed to install Chocolatey" -ForegroundColor Red
}

try {
    choco install azd dotnet-sdk python git vscode azure-cli -y
} catch {
    Write-Host "Failed to install some packages via Chocolatey" -ForegroundColor Red
}

$dockerUrl = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
$installerPath = "C:\TEMP\DockerDesktopInstaller1.exe"

try {
New-Item -ItemType Directory -Path "C:\TEMP" -Force
} catch {
    Write-Host "Failed to create temp folder" -ForegroundColor Red
}


try {
    Start-BitsTransfer -Source $dockerUrl -Destination $installerPath
} catch {
    Write-Host "Failed to download Docker Desktop Installer" -ForegroundColor Red
}

try {
    Start-Process -FilePath $installerPath -ArgumentList "install --quiet --norestart" -Wait -NoNewWindow
} catch {
    Write-Host "Failed to install Docker Desktop" -ForegroundColor Red
}

$CurrentUser = "$env:USERDOMAIN\$env:USERNAME"

try {
    Add-LocalGroupMember -Group "docker-users" -Member $CurrentUser
} catch {
    Write-Host "Failed to add user to docker-users group" -ForegroundColor Red
}
