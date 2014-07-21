function git_prompt_segment {
  git rev-parse --git-dir &> /dev/null
  # exit straight away if cwd is not a git repo
  if ! git_status="$(git status 2> /dev/null)"; then
    exit 1
  fi

  branch_pattern="^On branch ([^${IFS}]*)"
  detached_branch_pattern="Not currently on any branch"
  remote_pattern="Your branch is (ahead|behind)"
  diverge_pattern="Your branch and (.*) have diverged"

  # Green bolt if all changes are staged
  if [[ ${git_status}} =~ "Changes to be committed" ]]; then
    state="${GREEN}⚡"
  fi

  # Red bolt for unstaged changes
  if [[ ${git_status}} =~ "Changes not staged for commit" ]]; then
    state="${RED}⚡"
  fi

  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="${YELLOW}↑"
    elif [[ ${BASH_REMATCH[1]} == "behind" ]]; then
      remote="${YELLOW}↓"
    fi
  fi

  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="${YELLOW}↕"
  fi
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch="${YELLOW}${BASH_REMATCH[1]}"
  elif [[ ${git_status} =~ ${detached_branch_pattern} ]]; then
    branch="${YELLOW}NO BRANCH"
  fi

  if [[ ${#state} -gt "0" || ${#remote} -gt "0" ]]; then
    s=" "
  fi

  echo " (${branch}${s}${remote}${state}${COLOR_NONE})"
}

