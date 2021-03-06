
# \basic_concept_pl

## \file_pl

\file_anc

: in \Linux, everything is a \file_lnk

\pathname_anc

: a string used to identify a \file_lnk, containing zero or more slashes

\absolute_pathname_anc

: a \pathname_lnk beginning with one or more slashes

\filename_anc

: a \pathname_lnk component containing no slashes

+ each \filename_lnk is thus a \pathname_lnk

+ \pathname_lnk examples:

	+ `/home/luke/.bash_profile`

	+ `luke/.bash_profile`

	+ `./.bash_profile`

	+ `home`

	+ `.bash_profile`

+ \absolute_pathname_lnk examples:

	+ `/home/luke/.bash_profile`

	+ `/usr/bin/ls`

	+ `//usr/bin/ls`

+ \filename_lnk examples:

	+ `home`

	+ `luke`

	+ `.bash_profile`

## abstraction

\abstraction_anc

: a technique for arranging complexity of computer systems so that the user works with simpler concepts without going into unnecessary details of the hardware structure

+ the essence of \abstraction_lnk is preserving information that is relevant in a given context, and forgetting information that is irrelevant in that context

## common acronyms

\OS_anc

: a system software that manages it all

\CLI_anc

: (the thing we love the most!) a means of interacting with a software via text commands

\GUI_anc

: a means of interacting with a software via graphical tools

## keyboard and keys

sign | key        | comment                       
:---:|------------|-------------------------------
\key{\Alt_lnk} | \Alt_anc
\key{\AltGr_lnk} | \AltGr_anc | usually used to input characters not present in the keyboard (e.g. Polish characters)
\key{\Tab_lnk} | \Tab_anc
\key{\spacebar_lnk} | \spacebar_anc

## digital information units

+ $\mathrm{B} = \mathrm{byte}$

+ $\mathrm{b} = \mathrm{bit}$

+ $1~\mathrm{B} = 8~\mathrm{b}$

+ $1~\mathrm{kB} = 8~\mathrm{kb} = 10^3~\mathrm{B}$ (kilobyte)
+ $1~\mathrm{KiB} = 8~\mathrm{Kib} = 2^{10}~\mathrm{B} = 1024~\mathrm{B}$ (kibibyte)
