#!/usr/bin/env pwsh

# Setup and Maintenance script for Windows 11


# TODO check that script is being run as Administrator before proceeding

# Uninstall bloatware
winget uninstall Microsoft.Teams

# Install packages (winget)
winget install Microsoft.DotNet.Runtime.8
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
winget install OpenJS.NodeJS
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

# Install packages (from mssrote where winget version is outdated or "Installer hash does not match")
winget install WhatsApp -s msstore --accept-package-agreements

# Install packages manually (where no package managed versions were installable)
# TODO print friendly instructions guiding how to do this
# nordvpn
# nordpass

# Keep packages up to date
winget upgrade --include-unknown --all --accept-package-agreements
# TODO: figure out how to iterate over the list output from the above cmd and upgrade each one individually (is there a PowerShell awk equivalent?)
# Or is there an --all option?
# choco update(?)

# TODO Can trigger msstore update of all apps from command line?
# TODO Can trigger Windows update from command line?

# Note: can potentially ditch entirely, for now (running node and bash in win11 directly)
wsl --install Ubuntu
