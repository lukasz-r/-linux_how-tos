
# \searching_for_files

+ note that unless specified otherwise, \file_lnk_pl are used in \Unix sense (can be any \file_type_lnk)

## \locate_anc

### \getting_help

```bash
man locate
man updatedb
man updatedb.conf
```

### \locate machinery

+ \locate_lnk reads one or more \locate_database_lnk_pl prepared by \updatedb_lnk and prints \filename_lnk_pl matching at least one of the patterns

+ \updatedb_anc is usually run periodically by \cron_lnk to update the \locate_database_anc located at \locate_database_path_anc, thus the \locate_lnk results might be inaccurate, e.g. a \file_lnk in a database might have already been deleted

+ the configuration file for \updatedb_lnk: \updatedb_conf_path_anc

### \excluding_dirs

+ to exclude a \directory_lnk from search results, add its \absolute_pathname_lnk to a list of \directory_lnk_pl in the `PRUNEPATHS` variable in the \updatedb_conf_path_lnk file, and update the \locate_database_lnk manually:

	```bash
	sudo updatedb
	```

### search examples

+ search for \file_lnk_pl containing `finance` in their name via a \case_insensitive_search_lnk:

	```bash
	locate -i finance
	```

+ search for __existing__ \file_lnk_pl containing `1zł`, `5zł`, etc. in their name via a \case_insensitive_search_lnk:

	```bash
	locate -ei "*[0-9]zł*"
	```

	note that in this case we need to explicitly add `*` \globbing_character_lnk_pl since the pattern already contains the `[0-9]` \globbing_character_lnk_pl

+ search for a \file_lnk named exactly `Sold.txt`:

	```bash
	locate -b "\Sold.txt"
	```

## \find_anc

### \getting_help

```bash
man find
info find
```

### \basic_concepts

\find_starting_point_anc

: a \directory_lnk where the \directory_lnk tree searched by \find_lnk is rooted

### sorting the search results

+ almost always it's a good idea to sort the \find_lnk results for clarity:

	```bash
	find -ctime -5 | sort
	```

	but we'll skip the \sort_lnk part in most examples that follow just out of laziness

### searching for \file_pl by name

command | pattern | match
--------|---------|------
`find -name name_pattern`{.bash} | \find_name_pattern_anc | \filename_lnk_pl matching \find_name_pattern_lnk \glob_lnk
`find -path path_pattern`{.bash} | \find_path_pattern_anc | \pathname_lnk_pl mathing \find_path_pattern_lnk \glob_lnk

: basic commands

### searching for \file_pl by \file_permission_pl

+ $P(m)$ --- set of \file_permission_lnk_pl summing up to an overall octal \file_permission_class_lnk \file_permission_lnk $m$:

	$m$ | $P(m)$
	----|-------
	$0$ | $\varnothing$
	$1$ | $\{$\file_execute_permission_lnk$\}$
	$2$ | $\{$\file_write_permission_lnk$\}$
	$3$ | $\{$\file_write_permission_lnk$,$ \file_execute_permission_lnk$\}$
	$4$ | $\{$\file_read_permission_lnk$\}$
	$5$ | $\{$\file_read_permission_lnk$,$ \file_execute_permission_lnk$\}$
	$6$ | $\{$\file_read_permission_lnk$,$ \file_write_permission_lnk$\}$
	$7$ | $\{$\file_read_permission_lnk$,$ \file_write_permission_lnk$,$ \file_execute_permission_lnk$\}$

+ basic \find_lnk \file_permission_lnk tests:

	\find_lnk command | $n_1 n_2 n_3$ \file_permission_lnk_pl of \file_lnk_pl matched by \find_lnk
	-------------------|---------------
	`find -perm m₁m₂m₃`{.bash} | $n_1 = m_1 \wedge n_2 = m_2 \wedge n_3 = m_3$
	`find \! -perm m₁m₂m₃`{.bash} | $n_1 \neq m_1 ∨ n_2 \neq m_2 ∨ n_3 \neq m_3$
	`find -perm -m₁m₂m₃`{.bash} | $\Big( P(m_1) \subseteq P(n_1) \Big) \wedge \Big( P(m_2) \subseteq P(n_2) \Big) \wedge \Big( P(m_3) \subseteq P(n_3) \Big)$
	`find \! -perm -m₁m₂m₃`{.bash} | $\Big( P(m_1) \nsubseteq P(n_1) \Big) \vee \Big( P(m_2) \nsubseteq P(n_2) \Big) \vee \Big( P(m_3) \nsubseteq P(n_3) \Big)$
	`find -perm /m₁m₂m₃`{.bash} | $\Big( P(m_1) \cap P(n_1) \Big) \cup \Big( P(m_2) \cap P(n_2) \Big) \cup \Big( P(m_3) \cap P(n_3) \Big) \neq \varnothing$
	`find \! -perm /m₁m₂m₃`{.bash} | $\Big( P(m_1) \cap P(n_1) \Big) \cup \Big( P(m_2) \cap P(n_2) \Big) \cup \Big( P(m_3) \cap P(n_3) \Big) = \varnothing$

