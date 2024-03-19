#!/usr/bin/env pwsh

# Note: this is sourced from ../setup.ps1

Function Write-Heading {
  Write-Output "`n=================================================="
  Write-Output "  $Args"
  Write-Output "==================================================`n"
}

Function Write-Message {
  Write-Output "  $Args`n"
}

Function Invoke-ReloadEnv {
  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
  . $PROFILE
}

Function Remove-WinPkg {
  winget list $Args > $null

  if ($? -eq $true) { 
    winget uninstall --purge $Args
  }
  else {
    Write-Output "$Args already uninstalled"
  }
}

Function Get-WinPkg {
  winget list $Args > $null

  if ($? -eq $false) { 
    winget install -s winget --accept-package-agreements $Args
  }
  else {
    Write-Output "$Args already installed"
  }
}

Function Get-MsStorePkg {
  winget list $Args > $null

  if ($? -eq $false) { 
    winget install -s msstore --accept-package-agreements $Args
  }
  else {
    Write-Output "$Args already installed"
  }
}

Function Get-ChocoPkg {
  $Is_Present = (choco list -r $Args)

  if ($null -eq $Is_Present) { 
    choco install -y $Args
  }
  else {
    Write-Output "$Args already installed"
  }
}

Function Get-PipPkg {
  pip show $Args > $null

  if ($? -eq $false) { 
    pip install $Args
  }
  else {
    Write-Output "$Args already installed"
  }
}
