
# \PDF_chapter_anchor

\PDF_anchor

: you've used it already

## \getting_help

```bash
qpdf --help
man pdfnup
man pdfimages
man pdftotext
```

## joining and removing pages

+ remove the first page from a \PDF_link file:

	```bash
	pdftk input.pdf cat 2-end output output.pdf
	```

	or:

	```bash
	qpdf input.pdf --pages input.pdf 2-z -- output.pdf
	```

+ join two \PDF_link files:

	```bash
	qpdf input1.pdf --pages input1.pdf input2.pdf -- output.pdf
	```

+ join selected pages from two \PDF_link files:

	```bash
	qpdf input1.pdf --pages input1.pdf 1 input2.pdf 3,5-z -- out.pdf
	```

+ arrange slides so that there are two slides per row and three slides per column in a portrait mode, leaving a bit of space for margins (useful for handout printing):

	```bash
	pdfnup --nup 2x3 --no-landscape --scale 0.9 input.pdf --outfile output.pdf
	```

## rotating pages

+ create a \PDF_link file combining pages from `A.pdf` and `B.pdf` files:

	+ pages of `A.pdf`: from 2 to last then page 1

	+ pages of `B.pdf`: from 1 to last

	+ rotate all pages by 180 degrees

	```bash
	pdftk A=A.pdf B=B.pdf cat A2-endS A1S B1-endS output output.pdf
	```

+ rotate all pages by 180 degrees:

	```bash
	pdf-stapler cat input.pdf 1-endD output.pdf
	```

## cropping

+ crop and rotate, if needed, a \PDF_link file:

	```bash
	krop input.pdf
	```

## conversion between \PDF_link and other file formats

+ convert several images into a single \PDF_link file:

	```bash
	convert Image*.jpg out.pdf
	```

	or:

	```bash
	img2pdf --output out.pdf Image*.jpg
	```
+ display information about images contained in a \PDF_link file between second and fifth page:

	```bash
	pdfimages -f 2 -l 5 -list cat.pdf
	```

	now extract the images into \filename_link\plural{s} staring with `image`:

	```bash
	pdfimages -f 2 -l 5 -all -p cat.pdf image
	```

+ convert a text file into a \PDF_link file:

	```bash
	pandoc file.txt -f markdown+hard_line_breaks -t html5 -o file.pdf
	```

+ convert a \PDF_link file into a text file (e.g. for spell checking):

	```bash
	pdftotext file.pdf file.txt
	```

+ convert a \PDF_link file into a black-and-white format:

	```bash
	gs -sOutputFile=out.pdf -q -sDEVICE=pdfwrite -sColorConversionStrategy=Gray -dProcessColorModel=/DeviceGray -dCompatibilityLevel=1.4 -dNOPAUSE -dBATCH input.pdf
	```

## passwords

+ convert a password-protected \PDF_link file into passwordless one:
	+ if password known:

		```bash
		pdftk input.pdf input_pw password cat output output.pdf
		```

		or:

		```bash
		qpdf --decrypt --password=password input.pdf output.pdf
		```

	+ if password unknown:

		```bash
		gs -sOutputFile=output.pdf -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -c .setpdfwrite -f input.pdf
		```
