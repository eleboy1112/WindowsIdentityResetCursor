$ErrorActionPreference = "Stop"

function GenerateRandomName {
    $adjectives = @("Swift", "Rapid", "Azure", "Silent", "Golden", "Noble", "Stellar", "Phantom", "Mystic", "Royal")
    $nouns = @("Fox", "Hawk", "Dragon", "Wolf", "Eagle", "Tiger", "Phoenix", "Knight", "Ranger", "Voyager")
    
    $randomAdjective = $adjectives | Get-Random
    $randomNoun = $nouns | Get-Random
    $randomNumber = Get-Random -Minimum 100 -Maximum 999
    
    return "$randomAdjective$randomNoun$randomNumber"
}

function RequireAdminRights {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    
    if (-not $isAdmin) {
        Write-Host "Admin rights required!"
        Write-Host "Please run script as administrator."
        exit 1
    }
}

function BackupSettings {
    $backupPath = "$env:USERPROFILE\Desktop\SystemBackup_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    
    $currentComputerName = $env:COMPUTERNAME
    $currentMachineGuid = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Cryptography' -Name 'MachineGuid').MachineGuid
    
    "Current computer name: $currentComputerName" | Out-File -FilePath $backupPath
    "Current MachineGuid: $currentMachineGuid" | Out-File -FilePath $backupPath -Append
    
    Write-Host "Backup saved to: $backupPath"
}

function ChangeMachineIdentity {
    $newComputerName = GenerateRandomName
    $newMachineGuid = [guid]::NewGuid().ToString()
    
    Write-Host "Changing computer name to: $newComputerName"
    Rename-Computer -NewName $newComputerName -Force
    
    Write-Host "Updating MachineGuid in registry..."
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Cryptography' -Name 'MachineGuid' -Value $newMachineGuid
    
    Write-Host "Clearing CAPI identifiers..."
    Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\Cryptography\PCMM\MachineKeys' -Recurse -Force -ErrorAction SilentlyContinue
    
    Write-Host "Clearing Windows event logs..."
    wevtutil cl System
    wevtutil cl Application
    wevtutil cl Security
    
    Write-Host "Flushing DNS cache..."
    ipconfig /flushdns
    
    Write-Host "Clearing browser caches..."
    Remove-Item "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
    
    Write-Host "Resetting network settings..."
    netsh winsock reset
    netsh int ip reset
}

function ClearCursorData {
    Write-Host "Clearing Cursor IDE identifiers..."
    
    $cursorDataPath = "$env:APPDATA\Cursor"
    $cursorBackupPath = "$env:USERPROFILE\Desktop\CursorBackup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    
    if (Test-Path $cursorDataPath) {
        New-Item -Path $cursorBackupPath -ItemType Directory -Force | Out-Null
        Copy-Item -Path "$cursorDataPath\*" -Destination $cursorBackupPath -Recurse -Force
        
        Remove-Item -Path "$cursorDataPath\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$cursorDataPath\Session Storage\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$cursorDataPath\Local Storage\leveldb\*" -Recurse -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "$cursorDataPath\IndexedDB\*" -Recurse -Force -ErrorAction SilentlyContinue
        
        Write-Host "Cursor data backup saved to: $cursorBackupPath"
    }
    
    $cursorRegPath = "HKCU:\Software\Cursor"
    if (Test-Path $cursorRegPath) {
        Remove-Item -Path $cursorRegPath -Recurse -Force -ErrorAction SilentlyContinue
    }
}

function CleanTempFiles {
    Write-Host "Cleaning temp files..."
    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
}

try {
    RequireAdminRights
    BackupSettings
    ChangeMachineIdentity
    ClearCursorData
    CleanTempFiles
    
    Write-Host "Operation completed successfully!" -ForegroundColor Green
    Write-Host "Restart computer to apply all changes." -ForegroundColor Yellow
    
    $restart = Read-Host "Restart computer now? (y/n)"
    if ($restart -eq 'y') {
        Restart-Computer -Force
    }
} 
catch {
    Write-Host "Error occurred: $_" -ForegroundColor Red
    Write-Host "Try running script as administrator." -ForegroundColor Red
}