
# \gnuplot_anchor

+ plot a section through a graph $z = f(x, y)$ for $y = y_0$ with points only:

	```octave
	(...)
	y0 = 1.0
	plot "file_xyz.dat" u 1:($2 == y0 ? $3 : 1 / 0) notitle w p ls 1
	```

+ plot `file.dat` using only rows beginning with the `print-me` string, with points only:

	```octave
	(...)
	plot "file.dat" u (stringcolumn(1) eq "print-me" ? $3 : 1 / 0):xticlabel(2) notitle w p ls 1
	```

+ define a complex string function:

	```octave
	lambda_info(lambda1, lambda2) = \
		(rlambda = lambda1 / lambda2, rlambda == 1 ? \
			info = " = " : \
			info = sprintf(" = %.2f", rlambda), \
		"{/Symbol-Oblique l}_2".info."{/Symbol-Oblique l}_1")
	```

+ join data points with smooth lines, scale the $x$ axis to label it with smaller numbers, iterate through file columns, and use macros to avoid repetition:

	+ `data.dat`:

		```
		10000 3.09984 0.0133141 1.01911 0.0530381 0.0155319
		20000 12.3519 0.0410307 4.11062 0.0550196 0.0327131
		40000 51.7149 0.126686 17.4544 0.0590475 0.0584791
		80000 230.961 0.527484 78.6465 0.0965059 0.164902
		160000 941.585 2.01676 293.456 0.0913962 0.233645
		```

	+ `plot.plt`:

		```octave
		#!/usr/bin/gnuplot

		set term pdf enhanced

		cstyle = "lw 1.5 pt 7 ps 0.6"
		set style line 2 lc rgb "red" @@cstyle
		set style line 3 lc rgb "blue" @@cstyle
		set style line 4 lc rgb "green" @@cstyle
		set style line 5 lc rgb "magenta" @@cstyle
		set style line 6 lc rgb "orange" @@cstyle

		unit_power_x = 4
		unit_x = 10**unit_power_x
		set xlabel "{/:Italic n}_0/10^{" . unit_power_x . "}"
		set ylabel "{/:Italic t}/s"
		set logscale y
		set key top left spacing 0.8 font ", 10"
		titles = "'bubble sort' 'insertion sort' 'selection sort' 'counting sort' 'radix sort'"
		ncols = words(titles)
		col_first = 2
		col_last = col_first + ncols - 1

		set output "plot.pdf"
		iter = "for [icol = col_first:col_last]"
		plot \
			@@iter "data.dat" u ($1 / unit_x):icol w p ls icol notitle, \
			@@iter "data.dat" u ($1 / unit_x):icol smooth csplines w l ls icol notitle, \
			@@iter 1 / 0 w lp ls icol t word(titles, icol - 1)
		```

	+ note that `for` must be used for each `plot-element` as iteration is a part of a `plot-element`

+ scale plot sizes generated with `multiplot layout` (default size for eps is $5 \times 3.5~\mathrm{in}$):

	```octave
	(...)
	width_def = 5 # in
	height_def = 3.5 # in
	scale = 1.2
	set terminal postscript eps enhanced colour size scale * width_def, scale * height_def fontscale 1.2
	(...)
	set output "wiek_termometry.eps"
	set multiplot title "plots" layout 3, 2
	(...)
	```

+ change font size of axis tics:

	```octave
	set tics font ", 10"
	```

+ make a statistical summary of the data file (minimum, maximum values, etc.):

	```octave
	stats "data.txt" u 1:2 name "STATS_data"
	```

	you can then use `STATS_data_max_x` etc.

+ generate $x$ axis tick labels from $x$ column contents:

	```octave
	plot "data.dat" u 0:2:3:xtic(1) w boxerrorbars
	```

	+ `0` (or `column(0)`) is a sequential order of each point within a data set and needs to be given when the $x$ coordinate is required as in the case of `boxerrorbars`

	+ `xtic(1)` uses column 1 contents as $x$ axis tick labels