+ note that

	```bash
	find -perm -000
	```

	matches __all__ \file_lnk_pl since $\varnothing \subseteq A$ for any set $A$, and

	```bash
	find -perm /000
	```

	should match __no__ \file_lnk_pl since $\varnothing \cap A = \varnothing$ for any set $A$, however, the implementation of \find_lnk makes `-perm /000` consistent with `-perm -000`, and hence both variants match __all__ \file_lnk_pl

command | matching \file_lnk_pl | comment                                         
--------|-------------------------------|-------------------------------------------------
`find -perm 664`{.bash} | with exactly $664$ \file_permission_lnk_pl |
`find -perm -664`{.bash} | with $664$ possibly plus other extra \file_permission_lnk_pl | e.g. a \file_lnk with $777$ \file_permission_lnk_pl is matched, but $770$ is not
`find -perm -004`{.bash} | readable by \file_others_lnk | any $n_1$, any $n_2$, $n_3$ such that $P(4) \subseteq P(n_3)$, thus $n_3 \in \{4, 5, 6, 7\}$, and $\displaystyle \bigcap_{i = 4}^7{P(i)} = \{$\file_read_permission_lnk$\}$ --- all the sets contain the \file_read_permission_lnk
`find -perm /004`{.bash} | readable by \file_others_lnk | any $n_1$, any $n_2$, $n_3$ such that $P(4) \cap P(n_3) \neq \varnothing$, thus $n_3 \in \{4, 5, 6, 7\}$
`find \! -perm -004`{.bash} | not readable by \file_others_lnk | any $n_1$, any $n_2$, $n_3$ such that $P(4) \nsubseteq P(n_3)$, thus $n_3 \in \{0, 1, 2, 3\}$ (conditions for $n_1$ and $n_2$ are never met, the match is governed by the condition for $n_3$ since the conditions are matched by the `OR` operator), and $\displaystyle \bigcup_{i = 0}^3{P(i)} = \{$\file_write_permission_lnk$,$ \file_execute_permission_lnk$\}$ --- none of the sets contains the \file_read_permission_lnk
`find \! -perm /004`{.bash} | not readable by \file_others_lnk | any $n_1$, any $n_2$, $n_3$ such that $P(4) \cap P(n_3) = \varnothing$, thus $n_3 \in \{0, 1, 2, 3\}$
`find -perm -600`{.bash} | readable __and__ writable by \file_owner_lnk | any $n_2$, any $n_3$, $n_1$ such that $P(6) \subseteq P(n_1)$, thus $n_1 \in \{6, 7\}$, and $\displaystyle \bigcap_{i = 6}^7{P(i)} = \{$\file_read_permission_lnk$,$ \file_write_permission_lnk$\}$ --- the sets contain the \file_read_permission_lnk __and__ \file_write_permission_lnk
`find -perm /600`{.bash} | readable __or__ writable by \file_owner_lnk | any $n_2$, any $n_3$, $n_1$ such that $P(6) \cap P(n_3) \neq \varnothing$, thus $n_3 \in \{2, 3, 4, 5, 6, 7\}$, and $\displaystyle \bigcap_{i = 2}^3{P(i)} = \{$\file_write_permission_lnk$\} \wedge \displaystyle \bigcap_{i = 4}^7{P(i)} = \{$\file_read_permission_lnk$\}$ --- the sets contain the \file_read_permission_lnk __or__ \file_write_permission_lnk
`find -perm -222`{.bash} | writable by \file_all_users_lnk
`find -perm /222`{.bash} | writable by \file_any_user_lnk

: \file_lnk_pl with $n_1 n_2 n_3$ permissions matched by specific \find_lnk commands

