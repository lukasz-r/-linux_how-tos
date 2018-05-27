\define{YUM}{__YUM__}
\define{DNF}{__DNF__}
\define{APT}{__APT__}
\define{Fedora}{[__Fedora__](https://getfedora.org/)}
\define{Ubuntu}{[__Ubuntu__](https://kubuntu.org/)}
\define{RedHat}{__Red Hat__}
\define{RedHatEL}{[\RedHat __Enterprise Linux__](https://www.redhat.com/)}
\define{Debian}{[__Debian__](https://www.debian.org/)}

# package management

## \DNF and \APT

### \getting_help

```bash
man dnf
man apt
man apt-get
```

### searching and installing packages

+ \DNF replaced \YUM in \Fedora, \RedHatEL still uses \YUM

+ \DNF and \YUM are based on __RPM__ (\RedHat Package Manager)

+ \APT is based on __dpkg__ (package manager for \Debian) and is used by \Ubuntu

+ list files installed by a package:

	```bash
	rpm -ql gnuplot
	dpkg -L gnuplot
	```

+ list files provided by a package regardless of whether it's installed or not:

	```bash
	dnf repoquery -l gnuplot
	apt-file list gnuplot
	```

+ list packages providing a command:

	```bash
	dnf provides autoconf
	apt-file search autoreconf
	```

+ install an __Open MPI__ package and load a corresponding module (\Fedora only):

	```bash
	sudo dnf install environment-modules
	sudo dnf install openmpi{,-devel}
	module load mpi/openmpi-x86_64
	```

+ enable \RedHat __Developer Toolset__ in \RedHatEL:

	+ follow the [instructions](https://access.redhat.com/documentation/en-us/red_hat_developer_toolset/7/html/user_guide/chap-red_hat_developer_toolset#sect-Red_Hat_Developer_Toolset-Subscribe) to install the developer tools (below I list the commands I used on a cluster):

		```bash
		sudo -i
		subscription-manager list --available
		subscription-manager attach --pool=<from the output of the above command>
		subscription-manager list --consumed
		subscription-manager repos --list | grep -i optional
		subscription-manager repos --enable rhel-6-server-optional-rpms
		subscription-manager repos --list | grep -i rhscl
		subscription-manager repos --enable rhel-server-rhscl-6-rpms
		wget https://www.softwarecollections.org/en/scls/praiskup/autotools/epel-6-x86_64/download/praiskup-autotools-epel-6-x86_64.noarch.rpm
		rpm -i praiskup-autotools-epel-6-x86_64.noarch.rpm
		yum install devtoolset-7 rh-git29 autotools-latest*
		```

	+ enable the tools for all users in e.g. `/etc/profile.d/scl.sh`:

		```bash
		# Software Collection environment
		source scl_source enable devtoolset-7 rh-git29 autotools-latest
		unset arg
		alias sudo=/usr/bin/sudo
		```
