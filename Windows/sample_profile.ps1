Set-Alias -name npp -value 'C:\Program Files (x86)\Notepad++\notepad++.exe'
Import-Module -Force "d:\chelem\internal\utilities\windows\git-prompt.psm1"
Import-Module -Force -DisableNameChecking "d:\chelem\internal\utilities\windows\VirtualEnvUtils.psm1"

function prompt
{
    Write-VirtenvPrompt
    Write-Host $pwd -NoNewline
    write-GitPrompt
    Write-Host ">" -NoNewline
    " "
}

Set-Alias -name Activate-Virtenv -Value Enable-Virtenv