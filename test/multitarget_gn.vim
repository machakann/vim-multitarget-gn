scriptencoding utf-8
let s:assert = themis#helper('assert')
let s:suite = themis#suite('multitarget-gn')


function! s:put_test_string() abort "{{{
  let l:test_string =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  %delete
  call setline(1, l:test_string)
endfunction "}}}

function! s:suite.before_each() abort "{{{
  set smartcase&
  set wrapscan&
endfunction "}}}



function! s:suite.gn_o_first_call() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(2, 1)
  execute "normal d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux..bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(3, 1)
  execute "normal d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux..bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #3')
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #3')



  call s:put_test_string()
  /foo
  call cursor(4, 1)
  execute "normal d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #4')
  call s:assert.equals(getpos('.'), [0, 4, 12, 0], 'failed at #4')
endfunction "}}}

function! s:suite.gn_o_first_call_with_count() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 1d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal d1\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 2d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #3')
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #3')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal d2\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #4')
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #4')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 3d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #5')
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #5')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal d3\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #6')
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #6')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 4d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #7')
  call s:assert.equals(getpos('.'), [0, 4, 12, 0], 'failed at #7')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal d4\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #8')
  call s:assert.equals(getpos('.'), [0, 4, 12, 0], 'failed at #8')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 5d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #9')
  call s:assert.equals(getpos('.'), [0, 4, 12, 0], 'failed at #9')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal d5\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #10')
  call s:assert.equals(getpos('.'), [0, 4, 12, 0], 'failed at #10')



  call s:put_test_string()
  /foo\|bar
  call cursor(1, 1)
  execute "normal d2\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    ..baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #11')
  call s:assert.equals(getpos('.'), [0, 1, 2, 0], 'failed at #11')



  call s:put_test_string()
  /foo\|bar
  call cursor(1, 1)
  execute "normal d3\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    ..baz.qux
    qux..bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #12')
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #12')



  call s:put_test_string()
  /qux\nqux\|baz\nbaz\|bar\nbar
  call cursor(1, 1)
  execute "normal d3\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz..foo.bar..qux.foo..baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #13')
  call s:assert.equals(getpos('.'), [0, 1, 31, 0], 'failed at #13')
endfunction "}}}

function! s:suite.gn_o_dot_call() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  normal! .
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 2d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  normal! .
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 4, 12, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  normal! 2.
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #3')
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #3')
endfunction "}}}

function! s:suite.gn_o_wrapscan() abort "{{{
  call s:put_test_string()
  /foo
  set wrapscan
  call cursor(4, 1)
  execute "normal 2d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  set wrapscan
  call cursor(3, 1)
  execute "normal d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  normal! 2.
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux.foo.bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #2')



  call s:put_test_string()
  /^foo
  set nowrapscan
  call cursor(1, 1)
  execute "normal d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #3')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #3')
endfunction "}}}

function! s:suite.gn_o_c_operator() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal c\<Plug>(multitarget-gn-gn)quux"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    quux.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 2c\<Plug>(multitarget-gn-gn)quux"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    quux.bar.baz.qux
    qux.quux.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 2, 8, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 3c\<Plug>(multitarget-gn-gn)quux"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    quux.bar.baz.qux
    qux.quux.bar.baz
    baz.qux.quux.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #3')
  call s:assert.equals(getpos('.'), [0, 3, 12, 0], 'failed at #3')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 4c\<Plug>(multitarget-gn-gn)quux"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    quux.bar.baz.qux
    qux.quux.bar.baz
    baz.qux.quux.bar
    bar.baz.qux.quux
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #4')
  call s:assert.equals(getpos('.'), [0, 4, 16, 0], 'failed at #4')
endfunction "}}}

function! s:suite.gn_o_gU_with_smartcase() abort "{{{
  call s:put_test_string()
  /foo
  set smartcase
  call cursor(1, 1)
  execute "normal 2gU\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    FOO.bar.baz.qux
    qux.FOO.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  set smartcase
  call cursor(1, 1)
  execute "normal 3gU\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    FOO.bar.baz.qux
    qux.FOO.bar.baz
    baz.qux.FOO.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  set smartcase
  call cursor(1, 1)
  execute "normal 4gU\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    FOO.bar.baz.qux
    qux.FOO.bar.baz
    baz.qux.FOO.bar
    bar.baz.qux.FOO
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #3')
  call s:assert.equals(getpos('.'), [0, 4, 13, 0], 'failed at #3')
