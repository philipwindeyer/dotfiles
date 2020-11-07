#Requires -RunAsAdministrator

$script_path = $MyInvocation.MyCommand.Path
$dir = Split-Path $script_path

Set-Location  

$chocolatey_apps = 'windows/chocolatey.txt'

# TODO Remember to document manually setting "Unrestricted" script runtime access

# add bashrc equivalent
# can I iterate through lines in a file to install/manage choco apps?
# source aliases in bashrc equivalent
# copy-paste the shortcut file for autohotkey into startup items
# match the macos/ubuntu script i guess?
