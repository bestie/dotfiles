function __fzf_preview
# .config/fish/functions/__fzf_preview.fish

function __fzf_preview
    if file --mime "$argv" | grep -q directory
        tree -L 3 "$argv"
    else if file --mime "$argv" | grep -q binary
        echo "$argv is a binary file"
    else
        if command --quiet --search bat
            bat --color=always --line-range :250 "$argv"
        else if command --quiet --search cat
            cat "$argv" | head -250
        else
            head -250 "$argv"
        end
    end
end
