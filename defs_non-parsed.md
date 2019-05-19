# a non-parsed definitions file

# a slash separator
\define{slash_sep}{__/__}

# useful section titles
\define{getting_help}{__getting help__}
\define{see}{__additional info__}
\define{basic_concepts}{__basic concepts__}
\define{basic_operations}{__basic operations__}

# operating systems
\define{Unix}{__Unix__}
\define{Linux}{__Linux__}
\define{Windows}{__Windows__}
\define{Mac_OS}{classic __Mac OS__}
\define{macOS}{__macOS__}

# add suffix to a name (usually "s" or "es" to make plural forms)
\define{\plural{x}}{<wbr>__<wbr>\x<wbr>__}

# display a text as if it were printed on a keyboard key
\define{\key{x}}{<kbd>\x</kbd>}

# a link to an example defined with '<a name="anchor_name">':
\define{\example_link{anchor_name}}{<a href="#\anchor_name">__this example__</a>}

# definitions that will be moved to the respective definitions files
\define{EOL}{__end of line__}
\define{modulefile}{__modulefile__}
\define{\concat{x}{y}}{\x\y}
