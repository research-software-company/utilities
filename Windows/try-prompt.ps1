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
        $match = (Select-String -Path $activate_path -Pattern 'set "PROMPT=(.*)\s%PROMPT%"')
        if(! $match )
        {
            $match = (Select-String -Path $activate_path -Pattern 'set PROMPT=(.*)\s%PROMPT%')
        }
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

    # $activate_path = $(get-activate-path)
    $activate_path = "C:\Users\zmbq\sources\Personal\AdventOfCode\env\Scripts\activate.bat"
    if($activate_path)
    {
        $prompt = $(get-prompt $activate_path)
        Write-Host $prompt -ForegroundColor $color -NoNewline
    }
}

Write-VirtenvPrompt