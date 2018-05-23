
# archives

\define{gzip}{__gzip__}
## \gzip

+ unpack a \gzip archive:

	```bash
	gunzip -k archive.gz
	```

\define{zip}{__zip__}
## \zip

+ create the \zip archive from the files in `~/docs` without saving the pathname structure:

	```bash
	zip -j pics ~/docs/*
	```

+ create a __cbz__ comic book archive:

	```bash
	zip -j comic_book.cbz comic_book/*
	```

+ list \zip archive contents:

	```bash
	unzip -l archive.zip
	```

	or:

	```bash
	vim archive.zip
	```

+ extract a \zip archive into the `dest` directory:

	```bash
	unzip archive.zip -d dest
	```

\define{rar}{__rar__}
## \rar

+ create a \rar archive:

	```bash
	rar a archive.rar dir file1 file2
	```

+ create a __cbr__ comic book archive:

	```bash
	rar a -ep comic_book.cbr comic_book/*
	```

+ list \rar archive contents:

	```bash
	unrar l archive.rar
	```

+ extract a \rar archive into the `dest` directory:

	```bash
	unrar e archive.rar dest
	```

\define{tar}{__tar__}
## \tar

### \getting_help

```bash
man tar
info tar
```

### compression and extraction

+ \tar archives (`*.tar` files) are collections of files

+ create a \tar archive of the current directory:

	```bash
	tar cvf archive.tar *
	```

+ \tar archives can be compressed

\define{tar_tarball}{__tarball__}
\define{tar_tarball_linked}{[\tar_tarball](#tar_tarball)}

\tar_tarball<a name="tar_tarball"></a>

: a compressed \tar archive

+ compress a tar archive

	+ with __gzip__:

		```bash
		gzip archive.tar
		```

		resulting \tar_tarball_linked: `archive.tar.gz`

	+ with __bzip2__:

		```bash
		bzip2 archive.tar
		```

		resulting \tar_tarball_linked: `archive.tar.bz2`

	+ with __xz__:

		```bash
		xz archive.tar
		```

		resulting \tar_tarball_linked: `archive.tar.xz`

+ uncompress a \tar_tarball_linked back into a \tar archive:

	```bash
	gunzip archive.tar.gz
	bunzip2 archive.tar.bz2
	unxz archive.tar.xz
	```

+ create a \tar_tarball_linked directly from the `dir` directory:

	+ with __gzip__:

		```bash
		tar cvzf archive.tar.gz dir
		```

	+ with __bzip2__:

		```bash
		tar cvjf archive.tar.bz2 dir
		```

	+ with __xz__:

		```bash
		tar cvJf archive.tar.xz dir
		```

	+ automatically choose the compression program based on a \tar_tarball_linked extension:

		```bash
		tar cvaf archive.tar.gz aaa
		```

+ short \tar_tarball_linked extensions: `*.tgz`, `*.tbz`, `*.txz`

+ extract a \tar_tarball_linked to the "dest" directory:

	```bash
	tar xvzf archive.tar.gz -C dest
	tar xvjf archive.tar.bz2 -C dest
	```

	or simply use automatic compression program detection:

	```bash
	tar xvaf archive.tar.bz2 -C dest
	```

+ list the contents of a \tar archive or a \tar_tarball_linked:

	```bash
	tar tvf archive.tar
	tar tvf archive.tar.gz
	```

+ list files matching a specific pattern in a \tar_tarball_linked:

	```bash
	tar tvf archive.tar.gz --wildcards "*CONFIG*"
	```

+ extract specific files from a \tar_tarball_linked:

	```bash
	tar xvzf archive.tar.gz src/main.F90
	```

	`src/main.F90` is inputted as returned by an archive listing with the `t` option

+ append files and directories to a gzipped \tar_tarball_linked:

	```bash
	gunzip archive.tar.gz
	tar rvf archive.tar new_file.txt new_dir
	gzip archive.tar
	```

+ create a gzipped \tar_tarball_linked of everything under the `/mnt/usb/docs` directory without saving full pathnames:

	```bash
	tar cvzf archive.tar.gz -C /mnt/usb/docs .
	```

	+ `-C /mnt/usb/docs` changes current directory to `/mnt/usb/docs`

	+ `.` adds the entire current directory

+ create a zipped \tar_tarball_linked of the `docs` directory under `/mnt/usb` without saving full pathnames:

	```bash
	tar cvzf archive.tar.gz -C /mnt/usb docs
	```

	+ the archived pathnames start with `docs/`

+ extract a \tar_tarball_linked removing 2 leading components in each pathname:

	```bash
	tar xvzf archive.tar.gz --strip-components=2
	```

\define{dar}{__dar__}
## \dar

### \getting_help

```bash
man dar
```

### compression and extraction

+ \dar archives are meant for backup

+ create a gzipped, bzipped or xzipped \dar archive from specific directories, cutting the archive into slices of a given maximum size:

	```bash
	dar -c archive -z -v -s 500M -g dir1 -g dir2
	dar -c archive -zbzip2 -v -s 500M -g dir1 -g dir2
	dar -c archive -zxz:6 -v -s 500M -g dir1 -g dir2
	```

	+ `-g` directories without `-R` option are relative to the current path, otherwise `-R` must be used:

		```bash
		dar -c archive -z -v -s 500M -R ~/ -g Documents -g Pictures
		```

+ list the contents of a \dar archive:

	```bash
	dar -l archive
	```

+ extract a \dar archive to the `dest` directory:

	```bash
	dar -x archive -v -R dest
	```

### backup

+ backup directory to a remote host over \SSH in at most 10M slices:

	```bash
	dar -c - -R Manuals/ -z -v | ssh erwin "dar_xform -s 10M - backup/Manuals"
	```
