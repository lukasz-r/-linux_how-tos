
\define{Makefile}{__Makefile__}
# \Makefile

## getting help

```bash
info make
```

## rules

+ a general form of a rule:

	```makefile
	target : prerequisites
		recipe
	```

+ a recipe is run if a target doesn't exist or is older than any of the prerequisites

\define{Makefile_pattern_rule_linked}{[__pattern rule__](#Makefile_pattern_rule)}
__pattern rule__<a name="Makefile_pattern_rule"></a>

: a rule with the `%` character in the target

\define{Makefile_static_pattern_rule_linked}{[__static pattern rule__](#Makefile_static_pattern_rule)}
__static pattern rule__<a name="Makefile_static_pattern_rule"></a>

: a \Makefile_pattern_rule_linked with multiple targets and prerequisite names derived from target names

\define{Makefile__implicit_rule_linked}{[__implicit rule__](#Makefile_implicit_rule)}
__implicit rule__<a name="Makefile_implicit_rule"></a>

: a pre-defined or a user-defined non-static \Makefile_pattern_rule_linked

+ \Makefile__implicit_rule_linked\plural usually make use of pre-defined variables, e.g.

	```makefile
	%.o : %.c
		$(CC) $(CPPFLAGS) $(CFLAGS) -c $<
	```

	+ `F77`, `FFLAGS`, `FLIBS`: legacy Fortran 77 variables
	+ `FC`, `FCFLAGS`, `FCLIBS`: current Fortran variables

## variables

+ two types (flavours) of variables:

	+ recursively expanded variables --- defined with `=` and expanded only when a variable is referenced:

		```makefile
		FLAGS = $(include_dirs) -O
		```

	+ simply expanded variables --- defined with `:=` and expanded already at the definition:

		```makefile
		foo := $(x) bar
		```

+ useful automatic variables:

	  |
------|---------------------------------
`$@@` | a filename of a target of a rule
`$<`  | a name of the first prerequisite
`$^`  | names of all prerequisites separated with spaces
`$*`  | a stem matching the same string as "%" in a pattern rule

## grouping targets and prerequisites

+ avoid repeating a recipe common for several rules for which prerequisites don't follow the same pattern (e.g. the number of prerequisites is different for different rules):

	```makefile
	targets := service.x group.x

	all : $(targets)

	service.x : service.c procinfo.c
	group.x : group.c

	$(targets) :
		$(CC) $(CFLAGS) -o $@ $^

	.PHONY : clean

	clean :
		rm -f ./*.x
	```

# avoid repeating a recipe common for several rules for which prerequisites follow the same pattern: use pattern rules to define your own implicit rules, e.g. create "*.tex" files from corresponding "*.awk" and "*.dat" files:
-------------------------------------------------------
Makefile
-------------------------------------------------------
targets := $(patsubst %.dat,%.tex,$(wildcard *.dat))

all : $(targets)

%.tex : %.awk %.dat
	./$< $*.dat > $@

.PHONY : clean

clean :
	rm -f ./*{.aux,log,tex}
-------------------------------------------------------
# note that in the above example we have to first list "*.dat" files and substitute "*.dat" with "*.tex" to obtain a list of targets since there might not be any "*.tex" files ("make clean" removes them)

# use static pattern rules to override implicit rules for some files, e.g. for "big.dat" and "little.dat" which are made with "special_big.awk" and "special_little.awk" rather than with "big.awk" and "little.awk" files:
%.dat : %.awk %.txt
	./$< $*.txt > $@

big.dat little.dat : %.dat : special_%.awk %.txt
	./$< $*.txt > $@

# use target-specific variables with pattern rules if a recipe depends on a target name:
-------------------------------------------------------
Makefile
-------------------------------------------------------
dat_files := $(wildcard *.dat)
eps_files := $(data_files:.dat=.eps)

all : $(eps_files)

age.eps : plots_info := "age range"
mst.eps : plots_info := "marital status"

%.eps : plots.plt %.dat
	gnuplot -c $< $* $(plots_info)
-------------------------------------------------------

# use output of a shell command in a recipe:
%.eps : %.txt plots.plt
	gnuplot -c plots.plt $< $@ $(shell awk '/^X/ {print NR}' $<)

# to make sure certain files are remade if "Makefile" has changed, put "Makefile" as a prerequisite to a rule:
-------------------------------------------------------
Makefile
-------------------------------------------------------
data_files := $(wildcard *.txt)
eps_files := $(data_files:.txt=.eps)
pdf_files := $(data_files:.txt=.pdf)

all : $(eps_files)

pdf : $(pdf_files)

%.eps : %.txt plots.plt Makefile
	gnuplot -c plots.plt $< $@ $(shell awk '/^X/ {print NR}' $<)

%.pdf : %.eps
	epstopdf $<
-------------------------------------------------------
# note that using
all : $(eps_files) Makefile
# instead of placing "Makefile" in a "%.eps" rule won't work since "all" is a first and thus a default rule, not a filename, and there is no rule with "Makefile" as a target, whereas "%.eps" rule actually creates files which are checked against a "Makefile" prerequisite

