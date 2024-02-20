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

Log-Heading "Installing Apple Magic Keyboard 2 drivers (ensures the volume, media, brightness, and fn keys function as expected for my setup)"
# Note: v6.1.7071 is the latest version as of 27/1/24
$AppleMagicKeyboard2Url = "https://github.com/AbsentForeskin/Apple-Input-Device-Drivers-Windows-10-11/releases/download/v6.1.7071/AppleKeyboardMagic2.zip"
$AppleMagicKeyboard2File = "AppleKeyboardMagic2.zip"
Invoke-WebRequest -Uri $AppleMagicKeyboard2Url -OutFile $AppleMagicKeyboard2File
Expand-Archive -Force $AppleMagicKeyboard2File
Set-Location .\AppleKeyboardMagic2\AppleKeyboardMagic2
PNPUtil.exe /add-driver Keymagic2.inf /install
Set-Location .\..\..
Remove-Item -Force -Recurse .\AppleKeyboardMagic2
Remove-Item -Force $AppleMagicKeyboard2File

Log-Heading "Installing kinto.sh (for mac keymaps)"
if (Test-Path -Path $HOME\.kinto) {
  Write-Output "kinto.sh already installed"
}
else {
  Log-Msg "Note: you will be prompted to choose a keyboard type. Select 1 for Mac"
  Set-ExecutionPolicy Bypass -Scope Process -Force
  Invoke-WebRequest https://raw.githubusercontent.com/rbreaves/kinto/master/install/windows.ps1 -UseBasicParsing | Invoke-Expression
  cmd /c "explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}"
  Log-Msg "You'll notice a kinto-master directory in ~/Downloads. You may delete this after the next restart"
  # Note: the kinto.sh installation script sets location to ~/Downloads during it's execution
  Set-Location .\..
  Remove-Item -Force kinto.zip
  Set-Location $PSScriptRoot
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

Log-Heading "Install WSL and Ubuntu"
wsl --install Ubuntu
wsl --set-default-version 2

Log-Msg 'Note: you will need to restart your computer after the WSL installation, for the installation to complete'
Log-Msg 'IMPORTANT: WSL requires virtualization to be enabled in the BIOS. If you encounter an error, you may need to enable virtualization in the BIOS settings ("SVM Mode" for AMD, "VT-x" for Intel)'

Log-Heading 'Almost there!'
Log-Msg 'If this is the first time running this script, you will need to restart your computer for everything to complete, then either run setup.ps1 again, or "wsl ./setup-wsl.sh" directly'
wsl ./setup-wsl.sh

Log-Heading "Done!"
