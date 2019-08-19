
# \filesystem

## \file_type_pl in \Linux

\file_type_lnk | \file_type_character_anc
---------------|:-----------------------:
\regular_file_anc | `-`{.bash}
\directory_anc | `d`{.bash}
\symbolic_link_anc | `l`{.bash}
\FIFO_anc | `p`{.bash}
\socket_anc | `s`{.bash}
\character_special_file_anc | `c`{.bash}
\block_special_file_anc | `b`{.bash}

: \file_type_anc_pl in \Linux

\special_file_anc

: a \character_special_file_lnk or a \block_special_file_lnk

+ a \file_type_character_lnk is printed directly before a \file_mode_string_lnk in the output of `ls`{.bash} or `stat`{.bash} commands

## \file_pl, \directory_pl, \inode_pl and \file_link_pl

+ a \file_lnk is stored in at least three parts of a \filesystem_lnk:

	+ \inode_anc
	: a data structure storing \file_metadata_lnk, but not its \filename_lnk

	+ \data_block_pl
	: a data structure storing \file_lnk contents

	+ \directory_anc
	: a list of \hard_link_lnk_pl

\hard_link_anc
: a (\filename_lnk, \inode_lnk number) pair

+ \file_metadata_anc --- information stored in an \inode_lnk:

	+ \file_type_lnk

	+ location of \data_block_lnk_pl the \file_lnk uses on a \filesystem_lnk

	+ \file_owner_lnk and \file_group_lnk

	+ \file_permission_lnk_pl

	+ \file_timestamp_lnk_pl

	+ size

	+ \file_link_count_anc (number of \file_link_lnk_pl to the \inode_lnk)

+ \hard_link_lnk is thus a pointer to an \inode_lnk

+ there can be multiple \hard_link_lnk_pl pointing to an \inode_lnk, thus a \file_lnk can reside in more than one \directory_lnk

+ `file1` and `file2` are __hard-linked__ if they point to the same \inode_lnk

+ all \hard_link_lnk_pl to an \inode_lnk are equivalent, regardless of their creation order

+ a \file_lnk has $n$ \hard_link_lnk_pl if the \file_link_count_lnk of its \inode_lnk is $n$ (thus we count the very \file_lnk itself)

+ \inode_number_lnk_pl are unique within a \filesystem_lnk, thus \file_lnk_pl can be hard-linked only within the same \filesystem_lnk

+ traditionally, the \inode_number_lnk of the `/` (root) \directory_lnk is $2$

+ on my laptop, `/`, `/home`, `/opt` and `/scratch` all have \inode_number_lnk_pl of $2$, which is permitted since they are different \filesystem_lnk_pl

# a (filename, inode number) directory entry is unique only within that directory [there can be multiple identical (filename, inode number) pairs in different directories], but it can be resolved into system-wide unique (absolute pathname, inode number) pair through a path resolution process
# (absolute pathname, inode number) pairs are system-wide unique since absolute pathnames are system-wide unique (there are no identical absolute pathnames within a filesystem, and of course absolute pathnames on different filesystems always differ), though inode numbers are not system-wide unique
# an inode can have several filenames (links), but each file's absolute pathname points to one inode, thus there is a function mapping absolute pathnames into inode numbers

# list full directory contents (filenames and inode numbers):
ls -il /scratch

------------------------------------------------------------
# a link count (lc) for a directory
------------------------------------------------------------
## starting value: lc = 0
## each directory:
### has one parent directory and is referenced as (dirname, inode number) in this parent (lc := lc + 1)
### always contains "." and ".." links (see "ls -all" output) and is called empty if it contains only them
## "." points to the directory itself, thus there is (., inode number) entry in each directory (lc := lc + 1)
## ".." points to the parent directory (increasing its link count by 1)
## each of n first-level subdirectories in a directory contains (.., inode number) entry (lc := lc + n)
## "." and ".." in the root directory ("/") both point to the root directory (the parent of the root directory is the root directory itself)
## finally, lc = n + 2, n − number of first-level subdirectories inside a directory
## directories are not allowed to be hard linked manually like files, since this might lead to traverse loops, if e.g. a directory pointed back to its grandparent
------------------------------------------------------------

