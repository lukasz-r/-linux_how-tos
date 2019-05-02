# the "chapter_title" chapter:
## "chapter_title.md": a Markdown chapter file
## "chapter_title.defs": a chapter definitions file
## "chapter_title/*": additional chapter files, if needed

# chapters
chapters := \
	basic_concepts \
	clipboard \
	backup \
	Octave \
	gnuplot \
	Open_Babel \
	LaTeX \
	globs_and_regexes \
	text_operations \
	Bash \
	time_and_date \
	archives \
	searching_for_files \
	encryption \
	compilers_and_libraries \
	mc \
	Makefile \
	SELinux \
	package_management \
	job_scheduling \
	raw_image_development \
	image_metadata \
	images_edition \
	Wget \
	web_server \
	PDF \
	printing \
	Vim \
	SSH \
	Git \
	youtube-dl \
	Pandoc

# Markdown chapter files
md_chapters := $(chapters:=.md)

# a Markdown file collecting all chapters
md_collect := How-Tos.md

# a non-parsed definitions file, definitions file parser, and per-chapter definitions files
defs_non-parsed := defs_non-parsed.md
defs_parser := defs_parser
defs_files := $(wildcard *.defs)

# a file collecting all definitions
defs_collect := defs_all.md

# additional chapter files
chapter_files := $(foreach chapter, $(chapters), $(wildcard $(chapter)/*))

# a CSS style sheet file
css_file := style.css

# a target HTML file
html_file := index.html

all : $(html_file)

$(defs_collect) : $(defs_non-parsed) $(defs_parser) $(defs_files) Makefile
	awk '!/^#/' $< > $@
	cat $(defs_files) | ./$(defs_parser) >> $@

$(md_collect) : $(defs_collect) $(md_chapters)
	cat $^ | gpp -T > $@

$(html_file) : $(md_collect) $(chapter_files) $(css_file)
	pandoc -sSp --toc --toc-depth=4 -c $(css_file) \
		-f markdown+auto_identifiers+blank_before_header+backtick_code_blocks+fenced_code_attributes+fancy_lists+example_lists+abbreviations+tex_math_dollars \
		--highlight-style=espresso --mathjax \
		-o $@ $<

view : $(html_file)
	xdg-open $(html_file)

.PHONY : clean

clean :
	rm -f $(defs_collect) $(md_collect) $(html_file)
