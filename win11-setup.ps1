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

################################################################################
# Desktop system icons                                                         #
################################################################################
# Document (Home folder)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" -Value 1
# Computer
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" -Value 1
# Trash bin
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{645FF040-5081-101B-9F08-00AA002F954E}" -Value 0
# Network
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" -Value 1
# Control panel
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" -Name "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" -Value 1
# Restart Explorer for immediate update
Stop-Process -Name explorer -Force

################################################################################
# Install softwares                                                            #
################################################################################
InstallWingetPkg("Git.Git")
InstallWingetPkg("Microsoft.PowerToys")
InstallWingetPkg("voidtools.Everything")
InstallWingetPkg("Notepad++.Notepad++")
InstallWingetPkg("Neovim.Neovim")
InstallWingetPkg("Bandisoft.Bandizip")
InstallWingetPkg("Bitwarden.Bitwarden")
InstallWingetPkg("Microsoft.VisualStudioCode")
if ($samsung) {
  InstallWingetPkg -appName "Samsung Update" -appId 9NQ3HDB99VBF -source msstore
  InstallWingetPkg -appName "Samsung Settings 1.5" -appId 9P2TBWSHK6HJ -source msstore
}

Write-Host "`nPress any key to close:"
$null = [System.Console]::ReadKey($true)