# moving a file is very fast since its data are not moved, just:
## a new (filename, inode number) entry is created in a new directory
## an old (filename, inode number) entry is deleted in an old directory
# thus moving a file doesn't change anything in its inode nor data blocks (in particular, a number of links to its inode, so a number of its hard-linked files)
# when renaming a file to a filename corresponding to an existing file pathname, the latter file is overwritten (removed and replaced with the former file):
touch file{1,2}
mv -iv !$ # "file2" overwritten with "file1"

------------------------------------------------------------
# symbolic vs. hard links
------------------------------------------------------------
## symbolic link − a file with an absolute or relative path to a file (target) in the filesystem
## if a symbolic link's target doesn't exist, the link is broken/orphaned/dangling
## to dereference a symbolic link − to follow the reference to the target rather than work with the link itself
## to no-dereference a symbolic link − to work with the link itself
## symbolic link doesn't point to an inode and thus doesn't increase a link count of an inode
## symbolic links, contrary to hard links, can point to directories
## since inodes are unique within a filesystem, hard links must be on the same filesystem, but symbolic links can point to targets on different filesystems
## deleting a symbolic link doesn't influence its target
## a symbolic links breaks if:
### its target is deleted or moved
### it contains a relative path to a target and is moved
## the inode is removed and the corresponding data blocks (together with the disk space) are freed only when the inode's last filename (hard link) is removed (unlinked, with "rm" or "unlink" command)
## editing a file through its:
### symbolic link (e.g. via "vi symlink") never breaks the link
### hard link (e.g. via "emacs file") breaks the link if the program creates a working copy of a file which overwrites a file when the program terminates (it's not the case in vi)
## hard links are used by many backup codes (e.g. rsnapshot) to save the disk space
------------------------------------------------------------
## hard link:
------------------------------------------------------------
ln ~/text/a.txt b.txt    # ~/text/a.txt → inode ← b.txt
## no disk space growth
------------------------------------------------------------
## symbolic link:
------------------------------------------------------------
ln -s ~/text/a.txt b.txt # b.txt → ~/text/a.txt → inode
## no disk space growth
------------------------------------------------------------
## copying a file:
------------------------------------------------------------
cp a.txt b.txt           # a.txt → inode1, b.txt → inode2
## disk space grows
------------------------------------------------------------

# get total number of filenames pointing to inodes of all files in a current directory:
stat * | grep -i link

# find files referring to the same inode as the "a.txt" file (hard links):
find ~/ -samefile a.txt

# find regular files with multiple hard links:
find -type f -links +1

# get a full pathname to a file or resolve a symbolic link:
readlink -f a.txt
# or:
realpath a.txt

# extract a final filename from a pathname:
basename ./Desktop/ # yields "Desktop"

# find duplicate files in a set of directories:
fdupes -r dir1 dir2

# find duplicate files in a set of directories, including hard links:
fdupes -rH dir1 dir2

# find files identical to "a.txt" in a directory "texts" and all duplicate files in it, including hard links:
rdfind -removeidentinode false a.txt texts
# the results are written to a "results.txt" file

# dry-run replacing duplicate files with hard links in a current directory:
rdfind -n true -makehard_links true .
# the results are written to a "results.txt" file

================================================================================
filesystem structure
================================================================================
--------------------------------------------------------------------------------
# capitalization and spaces in filenames in Linux
--------------------------------------------------------------------------------
## some people say it's best practice to avoid capitals and spaces in filenames, because:

### Linux system files stick to that rule (e.g. "/etc/skel/.mozilla", "/usr/local/bin")
### sorting order in Unix is case-sensitive (e.g. "Makefile" starts with a capital letter so that it appears early in file lists)
### file transferability between other (i.e. lame) operating systems is easier
### specifying filenames with capitals and spaces on the command line is less comfortable

## but:

