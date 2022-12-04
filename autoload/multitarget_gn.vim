" multitarget-gn.vim
" Yet another gn command taking a count as a number of operation

" Copyright (c) 2022 Masaaki Nakamura

" This software is released under the MIT License.
" http://opensource.org/licenses/mit-license.php

let s:FALSE = 0
let s:TRUE = 1
let s:NULLPOS = [0, 0, 0, 0]

let s:textprop_id = 0
let s:TEXTPROP_NAME = 'multitarget-gn'
silent! call prop_type_add(s:TEXTPROP_NAME, {})


function! multitarget_gn#gn(mode) abort
  if @/ is# ''
    return
  endif
  let l:count = v:count1
  if a:mode is# 'n' || a:mode is# 'x'
    execute printf('normal! %dgn', l:count)
    return
  endif
  let l:targets = s:gather_targets('gn', 'n', l:count)
  if l:targets == []
    return
  endif
  let l:last_target = remove(l:targets, -1)
  let l:marks = s:set_marks(l:last_target)
  call s:operate_on_targets(v:operator, l:targets)
  let [l:head, l:tail] = s:get_marks(l:marks)
  if l:head != s:NULLPOS && l:tail != s:NULLPOS
    call s:select(l:head, l:tail)
  endif
endfunction


function! multitarget_gn#gN(mode) abort
  if @/ is# ''
    return
  endif
  let l:count = v:count1
  if a:mode is# 'n' || a:mode is# 'x'
    execute printf('normal! %dgN', l:count)
    return
  endif
  let l:targets = s:gather_targets('gN', 'N', l:count)
  if l:targets == []
    return
  endif
  let l:last_target = remove(l:targets, -1)
  let l:marks = s:set_marks(l:last_target)
  call s:operate_on_targets(v:operator, l:targets)
  let [l:head, l:tail] = s:get_marks(l:marks)
  if l:head != s:NULLPOS && l:tail != s:NULLPOS
    call s:select(l:head, l:tail)
  endif
endfunction


function! s:gather_targets(gn, nextcmd, count) abort
  if search(@/, 'cn') == 0
    return []
  endif
  let l:view = winsaveview()
  try
    execute "normal! " .. a:gn
    execute "normal! \<Esc>"
    let l:head = getpos("'<")
    let l:tail = getpos("'>")
    let l:first_head = l:head
    let l:targets = [[l:head, l:tail]]
    for l:i in range(a:count - 1)
      try
        execute "normal! " .. a:nextcmd
      catch /^Vim\%((\a\+)\)\=:E38[45]:/
        break
      endtry
      execute "normal! " .. a:gn
      execute "normal! \<Esc>"
      let l:head = getpos("'<")
      let l:tail = getpos("'>")
      if l:head == l:first_head
        break
      endif
      call add(l:targets, [l:head, l:tail])
    endfor
  finally
    call winrestview(l:view)
  endtry
  return l:targets
endfunction


function! s:operate_on_targets(operator, targets) abort
  let l:sorted_targets = sort(copy(a:targets), 's:compare_positions')
  for [l:head, l:tail] in l:sorted_targets
    call s:select(l:head, l:tail)
    execute 'normal! ' .. a:operator
  endfor
endfunction


function! s:select(head, tail) abort
  normal! v
  call setpos('.', a:head)
  normal! o
  call setpos('.', a:tail)
endfunction


function! s:compare_positions(i1, i2) abort
  let l:head1 = a:i1[0]
  let l:head2 = a:i2[0]
  let l:lnum1 = l:head1[1]
  let l:lnum2 = l:head2[1]
  if l:lnum1 != l:lnum2
    return l:lnum2 - l:lnum1
  endif
  let l:col1 = l:head1[2]
  let l:col2 = l:head2[2]
  return l:col2 - l:col1
endfunction


function! s:set_marks(target) abort
  let [l:head, l:tail] = a:target
  let l:headprops = s:set_a_mark(l:head)
  let l:tailprops = s:set_a_mark(l:tail)
  return [l:headprops, l:tailprops]
endfunction


function! s:set_a_mark(pos) abort
  let l:id = s:textprop_id
  let s:textprop_id += 1
  let l:prop = {
  \   'type': s:TEXTPROP_NAME,
  \   'id': l:id,
  \ }
  call prop_add(a:pos[1], a:pos[2], l:prop)
  return {
  \   'type': s:TEXTPROP_NAME,
  \   'id': l:id,
  \   'both': s:TRUE,
  \   'lnum': a:pos[1],
  \   'col': a:pos[2],
  \ }
endfunction


function! s:get_marks(propslist) abort
  let [l:headprops, l:tailprops] = a:propslist
  let l:head = s:get_a_mark(l:headprops)
  let l:tail = s:get_a_mark(l:tailprops)
  return [l:head, l:tail]
endfunction


function! s:get_a_mark(props) abort
  let l:props = copy(a:props)
  if l:props.lnum <= line('$')
    let l:p = prop_find(l:props, 'f')
    if l:p != {}
      return [0, l:p.lnum, l:p.col, 0]
    endif
    " Retry from the beginning of the same line
    let l:props.col = 1
    let l:p = prop_find(l:props, 'f')
    if l:p != {}
      return [0, l:p.lnum, l:p.col, 0]
    endif
  endif
  " Retry from the beginning of the buffer
  let l:props.lnum = 1
  let l:props.col = 1
  let l:p = prop_find(l:props, 'f')
  if l:p != {}
    return [0, l:p.lnum, l:p.col, 0]
  endif
  return s:NULLPOS
endfunction

" vim:set ts=2 sts=2 sw=2:
