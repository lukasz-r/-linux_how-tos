
# globs and regexes

+ \getting_help

```bash
man 7 glob
man 7 regex
```

## main differences between globs and regexes

glob (wildcard pattern)
: a string with one of the characters `?`, `*` or `[`

	pattern | match
	--------|-------------------------------------------
	`*`     | any string __(including the null string)__
	`?`     | any single character
	`[...]` | any character inside

	: globs

+ `shopt -s extglob` turns on additional pattern matching operators

	pattern  | match
	---------|---------------------
	`(a|b)`  | a or b
	`*(abc)` | zero or more `abc`'s
	`+(abc)` | one or more `abc`'s
	`?(abc)` | zero or one `abc`'s
	`@(abc)` | exactly one `abc`
	`!(abc)` | anything except `abc`

	: extended globs

globbing
: expansion of globs into the list of pathnames matching the pattern

+ globs are meant to match filenames

+ globbing is applied separately on each pathname component (the components are separated with `/`)

+ globs must span the whole filename to possibly match it, e.g. `*.txt` matches `file.txt`

regex (regular expression)
: one branch or multiple branches separated by `|`

+ regex matches anything that matches one of its branches

branch
: one or multiple concatenated pieces

+ branch matches all strings that match its pieces, in the order of pieces

piece
: an atom followed by `*`, `+`, `?`, or a bound (`{...}`)

	pattern          | match
	-----------------|-------------------
	`atom*`          | zero or more atoms
	`atom+`          | one or more atoms
	`atom?`          | zero or one atom
	`atom{2,}`, etc. | two or more atoms, etc.

	: pieces

	pattern             | match
	--------------------|------
	`(regex)`           | regex itself
	`()`                | __null string__
	bracket expression  | any character in a list
	`.`                 | any single character
	`^`                 | the null string at the beginning of a line
	`$`                 | the null string at the end of a line
	`\^`, `\+`, etc.    | `^`, `+`, etc.
	`a`, `b`, `1`, etc. | `a`, `b`, `1`, etc. (literal match)

	: atoms

+ regexes match portions of text

+ regexes are used to search for a certain pattern and are not meant to span the whole text, e.g. `ab` matches `abc`, `abnormal`, `slab`

	+ however, some commands use regexes to search for files and in that case they must span the whole pathname to possibly match it, e.g. `find -regex ".*bar."` matches `./fubar3`, but `find -regex bar` doesn't

## globs:
### "[0-9]*" matches filenames beginning with a number
### "[ab]*" matches filenames beginning with "a" or "b"
### "|" separates multiple patterns with "extglob" option on, e.g. "*.@(txt|dat)" matches filenames with "txt" and "dat" extension
### use "./" with globs to avoid filenames matching command arguments − e.g. there might be a file called "-n", but "-n" is an option to e.g. cat command, however, using "./*" will expand to "./-n" which won't be treated as a command
### inside double quotes all but "$", "`" and "\" characters lose their special meaning, so "*" and "?" globs are not expanded within double quotes by the shell:
for file in "./*.jpg"; do # WRONG!!!
stat "$file"
done
for file in ./*.jpg; do # RIGHT!!!
stat "$file"
done
### but quoting argument with globs is necessary to avoid glob expansion when the argument is passed to a command:
mmv -v "[0-9]*" "p#1#2"
find -iname "*.pdf"
### if "*.pdf" above weren't quoted, the shell would expand it to the listing of all "*.pdf" files in the current directory and pass the resultant to the find command, which would most likely issue an error message; only if there weren't any "*.pdf" files in the current directory, the quoted and unquoted versions would give the same result, so quoting is necessary
### globbing is not performed at variable assignment, so quoting is unnecessary, thus both lines do exactly same thing:
pattern=a*
pattern="a*"
### assign literal "a*" to the "pattern" variable
### a variable containing globs shouldn't be quoted in loops to allow a glob expansion:
pattern=./*.pdf
for file in $pattern; do
	ls "$file"
done
### extended globs: perform some operations on all but "*.dat" and "*.txt" files and directories: use "!(pattern-list)":
shopt -s extglob
for file in !(*.dat|*.txt); do
	stat "$file"
done
### note that "*!(.dat|.txt)" is wrong since "*" already matches all filenames, including those with "dat" and "txt" extensions, and the remaining null string is always matched by "!(.dat|.txt)", thus all files and directories are matched with this pattern
### to delete all "file.*" files but "file.txt", use:
shopt -s extglob
rm -rf file.!(txt)
### note that "!(file.txt)" would match all files and directories except for "file.txt", and "file!(.txt)" would e.g. match "file_new.txt"
### to match all files with names beginning with a non-digit followed by a digit followed by a non-digit (e.g. "a0_img.jpg"), use
for file in [^0-9][0-9][^0-9]*; do
	stat "$file"
done

## regexes:
### "*" matches zero or more copies of the preceding thing
### "?" matches zero or one copy of the preceding thing
### "+" matches one or more copies of the preceding thing
### "." matches any single character (but not the null string)
### ".*" matches any string (including the null string)
### "[0-9]*" matches null strings and strings of digits
### ".* " matches any characters (including null) followed by a space (e.g. "a ", "/ ", " ")
### "[[:alpha:]]* " matches any alphabetic characters (including null) followed by a space (e.g. "a ", " ", but not "/ ", since "/" is not an alphabetic character)
### "|" separates multiple patterns, e.g. "abc|def" matches "abc" and "def"
### precedence: repetition > concatenation > alternation, e.g. "abc|def" matches "abc" and "def", "ab(c|d)ef" matches "abcef" and "abdef"
### in basic regexes some characters have to preceded with "\" to keep their special meaning, e.g.
grep "a\|b" file.txt
grep -E "a|b" file.txt
### both match "a" and "b" occurrences as "-E" option turns on extended regexes
