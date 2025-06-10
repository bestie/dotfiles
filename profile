# vim: syntax=bash

### Foreground Colours #######################################################
   COLOR_NONE="\033[0m"
        RESET="\033[0m"
          RED="\033[0;31m"
        GREEN="\033[0;32m"
       YELLOW="\033[0;33m"
         BLUE="\033[0;34m"
      MAGENTA="\033[0;35m"
         CYAN="\033[0;36m"
    LIGHT_RED="\033[1;31m"
  LIGHT_GREEN="\033[1;32m"
 LIGHT_YELLOW="\033[1;33m"
   LIGHT_BLUE="\033[1;34m"
         PINK="\033[1;35m" # Duplicate of LIGHT_MAGENTA
LIGHT_MAGENTA="\033[1;35m"
        WHITE="\033[1;37m"
   LIGHT_CYAN="\033[1;36m"
   LIGHT_GRAY="\033[0;37m"
    ORANGE256="\033[38;5;202m"
      PINK256="\033[38;5;201m"
    YELLOW256="\033[38;5;190m"
     GREEN256="\033[38;5;82m"
 LIGHT_YELLOW=$YELLOW256

prefix="/opt/homebrew"

PATH="$prefix/bin:$PATH"
PATH=$HOME/bin:$PATH

### Bash things ##############################################################

echo "Bash version is $BASH_VERSION"
if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

### Remember to use the new and shiny things #################################

if [ -x "$(command -v rg)" ]; then
  alias grep="rg"
fi
if [ -x "$(command -v hexyl)" ]; then
  alias xxd="hexyl"
fi
if [ -x "$(command -v bat)" ]; then
  alias cat="bat"
fi
if [ -x "$(command -v dust)" ]; then
  alias du="dust"
fi
if [ -x "$(command -v lsd)" ]; then
  alias ls="lsd"
  alias tree="lsd --tree"
fi
if [ -x "$(command -v hwatch)" ]; then
  alias watch="hwatch"
fi

### fzf ######################################################################

if [ -x "$(command -v fzf)" ]; then
  [[ $- == *i* ]] && source "$prefix/opt/fzf/shell/completion.bash" 2> /dev/null
  source $prefix/opt/fzf/shell/key-bindings.bash
  export FZF_COMMAND="fd --max-depth=3"
  source ~/.config/fzf/fzf_default_opts.sh
  alias fzfkill=" ps -je | fzf --height=20 --multi --header-lines=1 --cycle --layout=reverse | awk '{print \$2}' | xargs kill $@"
fi

### Vim ######################################################################
export EDITOR=vim

alias vim="stty stop '' -ixoff ; vim" # Disable terminal suspend so vim can map ctrl-s
alias vim-dirty="git status --porcelain | grep -v '^ D' | sed 's/^...//' | xargs -o vim -O"
alias vim-changes="git status --porcelain | grep -v '^[D\?]' | sed 's/^...//' | xargs -o vim -O"
alias vim-conflicts="git status --porcelain | grep '^UU' | sed 's/^UU //' | xargs -o vim -O"
alias vim-open="xargs -o vim -O"
alias vim-last-commit="git diff head^ --name-only | xargs -o vim -O"
alias vim-stdin="vim --not-a-term"

### Rubby ####################################################################
alias be='bundle exec'
alias rs='be rails server'
alias rc='be rails console'
alias ctags-ruby='ctags -R --languages=ruby --exclude=.git --exclude=log'

source "$prefix/share/chruby/chruby.sh"
source "$prefix/share/chruby/auto.sh"
if [ -x "$(command -v chruby)" ]; then
  chruby 3
fi

alias gem-edit="bundle list --name-only | fzf | xargs -I{} -o bash -c 'bundle open {}; gem pristine {}'"
alias gem-cull='gem list | cut -d" " -f1 | xargs gem uninstall -aIx'
alias rackthis="echo \"run Rack::Directory.new('.')\" >> config.ru"
alias rspec-dirty="git status --porcelain spec/ | grep -v '^ D' |grep '_spec.rb'| sed 's/^...//' | xargs -o bundle exec rspec"

export DISABLE_SPRING=1

### Rust ######################################################################
source $HOME/.cargo/env
export RUST_BACKTRACE=1
export PATH="$HOME/.cargo/bin:$PATH"

### Misc CLI #################################################################
alias ll="ls -l"
alias psgrep="ps -je|grep"
alias rsyncwoptions='rsync -ruv -e ssh'
alias look-busy='cat /dev/urandom | hexdump -C | grep "ca fe"'
alias reload='source ~/.profile'
alias ssh-add="ssh-add && echo '' | pbcopy"

function random-word {
  ruby -e "puts File.readlines('/usr/share/dict/words').shuffle.take(${1-1})"
}

alias repeat="while true; do; $@ ; done"

# Quick and easy CPU benchmark, calculate pi to 5000 sf
alias bc-benchmark='time echo "scale=5000; a(1)*4" | bc -l'

alias lsof-openfiles="lsof / | awk '/ DEL /{proc[$1]=1;} END{for (name in proc){print name;}}'"
alias lsof-listening-ports="lsof -i| grep LISTEN"
alias big-directories="du -a . | sort -n -r"
alias image-resize-crop="convert $1 -resize $2x$2^ -gravity center -crop $2x$2+0+0 +repage resultimage"

export CLICOLOR="YES"

shopt -s histappend
export HISTSIZE=100000
export HISTCONTROL=ignoreboth
export HISTFILE=~/.bash_histories/$(date +%Y-%m)
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
function page() {
  if [ -x "$(command -v bat)" ]; then
    bat --color=always --pager=less "${1-\-}" $@ 2>&1
  fi
}

# Always open less with these options
export LESS="--raw-control-chars --incsearch --jump-target=8 --mouse --window=-10 --SILENT --use-color"
export PAGER="less"

##############################################################################

source "$HOME/.localprofile"
