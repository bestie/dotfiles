""" Vundle """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" for the editor itself
Plugin 'gmarik/Vundle.vim'
Plugin 'Solarized'
Plugin 'calmar256-lightdark.vim'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-dispatch'

nmap <c-p> :Files<cr>
nmap <leader>rg :Rg

" for general text editing
Plugin 'tComment'
Plugin 'endwise.vim'
Plugin 'surround.vim'
Plugin 'abolish.vim'

" language specific
Plugin 'haskell.vim'
Plugin 'rust-lang/rust.vim'

call vundle#end()
filetype plugin indent on

let g:dispatch_compilers = {
      \ 'latex': 'tex',
      \ 'bundle exec': ''}

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
set scrolloff=5               " keep at least 5 lines above/below
set sidescrolloff=5           " keep at least 5 lines left/right

set path+=./lib
set path+=./spec
set ttyfast                   " Apparently terminals are fast
set noerrorbells              " @andrewmcdonough does not like bells
set fileformats=unix
set lazyredraw
set shell=bash

" Allow backspacing over autoindent, eol and start of lines
set backspace=indent,eol,start

set t_Co=256                        " force vim to use 256 colors
colorscheme calmar256-light
set background=light

" set vertical marker at col 80
set colorcolumn=80
highlight ColorColumn ctermbg=224

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

" Use the old vim regex engine (version 1, as opposed to version 2, which was
" introduced in Vim 7.3.969). The Ruby syntax highlighting is significantly
" slower with the new regex engine.
" https://github.com/garybernhardt/dotfiles/commit/99b7d2537ad98dd7a9d3c82b8775f0de1718b356#diff-4e12c6a37ff2cbb2c93d1b33324a6051
set re=1

" Enable project specific configurations, allowing safe commands only
set exrc
set secure

" unobtrusive whitespace highlighting
" http://blog.kamil.dworakowski.name/2009/09/unobtrusive-highlighting-of-trailing.html
highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\s\+$/
au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\s\+$/

" Return to last edit position when opening files
function! PositionCursorFromViminfo()
  if !(bufname("%") =~ '\(COMMIT_EDITMSG\)') && line("'\"") > 1 && line("'\"") <= line("$")
    exe "normal! g`\""
  endif
endfunction

autocmd BufReadPost * call PositionCursorFromViminfo()

