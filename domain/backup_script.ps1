$backupFolder = "U:\Backup\" 

$logFile = "~\backup_log.txt"

if(!(Test-Path -Path $backupFolder ))
{
    New-Item -ItemType directory -Path $backupFolder
}
if(!(Test-path -Path $logFile))
{
	New-Item -Path "~" -ItemType "file" -Name "backup_log.txt"
}
"################################################"|Add-Content $logFile
Get-Date | Add-Content $logFile
"Started backup process..."| Add-Content $logFile

Robocopy $ENV:USERPROFILE $backupFolder /MIR /xo /fft  /mt:7 /w:3 /r:3 /nfl /ndl /nc /ns 
"Finished copying files..."|Add-Content $logFile

copy $profile $backupFolder\profile.ps1

"Backup finished" | Add-Content $logFile

# set Sources as link 

#$olddl = get-distributiongroup $ENV:USERPROFILE\Sources
#set-distributiongroup $backupFolder\Sources $olddl

#delete diretories not in $ENV:USERPROFILE from backupFolder\
#$dirs = Get-ChildItem $backupFolder|% {$_.BaseName}
#echo 'DIRS: ' $dirs
#echo 'BACKUPED_DIRS: ' $backuped_dirs
#$dirs_to_delete_from_backend = $dirs | where {$backuped_dirs -notcontains $_}
#echo 'DIRS TO DELETE: ' $dires_to_delete_from_backend
#echo 'Deletes folders from backup that are no longer in source: ' $dirs_to_delete_from_backend
#foreach ($dir in $dirs_to_delete_from_backend){
#	Remove-Item $backupFolder\$dir -Force -Recurse
#}