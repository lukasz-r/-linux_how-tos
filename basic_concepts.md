
# \basic_concepts_anchor

## files

\file_anchor

: in \Linux, everything is a \file_link

\pathname_anchor

: a string used to identify a file, containing zero or more slashes

\absolute_pathname_anchor

: a \pathname_link beginning with one or more slashes

\filename_anchor

: a \pathname_link component containing no slashes

+ each \filename_link is thus a \pathname_link

+ \pathname_link examples:

	+ `/home/luke/.bash_profile`

	+ `luke/.bash_profile`

	+ `./.bash_profile`

	+ `home`

	+ `.bash_profile`

+ \filename_link examples:

	+ `home`

	+ `luke`

	+ `.bash_profile`

## characters

\CLI_anchor

: too obvious to define

\blank_character_anchor

: a space or a tab

\whitespace_anchor

: one or more characters that represent horizontal or vertical space, e.g. a \blank_character_link, a vertical tab, a \newline

+ note that the above definitions of \blank_character_link and \whitespace_link are consistent with `man isalpha`, and \Vim_link's `:h [:blank:]` and `:h [:space:]` manuals, but not with \Vim_link's `:h \s` manual, according to which `\s` matches a \whitespace_link, whereas it in fact matches a \blank_character_link: we'll stick to the above definitions throughout the text

\empty_line_anchor

: a line with no characters at all

\blank_line_anchor

: an \empty_line_link or a line with only \blank_character_link\plural{s}

\Alt_anchor

: a left \key{Alt} key

\AltGr_anchor

: a right \key{Alt} key, usually used to input characters not present in the keyboard (e.g. Polish characters)

## abstraction

\abstraction_anchor

: a technique for arranging complexity of computer systems so that the user works with simpler concepts without going into unnecessary details of the hardware structure

+ the essence of \abstraction_link is preserving information that is relevant in a given context, and forgetting information that is irrelevant in that context

## digital information units

+ $\mathrm{B} = \mathrm{byte}$

+ $\mathrm{b} = \mathrm{bit}$

+ $1~\mathrm{B} = 8~\mathrm{b}$

+ $1~\mathrm{kB} = 8~\mathrm{kb} = 10^3~\mathrm{B}$ (kilobyte)
+ $1~\mathrm{KiB} = 8~\mathrm{Kib} = 2^{10}~\mathrm{B} = 1024~\mathrm{B}$ (kibibyte)
