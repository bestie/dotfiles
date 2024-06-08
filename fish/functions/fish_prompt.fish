function fish_prompt
    if test -n "$SSH_TTY"
        echo -n (set_color brred)"$USER"(set_color white)'@'(set_color yellow)(prompt_hostname)' '
    end

    echo -n (set_color F7F)(prompt_pwd)' '

    set_color -o
    if fish_is_root_user
        echo -n (set_color red)'# '
    end


    echo -n (set_color "0F0")'❯'(set_color "FF0")'❯'(set_color "F48")'❯ '

    set tasks (jobs --command | ~/bin/job_glyphs | xargs)
    echo -n (set_color "FFF")(set_color "0FF")$tasks' '

    set_color normal
    set_color blue
end