+ list \file_lnk_pl with special permissions, i.e. SUID, SGID or sticky bit set:

	```bash
	find -perm /7000
	```

+ list \file_lnk_pl which have SUID or SGID bit set:

	```bash
	find -perm /6000
	```

### searching for \file_pl by \file_timestamp_pl

+ list \file_lnk_pl:

	+ \file_atime_alt{accessed} at most $50~\mathrm{min}$ ago:

		```bash
		find -amin -50 | sort
		```

	+ \file_ctime_alt{changed} at most $5$ days ago the way `ls -dils`{.bash} would print them:

		```bash
		find -ctime -5 -ls
		```

+ list \file_lnk_pl with specific \file_MAC_time_lnk_pl:

	```bash
	date="9 Aug 2019"
	find -newermt "$date" \! -newermt "$date + 1 day"
	find -newerat "$date" \! -newerat "$date + 1 day"
	find -newerct "$date" \! -newerct "$date + 1 day"
	```

+ sort \file_lnk_pl from oldest to newest by \file_mtime_lnk:

	```bash
	find -printf "%T@ %p\n" | sort -n
	```

### relative \pathname_lnk_pl

+ print \pathname_lnk_pl relative to the \find_starting_point_lnk:

	```bash
	find ~/Desktop/ -type f -printf "%P\n" | sort
	```

	e.g. the `~/Desktop/Articles/Smith.pdf` \pathname_lnk is printed as `Articles/Smith.pdf`

### \excluding_dirs

command | actions performed on                           
--------|------------------------------------------------
`find ~/Desktop -maxdepth 0`{.bash} | the \find_starting_point_lnk itself (here: `~/Desktop`)
`find ~/Desktop -maxdepth 1`{.bash} | \file_lnk_pl inside the \find_starting_point_lnk __only__
`find ~/Desktop -mindepth 0`{.bash} ($\equiv$ `find ~/Desktop`{.bash}) | everything under the \find_starting_point_lnk
`find ~/Desktop -mindepth 1`{.bash} | everything but the \find_starting_point_lnk

: restricting depth of a \directory_lnk tree search

+ to skip certain \directory_lnk_pl, use the `-path pattern -prune` construct

	+ `-path pattern` matches a \pathname_lnk (which always contains a \find_starting_point_lnk) matching `pattern` \glob_lnk, thus `pattern` must span such a \pathname_lnk

	+ `pattern` can contain \globbing_character_lnk_pl, and `*` matches slashes too

	+ `pattern` ending in a slash matches nothing since \pathname_lnk has no trailing slash

	command | match                                               
	--------|-----------------------------------------------------
	`find dir . -path top_dir/foo`{.bash} | the `foo` \file_lnk in a \find_starting_point_lnk, if exists
	`find -path foo`{.bash} $\equiv$ `find . -path foo`{.bash} | nothing, since \pathname_lnk_pl in a current \directory_lnk start with `./`
	`find -path ./foo`{.bash} $\equiv$ `find . -path ./foo`{.bash} | the `foo` \file_lnk in a current \directory_lnk, if exists

	+ to match a \directory_lnk under the \find_starting_point_lnk, the `pattern` must contain a \find_starting_point_lnk followed by a slash, followed by the \directory_lnk name (e.g. `dir/omit` for `dir` as the \find_starting_point_lnk, `./omit` for the `.` as the \find_starting_point_lnk)

+ list all the \file_lnk_pl under the current \directory_lnk which have been \file_ctime_alt{changed} at most $10~\mathrm{min}$ ago, excluding the `omit` subdirectory:

	```bash
	find -path ./omit -prune -o -cmin -10 -print
	```

+ list all the \file_lnk_pl in the `/proc` \directory_lnk except for those in the \directory_lnk_pl directly under `/proc` whose names start with numbers:

	```bash
	find /proc -path "/proc/[0-9]*" -prune -o -print
	```

+ list all the \file_lnk_pl in the `src` \directory_lnk whose names begin with `a`, except for those under `src/.svn` \directory_lnk:

	```bash
	find src -path src/.svn -prune -o -iname "a*"
	```

	or:

	```bash
	find src -path src/.svn -prune -o -iname "a*" -print
	```

	+ note that by default, \find_lnk prints all the \file_lnk_pl matching the search criteria, however, with the `-print` option \find_lnk prints \file_lnk_pl only on explicit print instructions, so if `src/.svn` \directory_lnk exists:

		+ the first command above prints `src/.svn` \directory_lnk (for which `-prune` returns true, but makes \find_lnk never descend into that \directory_lnk)

		+ the second command above doesn't print `src/.svn` \directory_lnk since `-print` is associated with the right-hand side of the OR condition (`-o`), and hence nothing is printed from the left-hand side of the condition

