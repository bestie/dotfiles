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
Bundle 'surround.vim'

""" Settings """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible
syntax on
set autoindent
set ruler
set number
set hlsearch
set incsearch
set nowrap
set winwidth=83
set ignorecase
set smartcase
set noswapfile
set showcmd
set wildmode=list:longest,full

" Allow backspacing over autoindent, eol and start of lines
set backspace=indent,eol,start

" solarized options
let g:solarized_termtrans=1
let g:solarized_visibility = "low"
let g:solarized_contrast = "low"
colorscheme solarized
set background=light

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

""" Sick functions and macros """""""""""""""""""""""""""""""""""""""""""""""""

" RSpec let double - Convert bare word to let(:thing) { double(:thing) }
map <leader>rld Ilet(:wviwyA) { double(:pA) }

" Ruby binding pry - insert binding.pry on the line above
map <leader>rbp Orequire "pry"; binding.pry

" Ruby no pry - remove a binding.pry from the current file, hope it's the one you wanted
map <leader>rnp /binding.pry<cr>dd:noh

" Ruby hash new - convert a string hash rocket to 1.9 hash syntax
" "key" => value becomes key: value
" Works with single quotes too.
map <leader>rhn ^xf=dwbr:j

" Ruby open spec
map <leader>ros :call OpenSpec()<cr>

" Ruby open spec vsplit
map <leader>rosv :call VsplitSpec()<cr>

" Rename current file
map <leader>n :call RenameFile()<cr>

" Ruby hash old - converts 1.9 symbol hash syntax to double quoted string and hash rocket
map <leader>rho I"f:i"lcl =>j

" Rename current file thanks @samphippen
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction

" Infer and open RSpec file for current file
function! OpenSpec()
    let repl = substitute(substitute(substitute(expand('%'), '\.rb', '', ''), "lib/", "spec/", ""), "app/", "spec/", "")
    let path = repl . '_spec.rb'
    exec('e ' . path)
endfunction

" Open RSpec file in a Vsplit
function! VsplitSpec()
    exec('vsplit')
    call OpenSpec()
endfunction

""" Key remaps (standard stuff) """""""""""""""""""""""""""""""""""""""""""""""

" Remap esc to jj in insert mode
inoremap jj <Esc>

" Remap esc to kj in insert mode
inoremap kj <Esc>

" http://vimcasts.org/episodes/show-invisibles/
" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>

" Turn search highlighting off
map <leader>/ :noh<CR>

" Save with CTRL-s
:nmap <c-s> :w<CR>
:imap <c-s> <Esc>:w<CR>a
:imap <c-s> <Esc><c-s>

""" Forgive """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Disable entering EX mode by accident
map Q <Nop>

" You know what I meant
command! Q  q  " Bind :Q  to :q
command! W  w  " Bind :W  to :w
command! Wq wq " Bind :Wq to :wq
command! WQ wq " Bind :WQ to :wq

""" Things to disable when you're feeling masochistic / anti-social

" Disable backspace
" inoremap <BS> <Nop>
" Disable delete
" inoremap <Del> <Nop>

" disble arrow keys in insert, command mode
"nnoremap <up> <nop>
"nnoremap <down> <nop>
"nnoremap <left> <nop>
"nnoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>

""" Syntax highlighting """""""""""""""""""""""""""""""""""""""""""""""""""""""

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Guardfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn} set ft=markdown

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

""" Plugin configs """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Activeate CtrlP with leader t
nnoremap <silent> <leader>t :ClearCtrlPCache<cr>\|:CtrlP<cr>
nnoremap <silent> <leader>e :ClearCtrlPCache<cr>\|:CtrlP<cr>
nnoremap <leader>p :CtrlPBuffer<cr>

" Command + / for commenting
map <D-/> :TComment<cr>
map <leader>n :call RenameFile()<cr>

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
