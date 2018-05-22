
# archives

\define{tar}{__tar__}
## \tar

# compress a tar archive:
gzip archive.tar

# uncompress a tar archive:
gunzip archive.tar.gz

# unpack a gzip archive:
gunzip -k archive.gz

# create a tar zip or bz2 archive from "dir":
tar cvzf archive.tar.gz dir
tar cvjf archive.tar.bz2 dir

# extract a tar archive to "dest":
tar xvzf archive.tar.gz -C dest
tar xvjf archive.tar.bz2 -C dest

# list all files in a tar archive:
tar tvf archive.tar.gz

# list files matching a specific pattern in a tar archive:
tar tvf archive.tar.gz --wildcards "*CONFIG*"

# extract specific files from a tar archive:
tar xvzf archive.tar.gz src/main.F90
# "src/main.F90" is inputted as returned by an archive listing with the "t" option

# append files and directories to an existing tar zip archive:
gunzip archive.tar.gz
tar rvf archive.tar new_file.txt new_dir
gzip archive.tar

# create a tar zip archive of everything under the "/mnt/usb/docs" directory without saving full pathnames:
tar cvzf archive.tar.gz -C /mnt/usb/docs .
# "-C /mnt/usb/docs" changes current directory to "/mnt/usb/docs" and "." adds the entire current directory

# create a tar zip archive of the "docs" directory under "/mnt/usb" without saving full pathnames:
tar cvzf archive.tar.gz -C /mnt/usb docs
# the archived pathnames start with "docs/"

# extract a tar archive removing 2 leading components in each pathname:
tar xvzf archive.tar.gz --strip-components=2

# create a dar zip or bz2 archive from specific directories, cutting the archive into slices of a given maximum size:
dar -c archive -z -v -s 500M -g dir1 -g dir2
dar -c archive -zbzip2 -v -s 500M -g dir1 -g dir2
# "-g" directories without "-R" option are relative to the current path, otherwise "-R" must be used:
dar -c archive -z -v -s 500M -R ~/ -g Documents -g Pictures

# extract a dar archive to "dest":
dar -x archive -v -R dest

# list all files in a dar archive:
dar -l archive

# backup directory to a remote host over SSH in at most 10M slices:
dar -c - -R Manuals/ -z -v | ssh erwin "dar_xform -s 10M - backup/Manuals"

# create the "pics.zip" archive from the files in "~/docs" without saving the pathname structure:
zip -j pics ~/docs/*

# list files in a zip archive:
unzip -l archive.zip
# or:
vim archive.zip

# extract a zip archive to "dest":
unzip archive.zip -d dest
