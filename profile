### Foreground Colours #######################################################
          RED="\[\033[0;31m\]"
        GREEN="\[\033[0;32m\]"
       YELLOW="\[\033[0;33m\]"
         BLUE="\[\033[0;34m\]"
      MAGENTA="\[\033[0;35m\]"
         CYAN="\[\033[0;36m\]"
    LIGHT_RED="\[\033[1;31m\]"
  LIGHT_GREEN="\[\033[1;32m\]"
 LIGHT_YELLOW="\[\033[1;33m\]"
   LIGHT_BLUE="\[\033[1;34m\]"
         PINK="\[\033[1;35m\]" # Duplicate of LIGHT_MAGENTA
LIGHT_MAGENTA="\[\033[1;35m\]"
        WHITE="\[\033[1;37m\]"
   LIGHT_CYAN="\[\033[1;36m\]"
   LIGHT_GRAY="\[\033[0;37m\]"
   COLOR_NONE="\[\e[0m\]"

### 256 Colors ###############################################################

ORANGE256="\[\033[38;5;202m\]"
PINK256="\[\033[38;2;255;150;255m\]"

### Homebrew bash completion #################################################
. `brew --prefix`/etc/bash_completion

### Prompt ###################################################################
source "$HOME/.gitprompt.sh"

function prompt_function {
  PS1="${PINK}\w${COLOR_NONE}$(git_prompt_segment)${LIGHT_GREEN}\$${COLOR_NONE} "
}
PROMPT_COMMAND=prompt_function

### Rubby ####################################################################
alias be='bundle exec'
alias rs='be rails server'
alias rc='be rails console'
alias ctags-ruby='ctags -R --languages=ruby --exclude=.git --exclude=log'

function chruby-latest {
  chruby `chruby | grep -v truffle | tail -n 1 | sed 's/.*ruby-//'`
}

source /usr/local/share/chruby/chruby.sh
chruby 3.0.2
source /usr/local/share/chruby/auto.sh

alias gem-cull='gem list | cut -d" " -f1 | xargs gem uninstall -aIx'
alias rackthis="echo \"run Rack::Directory.new('.')\" >> config.ru"
alias rspec-dirty="git status --porcelain spec/ | grep -v '^ D' |grep '_spec.rb'| sed 's/^...//' | xargs -o bundle exec rspec"

export DISABLE_SPRING=1

### Rust ######################################################################
source $HOME/.cargo/env
export RUST_BACKTRACE=1
export PATH="$HOME/.cargo/bin:$PATH"

### Node ######################################################################
export NVM_DIR="$HOME/.nvm"
source "/usr/local/opt/nvm/nvm.sh"

### Postgres #################################################################
alias pgstart='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pgstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

### Misc CLI #################################################################
alias ll="ls -l"
alias psgrep="ps aux|grep"
alias rsyncwoptions='rsync -ruv -e ssh'
alias look-busy='cat /dev/urandom | hexdump -C | grep "ca fe"'
alias fuck='sudo $(history -p \!\!)'
function random-word {
  ruby -e "puts File.readlines('/usr/share/dict/words').shuffle.take(${1-1})"
}

# Quick and easy CPU benchmark, calculate pi to 5000 sf
alias bc-benchmark='time echo "scale=5000; a(1)*4" | bc -l'

# Kill coreaudio for when Airplay device refused to be selected
alias coreaudio-restart="sudo kill `ps ax | grep 'coreaudiod' | grep -v grep | awk '{print $1}'`"

# names of processes keeping deleting files open
# https://twitter.com/climagic/status/289382853555392513
alias lsof-openfiles="lsof / | awk '/ DEL /{proc[$1]=1;} END{for (name in proc){print name;}}'"

# List all processes listening on ports
alias lsof-listening-ports="lsof -i| grep LISTEN"

alias big-directories="du -a . | sort -n -r"

alias image-resize-crop="convert $1 -resize $2x$2^ -gravity center -crop $2x$2+0+0 +repage resultimage"

export EDITOR=vim
export PATH=$HOME/bin:$PATH
export CLICOLOR="YES"
# http://www.bigsoft.co.uk/blog/2008/04/11/configuring-ls_colors
# export LSCOLORS="ExGxFxdxCxDxDxhbadExEx"
export LSCOLORS=Exfxcxdxbxegedabagacad

export HISTSIZE=5000
export HISTCONTROL=ignoreboth

# Homebrew only
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# copy public ssh key to clipboard
alias copy-key='cat ~/.ssh/id_rsa.pub | pbcopy'

# print a UUID
function uuid {
  ruby -r securerandom -e 'puts SecureRandom.uuid'
}

# Get a user's public key from GitHub
github-pub-key() {
  curl https://github.com/${1}.keys
}

# Disable terminal suspend so vim can map ctrl-s
alias vim="stty stop '' -ixoff ; vim"

alias vim-dirty="git status --porcelain | grep -v '^ D' | sed 's/^...//' | xargs -o vim -O"
alias vim-changes="git status --porcelain | grep -v '^[D\?]' | sed 's/^...//' | xargs -o vim -O"
alias vim-conflicts="git status --porcelain | grep '^UU' | sed 's/^UU //' | xargs -o vim -O"
alias vim-open="xargs -o vim -O"
export FZF_COMMAND="rg --files"

# View some nice JSON, sorted!
alias jqs="jq --sort-keys 'walk(if type == \"array\" then sort else . end)'";

##############################################################################

function it2prof() { echo -e "\033]50;SetProfile=$1\a"; }

source "$HOME/.localprofile"
