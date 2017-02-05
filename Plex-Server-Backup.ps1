# Shut down the Plex Server and prepare for backup
Stop-Process -force -processname "Plex*"

# Finds 7zip to use in any directory
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"} 
set-alias 7z "$env:ProgramFiles\7-Zip\7z.exe"  

# Variables to use
$date = Get-Date -Format yyyy-MM-dd
$backup = "F:\OneDrive\Backups\Plex Server\"
$backupFolder = $backup + $date + "\"
$backup7z = $backupFolder + "Plex Media Server Backup " + $date + ".7z"
$backupReg = $backupFolder + "Plex Media Server Registry Backup " + $date + ".reg"
$plexServer = "C:\Users\Matthew\AppData\Local\Plex Media Server"
$plexRegistry = "HKEY_CURRENT_USER\SOFTWARE\Plex, Inc.\Plex Media Server"

# Make a new directory for the backup
mkdir $backupFolder

# 7zip backup
# Zip the file / a = 'add' / mx = method and level of compression (9 is the highest or "Ultra" in 7z)
7z a -mx=9 $backup7z $plexServer -xr!Cache

# Export Registry Key
Reg export $plexRegistry $backupReg

# Turn back on the Plex Server
Start-Process -FilePath "C:\Program Files (x86)\Plex\Plex Media Server\Plex Media Server.exe"