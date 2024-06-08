function bring_bg_to_fg
    # Count the number of background jobs
    set -l job_count (count (jobs -p))

    switch $job_count
        case 0
            # No background jobs
            echo "No background jobs running"
        case 1
            # Default to the first job
            fg %1
        case '*'
            # Prompt user to select a job
            # echo "Select a background job to bring to foreground:"
            set -l job_line (
              jobs | fzf --bind=ctrl-z:accept,alt-z:accept --pointer=" " --cycle --border=none --height=~5 --no-multi --separator='' --layout=reverse --color='bg:#000000,gutter:#000000,fg+:#000000,bg+:#4fff00'
            )
            set -l job_num(echo $job_line | cut -f1)
            if test $status -ne 0
                # echo "fzf was aborted"
                return
            end
            if test -z "$job_num"
                # echo "No job selected"
                return
            end
            fg "%"$job_num
    end
end

# Bind C-z to the function
bind \cz bring_bg_to_fg
bind \ez bring_bg_to_fg
