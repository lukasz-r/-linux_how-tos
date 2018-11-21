
# \clipboard_anchor

## \getting_help

```bash
man xsel
man xclip
```

## clipboards in \Linux

\clipboard_primary_anchor

: copy on select: keeps a currently selected __text__

: paste with a middle mouse button

\clipboard_system_anchor

: copy explicitly with \key{Ctrl}+\key{C}

: paste with \key{Ctrl}+\key{V}

: handles __multiple data formats__, not only __text__

\clipboard_secondary_anchor

: used very rarely, we won't need it at any point

+ the clipboards are independent

## clipboard tools

+ copy the contents of the `file` file into:

	+ a \clipboard_primary_link:

		```bash
		cat file | xsel
		```

		or:

		```bash
		xclip file
		```

	+ a \clipboard_system_link:

		```bash
		cat file | xsel -b
		```

		or:

		```bash
		xclip -selection clipboard file
		```

+ print the contents of:

	+ a \clipboard_primary_link:

		```bash
		xsel
		```

		or:

		```bash
		xclip -o
		```

	+ a \clipboard_system_link:

		```bash
		xsel -b
		```

		or:

		```bash
		xclip -selection clipboard -o
		```
