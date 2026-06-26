################################################################################
# Pre-requisites                                                               #
################################################################################
# Run `Set-ExecutionPolicy Unrestricted` as Administrator

$samsung = (Get-CimInstance -ClassName Win32_ComputerSystem).Manufacturer -match "samsung"

function InstallWingetPkg {
  param (
    [Parameter(Mandatory=$true)]
    [string]$appId,
    [Parameter(Mandatory=$false)]
    [string]$appName,
    [Parameter(Mandatory=$false)]
    [string]$source = "winget"
  )
  if (-not $appName) {
    $appName = $appId
  }

  $null = winget list --id $appId --exact 2>$null
  if ($LASTEXITCODE -eq 0) {
    Write-Host "$appName is already installed."
  } else {
    Write-Host "Installing $appName..."
    winget install $appId --source $source --silent --accept-source-agreements --accept-package-agreements
    if ($LASTEXITCODE -eq 0) {
      Write-Host "$appName is successfully installed."
    } else {
      Write-Host "Encountered an error during $appName installation. Error code: $LASTEXITCODE."
    }
  }
}

InstallWingetPkg("Git.Git")
InstallWingetPkg("Microsoft.PowerToys")
InstallWingetPkg("voidtools.Everything")
InstallWingetPkg("Notepad++.Notepad++")
InstallWingetPkg("Neovim.Neovim")
InstallWingetPkg("Bandisoft.Bandizip")
if ($samsung) {
  InstallWingetPkg -appName "Samsung Update" -appId 9NQ3HDB99VBF -source msstore
}

Write-Host "`nPress any key to close:"
$null = [System.Console]::ReadKey($true)

