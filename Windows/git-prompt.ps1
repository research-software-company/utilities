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

function git-prompt
{
    $prompt = ""
    $branch = git-branch
    if ($branch)
    {
        $prompt = " [" + $branch + "] "
    }

    $prompt
}

function prompt
{
    Write-Host $(get-location) -NoNewline

    $branch = $(git-branch)
    if ($branch)
    {
        $branch_str = " [" + $branch + "] "
        if (git-has-changed -Or git-has-added)
        {
            $color = "Red"
        }
        elseif (git-unpushed)
        {
            $color = "Yellow"
        }
        else
        {
            $color = "White"
        }

        Write-Host -ForegroundColor $color $branch_str -NoNewLine
       
    }

    Write-Host ">" -NoNewline
    " "
}