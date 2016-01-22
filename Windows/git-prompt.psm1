<#
 .Synopsis
 Outputs git status to the prompt.

 .Description
 When you call Write-GitPrompt in your prompt function, you will get the current git branch in brackets (if there current directory
 is inside a repository). The branch will be red if there are uncommitted changes, yellow if there are unpushed commits or white
 otherwise.

 The colors can be changed by passing the proper parameters.

 .Parameter $uncommittedColor
 The color of the prompt if there are uncommitted changes. Default is "Red"

 .Parameter $unpushedColor
 The color of the prompt if there are unpushed commits (but no uncommited changes). Default is "Yellow"

 .Parameter $noChangeColor
 The color of the prompt if there are no unpushed commits and not uncommited changes. Default is "White"

 .Example
  Add this to your prompt function:

  Write-GitPrompt

  Write-GitPrompt uses Write-Host to write to the console and returns nothing.
#>


function git-branch
{
    & git symbolic-ref HEAD --short 2> $null
}

function git-has-changed
{
    & git diff --shortstat 2> $null
}

function git-has-added
{
    & git diff --cached --shortstat 2> $null
}

function git-unpushed
{
    $log = (& git log "@{u}.." 2> $null)
    if($log)
    {
        "unpushed"
    }
    else
    {
        ""
    }
}

function Write-GitPrompt($uncommittedColor = "Red", $unpushedColor = "Yellow", $noChangeColor = "White")
{
    $branch = git-branch
    if ($branch)
    {
        $prompt = " [" + $branch + "] "
        if (git-has-changed -Or git-has-added)
        {
            $color = $uncommittedColor
        }
        elseif (git-unpushed)
        {
            $color = $unpushedColor
        }
        else
        {
            $color = $noChangeColor
        }

        Write-Host -ForegroundColor $color $prompt -NoNewline
    }
}

Export-ModuleMember Write-GitPrompt
