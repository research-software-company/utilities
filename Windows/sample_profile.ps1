Set-Alias -name npp -value 'C:\Program Files (x86)\Notepad++\notepad++.exe'
Import-Module "c:\sources\internal\utilities\windows\git-prompt.psm1"
Import-Module "c:\sources\internal\utilities\windows\VirtualEnvUtils.psm1"
Import-Module "c:\sources\internal\utilities\windows\ChooseVS.psm1"

function prompt
{
    Write-VSPrompt "DarkGreen"
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

