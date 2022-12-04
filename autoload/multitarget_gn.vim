" multitarget-gn.vim
" Yet another gn command taking a count as a number of operation

" Copyright (c) 2022 Masaaki Nakamura

" This software is released under the MIT License.
" http://opensource.org/licenses/mit-license.php

let s:FALSE = 0
let s:TRUE = 1


let s:in_operate_loop = s:FALSE
function! multitarget_gn#gn(mode) abort
  if @/ is# ''
    return
  endif
  if a:mode is# 'n' || a:mode is# 'x'
    execute printf('normal! %dgn', v:count1)
    return
  endif
  if s:in_operate_loop
    normal! gn
    return
  endif
  let l:count = v:count1
  call s:reserve(a:mode, 'n', l:count)
  normal! gn
endfunction


function! multitarget_gn#gN(mode) abort
  if @/ is# ''
    return
  endif
  if a:mode is# 'n' || a:mode is# 'x'
    execute printf('normal! %dgN', v:count1)
    return
  endif
  if s:in_operate_loop
    normal! gN
    return
  endif
  let l:count = v:count1
  call s:reserve(a:mode, 'N', l:count)
  normal! gN
endfunction


function! s:reserve(mode, n, count) abort
  if a:count <= 1
    return
  endif
  let s:n = a:n
  let s:count = a:count
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
function! s:operate() abort
  let s:in_operate_loop = s:TRUE
  try
    for _ in range(s:count - 1)
      execute 'normal! ' .. s:n
      undojoin
      normal! .
    endfor
  catch /^Vim\%((\a\+)\)\=:E\%(35\|384\|385\|486\):/
  finally
    let s:in_operate_loop = s:FALSE
  endtry
endfunction

" vim:set ts=2 sts=2 sw=2:
