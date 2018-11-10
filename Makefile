# the "some_chapter" chapter main file is "some_chapter.md", additional files are placed in the "some_chapter" directory

# chapter titles in the order they enter the documentation
chapters := \
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

# CSS style sheet file:
CSS_file := style.css

# Markdown files for all chapters
md_files := defs.md $(chapters:=.md)

# target HTML file
target := index.html

# Markdown file collecting all chapters
md_main_file := How-Tos.md

all : $(target)

$(md_main_file) : $(md_files) Makefile
	cat $(md_files) | gpp -T > $@

$(target) : $(md_main_file) $(CSS_file)
	pandoc -sSp --toc --toc-depth=4 -c $(CSS_file) \
		-f markdown+auto_identifiers+blank_before_header+backtick_code_blocks+fenced_code_attributes+fancy_lists+example_lists+abbreviations+tex_math_dollars \
		--highlight-style=espresso --mathjax \
		-o $@ $<

view : $(target)
	xdg-open $(target)

.PHONY : clean

clean :
	rm -f $(md_main_file) $(target)
