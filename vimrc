""" Vundle """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'Solarized'
Bundle 'ack.vim'
Bundle 'tComment'
Bundle 'endwise.vim'
Bundle 'ctrlp.vim'

""" Settings """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
syntax on
set autoindent
set ruler
set number
set hlsearch
set nowrap
set winwidth=83
set ignorecase
set smartcase
set noswapfile

colorscheme solarized

if has('gui_running')
    set background=light
else
    set background=dark
endif

" set vertical marker at col 80
set colorcolumn=80

" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" visual bell http://vim.wikia.com/wiki/Disable_beeping
" set noerrorbells visualbell t_vb=
" autocmd GUIEnter * set visualbell t_vb=

" http://vimcasts.org/episodes/tabs-and-spaces/
set ts=2 sts=2 sw=2 expandtab

" from http://robots.thoughtbot.com/post/48275867281/vim-splits-move-faster-and-more-naturally
"open splits to the right and towards the bottom
set splitbelow
set splitright

" unobtrusive whitespace highlighting
" http://blog.kamil.dworakowski.name/2009/09/unobtrusive-highlighting-of-trailing.html
highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

""" Key remaps """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Disable paragraph skipping
nnoremap { :echo 'Stop trying to hurt yourself'<CR>
nnoremap } :echo 'Stop trying to hurt yourself'<CR>

" Remap esc to jj in insert mode
inoremap jj <Esc>

" Remap esc to kj in insert mode
inoremap kj <Esc>

" DIsable entering EX mode by accident
map Q <Nop>

" disble arrow keys in insert, command mode
"nnoremap <up> <nop>
"nnoremap <down> <nop>
"nnoremap <left> <nop>
"nnoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>

" http://vimcasts.org/episodes/show-invisibles/
" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Disable backspace
" inoremap <BS> <Nop>
" Disable delete
" inoremap <Del> <Nop>

""" Syntax highlighting """""""""""""""""""""""""""""""""""""""""""""""""""""""

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Guardfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} set ft=markdown

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

""" Plugin configs """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Activeate CtrlP with leader t
map <leader>t <C-p>

" Command + / for commenting
map <D-/> :TComment<cr>

""" MacVim specific """""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('gui_running')
" MacVim save on loss of focus
" autocmd BufLeave,FocusLost * silent! wall

" Intelligently switch between relative and absolute line number line number
" autocmd FocusLost * :set norelativenumber
" if mode() == 'i'
"   autocmd FocusGained * :set relativenumber
" endif
" autocmd InsertEnter * :set norelativenumber
" autocmd InsertLeave * :set relativenumber
" autocmd CursorMoved * :set relativenumber
endif
