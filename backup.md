
# \backup_chapter_anchor

## \rsync_anchor

+ the most common \rsync_link option is `-a`, which is equal to `-rlptgoD`:

	component | meaning
	----------|--------
	`-r` | copy directories recursively
	`-l` | copy symlinks as symlinks
	`-p` | preserve permissions
	`-t` | preserve mtimes
	`-g` | preserve group
	`-o` | preserve owner
	`-D` | preserve device and special files

	: \rsync_link `-a` option components

+ get a remote file that has spaces in its name --- use double escape:

	```bash
	rsync -avPz -e ssh luke@@super.cluster.somewhere:"file\ with\ some\ spaces\ in\ it.dat" "$HOME/Desktop"
	```

+ sync files to a FAT disk (e.g. a USB drive) --- use `@@1` option to allow mtimes differ by $1~\mathrm{s}$:

	```bash
	rsync -aPv@@1 Desktop/Data /Volumes/KINGSTON
	```

+ sync directory preserving hard links --- use `-H` option:

	```bash
	rsync -ahHPvz src dest
	```

+ __dry-run__ syncing files that have the same size, ignoring permissions, mtimes, group and owner, and __deleting__ files not present in the source directory:

	```bash
	rsync -rPv --size-only --delete -n Data /run/media/luke/MyPassport/Docs
	```

	to actually perform the operation, remove the `-n` option

+ sync directories using filter file: create a file, say "$HOME/rsync_filter" (notice how the spaces are handled − they need not be escaped in a filter file), e.g.
-------------------------------------------------------
$HOME/rsync_filter
-------------------------------------------------------
-p .DS_Store
- luke/fuse/
- luke/Desktop/Varieties/Movies/
- luke/Library/Application Support/
- luke/.kde/
- luke/install/
-------------------------------------------------------
# and then use:
rsync -ahPvz --filter=". $HOME/rsync_filter" "$HOME" /backup

--------------------------------------------------------------------------------
# filter patterns (file in general refers to directory as well, we assume we use rsync command with options as listed above):
--------------------------------------------------------------------------------
## rsync builds a list of files to be transferred in a similar way "find directory | sort" lists files, but for each file a pattern list is checked until the first matching pattern is found (if it's an exclude pattern, file is skipped, and vice versa, but if no pattern matches a file, it's not skipped), thus if the directory is excluded, it won't be descended into

## if the pattern contains "/" (not counting the trailing "/") or "**", it's matched against the pathname, otherwise it's matched against the final filename

## the filter rules:
+ luke/Pictures/
- luke/*
## match everything in paths containing "luke/Pictures/", but exclude everything else
## the files in "luke/Pictures/" are not skipped, though "+ luke/Pictures/" matches only that dir, however, no filter pattern to be applied is found e.g. for "luke/Pictures/img.jpg" file as "- luke/*" excludes directories and files under "luke" ("*" stops at slashes), so "luke/Pictures/img.jpg" is not skipped

## the filter rule:
+ software/molpro
- *
## won't match anything, because rsync first gets "software/" component checked before descending to "software/molpro" component and "software/" is excluded by "- *"

## the filter rules:
+ Varieties/
+ Varieties/Movies/
+ Varieties/Movies/Screens/
- Varieties/Movies/*
- Varieties/*
## match only the directories and files in "Varieties/Movies/Screens/" and skip everything else under "Varieties/":
## we need "- Varieties/Movies/*" so that directories and files apart from "Screens/" in "Varieties/Movies/" are skipped, as "- Varieties/*" wouldn't exclude them ("*" stops at slashes)

## but note that the filter rules:
+ Varieties/
+ Varieties/Movies/
+ Varieties/Movies/Screens/
- Varieties/**
## only match "Varieties/Movies/Screens/" and no files within − all files are excluded by the "- Varieties/**" ("**" doesn't stop at slashes)

## "Unable to delete non-empty directory" error is usually triggered by files which become excluded by filter rules and are left on a receiver in directories which have been deleted on a sender: e.g. after some rsync actions lots of ".DS_Store" files have been copied to a receiver and now we add an exclude rule for them and delete some directories containing them on a sender − rsync won't delete those directories on a receiver since they are not empty as they still contain ".DS_Store" files: the solution is to use a perishable ("p") modifier which makes a rule perish for a directory which is to be deleted (this way the file is not excluded by the already perished rule and gets deleted, thus emptying the directory it's in):
rsync -ahPvz --delete -f "-p .DS_Store" Articles backup
--------------------------------------------------------------------------------

# update only pdf files and skip all other directories:
## we need to include "*.pdf" files
## but by default everything is included, so above rule wouldn't make sense on its own: we need to exclude other files, we do so with "-! */"
## that still includes all directories, but we don't need to copy directories without pdf files under them − so we prune them:
rsync -ahPvz --prune-empty-dirs --delete --include="*.pdf" -f "-! */" Articles backup

# update only the directory tree or copy only the directory structure:
## we use a filter rule to include all the directories, "+ */", and then a rule to exclude all the files, "- *":
rsync -av -f "+ */" -f "- *" /src/foo /dest

# update only the directory tree or copy only the directory structure of the first subdirectory level only:
rsync -av -f "+ /*/" -f "- *" /src/foo /dest

# update all but some directories in the "src" directory and skip all the files directly under "src":
-------------------------------------------------------
$HOME/rsync_filter
-------------------------------------------------------
- src/no1/
- src/no2/
- src/no3/
+ src/**/
- src/*
-------------------------------------------------------
# and then use:
rsync -ahPvz --filter=". $HOME/rsync_filter" src dest
# note that all files under, say, "src/yes" are updated: though the "+ src/**/" rule matches directories only, those files are not excluded (nor included) by any rule, no rule applies to them, so implicitly they are included

# the trailing slash in the source directory:
rsync -av /run/CD/ .
# avoids creating an additional directory (here: "CD") at the destination (here: ".", so a current directory), with the attributes of the source directory (here: "/run/CD") transferred to the destination directory (here: current directory), but:
rsync -av /run/CD/* .
# doesn't change the attributes of the destination directory (here: current directory), since "/run/CD/*" is expanded by the shell to the listing of the source directory, but apart from that both variants have the same results if "dotglob" option is set (without it "*" won't expand into hidden files)
# thus the two commands have the same results:
rsync -av /src/foo /dest
rsync -av /src/foo/ /dest/foo

# using "." as the source directory makes rsync behave as if the trailing slash were present, thus all three commands have the same results:
rsync -av src/ dest
cd src && rsync -av . ../dest
cd src && rsync -av ./ ../dest

# make a list of files which would be replaced skipping existing files on the receiver:
rsync -ahPvz --ignore-existing -n -i /media/luke /home &> log.txt

--------------------------------------------------------------------------------
# use rsnapshot to back up directories on a remote machine (say, called remote) as a root user: on remote:
--------------------------------------------------------------------------------
## edit "/etc/ssh/sshd_config" so that it contains a line:
PermitRootLogin forced-commands-only

## put a perl script called rrsync (which usually comes with rsync installation) in /usr/bin/rrsync and make it executable

## place local machine's public SSH key in "/root/.ssh/authorized_keys" and prepend it on a single line as follows:
commmand="/usr/bin/rrsync -ro /" ssh-rsa (the proper key follows)

## then on a local machine (which carries out backups) you can put in "/etc/rsnapshot.conf" the lines as such:
backup	root@remote:/home/	remote-home/
--------------------------------------------------------------------------------
