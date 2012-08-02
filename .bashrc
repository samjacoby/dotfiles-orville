export BASH_CONF="bashrc"
set -o vi
function _PS1 ()
{
    local PRE= NAME="$1" LENGTH="$2";
    [[ "$NAME" != "${NAME#$HOME/}" || -z "${NAME#$HOME}" ]] &&
        PRE+='~' NAME="${NAME#$HOME}" LENGTH=$[LENGTH-1];
    ((${#NAME}>$LENGTH)) && NAME="/...${NAME:$[${#NAME}-LENGTH+4]}";
    echo "$PRE$NAME"
}

export PS1='\[\e[0;32m\]\u@\h\[\e[m\] \[\e[1;34m\]$(_PS1 "$PWD" 30) \$\[\e[m\] \[\e[1;37m\] '

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.bash_colors ]; then
    . ~/.bash_colors
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