endfunction "}}}

" function! s:suite.gn_o_insert_operator() abort "{{{
"   " An operator inserting 'foo' before the specified region
"   function! s:operator_insert_foo(wise) abort
"     normal! `[ifoo
"   endfunction
"   function! s:operator_insert_foo_keymap() abort
"     set operatorfunc=funcref('s:operator_insert_foo')
"     return 'g@'
"   endfunction
"   nnoremap <expr> <Plug>(multitarget-gn-operator-insert-foo) <SID>operator_insert_foo_keymap()


"   call s:put_test_string()
"   /foo
"   call cursor(1, 1)
"   execute "normal 3\<Plug>(multitarget-gn-operator-insert-foo)\<Plug>(multitarget-gn-gn)"
"   silent! doautocmd multitarget-gn SafeState
"   let l:expect =<< trim END
"     foofoo.bar.baz.qux
"     qux.foofoo.bar.baz
"     baz.qux.foofoo.bar
"     bar.baz.qux.foo
"   END
"   call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
"   call s:assert.equals(getpos('.'), [0, 3, 11, 0], 'failed at #1')


"   call s:put_test_string()
"   /foo
"   call cursor(1, 1)
"   execute "normal 4\<Plug>(multitarget-gn-operator-insert-foo)\<Plug>(multitarget-gn-gn)"
"   silent! doautocmd multitarget-gn SafeState
"   let l:expect =<< trim END
"     foofoo.bar.baz.qux
"     qux.foofoo.bar.baz
"     baz.qux.foofoo.bar
"     bar.baz.qux.foofoo
"   END
"   call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
"   call s:assert.equals(getpos('.'), [0, 4, 15, 0], 'failed at #2')
" endfunction "}}}

