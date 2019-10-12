
# LaTeX: TeX Live configuration and compilation

# get the local TeX Live home directory (usually "~/texmf"):
kpsewhich -var-value=TEXMFHOME

# get the path where to place bibliography files:
kpsewhich -var-value=BIBINPUTS
# also look for "BIBINPUTS":
vi $(kpsewhich texmf.cnf)

# make LaTeX definitions visible to TeX Live: put your definitions in the above-obtained "TEXMFHOME" followed by root TeX Live directory structure, which you get through e.g.
kpsewhich braket.sty
# usually it's "~/texmf/tex/latex", then you can check if TeX Live sees a given file:
kpsewhich my_definitions.sty

# make LaTeX bibliography visible to TeX Live: put your definitions in the above-obtained "TEXMFHOME" followed by the "BIBINPUTS" directory structure, which altogether is usually "~/texmf/bibtex/bib"

# open the "longtable" package manual:
texdoc longtable

# list package manuals matching a string:
texdoc -s babel

# open the comprehensive LaTeX symbol list:
texdoc symbols-a4

# useful "Makefile" to compile a LaTeX document into PDF with the SyncTeX reverse search:
-------------------------------------------------------
Makefile
-------------------------------------------------------
name := manuscript
target := $(name).pdf

all : $(target)

pdf : $(target)

%.pdf : %.tex
	latexmk -pdflatex="pdflatex -synctex=1 -interaction=nonstopmode" -pdf $*

.PHONY : clean

