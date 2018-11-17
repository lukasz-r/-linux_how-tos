
\define{Pandoc}{__Pandoc__}
# \Pandoc

+ list highlight languages:

	```bash
	pandoc --list-highlight-languages
	```

+ list styles

	```bash
	pandoc --list-highlight-styles
	```

+ a text paragraph or a code block within a bullet list must be preceded with a blank line and intended one tab on top of the list item indentation

+ insert the `@@` character in a code block: `@@@@`

+ insert a non-breaking space:

	+ outside the code block --- use escaped space, e.g. `one\ two`

	+ inside the code block --- input the space with \key{\AltGr_link}+\key{Space}, e.g. to keep the trailing \whitespace_link: `list `
