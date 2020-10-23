function get-gitstatus { git status }
function get-gitcommit { git commit }
function get-gitcheckout { git checkout }
function get-gitadd { git add }
function get-gitdiff { git diff }
function get-gitbranch { git branch }


Set-Alias -Name gst -Value get-gitstatus
Set-Alias -Name gco -Value get-gitcommit
Set-Alias -Name gch -Value get-gitcheckout
Set-Alias -Name ga -Value get-gitadd
Set-Alias -Name gd -Value get-gitdiff
Set-Alias -Name gb -Value get-gitbranch
