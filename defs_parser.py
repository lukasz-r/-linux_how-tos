#!/usr/bin/env python3

############################################################
# a definitions file parser
############################################################

############################################################
# definitions in a definitions file can assume two syntaxes:
############################################################

# (1) anchor_name	text_first	[text_later]
# (2) link_name	text	URL (starting with "http://" or "https://")

# neither "anchor_name" nor "link_name" can contain dashes ("-")
# fields must be tab-separated
############################################################

############################################################
# definitions to be used in the Markdown file
# upon parsing the definitions file:
############################################################

############################################################
## case (1):
############################################################

### "\anchor_name_txt":
### prints the "text_first" (or the "text_later", if present)

### "\anchor_name_txt_pl":
### as above, but prints a pluralized text

### "\anchor_name_anc":
### creates an anchor called "anchor_name" with the "text_first"

### "\anchor_name_anc_pl":
### as above, but prints a pluralized text

### "\anchor_name_anc_alt_txt{alt_text}":
### creates an anchor called "anchor_name" with the "alt_text"

### "\anchor_name_lnk":
### creates a link with the "text_first" (or the "text_later", if present) to the "anchor_name" anchor

### "\anchor_name_lnk_pl":
### as above, but prints a pluralized text

### "\anchor_name_lnk_alt_txt{alt_text}":
### creates a link with the "alt_text" to the "anchor_name" anchor

### use only one anchor kind:
### "\anchor_name_anc",
### "\anchor_name_anc_pl" or
### "\anchor_name_anc_alt_txt{alt_text}"
### to avoid creating multiple anchors with the same name

############################################################
## case (2):
############################################################

### "\link_name_txt":
### prints the "text"

### "\link_name_txt_pl":
### as above, but prints a pluralized text

### "\link_name_lnk":
### creates a link with the "text" to an URL

### "\link_name_lnk_pl":
### as above, but prints a pluralized text

### "\link_name_lnk_alt_txt{alt_text}":
### creates a link with the "alt_text" to an URL
############################################################

############################################################
## the "\anchor_name_txt(_pl)" and "\link_name_txt(_pl)"
## non-linked definitions are useful in chapter titles,
## the links to which in the table of contents would be broken
## if the linked definitions were used instead
############################################################

############################################################
## we don't use "_text", "_anchor", "_link",
## "_plural" nor "_alternative_text" full suffixes,
## but "_txt", "_anc", "_lnk", "_pl" and "_alt_txt" abbreviated suffixes
## to reduce the probability of the names clash
## e.g. if we define "file" and "file_link" names,
## the full-suffix link to "file" is "file_link",
## clashing with the already defined "file_link" name,
## whereas the abbreviated-suffix link to "file" is "file_lnk",
## not coinciding with the "file_link" name
############################################################

import fileinput
import re
import inflect

text_suffix = "_txt"
anchor_suffix = "_anc"
link_suffix = "_lnk"
plural_suffix = "_pl"
alt_text_suffix = "_alt" + text_suffix
alt_text_argument = "{alt_text}"
alt_text_formatted = "<wbr>\\alt_text<wbr>"

p = inflect.engine()

# plural forms for texts not pluralized correctly by the "inflect" module
p.defadj("OS", "OSes")

def print_text_defs(def_name, text):
    print("\define{" + def_name + text_suffix + "}{__" + text + "__}")
    print("\define{" + def_name + text_suffix + plural_suffix + "}{__" + p.plural(text) + "__}")

def print_anchor_def(def_name, anchor_name, text):
    print("\define{" + def_name + "}{__" + text + "__<a name=\"" + anchor_name + "\"></a>}")

def print_anchor_link_def(def_name, anchor_name, text):
    print("\define{" + def_name + "}{[__" + text + "__](#" + anchor_name + ")}")

def print_url_link_def(def_name, url, text):
    print("\define{" + def_name + "}{[__" + text + "__](" + url + ")}")

for line in fileinput.input():
    if re.match(r"^\w", line):
        line = line.rstrip("\n")
        fields = line.split("\t")
        fields_count = len(fields)
        anchor_name = fields[0]
        text_first = fields[1]
        text_later = text_first
        if fields_count > 2:
            if re.match(r"^https?:\/\/", fields[2]):
                link_name = fields[0]
                print_text_defs(link_name, text_first)
                url = fields[2]
                print_url_link_def(
                    link_name + link_suffix,
                    url,
                    text_first
                )
                print_url_link_def(
                    link_name + link_suffix + plural_suffix,
                    url,
                    p.plural(text_first)
                )
                print_url_link_def(
                    "\\" + link_name + link_suffix + alt_text_suffix + alt_text_argument,
                    url,
                    alt_text_formatted
                )
                continue
            else:
                text_later = fields[2]
        anchor_name = fields[0]
        print_text_defs(anchor_name, text_later)
        print_anchor_def(
            anchor_name + anchor_suffix,
            anchor_name,
            text_first
        )
        print_anchor_def(
            anchor_name + anchor_suffix + plural_suffix,
            anchor_name,
            p.plural(text_first)
        )
        print_anchor_def(
            "\\" + anchor_name + anchor_suffix + alt_text_suffix + alt_text_argument,
            anchor_name,
            alt_text_formatted
        )
        print_anchor_link_def(
            anchor_name + link_suffix,
            anchor_name,
            text_later
        )
        print_anchor_link_def(
            anchor_name + link_suffix + plural_suffix,
            anchor_name,
            p.plural(text_later)
        )
        print_anchor_link_def(
            "\\" + anchor_name + link_suffix + alt_text_suffix + alt_text_argument,
            anchor_name,
            alt_text_formatted
        )
