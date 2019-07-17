
# \basic_concept_pl

## \file_pl

\file_anc
: in \Linux, everything is a \file_lnk

\pathname_anc
: a string used to identify a file, containing zero or more slashes

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

+ \filename_lnk examples:

	+ `home`

	+ `luke`

	+ `.bash_profile`

## abstraction

\abstraction_anc
: a technique for arranging complexity of computer systems so that the user works with simpler concepts without going into unnecessary details of the hardware structure

+ the essence of \abstraction_lnk is preserving information that is relevant in a given context, and forgetting information that is irrelevant in that context

## common acronyms

\CLI_anc
: the thing we love!

## keyboard and keys

sign | key        | comment                       
-----|------------|-------------------------------
\key{Alt} | \Alt_anc
\key{AltGr} | \AltGr_anc | usually used to input characters not present in the keyboard (e.g. Polish characters)
\key{Tab} | \Tab_anc

## digital information units

+ $\mathrm{B} = \mathrm{byte}$

+ $\mathrm{b} = \mathrm{bit}$

+ $1~\mathrm{B} = 8~\mathrm{b}$

+ $1~\mathrm{kB} = 8~\mathrm{kb} = 10^3~\mathrm{B}$ (kilobyte)
+ $1~\mathrm{KiB} = 8~\mathrm{Kib} = 2^{10}~\mathrm{B} = 1024~\mathrm{B}$ (kibibyte)
