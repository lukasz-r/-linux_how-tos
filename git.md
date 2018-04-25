
# Git

## getting help

+ print a list of useful guides:
```bash
git help -g
```

+ useful guides:
```bash
man gittutorial
man gittutorial-2
man giteveryday
man gitglossary
```

## basic Git configuration

+ global Git options are stored in `~/.gitconfig`
+ local Git options (specific to a repo) are stored in repo's `.git/config`

+ list all variables set in config files:
```bash
git config -l
```

+ list only global variables:
```bash
git config --global -l
```

+ get the values of the variables matching a regex:
```bash
git config --get-regexp mail
```

+ set the name and email associated with your commits:
```bash
git config --global user.name "John Git"
git config --global user.email johngit@example.com
```
	but you can always set the author when you commit via:
```bash
git commit --author="John Git Jr. johngitjunior@example.com"
```

## cloning a repo

+ clone a repo into a local directory:
```bash
git clone git@www.molpro.net:Molpro molpro-pauli
```
+ clone a repo containing other repos (submodules) into its default directory:
```bash
git clone --recursive git@gitlab.com:dalton/dalton.git
```
+ simplify URLs using the `~/.ssh/config` configuration file (provided the SSH private key is in `~/.ssh/id_rsa.git` and the corresponding SSH public key is in `~/.ssh/id_rsa.git.pub`): `~/.ssh/config`:

	```bash
	# Molpro
	Host molpro
	User git
	HostName www.molpro.net
	IdentityFile ~/.ssh/id_rsa.git

	# Bitbucket
	Host bitbucket
	User git
	HostName bitbucket.org
	IdentityFile ~/.ssh/id_rsa.git

	# GitLab
	Host gitlab
	User git
	HostName gitlab.com
	IdentityFile ~/.ssh/id_rsa.git
	```

	the `IdentityFile` line is not needed when a standard location (`~/.ssh/id_rsa`) key is used

	with such a definition, cloning reads:
```bash
git clone --recursive gitlab:dalton/dalton.git
```

## submodules

+ list submodules in a repo:
```bash
git submodule
```

+ initialize all submodules in a repo (e.g. if cloned without `--recursive` option):
```bash
git submodule update --init --recursive
```

## working tree, staging area and repos

