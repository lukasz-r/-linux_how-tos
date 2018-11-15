# the "some_chapter" chapter main file is "some_chapter.md", additional files are placed in the "some_chapter" directory

# chapter titles in the order they enter the documentation
chapters := \
	basic_concepts \
	Octave \
	gnuplot \
	LaTeX \
	globs_and_regexes \
	Bash \
	time_and_date \
	archives \
	file_encryption \
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
	text_file_operations \
	Vim \
	SSH \
	Git \
	youtube-dl \
	Pandoc

# CSS style sheet file
css_file := style.css

# Markdown definitions file, definitions parser, definition files, and file to collect all definitions
defs_md := non-parsed_defs.md
defs_parser := parse_defs
defs_files := $(wildcard *.defs)
defs_collect := defs_all.md

# chapters Markdown files
md_files := $(chapters:=.md)

# Markdown file collecting all chapters
md_main_file := How-Tos.md

# target HTML file
target := index.html

all : $(target)

$(defs_collect) : $(defs_md) $(defs_parser) $(defs_files) Makefile
	awk '!/^#/' $< > $@
	cat $(defs_files) | ./$(defs_parser) >> $@

$(md_main_file) : $(defs_collect) $(md_files)
	cat $^ | gpp -T > $@

$(target) : $(md_main_file) $(css_file)
	pandoc -sSp --toc --toc-depth=4 -c $(css_file) \
		-f markdown+auto_identifiers+blank_before_header+backtick_code_blocks+fenced_code_attributes+fancy_lists+example_lists+abbreviations+tex_math_dollars \
		--highlight-style=espresso --mathjax \
		-o $@ $<

view : $(target)
	xdg-open $(target)

.PHONY : clean

clean :
	rm -f $(defs_collect) $(md_main_file) $(target)
