
# BASH

## \getting_help

	```bash
	info bash
	```

## case of variable names

+ good practices for variable capitalization in scripts:

	+ uppercase for:

		+ environment variables (`PAGER`, `EDITOR`, etc.) and internal shell variables (`SHELL`, `BASH_VERSION`, etc.)

		+ exported variables (`export BLAS_LIB=...`)

		+ constants (`PI=3.14`)

	+ lowercase for:

		+ variables local to a script (`src_dir=/opt/ga`)

## error handling

+ example of terribly bad scripting:

	```bash
	cd dir
	rm *
	```

	+ if `dir` doesn't exist, all files in the current directory are removed

	+ no action should be performed if `dir` doesn't exist

## shell builtins

+ shell builtin command (shell builtin) is provided by the shell and is executed directly in the shell itself (e.g. `.`, `source`), and can affect the state of the shell (e.g. a current directory, therefore `cd` needs to be a shell builtin)

+ get help on the `shopt` builtin: `help shopt`

+ external command is provided by an external program and is loaded and executed by the shell (e.g. `ls`, `stat`)

+ get help on the `stat` command: `man stat`

+ show the full path of the `stat` command: `which stat`

+ shell builtins work much faster than external programs

## running commands

+ if the command name has no slashes, the shell tries to locate an object by that name in the following order:

	+ a function

	+ a shell builtin

	+ a file in directories contained in `PATH`

	the search stops once a match is found

+ if the command name contains slashes, no search is performed

+ the command is executed __in the separate shell__, thus it inherits only exported variables and functions and can't modify the state of the current shell

+ examples:

	+ `ls /tmp`: no slash (`/`) in the command (`ls`), it's not a shell builtin, shell looks for the `ls` file in directories contained in `PATH` and executes it using the first path found

	+ `/usr/bin/ls /tmp`: slash (`/`) in the command (`/usr/bin/ls`), shell executes the `/usr/bin/ls` file without any search through the `PATH`

	+ `./file`: same thing as above (the `file` file is in the current directory)

## sourcing files

+ using `.` or `source` bultin: `. filename` or `source filename` reads commands from `filename` and executes them __in the current shell__, thus all variables and functions are inherited and the state of the current shell can be modified

+ source the script instead of executing it if you want the script to modify the current shell state, e.g. set or change some variables, or if the scripts needs all variables and functions set in the current shell, not only the exported ones

+ examples:

	+ `. file` or `source file`: no slash (`/`) in the filename (`file`), shell looks for the `file` file in directories contained in `PATH` and executes commands from the file in the current shell using the first path found

	+ `. ./file` or `source ./file`: slash (`/`) in the filename (`./file`), so shell executes commands from the file in the current directory in the current shell without any search through the `PATH`

## shell grammar

+ pipeline:

	`command1 | command2`: send stdout of `command1` to stdin of `command2` through a pipe (`|`)

	`command1 |& command2`: also send stderr

	+ it's the stdout of the command on the left that is sent, not its arguments, e.g. `echo a | echo` prints nothing, since `echo` (see `help echo`) sends its arguments, not stdin, to stdout

	+ each command in a pipeline is executed in a subshell

	+ e.g. `find ~/Documents/ -ctime -5 | sort`

+ list: one or more pipelines separated with `;`, `&`, `&&`, or `||`

	+ `command &`: `command` executed in a subshell in the background

	+ commands separated by `;` are executed sequentially

	+ AND list: `command1 && command2`: `command2` executed only if `command1` returns a zero exit status

	+ OR list: `command1 || command2`: `command2` executed only if `command1` returns a non-zero exit status

	+ e.g. `cd "$dir" && rm -fv ./* | tee ../out.txt`

+ compound command:

	+ `(list)`: list executed in a subshell

	+ `{ list; }`: list executed in a current shell

+ examples:

	+

		```bash
		a=1
		a=2 && echo -n "$a" | tee out.txt
		echo -n "$a"
		```

		outputs `22` since a list is composed of `a=2` assignment performed in a current shell, and `echo -n "$a" | tee out.txt` pipeline

	+

		```bash
		a=1
		{ a=2 && echo -n "$a"; } | tee out.txt
		echo -n "$a"
		```

		outputs `21` since the `{ a=2 && echo -n "$a"; }` compound command is executed in a subshell since it's a part of a pipeline, so it can't change the state of the shell

	+

		```bash
		a=1
		{ a=2; echo -n "$a"; }
		echo -n "$a"
		```

		outputs `22` since the `{ a=2; echo -n "$a"; }` compound command is executed in a current shell

	+

		```bash
		a=1
		(a=2; echo -n "$a")
		echo -n "$a"
		```

		outputs `21` since the `(a=2; echo -n "$a")` compound command is executed in a subshell

