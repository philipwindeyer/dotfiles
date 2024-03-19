#!/usr/bin/env pwsh

# Note: this is sourced/invoked from $PROFILE

. $PSScriptRoot\aliases.ps1

$Env:Path += [IO.Path]::PathSeparator + "C:\Program Files\Git\usr\bin"
$Env:Path += [IO.Path]::PathSeparator + "C:\Program Files\Git\bin"
$Env:Path += [IO.Path]::PathSeparator + "C:\Program Files\Git\cmd"

$env:PYTHONIOENCODING = "utf-8"
Invoke-Expression "$(thefuck --alias)"
