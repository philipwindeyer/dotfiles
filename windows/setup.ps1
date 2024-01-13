#!/usr/bin/env pwsh

# Setup and Maintenance script for Windows 11

$IS_ADMIN = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

if ($IS_ADMIN -eq $false) { 
  Write-Output "Run as administrator"
  exit
}

Function Log-Heading {
  Write-Output "`n=================================================="
  Write-Output "  $Args"
  Write-Output "==================================================`n"
}

Function Log-Msg {
  Write-Output "  $Args`n"
}

Function Load-ReloadEnv {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
  . $PROFILE
}

Function Del-WinPkg {
  winget list $Args > $null

  if ($? -eq $true) { 
    winget uninstall --purge $Args
  } else {
    Write-Output "$Args already uninstalled"
  }
}

Function Get-WinPkg {
  winget list $Args > $null

  if ($? -eq $false) { 
    winget install -s winget --accept-package-agreements $Args
  } else {
    Write-Output "$Args already installed"
  }
}

Function Get-MsStorePkg {
  winget list $Args > $null

  if ($? -eq $false) { 
    winget install -s msstore --accept-package-agreements $Args
  } else {
    Write-Output "$Args already installed"
  }
}

Function Get-ChocoPkg {
  $Is_Present = (choco list -r $Args)

  if ($Is_Present -eq $null) { 
    choco install -y $Args
  } else {
    Write-Output "$Args already installed"
  }
}

Log-Heading "Windows 11 Setup Script"
Log-Msg "Work in progress (see notes and TODOs within)"

Log-Heading "Uninstalling bloatware"
Del-WinPkg Microsoft.Teams
Del-WinPkg Microsoft.OneDrive
Del-WinPkg Microsoft.OneDriveSync_8wekyb3d8bbwe
Load-ReloadEnv

Log-Heading "Installing winget packages"
Get-WinPkg Microsoft.DotNet.Runtime.8
Get-WinPkg Microsoft.DotNet.DesktopRuntime.8
Get-WinPkg Git.Git
Get-WinPkg Chocolatey.Chocolatey
Get-WinPkg AutoHotkey.AutoHotkey
Get-WinPkg StrawberryPerl.StrawberryPerl
Get-WinPkg Python.Python.3.12
Get-WinPkg Google.GoogleDrive
Get-WinPkg KeeWeb.KeeWeb
Get-WinPkg Google.Chrome
Get-WinPkg Notion.Notion
Get-WinPkg NordSecurity.NordVPN
Get-WinPkg NordSecurity.NordPass
Get-WinPkg Valve.Steam
Get-WinPkg Discord.Discord
Get-WinPkg Spotify.Spotify
Get-WinPkg SlackTechnologies.Slack
Get-WinPkg Microsoft.VisualStudioCode
Get-WinPkg SublimeHQ.SublimeText.4
Get-WinPkg VideoLAN.VLC
Get-WinPkg Keybase.Keybase
Get-WinPkg OpenWhisperSystems.Signal
Get-WinPkg Dropbox.Dropbox
Get-WinPkg JGraph.Draw
Get-WinPkg Microsoft.Skype
Get-WinPkg Zoom.Zoom
Get-WinPkg Balena.Etcher
Get-WinPkg Ryochan7.DS4Windows
Get-WinPkg stenzek.DuckStation
Get-WinPkg Brave.Brave
Get-WinPkg CoreyButler.NVMforWindows
Get-WinPkg Yarn.Yarn

Log-Heading "Installing Microsoft Store (msstore) packages"
Get-MsStorePkg Trello
Get-MsStorePkg Instagram
Get-MsStorePkg Facebook
Get-MsStorePkg PowerToys
Get-MsStorePkg iTunes

Log-Heading "Installing Microsoft Store (msstore) packages (for outdated or `"Installer hash does not match`" winget packages)"
Get-MsStorePkg WhatsApp

Log-Heading "Installing Chocolatey packages"
Load-ReloadEnv
Get-ChocoPkg mac-precision-touchpad
Get-ChocoPkg ocenaudio

Log-Heading "Installing Chocolatey packages (for outdated or `"Installer hash does not match`" winget packages)"
Get-ChocoPkg messenger
Get-ChocoPkg ClickUp-Official

Log-Heading "Keep all packages up to date"
winget upgrade --include-unknown --all --accept-package-agreements
choco upgrade -y all

Log-Heading "Keep Windows up to date"
UsoClient ScanInstallWait

Log-Heading "Install node and set global node version"
Load-ReloadEnv
$NODE_VERSION_TO_INSTALL="21.5.0" # as of 5/1/24
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
} else {
  Write-Output "PowerShell default profile already configured"
}

if (!(Test-Path -Path $VSCODE_PROFILE)) { 
  Write-Output ". $PROFILE" | Out-File $VSCODE_PROFILE -Append
} else {
  Write-Output "PowerShell VS Code profile already configured"
}

Load-ReloadEnv
