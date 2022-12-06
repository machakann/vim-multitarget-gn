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
  call s:main(a:mode, 'n')
endfunction


function! multitarget_gn#gN(mode) abort
  call s:main(a:mode, 'N')
endfunction


function! s:main(mode, n) abort
  if @/ is# ''
    return
  endif
  let l:count = v:count1
  if a:mode is# 'n'
    call s:normal_mode(a:n, l:count)
  elseif a:mode is# 'x'
    call s:visual_mode(a:n, l:count)
  elseif a:mode is# 'o'
    call s:operator_pending_mode(a:n, l:count)
  endif
endfunction


function! s:normal_mode(n, count) abort
  execute printf('normal! %dg%s', a:count, a:n)
endfunction


function! s:visual_mode(n, count) abort
  if s:a_target_was_selected()
    execute 'normal! ' .. a:n
  endif
  execute printf('normal! %dg%s', a:count, a:n)
endfunction


function! s:operator_pending_mode(n, count) abort
  if s:in_operate_loop
    execute 'normal! g' .. a:n
    return
  endif
  execute 'normal! g' .. a:n
  call s:reserve(a:n, a:count)
endfunction


function! s:a_target_was_selected() abort
  return getpos("'<")[1:2] == searchpos(@/, 'bcn') &&
       \ getpos("'>")[1:2] == searchpos(@/, 'cen')
endfunction


" Set a hook to call s:operate() if the given count is larger than 1
function! s:reserve(n, count) abort
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
