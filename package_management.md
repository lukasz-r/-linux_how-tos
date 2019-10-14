\define{Fedora}{[__Fedora__](https://getfedora.org/)}
\define{Ubuntu}{[__Ubuntu__](https://kubuntu.org/)}
\define{RedHat}{__Red Hat__}
\define{RedHatEL}{[\RedHat __Enterprise Linux__](https://www.redhat.com/)}
\define{Debian}{[__Debian__](https://www.debian.org/)}

# \package_management

\package_management_anc automates package installation process steps, in particular the resolution of \package_management_dependency_anc_pl

## \package_management_DNF and \package_management_APT

### \getting_help

```bash
man dnf
man apt
man apt-get
```

### searching and installing packages

+ \package_management_DNF_anc replaced \package_management_YUM_anc in \Fedora, \RedHatEL still uses \package_management_YUM_lnk

+ \package_management_DNF_lnk and \package_management_YUM_lnk are based on \package_management_RPM_anc (\RedHat Package Manager)

+ \package_management_APT_anc is based on \package_management_dpkg_anc (package manager for \Debian) and is used by \Ubuntu

task                                                        | \package_management_RPM_lnk-based | \package_management_dpkg_lnk-based
------------------------------------------------------------|-----------------------------------|-----------------------------------
list \file_lnk_pl installed by a package | `rpm -ql gnuplot`{.bash} | `dpkg -L gnuplot`{.bash}
list files provided by a package regardless of whether it's installed or not | `dnf repoquery -l gnuplot`{.bash} | `apt-file list gnuplot`{.bash}
list packages providing a \file_lnk | `dnf provides autoconf`{.bash} | `apt-file search libmp3lame.so.0`{.bash}

: common \package_management_lnk tasks

+ install an __Open MPI__ package and load a corresponding \modulefile (\Fedora only):

	```bash
	sudo dnf install environment-modules
	sudo dnf install openmpi{,-devel}
	module add mpi/openmpi-x86_64
	```

	to load a \modulefile automatically by the shell, use:

	```bash
	module initadd mpi/openmpi-x86_64
	```

	if you get the `Cannot find a 'module load' command in any of the 'bash' startup files`, error, run:

	```bash
	echo "module add null" >> ~/.bash_profile
	module initadd mpi/openmpi-x86_64
	```

+ enable the \Red_Hat_Developer_Toolset_lnk in \RedHatEL:

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
