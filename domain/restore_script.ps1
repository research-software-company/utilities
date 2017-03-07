$backupFolder = "U:\Backup\" 
$dirs = Get-ChildItem $backupFolder |% {$_.BaseName}
$source_dir = "$ENV:USERPROFILE\Sources"
#find data dir
#$data_drive_name = GET-WMIOBJECT -query 'SELECT * from win32_logicaldisk where DriveType = "3" AND VolumeName = "Data"' | Select-Object "DeviceID"
if(!(Test-Path -Path $source_dir ))
{
	throw "$source_dir does not exist"
}
$target = Get-Item $source_dir | Select-Object -ExpandProperty Target
if (! $target)
{
	throw "$source_dir is not a link"
}
	
foreach ($dir in $dirs)
{
	#copy to target
	$is_sources=$dir.CompareTo("Sources")
	if ($is_sources -eq 0)
	{
		Robocopy $backupFolder\$dir $target /MIR /xo /fft  /mt:7 /w:3 /r:3 /nfl /ndl /nc /ns 
	} 
	Else
	{	
		Robocopy $backupFolder\$dir $ENV:USERPROFILE\$dir /MIR /xo /fft  /mt:7 /w:3 /r:3 /nfl /ndl /nc /ns 
	}
} 	

$profile_dir = split-path $profile
if (!(Test-Path -Path $profile_dir))
{
	New-Item -ItemType directory -Path $profile_dir
}
copy $backupFolder\profile.ps1 $profile