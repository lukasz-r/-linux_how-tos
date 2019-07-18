
# \globs_and_regexes_anc

## \getting_help

```bash
man 7 glob
man 7 regex
man wctype
man isalpha
```

## characters

### \metacharacter_pl and \character_escaping

\metacharacter_anc

: a character that is not treated literally but has a special meaning to a program, e.g. \Bash_lnk or \regex_lnk engine

	\metacharacter_lnk | description
	-------------------|------------
	`[` \slash_sep `]` | opening \slash_sep closing square bracket
	`(` \slash_sep `)` | opening \slash_sep closing parenthesis
	`{` \slash_sep `}` | opening \slash_sep closing curly bracket
	`\` | backslash
	`|` | vertical bar
	`^` | caret
	`$` | dollar sign
	`.` | dot
	`?` | question mark
	`*` | asterisk
	`+` | plus sign

	: \metacharacter_lnk_pl

\character_escaping_anc

: preceding a character with an \escape_character_lnk

\escape_character_anc

: a \metacharacter_lnk which invokes an alternative interpretation of subsequent character or string

	in most cases backslash (`\`) serves as an \escape_character_lnk

	\character_escaping_lnk \metacharacter_lnk_pl causes them to be treated literally, stripping them of their special meaning

	\character_escaping_lnk non-\metacharacter_lnk_pl might give them special meaning

\escape_sequence_anc

: an \escape_character_lnk followed by an escaped character or a string

	an \escape_sequence_lnk thus has at least two characters

### \control_character_pl

#### a bit of a historical background

+ the paper in typewriters was held by a moving carriage operated by a lever

+ the carriage movement was halted by \tab_stop_pl --- adjustable clips that could be moved and fixed in a spot by the user on the tabulator rack, and pressing \key{\Tab_lnk} caused the carriage to go to the next \tab_stop

+ after the line was typed, the lever would:

	+ ___return the carriage___ to the __far right__ so that the type element would hit the paper at its __far left__

	+ ___feed___ the paper to advance to the next line

+ thus, the combined ___carriage return___ and ___line feed___ resulted in a text being typed in a ___new line___

+ although the typewriters needed both carriage motions to move to the new line, in computing both can be combined into one, \CRLF_lnk

#### back into computers

\control_character_anc

: a character not representing a written symbol

\null_string_anc

: a string that hasn't been assigned any value

\empty_string_anc

: the unique string of length $0$

	+ the \empty_string_lnk is denoted as $\epsilon =$`""`

	+ the concatenation of \empty_string_lnk with \any_string_lnk $\sigma$ doesn't change the string: $\epsilon \cdot \sigma = \sigma \cdot \epsilon = \sigma$

	+ in \Bash_lnk \null_string_lnk and \empty_string_lnk are the same since unitialized variable is assigned an \empty_string_lnk: the following script prints `yes`:

		```bash
		#!/bin/bash

		var1=
		var2=""

		[[ $var1 == $var2 ]] && echo "yes"
		```

		thus many `man` pages refer to \empty_string_lnk as \null_string_lnk

\any_string_anc

: an \empty_string_lnk or any other string

\standard_space_anc

: a character inserted with the \key{\spacebar_lnk} key

\tab_stop_anc

: a location the cursor stops after the \key{\Tab_lnk} key is pressed

	each line contains a number of \tab_stop_lnk_pl placed at regular intervals

\horizontal_tab_anc

: a \control_character_lnk introduced by the \key{\Tab_lnk} key spanning between consecutive \tab_stop_lnk_pl

	apart from a \horizontal_tab_lnk, there's also a \vertical_tab_anc, but I've never seen one in my life

\blank_character_anc

: a \standard_space_lnk or a \horizontal_tab_lnk

\whitespace_character_anc

: a character that represents a horizontal or vertical space, e.g. a \blank_character_lnk, a \vertical_tab_lnk, a \newline_lnk

\whitespace_anc

: a sequence of one or more \whitespace_character_lnk_pl

+ note that the above definitions of a \blank_character_lnk and a \whitespace_character_lnk are consistent with `man isalpha`, and \Vim_lnk's `:h [:blank:]` and `:h [:space:]` manuals, but not with \Vim_lnk's `:h \s` manual, according to which `\s` matches a \whitespace_character_lnk, whereas it in fact matches a \blank_character_lnk --- but we'll strictly stick to the __above definitions__ throughout the text

\nonbr_space_anc

: a space preventing an automatic line break at its position

	a \nonbr_space_lnk is inserted with \key{\AltGr_lnk}+\key{\spacebar_lnk}

\carriage_return_anc

: a \control_character_lnk used to reset a cursor position to the beginning of a line of text

\newline_anc

: a \control_character_lnk used to signify the end of a line of text and the start of a new one

operating system | \newline_lnk | \escape_sequence_lnk
-----------------|---------------|--------------------
\Linux and \macOS | \line_feed_anc | `\n`
\Mac_OS | \carriage_return_lnk | `\r`
\Windows | \CRLF_anc | `\r\n`

: \newline_lnk by operating system

\empty_line_anc

: a line with no characters at all

\blank_line_anc

: an \empty_line_lnk or a line with only \blank_character_lnk_pl

\case_sensitive_search_anc

: a search strictly following the case of characters, e.g. `Ab` matching only `Ab`, not `ab`, `aB`, nor `AB`

\case_insensitive_search_anc

: a search ignoring the case of characters, e.g. `ab` matching `ab`, `Ab`, `aB`, or `AB`

## features common for \glob_pl and \regex_pl

\character_class_anc

: set of characters sharing a common property

\define{\globs_and_regexes_set{x}}{C_\mathrm{\x}}

	syntax | character matched | set
	-------|-------------------|----
	`[:upper:]` | uppercase letter | $\globs_and_regexes_set{upper}$
	`[:lower:]` | lowercase letter | $\globs_and_regexes_set{lower}$
	`[:alpha:]` | \alphabetic_character_anc | $\globs_and_regexes_set{alpha} = \globs_and_regexes_set{upper} \cup \globs_and_regexes_set{lower}$
	`[:digit:]` | a digit | $\globs_and_regexes_set{digit} = \{0, 1, \ldots, 9\}$
	`[:alnum:]` | \alphanumeric_character_anc | $\globs_and_regexes_set{alnum} = \globs_and_regexes_set{alpha} \cup \globs_and_regexes_set{digit}$
	`[:blank:]` | \blank_character_lnk | $\globs_and_regexes_set{blank}$
	`[:space:]` | \whitespace_character_lnk | $\globs_and_regexes_set{space} \supset \globs_and_regexes_set{blank}$
	`\w` | \word_character_anc | $\globs_and_regexes_set{word} = \globs_and_regexes_set{alnum} \cup \{$_$\}$
	`\W` | \nword_character_anc | $\globs_and_regexes_set{nword} = \globs_and_regexes_set{word}^\complement$

	: \character_class_lnk_pl

note that the \character_class_lnk_pl denoted with \escape_sequence_lnk_pl are available in \regex_lnk_pl only

\equivalence_class_anc

: e.g. `[=a=]`: all characters typographically equivalent to `a`, e.g. `a`, `ą`, `a`, `à`, `á`, `â`, `ä`, `å`

\bracket_expression_anc

: a list of characters enclosed inside `[]`

	+ a \bracket_expression_lnk matches a ___single character___ from the list of characters

	+ the list can be given explicitly, as a range, as a \character_class_lnk, as an \equivalence_class_lnk, or as a compliment (negated list)

	expression | match
	-----------|------
	`[abc]` | `a`, `b`, or `c`
	`[0-9]`, `[[:digit:]]` | a digit
	`[^0-9jk]` | any non-digit non-`j` non-`k` character
	`[[=e=]]` | e.g. `e`, `ę`, `è`, `é`, `ê`, `ë`

	: \bracket_expression_lnk_pl

## \glob composition

\glob_anc

: a string with at least one \globbing_character_anc, i.e. `?`, `*`, or `[`

	pattern | match
	--------|------
	`*` | \any_string_lnk
	`?` | any single character
	`[...]` | see \bracket_expression_lnk

	: \glob_lnk_pl

\extended_glob_anc

: a string with at least one extended pattern matching operator

	pattern | match
	--------|------
	`(a|b)` | a or b
	`*(abc)` | zero or more `abc`'s
	`+(abc)` | one or more `abc`'s
	`?(abc)` | zero or one `abc`'s
	`@@(abc)` | exactly one `abc`
	`!(abc)` | anything except `abc`

	: extended pattern matching operators

	+ \extended_glob_lnk_pl are turned on with `shopt -s extglob`

## \glob_pl purpose

\globbing_anc

: expansion of a \glob_lnk into the list of matching \pathname_lnk_pl

+ \glob_lnk_pl are meant to match \filename_lnk_pl

+ \globbing_lnk is applied separately on each \pathname_lnk component (the components are separated with `/`)

+ \glob_lnk_pl must span the whole \filename_lnk to possibly match it, e.g. `*.txt` matches `file.txt`

## \regex composition

\regex_anc

: one or more \regex_branch_lnk_pl separated by `|`

	+ \regex_lnk matches anything that matches one of its branches

\regex_branch_anc

: one or multiple concatenated (coming one after another) \regex_piece_lnk_pl

	+ \regex_branch_lnk matches all strings that match its \regex_piece_lnk_pl, in the order of \regex_piece_lnk_pl

\regex_piece_anc

: an \regex_atom_lnk followed by `*`, `+`, `?`, or `{...}` (a bound)

	pattern | match
	--------|------
	`atom*` | zero or more \regex_atom_lnk_pl
	`atom+` | one or more \regex_atom_lnk_pl
	`atom?` | zero or one \regex_atom_lnk
	`atom{2,}`, etc. | two or more \regex_atom_lnk_pl, etc.

	: \regex_piece_lnk_pl

	pattern | match                      
	--------|----------------------------
	`(regex)` | \regex_lnk itself
	`()` | \empty_string_lnk
	`[...]` | see \bracket_expression_lnk
	`.` | any single character (but not the \empty_string_lnk)
	`^` | \empty_string_lnk at the beginning of a line
	`$` | \empty_string_lnk at the end of a line
	`\b` | \word_boundary_anc (the \empty_string_lnk between a \word_character_lnk and a \nword_character_lnk)
	`\<` | \empty_string_lnk at the beginning of a word (left \word_boundary_lnk)
	`\>` | \empty_string_lnk at the end of a word (right \word_boundary_lnk)
	`\^`, `\+`, etc. | `^`, `+`, etc.
	`a`, `b`, `1`, etc. | `a`, `b`, `1`, etc. (literal match)

	: \regex_atom_anc list

+ examples:

	+ `[0-9]*` matches an \empty_string_lnk or a string of digits

	+ `.* ` matches any character or an \empty_string_lnk followed by a space (e.g. `a `, `/ `, ` `)

	+ `[[:alpha:]]* ` matches any \alphabetic_character_lnk or an \empty_string_lnk followed by a space (e.g. `a `, ` `, but not `/ `, since `/` is not an \alphabetic_character_lnk)

	+ `\bhere\b` and `\<here\>` match `here` __whole word__

+ `|` separates multiple patterns, e.g. `abc|def` matches `abc` or `def`

+ precedence: __repetition__ > __concatenation__ > __alternation__, e.g. `abc|def` matches `abc` or `def`, `ab(c|d)ef` matches `abcef` or `abdef`

## \regex_pl kinds

+ \see

	```bash
	man grep
	man pcresyntax
	man pcrepattern
	```

+ most common kinds of a \regex_lnk:

	+ \basic_regex_anc

	+ \extended_regex_anc

	+ \Perl_compatible_regex_anc

\metacharacter_lnk_pl or \escape_sequence_lnk_pl | \basic_regex_lnk_pl | \extended_regex_lnk_pl and \Perl_compatible_regex_lnk_pl
-------------------------------------------------|------------------|--------------------
`?`, `+`, `{`, `}`, `|`, `(`, `)` | literal meaning | special meaning
`\?`, `\+`, `\{`, `}`, `\|`, `\(`, `\)` | special meaning | literal meaning

+ using \basic_regex_lnk_pl, \extended_regex_lnk_pl, or \Perl_compatible_regex_lnk_pl, find:

	+ `a` or `b`:

		```bash
		grep "a\|b" file.txt
		grep -E "a|b" file.txt
		grep -P "a|b" file.txt
		```

	+ at least two consecutive `a`'s:

		```bash
		grep "a\{2,\}" file.txt
		grep -E "a{2,}" file.txt
		grep -P "a{2,}" file.txt
		```

+ \Perl_compatible_regex_lnk_pl introduce several \escape_sequence_lnk_pl, e.g.

	\escape_sequence_lnk | match
	---------------------|-----
	`\t` | \horizontal_tab_lnk
	`\d` | a digit

+ find lines beginning with at least one \horizontal_tab_lnk:

	```bash
	grep -P "^\t+" file.txt
	```

## \regex_pl purpose

+ \regex_lnk_pl match portions of text

+ \regex_lnk_pl are used to search for a certain pattern and are not meant to span the whole text, e.g. `ab` matches `abc`, `abnormal`, `slab`

	+ however, some commands use \regex_lnk_pl to search for files and in that case they must span the whole pathname to possibly match it, e.g. `find -regex ".*bar."` matches `./fubar3`, but `find -regex bar` doesn't

## \glob_pl vs. \regex_pl

pattern | \glob_lnk |\regex_lnk
--------|------------|-----------
`*` | \any_string_lnk | zero or more copies of the preceding \regex_atom_lnk
`.*`| a dot followed by \any_string_lnk | \any_string_lnk
`?` | any single character | zero or one copy of the preceding \regex_atom_lnk
`.` | a dot | any single character
`[0-9]*` | a number followed by \any_string_lnk | zero or more digits

: matches for \glob_lnk and \regex_lnk

## \glob_pl and the shell

+ `[0-9]*` matches \filename_lnk_pl beginning with a number

+ `[ab]*` matches \filename_lnk_pl beginning with `a` or `b`

+ `|` separates multiple patterns with `extglob` option on, e.g. `*.@@(txt|dat)` matches filenames with `txt` and `dat` extension

+ put `./` directly before \glob_lnk_pl to avoid the problems when \filename_lnk_pl match command arguments --- e.g. there might be a file called `-n`, but `-n` is an option to e.g. `cat` command, however, using `./*` will expand to `./-n` which won't be treated as a command by the shell

+ inside double quotes all but `$`, `` ` `` and `\` characters lose their special meaning, so `*` and `?` globs are not expanded within double quotes by the shell:

	```bash
	for file in "./*.jpg"; do # WRONG!!!
		stat "$file"
	done
	```

	```bash
	for file in ./*.jpg; do # RIGHT!!!
		stat "$file"
	done
	```

+ but quoting argument with globs is necessary to avoid glob expansion when the argument is passed to a command:

	```bash
	mmv -v "[0-9]*" "p#1#2"
	find -iname "*.pdf"
	```

	+ if `*.pdf` above weren't quoted, the shell would expand it to the listing of all `*.pdf` files in the current directory and pass the resultant to the `find` command, which would most likely issue an error message

	+ only if there weren't any `*.pdf` files in the current directory, the quoted and unquoted versions would give the same result, so quoting is necessary

+ \globbing_lnk is not performed at variable assignment, so quoting is unnecessary, thus both lines do exactly same thing:

	```bash
	pattern=a*
	pattern="a*"
	```

	i.e., assign literal `a*` to the `pattern` variable

+ a variable containing \glob_lnk_pl shouldn't be quoted in loops to allow a glob expansion:

	```bash
	pattern=./*.pdf
	for file in $pattern; do
		ls "$file"
	done
	```

+ <a name="globs_and_regexes_extended_glob_example">\extended_glob_lnk_pl: perform some operations on all but `*.dat` and `*.txt` files and directories: use `!(pattern-list)`</a>:

	```bash
	shopt -s extglob
	for file in !(*.dat|*.txt); do
		stat "$file"
	done
	```

	note that `*!(.dat|.txt)` is wrong since `*` already matches all filenames, including those with `dat` and `txt` extensions, and the remaining \empty_string_lnk is always matched by `!(.dat|.txt)`, thus all files and directories are matched with this pattern

+ to delete all `file.*` files but `file.txt`, use:

	```bash
	shopt -s extglob
	rm -rf file.!(txt)
	```

	note that `!(file.txt)` would match all files and directories except for `file.txt`, and `file!(.txt)` would e.g. match `file_new.txt`

+ to match all files with names beginning with a non-digit followed by a digit followed by a non-digit (e.g. `a0_img.jpg`), use:

	```bash
	for file in [^0-9][0-9][^0-9]*; do
		stat "$file"
	done
	```
