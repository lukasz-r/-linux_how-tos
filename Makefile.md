
\define{Makefile}{__Makefile__}
# \Makefile

\define{Makefile_pattern_rule}{__pattern rule__}
\define{Makefile_pattern_rule_linked}{[\Makefile_pattern_rule](#Makefile_pattern_rule)}

\define{Makefile_static_pattern_rule}{__static pattern rule__}
\define{Makefile_static_pattern_rule_linked}{[\Makefile_static_pattern_rule](#Makefile_static_pattern_rule)}

\define{Makefile_implicit_rule}{__implicit rule__}
\define{Makefile_implicit_rule_linked}{[\Makefile_implicit_rule](#Makefile_implicit_rule)}

\define{Makefile_rec_exp_vars}{__recursively expanded variables__}
\define{Makefile_rec_exp_vars_linked}{[\Makefile_rec_exp_vars](#Makefile_rec_exp_vars)}

\define{Makefile_sim_exp_vars}{__simply expanded variables__}
\define{Makefile_sim_exp_vars_linked}{[\Makefile_sim_exp_vars](#Makefile_sim_exp_vars)}

\define{Makefile_auto_vars}{__automatic variables__}
\define{Makefile_auto_vars_linked}{[\Makefile_auto_vars](#Makefile_auto_vars)}

\define{Makefile_impl_vars}{__implicit variables__}
\define{Makefile_impl_vars_linked}{[\Makefile_impl_vars](#Makefile_impl_vars)}

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

+ a recipe is run if a target doesn't exist or is older than any of the prerequisites or if any prerequisite needs to be remade as a target in its own rule

\Makefile_pattern_rule<a name="Makefile_pattern_rule"></a>

: a rule with the `%` character in the target

\Makefile_static_pattern_rule<a name="Makefile_static_pattern_rule"></a>

: a \Makefile_pattern_rule_linked with multiple targets and prerequisite names derived from target names

\Makefile_implicit_rule<a name="Makefile_implicit_rule"></a>

: a pre-defined or a user-defined non-static \Makefile_pattern_rule_linked

+ \Makefile_implicit_rule_linked\plural usually make use of \Makefile_impl_vars_linked, e.g.

	```makefile
	%.o : %.c
		$(CC) $(CPPFLAGS) $(CFLAGS) -c $<
	```

## variables

+ two types (flavours) of user-defined variables:

	+ \Makefile_rec_exp_vars<a name="Makefile_rec_exp_vars"></a> --- defined with `=` and expanded only when a variable is referenced:

		```makefile
		FLAGS = $(include_dirs) -O
		```

	+ \Makefile_sim_exp_vars<a name="Makefile_sim_exp_vars"></a> --- defined with `:=` and expanded already at the definition:

		```makefile
		foo := $(x) bar
		```

+ \Makefile_auto_vars<a name="Makefile_auto_vars"></a> are computed for each rule based on its target and prerequisites, e.g.:

	variable | meaning
	---------|---------------------------------
	`$@@`    | a filename of a target of a rule
	`$<`     | a name of the first prerequisite
	`$^`     | names of all prerequisites separated with spaces
	`$*`     | a stem matching the same string as "%" in a pattern rule

+ \Makefile_impl_vars<a name="Makefile_impl_vars"></a> are predefined variables used in \Makefile_implicit_rule_linked\plural, e.g. (default values given in the last column):

	variable                  | meaning                     | default value
	--------------------------|-----------------------------|--------------
	`CC`                      | C compiler                  | `cc`
	`CXX`                     | C++ compiler                | `g++`
	`CPP`                     | C preprocessor              | `cc -E`
	`F77`, `FFLAGS`, `FLIBS`  | legacy Fortran 77 variables |
	`FC`, `FCFLAGS`, `FCLIBS` | current Fortran variables   |
	`PC`                      | Pascal compiler             | `pc`

## grouping targets and prerequisites

+ avoid repeating a recipe common for several rules for which prerequisites don't follow the same pattern (e.g. the number of prerequisites is different for different rules):

	```makefile
	targets := service.x group.x

	all : $(targets)

	service.x : service.c procinfo.c
	group.x : group.c

	$(targets) :
		$(CC) $(CFLAGS) -o $@@ $^

	.PHONY : clean

	clean :
		rm -f ./*.x
	```

+ avoid repeating a recipe common for several rules for which prerequisites follow the same pattern: use \Makefile_pattern_rule_linked\plural to define your own \Makefile_implicit_rule_linked\plural, e.g. create `*.tex` files from corresponding `*.awk` and `*.dat` files:

	```makefile
	targets := $(patsubst %.dat,%.tex,$(wildcard *.dat))

	all : $(targets)

	%.tex : %.awk %.dat
		./$< $*.dat > $@@

	.PHONY : clean

	clean :
		rm -f ./*{.aux,log,tex}
	```

	note that we have to first list `*.dat` files and substitute `*.dat` with `*.tex` to obtain a list of targets since there might not be any `*.tex` files (`make clean` removes them)

+ use \Makefile_static_pattern_rule_linked\plural to override \Makefile_implicit_rule_linked\plural for some files, e.g. for `big.dat` and `little.dat` which are made with `special_big.awk` and `special_little.awk` rather than with `big.awk` and `little.awk` files:

	```makefile
	%.dat : %.awk %.txt
		./$< $*.txt > $@@

	big.dat little.dat : %.dat : special_%.awk %.txt
		./$< $*.txt > $@@
	```

+ use target-specific variables with \Makefile_pattern_rule_linked\plural if a recipe depends on a target name:

	```makefile
	dat_files := $(wildcard *.dat)
	eps_files := $(data_files:.dat=.eps)

	all : $(eps_files)

	age.eps : plots_info := "age range"
	mst.eps : plots_info := "marital status"

	%.eps : plots.plt %.dat
		gnuplot -c $< $* $(plots_info)
	```

+ to make sure certain files are remade if `Makefile` has changed, put `Makefile` as a prerequisite to a rule:

	```makefile
	data_files := $(wildcard *.txt)
	eps_files := $(data_files:.txt=.eps)
	pdf_files := $(data_files:.txt=.pdf)

	all : $(eps_files)

	pdf : $(pdf_files)

	%.eps : %.txt plots.plt Makefile
		gnuplot -c plots.plt $< $@@ $(shell awk '/^X/ {print NR}' $<)

	%.pdf : %.eps
		epstopdf $<
	```

	note that using

	```makefile
	all : $(eps_files) Makefile
	```

	instead of placing `Makefile` in the `%.eps` rule won't work since `all` is a first and thus a default rule, not a filename, and there is no rule with `Makefile` as a target, whereas `%.eps` rule actually creates files which are checked against the `Makefile` prerequisite

+ use output of a shell command in a recipe:

	```makefile
	%.eps : %.txt plots.plt
		gnuplot -c plots.plt $< $@@ $(shell awk '/^X/ {print NR}' $<)
	```
