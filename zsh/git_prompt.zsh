# Add git information to the prompt.

function git_branch_name()
{
    git symbolic-ref HEAD --short 2>/dev/null
}

function git_has_modified()
{
    if [[ $(git diff --shortstat 2> /dev/null) != "" ]]
    then
	echo modified
    fi
}

function git_prompt()
{
    local color
    local branch=$(git_branch_name)    
    if [[ $branch != "" ]]
    then
    	if [[ $(git_has_modified) ]]
        then
            color="%F{red}"
        else
            color="%F{white}"
        fi
        echo " $color($branch)%f"
    fi
}