+ pass arguments to a \gnuplot_link script:

	```bash
	gnuplot -c plots.plt 1.2 file
	```

	in `plots.plt`, `1.2` and `file` are referred to as `ARG1` and `ARG2`, respectively:

	```octave
	(...)
	ratio = ARG1
	out_file = ARG2
	(...)
	```

## conditional plotting

+ note on the conditional plotting:

	```octave
	plot "data.txt" u 1:($4 < 0 ? 1 / 0 : ($2 + $3) / 2) w lp
	```

	+ rows evaluating to `1 / 0` (an undefined and hence not plottable value) are not connected with lines, so such rows cause breaks in a graph if they are surrounded by the rows evaluating to defined values

	+ so to plot `file.dat` using only rows with the same first and second value with points only (not the lines) you can safely use:

		```octave
		(...)
		inp_file = "data.txt"
		plot inp_file u 1:($1 == $2 ? $8 : 1 / 0) w p ls 1
		```

	+ however, the command:

		```octave
		plot inp_file u 1:($1 == $2 ? $8 : 1 / 0) w lp ls 1
		```

		won't connect all the points with lines as it skips rows evaluating to `1 / 0`

	+ to connect all the points with lines, use external command, e.g. awk, to pre-process the data file:

		```octave
		plot "<awk '{if ($1 == $2) print $1, $8}' " . inp_file w lp ls 1
		```

	+ to facilitate multiple usage of the external command, use a macro:

		```octave
		data = "\"<awk '{if ($1 == $2) print $1, $8}' \" . inp_file"
		stats @@data nooutput
		plot @@data w lp ls 1
		```

## histograms

+ place values on top of bars in a histogram:

	+ `data.dat`:

		```bash
		# x	y1	y2	y3	y4	y5
		a	3	5	2	6	7
		b	4	3	8	2	3
		```

	+ `plots.plt`:

		```octave
		#!/usr/bin/gnuplot

		inp_file = "data.dat"
		out_file = "data.eps"

		set terminal postscript eps enhanced colour fontscale 1.5
		set output out_file
		set style data histograms
		set style histogram cluster
		set style fill solid 1.0 border lt -1
		set yrange [0:10]
		col_first = 2
		col_last = 5
		nboxes = col_last - col_first + 1
		gap_size = 2
		box_width = 1.0 / (gap_size + nboxes)
		xcenter(x0, icol) = x0 - ((nboxes + 1.0) / 2.0 - icol) * box_width
		plot \
			for [col = col_first:col_last] \
				inp_file u col:xtic(1) notitle, \
			for [col = col_first:col_last] \
				inp_file u (xcenter($0, col - 1)):col:(sprintf("%.1f", column(col))) notitle \
				w labels center rotate by 45 font ", 10" offset 1, 0.8
		```

	+ `style data histograms` sets plotting style to histograms [as if `plot (...) with histograms` were used]

	+ `set style histogram cluster` sets the look style of a histogram

	+ label coordinates are given as `x:y:label`:

		+ the $x$ coordinate is computed with `xcenter` function returning the center of a box

		+ `$0` is the $x$ coordinate of a center of a cluster group in a histogram, equal to the consecutive row number in a data file

		+ the clusters [each with $n$ boxes (bars)] are centred at integer $x$ values, starting with $x = 1$

		+ gap size is given in box (bar) width units

		+ the $x$ distance between two cluster groups is euqal to $1$, and

			$1 = \left( \frac{n}{2} + g_s + \frac{n}{2} \right) b_w \implies
				b_w = \frac{1}{g_s + n}$

			$g_s$ --- gap size

			$b_w$ --- box width

		+ the $y$ coordinate is taken from a respective column

		+ the label is the $y$ coordinate printed with the `%.1f` format

	+ note that for functions to operate on column values, the full `column(col)` syntax must be used (a simple `col` is just a column number)
