check_foreground_job() {
  local fg_job=$(jobs -r | wc -l | xargs)
  if [ "$fg_job" -gt 0 ]; then
    echo "There is a foreground job running. ${fg_job}"
    return 1
  else
    echo "No foreground jobs running."
    return 0
  fi
}

job_select() {


    check_foreground_job


    # Count the number of background jobs
    local job_count=$(jobs -p | wc -l | xargs)

    case $job_count in
        0)
            # No background jobs
            # echo "No background jobs running"
            ;;
        1)
            # Default to the first job
            fg
            ;;
        *)
            # Prompt user to select a job
            # echo "Select a background job to bring to foreground:"
            local job_line=$(
              jobs | fzf --bind=ctrl-z:accept --pointer=" " --cycle --border=none --height=~5 --no-multi --separator='' --layout=reverse --color='bg:#000000,gutter:#000000,fg+:#000000,bg+:#4fff00'
            )
            local job_num=$(echo $job_line | sed 's/\[\([0-9]*\)\].*/\1/')

            # Check the exit status of fzf
            if [ $? -ne 0 ]; then
                # echo "No job selected or fzf was aborted"
                return
            fi
            if [ -z "$job_num" ]; then
                # echo "No job selected"
                return
            fi
                # echo "Chosen '$job_num'"
                fg %$job_num
            ;;
    esac
}

# stty susp undef

bind -x '"\ez": job_select'
