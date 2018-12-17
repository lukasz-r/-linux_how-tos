
# \globs_and_regexes_anchor

## \getting_help

```bash
man 7 glob
man 7 regex
man wctype
man isalpha
```

## characters

\null_string_anchor

: the unique string of length zero

\any_string_anchor

: a \null_string_link or any sequence of characters

\blank_character_anchor

: a space or a tab

\whitespace_anchor

: one or more characters that represent horizontal or vertical space, e.g. a \blank_character_link, a vertical tab, a \newline

+ note that the above definitions of a \blank_character_link and a \whitespace_link are consistent with `man isalpha`, and \Vim_link's `:h [:blank:]` and `:h [:space:]` manuals, but not with \Vim_link's `:h \s` manual, according to which `\s` matches a \whitespace_link, whereas it in fact matches a \blank_character_link: but we'll stick to the __above definitions__ throughout the text

\nonbr_space_anchor

: a space preventing an automatic line break at its position

+ a \nonbr_space_link is inputted via \key{\AltGr_link}+\key{Space}

\empty_line_anchor

: a line with no characters at all

\blank_line_anchor

: an \empty_line_link or a line with only \blank_character_link\plural{s}

\case_sensitive_search_anchor

: a search strictly following the case of characters, e.g. `Ab` matching only `Ab`, not `ab`, `aB`, nor `AB`

\case_insensitive_search_anchor

: a search ignoring the case of characters, e.g. `ab` matching `ab`, `Ab`, `aB`, or `AB`

## features common for \glob_link\plural{s} and \regex_link\plural{es}

\character_class_anchor

: set of characters sharing a common property

\define{\globs_and_regexes_set{x}}{C_\mathrm{\x}}

	class | characters | set
	------|------------|----
	`[:upper:]` | uppercase letters | $\globs_and_regexes_set{upper}$
	`[:lower:]` | lowercase letters | $\globs_and_regexes_set{lower}$
	`[:alpha:]` | \alphabetic_character_anchor\plural{s} | $\globs_and_regexes_set{alpha} = \globs_and_regexes_set{upper} \cup \globs_and_regexes_set{lower}$
	`[:digit:]` | digits | $\globs_and_regexes_set{digit} = \{0, 1, \ldots, 9\}$
	`[:alnum:]` | \alphanumeric_character_anchor\plural{s} | $\globs_and_regexes_set{alnum} = \globs_and_regexes_set{alpha} \cup \globs_and_regexes_set{digit}$
	`[:blank:]` | \blank_character_link\plural{s} | $\globs_and_regexes_set{blank}$
	`[:space:]` | \whitespace_link | $\globs_and_regexes_set{space} \supset \globs_and_regexes_set{blank}$

	: \character_class_link\plural{es}

\equivalence_class_anchor

: e.g. `[=a=]`: all characters typographically equivalent to `a`, e.g. `a`, `ą`, `a`, `à`, `á`, `â`, `ä`, `å`

\bracket_expression_anchor

: a list of characters enclosed inside `[]`

	+ a \bracket_expression_link matches a single character from the list of characters

	+ the list can be given explicitly, as a range, as a \character_class_link, as an \equivalence_class_link, or as a compliment (negated list)

	expression | match
	-----------|------
	`[abc]` | `a`, `b`, or `c`
	`[0-9]`, `[[:digit:]]` | any digit
	`[^0-9jk]` | any non-digit non-`j` non-`k` character
	`[[=e=]]` | e.g. `e`, `ę`, `è`, `é`, `ê`, `ë`

	: \bracket_expression_link\plural{s}

## \glob_link composition

\glob_anchor

: a string with at least one `?`, `*`, or `[` character

	pattern | match
	--------|------
	`*` | \any_string_link
	`?` | any single character
	`[...]` | see \bracket_expression_link

	: \glob_link\plural{s}

\extended_glob_anchor

: a \glob_link or a string with at least one extended pattern matching operator

	pattern | match
	--------|------
	`(a|b)` | a or b
	`*(abc)` | zero or more `abc`'s
	`+(abc)` | one or more `abc`'s
	`?(abc)` | zero or one `abc`'s
	`@@(abc)` | exactly one `abc`
	`!(abc)` | anything except `abc`

	: extended pattern matching operators

	+ \extended_glob_link\plural{s} are turned on with `shopt -s extglob`

## \glob_link purpose

\globbing_anchor

: expansion of \glob_link\plural{s} into the list of \pathname_link\plural{s} matching the pattern

+ \glob_link\plural{s} are meant to match \filename_link\plural{s}

+ \globbing_link is applied separately on each \pathname_link component (the components are separated with `/`)

+ \glob_link\plural{s} must span the whole \filename_link to possibly match it, e.g. `*.txt` matches `file.txt`

## \regex_link composition

