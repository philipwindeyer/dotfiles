function Get-GitStatus { git status }
function Get-GitCommit { git commit }
function Get-GitCheckout { git checkout }
function Get-GitAdd { git add }
function Get-GitDiff { git diff }
function Get-GitBranch { git branch }


Set-Alias -Name gst -Value Get-GitStatus
Set-Alias -Name gco -Value Get-GitCommit
Set-Alias -Name gch -Value Get-GitCheckout
Set-Alias -Name ga -Value Get-GitAdd
Set-Alias -Name gd -Value Get-GitDiff
Set-Alias -Name gb -Value Get-GitBranch
