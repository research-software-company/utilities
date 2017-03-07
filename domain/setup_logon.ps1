Set-ExecutionPolicy Unrestricted -Scope CurrentUser
$sources_target="D:\UserData\$ENV:UserName\Sources"
New-Item -ItemType directory -Path $sources_target
cmd /c mklink /j "$ENV:USERPROFILE\Sources" $sources_target

net time \\server01 /yes
net use u: \\server01\$ENV:UserName /yes
net use p: \\server01\public /yes