
# \mc_anchor

## \getting_help

```bash
man mc
```

## basic operations

+ start \mc_link with the `~/Desktop` directory in a left panel and a current directory in a right panel:

	```bash
	mc ~/Desktop
	```

## useful shortcuts

shortcut | action
---------|-------
\key{Ctrl}+\key{O} | get a shell in a current directory, or switch back into \mc_link from a shell
\key{Ctrl}+\key{R} | reload the directory contents
\key{Alt}+\key{Enter} | copy the currently selected \filename_link to the command line

: shortcuts in \mc_link

## default programs

+ set the default program, e.g. `mplayer`, to open video files: edit the `/usr/libexec/mc/ext.d/video.sh` file
