#!/usr/bin/env python3

# a definitions file parser

# definitions in a definitions file can have two syntaxes:

# (1) term	text_first	[text_later]
# (2) term	text	URL (starting with "http://" or "https://")

# "term" can't contain dashes ("-")
# fields must be tab-separated

# definitions to be used in the Markdown file upon parsing the definitions file:

## case (1):
### "\term": prints the "text_first" (or the "text_later", if present)
### "\term_anchor" creates an anchor with the "text_first"
### "\term_link" creates a link, with the "text_first" (or the "text_later", if present), to the anchor

## case (2):
### "\term": prints the "text"
### "\term_link" creates a link, with the "text", to an URL

## the "\term" non-linked definition is useful in chapter titles, the links to which in the table of contents would be broken if the linked definitions were used instead
## plural forms are available via "\term_plural" and "\term_link_plural"

import fileinput
import re
import inflect

p = inflect.engine()
plural_suffix = "_plural"

def print_def(term, text):
    print("\define{" + term + "}{__" + text + "__}")
    print("\define{" + term + plural_suffix + "}{__" + p.plural(text) + "__}")

for line in fileinput.input():
    if re.match(r"^\w", line):
        line = line.rstrip("\n")
        fields = line.split("\t")
        fields_count = len(fields)
        term = fields[0]
        term_link = term + "_link"
        text_first = fields[1]
        text_later = text_first
        if fields_count > 2:
            if re.match(r"^https?:\/\/", fields[2]):
                URL = fields[2]
                print_def(term, text_first)
                print("\define{" + term_link + "}{[__" + text_first + "__](" + URL + ")}")
                continue
            else:
                text_later = fields[2]
        term_anchor = term + "_anchor"
        print_def(term, text_later)
        print("\define{" + term_anchor + "}{__" + text_first + "__<a name=\"" + term + "\"></a>}")
        print("\define{" + term_link + "}{[__" + text_later +"__](#" + term + ")}")
        print("\define{" + term_link + plural_suffix + "}{[__" + p.plural(text_later) + "__](#" + term + ")}")