function! s:suite.gn_o_surround_operator() abort "{{{
  " An operator surround the specified region by parentheses
  function! s:operator_surround(wise) abort
    let l:head = getpos("'[")
    normal! `]a)
    call setpos('.', l:head)
    normal! i(
  endfunction
  function! s:operator_surround_keymap() abort
    set operatorfunc=funcref('s:operator_surround')
    return 'g@'
  endfunction
  nnoremap <expr> <Plug>(multitarget-gn-operator-surround) <SID>operator_surround_keymap()


  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 3\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    (foo).bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #1')


  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 4\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    (foo).bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.(foo)
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 4, 13, 0], 'failed at #2')


  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    (foo).bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.(foo)
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #3')
  call s:assert.equals(getpos('.'), [0, 4, 13, 0], 'failed at #3')


  call s:put_test_string()
  /foo
  call cursor(1, 1)
  set nowrapscan
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    (foo).bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.(foo)
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #4')
  call s:assert.equals(getpos('.'), [0, 4, 13, 0], 'failed at #4')


  call s:put_test_string()
  /foo
  call cursor(1, 3)
  set nowrapscan
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    (foo).bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.(foo)
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #5')
  call s:assert.equals(getpos('.'), [0, 4, 13, 0], 'failed at #5')


  call s:put_test_string()
  /foo
  call cursor(1, 4)
  set nowrapscan
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.(foo)
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #6')
  call s:assert.equals(getpos('.'), [0, 4, 13, 0], 'failed at #6')


  call s:put_test_string()
  /foo
  call cursor(2, 1)
  set nowrapscan
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.(foo)
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #7')
  call s:assert.equals(getpos('.'), [0, 4, 13, 0], 'failed at #7')


  call s:put_test_string()
  /foo
  call cursor(2, 5)
  set nowrapscan
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.(foo)
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #8')
  call s:assert.equals(getpos('.'), [0, 4, 13, 0], 'failed at #8')


  call s:put_test_string()
  /foo
  call cursor(2, 7)
  set nowrapscan
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.(foo)
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #9')
  call s:assert.equals(getpos('.'), [0, 4, 13, 0], 'failed at #9')


  call s:put_test_string()
  /foo
  call cursor(2, 8)
  set nowrapscan
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.(foo)
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #10')
  call s:assert.equals(getpos('.'), [0, 4, 13, 0], 'failed at #10')
endfunction "}}}

function! s:suite.gn_o_failure() abort "{{{
  call s:put_test_string()
  let @/ = ''
  call cursor(1, 1)
  execute "normal d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #1')



  call s:put_test_string()
  let @/ = 'quux'
  call cursor(1, 1)
  execute "normal d\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #2')
endfunction "}}}

function! s:suite.gn_n_select() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal \<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #1')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #1')
  call s:assert.equals(getpos("'<"), [0, 1, 1, 0], 'failed at #1')
  call s:assert.equals(getpos("'>"), [0, 1, 3, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(2, 1)
  execute "normal \<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #2')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 2, 7, 0], 'failed at #2')
  call s:assert.equals(getpos("'<"), [0, 2, 5, 0], 'failed at #2')
  call s:assert.equals(getpos("'>"), [0, 2, 7, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(3, 1)
  execute "normal \<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #3')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 3, 11, 0], 'failed at #3')
  call s:assert.equals(getpos("'<"), [0, 3, 9, 0], 'failed at #3')
  call s:assert.equals(getpos("'>"), [0, 3, 11, 0], 'failed at #3')



  call s:put_test_string()
  /foo
  call cursor(4, 1)
  execute "normal \<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #4')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 4, 15, 0], 'failed at #4')
  call s:assert.equals(getpos("'<"), [0, 4, 13, 0], 'failed at #4')
  call s:assert.equals(getpos("'>"), [0, 4, 15, 0], 'failed at #4')
endfunction "}}}

function! s:suite.gn_n_select_with_count() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 2\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #1')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 2, 7, 0], 'failed at #1')
  call s:assert.equals(getpos("'<"), [0, 2, 5, 0], 'failed at #1')
  call s:assert.equals(getpos("'>"), [0, 2, 7, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 3\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #2')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 3, 11, 0], 'failed at #2')
  call s:assert.equals(getpos("'<"), [0, 3, 9, 0], 'failed at #2')
  call s:assert.equals(getpos("'>"), [0, 3, 11, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal 4\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #3')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 4, 15, 0], 'failed at #3')
  call s:assert.equals(getpos("'<"), [0, 4, 13, 0], 'failed at #3')
  call s:assert.equals(getpos("'>"), [0, 4, 15, 0], 'failed at #3')
endfunction "}}}

function! s:suite.gn_x_select() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal v\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #1')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #1')
  call s:assert.equals(getpos("'<"), [0, 1, 1, 0], 'failed at #1')
  call s:assert.equals(getpos("'>"), [0, 1, 3, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(2, 1)
  execute "normal v\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #2')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 2, 7, 0], 'failed at #2')
  call s:assert.equals(getpos("'<"), [0, 2, 5, 0], 'failed at #2')
  call s:assert.equals(getpos("'>"), [0, 2, 7, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(3, 1)
  execute "normal v\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #3')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 3, 11, 0], 'failed at #3')
  call s:assert.equals(getpos("'<"), [0, 3, 9, 0], 'failed at #3')
  call s:assert.equals(getpos("'>"), [0, 3, 11, 0], 'failed at #3')



  call s:put_test_string()
  /foo
  call cursor(4, 1)
  execute "normal v\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #4')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 4, 15, 0], 'failed at #4')
  call s:assert.equals(getpos("'<"), [0, 4, 13, 0], 'failed at #4')
  call s:assert.equals(getpos("'>"), [0, 4, 15, 0], 'failed at #4')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal v\<Plug>(multitarget-gn-gn)\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #5')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 2, 7, 0], 'failed at #5')
  call s:assert.equals(getpos("'<"), [0, 2, 5, 0], 'failed at #5')
  call s:assert.equals(getpos("'>"), [0, 2, 7, 0], 'failed at #5')
endfunction "}}}

function! s:suite.gn_x_select_with_count() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal v2\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #1')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 2, 7, 0], 'failed at #1')
  call s:assert.equals(getpos("'<"), [0, 2, 5, 0], 'failed at #1')
  call s:assert.equals(getpos("'>"), [0, 2, 7, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal v3\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #2')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 3, 11, 0], 'failed at #2')
  call s:assert.equals(getpos("'<"), [0, 3, 9, 0], 'failed at #2')
  call s:assert.equals(getpos("'>"), [0, 3, 11, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(1, 1)
  execute "normal v4\<Plug>(multitarget-gn-gn)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #3')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 4, 15, 0], 'failed at #3')
  call s:assert.equals(getpos("'<"), [0, 4, 13, 0], 'failed at #3')
  call s:assert.equals(getpos("'>"), [0, 4, 15, 0], 'failed at #3')
endfunction "}}}


function! s:suite.gN_o_first_call() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(1, 15)
  execute "normal d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(2, 15)
  execute "normal d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux..bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(3, 15)
  execute "normal d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux..bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #3')
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #3')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #4')
  call s:assert.equals(getpos('.'), [0, 4, 12, 0], 'failed at #4')
endfunction "}}}

function! s:suite.gN_o_first_call_with_count() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 1d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 4, 12, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal d1\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 4, 12, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 2d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #3')
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #3')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal d2\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #4')
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #4')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 3d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #5')
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #5')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal d3\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #6')
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #6')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 4d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #7')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #7')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal d4\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #8')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #8')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 5d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #9')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #9')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal d5\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #10')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #10')



  call s:put_test_string()
  /foo\|bar
  call cursor(4, 15)
  execute "normal d2\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    .baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #11')
  call s:assert.equals(getpos('.'), [0, 4, 1, 0], 'failed at #11')



  call s:put_test_string()
  /foo\|bar
  call cursor(4, 15)
  execute "normal d3\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.
    .baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #12')
  call s:assert.equals(getpos('.'), [0, 3, 12, 0], 'failed at #12')



  call s:put_test_string()
  /qux\nqux\|baz\nbaz\|bar\nbar
  call cursor(4, 15)
  execute "normal d3\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz..foo.bar..qux.foo..baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #13')
  call s:assert.equals(getpos('.'), [0, 1, 13, 0], 'failed at #13')
endfunction "}}}

function! s:suite.gN_o_dot_call() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  normal! .
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 2d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  normal! .
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  normal! 2.
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux..bar.baz
    baz.qux..bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #3')
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #3')
endfunction "}}}

function! s:suite.gN_o_wrapscan() abort "{{{
  call s:put_test_string()
  /foo
  set wrapscan
  call cursor(1, 1)
  execute "normal 2d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 4, 12, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  set wrapscan
  call cursor(3, 1)
  execute "normal d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  normal! 2.
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux..bar.baz
    baz.qux.foo.bar
    bar.baz.qux.
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 4, 12, 0], 'failed at #2')



  call s:put_test_string()
  /^foo
  set nowrapscan
  call cursor(1, 1)
  execute "normal d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    .bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #3')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #3')
endfunction "}}}

function! s:suite.gN_o_c_operator() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal c\<Plug>(multitarget-gn-gN)quux"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.quux
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 4, 16, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 2c\<Plug>(multitarget-gn-gN)quux"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.quux.bar
    bar.baz.qux.quux
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 3, 12, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 3c\<Plug>(multitarget-gn-gN)quux"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.quux.bar.baz
    baz.qux.quux.bar
    bar.baz.qux.quux
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #3')
  call s:assert.equals(getpos('.'), [0, 2, 8, 0], 'failed at #3')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 4c\<Plug>(multitarget-gn-gN)quux"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    quux.bar.baz.qux
    qux.quux.bar.baz
    baz.qux.quux.bar
    bar.baz.qux.quux
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #4')
  call s:assert.equals(getpos('.'), [0, 1, 4, 0], 'failed at #4')
endfunction "}}}

function! s:suite.gN_o_gU_with_smartcase() abort "{{{
  call s:put_test_string()
  /foo
  set smartcase
  call cursor(4, 15)
  execute "normal 2gU\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.FOO.bar
    bar.baz.qux.FOO
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  set smartcase
  call cursor(4, 15)
  execute "normal 3gU\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.FOO.bar.baz
    baz.qux.FOO.bar
    bar.baz.qux.FOO
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  set smartcase
  call cursor(4, 15)
  execute "normal 4gU\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    FOO.bar.baz.qux
    qux.FOO.bar.baz
    baz.qux.FOO.bar
    bar.baz.qux.FOO
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #3')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #3')
endfunction "}}}

" function! s:suite.gN_o_insert_operator() abort "{{{
"   " An operator inserting 'foo' before the specified region
"   function! s:operator_insert_foo(wise) abort
"     normal! `[ifoo
"   endfunction
"   function! s:operator_insert_foo_keymap() abort
"     set operatorfunc=funcref('s:operator_insert_foo')
"     return 'g@'
"   endfunction
"   nnoremap <expr> <Plug>(multitarget-gn-operator-insert-foo) <SID>operator_insert_foo_keymap()


"   call s:put_test_string()
"   /foo
"   call cursor(4, 15)
"   execute "normal 3\<Plug>(multitarget-gn-operator-insert-foo)\<Plug>(multitarget-gn-gN)"
"   silent! doautocmd multitarget-gn SafeState
"   let l:expect =<< trim END
"     foo.bar.baz.qux
"     qux.foofoo.bar.baz
"     baz.qux.foofoo.bar
"     bar.baz.qux.foofoo
"   END
"   call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
"   call s:assert.equals(getpos('.'), [0, 2, 7, 0], 'failed at #1')


"   call s:put_test_string()
"   /foo
"   call cursor(4, 15)
"   execute "normal 4\<Plug>(multitarget-gn-operator-insert-foo)\<Plug>(multitarget-gn-gN)"
"   silent! doautocmd multitarget-gn SafeState
"   let l:expect =<< trim END
"     foofoo.bar.baz.qux
"     qux.foofoo.bar.baz
"     baz.qux.foofoo.bar
"     bar.baz.qux.foofoo
"   END
"   call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
"   call s:assert.equals(getpos('.'), [0, 1, 3, 0], 'failed at #2')
" endfunction "}}}

