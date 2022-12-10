vim-multitarget-gn
=================

[![Test](https://github.com/machakann/vim-multitarget-gn/actions/workflows/test.yml/badge.svg)](https://github.com/machakann/vim-multitarget-gn/actions/workflows/test.yml)

Yet another `gn` command taking a count as a number of operation.

## What for?

Suppose that you wanted to delete all `foo` from your buffer.

```
foo bar
bar foo
foo bar
```

You had searched the targets like `/foo<CR>` and now the cursor was at the first column of the first line.
Then, could you tell what happen if you typed `3dgn`?
The answer is here.

```
foo bar
bar foo
 bar
```

Yes, it should be. However, someone might expect like this.

```
 bar
bar 
 bar
```

This is it.


## Usage

Map `<Plug>(multitarget-gn-gn)` to your favorite key.

```
nmap gn <Plug>(multitarget-gn-gn)
xmap gn <Plug>(multitarget-gn-gn)
omap gn <Plug>(multitarget-gn-gn)
```


## Requirements
- Vim v8.2.0877 or newer
- `SafeState` autocmd
- `+textprop` feature


## Difference from the original command

### normal mode

Behave similarly.

### Visual mode

- The original command **expands** the visual selected region to the *count*-th target.
- The command of this plugin **jump to select** only the *count*-th target.

### Operator-pending mode

- The original command operate only on the *count*-th target.
- The command of this plugin operate on the *count* of targets.

