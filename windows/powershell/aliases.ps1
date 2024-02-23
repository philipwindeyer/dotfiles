#!/usr/bin/env pwsh

Function Get-GitStatus { git status }
Set-Alias -Name gst -Value Get-GitStatus

Function Set-GitCommit { git commit $Args }
Set-Alias -Name gco -Value Set-GitCommit

Function Get-GitCheckout { git checkout $Args }
Set-Alias -Name gch -Value Get-GitCheckout

Function Set-GitAdd { git add $Args }
Set-Alias -Name ga -Value Set-GitAdd

Function Get-GitDiff { git diff $Args }
Set-Alias -Name gd -Value Get-GitDiff

Function Get-GitBranch { git branch $Args }
Set-Alias -Name gb -Value Get-GitBranch

Function Get-FullDir { Get-ChildItem -Force $Args }
Set-Alias -Name ll -Value Get-FullDir

Function Invoke-SSHPersonalServer { ssh -i $PERSONAL_SERVER_KEY $PERSONAL_SERVER }
Set-Alias -Name ssh-personal-server -Value Invoke-SSHPersonalServer

Function Invoke-SSHPersonalServerDBTunnel { ssh -i $PERSONAL_SERVER_KEY -N -L 3336:127.0.0.1:3306 $PERSONAL_SERVER }
Set-Alias -Name ssh-personal-server-db-tunnel -Value Invoke-SSHPersonalServer