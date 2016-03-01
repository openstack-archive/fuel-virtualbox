Mirantis VirtualBox scripts
===========================

Mirantis VirtualBox scripts are used to automate the installation of Fuel and
Mirantis OpenStack. When you install Mirantis OpenStack using the Mirantis
VirtualBox scripts, you do not need to configure the virtual machine network
and hardware settings. The script automatically provisions the virtual machines
with all required settings. However, you must place the latest Mirantis
OpenStack ISO image in the iso directory. You may also modify the number of
Fuel Slave nodes using the config.sh script.


Requirements
------------

- VirtualBox with VirtualBox Extension Pack
- procps
- expect
- openssh-client
- xxd
- Cygwin for Windows host PC
- Enable VT-x/AMD-V acceleration option on your hardware for 64-bits guests
- Enable Internet access


Run
---

In order to successfully run Mirantis OpenStack under VirtualBox, you need to:
- download the official release (.iso) and place it under 'iso/' directory
- run "./launch.sh" (or "./launch\_8GB.sh" or "./launch\_16GB.sh" according
to your system resources). It will automatically pick up the iso and spin up
master node and slave nodes

If you run this script under Cygwin, it will automatically add the path to the
VirtualBox directory to your PATH.

If there are any errors, the script will report them and abort.

If you want to change settings (number of OpenStack nodes, CPU, RAM, HDD),
please refer to "config.sh".

To shutdown VMs and clean environment just run "./clean.sh"

To deploy on a remote machine just set environment variable REMOTE_HOST with
ssh connection string. The variable REMOTE_PORT allows to specify custom port
for ssh.

```bash
 REMOTE_HOST=user@user.mos.mirantis.net ./launch_8GB.sh
# or
 REMOTE_HOST=user@user.mos.mirantis.net REMOTE_PORT=23 ./launch_8GB.sh
```


TODO
----

- add the ability to use Boot ROM during the remote deploy
- add the new (even smaller) Boot ROM with iPXE HTTP enabled
