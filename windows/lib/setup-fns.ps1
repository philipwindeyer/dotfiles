#!/usr/bin/env pwsh

# Note: this is sourced from ../setup.ps1

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