""" Sick functions and macros """""""""""""""""""""""""""""""""""""""""""""""""

" Open and reload vimrc
map <leader>vrc :edit $MYVIMRC<cr>
map <leader>vsrc :source $MYVIMRC<cr>:echo "VIMRC reloaded"<cr>

map <leader>ct :call RefreshRubyCTags()<cr>
" Rename current file
map <leader>n :call RenameFile()<cr>

" RSpec let double - Convert bare word to let(:thing) { double(:thing) }
map <leader>rld Ilet(:wviwyA) { double(:pA) }

" Ruby binding pry - insert binding.pry on the line above
map <leader>rbp Orequire "pry"; binding.pry # DEBUG @bestie

" Ruby tap and pry
map <leader>rtp o.tap { \|o\| "DEBUG @bestie"; require "pry"; binding.pry }<esc>

" Ruby no pry - remove a binding.pry from the current file, hope it's the one you wanted
map <leader>rnp /binding.pry<cr>dd:noh

" Convert Ruby hash keys, works with visual selection
" Works with single quotes too.
map <leader>rhn :call RubyHashConvertStringKeysToNewSyntax()<cr>
map <leader>rho :call RubyHashConvertNewSyntaxKeysToStrings()<cr>
map <leader>rh19 :call RubyHashConvertSymbolHashRocketKeysToNewSyntax()<cr>
map <leader>rhrs :call RubyHashConvertSymbolHashRocketKeysToStrings()<cr>

imap <c-l> <space>=><space>

function! RefreshRubyCTags()
  if !(bufname("%") =~ '\*.rb\')
    exec(":!tmux new -d 'ctags -R --languages=ruby --exclude=.git --exclude=log'")
  endif
endfunction

function! RubyHashConvertStringKeysToNewSyntax()
  normal ^xf=dwbr:j^
endfunction

function! RubyHashConvertNewSyntaxKeysToStrings()
  normal I"f:i"lcl =>j
endfunction

function! RubyHashConvertSymbolHashRocketKeysToNewSyntax()
  normal ^xf r:ldt j
endfunction

function! RubyHashConvertSymbolHashRocketKeysToStrings()
  normal ^r"f i"j
endfunction

" Execute the current file, detects tests, always opens the quickfix window
map <leader>e :ccl<cr>:w<esc>:call ExecuteFile(expand("%"), &filetype)<cr>:Copen<cr>

" Same as above but 't' for test and doesn't reopen the quickfix window
map <leader>t :ccl<cr>:w<cr>:call ExecuteFile(expand('%'), &filetype)<cr>

" Test at line, as above but appends the cursor position to the command
map <leader>tl :ccl<cr>:w<cr>:call RunTestAtLine(expand('%'), line("."))<cr>

" Repeats the previous test run / file execution
map <leader>r <esc>:ccl<cr>:w<cr>:call RepeatLatestCommand()<cr>

" Ruby open spec, infer spec file for current file and open
map <leader>ros :call EditFile(InferSpecFile(expand('%')))<cr>

" Generate Ruby classes with a bit less typing
map <leader>rc :%!ruby-class-generator<cr>
vmap <leader>rc :!ruby-class-generator<cr>

" Unjoin
map <leader>j :s/, /,\r/g<cr>:nohl<cr>

" Run a test file at line (currently supports RSpec only)
function! RunTestAtLine(filename, line_number)
  let test_command = RubyFileCommand(a:filename)

  if strlen(test_command)
    let test_command_with_line = test_command . ":" . a:line_number
    call RunCommand(test_command_with_line)
  else
    echo "Not a recognized test '" . a:filename . "'"
  end
endfunction!

" Infer RSpec file for current file
function! InferSpecFile(filename)
    if a:filename =~ '^app'
      let spec_file = substitute(a:filename, '^app', 'spec', '')
    elseif a:filename =~ '^lib/'
      let spec_file = substitute(a:filename, '^lib', 'spec', '')
    else
      let spec_file = 'spec/' . a:filename
    endif

    let path = substitute(spec_file, '\.rb', '_spec.rb', '')

    return path
endfunction

function! ExecuteFile(filename, filetype)
  let command = ExecuteFileCommand(a:filename, a:filetype)

  call RunCommand(command)
endfunction

function! ExecuteFileCommand(filename, filetype)
  let filetype = a:filetype
  let filename = a:filename

  if filetype == "ruby"
    let command = RubyFileCommand(filename)
  elseif filetype == "cucumber"
    let command = BundlerPrefix() . "cucumber " . filename
  elseif filetype == "rust" && filereadable("Cargo.lock")
    let command = "cargo run"
  elseif filetype == "rust"
    let command = "rustc -o out -- " . filename . " && ./out"
  else
    echo "No execution strategy for filetype " . filetype
    return ""
  endif

  return command
endfunction

function! RubyFileCommand(filename)
  let filename = a:filename

  if filename =~ "_spec.rb"
    let command = BundlerPrefix() . "rspec " . filename
  elseif filename =~ "_test.rb"
    let command = BundlerPrefix() . "ruby -I test -r test_helper.rb " . filename
  else
    let command = BundlerPrefix() . "ruby " . filename
  endif

  return command
endfunction

function! BundlerPrefix()
  if filereadable("Gemfile.lock")
    return "bundle exec "
  else
    return ""
  endif
endfunction

function! RepeatLatestCommand()
  if exists("g:latest_command")
    call RunCommand(g:latest_command)
  else
    echo "No command to repeat"
  end
endfunction

function! RunCommand(command)
  if strlen(a:command)
    " echo a:command
    let g:latest_command = a:command
    exec "Dispatch " . a:command
  else
    echo "No command to run"
  endif
endfunction

" This probably isn't necessary but I have no idea what I'm doing
function! EditFile(filename)
  exec "e " . a:filename
endfunction

" Rename current file thanks @samphippen
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', old_name, 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

""" Key remaps (standard stuff) """""""""""""""""""""""""""""""""""""""""""""""

" %% For current directory thanks @squil
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Turn search highlighting off
map <leader>/ :noh<CR>

" Save with CTRL-s
:nmap <c-s> :w<CR>
:imap <c-s> <Esc>:w<CR>a
:imap <c-s> <Esc><c-s>

:nnoremap <leader>c :ccl<CR>

" Copy and paste from system clipboard
vmap <leader>y "+y
nmap <leader>y "+yy
nmap <leader>p "+p
vmap <leader>p "+p
nmap <leader>P "+P

""" Forgive """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Disable entering EX mode by accident
map Q <Nop>

" Disable man page lookups
map K :echo "man lookups disabled"<cr>

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
au BufRead,BufNewFile {Gemfile,Guardfile,Rakefile,Vagrantfile,Thorfile,config.ru,*.jbuilder} set filetype=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown} set filetype=markdown

" Spell checking for text formats
au BufRead,BufNewFile *.txt,*.md,*.markdown,*.textile,*.feature setlocal spell
autocmd FileType gitcommit setlocal spell
" Autocomplete with dictionary words when spell check is on
set complete+=kspell

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

" Remove 80 char line from temporary windows
au BufReadPost quickfix setlocal colorcolumn=0
au BufReadPost quickfix setlocal wrap

""" Plugin configs """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ctrl-p working mode nearest git versioned ancestor
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|tmp'

if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

nnoremap <leader>] :CtrlPTag<cr>

" Always show Airline status
set laststatus=2
let g:airline_powerline_fonts = 0
let g:airline_theme='lucius'
