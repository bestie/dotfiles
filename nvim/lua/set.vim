autocmd FileType java setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType c setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

highlight TrailingWhitespace ctermbg=red guibg=red
match TrailingWhitespace /\s\+$/
