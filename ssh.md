
--------------------------------------------------------------------------------
# SSH keys and ssh-agent
--------------------------------------------------------------------------------
## the key which is not in the standard location won't be seen by the remote Git repos unless it has been added to the ssh-agent
## ssh-agent normally isn't started on boot
## add the following lines to your "~/.bash_profile" to start the ssh-agent (or just the last line if the agent is started by a system):
------------------------------------------------------------
~/.bash_profile
------------------------------------------------------------
(...)
# ssh keys for remote Git repos
trap '[[ -n $SSH_AGENT_PID ]] && eval $(ssh-agent -k &> /dev/null)' 0
eval $(ssh-agent)
ssh-add ~/.ssh/id_rsa.git &> /dev/null
------------------------------------------------------------

## list the keys represented by the authentication agent:
ssh-add -l

## to rename a pair of keys, first remove it from the ssh-agent, and add the pair with a new name:
ssh-add -d ~/.ssh/id_rsa.molpro
mv -iv ~/.ssh/id_rsa.{molpro,git}
mv -iv ~/.ssh/id_rsa.{molpro,git}.pub
ssh-add ~/.ssh/id_rsa.git
## adjust "~/.bash_profile" and "~/.ssh/config" files accordingly
--------------------------------------------------------------------------------

================================================================================
SSH / VNC
================================================================================
# tunnel SSH connection to a machine C behind a gateway B from your local machine A:
# use port forwarding to forward port 22 (usually used for SSH) from machine C to, say, port 5022 on machine B and finally to port 5022 on your local machine A:
ssh userB@machineB -L 5022:machineC:22
# you can now connect to machine C from A:
ssh -p 5022 userC@localhost

# the above procedure can be used to tunnel VNC over another computer: suppose we want to connect via VNC to machine C from a local machine A over a gateway B:
# A -> B -> C,
# then the example procedure is as follows:
# start VNC server on machine C, say on port 5900 (this is usually the case for Mac OS X), then on machine A:
ssh userB@machineB -L 5900:machineC:5900
# and then on machine A:
vncviewer localhost:5900

# use SSH config file for connceting to machine C behind a gateway B from your local machine A:
-------------------------------------------------------
$HOME/.ssh/config
-------------------------------------------------------
Host ctunnel
User userB
HostName machineB
LocalForward 5022 machineC:22

Host ctunneled
User userC
HostName localhost
Port 5022
-------------------------------------------------------
# and then use the command (the tunnel will be automatically closed after logging out):
ssh -f ctunnel sleep 10s; ssh ctunneled

# start VNC server (desktop sharing) on Mac OS X via command line:
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -privs -all -allowAccessFor -allUsers -clientopts -setvnclegacy -vnclegacy yes -setvncpw -vncpw my_password -restart -agent -console -menu

# stop VNC server (desktop sharing) on Mac OS X via command line:
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -configure -access -off -agent -stop

# pipe to a remote server:
find -type f | ssh erwin "cat > file_list"