\define{Git_wt}{__working tree__}
\define{Git_wt_linked}{[\Git_wt](#Git_wt)}
\define{Git_sa}{__staging area__}
\define{Git_sa_linked}{[\Git_sa](#Git_sa)}
\define{Git_lr}{__local repo__}
\define{Git_lr_linked}{[\Git_lr](#Git_lr)}
\define{Git_rr}{__remote repo__}
\define{Git_rr_linked}{[\Git_rr](#Git_rr)}

+ Git operates on several levels: <br>
	\Git_wt_linked → \Git_sa_linked (__index__) → \Git_lr_linked → \Git_rr_linked
	+ \Git_wt<a name="Git_wt"></a> is a working directory contents where you actually modify files
	+ \Git_sa<a name="Git_sa"></a> collects info on what will go in the next commit
	+ \Git_lr<a name="Git_lr"></a> contains all history up to the last commit (it collects all the data which e.g. would be copied from the repo with "git clone")
	+ \Git_rr<a name="Git_rr"></a> tracks the same project as (C), but resides somewhere else

+ the Git workflow:
	#. you modify files in the \Git_wt_linked
	#. with `git add` you selectively add just the changes (new or modified files) you want to be a part of a next commit, thus you stage the changes to the index: <br>
	\Git_wt_linked → \Git_sa_linked
	#. with `git rm` you selectively remove files from the \Git_wt_linked and from the \Git_sa_linked
	#. with `git commit` you record the changes staged in the \Git_sa_linked to the \Git_lr_linked: <br>
	\Git_sa_linked → \Git_lr_linked
	#. if step 2. doesn't involve new files addition (just the file contents modification), steps 2.---4. can be accomplished in a single step with `git commit -a`: <br>
	\Git_wt_linked → \Git_sa_linked → \Git_lr_linked
	#. with `git push` you record the changes to the \Git_rr_linked: <br>
	\Git_lr_linked → \Git_rr_linked

+ a file in the \Git_wt_linked is either:

	+ tracked, then it can be:

		+ unmodified (committed) --- it hasn't been changed relative to the last commit, its same version is in the \Git_lr_linked

		+ modified --- it's been changed relative to the last commit in the \Git_lr_linked, but not yet staged

		+ staged --- its modification has been recorded in the \Git_sa_linked, so it's also in the \Git_sa_linked

	+ untracked, since it:

		+ is ignored due to the rules in `.gitignore` (note that the rules don't affect already tracked files)

		+ hasn't been staged and the last commit doesn't include this file (e.g. it's a newly created file)

+ show the working tree status:
```bash
git status
```

	also show individual files in untracked directories and ignored files:
```bash
git status -uall --ignored
```

+ show modified files:
```bash
git diff
```

+ show staged files (what will be committed with `git commit`):
```bash
git diff --cached
```
	or:
```bash
git diff --staged
```

+ show both modified and staged files (what will be committed with `git commit -a`):
```bash
git diff HEAD
```

+ if you only use `git commit -a`, you skip staging changes, thus `git diff` and `git diff HEAD` yield same results

+ show modifications for a specific file:
```bash
git diff Makefile
```

## adding files

+ if you add a new file and want Git to track it, you need to stage its addition:
```bash
git add new_file
```
	and then commit it:
```bash
git commit
```
+ thus a staging part can't be skipped in the case of a file addition

## removing files

+ if a file is removed with
```bash
rm file_del
```
	it's no longer in \Git_wt_linked and is reported as deleted and not staged for commit

+ at this point you can restore a file (e.g. if you deleted it by accident):
```bash
git checkout file_del
```
	(`git checkout` alone lists deleted files)

+ but if you want to actually remove a file from a repo, stage its removal with:
```bash
git rm file_del
```
	which has the same effect regardless of whether or not the `rm file_del` command was used previously: the file is no longer in \Git_wt_linked and is reported as deleted and staged for commit, so you can commit the change:
```bash
git commit
```
	or do both of the above in one go:
```bash
git commit -a
```
+ now the file's gone from the \Git_wt_linked, but it's history up to a deletion is recorded in the \Git_lr_linked, thus `file_del` can be restored by checking it from a specific commit, e.g. from the one before its deletion (the penultimate one):
```bash
git checkout HEAD^ file_del
```
	`file_del` is now staged

## untracking files

+ untrack a tracked file (useful if you forgot to add something to `.gitignore` and accidentally staged or committed a file):
```bash
git rm --cached file_ut
```
+ now `file_ut` is in still in \Git_wt_linked and its deletion is staged in \Git_sa_linked, and you can commit the change:
```bash
git commit
```
	`file_ut` is now untracked

## discarding file modifications

+ discard changes on a modified file:
```bash
git checkout file_mod
```

+ discard changes on an already staged file:
```bash
git reset HEAD file_mod # unstages a file, "file_mod" is now modified
git checkout file_mod
```

+ undo all changes in the tracked files in the working tree and in the index (e.g. introduced with "git pull" which led to merge conflicts), reverting them to the last commit:
```bash
git reset --hard HEAD
```

# rename a file:
mv -iv file1 file2
# now "file1" is deleted and "file2" is untracked, so we need to stage the changes:
git rm file1
git add file2
# all three above commands can be replaced with:
git mv -v old new
# which stages a rename automatically
# Git tracks contents not files, so it detects a rename after those operations, now just commit the change:
git commit

# copy a file from the "source_br" branch into the "working_br" branch:
git checkout working_br # if not already at "working_br"
git checkout source_br file_cp
# "file_cp" is now staged if its versions differ between the two branches

## clean-up

+ dry-run removing non-ignored untracked files and directories from the working tree:
```bash
git clean -dn
```
	
	actually remove them:
```bash
git clean -df
```

+ dry-run removing all (including ignored) untracked files and directories from the working tree:
```bash
git clean -dxn
```

	actually remove them:
```bash
git clean -dxf
```

	also remove directories with `.git` subdirectory:
```bash
git clean -dxff
```
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
# creating a Git repo for a working project
--------------------------------------------------------------------------------
## go to the working directory of your project and initialize a Git repo:
git init
## a "master" branch is created by default and "HEAD" points to that branch
## the name of the working directory is irrelevant and can be changed at any time
## you can name your project by editing the ".git/description" file, this name is used by some web interfaces

## create a ".gitignore" file with the filter rules

## add all the contents of the working directory (".") but ignored files to the repo:
git add .

## record a current state as a first commit:
git commit -m "initial commit"

## you can create your own branch which you can share through the remote Git repo instead of working with a default "master" branch:
git checkout -b my_branch
## creating a branch is very useful if lots of people work on the same code, so that people use their own branches for their contributions

## now you can add a remote Git repo that the other users can access and through which you can share your changes
## initialize a bare Git repo (repo with only Git objects and no working tree) in a directory on a remote machine:
[remote_machine]$ cd ~/git_repos/work_repo.git
[remote_machine]$ git init --bare
## it's useful to add the name (e.g. "my_cluster") and definition of the remote machine to the "~/.ssh/config" file

## go back to a working directory on your local computer and add "my_repo" remote repo at "my_cluster":
git remote add my_repo my_cluster:git_repos/work_repo.git

## switch to your branch and push it to the remote repo:
git checkout my_branch
git push -u my_repo my_branch
## using "-u" makes "my_repo" and "my_branch" default options for argument-less "git push" and "git pull" commands for "my_branch", i.e. a "my_repo/my_branch" upstream branch is created (see below)

## now you've got a history of your branch recorded at the remote repo
## but "HEAD" at "my_repo" points to "master" branch by default
## if "my_branch" ≠ "master", you need to switch an avtive branch at the remote repo to "my_branch":
[remote_machine]$ cd ~/git_repos/work_repo.git
[remote_machine]$ git symbolic-ref HEAD refs/heads/my_branch
## note that "git checkout my_branch" can't be run in a bare repo since it doesn't contain a working tree, so the above command must be used
## on Git severs (e.g. Bitbucket) a default clone branch (an active branch in a remote repo) can be changed via a web interface

## you can add more remote repos, e.g. use the Bitbucket website (where you log in in initialize a new repo via a web interface):
git remote add bitbucket bitbucket:luke/molpro_lr_repo # "bitbucket" defined above in the "~/.ssh/config" file
git push bitbucket my_branch
## this way "bitbucket" contains only "my_branch", which we've just pushed

## you can rename a remote repo, especially when it's called "origin" (a default name given to a remote repo in a local cloned repo):
git remote rename origin my_repo

## you can rename a Git repo directory on a remote machine:
[remote_machine]$ mv -iv ~/git_repos/{work_repo,super_repo}.git
## you need to change the remote URL in your local repo accordingly:
git remote set-url my_repo my_cluster:git_repos/super_repo.git

## show remote repos:
git remote -v

## list references in a remote repo:
git ls-remote my_repo

## now you can share your work with others: you can add their public keys to your cluster or grant access via a web interface e.g. on your project Bitbucket website, and ask them to clone the code:
git clone my_cluster:git_repos/work_repo.git my_work_dir
## of course, "my_cluster" needs to be substituted with the full remote machine address if not configured in the "~/.ssh/config" file

## if you've added multiple files and directories to your working tree, you can stage them in one go:
git add .
## but make sure your ".gitignore" properly takes care of files generated through the compilation process so that you don't stage those files as well with this command

## stage an ignored file:
git add -f ignored_file

## commit your changes and send them to a remote repo:
git commit -a
git push

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
# development logs
--------------------------------------------------------------------------------
## branch ref points to the tip of a branch (a most recent commit)
## "HEAD" points to either:
### a current branch
### an arbitrary commit in a detached "HEAD" state
## current commit − a commit "HEAD" points to
## "HEAD" changes when switching branches, checking out commits, and committing
## head − a named reference to the commit at the tip of a branch, stored in "refs/heads/branch_name" file
## head corresponds to a branch name

## reflog − a reference log recording where "HEAD" and the heads have been in a few last months in a local repo
## reflog records all actions changing "HEAD" and heads in a local repo, thus it's local to a specific repo and isn't cloned
## reflog is an equivalent of a BASH history, which is specific for a session
## reflog is rotated just like a BASH history
## commit logs record a commit ancestry chain: what and when was committed
## commit logs are shared among repos and are never deleted,
## thus reflog stores more information than commit logs for their time span

## show the reflog for "HEAD":
git reflog
## show the reflog for "my_branch":
git reflog show my_branch
## show the commit logs for "HEAD":
git log
## show the commit logs for all branches in a nice way:
git log --oneline --graph --decorate

## reflog examples:
git show HEAD@{2} # 2nd prior value of "HEAD" (not necessarily a grandparent, might be a commit on a different branch if a branch was switched)
git show my_branch@{"5 weeks ago"}
git show my_branch@{"2016-02-01 18:30:00"}

## commit ancestry examples:
git show HEAD # a current commit
git show @ # a current commit, "@" alone = "HEAD"
git show HEAD^ # the first parent of a current commit
git show HEAD~ # the first parent of a current commit
git show 71ff4b19^2 # the second parent of a merge commit (the parent on a branch that was merged in), the first parent ("^" = "^1") is the parent on a branch to which a merge was made
git show my_branch~2 # grandparent (following only first parents in case of merge commits) of a tip of "my_branch"

## more on specifying revisions:
man git-rev-parse

+ show commit logs by author matching a pattern:
```bash
git log --author=andreas
```

+ show commit logs by commit message matching a pattern:
```bash
git log -i --grep=regular
```

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
# branches
--------------------------------------------------------------------------------
## incorporate changes from "dev_branch" into "my_branch":
git checkout my_branch
git merge dev_branch
## if merge is successful, it's automatically recorded as a new commit

### list branches already merged into the branch you're on (those branches can be safely deleted without losing any changes):
git branch --merged

## remote-tracking branch − a branch following changes in a branch at a remote repo
## tracking branch − a branch checkout out of a remote-tracking branch, so a branch following changes in a remote-tracking branch
## upstream branch − a remote-tracking branch followed by a tracking branch
## local branch − a non remote-tracking branch in a local Git repo (it's tracking if it has an upstream branch, or non-tracking otherwise)
## remote branch − a branch at a remote Git repo
## in fact all non-remote branches exist locally, but Git makes a distinction between remote-tracking and local branches

## a remote-tracking branch ref is "refs/remotes/my_repo/my_branch": it tracks "my_branch" at "my_repo", and is referred to as "my_repo/my_branch" in Git commands
## a local branch ref is "refs/heads/my_branch", and is referred to as "my_branch" in Git commands
## a branch name can contain slashes (e.g. "release/2016"), thus "my_repo/my_branch" might include multiple slashes
## "branch.my_branch.remote" and "branch.my_branch.merge" variables define an upstream branch for a "my_branch" tracking branch
## an upstream branch is referred to as "@{u}" from its tracking branches:
git merge @{u}

## when cloning a repo, remote-tracking branches for each branch in the cloned repo, and a tracking branch for an active branch are created

## list remote-tracking branches:
git branch -r
## list local and remote-tracking branches:
git branch -a
## list local branches together with their upstream branches, if they're set:
git branch -vv

## create a "2012" tracking branch to follow a "origin/2012.1" remote-tracking branch:
git checkout -b 2012 origin/2012.1

## if there's a "origin/2012.1" remote-tracking branch, a "2012.1" tracking branch can be easily created with:
git checkout --track origin/2012.1
## or:
git checkout 2012.1

## set or change an upstream branch for a current branch:
git branch -u origin/2012.1

## update the remote-tracking branches from "my_repo":
git fetch my_repo
## update the remote-tracking branches from all remote repos:
git fetch --all

## update the remote-tracking branches and incorporate changes into a current tracking branch:
git pull
## "git pull" is basically "git fetch" plus "git merge"

## delete a local "2012" branch (first you need to switch to another branch):
git checkout master
git branch -D 2012

## rename the "old_branch_name" branch you're on:
git branch -m new_branch_name
## now you need to delete the "old_branch_name" from a remote repo and push the "new_branch_name":
git push my_repo :old_branch_name new_branch_name
## but this will result in an error if "old_branch_name" is the default branch in a remote repo, then:
git push my_repo new_branch_name
## change a default branch in a remote repo to "new_branch_name", either with:
[remote_machine]$ git symbolic-ref HEAD refs/heads/new_branch_name
## or via a web interface, and finally:
git push my_repo :old_branch_name

## "warning: ignoring broken ref refs/remotes/my_repo/HEAD" message means the default branch for "my_repo" is not set locally
## get rid of the message and set the default branch:
git remote set-head my_repo my_branch
## now "git branch -r" shows "remotes/my_repo/HEAD -> my_repo/my_branch", which of course is set locally (it doesn't set the default branch at the remote repo)
## a remote repo can also be queried to determine its "HEAD" and then "refs/remotes/my_repo/HEAD" can be set locally to the same branch:
git remote set-head my_repo -a

## go back to a specific commit:
git checkout 5fdac
## commit names are 40-byte SHA-1 hexadecimal strings, but it suffices to specify leading substring that is unique within the repo
## now you're in a detached "HEAD" state: "HEAD" refers to a specific commit
## normally "HEAD" refers to the branch, and, with new commits, always updates to the tip of the branch
## new commits in a detached "HEAD" state also update "HEAD" to refer to the last commit, but when no branch nor tag are created in this development line, they will be eventually deleted by Git, thus it's better to create a branch:
git checkout -b dev_branch # now "HEAD" refers to "dev_branch"
## you can go back to a specific branch from a detached "HEAD" state:
git checkout my_branch # now "HEAD" refers to "my_branch"
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
# debugging: looking for a commit which introduced a bug
--------------------------------------------------------------------------------
## a current revision (commit) is bad:
git bisect start
git bisect bad

## a "good_commit_name" revision is good:
git bisect good good_commit_name

## compile, check if OK, then use:
git bisect good # if OK
git bisect bad  # if not OK
git bisect skip # if impossible to verify (e.g. the revision doesn't compile)

## see the current commit:
git show HEAD

## continue until there are no more revisions to bisect, you'll be on the revision which first broke the code

## save the bisecting log:
git bisect log > bisect_log

## quit bisecting and go back to the commit checked out before "git bisect start":
git bisect reset
--------------------------------------------------------------------------------