
\define{web_server}{__web server__}
# \web_server

\define{Apache}{__Apache__}
## \Apache

+ install \Apache and its documentation under \Fedora:

	```bash
	sudo dnf install httpd{,-manual}
	```

### \getting_help

+ basic control of \Apache:

	```bash
	man apachectl
	```

+ locally available documentation: <file:///usr/share/httpd/manual/index.html>

### firing up the \web_server

+ start \Apache (the `httpd` daemon):

	```bash
	sudo apachectl start
	```

+ restart \Apache not using the `apachectl` (e.g. on older systems):

	```bash
	sudo service httpd restart
	```

### configuration

+ most options are set in the `/etc/httpd/conf/httpd.conf` file:

	+ owner (usually `apache`) and group of the `httpd` daemon process

	+ `DocumentRoot "/var/www/html"`: top directory of the \web_server

	+ `DirectoryIndex index.html`: a filename to open if a directory with a trailing `/` in the \wget_URL_linked is requested

	+ options for specific directories go between the `<Directory "directory">` and `</Directory>` lines:

		+ `Options Indexes FollowSymLinks`: return a directory listing if none of the `DirectoryIndex` files is present and permissions allow for such listing, and resolve symbolic links

	+ `AllowOverride`: list of directives which can be changed vi the `.htaccess` files

+ per-directory options can be overwritten in per-directory `.htaccess` files:

	+ enable the directory listing, keeping other directory options unchanged:

		```bash
		Options +Indexes
		```
	+ disable the directory listing, keeping other directory options unchanged:

		```bash
		Options -Indexes
		```

+ per-user web directories can be accessed upon enabling the access, usually in the `/etc/httpd/conf.d/userdir.conf` file:

	+ `UserDir public_html`: `~user/public_html` is the directory containing user's files, and is accessed over web by appending the `~user` to the \wget_URL_linked

	+ the `~user/public_html` directory needs to be accessible for the owner of the `httpd` process:

		+ if user is not a member of the `httpd` process group, the minimum permissions are $0701$ for `~user` (usually they are $0711$), and 0705 for `~user/public_html` (usually they are $0755$) directories

	+ options for user web directories go between `<Directory "/home/*/public_html">` and `</Directory>` lines

+ check if the owner of the `httpd` process, say `apache`, can list the contents of a specific directory inside a user directory:

	```bash
	sudo -u apache ls -l How-Tos
	```

	if `apache` can't list a directory or a symbolic link to a directory, check if all directories of the pathname have at least $0701$ permissions
