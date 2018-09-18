## Setup - Let's Get Started!
Login to your VM using the username and password provided by the instructors.

    $ ssh centos@<YOUR_VM_IP>

Your assigned VM already has an OpenStack deployment configured and running!   This includes the OpenStack services Keystone, Nova, Cinder, Glance, Neutron, Swift, Horizon, and Barbican.

In addition, a Dogtag instance is deployed, which Barbican is configured to use as a storage backend.  This Dogtag instance is configured to use an NSS database to store its keys.  In the last exercise, though, we will reconfigure Barbican to connect to a Dogtag instance that stores its keys in a Thales nShield Connect HSM.

After logging in to your assigned VM, become the root user and run some OpenStack CLI commands to verify that it is working.

    $ sudo su -
    # source openrc
    # openstack catalog list
    # openstack user list
    # openstack image list
    # openstack network list

[Up](../README.md) [Next](Exercise_01_Passphrases.md)
