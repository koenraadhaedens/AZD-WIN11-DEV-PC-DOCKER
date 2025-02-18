$UserName = "hacker"

Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
# Invoke-WebRequest https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi -OutFile c:\\wsl_update_x64.msi -UseBasicParsing
# Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile c:\\ubuntu2004.appx




Set-Content -Path c:\\config2.ps1 -Value "`$wsh = New-Object -ComObject Wscript.Shell`r`n`$wsh.Popup('Still Installing some binarys, Press OK to Continue, PC will restart when done',10,'Hang on for a sec')`r`nmsiexec /i c:\wsl_update_x64.msi /qn`r`nsleep 5`r`nwsl --set-default-version 2`r`nAdd-AppxPackage c:\\ubuntu2004.appx`r`nubuntu2004.exe install --root`r`nDisable-ScheduledTask -TaskName install-ubuntu`r`n`$trig = New-ScheduledTaskTrigger -AtLogOn`r`n`$task = New-ScheduledTaskAction -Execute 'C:\Program Files\Docker\Docker\Docker Desktop.exe'`r`nRegister-ScheduledTask -TaskName start-docker -Force -Action `$task -Trigger `$trig -User `$env:USERNAME`r`nchoco install vscode-kubernetes-tools vscode-docker -y --force`r`nRestart-Computer -Force"


New-LocalGroup -Name docker-users -Description "Users of Docker Desktop"
Add-LocalGroupMember -Group 'docker-users' -Member $UserName


Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart 
Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install nodejs azd dotnetcore-sdk python git vscode azure-cli  -y



$trig = New-ScheduledTaskTrigger -AtLogOn 
$task = New-ScheduledTaskAction -Execute powershell.exe -Argument "-File c:\config2.ps1" 
# Register-ScheduledTask -TaskName install-ubuntu -Force -Action $task -Trigger $trig -User $UserName



Restart-Computer -Force


`r`n`$wsh = New-Object -ComObject Wscript.Shell`r`n`$wsh.Popup('Still Installing some binarys, PC will restart in a min',0,'Hang on for a sec')`r`n
