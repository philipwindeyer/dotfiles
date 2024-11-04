#!/usr/bin/env pwsh

# Setup and Maintenance script for Windows 11

$IS_ADMIN = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

if ($IS_ADMIN -eq $false) { 
  Write-Output "Run as administrator"
  exit
}

. $PSScriptRoot\lib\setup-fns.ps1

Write-Heading "Windows 11 Setup Script"

Write-Heading "Uninstalling bloatware"
ForEach ($Line in Get-Content $PSScriptRoot\lib\bloatware.txt) {
  Remove-WinPkg $Line
}
Invoke-ReloadEnv

Write-Heading "Installing winget packages"
ForEach ($Line in Get-Content $PSScriptRoot\lib\winget-pkgs.txt) {
  Get-WinPkg $Line
}

Write-Heading "Installing Microsoft Store (msstore) packages"
ForEach ($Line in Get-Content $PSScriptRoot\lib\msstore-pkgs.txt) {
  Get-MsStorePkg $Line
}

Write-Heading "Installing Microsoft Store (msstore) packages (for outdated or `"Installer hash does not match`" winget packages)"
ForEach ($Line in Get-Content $PSScriptRoot\lib\msstore-fallback-pkgs.txt) {
  Get-MsStorePkg $Line
}

Write-Heading "Pinning / Version-locking winget packages"
ForEach ($Line in Get-Content $PSScriptRoot\lib\winget-pins.txt) {
  Set-WinPkgPin $Line
}

Write-Heading "Installing Chocolatey packages"
Invoke-ReloadEnv
ForEach ($Line in Get-Content $PSScriptRoot\lib\choco-pkgs.txt) {
  Get-ChocoPkg $Line
}

Write-Heading "Installing Chocolatey packages (for outdated or `"Installer hash does not match`" winget packages)"
ForEach ($Line in Get-Content $PSScriptRoot\lib\choco-fallback-pkgs.txt) {
  Get-ChocoPkg $Line
}

Write-Heading "Installing Apple Magic Keyboard 2 drivers (ensures the volume, media, brightness, and fn keys function as expected for my setup)"
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

Write-Heading "Installing kinto.sh (for mac keymaps)"
if (Test-Path -Path $HOME\.kinto) {
  Write-Output "kinto.sh already installed"
}
else {
  Write-Message "Note: you will be prompted to choose a keyboard type. Select 1 for Mac"
  Set-ExecutionPolicy Bypass -Scope Process -Force
  Invoke-WebRequest https://raw.githubusercontent.com/rbreaves/kinto/master/install/windows.ps1 -UseBasicParsing | Invoke-Expression
  cmd /c "explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}"
  Write-Message "You'll notice a kinto-master directory in ~/Downloads. You may delete this after the next restart"
  # Note: the kinto.sh installation script sets location to ~/Downloads during it's execution
  Set-Location .\..
  Remove-Item -Force kinto.zip
  Set-Location $PSScriptRoot
}

Write-Heading "Keep all packages up to date"
winget upgrade --include-unknown --all --accept-package-agreements
choco upgrade -y all

Write-Heading "Keep Windows up to date"
UsoClient ScanInstallWait

Write-Heading "Install node and set global node version"
Invoke-ReloadEnv
$NODE_VERSION_TO_INSTALL = "21.5.0" # as of 5/1/24
nvm install $NODE_VERSION_TO_INSTALL
nvm use $NODE_VERSION_TO_INSTALL

Write-Heading "Add shortcuts to home directory (triggerable via Start Menu)"
Write-Message "Kinto.sh"
Copy-Item -Force .\lib\helpers\kinto-start.vbs.lnk $HOME

Write-Message "work-environment, sleep, and lock-screen"
Copy-Item -Force .\lib\helpers\*.bat $HOME

Write-Heading "Link PowerShell profile to ./powershell/config.ps1"
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

Invoke-ReloadEnv

Write-Heading "Installing pip packages"
ForEach ($Line in Get-Content $PSScriptRoot\lib\pip-pkgs.txt) {
  Get-PipPkg $Line
}

Invoke-ReloadEnv

Write-Heading "Installing local LLMs (ollama)"
ForEach ($Line in Get-Content $PSScriptRoot\lib\ollama-llms.txt) {
  Get-OllamaLlm $Line
}

Write-Heading "Installing rbenv for Windows"
$env:RBENV_ROOT = "C:\Ruby-on-Windows"
Invoke-WebRequest -useb "https://github.com/RubyMetric/rbenv-for-windows/raw/main/tool/install.ps1" | Invoke-Expression
Invoke-ReloadEnv

Write-Heading "Installing Ruby 3.0.0-1"
rbenv install 3.0.0-1-with-devkit
rbenv global 3.0.0-1

Write-Heading "Install WSL and Ubuntu"
wsl --install Ubuntu
wsl --set-default-version 2

Write-Message 'Note: you will need to restart your computer after the WSL installation, for the installation to complete'
Write-Message 'IMPORTANT: WSL requires virtualization to be enabled in the BIOS. If you encounter an error, you may need to enable virtualization in the BIOS settings ("SVM Mode" for AMD, "VT-x" for Intel)'

Write-Heading 'Almost there!'
Write-Message 'If this is the first time running this script, you will need to restart your computer for everything to complete, then either run setup.ps1 again, or "wsl ./setup-wsl.sh" directly'
Write-Message "Btw, if you're having trouble finding the setup-wsl.sh script in WSL, it's located at /mnt/c/Users/$env:USERNAME/<wherever-you-checked-out-this-repo>/setup-wsl.sh"
wsl ./setup-wsl.sh

Write-Heading "Done!"
