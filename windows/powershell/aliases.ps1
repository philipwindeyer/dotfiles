#!/usr/bin/env pwsh

Function Get-GitStatus { git status }
Set-Alias -Name gst -Value Get-GitStatus

Function Set-GitCommit { git commit }
Set-Alias -Name gco -Value Set-GitCommit

Function Get-GitCheckout { git checkout }
Set-Alias -Name gch -Value Get-GitCheckout

Function Set-GitAdd { git add }
Set-Alias -Name ga -Value Set-GitAdd

Function Get-GitDiff { git diff }
Set-Alias -Name gd -Value Get-GitDiff

Function Get-GitBranch { git branch }
Set-Alias -Name gb -Value Get-GitBranch

Function Get-FullDir { Get-ChildItem -Force }
Set-Alias -Name ll -Value Get-FullDir
