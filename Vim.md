
# \Vim_anchor

\define{\Vim_selection{text}}{[__<wbr>\text<wbr>__](#Vim_visual_mode)}

## \getting_help

+ start a \Vim_link tutor:

	```bash
	vimtutor
	```

	command | meaning
	--------|--------
	`:h p` | get help about the `p` command
	`:h CTRL-F` | get help about the \key{Ctrl}+\key{F} shortcut
	`:h CTRL-W_X` | get help on the \key{Ctrl}+\key{W}\ \key{X} combination
	`:h CTRL-W_CTRL-B` | get help on the \key{Ctrl}+\key{W}\ \key{Ctrl}+\key{B} combination

	: help from within a \Vim_link

## opening and saving files

\Vim_buffer_anchor

: an area of memory used to hold text read from a file or a newly created text

	command | meaning
	--------|--------
	`:w` | save a file (write the whole \Vim_buffer_link to the current file)
	`:e` | reload a file
	`:wqa` | write changes to all open files and exit \Vim_link
	`:qa!` | exit all open files without saving changes

	: saving and quitting \Vim_buffer_anchor\plural{s}

## most useful \Vim_link modes

\define{Vim_mode_tab_caption}{command examples}

\Vim_normal_mode_anchor

: a default mode after \Vim_link starts, useful for efficient text navigation and deletion

	command | action
	--------|-------
	\key{Esc} | usually enters the mode
	`5w` \slash_sep `5b` | move forward \slash_sep backward 5 words
	`)` \slash_sep `(` | move forward \slash_sep backward a sentence
	`}` \slash_sep `{` | move forward \slash_sep backward a paragraph
	\key{Ctrl}+\key{F} \slash_sep \key{Ctrl}+\key{B} | move forward \slash_sep backward a page
	`fc` \slash_sep `Fc` | move forward \slash_sep backward to the `c` character (`f` means `find`)
	`;` \slash_sep `,` | repeat the forward \slash_sep backward move
	`0` | move to the first character of the line
	`^` | move to the first non-\blank_character_link of the line
	`%` | jump to the corresponding item, e.g. a matching bracket
	`gg` | go to the beginning of a file
	`10G` | go to the 10th line
	`G` | go to the end of a file
	`/word` | search forward for `word`
	`n` \slash_sep `N` | repeat the latest search forward \slash_sep backward
	`4dd` | delete 4 lines
	`D` or `d$` | delete the characters from the cursor to the \EOL
	`.` | repeat last normal-mode change

	: \Vim_normal_mode_link \Vim_mode_tab_caption

\Vim_insert_mode_anchor

: a mode to insert text into the \Vim_buffer_link

	command | action
	--------|-------
	`a` | start inserting the text after the cursor
	`i` | start inserting the text before the cursor
	`A` | start inserting the text at the end of the line
	`I` | start inserting the text before the first non-blank in the line
	`o` | add an \empty_line_link below the cursor and start inserting the text
	`O` | add an \empty_line_link above the cursor and start inserting the text
	`120i-`\ \key{Esc} | insert the `-` character 120 times

	: \Vim_insert_mode_link \Vim_mode_tab_caption

\Vim_replace_mode_anchor

: a mode similar to an \Vim_insert_mode_link, but typing replaces existing characters

	command | action
	--------|-------
	`R` | start replacing characters
	`ra` | replace the character under the cursor with `a`

	: \Vim_replace_mode_link \Vim_mode_tab_caption

\Vim_visual_mode_anchor

: a mode for navigation and manipulation of text selections:

	command | action
	--------|-------
	`v` | start selecting characters continuously
	`V` | start selecting lines
	\key{Ctrl}+\key{V} | start selecting blocks
	`gv` | restore the previous visual selection

	: \Vim_visual_mode_link \Vim_mode_tab_caption

\Vim_cline_mode_anchor

: a mode for entering editor commands at the bottom of the window:

	command | action
	--------|-------
	`:h :q` | get help on the `:q` command
	`:10` | go to the 10th line
	`:@@:` | repeat last command-line-mode command

	: \Vim_cline_mode_link \Vim_mode_tab_caption

## clipboards and registers

\Vim_register_anchor

: a space in memory used by \Vim_link to store some text

+ \Vim_register_link\plural{s} are accessed via `"<register_name>`, e.g. `"*`

+ by default, `y` (___yank___) and `d` (___delete___) copy to, and `p` (___paste___) pastes from an __unnamed__ \Vim_register_link

	\Vim_register_link name | description
	------------------------|------------
	`"` (__unnamed__) | a default \Vim_register_link
	`*` | \clipboard_primary_link (hint: star `*` is select)
	`+` | \clipboard_system_link (hint: \key{Ctrl}`+`\key{C})
	`n`, $n \in \{0, 1, \ldots, 9\}$ | numbered \Vim_register_link\plural{s} to keep text from recent `y` and `d` commands
	`a`, `b`, ... | \Vim_register_link named `a`, `b`, ... to store user's text
	`%` | the name of the current file
	`/` | last search pattern

	: \Vim_register_link examples in __vimx__

	(__vimx__ in \Fedora is provided by the __vim-X11__ package)

+ copy a word under the cursor : `yiw` (___yank inner word___)

+ paste the text after the cursor: `p`

+ paste the text before the cursor: `P` (useful to insert a copied line before the first line)

+ display the contents of all numbered and named \Vim_register_link\plural{s}: `:reg`

+ paste the text from \Vim_register_link `x` after the cursor: `"xp`

+ copy \Vim_selection{selection} to a \clipboard_system_link: `"+y`

+ copy a current line to a \clipboard_system_link: `V"+y`

+ paste \clipboard_primary_link contents: `"*p`

+ paste \clipboard_system_link contents: `"+p`

## selecting text

+ see \Vim_visual_mode_link for basic commands to select text

+ select all text in a file: `ggVG`

+ select a word under the cursor: `viw`

## deleting characters

+ delete everything from a given line to the end of a file: `dG`

+ delete everything from a given line to the beginning of a file: `dgg`

+ delete a word under the cursor: `diw` (___delete inner word___)

+ delete from the cursor to the end of a word: `dw`

+ delete a word under the cursor and type the `new` word: `ciwnew` (___change inner word___, then type `new`)

+ delete a current line and start inserting text in it (switch to an \Vim_insert_mode_link): `cc`

+ delete all characters in a current line (turn it into an \empty_line_link): `0D` or: `cc`\ \key{Esc}

+ delete lines containing a specific pattern: `:g/some_pattern/d`

	delete lines __not__ containing a specific pattern: `:g!/some_pattern/d` or: `:v/some_pattern/d`

	+ to only list the lines that would be deleted, remove `/d` in the above commands

	+ above commands can also be applied to a \Vim_selection{selection}

+ delete \empty_line_link\plural{s} in a \Vim_selection{selection}: `:g/^$/d`

+ delete \blank_line_link\plural{s} in a \Vim_selection{selection}: `:g/^\s*$/d`

## searching and replacing

+ general form of a \Vim_substitute_command_anchor: `:[range]s/pattern/string/[flags]`

\Vim_substitute_range_anchor

: which lines to apply the operation to

	range | meaning
	------|-------
	null string | a current line only
	`%` | all lines in a file
	`'<,'>` | all lines in a \Vim_selection{selection} (it appears automatically after typing `:s` following the \Vim_selection{selection})

	: \Vim_substitute_range_link examples

\Vim_substitute_pattern_anchor

: a \regex_link specifying what to look for

\Vim_substitute_string_anchor

: how to replace what's been matched by the \Vim_substitute_pattern_link

\Vim_substitute_flag_anchor\plural{s}

: characters for fine-tuning of the substitute operation

flag | meaning
-----|--------
`c` | confirm each substitution
`g` | replace all occurrences in the line
`i` | ignore case for the \Vim_substitute_pattern_link
`I` | don't ignore the case for the \Vim_substitute_pattern_link
`n` | report the number of matches, but do not replace anything

: \Vim_substitute_flag_link examples

+ the \Vim_substitute_command_link by default operates on __whole lines__:

	+ this causes no problem for a \Vim_selection{selection} capturing whole lines only

	+ this might cause problems when a \Vim_selection{selection} includes only parts of line --- the solution then is to use the `\%V` atom in the \Vim_substitute_pattern_link to restrict the match to the current \Vim_selection{selection} only (without the atom, the \Vim_substitute_command_link operates on the whole lines, even the partially \Vim_selection{selected} ones)

### special characters

+ some characters in the \Vim_substitute_pattern_link and \Vim_substitute_string_link:

	+ are taken literally, but have special meaning when preceded with `\`

	+ have a special meaning without `\` before them

+ the `magic` options decides if a specific character is taken literally or not

+ it's best to keep this option unchanged at its default value, thus all searches are performed with the `magic` option

	character | matches
	----------|--------
	`\n` | \newline
	`$` | \EOL
	`*` | 0 or more of the preceding item
	`\=`, `\?` | 0 or 1 of the preceding item
	`\+` | 1 or more of the preceding item
	`\{n,m}` | $n$ to $m$ of the preceding item
	`\<` | beginning of a word
	`\>` | end of a word

	: examples of characters in the \Vim_substitute_pattern_link with the `magic` option

	character | meaning
	----------|--------
	`\r` | \newline
	`&` | the whole string matched by the \Vim_substitute_pattern_link
	`\2` | the string matched in the second pair of `\(...\)` in the \Vim_substitute_pattern_link
	`\=` | the remainder is interpreted as an expression

	: examples of characters in the \Vim_substitute_string_link with the `magic` option

### search examples

+ search for a pattern case-insensitively: `/\cPattern`

+ search for a pattern case-sensitively: `/\CPattern`

+ turn off the highlighted search results: `:nohls`

+ search for the __whole__ `the` word (thus match only `the`, not `then`, `other`, etc.): `/\<the\>`

\define{Vim_spat}{[  ][  ]\|\s$\| $\|\n\n\n}

+ search for multiple patterns, e.g. double spaces (including \nonbr_space_link\plural{s}), a \blank_character_link or a \nonbr_space_link at the end of a line, and double line breaks: `/\Vim_spat`

	(`\|` separates patterns, `[  ]` contains a space and a \nonbr_space_link)

	turn the avove search into a custom command in \Vim_rc_file_anchor:

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

+ replace \blank_character_link\plural{s} in the \Vim_selection{selected} lines with tabs: `:s/\s\+/\t/g`

	(`:s/\s\+/\t/g` replaces one or more \blank_character_link\plural{s} in a row, i.e. continouos horizontal whitespace, with a tab, whereas `:s/\s/\t/g` replaces each \blank_character_link with a tab, so there might be multipe tabs between words after replacement)

+ remove \blank_character_link\plural{s} in the beginning of the \Vim_selection{selected lines}: `:s/^\s\+`

	(`\s` matches a \blank_character_link\plural)

+ replace \Vim_selection{selected} characters with `.`: `:r.`

+ replace all `1` characters with `_1` strings __only__ inside a \Vim_selection{selection}: `:s/\%V1/_1/g`

#### case conversion

+ convert a \Vim_selection{selection}:

	+ to uppercase: `U`

	+ to lowercase: `u`

	+ toggle the case: `~`

+ convert all instances of `FILTER_FILE` to lowercase: `:%s/FILTER_FILE/\L&/g`

+ convert first characters of words __only__ in a \Vim_selection{selection} to uppercase: `:s/\%V\<./\u&/g`

### __vim-surround__ plugin

+ surround a current word in backticks: `` ysiw` ``

+ surround a current line in backticks: `` yss` ``

+ to avoid repeating typing long character sequences, use [macros](#macros)

## macros

+ record typed characters into the `a` \Vim_register_link for further repetition: `` qaysiw`q ``

	+ `qa` starts recording into the `a` register

	+ `` ysiw` `` are the characters recorded into the register

	+ `q` stops recording

+ execute the contents of the `a` register: `@@a`

	+ the previous `@@a` can be repeated with `@@@@`

## sorting and reversing lines

+ sort \Vim_selection{selected lines} case-insensitively: `:sort i`

+ reverse all lines in a file: `:g/^/m0`

	`^` matches the start of a line and thus all lines in a \Vim_buffer_link, `m0` moves each matched line to the beginning of a \Vim_buffer_link

	or select everything with `ggVG` and: `:!tac`

+ reverse \Vim_selection{selected lines} in a file: `:!tac`

## indentation and comments

+ indent \Vim_selection{selected lines}: `>`

+ indent \Vim_selection{selected lines} by two levels: `2>`

+ comment \Vim_selection{selected lines} with `# `: `:s/^/# /` or \Vim_selection{select a visual block} starting in the leftmost column and: `I# `\ \key{Esc}

## more on inserting text

+ insert regular quotes (`"..."`) instead of smart quotes in a `*.tex` file: `\"` and then erase `\`

+ insert the `list: ` string starting in a given column: \Vim_selection{select a visual block} starting in the given column and: `Ilist: `\ \key{Esc}

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

+ insert an output of a command into the current \Vim_buffer_link: `:r !free -h`

+ insert an external file contents into the current \Vim_buffer_link: `:r file.txt`

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

+ go to a next window: \key{Ctrl}+\key{W}\key{W}

+ go to a window below: \key{Ctrl}+\key{w}\ \key{↓}

+ exchange (swap) the split windows: \key{Ctrl}+\key{W}\ \key{X}

+ list all \Vim_buffer_link\plural: `:ls`

+ note that switching \Vim_buffer_link\plural doesn't switch between windows nor tabs, but switches a file in a current window if several files are open

+ go to a next \Vim_buffer_link: `:bn`

+ go to a previous \Vim_buffer_link: `:bp`

+ go to a next tab: `gt`

+ go to a previous tab: `gT`

## big files

+ view really big (e.g. gigabyte) files --- use `more` or `less` instead of `vim`:
```bash
more file.txt
less file.txt
```
