# Timmy - System Configuraiton Discovery

Timmy is a tool for system administrators who operate OpenStack clouds based on
Fuel product by Mirantis. It allows operator to collect system configrations
from servers that are part of OpenStack cluster.

Timmy is designed fo be simple, platform independent and easily extensible. It
is written mostly in Bash. It could rely on Fuel to get initial configurations
and access credentials for cluster nodes.

## Installation

To start using Timmy, you just need to download this repository to the host that
has access to Fuel API and to nodes of the OpenStack cluster via SSH.

Once you've cloned the repo, run the following command to grab initial
configuraiton from Fuel:

    ./timmy.sh fuel-master.node.tld

It will create a file named `ssh_config` with addresses and credentials of nodes
of OpenStack cluster installed by Fuel.

You could also create the `ssh_config` file by hand.

## Usage

To collect the systems configuration data, you need to execute the following
command:

    ./collect.sh

This command will walk through the list of hosts defined in `ssh_config` file.
For every host, it will execute diagnostic commands according to the role of the
host (which is also defined in `ssh_config`). 

Output of commands with system configuration data will be stored to `output/`
directory in Timmy root folder.

## Extending

Timmy is intended to be easily extensible. If you as operator need additional
data about the system, you could add this information to collection.

You need to identify which command displays the information that you want to
collect. Then you need to add a file with this command to `scripts` directory.

Once you have the check file, you need to assign it to run on nodes of your
choice. To do so, just create directory named as a hostname of that node in
`hosts/` directory. Then create symbolic links to all scripts you want to run on
that node in corresponding directory.

For example, if you want to know disk space utilization on compute node
cmp1.domain.tld in the cluster, you add a file `df` to directory
`scripts/` with the following contents:

    #!/bin/sh
   
    df -h
   
Then create hosts entry for the node:

    mkdir hosts/cmp1.domain.tld
    ln -s scripts/df hosts/cmp1.domain.tld/df
    
Run `collect.sh` script and look for the disk usage information in file
`output/cmp1.domain.tld/df`.

## Available checks

Currently, following checks are implemented in Timmy

* `date` returns current date set on the machine
* `df` returns current disk usage in human-readable format
* `du` collects sizes of directories in the root directory (`/`)
* `ifconfig` collects configuration of network interfaces in standard ifconfig format
* `ip` returns current ARP neighbours table for the target node
* `ps` collects full list of processes running on the target machine