# start and stop exporting variables:
set -a
CC=icc
CXX=icpc
FC=ifort
set +a

# the lists in BASH are formed by a word splitting based on the "IFS" variable (which is usually <space><tab><newline>), e.g.
file1 file2 "file 3"
# expands to three words; you can loop through list elements:
for file in file1 file2 "file 3"; do
	ls -all "$file"
done
# but
file1 file2 file 3
# expands to four words (no double quotes over file 3)

--------------------------------------------------------------------------------
# the order of expansion:
--------------------------------------------------------------------------------
## brace expansion: /home/{a,b{1,2}}
## tilde expansion: ~luke/.bashrc
## parameter: "$1", and variable expansion: "${VAR:2:5}"
## command substitution: "$(which ls)"
## arithmetic expansion: j=$((i + 2)), but it's easier to use ((j = i + 2))
## word splitting: file1 file2 "file 3" # splits into three words
## pathname expansion (globs): ./*.txt (might happen when "*", "?", or "[...]" characters are present, the dot, ".", doesn't have special meaning with globs)
# this way you can e.g. loop through the files:
for file in "$HOME"/foo/bar{1,2,3} "$HOME"/{x1,"x 2"}.txt; do
	stat "$file"
done
# the list above expands to the words:
/home/luke/foo/bar1
/home/luke/foo/bar2
/home/luke/foo/bar3
/home/luke/x1.txt
/home/luke/x 2.txt

# note that
"$HOME/foo/bar{1,2,3}"
# construct won't expand (except for "$HOME" expansion) as curly brackets are in double quotes

# use curly brackets with variable expansion when concatenating variables with a character allowed in variable names (alphanumeric or underscore character):
CC=icc
CC_VERSION=14
echo $CC_$CC_VERSION   # 14 ("CC_" variable not defined)
echo ${CC}_$CC_VERSION # icc_14

# use array variables to store results of a brace expansion:
back_dirs=(~luke/{Documents,Pictures}) # RIGHT!!!
echo "${back_dirs[@]}"                 # /home/luke/Documents /home/luke/Pictures
back_dirs=~luke/{Documents,Pictures}   # WRONG!!!
echo "$back_dirs"                      # /home/luke/{Documents,Pictures}
# brace expansion produces a list, and a scalar variable can't hold a list

# "$@" expands to script arguments as separate words: "$1" "$2" ... "${n}", so
for arg in "$@"; do
	ls -all $arg # WRONG!!!
done
# is wrong, because arguments may contain spaces and then will be split into words when called as "$arg"!
for arg in "$@"; do
	ls -all "$arg" # RIGHT!!!
done

# double quotes for variable assignment, case construct, and "[[ ... ]]" are not necessary since word splitting doesn't take place:
var=$file # RIGHT!!!
var="$file" # ALSO RIGHT!!!
PATH=$PATH:$HOME/scripts # RIGHT!!!
PATH="$PATH:$HOME/scripts" # ALSO RIGHT!!!
fullpath=$(readlink -f -- "$file") # RIGHT!!!
fullpath="$(readlink -f -- "$file")" # ALSO RIGHT!!!
# note that "--" means end of options, useful if there's a file beginning with "-"
case $1 in # RIGHT!!!
case "$1" in # ALSO RIGHT!!!
[[ -d $dir ]] && ls -d "$dir" # RIGHT!!!
[[ -d "$dir" ]] && ls -d "$dir" # ALSO RIGHT!!!

+ double quotes aren't necessary associative array subscripts:

	```bash
	sub="nice animal"
	declare -A table
	table[$sub]=cat
	```

# don't use double quotes with variables holding command options: if a variable is null, it is retained and passed explicitly as '' when quoted, but is removed when unquoted (desired behaviour), so:
rsync -ahPvz "$OPTS" src dest # WRONG!!!
# the above leads to problems if $OPTS is null, so always use
rsync -ahPvz $OPTS src dest # RIGHT!!!
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
# globs vs. regexs [difference between wildcard patterns (globs) and regular expressions (regexs)]
--------------------------------------------------------------------------------
## globs match filenames
## globbing is applied separately on each pathname component (the components are separated with "/")
## globs must span the whole filename to possibly match it, e.g. "*.txt" matches "file.txt"

