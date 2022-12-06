" multitarget-gn.vim
" Yet another gn command taking a count as a number of operation

" Copyright (c) 2022 Masaaki Nakamura

" This software is released under the MIT License.
" http://opensource.org/licenses/mit-license.php

let s:FALSE = 0
let s:TRUE = 1
let s:NULLPOS = [0, 0]


let s:in_operate_loop = s:FALSE
function! multitarget_gn#gn(mode) abort
  if @/ is# ''
    return
  endif
  if a:mode is# 'n'
    execute printf('normal! %dgn', v:count1)
  elseif a:mode is# 'x'
    if s:a_target_was_selected()
      normal! n
    endif
    execute printf('normal! %dgn', v:count1)
  elseif a:mode is# 'o'
    if s:in_operate_loop
      normal! gn
      return
    endif
    let l:count = v:count1
    normal! gn
    call s:reserve(a:mode, 'n', l:count)
  endif
endfunction


function! multitarget_gn#gN(mode) abort
  if @/ is# ''
    return
  endif
  if a:mode is# 'n'
    execute printf('normal! %dgN', v:count1)
  elseif a:mode is# 'x'
    if s:a_target_was_selected()
      normal! N
    endif
    execute printf('normal! %dgN', v:count1)
  elseif a:mode is# 'o'
    if s:in_operate_loop
      normal! gN
      return
    endif
    let l:count = v:count1
    normal! gN
    call s:reserve(a:mode, 'N', l:count)
  endif
endfunction


function! s:a_target_was_selected() abort
  return getpos("'<")[1:2] == searchpos(@/, 'bcn') &&
       \ getpos("'>")[1:2] == searchpos(@/, 'cen')
endfunction


" Set a hook to call s:operate() if the given count is larger than 1
function! s:reserve(mode, n, count) abort
  if a:count <= 1
    return
  endif
  let s:n = a:n
  let s:count = a:count
  let s:mark = s:set_mark()
  augroup multitarget-gn
    autocmd!
    if v:operator is# 'c'
      autocmd InsertLeave <buffer> ++once call s:operate()
    else
      autocmd SafeState <buffer> ++once call s:operate()
    endif
  augroup END
endfunction


let s:count = 1
let s:n = ''
let s:mark = {}
" Repeat the operation for the rest of targets
function! s:operate() abort
  let l:mark = s:mark
  let s:in_operate_loop = s:TRUE
  try
    for _ in range(s:count - 1)
      call s:go_to_mark(l:mark)
      execute 'normal! ' .. s:n
      let l:mark = s:set_mark()
      undojoin
      " NOTE: This is intentional use of 'normal' command without bang for
      "       plugins like repeat.vim
      normal .
    endfor
  catch /^Vim\%((\a\+)\)\=:E\%(35\|384\|385\|486\):/
  finally
    let s:in_operate_loop = s:FALSE
  endtry
endfunction


let s:TEXTPROP_NAME = 'multitarget-gn'
let s:textprop_id = 0
call prop_type_add(s:TEXTPROP_NAME, {})
" Mark the current cursor position
function! s:set_mark() abort
  let l:lnum = line('.')
  let l:col = col('.')
  let l:id = s:textprop_id
  let s:textprop_id += 1
  call prop_add(l:lnum, l:col, {'type': s:TEXTPROP_NAME, 'id': l:id})
  return {
  \   'type': s:TEXTPROP_NAME,
  \   'id': l:id,
  \   'both': s:TRUE,
  \   'lnum': l:lnum,
  \   'col': 1,
  \ }
endfunction


" Move the cursor to the position marked by s:set_mark()
function! s:go_to_mark(props) abort
  if a:props == {}
    return
  endif
  let l:prop = prop_find(a:props, 'f')
  if l:prop == {}
    let l:prop = prop_find(a:props, 'b')
    if l:prop == {}
      return
    endif
  endif
  let l:lnum = l:prop.lnum
  let l:col = l:prop.col
  call prop_remove(a:props, l:lnum)
  call cursor(l:lnum, l:col)
endfunction

" vim:set ts=2 sts=2 sw=2:
