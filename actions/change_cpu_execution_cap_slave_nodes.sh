#!/bin/bash

#    Copyright 2013 Mirantis, Inc.
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

local local_cpu_execution_cap

local_cpu_execution_cap=${1:-$cpu_execution_cap}

# Create and start slave nodes
for idx in $(eval echo {1..$cluster_size}); do
  name="${vm_name_prefix}slave-${idx}"
  #change cpuexecutioncap setting
  echo "change CPU execution cap setting to $local_cpu_execution_cap on node $name..."
  change_cpuexecutioncap $name $local_cpu_execution_cap
done

# Report success
echo
echo "Slave nodes have been created. They will boot over PXE and get discovered by the master node."
echo "To access master node, please point your browser to:"
echo "    http://${vm_master_ip}:8000/"
echo "The default username and password is admin:admin"
