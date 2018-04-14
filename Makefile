# Markdown files in the order they enter the documentation
md_files := vim.md ssh.md git.md pandoc.md

# target HTML file
target := index.html

md_main_file := How-Tos.md

all : $(target)

$(md_main_file) : $(md_files)
	cat $^ > $@

$(target) : $(md_main_file) pandoc.css Makefile
	pandoc $< -sS --toc -c pandoc.css \
		-f markdown+auto_identifiers+blank_before_header+backtick_code_blocks+fenced_code_attributes \
		--highlight-style=zenburn -mathjax \
		-o $@

.PHONY : clean

clean :
	rm -f $(md_main_file) $(target)
