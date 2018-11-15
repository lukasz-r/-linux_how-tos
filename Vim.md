
\define{Vim}{__Vim__}
# \Vim

\define{Vim_buffer}{__buffer__}
\define{Vim_buffer_linked}{[\Vim_buffer](#Vim_buffer)}

\define{\Vim_selection{text}}{[__<wbr>\text<wbr>__](#Vim_visual_mode)}

\define{Vim_register}{__register__}
\define{Vim_register_linked}{[\Vim_register](#Vim_register)}

\define{Vim_prim_clip}{__primary clipboard__}
\define{Vim_prim_clip_linked}{[\Vim_prim_clip](#Vim_prim_clip)}

\define{Vim_sys_clip}{__system clipboard__}
\define{Vim_sys_clip_linked}{[\Vim_sys_clip](#Vim_sys_clip)}

\define{Vim_search_pattern}{__search pattern__}
\define{Vim_search_pattern_linked}{[\Vim_search_pattern](#Vim_search_pattern)}

\define{Vim_search_string}{__search string__}
\define{Vim_search_string_linked}{[\Vim_search_string](#Vim_search_string)}

## \getting_help

+ start a \Vim tutor:

	```bash
	vimtutor
	```
+ help in a \Vim:

	+ `:h p`: get help about the `p` command

	+ `:h CTRL-f`: get help about the `<CTRL>+f` shortcut

## opening and saving files

\Vim_buffer<a name="Vim_buffer"></a>

: an area of memory used to hold text read from a file or a newly created text

+ save a file (write the whole \Vim_buffer_linked to the current file): `:w`

+ reload a file: `:e`

+ exit all edited files without saving changes: `:qa!`

## most useful \Vim modes

+ __normal (command) mode__ --- a default mode after \Vim starts:

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

	+ `/word`: search forward for `word`

	+ `n`: repeat the latest search forward

	+ `N`: repeat the latest search backward

	+ `.`: repeat last normal-mode change

+ __insert mode__ --- a mode to insert text into the \Vim_buffer_linked:

	+ `a`: start inserting the text after the cursor

	+ `i`: start inserting the text before the cursor

	+ `A`: start inserting the text at the end of the line

	+ `I`: start inserting the text before the first non-blank in the line

	+ `o`: add an empty line below and start inserting the text

	+ `O`: add an empty line above and start inserting the text

	+ `120i-<ESC>`: insert the `-` character 120 times

+ __replace mode__ --- a mode similar to an insert mode, but typing replaces existing characters:

	+ `R`: start replacing characters

+ __visual mode__<a name="Vim_visual_mode"></a> --- a mode for navigation and manipulation of text selections:

	+ `v`: select characters continuously

	+ `V`: select lines

	+ `<CTRL>+v`: select blocks

	+ `gv`: restore the previous visual selection

+ __command-line mode__ --- a mode for entering editor commands at the bottom of the window:

	+ `:h :q`: get help on the `:q` command

	+ `:10`: go to the 10th line

	+ `:@@:`: repeat last command-line-mode command

## clipboards and registers

\Vim_register<a name="Vim_register"></a>

: a space in memory used by \Vim to store some text

+ in Linux there two independent clipboards:

	+ \Vim_prim_clip<a name="Vim_prim_clip"></a> (copy-on-select, pasted with middle mouse button)

	+ \Vim_sys_clip<a name="Vim_sys_clip"></a> (copy with `<CTRL>+c`, paste with `<CTRL>+v`)

+ by default, `y` (yank) and `d` (delete) copy to, and `p` (paste) pastes from an unnamed \Vim_register_linked

+ \Vim_prim_clip_linked is the `*` \Vim_register_linked in __vimx__ (hint: star is select)

+ \Vim_sys_clip_linked is the `+` \Vim_register_linked in __vimx__ (hint: `<CTRL>+c`)

+ __vimx__ in Fedora is from __vim-X11__ package

+ copy a word under the cursor (_yank inner word_): `yiw`

+ paste the text after the cursor: `p`

+ paste the text before the cursor: `P` (useful to insert a copied line before the first line)

+ display the contents of all numbered and named \Vim_register_linked\plural: `:reg`

+ paste the text from \Vim_register_linked `x` after the cursor: `"xp`

+ copy \Vim_selection{selection} to a system clipboard: `"+y`

+ copy a current line to a system clipboard: `V"+y`

+ paste primary clipboard contents: `"*p`

+ paste system clipboard contents: `"+p`

## selecting text

+ select all text in a file: `ggVG`

+ select a word under the cursor: `viw`

## deleting text

+ delete everything from a given line to the end of a file: `dG`

+ delete everything from a given line to the beginning of a file: `dgg`

+ delete a word under the cursor (_delete inner word_): `diw`

+ delete from the cursor to the end of a word: `dw`

+ delete a word under the cursor and type the `new` word (_change inner word, then type_ `new`): `ciwnew`

+ delete a current line and start inserting text in it (switch to an insert mode): `cc`

+ delete a current line (turn it into a blank line): `0D` or: `cc<ESC>`

+ delete lines containing a specific pattern: `:g/some_pattern/d`

	delete lines __not__ containing a specific pattern: `:g!/some_pattern/d` or: `:v/some_pattern/d`

	+ to only list the lines that would be deleted, remove `/d` in the above commands

	+ above commands can also be applied to a \Vim_selection{selection}

## searching and replacing

+ general form of a substitue command: `:[range]s/pattern/string/[flags]`

	+ \Vim_search_pattern<a name="Vim_search_pattern"></a>: what to look for

	+ \Vim_search_string<a name="Vim_search_string"></a>: how to replace what's been found

### special characters

+ some characters in the \Vim_search_pattern_linked and \Vim_search_string_linked:

	+ are taken literally, but have special meaning when preceded with `\`

	+ have a special meaning without `\` before them

+ the `magic` options decides if a specific character is taken literally or not

+ it's best to keep this option unchanged at its default value, thus all searches are performed with the `magic` option

	character  | matches
	-----------|----------------------------------
	`\n`       | \newline
	`$`        | \EOL
	`*`        | 0 or more of the preceding item
	`\=`, `\?` | 0 or 1 of the preceding item
	`\+`       | 1 or more of the preceding item
	`\{n,m}`   | $n$ to $m$ of the preceding item
	`\<`       | beginning of a word
	`\>`       | end of a word

	: __examples of characters in the \Vim_search_pattern_linked with the `magic` option__

	character | meaning
	----------|----------------------------------------------------------
	`\r`      | \newline
	`&`       | the whole matched pattern
	`\2`      | the pattern matched in the second pair of `\(...\)` in the \Vim_search_pattern_linked
	`\=`      | the remainder is interpreted as an expression

	: __examples of characters in the \Vim_search_string_linked with the `magic` option__

### search examples

+ search for a pattern case-insensitively: `/\cPattern`

+ search for a pattern case-sensitively: `/\CPattern`

+ turn off the highlighted search results: `:nohls`

+ search for the __whole__ `the` word (thus match only `the`, not `then`, `other`, etc.): `/\<the\>`

\define{Vim_spat}{  \|\s$\|\n\n\n}

+ search for multiple patterns, e.g. double spaces, whitespace characters at the end of a line, and double line breaks: `/\Vim_spat`

	(`\|` separates patterns)

	turn the avove search into a custom command in `~/.vimrc`:
```
com SearchMess /\Vim_spat
```
such a command might be then invoked with: `:SearchMess`

+ search for the __whole__ `KTM1` and `TRK1` words: `/\<\(KTM1\|TRK1\)\>`

### replacement examples

+ find strings of 120 `-` characters: `/-\{120}`

	now replace just found strings with strings of `=` characters of the same length: `:%s//\=repeat("=", strlen(submatch(0)))/g`

	+ `:%s//string/g` refers to the most recently searched pattern

+ add one newline to \Vim_selection{selected lines}: `:s/$/\r/g`

+ replace two consecutive newlines with a single newline in the \Vim_selection{selected lines}: `:s/\n\n/\r/g`

\define{Vim_spat}{\(_l\)\([|>]\)}
\define{Vim_rpat}{\1\inked\2}

+ search for the `_l|` and `_l>` strings: `/_l[|>]`

	now we'll replace `_l` into `_linked` in the above strings using the most recently searched pattern and backreferences:

	+ we repeat the search adding the groups via `\(` and `\)` around `_l` and `[|>]`: `\Vim_spat`

	+ we use `\1`, `\2`, etc. to refer to strings matched inside `\(` and `\)`: `%s//\Vim_rpat/g`

+ replace the __whole__ `KTM1` and `TRK1` words with `\KTM1_link` and `\TRK1_link`, respectively: `:%s/\(\<\(KTM1\|TRK1\)\>\)/\\\1_link/g`

+ the `E488: Trailing characters` error is usually caused when the unescaped separator (e.g. `\`) is used in the pattern --- in that case either escape the separator (use `\\`), or use a different separator (e.g. `#`: `:s#/>$#}#g`)

+ make multiple substitutions:
```
:%s/one/two/g | :%s/three/four/g
```

	(`|` separates commands)

+ replace whitespace in the \Vim_selection{selected} lines with tabs: `:s/\s\+/\t/g`

	(`:s/\s\+/\t/g` replaces one or more whitespace characters in a row, i.e. continouos whitespace, with a tab, whereas `:s/\s/\t/g` replaces each whitespace character with a tab, so there might be multipe tabs between words after replacement)

+ remove whitespace in the beginning of the \Vim_selection{selected lines}: `:s/^\s\+`

	(`\s` selects whitespace)

+ replace \Vim_selection{selected} characters with `.`: `:r.`

#### case conversion

+ convert a \Vim_selection{selection}:

	+ to uppercase: `U`

	+ to lowercase: `u`

	+ toggle the case: `~`

+ convert all instances of `FILTER_FILE` to lowercase: `:%s/FILTER_FILE/\L&/g`

+ convert first characters of words in a \Vim_selection{selection} to uppercase: `:s/\<./\u&/g`

### __vim-surround__ plugin

+ surround a current word in backticks: `` ysiw` ``

+ surround a current line in backticks: `` yss` ``

+ to avoid repeating typing long character sequences, use [macros](#macros)

## macros

+ record typed characters into the `a` register for further repetition: `` qaysiw`q ``

	+ `qa` starts recording into the `a` register

	+ `` ysiw` `` are the characters recorded into the register

	+ `q` stops recording

+ execute the contents of the `a` register: `@@a`

	+ the previous `@@a` can be repeated with `@@@@`

## sorting and reversing lines

+ sort \Vim_selection{selected lines} case-insensitively: `:sort i`

+ reverse all lines in a file: `:g/^/m0`

	`^` matches the start of a line and thus all lines in a \Vim_buffer_linked, `m0` moves each matched line to the beginning of a \Vim_buffer_linked

	or select everything with `ggVG` and: `:!tac`

+ reverse \Vim_selection{selected lines} in a file: `:!tac`

## indentation and comments

+ indent \Vim_selection{selected lines}: `>`

+ indent \Vim_selection{selected lines} by two levels: `2>`

+ comment \Vim_selection{selected lines} with `# `: `:s/^/# /` or \Vim_selection{select a visual block} starting in the leftmost column and: `I# <ESC>`

## more on inserting text

+ insert regular quotes (`"..."`) instead of smart quotes in a `*.tex` file: `\"` and then erase `\`

+ insert the `list: ` string starting in a given column: \Vim_selection{select a visual block} starting in the given column and: `Ilist: <ESC>`

+ add the `.` character at the end of \Vim_selection{selected lines}: `norm A.`

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

+ insert an output of a command into the current \Vim_buffer_linked: `:r !free -h`

+ insert an external file contents into the current \Vim_buffer_linked: `:r file.txt`

+ add line numbers to non-empty \Vim_selection{selected lines}: `:!nl`

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

+ list all \Vim_buffer_linked\plural: `:ls`

+ note that switching \Vim_buffer_linked\plural doesn't switch between windows nor tabs, but switches a file in a current window if several files are open

+ go to a next \Vim_buffer_linked: `:bn`

+ go to a previous \Vim_buffer_linked: `:bp`

+ go to a next tab: `gt`

+ go to a previous tab: `gT`

## big files

+ view really big (e.g. gigabyte) files --- use `more` or `less` instead of `vim`:
```bash
more file.txt
less file.txt
```