## regexs match portions of text
## regexs are used to search for a certain pattern, e.g. "ab" matches "abc", "abnormal", "slab"
## exception: regex in "find -regex" is not a search and must match the whole path, e.g. ".*bar." matches "./fubar3", but "bar" doesn't

## globs:
### "*" matches any string (including the null string)
### "?" matches any single character
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
### but quoting is necessary to avoid glob expansion when an argument with globs needs to be passed to a command:
mmv -v "[0-9]*" "p#1#2"
find -iname "*.pdf"
### if "*.pdf" above weren't quoted, the shell would expand it to the listing of all "*.pdf" files in the current directory and pass the resultant to the find command, which would most likely issue an error message; only if there weren't any "*.pdf" files in the current directory, the quoted and unquoted versions would give the same result, so quoting is necessary
### globbing is not performed for variable assignment:
pattern=a*
### assigns literal "a*" to the "pattern" variable
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

## regexs:
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
### in basic regexs some characters have to preceded with "\" to keep their special meaning, e.g.
grep "a\|b" file.txt
grep -E "a|b" file.txt
### both match "a" and "b" occurrences as "-E" option turns on extended regexs
--------------------------------------------------------------------------------

# never pass the ls command result to anything!
for file in $(ls ./*.jpg); do # COMPLETELY WRONG!!!
	cat "$file"
done
# ls is just meant to display a human-readable output, not to form a list, for that simply use globs:
for file in ./*.jpg; do # RIGHT!!!
	cat "$file"
done

# when there are no files matching a given pattern in a "for" loop, the looping variable becomes literally that pattern (e.g. "./*"), to avoid that, use "nullglob" option, so that the looping variable becomes null in such a case:
shopt -s nullglob
files=()
for file in ./*.jpg; do
	[[ -f $file ]] && files+=("$file")
done
# notice above how files can be added to an array

# loop over directories but not their subdirectories (note the trailing "/" in the glob):
shopt -s nullglob dotglob
for dir in ./*/; do
	echo "$dir"
done

# loop over directories recursively:
shopt -s nullglob dotglob globstar
for dir in ./**/; do
	du -hs "$dir"
done

# loop just over the directories of given patterns recursively and case-insensitively without using find:
shopt -s nullglob dotglob globstar nocaseglob
for dir in ./**/*sth*/; do
	ls -all "$dir"
done

# loop over files recursively:
shopt -s nullglob dotglob globstar
for file in ./**/*; do
	[[ -f $file ]] && file "$file"
done

# loop over files of given patterns recursively and case-insensitively without using find:
shopt -s nullglob dotglob globstar nocaseglob
for file in ./**/*.tex; do
	[[ -f $file ]] && enca -l pl "$file"
done

# perform some action on each line in a file:
while read line; do
	echo "$line"
done < "$1"

# perform some action on each array's element:
files=("$HOME"/foo/bar{1,2,3} "$HOME"/{x1,"x 2"}.txt)
for i in "${!files[@]}"; do
	files[$i]="$PWD/${files[$i]}"
done

# check if any arguments have been supplied to the script:
if [ $# -eq 0 ]; then
	echo "no"
else
	echo "yes"
fi

# loop over the script arguments:
for arg in "$@"; do
	echo "$arg"
done
# or simply (it really works, you can use any thus far unset variable name):
for arg do
	echo "$arg"
done

--------------------------------------------------------------------------------
# conditional expressions:
--------------------------------------------------------------------------------
## are used in "[[ ... ]]", "[ ... ]" and "test" to test file attributes and perform string and arithmetic comparisons

## "[[ ... ]]" is a compound command and returns "0" or "1", word splitting is not performed

## "[" is a BASH builtin (see "help [") and is simply a synonim for "test", but must be terminated with the closing "]", word splitting is performed (because [" = "test" are commands, so their arguments undergo word splitting), so double quotes must be used

## "if list1; then list2; fi" executes "list2" if "list1" returns "0"

## the following are equivalent:
[[ -d $file ]] && echo "$file is a dir"
[ -d "$file" ] && echo "$file is a dir"
test -d "$file" && echo "$file is a dir"

## within "[[ ... ]]", "&&" and "||" operators might be used

## within "[ ... ]", "-a" and "-o" operators might be used

## the following are equivalent:
if [[ -f $file && ! -s $file ]]; then echo "$file is an empty file"; fi
if [ -f "$file" -a ! -s "$file" ]; then echo "$file is an empty file"; fi
if test -f "$file" -a ! -s "$file"; then echo "$file is an empty file"; fi

## "==", "!=", "<", ">" operators compare strings

## "==" within "[[ ... ]]" can be used for globbing-like pattern matching (so the pattern must span the whole string):
[[ $text == z* ]] && echo "\"$text\" begins with \"z\""

## "==" within "[ ... ]" and "test" checks for an exact string match (globs lead to file globbing):
[ "$text" == zet ] && echo "\"$text\" is \"zet\""

## "=~" within "[[ ... ]]" is used for regex matching (so the pattern doesn't have to span the whole string):
[[ $text =~ [0-9]+ ]] && echo "\"$text\" contains at least one digit"
[[ $text =~ ^[[:alpha:]] ]] && echo "\"$text\" starts with a letter"

## the following are equivalent:
[[ $text == *.* ]] && echo "there's a dot in \"$text\""
[[ $text =~ \. ]] && echo "there's a dot in \"$text\""

## negated regex condition:
[[ ! $text =~ \. ]] && echo ""there's no dot in \"$text\"

## note that "[[ $text =~ . ]]" is true for any non-null "$text" variable

## "-eq", "-ne", "-lt", "-le", "-gt", "-ge" operators compare integers

## integers can also be compared with "((n1 > n2))"-type compound command using more "integer-friendly" "==", ">", etc. operators, within which the variables don't need the dollar ("$") sign

## the following are equivalent:
[[ $n1 -gt $n2 && $n1 -gt 0 ]] && echo "positive number $n1 is greater than $n2"
[ "$n1" -gt "$n2" -a "$n1" -gt 0 ] && echo "positive number $n1 is greater than $n2"
((n1 > n2 && n1 > 0)) && echo "positive number $n1 is greater than $n2"

## "[[ ... ]]" − conditional expression evaluation
## "((...))" − arithmetic expression evaluation

## true/false checking:
true=1
false=0
((true)) && echo "true"  # echoes "true"
((false)) && echo "true" # echoes nothing

## use "(list)" or "{ list; }" compound command to group multiple commands:
dir=~/my_dir
[[ -d $dir ]] && { echo "$dir exists"; exit 0; } # compound command executed in a current shell environment (closes a current terminal tab or exits a script if check true)
[[ -d $dir ]] && (echo "$dir exists"; exit 0)    # compound command executed in a subshell environment (doesn't close a current terminal tab nor exits a script even if check true, so it's not a proper solution with "exit 0")
[[ -d $dir ]] && echo "$dir exists"; exit 0      # "exit 0" always executed regardless of the check result, so it's a wrong solution!

## test if a file is executable by a user:
file=/opt/intel/mkl/bin/mklvars.sh
[[ -x $file ]] && echo "$file is executable"
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
# arithmetic operations
--------------------------------------------------------------------------------
## examples:
i=10
j=20
((i++))
((i += 2))
((k = i + j))
echo "result = $k"

## use variable pre-increment ("++var") to change *.mp4 filenames into consecutive numbers starting with 1 and appended with titles from the "titles.txt" file:
### array indices start with 0
### we don't use variable post-increment ("var++") since we want filename numbers to start with 1, not with 0
-------------------------------------------------------
script.sh
-------------------------------------------------------
#!/bin/bash

files=()
ext=mp4
for file in ./*."$ext"; do
	files+=("$file")
done

ifile=0
while read line; do
	mv -iv "${files[$ifile]}" "$((++ifile)) - $line.$ext"
done < titles.txt
-------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
# redirection
--------------------------------------------------------------------------------
## stdin (file no. 0) is read from a terminal, stdout (file no. 1) and stderr (file no. 2) are sent to a terminal (TTY, say "/dev/tty0"), so the file descriptor table after BASH starts looks like
## 0 → /dev/tty0
## 1 → /dev/tty0
## 2 → /dev/tty0

## when we run
make > make.log
## the table looks like
## 0 → /dev/tty0
## 1 → make.log
## 2 → /dev/tty0

## when we run
make 2> make.err
## the table looks like
## 0 → /dev/tty0
## 1 → /dev/tty0
## 2 → make.err

## redirections are processed from left to right, so when we run
make > make.log 2>&1
## after "> make.log" the table looks like
## 0 → /dev/tty0
## 1 → make.log
## 2 → /dev/tty0
## and after "2>&1" (which makes file descriptor "2" to point to where "1" points) the table looks like
## 0 → /dev/tty0
## 1 → make.log
## 2 → make.log
## the same can be achieved with "&>" or ">&" operators (see below)

## but! when we run
make 2>&1 > make.log
## after "2>&1" the table looks like
## 0 → /dev/tty0
## 1 → /dev/tty0
## 2 → /dev/tty0
## so nothing changes, and after "> make.log" the table looks like
## 0 → /dev/tty0
## 1 → make.log
## 2 → /dev/tty0a
## so stderr is still sent to a terminal, not to a file!

## redirect only stdout to a file:
make > make.log

## redirect both stdout and stderr to a file:
make &> make.log

## redirect both stdout and stderr to a file and to a screen:
make |& tee make.log

## suppress error messages by redirecting them to "/dev/null":
find /tmp -iname "*rekonq*" 2>/dev/null
--------------------------------------------------------------------------------

# prefix or suffix removal (e.g. easily get filename and extension):
## "#", "##" remove matching prefix (shortest, longest)
## "%", "%%" remove matching suffix (shortest, longest)
file=file.name.tar.gz
echo $file			# file.name.tar.gz
echo ${file#*.}		# name.tar.gz
echo ${file##*.}	# gz
echo ${file%.*}		# file.name.tar
echo ${file%%.*}	# file

# pattern substitution:
## replace a first dot (".") with a space (" ") in a string:
echo ${text/./ }
## replace all dots (".") with spaces (" ") in a string:
echo ${text//./ }
## remove all non-digits from a string:
echo ${text//[^0-9]}

# case modification:
## convert first character in a string to lowercase:
${text,}
## convert a string to lowercase:
${text,,}
## convert first character in a string to uppercase:
${text^}
## convert a string to uppercase:
${text^^}
## convert first character of each word in a filename to uppercase:
file_words=($file)
echo "${file_words[*]^}"
## note that:
### "${file_words[@]}" expands each array element to a separate word: "${file_words[0]}" "${file_words[1]}" ...
### "${file_words[*]}" expands to a single word: "${file_words[0]} ${file_words[1]} ...", thus this construct is appropriate for filename changes
## convert first character of each word not beginning with "u" in a filename to uppercase:
shopt -s extglob
file_words=($file)
echo "${file_words[*]^!(u)}"

# substring expansion: "${parameter:offset}" or "${parameter:offset:length}", offset counted from 0:
text="abc456"
echo ${text:1}      # bc456
echo ${text:3:2}    # 45
echo ${text::1}     # a

# print only digits from a string:
echo "$text" | tr -dc '[:digit:]'
# or:
echo ${text//[^0-9]}

# remove all non-numeric characters before a first digit in a string:
shopt -s extglob
${text##*([^0-9])}

# note that:
text="a b c 1 d 2"; echo ${text#*([^0-9])}; echo ${text#+([^0-9])}
# yields "a b c 1 d 2" and " b c 1 d 2" (note leading space), respectively, since in the first case the shortest match is null ("*" matches zero or more occurrences) and in the second case the shortest match is "a" ("+" matches one or more occurrences)

# remove leading whitespace from a string:
shopt -s extglob
echo ${text##+([[:space:]])}

# remove trailing whitespace from a string:
shopt -s extglob
echo ${text%%+([[:space:]])}

# remove all whitespace from a string:
echo ${text//[[:space:]]}

# don't use the cat command in a following way:
cat "$file" | grep sth # WRONG!!!
# it's redundant, simply use
grep sth "$file" # RIGHT!!!
# cat is only meant to join files

# set echo on (useful for debugging):
set -x

# pad one-digit integers with zeroes (e.g. "1" → "01") , leave two-digit integers unchanged (e.g. "12" → "12"):
printf "%02d" "$num"

# unfreeze the terminal frozen by pressing <CTRL>+"s" (usually happens accidentally in vim):
<CTRL>+"q"
# <CTRL>+"s" = XOFF (transmit off)
# <CTRL>+"q" = XON (transmit on)

--------------------------------------------------------------------------------
# history expansion
--------------------------------------------------------------------------------
## "!" not followed by a blank, newline, carriage return, "=", nor "(" starts a history substitution which allows to pick specific events, event words, and modify them before executing again

--------------------------------------------------------------------------------
## the history expansion syntax:
event[:word[:modifiers]]
--------------------------------------------------------------------------------
## events:
--------------------------------------------------------------------------------
### !-n − the current command minus n
### !! = !-1 − the previous command
### !# − the entire command typed so far
### "!" directly followed by words and modifiers refers to the previous command just like "!!"
--------------------------------------------------------------------------------
## words:
--------------------------------------------------------------------------------
### note that arguments also encompass options passed to commands, thus in most cases it's better use "$" to refer to the last argument than "^" to refer to the first one, which might actually be an option
### 0 − the command name (word 0)
### ^ − the first argument (word 1)
### n − the nth argument (word n)
### $ − the last argument (the last word)
### * = 1-$ − all arguments
### n* = n-$ − arguments from nth to the last one
### n- − all arguments from nth to the penultimate one
### "^", "$", "*" don't need to be preceded with ":"
--------------------------------------------------------------------------------
## modifiers:
--------------------------------------------------------------------------------
### h − remove a trailing filename from a pathname, leaving only its head
### t − remove all leading pathname components, leaving a filename
### r − remove a trailing ".xxx" suffix, leaving the basename
### e − extract the trailing ".xxx" suffix (including ".")
### p − print the new command but do not execute it
--------------------------------------------------------------------------------
## e.g.
--------------------------------------------------------------------------------
### !^ = !!^ − the first argument of the previous command
### !$ = !!$ − the last argument of the previous command
### !* = !!* − all arguments of the previous command
### !#^:h − the head of the pathname of the first argument in the command typed so far
### !$:p = !!$:p − print the last argument of the previous command
--------------------------------------------------------------------------------
echo file !#^	                # file file
echo -e file !#^                # file -e
echo -e file !#$                # file file
mv -iv "system file" !#$.backup # 'system file' -> 'system file.backup' (no need to quote designators, spaces are handled properly with and without single or double quotes)
echo /usr/bin !#$:h             # /usr/bin /usr
echo /usr/bin !#$:t             # /usr/bin bin
echo file.txt !#$:r             # file.txt file
echo file.txt !#$:e             # file.txt .txt
!$:p                            # .txt ("!#$:e" in the previous command has been replaced with ".txt")
--------------------------------------------------------------------------------

## history expansion designators are replaced immediately and the replacements, not the designators, are printed and available in the history
## globs are not replaced by their expansions in the history
## thus history expansion designators trigger globs, not their expansions:
ls file* # file1.txt  file2.txt
ls -l !^ # replaced immediately with "ls -l file*", thus a glob and not its expansion replaces "!^"
history | tail -3
------------------------------------------------------------
output
------------------------------------------------------------
 1490  ls file*
 1491  ls -l file*
 1492  history | tail -3
------------------------------------------------------------
## we have "ls -l file*" instead of "ls -l !^" in the history

## access last argument of the previous command:
file --mime file
mv -iv !$ !$.jpg

## print the last argument of the previous command:
!$:p

## access all arguments of the previous command that was invoked without any options:
file file1.txt file2.txt
ls -l !*

## access all arguments of the previous command that was invoked with some options:
file --mime file1.txt file2.txt
ls -l !:2*
## note that "ls -l !*" would pass the "--mime" option as an argument to "ls"
## we have to supply the starting position of arguments (here: 2)

## repeat the previous command (very useful with sudo):
dnf upgrade
sudo !!

## search the command history:
### press <CTRL>+"r" and type part of a command, if not found look further by pressing <CTRL>+"r" again, if found edit it with left/right arrows etc. and execute the command with <ENTER>
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
# prompting:
--------------------------------------------------------------------------------
## PS1 − the primary prompt string, displayed when BASH is executed interactively and ready to read a command
## PS2 − the secondary prompt string, displayed when BASH is executed interactively and needs more input to complete a command
## e.g. PS1="[\u@\h \W]\$ " and PS2="> ":
### \u − the username of the current user
### \h − the hostname up to the first "."
### \W − the basename of the current working directory
### \$ − "#" if EUID = 0 (root), "$" otherwise
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
# command-line navigation with BASH shortcuts:
--------------------------------------------------------------------------------
## <CTRL>+"a" − go to the beginning of a command
## <CTRL>+"e" − go to the end of a command
## <ALT>+"b" − move back one word
## <ALT>+"f" − move forward one word
## <CTRL>+"w" − delete from the cursor to the beginning of a word (backwards)
## <ALT>+"d" − delete from the cursor to the end of a word (forwards)
## <ALT>+"u" − convert to uppercase from the cursor to the end of a word (forwards)
## <ALT>+"l" − convert to lowercase from the cursor to the end of a word (forwards)
--------------------------------------------------------------------------------
