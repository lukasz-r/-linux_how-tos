
\define{SELinux}{__SELinux__}
# \SELinux

+ get the current mode of \SELinux:

	```bash
	getenforce
	```

+ get the current status of \SELinux:

	```bash
	sestatus
	```

+ show all SELinux boolean values:

	```bash
	sestatus -b
	```

	or:

	```bash
	getsebool -a
	```

+ set a SELinux boolean value to true and make it persistent across reboots:

	```bash
	sudo setsebool -P httpd_enable_homedirs true
	```
