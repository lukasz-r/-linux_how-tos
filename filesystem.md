
# filesystem

================================================================================
files, directories, inodes and links
================================================================================
# a file is stored in at least three parts of a filesystem:
## inode (index node) − a data structure storing file metadata, but not its name
## data blocks − a data structure storing file contents
## directory − a list of hard links, i.e. (filename, inode number) pairs

# file metadata (thus information stored in an inode):
## file type (regular file, directory, etc.)
## location of data blocks the file uses on a filesystem
## owner and group
## permissions
## timestamps
## size
## number of links to the inode (link count)

# hard link is thus a pointer to an inode
# there can be multiple links pointing to an inode, thus a file can reside in more than one directory
# "file1" and "file2" are hard-linked if they point to the same inode
# all hard links to an inode are equivalent, regardless of their creation order
# a file has n hard links if the link count of its inode is n (thus we count the very file itself)
# inode numbers are unique within a filesystem, thus files can be hard-linked only within the same filesystem
# inode number for "/" (a root dir) is traditionally 2
# on my laptop, "/", "/home", "/opt" and "/scratch" all have inode numbers equal to 2, which is permitted since they are different filesystems

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
rdfind -n true -makehardlinks true .
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

================================================================================
file permissions
================================================================================
# file permissions − access rights to specific users, groups of users and processes created by users that control their ability to operate on files

# of course, root is not bound by file permissions

# file permission classes:
## owner: used when the UID of the file equals the EUID of the calling process (e.g. the user accesses his own file) (A
## group: used when the GID of the file equals the EGID of the calling process or the GID of one of the supplementary groups of the calling process (e.g. the user accesses the file which he doesn't own but which belongs to one of his groups) (B)
## others: used when neither (A) nor (B) applies (e.g. the user accesses the file which he doesn't own and which belongs to none of his groups)

# chmod and most commands refer to the owner, group and others class with "u", "g" and "o" letters, respectively, and "a" means all three classes
# though most commands refer to the owner class as the user class, we prefer to use the former name since it avoids confusion with the current user which might not be the file owner

# display file owner, group and corresponding UID and GID, plus much more information:
stat file

# file mode − filesystem permissions given to owner, group and others class to access files, plus special permissions
# permissions for each class are represented by a bit triad b₃b₂b₁:
## b₁ − execute bit
## b₂ − write bit
## b₃ − read bit
# a bit is either 0 or 1, so the highest binary value of the triad is 111, which corresponds to:
## m = 1 * 2² + 1 * 2¹ + 1 * 2⁰ = 7
# octal numbers are used to represent the permissions:
## all numbers ≤ 7 have the same decimal and octal representations
## let's see how two bit triads convert to octal numbers:
### 111111 → 77
### 000111 → 7 ≡ 07
### 110110 → 66
## similarly for three bit triads:
### 111111111 → 777
### 100100100 → 444
## similarly for four, five, etc. bit triads
## so we can convert each bit triad separately into a decimal number and compose the resulting numbers into an octal number
## octal numbers are thus a natural choice to represent the bit triad values compactly
# execute bit: 001 ⇒ m = 1
# write bit: 010 ⇒ m = 2
# read bit: 100 ⇒ m = 4
# there are 2³ = 8 possible bit patterns for a single class, and hence 8³ = 512 possible bit patterns for the three classes
# class permissions can be represented by their octal value or symbolically with "r", "w", "x" and "-" symbols, e.g.
## m = 7 ⇔ rwx
## m = 5 ⇔ r-x
## m = 4 ⇔ r--

--------------------------------------------------------------------------------
# permissions for files:
--------------------------------------------------------------------------------
## r = read a file
## w = modify a file
## x = execute a file
--------------------------------------------------------------------------------

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

================================================================================
file timestamps
================================================================================
# file MAC (modification, access, change) times:
## M (mtime) describes when the file contents most recently changed
## A (atime) describes when the file was most recently opened for reading
## C (ctime) describes when the file owner, group, permissions, size or name most recently changed
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
