#!/usr/bin/env pwsh

# Setup and Maintenance script for Windows 11

$IS_ADMIN = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

if ($IS_ADMIN -eq $false) { 
  Write-Output "Run as administrator"
  exit
}

. $PSScriptRoot\lib\setup-fns.ps1

Log-Heading "Windows 11 Setup Script"
Log-Msg "Note: this is a work in progress (see notes and TODOs within)"

Log-Heading "Uninstalling bloatware"
ForEach ($Line in Get-Content $PSScriptRoot\lib\bloatware.txt) {
  Del-WinPkg $Line
}
Load-ReloadEnv

Log-Heading "Installing winget packages"
ForEach ($Line in Get-Content $PSScriptRoot\lib\winget-pkgs.txt) {
  Get-WinPkg $Line
}

Log-Heading "Installing Microsoft Store (msstore) packages"
ForEach ($Line in Get-Content $PSScriptRoot\lib\msstore-pkgs.txt) {
  Get-MsStorePkg $Line
}

Log-Heading "Installing Microsoft Store (msstore) packages (for outdated or `"Installer hash does not match`" winget packages)"
ForEach ($Line in Get-Content $PSScriptRoot\lib\msstore-fallback-pkgs.txt) {
  Get-MsStorePkg $Line
}

Log-Heading "Installing Chocolatey packages"
Load-ReloadEnv
ForEach ($Line in Get-Content $PSScriptRoot\lib\choco-pkgs.txt) {
  Get-ChocoPkg $Line
}

Log-Heading "Installing Chocolatey packages (for outdated or `"Installer hash does not match`" winget packages)"
ForEach ($Line in Get-Content $PSScriptRoot\lib\choco-fallback-pkgs.txt) {
  Get-ChocoPkg $Line
}

Log-Heading "Keep all packages up to date"
winget upgrade --include-unknown --all --accept-package-agreements
choco upgrade -y all

Log-Heading "Keep Windows up to date"
UsoClient ScanInstallWait

Log-Heading "Install node and set global node version"
Load-ReloadEnv
$NODE_VERSION_TO_INSTALL = "21.5.0" # as of 5/1/24
nvm install $NODE_VERSION_TO_INSTALL
nvm use $NODE_VERSION_TO_INSTALL

Log-Heading "Add shortcuts to home directory (triggerable via Start Menu)"
Log-Msg "Kinto.sh"
Copy-Item -Force .\lib\helpers\kinto-start.vbs.lnk $HOME

Log-Msg "work-environment, sleep, and lock-screen"
Copy-Item -Force .\lib\helpers\*.bat $HOME

Log-Msg "Add Google Chrome `"Desktop App`" shortcuts to Start Menu"
Copy-Item -Force .\lib\chrome-apps\*.lnk "$HOME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Chrome Apps"

Log-Heading "Link PowerShell profile to ./powershell/config.ps1"
$VSCODE_PROFILE = $PROFILE.Substring(0, $PROFILE.LastIndexOf('\')) + '\Microsoft.VSCode_profile.ps1'

if (!(Test-Path -Path $PROFILE)) {
  New-Item -ItemType File -Path $PROFILE -Force
  Write-Output ". $PSScriptRoot\powershell\config.ps1" | Out-File $PROFILE -Append
}
else {
  Write-Output "PowerShell default profile already configured"
}

if (!(Test-Path -Path $VSCODE_PROFILE)) { 
  Write-Output ". $PROFILE" | Out-File $VSCODE_PROFILE -Append
}
else {
  Write-Output "PowerShell VS Code profile already configured"
}

Load-ReloadEnv

Log-Heading "Done!"