clean :
	rm -f ./*{aux,bbl,bcf,blg,fdb*,fls*,log,Notes.bib,synctex.gz,toc,out,xml} $(target)
-------------------------------------------------------

# LaTeX: typesetting

+ input accented characters directly through Unicode UTF-8:
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}

+ prevent hyphenation when:

	+ no "babel" package is used:

		```latex
		\usepackage[none]{hyphenat}
		```
	+ "babel" package is used:

		```latex
		\hyphenpenalty = 10000
		```

+ don't print page numbers:
\pagenumbering{gobble}

+ print the value of a "example "counter:
\theexample

+ left- and right- aligned text in the same line:

	```latex
	left \hfill right
	```

+ insert references from another file:

	```bash
	(...)
	\usepackage{xr-hyper}
	\usepackage[colorlinks = true, linkcolor = blue, citecolor = blue, urlcolor = blue, bookmarks = true]{hyperref}
	\externaldocument[manuscript-]{main_file}
	(...)
	See Fig.~\ref{manuscript-fig_label_in_main_file} for details.
	(...)
	```

+ switch between languages (main language is given as the last option):

	```latex
	\documentclass{article}

	\usepackage[utf8]{inputenc}
	\usepackage[german, polish]{babel}

	\begin{document}

		\begin{otherlanguage}{german}
			Deutsch
		\end{otherlanguage}

			Polski

		\foreignlanguage{german}{Deutsch}

	\end{document}
	```

+ a letter in German with date in a German format, with hyphenation turned off and a font size of 20 pt:

	```latex
	\documentclass[20pt]{extletter}
	\usepackage[T1]{fontenc}
	\usepackage[utf8]{inputenc}
	\usepackage[german]{babel}
	\usepackage[useregional]{datetime2}

	\hyphenpenalty = 10000

	\address{
		Helga Müller \\
		Düsseldorf
	}
	\date{Essen, den~\DTMdisplaydate{2017}{08}{05}{-1}}
	\signature{Lük Anonymus}

	\begin{document}

	\begin{letter}{}

	\opening{Sehr geehrte Frau Müller,}

	Halo, etc.

	\closing{MfG,}

	\end{letter}

	\end{document}
	```

+ a letter in French using French acronyms, with customized date format to show month and year:

	```latex
	\documentclass[12pt]{letter}
	\usepackage[T1]{fontenc}
	\usepackage[utf8]{inputenc}
	\usepackage[margin = 2.5cm]{geometry}
	\usepackage[polish, french]{babel}
	\usepackage[useregional]{datetime2}
	\usepackage[hidelinks]{hyperref}

	\newcommand{\monthyearfr}[2]{\DTMfrenchmonthname{#1}~#2}
	\newcommand{\myemail}{me@@me.pl}
	\newcommand{\jc}{\textbf{Jan Cabacki}}

	\address{
		Jan Kowalski \\
		ul. Piękna 169 \\
		00-001 Miasteczko \\
		\textsc{Pologne} \\
		tél. \texttt{+48000000000} \\
		e-mail \href{mailto:\myemail}{\texttt{\myemail}}
	}

	\date{Miasteczko, le~\DTMdisplaydate{2019}{09}{30}{-1}}
	\signature{Jan Kowalski}

	\begin{document}

	\begin{letter}{
		Centre des archives du personnel militaire \\
		Caserne Bernadotte \\
		Place de Verdun \\
		64023 Pau cedex \\
		\textsc{France}
	}

	\opening{Madame, Monsieur,}

	Je suis historien local sur le point d'étudier l'histoire des soldats qui prenaient part à la Deuxième Guerre mondiale, à l'occasion du 75\ieme{} anniversaire de la fin de la Guerre.

	En rapport avec mes recherches, je voudrais vous prier de m'envoyer une copie du dossier personnel de~\jc, un soldat des forces armées polonaises, né le~\DTMdisplaydate{1916}{3}{8}{-1}.

	Je couvrirai tous les frais de la recherche d'archives.

	D'après mes informations, {\jc} est arrivé en France après l'invasion de la Pologne en 1939. En~\monthyearfr{6}{1940}, après la bataille de France, il a été évacué, y compris d'autres soldats alliés, au Royaume-Uni. Là-bas il s'est enrôlé à la 1\iere{} division blindée polonaise sous les ordres de G\up{al}~Stanisław~Maczek, avec laquelle il a pris part au débarquement de Normandie en~\monthyearfr{6}{1944}. Il a été tué au combat le~\DTMdisplaydate{1944}{8}{19}{-1} à Soignolles.

	Je vous remercie d'avance pour votre aide. Veuillez recevoir mes salutations distinguées.

	\closing{Dans l'attente de votre réponse,}

	\end{letter}

	\end{document}
	```

# avoid "Command `\lll` already defined" error with "babel" and "amssymb" packages:
\let\lll\undefined
\usepackage{amssymb}
# or load the "amssymb" before the "babel" package

# set all margins:
\usepackage[margin = 2cm]{geometry}

+ change table column and row separation and restrict the change to a single table only:

	```latex
	\begingroup
		\addtolength{\tabcolsep}{6pt}
		\renewcommand{\arraystretch}{1.5}
		\begin{table}[h!]
			\centering
			\caption{Derivatives}
			\begin{tabular}{l*{2}{>{$}c<{$}}}
				\toprule
				function & f(x) & f'(x) \\
				\midrule
				linear & a x + b & a \\
				sine & \sin{x} & \cos{x} \\
				\bottomrule
			\end{tabular}
			\label{tab:derivatives}
		\end{table}
	\endgroup
	```

--------------------------------------------------------------------------------
# bibliography with Biblatex
--------------------------------------------------------------------------------
## add compressed-numerical style bibliography with Biblatex and reference a bibliography section:
-------------------------------------------------------
(...)
\usepackage{nameref}
\usepackage[citestyle = numeric-comp, maxnames = 10, sorting = none]{biblatex}
\addbibresource{bibliography.bib}
(...)
See the~\nameref{biblio} section.
(...)
\printbibliography[title = Publications\label{biblio}]
(...)
-------------------------------------------------------

## don't print "note" nor "doi" fields for all references and "title" field for specific references with Biblatex:
-------------------------------------------------------
(...)
\usepackage[maxnames = 4]{biblatex}
\addbibresource{bibliography.bib}
\AtEveryCitekey{\clearfield{note}}
\AtEveryCitekey{\clearfield{doi}}
% full cite without a title
\newcommand{\fullcnt}[1]{\AtNextCitekey{\clearfield{title}}\fullcite{#1}}
(...)
The title of the thesis was~\citetitle{my_thesis}. The article is~\fullcnt{my_article}.
(...)
-------------------------------------------------------
--------------------------------------------------------------------------------

# useful packages:
## booktabs (rules in tables)
## chemfig (molecules, reaction schemes)
## datetime2 (times and dates)
## extsizes (global font size setting)
## mhchem (chemical reactions)
## siunitx (SI units, tables with numbers)
## subcaption (subfigures, subtables)
## tcolorbox (frames)

================================================================================
LaTeX: presentations (Beamer)
================================================================================
--------------------------------------------------------------------------------
# in Beamer, overlays are controlled by the value of "beamerpauses" counter (you can check its value by "\thebeamerpauses" command):
--------------------------------------------------------------------------------
## each "+" in overlay specification (e.g. "<+-+(2)>") is replaced by the value of the "beamerpauses" counter, which is 1 at the beginning of the frame, and after setting a given text, "beamerpauses" is increased by 1, so all "+" signs in an overlay specification are replaced with the same number

## use the following to avoid clashes with "onslide" and "uncover":
-------------------------------------------------------
(...)
\begin{frame}
	beamerpauses = 1
	\begin{overprint}
		\onslide<+-+(2)> % = <1-3>
			beamerpauses = 2
			\uncover<+->{ % = <2->
				beamerpauses = 3
			}
			\uncover<+->{ % = <3->`
				beamerpauses = 4
				text
			}
		\onslide<+> % = <4>
				beamerpauses = 5
	\end{overprint}
\begin{frame}
-------------------------------------------------------

## each "." in overlay specification (e.g. "<.(1)-.(4)>") is replaced by the value of "beamerpauses" counter minus one, and "beamerpauses" is not changed

## "\begin{frame}[<+->]" means that the "<+->" overlay specification is applied to all commands accepting overlay specifications that are not followed by their own overlay specifications

## use "onlyenv" environment with "itemize" environment if you want to further use commands with "+" overlay specifications as the "beamerpauses" counter is reset to its original value after "\only" (note that "5" is used with "onlyenv" since there are four items plus one block title influenced by "<+->" specification):
-------------------------------------------------------
(...)
\begin{frame}[<+->]
	\begin{onlyenv}<.(1)-.(5)>
		\begin{block}{Fruits}
			\begin{itemize}
				\item Orange.
				\item Apple.
				\item Strawberry.
				\item Banana.
			\end{itemize}
		\end{block}
	\end{onlyenv}
	\only<+>{
		\begin{center}
			\Large Fruits \\
			\includegraphics[width = \textwidth]{Fruits}
		\end{center}
	}
-------------------------------------------------------
--------------------------------------------------------------------------------

# insert a figure into another figure:
-------------------------------------------------------
(...)
\usepackage{textpos}
(...)
\begin{frame}
	\frametitle{Example: interaction energies for the \ce{H2O} dimer}
	\begin{center}
		\includegraphics[scale = 0.8]{Graphs/Water_dimer/en_int_water_dimer}
	\end{center}
	\begin{textblock}{4}(10, 4)
		\includegraphics[scale = 0.08]{Figures/H2O_dimer}
	\end{textblock}
\end{frame}
(...)
-------------------------------------------------------

## posters

+ a poster with multiline title, with figures side by side with captions without labels:

	```latex
	\documentclass{tikzposter}

	\usetheme{Simple}
	\usepackage[utf8]{inputenc}
	\usepackage[T1]{fontenc}
	\usepackage{subcaption}
	\AtBeginEnvironment{tikzfigure}{\captionsetup{type = figure}}
	\captionsetup[subfigure]{labelformat = empty}

	\colorlet{backgroundcolor}{white}
	\colorlet{framecolor}{blue}

	\newcommand{\pheight}{8cm}

	\title{\parbox{\linewidth}{\centering Line 1 \\ Line 2}}

	\begin{document}
		\maketitle
		\begin{columns}
			\column{0.5}
			\block{Some nice title}{
				\centering
				\begin{tikzfigure}
					\subcaptionbox{Left figure}{\includegraphics[height = \pheight]{img1}}
					\subcaptionbox{Right figure}{\includegraphics[height = \pheight]{img2}}
				\end{tikzfigure}
			}
			\column{0.5}
			\block{Another nice title}{
				Some text.
			}
		\end{columns}
	\end{document}
	```