### most Linux distros create capitalized directories in "$HOME" (e.g. "$HOME/Documents", "$HOME/Pictures")
### BASH handles filenames with capitals and spaces well when properly scripted

## some people opt for camel case (e.g. "$HOME/myPictures")

## decision:

### avoid capitals and spaces in filenames for code, scripts, etc. (e.g. "$HOME/scripts/characters", "$HOME/codes/fortran/mpi/hello.F90") and do not keep them inside capitalized directories
### use capitals and spaces in filenames for articles, books, films, pictures, etc. according to the language rules (e.g. "$HOME/Desktop/Articles/Molecular Mechanics", "$HOME/Desktop/Varieties/Movies/Polish Films/Ziemia obiecana.mkv")
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
# my take on filenames:
--------------------------------------------------------------------------------
## use "_" in system, code and script filenames to mark spaces (e.g. "build_scripts", "regular_users_list")
## use "-" to indicate software version (e.g. "openmpi-1.8.8", "molpro-2015", "molpro-pauli")
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
# my take on build and installation directory names:
--------------------------------------------------------------------------------
## src_dir=$HOME/$name/$name-git (if from Git) or src_dir=$HOME/$name/$name-src-$ver (if downloaded directly) − directory to keep the source
## bld_dir=$src_dir/build-$suffix − directory to build a software from source
## inst_dir=$HOME/$name/$name-$suffix (locally) or inst_dir=/opt/$name/$name-$suffix (globally) − directory to install binaries and libraries
## jobs_dir=$HOME/${name}_jobs − directory to keep input files
## scr_dir=/scratch/$USER/$name − scratch dirctory
## e.g. suffix=${branch//\//-}_${CC}-${CC_VERSION}_${FC}-${FC_VERSION}, name=nwchem, branch=release-6-8
--------------------------------------------------------------------------------

# get info on the filesystem hierarchy:
man hier

# list directory tree printing non-printable characters as is:
tree -dN

# go back to the previously visited directory:
cd -

================================================================================
file owner and group
================================================================================
# each file has one owner and is assigned to one group, in contrast to a user and a process which can be members of multiple groups
# a file owner doesn't have to be a member of a file group

# each file is owner:group and UID:GID, respectively

# change the files owner and group recursively inside a directory:
sudo chown -R theochem:gaussian dir

# change the files group recursively inside a directory:
chgrp -R gaussian dir

## file permissions

\file_permission_anc\plural{s}

: access rights to specific users, groups of users and processes created by users that control their ability to operate on \file_lnk\plural{s}

+ of course, root is not bound by file permissions

\file_permission_type_lnk | \file_permission_symbolic_representation_anc
---------------------------|------------------------
\file_read_permission_anc | \file_read_permission_lnk
\file_write_permission_anc | \file_write_permission_lnk
\file_execute_permission_anc | \file_execute_permission_lnk
\file_no_permission_anc | \file_no_permission_lnk

: \file_permission_type_anc_pl

