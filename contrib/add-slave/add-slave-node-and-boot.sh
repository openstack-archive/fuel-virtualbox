#!/bin/bash

#    Copyright 2016 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

#
# This script creates slaves node for the product, launches its installation,
# and waits for its completion
#

# Include the handy functions to operate VMs
source ./config.sh
source ./functions/vm.sh
source ./functions/network.sh
source ./functions/shell.sh

# Add VirtualBox directory to PATH
add_virtualbox_path

# Get variables "host_nic_name" for the slave node
get_fuel_name_ifaces
echo

# Get the number of the last slave node
last_idx=$(execute VBoxManage list vms | grep "${vm_name_prefix}slave-" | sed -e"s/${vm_name_prefix}slave-//g" | cut -d'"' -f2 | sort -nu | tail -1)
if [ -z "${last_idx}" ]; then
  echo "ERROR: Couldn't parse VMs list or ${vm_name_prefix}slave nodes don't exist."
  echo
  exit 1
fi

# Number for the new slave node
idx="$(($last_idx + 1))"

# Name for the new slave node
name="${vm_name_prefix}slave-${idx}"

# Ammount of RAM for the new slave node
vm_ram=$(execute VBoxManage showvminfo "${vm_name_prefix}slave-${last_idx}" --machinereadable 2>/dev/null | grep '^memory=' | cut -d'=' -f2)
[ -z $vm_ram ] && vm_ram=$vm_slave_memory_default

# Number of CPUs for the new slave node
vm_cpu=$(execute VBoxManage showvminfo "${vm_name_prefix}slave-${last_idx}" --machinereadable 2>/dev/null | grep '^cpus=' | cut -d'=' -f2)
[ -z $vm_cpu ] && vm_cpu=$vm_slave_cpu_default

# Create and start slave node
echo "Creating slave #${idx}, with name '${name}', and the same configuration as slave #${last_idx}:"
echo " - memory=${vm_ram}, cpus=${vm_cpu}"
echo
create_vm $name "${host_nic_name[0]}" $vm_cpu $vm_ram $vm_slave_first_disk_mb

# Add additional NICs to VM
if [ ${#host_nic_name[*]} -gt 1 ]; then
  for nic in $(eval echo {1..$((${#host_nic_name[*]}-1))}); do
    add_hostonly_adapter_to_vm $name $((nic+1)) "${host_nic_name[${nic}]}"
  done
fi

# Add additional disks to VM
echo
add_disk_to_vm $name 1 $vm_slave_second_disk_mb
add_disk_to_vm $name 2 $vm_slave_third_disk_mb

# Add COM1 port for serial console
execute VBoxManage modifyvm $name --uart1 0x03f8 4 --uartmode1 disconnected

# Add NIC1 MAC to description
mac=$(execute VBoxManage showvminfo $name --machinereadable | grep '^macaddress1=' | cut -d'"' -f2)
if [ -n "${mac}" ]; then
  mac_address=$(echo $mac | sed 's/.\{2\}/&:/g;s/:$//' | tr '[:upper:]' '[:lower:]')
  execute VBoxManage modifyvm $name --description "${mac}"
fi

# Add RDP connection
if [ ${headless} -eq 1 ]; then
  enable_vrde $name $((${RDPport} + idx))
fi

echo
enable_network_boot_for_vm $name
echo "Preparing to start the node..."
# The delay required for downloading tftp boot image
sleep 10

start_vm $name

echo
echo "Slave node have been added and started. They will boot over PXE and get discovered by the master node."
echo "Please wait while the slave node appears in the list of the available nodes, this can take some time."
echo "You can use the command 'fuel node' on the Fuel master node to check the list of available nodes."

if [ -n "${mac}" ]; then
  echo "The MAC address of the new node is: '${mac_address}'."
fi
echo