\regex_anchor

: one or more \regex_branch_link\plural{es} separated by `|`

	+ \regex_link matches anything that matches one of its branches

\regex_branch_anchor

: one or multiple concatenated (coming one after another) \regex_piece_link\plural{s}

	+ \regex_branch_link matches all strings that match its \regex_piece_link\plural{s}, in the order of \regex_piece_link\plural{s}

\regex_piece_anchor

: an \regex_atom_link followed by `*`, `+`, `?`, or `{...}` (a bound)

	pattern | match
	--------|------
	`atom*` | zero or more \regex_atom_link\plural{s}
	`atom+` | one or more \regex_atom_link\plural{s}
	`atom?` | zero or one \regex_atom_link
	`atom{2,}`, etc. | two or more \regex_atom_link\plural{s}, etc.

	: \regex_piece_link\plural{s}

	pattern | match
	--------|------
	`(regex)` | \regex_link itself
	`()` | \null_string_link
	`[...]` | see \bracket_expression_link
	`.` | any single character (but not the \null_string_link)
	`^` | the \null_string_link at the beginning of a line
	`$` | the \null_string_link at the end of a line
	`\^`, `\+`, etc. | `^`, `+`, etc.
	`a`, `b`, `1`, etc. | `a`, `b`, `1`, etc. (literal match)

	: \regex_atom_anchor\plural{s}

+ `[0-9]*` matches a \null_string_link or a string of digits

+ `.* ` matches any character or a \null_string_link followed by a space (e.g. `a `, `/ `, ` `)

+ `[[:alpha:]]* ` matches any \alphabetic_character_link or a \null_string_link followed by a space (e.g. `a `, ` `, but not `/ `, since `/` is not an \alphabetic_character_link)

+ `|` separates multiple patterns, e.g. `abc|def` matches `abc` or `def`

+ precedence: __repetition__ > __concatenation__ > __alternation__, e.g. `abc|def` matches `abc` or `def`, `ab(c|d)ef` matches `abcef` or `abdef`

+ in basic \regex_link\plural{es} some characters have to preceded with `\` to keep their special meaning, e.g.

	```bash
	grep "a\|b" file.txt
	grep -E "a|b" file.txt
	```

	both match `a` or `b` occurrences as `-E` option turns on extended \regex_link\plural{es}

## \regex_link purpose

+ \regex_link\plural{es} match portions of text

+ \regex_link\plural{es} are used to search for a certain pattern and are not meant to span the whole text, e.g. `ab` matches `abc`, `abnormal`, `slab`

	+ however, some commands use \regex_link\plural{es} to search for files and in that case they must span the whole pathname to possibly match it, e.g. `find -regex ".*bar."` matches `./fubar3`, but `find -regex bar` doesn't

## \glob_link\plural{s} vs. \regex_link\plural{es}

pattern | \glob_link |\regex_link
--------|------------|-----------
`*` | \any_string_link | zero or more copies of the preceding \regex_atom_link
`.*`| a dot followed by \any_string_link | \any_string_link
`?` | any single character | zero or one copy of the preceding \regex_atom_link
`.` | a dot | any single character
`[0-9]*` | a number followed by \any_string_link | zero or more digits

: matches for \glob_link and \regex_link

## \glob_link\plural{s} and the shell

+ `[0-9]*` matches \filename_link\plural{s} beginning with a number

+ `[ab]*` matches \filename_link\plural{s} beginning with `a` or `b`

+ `|` separates multiple patterns with `extglob` option on, e.g. `*.@@(txt|dat)` matches filenames with `txt` and `dat` extension

+ put `./` directly before \glob_link\plural{s} to avoid the problems when \filename_link\plural{s} match command arguments --- e.g. there might be a file called `-n`, but `-n` is an option to e.g. `cat` command, however, using `./*` will expand to `./-n` which won't be treated as a command by the shell

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

+ \globbing_link is not performed at variable assignment, so quoting is unnecessary, thus both lines do exactly same thing:

	```bash
	pattern=a*
	pattern="a*"
	```

	i.e., assign literal `a*` to the `pattern` variable

+ a variable containing \glob_link\plural{s} shouldn't be quoted in loops to allow a glob expansion:

	```bash
	pattern=./*.pdf
	for file in $pattern; do
		ls "$file"
	done
	```

+ \extended_glob_link\plural{s}: perform some operations on all but `*.dat` and `*.txt` files and directories: use `!(pattern-list)`:

	```bash
	shopt -s extglob
	for file in !(*.dat|*.txt); do
		stat "$file"
	done
	```

	note that `*!(.dat|.txt)` is wrong since `*` already matches all filenames, including those with `dat` and `txt` extensions, and the remaining \null_string_link is always matched by `!(.dat|.txt)`, thus all files and directories are matched with this pattern

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
