vim-multitarget-gn
=================

Yet another `gn` command taking a count as a number of operation.

## What for?

Suppose that you wanted to delete all `foo` from your buffer.

```
foo bar
foo bar
foo bar
```

You had searched the targets like `/foo<CR>`.
Then, could you tell what happen if you typed `3dgn`?
The answer is here.

```
foo bar
foo bar
 bar
```

Yes, it should be. However, someone might expect like this.

```
 bar
 bar
 bar
```

The usual `3dgn` deletes the third `foo` instead of three `foo`.
This is ok.
But, it is also ok to have another choice to delete three `foo`.
This is it.


## Usage

Map `<Plug>(multitarget-gn-gn)` to your favorite key.

```
nmap gn <Plug>(multitarget-gn-gn)
xmap gn <Plug>(multitarget-gn-gn)
omap gn <Plug>(multitarget-gn-gn)
```


## Requirements
- Vim with `+textprop` feature


## Difference from the original command

### normal mode

Behave similarly.

### Visual mode

- The original command **expands** the visual selected region to the *count*-th target.
- The command of this plugin **jump to select** only the *count*-th target.

### Operator-pending mode

- The original command operate only on the *count*-th target.
- The command of this plugin operate on the *count* of targets.

