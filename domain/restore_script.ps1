$backupFolder = "U:\Backup\" 

$logFile = "~\restore_log.txt"

if(!(Test-Path -Path $backupFolder ))
{
    New-Item -ItemType directory -Path $backupFolder
}
if(!(Test-path -Path $logFile))
{
	New-Item -Path "~" -ItemType "file" -Name "restore_log.txt"
}
"################################################"|Add-Content $logFile
Get-Date | Add-Content $logFile
"Started restore process..."| Add-Content $logFile

Robocopy $backupFolder $ENV:USERPROFILE /MIR /xo /fft  /mt:7 /w:3 /r:3 /nfl /ndl /nc /ns 
"Finished copying files..."|Add-Content $logFile

copy $backupFolder $profile \profile.ps1

"Restore process finished" | Add-Content $logFile