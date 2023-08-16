""" Vundle """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" for the editor itself
Plugin 'gmarik/Vundle.vim'
Plugin 'Solarized'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'tpope/vim-rsi'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-dispatch'
Plugin 'airblade/vim-gitgutter'
Plugin 'mbbill/undotree'
Plugin 'jremmen/vim-ripgrep'

" for general text editing
Plugin 'tComment'
Plugin 'endwise.vim'
Plugin 'surround.vim'
Plugin 'abolish.vim'
Plugin 'terryma/vim-multiple-cursors'

" language specific
Plugin 'haskell.vim'
Plugin 'rust-lang/rust.vim'
Plugin 'slim-template/vim-slim.git'
Plugin 'dag/vim-fish'

call vundle#end()
filetype plugin indent on

let g:dispatch_compilers = {
      \ 'latex': 'tex',
      \ 'bundle exec': ''}

""" Settings """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let mapleader = "\<Space>"

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
set nobackup
set undodir=~/.vim/undodir
set undofile
set showcmd
set cmdheight=1
set wildmode=list:longest,full
set scrolloff=8               " keep at least 5 lines above/below
set sidescrolloff=8           " keep at least 5 lines left/right
set textwidth=0

set path+=./lib
set path+=./spec
set ttyfast                   " Apparently terminals are fast
set noerrorbells              " @andrewmcdonough does not like bells
set fileformats=unix
set shell=sh
set hidden
set mouse=a
set ttymouse=xterm2
set virtualedit=block,insert,onemore " all also works
" set mousemoveevent

" Allow backspacing over autoindent, eol and start of lines
set backspace=indent,eol,start

set t_Co=256                        " force vim to use 256 color

" starting colorscheme
colorscheme calmar256-dark

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

" Resize horizontal splits more easily and bigger increments
nmap <silent> <c-w>. :vertical resize +5<CR>
nmap <silent> <c-w>, :vertical resize -5<CR>
" Resize vertical splits with the same keys but bigger increments
nmap <silent> <c-w>+ :resize +3<CR>
nmap <silent> <c-w>- :resize -3<CR>

" Use the old vim regex engine (version 1, as opposed to version 2, which was
" introduced in Vim 7.3.969). The Ruby syntax highlighting is significantly
" slower with the new regex engine.
" https://github.com/garybernhardt/dotfiles/commit/99b7d2537ad98dd7a9d3c82b8775f0de1718b356#diff-4e12c6a37ff2cbb2c93d1b33324a6051
set re=1

" Enable project specific configurations, allowing safe commands only
set exrc
set secure

" Autocomplete with dictionary words when spell check is on
set complete+=kspell
set completeopt=menuone,noinsert,noselect

" Make file browsing nicer
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altfile = 1
let g:netrw_altv = 1
let g:netrw_browse_split = 2 "s1 hs, 2 vs, 3 tab, 4 previous window
let g:netrw_list_hide = &wildignore " Nothing to hide

" unobtrusive whitespace highlighting
" http://blog.kamil.dworakowski.name/2009/09/unobtrusive-highlighting-of-trailing.html
highlight ExtraWhitespace ctermbg=red guibg=red
au ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
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

" Abolish aliases that make more sense to me
nmap cr_ crs<left> " snake_case
nmap crC crm<left> " MixedCase or UpperCamalCase

nmap - f_
nmap _ F_

""" Sick functions and macros """""""""""""""""""""""""""""""""""""""""""""""""

command! -nargs=1 -complete=customlist,dispatch#command_complete CMD :call RunCommand(<q-args>)
nmap <leader>x :CMD<space>

" Open and reload vimrc
map <leader>vrc :edit $MYVIMRC<cr>
map <leader>vsrc :source $MYVIMRC<cr>:echo "VIMRC reloaded"<cr>

" Rename current file
map <leader>n :call RenameFile()<cr>

" Unjoin
map <leader>j :s/[,\(\[\{]/&\r/g<cr>:s/[\)\]\}]/\r&/g<cr>=%:nohl<cr>

" Highlight word under cursor without advancing the search
map <leader>8 "syiw<esc>:let @/ = @s<cr>

" It's just mv. Thanks @fables-tales (circa 2014 😀)
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', old_name, 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

function! ToggleDarkMode()
  if g:dark_mode
    let g:dark_mode = 0
    set background=light
    colorscheme calmar256-light
    highlight ColorColumn ctermbg=226
  else
    let g:dark_mode = 1
    set background=dark
    colorscheme calmar256-dark
    " highlight ColorColumn ctermbg=84
  end
endfunction

map <leader>d :call ToggleDarkMode()<cr>
let g:dark_mode = 0
call ToggleDarkMode()

""" Ruby specific things

