# MacPorts Installer addition on 2011-03-01_at_16:39:37: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

# Add ruby gems to path
export PATH=$PATH:~/.gem/ruby/1.8/bin

# Add Android.sdk to path
export PATH=$PATH:/Users/sjacoby/Development/Android.sdk:/Users/sjacoby/Development/Android.sdk/tools

# Editor
export EDITOR=vim

[ -r ~/.bashrc ] && source ~/.bashrc

function epub()
{
    rm -f $@; zip -q0X $@ mimetype; zip -qXr9D $@ * -x "*.svn*" -x "*~" -x "*.hg*" -x "*.swp" -x "#*#" -x "#*"
}

function epubcheck()
{
    java -jar ~/Development/code.gooogle/epubcheck/com.adobe.epubcheck/dist/epubcheck-1.2.jar $@
}

function ev() 
{
    epub $@; epubcheck $@
}

function swap()  # Swap 2 filenames around, if they exist
{                #(from Uzi's bashrc).
    local TMPFILE=tmp.$$ 

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE 
    mv "$2" "$1"
    mv $TMPFILE "$2"
}