\file_permission_class_anc
: specific \file_permission_lnk\plural{s} given to a corresponding \file_user_class_lnk

	\file_permission_class_lnk | \file_user_class_anc | comment                           
	----------------------------|-------------------------|-----------------------------------
	\file_owner_permission_class_anc | \file_owner_anc | used when the UID of the file equals the EUID of the calling process (e.g. the user accesses his own file) (A
	\file_group_permission_class_anc | \file_group_anc | used when the GID of the file equals the EGID of the calling process or the GID of one of the supplementary groups of the calling process (e.g. the user accesses the file which he doesn't own but which belongs to one of his groups) (B)
	\file_others_permission_class_anc | \file_others_anc | used when neither (A) nor (B) applies (e.g. the user accesses the file which he doesn't own and which belongs to none of his groups)
	\file_all_permission_class_anc ($=$ \file_owner_permission_class_lnk\file_group_permission_class_lnk\file_others_permission_class_lnk) | \file_all_users_lnk

	: \file_permission_class_lnk\plural{es} and corresponding \file_user_class_lnk\plural{es}

+ groups of \file_user_class_lnk\plural{es}:

	+ \file_all_users_anc: \file_owner_lnk, \file_group_lnk, and \file_others_lnk

	+ \file_any_user_anc: \file_owner_lnk, \file_group_lnk, or \file_others_lnk

# chmod and most commands refer to the owner, group and others class with "u", "g" and "o" letters, respectively, and "a" means all three classes
# though most commands refer to the owner class as the user class, we prefer to use the former name since it avoids confusion with the current user which might not be the file owner

# display file owner, group and corresponding UID and GID, plus much more information:
stat file

\file_mode_anc

: \file_owner_permission_class_lnk, \file_group_permission_class_lnk and \file_others_permission_class_lnk \file_permission_lnk\plural{s} plus \file_special_permission_lnk\plural{s}

+ a \file_permission_class_lnk is represented by three bits:

	bit | meaning
	----|--------
	$b_3$ | \file_read_bit_anc
	$b_2$ | \file_write_bit_anc
	$b_1$ | \file_execute_bit_anc

	: $b_3b_2b_1$ bit triad

+ a bit is either $0$ or $1$, so the highest binary value of the bit triad is 111, which corresponds to the decimal value of

	$$m = 1 \cdot 2^2 + 1 \cdot 2^1 + 1 \cdot 2^0 = 7$$

+ why __octal numbers__ are used to represent the \file_permission_lnk\plural{s}:

	+ decimal integer numbers between $0$ and $7$ have the same octal representation

	+ let's see how multiple bit triads convert to octal numbers:

		two bit triads | octal value
		---------------|------------
		$111\,111$ | $77$
		$000\,111$ | $7 \equiv 07$
		$110\,110$ | $66$

		three bit triads | octal value
		-----------------|------------
		$111\,111\,111$ | $777$
		$000\,000\,111$ | $7 \equiv 007$
		$100\,100\,100$ | $444$

		similarly for four, five, etc. bit triads

	+ so to get the octal value corresponding to $n$ bit triads, we can convert each bit triad separately into a decimal number, and compose the resulting $n$ decimal numbers into an $n$-digit octal number

	+ octal numbers are thus a natural choice to represent the bit triad values compactly

\file_permission_lnk bit | bit triad | octal value
--------------------------|-----------|------------
\file_read_bit_lnk | $100$ | $m = 4$
\file_write_bit_lnk | $010$ | $m = 2$
\file_execute_bit_lnk | $001$ | $m = 1$

: octal values corresponding to individual \file_permission_lnk bits

+ there are $2^3 = 8$ possible bit patterns for a single \file_permission_class_lnk, and hence $8^3 = 512$ possible bit patterns for the three \file_owner_permission_class_lnk, \file_group_permission_class_lnk and \file_others_permission_class_lnk \file_permission_class_lnk\plural{es} combined

+ \file_permission_class_lnk can be represented by its octal value $m$, or \file_permission_symbolic_representation_alt{symbolically}:

	bit triad | octal value | \file_permission_symbolic_representation_lnk
	----------|-------------|------------------------
	$000$ | $m = 0$ | `---`
	$001$ | $m = 1$ | `--x`
	$010$ | $m = 2$ | `-w-`
	$011$ | $m = 3$ | `-wx`
	$100$ | $m = 4$ | `r--`
	$101$ | $m = 5$ | `r-x`
	$110$ | $m = 6$ | `rw-`
	$111$ | $m = 7$ | `rwx`

	: $8$ possible bit patterns for a single \file_permission_class_lnk

\file_mode_string_anc

: a \file_permission_symbolic_representation_lnk of a \file_mode_lnk, e.g. `rw-rw-r--`{.bash}

## w = modify a file
## x = execute a file

--------------------------------------------------------------------------------
# permissions for directories (directory is basically a list of files and directories contained in it):
--------------------------------------------------------------------------------
## r = read the list (list the files within the directory)
## x = enter the directory and access files (but not list files)
## r+x = enter the directory, access and list files
## w+x = modify the list (create, delete, rename files), but not list files
## note that file deletion is allowed if a parent directory is w+x for the user, irrespective of the ownership and permissions of the file
--------------------------------------------------------------------------------

# typical directory permissions:
## 0 (---) − no access at all
## 1 (--x) − minimal access allowing directory traversing
## 5 (r-x) − enter the directory, read readable and edit writable files, but not remove any of them nor create new ones
## 7 (rwx) − full access

# permissions on Unix-like systems are not inherited, with the exception of the SGID bit (see below), however, to:
## enter a directory, it, together with all its parent directories, must have "x" set
## list files under a directory, (it must have "r" set for a single-level listing or "r" and "x" set for at least two-level listing) and all its parent directories must have "r" and "x" set

--------------------------------------------------------------------------------
# file and directory permission examples (user is the owner of all files)
--------------------------------------------------------------------------------
## the "x" bit on a directory:
--------------------------------------------------------------------------------
mkdir -m 775 dir
echo "text" > dir/file
chmod 111 dir
cd dir                  # works, "x" is set on "dir"
ls                      # doesn't work, "r" not set on "dir"
ls file                 # works, "x" on "dir" allows to access file contents together with its properties, and "ls file" accesses that information instead of reading directory contents as does "ls" − but we have to know the name of the file, completion doesn't work
cat file                # works as well
>file                   # interesting observation: we can erase file contents, since that operation doesn't modify directory contents
rm file                 # we can't remove any file without "w" set on its parent directory
--------------------------------------------------------------------------------
## the "r" bit on a directory:
--------------------------------------------------------------------------------
tree -pugFC
------------------------------------------------------------
output
------------------------------------------------------------
.
└── [drwxrwxr-x luke     luke    ]  dir/
    ├── [-rw-rw-r-- luke     luke    ]  file1
    ├── [-rw-rw-r-- luke     luke    ]  file2
    ├── [-rw-rw-r-- luke     luke    ]  file3
    └── [drwxrwxr-x luke     luke    ]  subdir/
        ├── [-rw-rw-r-- luke     luke    ]  file11
        ├── [-rw-rw-r-- luke     luke    ]  file12
        └── [-rw-rw-r-- luke     luke    ]  file13
------------------------------------------------------------
chmod 400 dir
find dir | sort
------------------------------------------------------------
output
------------------------------------------------------------
find: ‘dir/subdir’: Permission denied
dir
dir/file1
dir/file2
dir/file3
dir/subdir
------------------------------------------------------------
### we only get contents of "dir", since listing contents of "dir/subdir" would require "x" on "dir", we only have "r"
cd dir # doesn't work, "x" not set on "dir"
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
# special permissions:
--------------------------------------------------------------------------------
## SUID bit and SGID bit for files (see above for the processes for explanation)
## SUID bit for directories is ignored by Linux
## SGID bit for directories means newly created files and directories under that directory inherit their group from that directory, and newly created subdirectories inherit the SGID bit
## sticky bit for files, used only in old operating systems, saves the program's text image on the swap device so it will load more quickly when run
## sticky bit for directories (restricted deletion flag) means only the directory owner can rename, move or delete files within that directory

## special permissions are, just like standard class permissions, represented by a bit triad b₃b₂b₁:
### b₁ − sticky bit: 001 ⇒ m = 1
### b₂ − SGID bit: 010 ⇒ m = 2
### b₃ − SUID bit: 100 ⇒ m = 4
--------------------------------------------------------------------------------

# a full file mode is uniquely defined by 4 * 3 = 12 bits, so there are 2¹² = 4096 possible file mode bit combinations
# listing all 12 bit values would be cumbersome, thus the mode is represented either:
## numerically by a 3-digit number (octal permission values for owner, group and others triads), e.g. 644, 755, etc.
## numerically by a 4-digit number (octal permission values for special permissions and for owner, group and others triads), e.g. 0644, 4755, etc.
## symbolically using a sequence of 9 characters from "r", "w", "x", "-" letters already explained above, and:
### "s" − "x" is set and SUID bit set when in the owner triad or SGID bit when in the group triad
### "S" − "x" is not set, otherwise same as "s" (rare on regular files, and useless on directories)
### "t" − "x" is set and sticky bit set, resides only in the others triad
### "T" − "x" is not set, otherwise same as "t" (rare on regular files, and useless on directories)
### "S" and "T" are useless on directories, since without "x" a user can't enter the directory
## e.g.
### 0644 ⇔ rw-r--r--
### 4755 ⇔ rwsr-xr-x
### 2720 ⇔ -rwx-wS---
### 1640 ⇔ rw-r----T

# show file mode in an octal form:
stat -c %a file

# show file mode in a symbolical (human-readable) form:
stat -c %A file
# or:
ls -l file
# or:
ls -ld dir
# note that the mode is prepended with the file type character ("-" − regular file, "d" − directory, etc.) and if it's appended with "+", the file has extended permissions (access control lists)

--------------------------------------------------------------------------------
# file mode creation mask:
--------------------------------------------------------------------------------
## contains the permission bits that should not be set on a newly created file
## is the logical complement of the:
### (default mode + 0111) for newly created files
### default mode for newly created directories
## ignores the special permission bits

## default creation mode:
### 0777 for directories
### 0666 for regular files (Linux does not allow files to be created with executable permissions)
## hence for the mask = 0002, the mode of a newly created:
### regular file is 0664
### directory is 0775 or 2775 if it's under a SGID-set directory

## display the file mode mask:
umask
--------------------------------------------------------------------------------

# changing file modes:
umask          # 0002
touch file     # 0664
chmod +x file  # 0775
chmod +s file  # 6775
chmod 664 file # 0664 (omitted digits are assumed to be leading zeros)
chmod o-r file # 0660
mkdir dir      # 0775
chmod +t dir   # 1775
chmod 775 dir  # 0775
chmod g+s dir  # 2775
chmod 775 dir  # 2775 (SUID and SGID bits of a directory cannot be cleared with a numeric mode)
chmod -s dir   # 0775 (SUID and SGID bits of a directory need to cleared with a symbolic mode)

--------------------------------------------------------------------------------
# share "/var/www" directory between users of the "www-data" group so that they can read and write contents in it:
--------------------------------------------------------------------------------
## let's assume that "/var" and "/var/www" are root:root and 0755, so are readable by everyone
## recursively change group of "/var/www" to "www-data":
sudo chgrp -R www-data /var/www
## recursively grant group members a write permission to "/var/www":
sudo chmod -R g+w /var/www
## add the SGID bit to "/var/www" directory and all directories below it, so that newly created files and directories created under it belong to the "www-data" group:
sudo find /var/www -type d -exec chmod g+s {} \;
## we can't simply use "chmod -R" above, since we must restrict the operation to directories only, and we apply it recursively because the SGID bit is inherited only after it's been added
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
# external disk with ext4 filesystem mounted in "/run/media/luke/DataTraveler" for the "luke" user:
--------------------------------------------------------------------------------
## "/run/media/luke/DataTraveler" is root:root 0755, so "luke" can't create files in that directory
## "luke" needs to use sudo to create a directory:
sudo mkdir dir
sudo chown luke:luke
## thus created "dir" is usually 0755, since root's mask is usually 0022, and that of a regular user is usually 0002, so "luke" might additionally do
chmod 775 dir
## "dir" is now fully accessible to "luke"
## note that if an external disk with FAT filesystem is mounted, a regular user can create files directly under a mount point since FAT is totally lame and doesn't know what Linux permissions are
--------------------------------------------------------------------------------

## \file_timestamp_pl

\file_MAC_time_lnk | description
-------------------|------------
\file_mtime_anc | when the \file_lnk contents most recently changed
\file_atime_anc | when the \file_lnk was most recently opened for reading
\file_ctime_anc | when the \file_lnk owner, group, permissions, size or name most recently changed

: \file_MAC_time_anc_pl

## mtime changes each time a file is written during edition, even if its final version is the same as that of the originally-opened file
## mtime change triggers atime and ctime changes: atime is set to mtime, and ctime is ca. 50 ms later in time than mtime since file metadata are written after its contents were saved
## renaming a file changes only its ctime
## note, however, that since most filesystems are mounted with the default "relatime" option, atime is only updated if the previous atime was earlier than the current mtime or ctime

# report file timestamps:
stat file

# when e.g. wget or youtube-dl downloads a file from a website, its mtime is taken from a download server if it gives timestamps, but atime and ctime are set to the download time since the file copy has been created locally, so to list files downloaded within last hour inside a directory, use:
find -maxdepth 1 -amin -60
# or:
find -maxdepth 1 -cmin -60
# instead of the "-mmin" switch

================================================================================
file and directory size
================================================================================
# list 15 biggest directories under a current directory:
du -hS | sort -hr | head -n 15
# note that "du -hS" treats each directory separately and doesn't count the size of its subdirectories (each directory is printed separately), hidden directories are accounted for

# list 15 biggest directories in a current directory including the size of their subdirectories:
shopt -s dotglob
du -hs * | sort -hr | head -n 15
# note that the "dotglob" option must be set so that a shell expands "*" into hidden directories, if present, as well

================================================================================
file renaming
================================================================================
# use brace expansion to avoid first argument repetition:
mv -iv {,old_}readme.txt             # 'readme.txt' -> 'old_readme.txt'
mv -iv {Image0001,"My Passport"}.jpg # 'Image0001.jpg' -> 'My Passport.jpg'
mv -iv file{,.backup}                # 'file' -> 'file.backup'

# use history expansion to avoid first argument repetition:
mv -iv Image0001.jpg "My Passport"!#:2:e # 'Image0001.jpg' -> 'My Passport.jpg' ("2" means second word after "mv", which is "Image0001.jpg")
mv -iv "system file" !#$.backup          # 'system file' -> 'system file.backup'
# the filename can be printed using the "p" designator for further edition:
mv -iv "file with a long name" !#$:p
# then press "↑" to edit the command

--------------------------------------------------------------------------------
# renaming multiple files: rename and mmv
--------------------------------------------------------------------------------
## rename "linx1.txt" etc. files into "linux docs 1.txt" etc.:
rename linx "linux docs " *.txt
## note we cannot quote "*.txt" as the rename command needs a list of files, and quoting would prevent the shell expansion into a list of files

## mmv command works with globs and the globs must be quoted as they must be processed by mmv, not by the shell

## dry-run a multiple rename operation with mmv:
mmv -n "*.jpg" "#1.png"

## append "p" to filenames starting with a digit:
mmv -v "[0-9]*" "p#1#2"
## "#1" matches a first digit in a filename, "#2" matches everything after the first digit

## rename files and directories with names beginning with two numbers and "_" into the remainders of their names:
mmv -rv "[0-9][0-9]_*" "#3"
## "#1" and "#2" would match first and second digit in a filename, respectively
## "-r" must be used to match both files and directories

## remove " (sth)" from filenames:
mmv -n '* (*)*' '#1#3'

## remove "Ford Fiesta - " leading string from all filenames und capitalize first character after the string:
mmv -v "Ford Fiesta - ?*" "#u1#2"
## e.g. "Ford Fiesta - rear.jpg" is renamed into "Rear.jpg"
--------------------------------------------------------------------------------

================================================================================
temporary files and directories
================================================================================
# create a temporary directory in a current directory using a template:
mktemp -p . -d mytempdir-XXX

## splitting large \file\plural{s}

+ split a large \file_lnk into:

	+ 100 smaller \file_lnk\plural{s}:

		```bash
		split -dn 100 large_file split_file_
		```

	+ $100~\mathrm{MiB}$ \file_lnk\plural{s}:

		```bash
		split -db 100M large_file split_file_
		```

+ the split \file_lnk\plural{s} are `split_file_00`, `split_file_01`, `...` (and `x00`, `x01`, `...` if no `split_file_` prefix is present), and their concatenation leads back to an original \file_lnk:

	```bash
	cat split_file_* > original_large_file
	```
