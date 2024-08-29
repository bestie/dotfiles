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

if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.bash" 2> /dev/null
source /usr/local/opt/fzf/shell/key-bindings.bash

export FZF_COMMAND="fd --max-depth=3"
source ~/.config/fzf/fzf_default_opts.sh

alias fzfkill=" ps -je | fzf --height=20 --multi --header-lines=1 --cycle --layout=reverse | awk '{print \$2}' | xargs kill $@"
source "$HOME/.job_control.bash"

### Vim ######################################################################
export EDITOR=vim

alias vim="stty stop '' -ixoff ; vim" # Disable terminal suspend so vim can map ctrl-s
alias vim-dirty="git status --porcelain | grep -v '^ D' | sed 's/^...//' | xargs -o vim -O"
alias vim-changes="git status --porcelain | grep -v '^[D\?]' | sed 's/^...//' | xargs -o vim -O"
alias vim-conflicts="git status --porcelain | grep '^UU' | sed 's/^UU //' | xargs -o vim -O"
alias vim-open="xargs -o vim -O"
alias vim-last-commit="git diff head^ --name-only | xargs -o vim -O"
alias vim-stdin="vim --not-a-term"

### Homebrew bash completion #################################################
if [ -x "$(command -v brew)" ]; then
  [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
  export PATH=/usr/local/bin:/usr/local/sbin:$PATH
  export HOMEBREW_NO_AUTO_UPDATE=1
fi

### Prompt ###################################################################
source "$HOME/.gitprompt.sh"

function prompt_function {
  local last_exit=$?

  if (( $last_exit == 0 )); then
    last_exit_seg=""
  else
    # add a zero width space here so character count matches width
    last_exit_seg="❌​ ${LIGHT_RED}${last_exit} ${RESET}"
  fi

  local glyph_seg=$(jobs | awk '{print $3}' | job_glyphs --separator '')
  [[ "$glyph_seg" ]] && glyph_seg="\[$LIGHT_YELLOW\][\[$CYAN\]${glyph_seg}\[$LIGHT_YELLOW\]]\[$RESET\]"
  local git_seg=$(git_prompt_segment)
  local terminal_width=$(tput cols)

  local git_info="${branch}${dirty}${untracked}"

  local right_prompt_content="${last_exit_seg}${git_seg}"
  local right_prompt_len=$(echo "${right_prompt_content}" | ruby --disable=gems -e "s=STDIN.read.strip; sg=s.gsub(/\\\\033\[\d+(;\d+)*\w/,''); puts sg.length")
  local right_prompt_start_column=$(($terminal_width-$right_prompt_len))

  local right_prompt="\[\033[${right_prompt_start_column}G${right_prompt_content}\033[0G\]"
  local current_dir="\[${PINK256}\]\w\[${COLOR_NONE}\]"
  local bg_glyphs="\[${CYAN}\]${glyph_seg}\[${COLOR_NONE}\]"
  local dollar="\[${GREEN256}\]\$\[${RESET}\]"

  PS1="${right_prompt}🔨${current_dir}${bg_glyphs}${dollar} "
}
PROMPT_COMMAND=prompt_function

### Rubby ####################################################################
alias be='bundle exec'
alias rs='be rails server'
alias rc='be rails console'
alias ctags-ruby='ctags -R --languages=ruby --exclude=.git --exclude=log'

source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
chruby 3.2

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

export PATH=$HOME/bin:$PATH
export CLICOLOR="YES"

shopt -s histappend
export HISTSIZE=100000
export HISTCONTROL=ignoreboth
export HISTFILE=~/.bash_histories/$(date +%Y-%m)
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# Always open less with these options
export LESS="--raw-control-chars --incsearch --jump-target=8 --mouse --window=-10 --SILENT --use-color"
export PAGER="less"
function page() {
  if [ -x "$(command -v bat)" ]; then
    bat --color=always --pager=less "${1-\-}" $@ 2>&1
  fi
}

# copy public ssh key to clipboard
alias copy-key='cat ~/.ssh/id_rsa.pub | pbcopy'

# print a UUID
function uuid {
  ruby -r securerandom -e 'puts SecureRandom.uuid'
}

# Get a user's public key from GitHub
github_pub_key() {
  curl https://github.com/${1}.keys
}

# View some nice JSON, sorted!
alias jqsorted="jq --sort-keys 'walk(if type == \"array\" then sort else . end)'";

# Using a script to do this for portability
# alias fzfkill="ps -A | fzf --height=20 --multi --header-lines=1 --cycle --layout=reverse | awk '{print \$2}' | xargs kill $@"

docker-nuke-containers() {
  docker rm -vf $(docker ps -aq)
}

docker-nuke-images() {
  docker rmi -f $(docker images -aq)
}

##############################################################################

function it2prof() { echo -e "\033]50;SetProfile=$1\a"; }

source "$HOME/.localprofile"

export KAFKA_BROKERS="localhost:9092"
kafka-topic-create() {
  kafka-topics --bootstrap-server $KAFKA_BROKERS --create --topic $1 --partitions ${2-1} --replication-factor 1
}
kafka-topic-delete() {
  kafka-topics --bootstrap-server $KAFKA_BROKERS --delete --topic $1
}
kafka-topics-list() {
  kafka-topics --bootstrap-server $KAFKA_BROKERS --list
}
kafka-consumers-groups-list() {
  kakfa-consumer-groups --list --bootstrap-server $KAFKA_BROKERS
#  5041  kafka-consumer-groups   --broker-list localhost:9092 --list
}
kafka-consumer-group-describe() {
  kafka-consumer-groups --bootstrap-server $KAFKA_BROKERS --describe --group $1
}
kafka-topic-consumer-group-offsets() {
  kafka-run-class kafka.tools.GetOffsetShell --broker-list $KAFKA_BROKERS --topic $1
}

# Kafka commands
#  5040  kafka-consumer-groups --list
#  5011  kafka-topics --bootstrap-server localhost:9092
#  5030  kakfa-run-class kafka.tools.ConsumerOffsetChecker
#  5037  kafka-consumer-groups --topic interesting --group boop
#  5041  kafka-consumer-groups   --broker-list localhost:9092 --list
#  5045  kafka-consumer-groups --bootstrap-server localhost:9092 --list --offsets
#  5027  watch kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group boop
#  5017  kafka-run-class kafka.tools.GetOffsetShell   --broker-list localhost:9092 --topic interesting


export JAVA_HOME="/Library/Java/JavaVirtualMachines/graalvm-jdk-22+36.1/Contents/Home/"
export PATH="$JAVA_HOME/bin:$PATH"
