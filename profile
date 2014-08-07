### Foreground Colours #######################################################
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
      GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
       PINK="\[\033[0;35m\]"
 COLOR_NONE="\[\e[0m\]"

### Homebrew bash completion #################################################
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

### Prompt ###################################################################
source "$HOME/.gitprompt.sh"

function prompt_function {
  PS1="${PINK}\w${COLOR_NONE}$(git_prompt_segment)\$ "
}
PROMPT_COMMAND=prompt_function

### Amazon shizzle ###########################################################
export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
export EC2_PRIVATE_KEY="$(/bin/ls $HOME/.ec2/pk-*.pem)"
export EC2_CERT="$(/bin/ls $HOME/.ec2/cert-*.pem)"
export EC2_HOME="/usr/local/Cellar/ec2-api-tools/1.3-57419/jars"

source "$HOME/.ec2/access_keys"

### Rails / dev aliases ######################################################
alias be='bundle exec'
alias pryc='pry -r./config/environment'
alias cf="cucumber features"
alias cfip="cf --tags @in_progress @wip"

alias rs='be rails server'
alias rc='be rails console'
alias rg='be rails generate'
alias rails-migrate-redo="rake db:migrate:redo VERSION=\$(ls -tr db/migrate| tail -n1 | sed -e s/[^0-9]//g)"

# Disable terminal suspend so vim can map ctrl-s
alias vim="stty stop '' -ixoff ; vim"

alias gem-cull='gem list | cut -d" " -f1 | xargs gem uninstall -aIx'
alias rackthis="echo \"run Rack::Directory.new('.')\" >> config.ru"
alias iphone-simulator="open /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Applications/iPhone\ Simulator.app"

# Kill coreaudio for when Airplay device refused to be selected
alias coreaudio-restart="sudo kill `ps ax | grep 'coreaudiod' | grep -v grep | awk '{print $1}'`"

# names of processes keeping deleting files open
# https://twitter.com/climagic/status/289382853555392513
alias lsof-openfiles="lsof / | awk '/ DEL /{proc[$1]=1;} END{for (name in proc){print name;}}'"

# List all processes listening on ports
alias lsof-listening-ports="lsof -i| grep LISTEN"

### Scala ####################################################################

export SCALA_HOME="/usr/local/opt/scala/idea"
export SBT_OPTS="-XX:MaxPermSize=256m"

### Postgres #################################################################
alias pgstart='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pgstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

### Misc CLI #################################################################
alias ll="ls -l"
alias psgrep="ps aux|grep"
alias rsyncwoptions='rsync -ruv -e ssh'
export EDITOR=vim
export PATH=$HOME/bin:$PATH
export CLICOLOR="YES"
export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# copy public ssh key to clipboard
alias copy-key='cat ~/.ssh/id_rsa.pub | pbcopy'

##############################################################################

source "$HOME/.localprofile"

### This loads RVM into a shell session. #####################################
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

