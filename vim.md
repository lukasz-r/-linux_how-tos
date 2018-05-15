
\define{vim}{__vim__}
# \vim

## opening and saving files

__buffer__<a name="vim_buffer"></a>

: an area of memory used to hold text read from a file or a newly created text

+ `:h p`: get help about the `p` command

+ `:h CTRL-f`: get help about the `<CTRL>+f` shortcut

+ save a file (write the whole [buffer](#vim_buffer) to the current file): `:w`

+ reload a file: `:e`

+ exit all edited files without saving changes: `:qa!`

## most useful vim modes

+ normal (command) mode --- a default mode after \vim starts:
	+ `<ESC>`: usually enters the mode
	+ `5w`: move forward 5 words
	+ `5b`: move backward 5 words
	+ `)`: move forward a sentence
	+ `(`: move backward a sentence
	+ `}`: move forward a paragraph
	+ `{`: move backward a paragraph
	+ `<CTRL>+f`: move forward a page
	+ `<CTRL>+b`: move backward a page
	+ `fc`: move forward to the `c` character (`f` means `find`)
	+ `Fc`: move backward to the `c` character
	+ `;`: repeat the forward move
	+ `,`: repeat the backward move
	+ `0`: move to the first character of the line
	+ `^`: move to the first non-blank character of the line
	+ `%`: jump to the corresponding item, e.g. a matching bracket
	+ `gg`: go the beginning of a file
	+ `10G`: go to the 10th line
	+ `G`: go to the end of a file
	+ `.`: repeat last normal-mode change

+ insert mode --- a mode to insert text into the buffer:
	+ `a`: start inserting the text after the cursor
	+ `i`: start inserting the text before the cursor
	+ `A`: start inserting the text at the end of the line
	+ `I`: start inserting the text before the first non-blank in the line
	+ `120i-<ESC>`: insert the `-` character 120 times

+ replace mode --- a mode similar to an insert mode, but typing replaces existing characters:
	+ `R`: start replacing characters

+ visual mode<a name="vim_visual_mode"></a> --- a mode for navigation and manipulation of text selections:
	+ `v`: select characters continuously
	+ `V`: select lines
	+ `<CTRL>+v`: select blocks
	+ `gv`: restore the previous visual selection

+ command-line mode --- a mode for entering editor commands at the bottom of the window:
	+ `:h :q`: get help on the `:q` command
	+ `/word`: search forward for `word`
	+ `n`: repeat the latest search forward
	+ `N`: repeat the latest search backward
	+ `:10`: go to the 10th line
	+ `@:`: repeat last command-line-mode command

## clipboards and registers

\define{vim_register}{__register__}
\define{vim_register_linked}{[__register__](#vim_register)}
\vim_register<a name="vim_register"></a>

: a space in memory used by \vim to store some text

\define{vim_primclip}{__primary clipboard__}
\define{vim_primclip_linked}{[\vim_primclip](#vim_primclip)}

+ in Linux there two independent clipboards:
	+ \vim_primclip (copy-on-select, pasted with middle mouse button)
	+ __system clipboard__ (copy with `<CTRL>+c`, paste with `<CTRL>+v`)

+ by default, `y` (yank) and `d` (delete) copy to, and `p` (paste) pastes from an unnamed [register](#vim_register)
+ primary clipboard is the `*` register in __vimx__ (hint: star is select)
+ system clipboard is the `+` register in __vimx__ (hint: `<CTRL>+c`)
+ __vimx__ in Fedora is from __vim-X11__ package

+ copy a word under the cursor (_yank inner word_): `yiw`

+ paste the text after the cursor: `p`

+ paste the text before the cursor: `P` (useful to insert a copied line before the first line)

+ display the contents of all numbered and named registers: `:reg`

+ paste the text from register `x` after the cursor: `"xp`

+ copy [selection](#vim_visual_mode) to a system clipboard: `"+y`

+ copy a current line to a system clipboard: `V"+y`

+ paste primary clipboard contents: `"*p`

+ paste system clipboard contents: `"+p`

## selecting, deleting and replacing text

+ select all text in a file: `ggVG`

+ select a word under the cursor: `viw`

+ delete everything from a given line to the end of a file: `dG`

+ delete everything from a given line to the beginning of a file: `dgg`

+ delete a word under the cursor (_delete inner word_): `diw`

+ delete from the cursor to the end of a word: `dw`

+ delete a word under the cursor and type the `new` word (_change inner word, then type_ `new`): `ciwnew`

+ delete a current line and start inserting text in it (switch to an insert mode): `cc`

+ delete a current line (turn it into a blank line): `0D` or: `cc<ESC>`

+ delete lines containing a specific pattern: `:g/some_pattern/d`

	delete lines NOT containing a specific pattern: `:g!/some_pattern/d` or: `:v/some_pattern/d`

	to only list the lines that would be deleted, remove `/d` in the above commands

	above commands can also be applied to a [selection](#vim_visual_mode)

+ turn off the highlighted search results: `:nohls`

+ search for a pattern case-insensitively: `/\\cPattern`

+ search for a pattern case-sensitively: `/\\CPattern`

\define{vim_spat}{  \|\s$\|\n\n\n}

+ search for multiple patterns, e.g. double spaces, whitespace characters at the end of a line, and double line breaks: `/\vim_spat`

	(`\\|` separates patterns)

	turn the avove search into a custom command in `~/.vimrc`:
```
com SearchMess /\vim_spat
```
such a command might be then invoked with: `:SearchMess`

\define{vim_spat}{\(_l\)\([|>]\)}
\define{vim_rpat}{\1\inked\2}

+ search for the `_l|` and `_l>` strings: `/_l[|>]`

	now we'll replace `_l` into `_linked` in the above strings using the most recently searched pattern and backreferences:

	+ we repeat the search adding the groups via `\(` and `\)` around `_l` and `[|>]`: `\vim_spat`

	+ we use `:%s//replace_pattern/g` to refer to the most recently searched pattern, and `\\1`, `\\2`, etc. to refer to strings matched inside `\\(` and `\\)`: `%s//\vim_rpat/g`

+ the `E488: Trailing characters` error is usually caused when the unescaped separator (e.g. `\`) is used in the pattern --- in that case either escape the separator (e.g. `\\`), or use a different separator (e.g. `#`: `:s#/>$#}#g`)

+ make multiple substitutions:
```
:%s/one/two/g | :%s/three/four/g
```

	(`|` separates commands)

+ replace whitespace in the [selected](#vim_visual_mode) lines with tabs: `:s/\s\+/\t/g`

	(`:s/\s\+/\t/g` replaces one or more whitespace characters in a row, i.e. continouos whitespace, with a tab, whereas `:s/\s/\t/g` replaces each whitespace character with a tab, so there might be multipe tabs between words after replacement)

+ remove whitespace in the beginning of the [selected lines](#vim_visual_mode): `:s/^\s\+`

	(`\s` selects whitespace)

+ replace [selected](#vim_visual_mode) characters with `.`: `:r.`

+ make a [selection](#vim_visual_mode) uppercase: `U`, lowercase: `u`

### __vim-surround__ plugin

+ surround a current line in backticks: `` yss` ``

## sorting and reversing lines

+ sort [selected lines](#vim_visual_mode) case-insensitively: `:sort i`

+ reverse all lines in a file: `:g/^/m0`

	`^` matches the start of a line and thus all lines in a buffer, `m0` moves each matched line to the beginning of a buffer

	or select everything with `ggVG` and: `:!tac`

+ reverse [selected lines](#vim_visual_mode) in a file: `:!tac`

## indentation and comments

+ indent [selected lines](#vim_visual_mode): `>`

+ comment [selected lines](#vim_visual_mode) with `# `: `:s/^/# /` or [select a visual block](#vim_visual_mode) starting in the leftmost column and: `I# <ESC>`

## more on inserting text

+ insert regular quotes (`"..."`) instead of smart quotes in a `*.tex` file: `\"` and then erase `\`

+ insert the `list: ` string starting in a given column: [select a visual block](#vim_visual_mode) starting in the given column and: `Ilist: <ESC>`

+ add the `.` character at the end of [selected lines](#vim_visual_mode): `norm A.`

	(`norm A.` executes insert-mode command `A.`)

## external commands

+ run the `make` command: `:!make`

	note that `:make` (with no `!`) calls a command stored in `makeprg` (`mp`) string whose actual value depends on the edited file type, e.g. for `*.tex` file it's usually `latex -interaction=nonstopmode -file-line-error-style $*`

	display the value of the `mp` string: `:set mp`

+ execute a shell command: `:!ls`, `:!man bash`, etc.

+ repeat the last shell command (very useful with `make`): `:!!`

+ make a currently edited file executable: `:!chmod +x %`

+ execute a currently edited file: `:!./%` or: `:!%:p`

	(`:p` means a file pathname)

+ insert an output of a command into the current buffer: `:r !free -h`

+ insert an external file contents into the current buffer: `:r file.txt`

## encoding

+ check the file encoding in vi: `:set fenc`

+ reopen the file with a given encoding (e.g. latin2): `:e ++enc=latin2`

## printing

+ print a document: `:ha`

+ print a document with Polish characters:
```
:set printencoding=cp1250
:ha
```

## editing multiple files

+ open multiple files:
	+ `vim -o ./*.txt` (split horizontally)
	+ `vim -O ./*.txt` (split vertically)
	+ `vim -p ./*.txt` (using tabs)

+ split a current window horizontally: `:sp`

+ split a current window vertically: `:vsp`

+ split a current window horizontally and start editing a new named file in a new window: `:sp new_file`

+ split a current window vertically and start editing a new file in a new window: `:vne`

+ go to a next window: `<CTRL>+ww`

+ go to a window below: `<CTRL>+w↓`

+ list all buffers: `:ls`

+ note that switching buffers doesn't switch between windows nor tabs, but switches a file in a current window if several files are open

+ go to a next buffer: `:bn`

+ go to a previous buffer: `:bp`

+ go to a next tab: `gt`

+ go to a previous tab: `gT`

## big files

+ view really big (e.g. gigabyte) files --- use `more` or `less` instead of `vim`:
```bash
more file.txt
less file.txt
```
