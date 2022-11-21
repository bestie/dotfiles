let s:cpo_save = &cpo
set cpo&vim

" let g:rubyfmt_path = system('which rubyfmt')
let g:rubyfmt_path = "/Users/stephenbest/bin/rubyfmt"
let g:rubyfmt_enable_logs = 1
let g:rubyfmt_log_file = "/tmp/rubyfmt.log"

function! rubyfmt#format()
  call rubyfmt#log("")
  call rubyfmt#log("")
  call rubyfmt#log("")
  call rubyfmt#log("Running new format on " . expand('%'))

  " let l:bin_args = [g:rubyfmt_path, '-i', '--header-opt-out', '--silence-update-message', '--include-git-ignored']
  let l:bin_args = [g:rubyfmt_path, '-i']
  let l:curw = winsaveview()
  let l:tmpname = "/tmp/bees.rb"
  call writefile(rubyfmt#get_lines(), l:tmpname)

  let l:orig_column_corsor_position = col('.')
  let l:orig_line_cursor_position = line('.')
  let l:orig_file_line_count = line('$')
  call rubyfmt#log("rubyfmt path = " . g:rubyfmt_path)
  call rubyfmt#log("Current cursor position: " . l:orig_line_cursor_position .  " " . l:orig_column_corsor_position)

  let [l:out, l:err] = rubyfmt#run(l:bin_args, l:tmpname, expand('%'))
  let l:formatted_file_line_count = len(readfile(l:tmpname))
  let l:line_count_difference = l:orig_file_line_count - l:formatted_file_line_count

  if l:err == 0
    call rubyfmt#log("Format successful, updating file on disk")
    call rubyfmt#update_file(l:tmpname, expand('%'))
  else
    let l:message = "Error formatting (" . l:err . ") rubyfmt said `" . l:out. "`"
    call rubyfmt#log(l:message)
    echom l:message
  endif

  " call delete(l:tmpname)
  call winrestview(l:curw)

  " make niave cursor position guess and move the cursor there
  let l:new_cursor_line_position = l:orig_line_cursor_position + l:line_count_difference
  let l:new_cursor_column_position = l:orig_column_corsor_position + (len(getline(l:new_cursor_line_position)) - len(l:orig_line_cursor_position))
  call rubyfmt#log("Moving cursor to hopefully not terrible position: " .  l:new_cursor_line_position . " " . l:new_cursor_column_position)
  call cursor(l:new_cursor_line_position, l:new_cursor_column_position)

  syntax sync fromstart
endfunction

function! rubyfmt#update_file(source, target) abort
  try | silent undojoin | catch | endtry

  let old_fileformat = &fileformat
  if exists("*getfperm")
    let original_fperm = getfperm(a:target)
  endif

  call rename(a:source, a:target)
  if exists("*setfperm") && original_fperm != ''
    call setfperm(a:target, original_fperm)
  endif

  silent edit!
  let &fileformat = old_fileformat
  let &syntax = &syntax
endfunction

function! rubyfmt#run(bin_args, source, target) abort
  if a:source == ''
    return
  endif
  if a:target == ''
  call rubyfmt#log("run target: `". target . "`")
    return
  endif

  let command = join(a:bin_args + [" -- ", a:source], " ")
  call rubyfmt#log("Running command: `". command . "`")
  let s:res = system(command)

  return [s:res, v:shell_error]
endfunction

function! rubyfmt#get_lines() abort
  let buf = getline(1, '$')
  return buf
endfunction

function! rubyfmt#exec(cmd, ...) abort
  if len(a:cmd) == 0
endfunction

function! rubyfmt#show_errors(errors) abort
  echom a:errors
endfunction

function! rubyfmt#log(lines)
  if !g:rubyfmt_enable_logs
    return
  endif

  if type(a:lines) == type([])
    let l:lines = a:lines
  else
    let l:lines = [a:lines]
  endif

  let l:time = strftime("%Y-%m-%d %H:%M:%S")
  for log_line in l:lines
    call writefile([l:time . "    " . log_line], g:rubyfmt_log_file, "a")
  endfor
endfunction

if !exists("s:rubyfmt_ac_set")
  let s:rubyfmt_ac_set=1
  autocmd FileType ruby autocmd! BufWritePre <buffer> call rubyfmt#format()
endif

let &cpo = s:cpo_save
unlet s:cpo_save
