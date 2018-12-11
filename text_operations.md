
# \text_operations_anchor

## \sed_anchor

+ replace some patterns in a file and write changes directly to that file:

	```sed
	sed -i 's/old/new/g' file
	```

+ remove lines containing the `hello` string:

	```sed
	sed '/hello/d' file
	```

+ convert pattern to lowercase:

	```sed
	sed 's/Login/\L&/g' file
	```

+ remove lines containing repeated characters, say 1 to 100 star signs (`*`):

	```sed
	sed '/\*\{1,100\}/d' file
	```

+ print lines from $730$th to the last one of a file:

	```sed
	sed -n '730,$p' file
	```

+ insert variable with newlines into a given line of a file:

	`script.sh`:

	```bash
	#!/bin/bash
	(...)
	# var is a variable with newline characters (multiline variable)
	# insert var in a file "$out" at line number n
	n=3
	echo "$var" | while read line; do
		sed -i "$n i\\$line" "$out"
		((n++))
	done
	```

## \AWK_anchor

### \getting_help

```bash
man awk
info gawk
```

### \AWK_link basics

+ \AWK_link program consists of a series of \AWK_rule_anchor\plural{s} of the form:

	```awk
	pattern {action}
	```

	\AWK_pattern_link | description
	------------------|------------
	`/regex/` | a line matches a a \regex_link (which must be enclosed in slashes)
	`! /regex/` | a line doesn't match a \regex_link
	`$1 == "li"` | a first field in a line is precisely `li` (exact match)
	`$1 ~ /li/` | a first field in a line contains `li` (\regex_link match)
	no pattern | all lines match

	: \AWK_pattern_link examples

+ user function definitions can go anywhere, e.g. in the beginning of the script

### examples

+ `print` takes a list of strings, separated by commas, and prints them separated with spaces:

	```awk
	{print $1, $2}
	```

+ putting list of strings separated by spaces instead of commas concatenates them into one string:

	```awk
	{print $1 $2}
	```

+ executable \AWK_link scripts: use

	```awk
#!/usr/bin/awk -E
	```

	in the first line of the script

+ print $n$th line of a file:

	```bash
	n=100
	awk "NR == $n" input.txt
	```

+ perform an action for the first line of the input and another action for other lines:

	```awk
	NR == 1 {print $1}
	NR > 2 {print $2}
	```

+ pass a function as an argument to a function:

	```awk
	function stats(num, transform) {
		return @@transform(num)
	}
	stats(num, "age_transform")
	```

+ given a plain text file containing a list in a form:

	`input`:

	```bash
	1. one ...
	2. two ...
	(...)
	```

	create a html file with a html list --- use \AWK_link to replace each number (`1.`, `2.`, ...) with `<LI>`:

	```bash
	awk '{if ($1 ~ /^[0-9]/) $1 = "<LI>"; print}' input > output
	```

	+ this changes only lines beginning with a number possibly following whitespace

	+ to make a list visible in html, wrap the list in `<OL>` and `</OL>` tags

	+ note that

		```bash
		awk '/^\s*[0-9]/ {$1 = "<LI>"; print}' input > output
		```

		would only print the lines beginning with a number possibly following whitespace (here we need to add `\s*`), so we need to use `if` as above to print other lines as well

+ for lines containing at least $5$ `=` characters, cut everything after $80$th column:

	```bash
	awk '/={5,}/ {print substr($0, 1, 80)}' file
	```

	do the above thing, but also print all other lines:

	```awk
	{if ($0 ~ /={5,}/) print substr($0, 1, 80); else print $0}
	```

+ for a LaTeX file with comments below commands, move the comments above the commands:

	`script.awk`:

	```awk
#!/usr/bin/awk -E

	BEGIN { RS = ""; FS = "\n" }

	{
		if ($NF ~ /^\s*%/) {
			print $NF
			for (i = 1; i < NF; i++) print $i
		} else
			print
		print RS
	}
	```

	```bash
	./script.awk input.sty > output.sty
	```

+ convert a table to LaTeX format:

	`script.awk`:

	```awk
	#!/usr/bin/awk -E

	BEGIN {
		OFS = " & "
		ORS = " \\\\\n"
	}
	$1 = $1
	```

	```bash
	./script.awk tab.dat > tab.tex
	```

	note that the use of `$1 = $1` makes \AWK_link recompute the whole record, `$0`, with the values of `OFS` and `ORS` variables

+ convert a table to LaTeX format like above, but additionally print the numbers in specific format:

	`script.awk`:

	```awk
#!/usr/bin/awk -E

	function isnum(x) {
		return(x == x + 0)
	}

	BEGIN {
		CONVFMT = "%.2g"
		OFS = " & "
		ORS = " \\\\\n"
	}

	{
		for (i = 1; i <= NF; i++)
			if (isnum($i))
				$i = $i + 0
			else
				$i = $i
		print
	}
	```

	```bash
	./script.awk tab.dat > tab.tex
	```

## \tr_anchor

+ change all spaces into newlines in a file:

	```bash
	tr -s '[:space:]' '\n' < inp
	```

+ remove all letters from a file:

	```bash
	tr -d '[:alpha:]' < inp
	```

+ extract all digits from a file into one big number:

	```bash
	tr -dc '[:digit:]' < inp
	```

+ add numbers of a one-column file:

	```bash
	echo $(tr "\n" "+" < file) 0 | bc
	```

## \cut_anchor

+ remove parts of a file after last dot (.) in each line:

	```bash
	rev < file | cut -d "." -f 1 --complement | rev
	```

+ print nth character of a string:

	```bash
	echo axy10eRf | cut -c 7
	```

+ note that \cut_link doesn't reorder fields, thus `cut -f 1,2` and `cut -f 2,1` are equivalent

## \sort_anchor and \uniq_anchor

+ sort a file and delete duplicate lines:

	```bash
	sort -u file.txt
	```

+ print duplicate lines in a file:

	+ irrespective of the case:

		```bash
		sort file.txt | uniq -d
		```

	+ ignoring the case:

		```bash
		sort file.txt | uniq -id
		```
