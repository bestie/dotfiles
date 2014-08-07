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
if !has('gui_running')
    let g:solarized_termtrans=1
    let g:solarized_visibility = "low"
    let g:solarized_contrast = "low"
endif
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

" Ruby hash old - converts 1.9 symbol hash syntax to double quoted string and hash rocket
map <leader>rho I"f:i"lcl =>j

" Ruby open spec
map <leader>ros :call OpenSpec()<cr>

" Run test, support all common Ruby test libs
map <leader>rt :call RunTestFile()<cr>

" As above but only test on current line
map <leader>rtl :call RunTestFileAtLine()<cr>

" Ruby open spec vsplit
map <leader>rosv :call VsplitSpec()<cr>

" Rename current file
map <leader>n :call RenameFile()<cr>

map <leader>vrc :vsplit<cr>:edit $MYVIMRC<cr>
map <leader>vsrc :w<cr>:source $MYVIMRC<cr>:echo "VIMRC reloaded"<cr>

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
    let current_file = expand('%')
    if current_file =~ '^app'
      let spec_file = substitute(current_file, '^app', 'spec', '')
    elseif current_file =~ '^lib/'
      let spec_file = substitute(current_file, '^lib', 'spec', '')
    else
      let spec_file = 'spec/' . current_file
    endif

    let path = substitute(spec_file, '\.rb', '_spec.rb', '')
    exec('e ' . path)
endfunction

" Open RSpec file in a Vsplit
function! VsplitSpec()
    exec('vsplit')
    call OpenSpec()
endfunction

" Run the current file and open results in a Vsplit, handle ANSI chars
function! RunTestFile()
    exec("w")
    let test_command = CommandToRunFile(expand("%"))
    call RunCommandVsplitOutput(test_command)
endfunction

" As RunTestFile using Ruby convention for running tests by line number
function! RunTestFileAtLine()
    let current_line = line(".") + 1
    let test_command = CommandToRunFile(expand("%")) . ":" . current_line
    call RunCommandVsplitOutput(test_command)
endfunction

" Run a command capturing the output in a new vsplit
function! RunCommandVsplitOutput(command)
    let temp_file = CaptureShellOutput(a:command)
    call VsplitFileWithAnsiEscChars(temp_file)
    call system("rm " . temp_file)
endfunction

" Open a file in a new vsplit handling ANSI escape chars
function! VsplitFileWithAnsiEscChars(file)
  exe "vsplit"
  call OpenFileWithAnsiEscChars(a:file)
endfunction

" Open a file stripping ANSI escape chars or use AnsiEsc plugin if present
function! OpenFileWithAnsiEscChars(file)
    if exists(":AnsiEsc")
      exe "edit " . a:file
      exe "AnsiEsc"
    else
      let stripped_file = StripAnsiEscapeChars(a:file)
      exe "edit " . stripped_file
      call system("rm " stripped_file)
    endif
endfunction

" Infer command necessary test run file
function! CommandToRunFile(filename)
    if a:filename =~ "\.feature$"
      let command  = "bundle exec cucumber"
    elseif a:filename =~ "_spec\.rb$"
      let command = "bundle exec rspec"
    elseif a:filename =~ "_test\.rb$"
      let command = "bundle exec ruby -I test"
    end

    return command . " " . a:filename
endfunction

" Run command, capture shell eutput to temp file and return temp file
function! CaptureShellOutput(command)
    let temp_file=tempname()
    exe expand(":!unbuffer " . a:command . " % 2>&1 | tee " . temp_file)
    return temp_file
endfunction

function! StripAnsiEscapeChars(raw_file)
    let stripped_file=tempname()
    call system('cat ' . a:raw_file . ' | sed "s:.\[[0-9;]*[mK]::g" > ' . stripped_file)
    return stripped_file
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
