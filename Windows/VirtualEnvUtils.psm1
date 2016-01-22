<#
 .Synopsis
 Activates a Python Virtual Environment

 .Description
 Activates a Python Virtual Environment without changing the prompt.
 If you want to add the virtualenv to your prompt, call Write-VirtenvPrompt from your prompt function
  

 .Parameter $dir
 The environment's directory (default is env)


 .Example
  Enable-Virtenv
  Activates the virtual env at env

  Enable-Virtenv env35 
  Activates the virtual env at env35\

#>

function Enable-Virtenv($dir = "env")
{
    $function:old_prompt = $function:prompt
    $cmd = $dir+"\scripts\activate.ps1"
    . $cmd

    # The Virtualenv's Powershell prompt is rather useless, so we just restore the previous prompt function.
    set-content function:\prompt $function:old_prompt
}


function Write-VirtenvPrompt($color = "cyan")
{
    function get-activate-path
    {
        $path = (Get-Command python).Source
        $dir = (Get-Item $path).DirectoryName  
        $activate_path = (Join-Path $dir "activate.bat")

        if(Test-Path $activate_path)
        {
            return $activate_path
        }
        else
        {
            return "";
        }
    }

    function get-prompt($activate_path)
    {
        $match = (Select-String -Path $activate_path -Pattern 'set "PROMPT=(.*)%PROMPT%"')
        if(! $match )
        {
            $prompt = "(UnknownEnv)"
        }
        else
        {
            $prompt = $match.Matches[0].Groups[1].Value.Trim() + " "
        }
        
        return $prompt
    }

    $activate_path = $(get-activate-path)
    if($activate_path)
    {
        $prompt = $(get-prompt $activate_path)
        Write-Host $prompt -ForegroundColor $color -NoNewline
    }
}

Export-ModuleMember Enable-Virtenv
Export-ModuleMember Write-VirtenvPrompt