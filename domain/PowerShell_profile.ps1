Set-Alias -name npp -value 'C:\Program Files (x86)\Notepad++\notepad++.exe'
#Import-Module "C:\Users\irit\Sources\Internal\utilities\Windows\git-prompt.psm1"
#Import-Module "C:\Users\irit\Sources\Internal\utilities\Windows\VirtualEnvUtils.psm1"

Set-ExecutionPolicy Unrestricted -Scope CurrentUser
$sources_target="D:\UserData\$ENV:UserName\Sources"
New-Item -ItemType directory -Path $sources_target
cmd /c mklink /j "$ENV:USERPROFILE\Sources" $sources_target

function prompt
{
    Write-VirtenvPrompt "DarkCyan"
    Write-Host $pwd -NoNewline
    write-GitPrompt
    Write-Host ">" -NoNewline
    " "
}
Set-Alias -name Activate-Virtenv -Value Enable-Virtenv

# Use PSReadLine
Import-Module PSReadline
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

