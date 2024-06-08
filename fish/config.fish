if status is-interactive
    # Commands to run in interactive sessions can go here
end

if command -q rg
  alias grep="rg"
end
if command -q hexyl
  alias xxd="hexyl"
end
if command -q bat
  alias cat="bat"
end
if command -q dust
  alias du="dust"
end
if command -q lsd
  alias ls="lsd"
  alias tree="lsd --tree"
end
if command -q hwatch
  alias watch="hwatch"
end


set -Ux FZF_DEFAULT_OPTS "--multi --cycle --keep-right -1 --height=~80% --layout=reverse --info=default --preview-window right:50%:wrap --preview '__fzf_preview {}' --ansi"
set -Ux FZF_CTRL_T_COMMAND "rg --files --no-require-git"

export EDITOR=vim
export FZF_COMMAND="rg --files"
export DISABLE_SPRING=1
export RUST_BACKTRACE=1
# export HISTSIZE=5000
# export HISTCONTROL=ignoreboth
export LESS="--raw-control-chars --incsearch --jump-target=8 --mouse --window=-10 --SILENT --use-color"
export PAGER="less"

alias unset="set --erase"
alias vim-dirty="git status --porcelain | grep -v '^ D' | sed 's/^...//' | xargs -o vim -O"
alias vim-changes="git status --porcelain | grep -v '^[D\?]' | sed 's/^...//' | xargs -o vim -O"
alias vim-conflicts="git status --porcelain | grep '^UU' | sed 's/^UU //' | xargs -o vim -O"
alias vim-open="xargs -o vim -O"
alias vim-last-commit="git diff head^ --name-only | xargs -o vim -O"
alias vim-stdin="vim --not-a-term"
alias be='bundle exec'
alias rs='be rails server'
alias rc='be rails console'
alias ctags-ruby='ctags -R --languages=ruby --exclude=.git --exclude=log'
alias gem-edit="bundle list --name-only | fzf | xargs -I{} -o bash -c 'bundle open {}; gem pristine {}'"
alias gem-cull='gem list | cut -d" " -f1 | xargs gem uninstall -aIx'
alias rackthis="echo \"run Rack::Directory.new('.')\" >> config.ru"
alias rspec-dirty="git status --porcelain spec/ | grep -v '^ D' |grep '_spec.rb'| sed 's/^...//' | xargs -o bundle exec rspec"
alias ll="ls -l"
alias ltr="ls -ltr"
alias psgrep="ps -je|grep"
alias rsyncwoptions='rsync -ruv -e ssh'
alias look-busy='cat /dev/urandom | hexdump -C | grep "ca fe"'
alias reload='source ~/.profile'
alias fzfkill="ps aux | fzf --multi | awk '{print \$2}' | xargs kill $argv"
alias bc-benchmark='time echo "scale=5000; a(1)*4" | bc -l'
alias lsof-openfiles="lsof / | awk '/ DEL /{proc[$1]=1;} END{for (name in proc){print name;}}'"
alias lsof-listening-ports="lsof -i| grep LISTEN"
alias big-directories="du -a . | sort -n -r"
alias image-resize-crop="convert $1 -resize $2x$2^ -gravity center -crop $argv[2]x$argv[2]+0+0 +repage resultimage"
alias copy-key='cat ~/.ssh/id_rsa.pub | pbcopy'
alias jqsorted="jq --sort-keys 'walk(if type == \"array\" then sort else . end)'";
alias fzfkill="ps -je | fzf --height=20 --multi --header-lines=1 --cycle --layout=reverse | awk '{print \$2}' | xargs kill $argv"

source "job_control.fish"
