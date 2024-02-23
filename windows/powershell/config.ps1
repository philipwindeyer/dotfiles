#!/usr/bin/env pwsh

# Note: this is sourced/invoked from $PROFILE

. $PSScriptRoot\aliases.ps1

$Env:Path += [IO.Path]::PathSeparator + "C:\Program Files\Git\usr\bin"
$Env:Path += [IO.Path]::PathSeparator + "C:\Program Files\Git\bin"
$Env:Path += [IO.Path]::PathSeparator + "C:\Program Files\Git\cmd"

$Env:PERSONAL_SERVER = 'Add `$Env:PERSONAL_SERVER = "<username>@<your-personal-server-address-here-if-you-have-one>"` to your powershell profile'
$Env:PERSONAL_SERVER_KEY = 'Add `$Env:PERSONAL_SERVER_KEY = "/path/to/your/personal/server/key/file"` to your powershell profile'
