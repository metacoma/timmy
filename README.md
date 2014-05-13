Timmy
==============
Script must be run on fuel node

--------------
Example usage:
    sh timmy.sh [path to ssh key, by default /root/.ssh/id_rsa]

--------------
Scripts dir:

    scripts/compute     - place for scripts to be run on compute nodes

    scripts/controller  - for controller nodes

--------------

Special environemnt variables:

    **COMPUTE**         ips of all compute nodes

    **CONTROLLER**      ips of all controller nodes

    **FUEL_IP**         fuel ip addr

    **TIMMY_SOCKET**    ssh socket for file copy