function! s:suite.gN_o_surround_operator() abort "{{{
  " An operator surround the specified region by parentheses
  function! s:operator_surround(wise) abort
    let l:head = getpos("'[")
    normal! `]a)
    call setpos('.', l:head)
    normal! i(
  endfunction
  function! s:operator_surround_keymap() abort
    set operatorfunc=funcref('s:operator_surround')
    return 'g@'
  endfunction
  nnoremap <expr> <Plug>(multitarget-gn-operator-surround) <SID>operator_surround_keymap()


  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 3\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.(foo)
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #1')


  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 4\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    (foo).bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.(foo)
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #2')


  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    (foo).bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.(foo)
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #3')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #3')


  call s:put_test_string()
  /foo
  call cursor(4, 15)
  set nowrapscan
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    (foo).bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.(foo)
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #4')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #4')


  call s:put_test_string()
  /foo
  call cursor(4, 13)
  set nowrapscan
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    (foo).bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.(foo)
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #5')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #5')


  call s:put_test_string()
  /foo
  call cursor(4, 12)
  set nowrapscan
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    (foo).bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #6')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #6')


  call s:put_test_string()
  /foo
  call cursor(3, 15)
  set nowrapscan
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    (foo).bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #7')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #7')


  call s:put_test_string()
  /foo
  call cursor(3, 11)
  set nowrapscan
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    (foo).bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #8')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #8')


  call s:put_test_string()
  /foo
  call cursor(3, 9)
  set nowrapscan
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    (foo).bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.(foo).bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #9')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #9')


  call s:put_test_string()
  /foo
  call cursor(3, 8)
  set nowrapscan
  execute "normal 5\<Plug>(multitarget-gn-operator-surround)\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    (foo).bar.baz.qux
    qux.(foo).bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #10')
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #10')
endfunction "}}}

function! s:suite.gN_o_failure() abort "{{{
  call s:put_test_string()
  let @/ = ''
  call cursor(4, 15)
  execute "normal d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #1')
  call s:assert.equals(getpos('.'), [0, 4, 15, 0], 'failed at #1')



  call s:put_test_string()
  let @/ = 'quux'
  call cursor(4, 15)
  execute "normal d\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  let l:expect =<< trim END
    foo.bar.baz.qux
    qux.foo.bar.baz
    baz.qux.foo.bar
    bar.baz.qux.foo
  END
  call s:assert.equals(getline(1, 4), l:expect, 'failed at #2')
  call s:assert.equals(getpos('.'), [0, 4, 15, 0], 'failed at #2')
endfunction "}}}

function! s:suite.gN_n_select() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(1, 15)
  execute "normal \<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #1')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #1')
  call s:assert.equals(getpos("'<"), [0, 1, 1, 0], 'failed at #1')
  call s:assert.equals(getpos("'>"), [0, 1, 3, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(2, 15)
  execute "normal \<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #2')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #2')
  call s:assert.equals(getpos("'<"), [0, 2, 5, 0], 'failed at #2')
  call s:assert.equals(getpos("'>"), [0, 2, 7, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(3, 15)
  execute "normal \<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #3')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #3')
  call s:assert.equals(getpos("'<"), [0, 3, 9, 0], 'failed at #3')
  call s:assert.equals(getpos("'>"), [0, 3, 11, 0], 'failed at #3')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal \<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #4')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 4, 13, 0], 'failed at #4')
  call s:assert.equals(getpos("'<"), [0, 4, 13, 0], 'failed at #4')
  call s:assert.equals(getpos("'>"), [0, 4, 15, 0], 'failed at #4')
endfunction "}}}

function! s:suite.gN_n_select_with_count() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 2\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #1')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #1')
  call s:assert.equals(getpos("'<"), [0, 3, 9, 0], 'failed at #1')
  call s:assert.equals(getpos("'>"), [0, 3, 11, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 3\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #2')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #2')
  call s:assert.equals(getpos("'<"), [0, 2, 5, 0], 'failed at #2')
  call s:assert.equals(getpos("'>"), [0, 2, 7, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal 4\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #3')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #3')
  call s:assert.equals(getpos("'<"), [0, 1, 1, 0], 'failed at #3')
  call s:assert.equals(getpos("'>"), [0, 1, 3, 0], 'failed at #3')
endfunction "}}}

function! s:suite.gN_x_select() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(1, 15)
  execute "normal v\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #1')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #1')
  call s:assert.equals(getpos("'<"), [0, 1, 1, 0], 'failed at #1')
  call s:assert.equals(getpos("'>"), [0, 1, 3, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(2, 15)
  execute "normal v\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #2')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #2')
  call s:assert.equals(getpos("'<"), [0, 2, 5, 0], 'failed at #2')
  call s:assert.equals(getpos("'>"), [0, 2, 7, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(3, 15)
  execute "normal v\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #3')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #3')
  call s:assert.equals(getpos("'<"), [0, 3, 9, 0], 'failed at #3')
  call s:assert.equals(getpos("'>"), [0, 3, 11, 0], 'failed at #3')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal v\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #4')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 4, 13, 0], 'failed at #4')
  call s:assert.equals(getpos("'<"), [0, 4, 13, 0], 'failed at #4')
  call s:assert.equals(getpos("'>"), [0, 4, 15, 0], 'failed at #4')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal v\<Plug>(multitarget-gn-gN)\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #5')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #5')
  call s:assert.equals(getpos("'<"), [0, 3, 9, 0], 'failed at #5')
  call s:assert.equals(getpos("'>"), [0, 3, 11, 0], 'failed at #5')
endfunction "}}}

function! s:suite.gN_x_select_with_count() abort "{{{
  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal v2\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #1')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 3, 9, 0], 'failed at #1')
  call s:assert.equals(getpos("'<"), [0, 3, 9, 0], 'failed at #1')
  call s:assert.equals(getpos("'>"), [0, 3, 11, 0], 'failed at #1')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal v3\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #2')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 2, 5, 0], 'failed at #2')
  call s:assert.equals(getpos("'<"), [0, 2, 5, 0], 'failed at #2')
  call s:assert.equals(getpos("'>"), [0, 2, 7, 0], 'failed at #2')



  call s:put_test_string()
  /foo
  call cursor(4, 15)
  execute "normal v4\<Plug>(multitarget-gn-gN)"
  silent! doautocmd multitarget-gn SafeState
  call s:assert.equals(mode(), 'v', 'failed at #3')
  execute "normal! \<Esc>"
  call s:assert.equals(getpos('.'), [0, 1, 1, 0], 'failed at #3')
  call s:assert.equals(getpos("'<"), [0, 1, 1, 0], 'failed at #3')
  call s:assert.equals(getpos("'>"), [0, 1, 3, 0], 'failed at #3')
endfunction "}}}

" vim:set foldmethod=marker:
" vim:set commentstring="%s:
