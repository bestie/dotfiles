export FZF_DEFAULT_OPTS=$(echo -e "
  --reverse \
  --multi \
  --height=~50% \
  --info=inline \
  --border=none\
  --separator='     (ノ ˘_˘)ノ :｡･:*:･’★,｡･:*:･’☆                                                                                                                                                                      ' \
  --prompt='~ '\
  --pointer='→' \
  --marker='✓' \
  --bind='ctrl-k:up,ctrl-j:down,ctrl-d:page-down,ctrl-x:cancel' \
  --color=gutter:yellow \
  --color=fg:#5fff00,bg:#080808,hl:#5fff00 \
  --color=fg+:#ff5f00,bg+:#080808,hl+:#ff5f00 \
  --color=info:#d7ff00,prompt:#d7ff00,pointer:#ff5f5f \
  --border-label='much separation, such clarity' \
  --color=marker:#5f5f00,spinner:#d7ff00,header:#ff87ff \
")
