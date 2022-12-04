" Yet another gn command taking a count as a number of operation
" Maintainer : Masaaki Nakamura
" License    : MIT

" Copyright (c) 2022 Masaaki Nakamura

" This software is released under the MIT License.
" http://opensource.org/licenses/mit-license.php

if &compatible || exists("g:loaded_multitarget_gn")
  finish
endif
let g:loaded_multitarget_gn = 1

" keymappings
nnoremap <silent> <Plug>(multitarget-gn-gn) :<C-u>call multitarget_gn#gn('n')<CR>
onoremap <silent> <Plug>(multitarget-gn-gn) :<C-u>call multitarget_gn#gn('o')<CR>
xnoremap <silent> <Plug>(multitarget-gn-gn) :<C-u>call multitarget_gn#gn('x')<CR>

nnoremap <silent> <Plug>(multitarget-gn-gN) :<C-u>call multitarget_gn#gN('n')<CR>
onoremap <silent> <Plug>(multitarget-gn-gN) :<C-u>call multitarget_gn#gN('o')<CR>
xnoremap <silent> <Plug>(multitarget-gn-gN) :<C-u>call multitarget_gn#gN('x')<CR>
