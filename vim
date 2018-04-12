================================================================================
vi / vim
================================================================================
# get help about a command:
:h p

# get help about a shortcut:
:h CTRL-f

# save a file (write the whole buffer to the current file):
:w

# reload a file:
:e

# exit all edited files without saving changes:
:qa!

--------------------------------------------------------------------------------
# most useful vim modes:
--------------------------------------------------------------------------------
## normal (command) mode − a default mode after vim starts:
### <ESC>: usually enters the mode
### "/word": search forward for "word"
### "n": repeat the latest search forward
### "N": repeat the latest search backward

## insert mode − a typed text is inserted into the buffer:
### "a": insert the text after the cursor
### "i": insert the text before the cursor

## replace mode − just like an insert mode, but typing replaces existing characters:
### "R": start replacing characters

## visual mode − a mode for navigation and manipulation of text selections:
### "v": select characters continuously
### "V": select lines
### <CTRL>+"v": select blocks

## command-line mode − a mode for entering editor commands at the bottom of the window:
### ":h :q": get help on the ":q" command
-------------------------------------------------------------------------------

# move forward 5 words:
5w
# move backward 5 words:
5b
# move forward a sentence:
)
# move backward a sentence:
(
# move forward a paragraph:
}
# move backward a paragraph:
{
# move forward a page:
<CTRL>+"f"
# move backward a page:
<CTRL>+"b"

# move forward to the "c" character ("f" means "find"):
fc
# move backward to the "c" character:
Fc
# repeat the forward move:
;
# repeat the backward move:
,

# move to the first character of the line:
0

# move to the first non-blank character of the line:
^

# jump to the corresponding item, e.g. a matching bracket:
%

# go the beginning of a file:
gg

# go to the end of a file:
G

--------------------------------------------------------------------------------
# clipboards and registers
--------------------------------------------------------------------------------
## in Linux there two independent clipboards:
### primary clipboard (copy-on-select, pasted with middle mouse button)
### system clipboard (copy with <CTRL>+"c", paste with <CTRL>+"v")

## "y", "d", "p" vim commands by default use an unnamed register
## primary clipboard is the "*" register in vimx (hint: star is select)
## system clipboard is the "+" register in vimx (hint: <CTRL>+"c")
## vimx in Fedora is from vim-X11 package

## copy a word under the cursor:
yiw

## paste the text after the cursor:
p

## display the contents of all numbered and named registers:
:reg

## paste the text from register "x" after the cursor:
"xp

## copy selected lines to a system clipboard: select lines with "V" (visual mode) and:
"+y

## copy one line to a system clipboard: go to the line and:
V"+y

## paste primary clipboard contents to vimx:
"*p

## paste system clipboard contents to vimx:
"+p
--------------------------------------------------------------------------------

# select all text in a file:
ggVG

# delete everything from a given line to the end of a file:
dG

# delete everything from a given line to the beginning of a file:
dgg

# delete a word under the cursor ("iw" means "inner word"):
diw

# delete from the cursor to the end of a word:
dw

# delete a word under the cursor and type the "new" word:
ciwnew

# turn off the highlighted search results:
:nohls

# search for multiple patterns, e.g. double spaces, whitespace characters at the end of a line, and double line breaks:
/  \|\s$\|\n\n\n
# "\|" separates patterns
# turn the avove search into a custom command in "~/.vimrc":
com SearchMess /  \|\s$\|\n\n\n
# such a command might be then invoked with:
:SearchMess

# make multiple substitutions:
:%s/one/two/g | :%s/three/four/g
# "|" separates commands

# replace whitespace in the selected lines with tabs:
# select lines with "V" (visual mode) and:
:s/\s\+/\t/g
# (":s/\s\+/\t/g" replaces one or more whitespace characters in a row, i.e. continouos whitespace, with a tab, whereas ":s/\s/\t/g" replaces each whitespace character with a tab, so there might be multipe tabs between words after replacement)

# replace selected characters with ".":
# select characters (e.g. with "v") and:
:r.

# make a selection uppercase/lowercase:
# select some text and:
U
# (uppercase), or:
u
# (lowercase)

# delete lines containing a specific pattern:
:g/some_pattern/d
# delete lines NOT containing a specific pattern:
:g!/some_pattern/d
# or:
:v/some_pattern/d
# remove "/d" in the above commands to show the lines that will be deleted

# display the value of a string, e.g. "mp":
:set mp

# run a shell command line, e.g. "make":
:!make
# note that typing ":make" (with no "!") calls a command stored in "makeprg" = "mp" string whose actual value depends on the edited file type, e.g. for "*.tex" file it can be "latex -interaction=nonstopmode -file-line-error-style $*"

# execute a currently edited file:
:! %

# insert an external file contents into the current buffer:
:r file.txt

# insert an output of a command into the current buffer:
:r !free -h 

# sort selected lines case-insensitively:
:sort i

# reverse all lines in a file:
:g/^/m0
# "^" matches the start of a line and thus all lines in a buffer, "m0" moves each matched line to the beginning of a buffer
# or select everything with "ggVG" and:
:!tac

# reverse selected lines in a file:
# select lines with "V" (visual mode) and:
:!tac

# check the file encoding in vi:
:set fenc

# reopen the file with a given encoding (eg., latin2) in vi:
:e ++enc=latin2

# insert the same character (say "-") 120 times:
120i-<ESC>

# insert regular quotes ("...") in a "*.tex" file:
\"
# with "\" smart quotes aren't inserted, you just need to erase "\"

# remove whitespace in the beginning of the selected lines:
# select lines with "V" (visual mode) and:
:s/^\s\+
# ("\s" selects whitespace)

# indent selected lines:
# select lines with "V" (visual mode) and:
>

# comment selected lines, say with "# ":
# select lines with "V" (visual mode) and:
:s/^/# /
# or select characters to be commented with <CTRL>+"v" and:
I#<space><ESC>

# insert same contents (e.g. spaces) starting in a given column:
# select the starting column with <CTRL>+"v" and:
I<some contents><ESC>

# print a document:
:ha

# print a document with Polish characters:
:set printencoding=cp1250
:ha

--------------------------------------------------------------------------------
# working with multiple files
--------------------------------------------------------------------------------
## buffer − an area of memory used to hold text read from a file or a newly created text

## open multiple files:
vi -o ./*.txt # split horizontally
vi -O ./*.txt # split vertically
vi -p ./*.txt # using tabs

## split a current window horizontally:
:sp

## split a current window vertically:
:vsp

## create a new file in a split window:
:sp new_file

## list all buffers:
:ls

## go to a next buffer:
:bn

## go to a previous buffer:
:bp

## go to a next tab:
gt

## go to a previous tab:
gT
--------------------------------------------------------------------------------

# view really big (e.g. gigabyte) files − use more or less instead of vi:
more file.txt
less file.txt
