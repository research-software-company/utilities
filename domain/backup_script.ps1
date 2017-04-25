$backupFolder = "U:\Backup\" 
$suffix_to_backup=".ssh","Sources",".Py*"
#$backuped_dirs = New-Object System.Collections.ArrayList

$user_name = Get-ChildItem Env:USERNAME
$user_name = $user_name.value
$logFile = "C:\Users\$user_name\backup_log.txt"
$date = Get-Date

if(!(Test-Path -Path $backupFolder ))
{
    New-Item -ItemType directory -Path $backupFolder
}
if(!(Test-path -Path $logFile))
{
	New-Item -Path "C:\Users\$user_name" -ItemType "file" -Name "backup_log.txt"
}
"################################################"|Add-Content $logFile
$date|Add-Content $logFile
"Started backup process..."| Add-Content $logFile
foreach ($suffix in $suffix_to_backup){
	
	"Copying " + $suffix + " files..."|Add-Content $logFile
	if ($suffix.EndsWith("*"))
	{
		$dirs = Get-ChildItem "$ENV:USERPROFILE\$suffix*"
	}
	Else 
	{		
		$dirs = "$ENV:USERPROFILE\$suffix"
	}

	foreach ($dir in $dirs)
	{
		$base_name = $dir|% {$_.BaseName}
		if  ([string]::IsNullOrEmpty($base_name)) 
		{
			$base_name=$suffix
		}
		"Copied " + $base_name|Add-Content $logFile
		#echo "$dir ,  $base_name"
		Robocopy $dir  $backupFolder\$base_name /MIR /xo /fft  /mt:7 /w:3 /r:3 /nfl /ndl /nc /ns 
		#[void] $backuped_dirs.Add($base_name)
	}
	"Finished copying " + $suffix + " files..."|Add-Content $logFile
}

copy $profile $backupFolder\profile.ps1

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