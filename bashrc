
### Homebrew #################################################################
if [ -x "$(command -v brew)" ]; then
  prefix=/opt/homebrew
  [[ -r "$prefix/etc/profile.d/bash_completion.sh" ]] && . "$prefix/etc/profile.d/bash_completion.sh"
  export PATH=$prefix/bin:$prefix/sbin:$PATH
  export HOMEBREW_NO_AUTO_UPDATE=1
fi

### History ##################################################################
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

### fzf ######################################################################

if [ -x "$(command -v fzf)" ]; then
  [[ $- == *i* ]] && source "$prefix/opt/fzf/shell/completion.bash" 2> /dev/null
  source $prefix/opt/fzf/shell/key-bindings.bash
  source ~/.config/fzf/fzf_default_opts.sh
  export FZF_COMMAND="fd --max-depth=3"
  alias fzfkill=" ps -je | fzf --height=20 --multi --header-lines=1 --cycle --layout=reverse | awk '{print \$2}' | xargs kill $@"
fi

### Prompt ###################################################################
source "$HOME/.gitprompt.sh"
source "$HOME/.job_control.bash"

function prompt_function {
  local last_exit=$?
  local prefix=""
  local last_exit_seg=""

  if (( $last_exit == 0 )); then
    last_exit_seg=""
    prefix="🐚🔨"
  else
    # add a zero width space here so character count matches width
    last_exit_seg=" ❌​ \[${LIGHT_RED}\]${last_exit} \[${RESET}\]"
    prefix="🤕🔨"
    last_exit=0
  fi

  local glyph_seg=$(jobs | awk '{print $3}' | job_glyphs '')
  [[ "$glyph_seg" ]] && glyph_seg="\[$LIGHT_YELLOW\][\[$CYAN\]${glyph_seg}\[$LIGHT_YELLOW\]]\[$RESET\]"
  local git_seg=$(git_prompt_segment)
  [[ "$git_seg" ]] && git_seg=" $git_seg"

  local terminal_width=$(tput cols)
  local right_prompt_content="${last_exit_seg}${git_seg}"
  local right_prompt_len=$(echo "${right_prompt_content}" | ruby --disable=gems -e "s=STDIN.read.strip; sg=s.gsub(/\\\\033\[\d+(;\d+)*\w/,''); puts sg.length")
  local right_prompt_start_column=$(($terminal_width-$right_prompt_len))

  local move_to_right_prompt_start_column="\[\033[${right_prompt_start_column}G\]"
  local right_prompt="${move_to_right_prompt_start_column}${right_prompt_content}"
  local current_dir="\[${PINK256}\]\w\[${COLOR_NONE}\]"
  local bg_glyphs="\[${CYAN}\]${glyph_seg}\[${COLOR_NONE}\]"
  local dollar="\[${GREEN256}\]\$\[${RESET}\]"

  local save_position="\[\033[s\]"
  local restore_position="\[\033[u\]"

  # PS1="${save_position}${right_prompt}${restore_position}🔨${current_dir}${bg_glyphs}${dollar} "
  PS1="${prefix}${current_dir}${git_seg}${bg_glyphs}${last_exit_seg}${dollar} "
}
PROMPT_COMMAND=prompt_function


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

