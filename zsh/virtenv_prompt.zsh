# Python virtualenv rprompt
function virtualenv_name()
{
   python ~/Scripts/zsh/envname.py
}

export VIRTUAL_ENV_DISABLE_PROMPT='1'
RPROMPT='%F{green}$(virtualenv_name)%{$reset_color%}'

setopt PROMPT_SUBST
