#!/usr/bin/env python3

# a definitions file parser

# definitions in a definitions file can assume two syntaxes:

# (1) name	text_first	[text_later]
# (2) name	text	URL (starting with "http://" or "https://")

# "name" can't contain dashes ("-")
# fields must be tab-separated

# definitions to be used in the Markdown file upon parsing the definitions file:

## case (1):
### "\name": prints the "text_first" (or the "text_later", if present)
### "\name_anc" creates an anchor with the "text_first"
### "\name_lnk" creates a link with the "text_first" (or the "text_later", if present) to the anchor
### "\name_alt{alt_text}" creates a link with the "alt_text" to the anchor

## case (2):
### "\name": prints the "text"
### "\name_lnk" creates a link with the "text" to an URL
### "\name_alt{alt_text}" creates a link with the "alt_text" to an URL

## the "\name" non-linked definition is useful in chapter titles, the links to which in the table of contents would be broken if the linked definitions were used instead
## plural text forms are available via "\name_pl", "\name_anc_pl" and "\name_lnk_pl"
## use "\name_anc" or "\name_anc_pl" and never both to avoid creating multiple anchors with the same name

## we don't use "_anchor", "_link", "_plural" nor "_alternative_text" full suffixes, but "_anc", "_lnk", "_pl" and "_alt" abbreviated suffixes to reduce the probability of the names clash
## e.g. if we define "file" and "file_link" names, the full-suffix link to "file" is "file_link", clashing with the already defined "file_link" name, whereas the abbreviated-suffix link to "file" is "file_lnk", not coinciding with the "file_link" name

import fileinput
import re
import inflect

anchor_suffix = "_anc"
link_suffix = "_lnk"
plural_suffix = "_pl"
alt_text_suffix = "_alt"
p = inflect.engine()

# plural forms for texts not pluralized correctly by the "inflect" module
p.defadj("OS", "OSes")

def print_def(name, text):
    print("\define{" + name + "}{__" + text + "__}")
    print("\define{" + name + plural_suffix + "}{__" + p.plural(text) + "__}")

for line in fileinput.input():
    if re.match(r"^\w", line):
        line = line.rstrip("\n")
        fields = line.split("\t")
        fields_count = len(fields)
        name = fields[0]
        name_link = name + link_suffix
        name_alt_text = name + alt_text_suffix
        text_first = fields[1]
        text_later = text_first
        if fields_count > 2:
            if re.match(r"^https?:\/\/", fields[2]):
                URL = fields[2]
                print_def(name, text_first)
                print("\define{" + name_link + "}{[__" + text_first + "__](" + URL + ")}")
                print("\define{\\" + name_alt_text + "{alt_text}}{[__<wbr>\\alt_text<wbr>__](" + URL + ")}")
                continue
            else:
                text_later = fields[2]
        name_anchor = name + anchor_suffix
        print_def(name, text_later)
        print("\define{" + name_anchor + "}{__" + text_first + "__<a name=\"" + name + "\"></a>}")
        print("\define{" + name_anchor + plural_suffix + "}{__" + p.plural(text_first) + "__<a name=\"" + name + "\"></a>}")
        print("\define{" + name_link + "}{[__" + text_later +"__](#" + name + ")}")
        print("\define{" + name_link + plural_suffix + "}{[__" + p.plural(text_later) + "__](#" + name + ")}")
        print("\define{\\" + name_alt_text + "{alt_text}}{[__<wbr>\\alt_text<wbr>__](#" + name + ")}")
