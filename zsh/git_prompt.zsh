# Add git information to the prompt.

function git_branch_name()
{
    git symbolic-ref HEAD --short 2>/dev/null
}

function git_has_changed()
{
   if [[ $(git diff --shortstat 2> /dev/null) != "" ]]
    then
	echo changed
    fi
}

function git_has_added()
{
   if [[ $(git diff --cached --shortstat 2> /dev/null) != "" ]]
    then
	echo added
    fi
}

function git_unpushed()
{
    if [[ $(git log @{u}.. 2> /dev/null) != "" ]]
    then
        echo unpushed
    fi
}

function git_prompt()
{
    local color
    local branch=$(git_branch_name)    
    if [[ $branch != "" ]]
    then
    	if [[ $(git_has_changed) ]] || [[ $(git_has_added) ]]
        then
            color="%F{red}"
        elif [[ $(git_unpushed) ]]
        then
	    color="%F{yellow}"
	else
            color="%F{white}"
        fi
        echo " $color($branch)%f"
    fi
}