" rubyfmt
map <leader>rf :%!rubyfmt<cr>
source /Users/stephenbest/.vim/bundle/rubyfmt.vim

map <leader>ct :call RefreshRubyCTags()<cr>

" Run all specs
map <leader>ra :call RunCommand("bundle exec rspec --force-color")<cr>

" Ruby binding pry - insert binding.pry on the line above
map <leader>rbp Orequire "pry"; binding.pry # DEBUG @bestie

" Ruby tap and pry
map <leader>rtp o.tap { \|o\| "DEBUG @bestie"; require "pry"; binding.pry }<esc>

function! RefreshRubyCTags()
  if !(bufname("%") =~ '\*.rb\')
    let result = system("tmux split-window -d -l2 'ctags -R  --languages=ruby --exclude=.git --exclude=log && echo \"tags generated 🏷🥳 \" || echo \"Error generating tags 😭\" && sleep 2'")
  endif
endfunction

" Execute the current file, detects tests, always opens the quickfix window
map <leader>e :w<esc>:call ExecuteFile(expand("%"), &filetype)<cr>

" Same as above but 't' for test, I just like to press t sometimes
map <leader>t :w<cr>:call ExecuteFile(expand('%'), &filetype)<cr>

" Test at line, as above but appends the cursor position to the command
map <leader>l :w<cr>:call RunTestAtLine(expand('%'), line("."))<cr>

" Repeats the previous test run / file execution
map <leader><leader> :w<cr>:call RepeatLatestCommand()<cr>

" Ruby open spec, infer spec file for current file and open
map <leader>ros :call EditFile(InferSpecFile(expand('%')))<cr>

" Generate Ruby classes with a bit less typing
map <leader>rc :%!ruby-class-generator<cr>
vmap <leader>rc :!ruby-class-generator<cr>

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
    let command = BundlerPrefix() . "rspec --force-color " . filename
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
    if exists("g:tmux_run_in_target_pane")
      call TMUX_RunInTargetTmuxPane(a:command)
    else
      exec "Dispatch " . a:command
    endif
  else
    echo "No command to run"
  endif
endfunction

" This probably isn't necessary but I have no idea what I'm doing
function! EditFile(filename)
  exec "e " . a:filename
endfunction

""" tmux things """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This is all about generating a command within Vim and sending it to a second
" tmux pane. This is often better than Dispatch, especially for more complex
" situations.
"
" The 'target' pane is the just one I open after the one I'm editing in.
" Hacky, but 99% of the time it works every time.

map <leader>op :call TMUX_ToggleRunInTargetTmuxPane()<cr>
map <pageup> :call TMUX_ScrollTargetTmuxPane("PageUp")<cr>
map <pagedown> :call TMUX_ScrollTargetTmuxPane("PageDown")<cr>
nmap <leader><Up> :w<cr>:call TMUX_UpEnter()<cr>

if !exists("g:tmux_run_in_target_pane")
  let g:tmux_run_in_target_pane = 0
endif
if !exists("g:tmux_target_pane")
  let g:tmux_target_pane = { }
endif

function! TMUX_RunInTargetTmuxPane(command)
  let pane_number = g:tmux_target_pane['uid']

  let cmd = a:command
  " ctrl+c will not quit interactive programs like irb so try q, enter first.
  " the leading space prevents shell history filling up with q characters.
  call system("tmux send-keys -t" . pane_number . " ' 'q ENTER C-c")
  call system("tmux send-keys -t" . pane_number . " '" . cmd . "' ENTER")
  if v:shell_error != 0
    echom "Error targeting tmux pane with index `" . pane_number
    echom "tmux says: `" . result
    call TMUX_ToggleRunInTargetTmuxPane()
    return
  endif
endfunction

" Manually set the target pane
function! TMUX_UserSetPane()
  echo 'Select target pane by index:'
  echo join(map(split(system('tmux list-panes |grep -v active'), "\n"), { _i,line -> "    " . line }))
  let selected_index = input(" -> ")
  let pane = filter(TMUX___GetPanes(), { _i,pane_info -> pane_info['index'] == selected_index })[0]
  call TMUX___GivePaneSomeSparkles(pane['uid'])
  let g:tmux_target_pane = pane
endfunction

" Send Page up and down to the target tmux pane
function! TMUX_ScrollTargetTmuxPane(page_key)
  let pane_number = g:tmux_target_pane['uid']
  let result = system("tmux copy-mode -t" . pane_number . " -e")
  let _x = system("tmux send-keys -t" . pane_number . " " . a:page_key)
endfunction

" Send up enter to the target pane
function! TMUX_UpEnter()
  let pane_number = g:tmux_target_pane['uid']
  call system("tmux send-keys -t" . pane_number . " C-c Up ENTER")
endfunction

" Toggle feature, creates a new pane if non target pane is set
function! TMUX_ToggleRunInTargetTmuxPane()
  if g:tmux_run_in_target_pane == 1
    let g:tmux_run_in_target_pane = 0
    echo "Running in tmux split is disabled"
  else
    let g:tmux_run_in_target_pane = 1
    if has_key(g:tmux_target_pane, 'uid') && TMUX___CheckPaneExists(g:tmux_target_pane['uid'])
    else
      call TMUX___CreateNewTmuxPane()
    endif
    echo "Running in tmux split is enabled (using " . g:tmux_target_pane['index'] ." uid=" . g:tmux_target_pane['uid'] . ")"
  endif
  return
endfunction

function! TMUX___CheckPaneExists(uid)
  let list_pane_uids_cmd = 'tmux list-panes -F "#{pane_id}"| grep ' . a:uid
  let result = system(list_pane_uids_cmd)
  return(result != "")
endfunction

function! TMUX___CreateNewTmuxPane()
  let create_split_window_cmd = 'tmux split-window -hdP -F "#{pane_id} #{pane_index} #{pane_tty}" -c "$(pwd)"'
  let result = system(create_split_window_cmd)
  let fields = split(result, " ")
  let g:tmux_target_pane = { 'uid': fields[0], 'index': fields[1], 'tty_dev': fields[2] }
  call TMUX___GivePaneSomeSparkles(g:tmux_target_pane['uid'])
  return g:tmux_target_pane
endfunction

function! TMUX___GivePaneSomeSparkles(pane_id)
  let get_border_format = 'tmux show-option -g pane-border-format'
  let tmux_border_format = system(get_border_format)
  let tmux_border_format = substitute(tmux_border_format, '#P', '✨#P', '')
  call system("tmux set-option -p -t" . a:pane_id . " " . tmux_border_format)
endfunction

function! TMUX___GetPanes()
  let list_panes_cmd = 'tmux list-panes -F "#{pane_id} #{pane_index} #{pane_tty} #{pane_active}"'
  let cmd_output = system(list_panes_cmd)
  let pane_list = split(cmd_output, "\n")
  call map(pane_list, { k,v -> split(v, " ")})
  call map(pane_list, { _i,row -> { 'uid': row[0], 'index': row[1], 'tty_dev': row[2], 'active': row[3] } })
  return pane_list
endfunction

""" Key remaps (standard stuff) """""""""""""""""""""""""""""""""""""""""""""""

" %% For current directory thanks @squil
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Turn search highlighting off
map <leader>/ :noh<CR>

" Save with CTRL-s
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>

" Copy and paste from system clipboard
vmap <leader>y "+y
nmap <leader>y "+yy
nmap <leader>Y "+y$
nmap <leader>p "+p
vmap <leader>p "+p
nmap <leader>P "+P

nmap Y y$

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

nmap <c-p> :Files<cr>
nmap <leader>rg :Rg<space>
nmap <leader>b :Buffer<cr>
nmap [b :bprevious<cr>
nmap ]b :bnext<cr>
nmap [B :bfirst<cr>
nmap ]B :blast<cr>

""" Syntax highlighting """""""""""""""""""""""""""""""""""""""""""""""""""""""

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Guardfile,Rakefile,Vagrantfile,Thorfile,config.ru,*.jbuilder} set filetype=ruby

" md, markdown, and mk are markdown and define buffer-local preview
au BufRead,BufNewFile *.{md,markdown} set filetype=markdown

" Spell checking for text formats
au BufRead,BufNewFile *.txt,*.md,*.markdown,*.textile,*.feature setlocal spell
autocmd FileType gitcommit setlocal spell

" Default action should save and reload vimrc when editing a vim file
autocmd FileType vim nnoremap <leader><leader> :w<cr>:source $MYVIMRC<cr>:echom "vimrc reloaded"<cr>

" add json syntax highlighting
au BufNewFile,BufRead *.json set ft=javascript

" Remove 80 char line from temporary windows
au BufReadPost quickfix setlocal colorcolumn=0
au BufReadPost quickfix setlocal wrap

nnoremap <leader>q :call QuickfixToggle()<cr><cr>

let g:quickfix_is_open = 0

function! QuickfixToggle()
	if g:quickfix_is_open
		cclose
		let g:quickfix_is_open = 0
		execute g:quickfix_return_to_window . "wincmd w"
	else
		let g:quickfix_return_to_window = winnr()
		copen
		let g:quickfix_is_open = 1
	endif
endfunction

""" Plugin configs """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Always show Airline status
set laststatus=2
let g:airline_powerline_fonts = 0
let g:airline_theme='lucius'