+ list \hard_link_lnk_pl to a \file_lnk:

	+ including the very \file_lnk:

		```bash
		find ~/Desktop -samefile file.txt
		```

	+ excluding the very \file_lnk:

		```bash
		find ~/Desktop -path . -prune -o -samefile file.txt
		```

### restricting search to a current \directory_lnk

+ list \file_lnk_pl only in a current \directory_lnk:

	```bash
	find \! -name . -prune
	```

	or:

	```bash
	find -maxdepth 1 \! -name .
	```

	+ note that the above commands don't print `.` since it was excluded with `\! -name .`, the \directory_lnk_pl are not descended into owing to `-prune`

### \regex\plural{es} with \find

+ list all \file_lnk_pl but those with specific extensions via a \case_insensitive_search_lnk:

	```bash
	find \! -iregex ".*\.\(bmp\|jp.*g\|gif\|png\)$"
	```

	+ note that in \Bash_lnk scripts it's better to use the `!(pattern-list)` \extended_glob_lnk instead of \find_lnk, see <a href="#globs_and_regexes_extended_glob_example">__this example__</a>

+ find \directory_lnk_pl with

	+ leading \blank_character_lnk_pl in their name:

		```bash
		find -type d -regex "./\s.*"
		```

	+ trailing \blank_character_lnk_pl in their name:

		```bash
		find -type d -regex "./.*\s$"
		```

### dry runs

+ use `echo` to dry-run a dangerous operation, e.g. moving \file_lnk_pl:

	```bash
	find -iname "*.txt" -exec echo mv -iv '{}' dest \;
	```

### renaming multiple \directory_pl

+ we want to rename all \directory_lnk_pl named `old dir` into `new dir` recursively inside a current \directory_lnk

	+ we create an empty \directory_lnk inside which we create a simple \directory_lnk hierarchy:

		```bash
		$ cd $(mktemp -d) && mkdir -p "old dir" "subdir/old dir/old dir"
		$ find | sort
		.
		./old dir
		./subdir
		./subdir/old dir
		./subdir/old dir/old dir
		```

	+ the use of of the `-exec` action works only for a rename directly under a current \directory_lnk, which you can see by dry-running a rename command (__note that__ the \Unix_shell_lnk doesn't output the quotes, which is not an error):

		```bash
		$ find -type d -name "old dir" -exec echo mv -iv {} "new dir" \;
		mv -iv ./subdir/old dir new dir
		mv -iv ./subdir/old dir/old dir new dir
		mv -iv ./old dir new dir
		```
		__note that__ only the first rename command would work as expected

	+ the use of the `-execdir` action runs the command from the subdirectory containing the matched \file_lnk:

		```bash
		$ find -type d -name "old dir" -execdir echo mv -iv {} "new dir" \;
		mv -iv ./old dir new dir
		mv -iv ./old dir new dir
		mv -iv ./old dir new dir
		```

		which seems fine as the rename commands are run in the matching \directory_lnk_pl, so we no longer dry-run:

		```bash
		$ find -type d -name "old dir" -execdir mv -iv {} "new dir" \;
		'./old dir' -> 'new dir'
		find: ‘./subdir/old dir’: No such file or \directory_lnk
		'./old dir' -> 'new dir'
		find: ‘./old dir’: No such file or \directory_lnk
		$ find | sort
		.
		./new dir
		./subdir
		./subdir/new dir
		./subdir/new dir/old dir

		```

		the problem is that the `old dir` is renamed `new dir` and \find_lnk cannot descend further inside a renamed \directory_lnk

	+ a solution is to ___process each \directory_lnk's contents before the \directory_lnk itself___, which is precisely what the `-depth` option does:

		```bash
		$ cd $(mktemp -d) && mkdir -p "old dir" "subdir/old dir/old dir"
		$ find -depth -type d -name "old dir" -execdir mv -iv {} "new dir" \;
		'./old dir' -> 'new dir'
		'./old dir' -> 'new dir'
		'./old dir' -> 'new dir'
		$ find | sort
		.
		./new dir
		./subdir
		./subdir/new dir
		./subdir/new dir/new dir
		```
