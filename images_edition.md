
# images edition

## basic concepts

\define{imed_DPI_linked}{[DPI](#imed_DPI)}
__DPI (dots per inch)__<a name="imed_DPI"></a>

: the number of individual dots per an inch-length line

\define{imed_PPI_linked}{[PPI](#imed_PPI)}
__PPI (pixels per inch)__<a name="imed_PPI"></a>

: the number of pixels per an inch-length line

\define{imed_SPI_linked}{[SPI](#imed_SPI)}
__SPI (samples per inch)__<a name="imed_SPI"></a>

: the number of individual samples per an inch-length line

+ \imed_DPI_linked usually refers to computer printers

+ \imed_PPI_linked usually refers to electronic image devices, e.g. monitor screens

+ \imed_SPI_linked usually refers to image scanners

+ sometimes \imed_PPI_linked and \imed_SPI_linked are mistakenly referred to as \imed_DPI_linked in the context of monitor screens and image scanners

+ \imed_PPI_linked ($p$) of a monitor screen:

	$p = \frac{\sqrt{w^2 + h^2}}{d}$

	$d$ --- diagonal screen size in inches

	$w$ --- width screen resolution in pixels

	$h$ --- height screen resolution in pixels

+ \imed_PPI_linked of a digital image or \imed_SPI_linked of a scanned image is purely a number stored within it and has no bearing on the actual image pixel size, becoming meaningful only when an absolute size of the printout, rendering on screen, or a scanned paper is known:

	+ a $72 \times 72$ pixels image printed on an inch square: $p = 72$

	+ a $72 \times 72$ pixels image printed on a 1/4-inch square: $p = 72 \cdot 4 = 288$

	+ an A4 ($8.27 \times 11.69$\ in) page scanned with \imed_SPI_linked $s = 600$ resolution: resulting digital image resolution, $r = (8.27 \cdot 600) \times (11.69 \cdot 600)$\ pixels\ $= 4962 \times 7014$\ pixels

## resolution of display and images

+ get a display resolution:
```bash
xrandr
```
	or:
```bash
xdpyinfo | grep -i dimen
```

+ get resolution and some other information on an image:
```bash
identify image.png
```

## joining images

+ join two images together top to bottom:
```bash
convert f1.jpg f2.jpg -append f.jpg
```

+ join two images together left to right:
```bash
convert f1.jpg f2.jpg +append f.jpg
```

+ join two jpegs together through ppm file:

	```bash
	djpeg f1.jpg > f1.ppm
	djpeg f2.jpg > f2.ppm
	pnmcat -leftright f1.ppm f2.ppm > f.ppm
	cjpeg f.ppm > f.jpg
	```

## creating and adding elements to images

+ create a black image of a given size:
```bash
convert -size 800x600 xc:black -fill black image.jpg
```
+ add a blue 100-pixel-high row to the bottom of an image:
```bash
convert image.jpg -gravity South -background blue -splice 0x100 out.jpg
```

+ add background-colour-coloured 100-pixel-wide columns to both sides of an image:
```bash
convert image.jpg -splice 100x0 -gravity East -splice 100x0 out.jpg
```

## animated GIFs

+ create animated GIF from `*.jpg` pictures:
```bash
convert -delay 100 -loop 0 *.jpg out.gif
```

+ extract images from an animated GIF:
```bash
convert -coalesce in.gif out.png
```

+ open an animated GIF:
```bash
animate in.gif
```
