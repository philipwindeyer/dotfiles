#!/usr/bin/env pwsh

# Setup and Maintenance script for Windows 11


# TODO check that script is being run as Administrator before proceeding

# Uninstall bloatware
winget uninstall Microsoft.Teams
winget uninstall Microsoft.OneDrive

# Install packages (winget)
winget install Microsoft.DotNet.Runtime.8
winget install Microsoft.DotNet.DesktopRuntime.8
winget install Git.Git
winget install Chocolatey.Chocolatey
winget install AutoHotkey.AutoHotkey
winget install StrawberryPerl.StrawberryPerl
winget install Python.Python.3.12
winget install Google.GoogleDrive
winget install KeeWeb.KeeWeb
winget install Google.Chrome
winget install Notion.Notion
winget install Valve.Steam
winget install Discord.Discord
winget install Spotify.Spotify
winget install SlackTechnologies.Slack
winget install Facebook.Messenger
winget install Microsoft.VisualStudioCode
winget install SublimeHQ.SublimeText.4
winget install VideoLAN.VLC
winget install Keybase.Keybase
winget install OpenWhisperSystems.Signal
winget install Dropbox.Dropbox
winget install JGraph.Draw
winget install Microsoft.Skype
winget install Zoom.Zoom
winget install Balena.Etcher
winget install Ryochan7.DS4Windows
winget install stenzek.DuckStation
winget install Brave.Brave
winget install CoreyButler.NVMforWindows
winget install Yarn.Yarn

# Install packages (msstore)
winget install Trello -s msstore --accept-package-agreements
winget install Instagram -s msstore --accept-package-agreements
winget install Facebook -s msstore --accept-package-agreements
winget install PowerToys -s msstore --accept-package-agreements
winget install iTunes -s msstore --accept-package-agreements
winget install "Windows Subsystem for Linux" -s msstore --accept-package-agreements

# Install packages (chocolatey)
choco install mac-precision-touchpad -y
choco install ocenaudio -y

# Install packages (from chocolatey where winget version is outdated or "Installer hash does not match")
choco install messenger -y
choco install ClickUp-Official -y

# Install packages (from mssrote where winget version is outdated or "Installer hash does not match")
winget install WhatsApp -s msstore --accept-package-agreements

# Install packages manually (where no package managed versions were installable)
# TODO print friendly instructions guiding how to do this
# nordvpn
# nordpass

# Keep packages up to date
winget upgrade --include-unknown --all --accept-package-agreements
choco upgrade -y all

# TODO Can trigger Windows update from command line?

# Note: can potentially ditch entirely, for now (running node and bash in win11 directly)
wsl --install Ubuntu

# Run Windows Update
UsoClient ScanInstallWait

# TODO: Generate a kinto-start.vbs shortcut and move to home directory (so it can be searched and triggered from Start Menu)

# Need to refetch profile OR reload env somehow before running nvm (not on path in same shell session)
nvm install 21.5.0 # as of 5/1/24
nvm use 21.5.0

if (!(Test-Path -Path $PROFILE)) {
  New-Item -ItemType File -Path $PROFILE -Force
  Write-Output ". $PSScriptRoot\powershell\config.ps1" | Out-File $PROFILE -Append
}
