## Setup - Let's Get Started!
Login to your VM using the username and password provided by the instructors.

    $ ssh centos@<YOUR_VM_IP>

Your assigned VM already has an OpenStack deployment configured and running!   This includes the OpenStack services Keystone, Nova, Cinder, Glance, Neutron, Swift, Horizon, and Barbican.

In addition, a Dogtag instance is deployed, which Barbican is configured to use as a storage backend.  This Dogtag instance is configured to use an NSS database to store its keys.  In the last exercise, though, we will reconfigure Barbican to connect to a Dogtag instance that stores its keys in a Thales nShield Connect HSM.

After logging in to your assigned VM, become the root user and run some OpenStack CLI commands to verify that it is working.

    $ sudo su -
    $ source openrc

### catalog

    $ openstack catalog list
    +-----------+--------------+----------------------------------------------------------------------------+
    | Name      | Type         | Endpoints                                                                  |
    +-----------+--------------+----------------------------------------------------------------------------+
    | neutron   | network      | RegionOne                                                                  |
    |           |              |   admin: https://127.0.0.1:9696                                            |
    |           |              | RegionOne                                                                  |
    |           |              |   internal: https://127.0.0.1:9696                                         |
    |           |              | RegionOne                                                                  |
    |           |              |   public: https://127.0.0.1:9696                                           |
    |           |              |                                                                            |
    | cinderv2  | volumev2     | RegionOne                                                                  |
    |           |              |   internal: https://127.0.0.1:8776/v2/38ca2cc64f204a6fb0ee1e85398c6380     |
    |           |              | RegionOne                                                                  |
    |           |              |   admin: https://127.0.0.1:8776/v2/38ca2cc64f204a6fb0ee1e85398c6380        |
    |           |              | RegionOne                                                                  |
    |           |              |   public: https://127.0.0.1:8776/v2/38ca2cc64f204a6fb0ee1e85398c6380       |
    |           |              |                                                                            |
    | placement | placement    | RegionOne                                                                  |
    |           |              |   admin: https://127.0.0.1:8778/placement                                  |
    |           |              | RegionOne                                                                  |
    |           |              |   public: https://127.0.0.1:8778/placement                                 |
    |           |              | RegionOne                                                                  |
    |           |              |   internal: https://127.0.0.1:8778/placement                               |
    |           |              |                                                                            |
    | keystone  | identity     | RegionOne                                                                  |
    |           |              |   internal: https://127.0.0.1:5000                                         |
    |           |              | RegionOne                                                                  |
    |           |              |   public: https://127.0.0.1:5000                                           |
    |           |              | RegionOne                                                                  |
    |           |              |   admin: https://127.0.0.1:5000                                            |
    |           |              |                                                                            |
    | cinder    | volume       | RegionOne                                                                  |
    |           |              |   admin: https://127.0.0.1:8776/v1/38ca2cc64f204a6fb0ee1e85398c6380        |
    |           |              | RegionOne                                                                  |
    |           |              |   public: https://127.0.0.1:8776/v1/38ca2cc64f204a6fb0ee1e85398c6380       |
    |           |              | RegionOne                                                                  |
    |           |              |   internal: https://127.0.0.1:8776/v1/38ca2cc64f204a6fb0ee1e85398c6380     |
    |           |              |                                                                            |
    | glance    | image        | RegionOne                                                                  |
    |           |              |   internal: https://127.0.0.1:9292                                         |
    |           |              | RegionOne                                                                  |
    |           |              |   public: https://127.0.0.1:9292                                           |
    |           |              | RegionOne                                                                  |
    |           |              |   admin: https://127.0.0.1:9292                                            |
    |           |              |                                                                            |
    | nova      | compute      | RegionOne                                                                  |
    |           |              |   admin: https://127.0.0.1:8774/v2.1                                       |
    |           |              | RegionOne                                                                  |
    |           |              |   internal: https://127.0.0.1:8774/v2.1                                    |
    |           |              | RegionOne                                                                  |
    |           |              |   public: https://127.0.0.1:8774/v2.1                                      |
    |           |              |                                                                            |
    | swift     | object-store | RegionOne                                                                  |
    |           |              |   internal: http://127.0.0.1:8080/v1/AUTH_38ca2cc64f204a6fb0ee1e85398c6380 |
    |           |              | RegionOne                                                                  |
    |           |              |   public: http://127.0.0.1:8080/v1/AUTH_38ca2cc64f204a6fb0ee1e85398c6380   |
    |           |              | RegionOne                                                                  |
    |           |              |   admin: http://127.0.0.1:8080                                             |
    |           |              |                                                                            |
    | cinderv3  | volumev3     | RegionOne                                                                  |
    |           |              |   internal: https://127.0.0.1:8776/v3/38ca2cc64f204a6fb0ee1e85398c6380     |
    |           |              | RegionOne                                                                  |
    |           |              |   admin: https://127.0.0.1:8776/v3/38ca2cc64f204a6fb0ee1e85398c6380        |
    |           |              | RegionOne                                                                  |
    |           |              |   public: https://127.0.0.1:8776/v3/38ca2cc64f204a6fb0ee1e85398c6380       |
    |           |              |                                                                            |
    | swift_s3  | s3           | RegionOne                                                                  |
    |           |              |   public: http://127.0.0.1:8080                                            |
    |           |              | RegionOne                                                                  |
    |           |              |   internal: http://127.0.0.1:8080                                          |
    |           |              | RegionOne                                                                  |
    |           |              |   admin: http://127.0.0.1:8080                                             |
    |           |              |                                                                            |
    | barbican  | key-manager  | RegionOne                                                                  |
    |           |              |   admin: https://127.0.0.1:9311                                            |
    |           |              | RegionOne                                                                  |
    |           |              |   public: https://127.0.0.1:9311                                           |
    |           |              | RegionOne                                                                  |
    |           |              |   internal: https://127.0.0.1:9311                                         |
    |           |              |                                                                            |
    +-----------+--------------+----------------------------------------------------------------------------+

### users

    $ openstack user list
    +----------------------------------+-----------+
    | ID                               | Name      |
    +----------------------------------+-----------+
    | 0465c2975c1648388a4a8e67655a4542 | cinder    |
    | 3d56e4b166f44bb4868803a61b99081a | glance    |
    | 446a9e23becb4a3896162f9883b0e49a | nova      |
    | 63e50d154a0947cea3e10defb5f2a92e | neutron   |
    | 8210e579d4d54d73af1cad22e4479076 | barbican  |
    | d2f24e2e38314d3abc52d4732e14c794 | swift     |
    | daa55ce370d64976ba07c6fd3d2e2dc5 | placement |
    | e3b64775d08d4448a45fbf2a4bb8d0ae | admin     |
    +----------------------------------+-----------+

### images

    $ openstack image list
    +--------------------------------------+------------+--------+
    | ID                                   | Name       | Status |
    +--------------------------------------+------------+--------+
    | e578bac0-0b28-480e-afd9-5e7e95ce465f | cirros     | active |
    | 52a2dcfa-d660-4e1b-9219-abd6ffe8b3d8 | cirros_alt | active |
    +--------------------------------------+------------+--------+

### network

    $ openstack network list
    +--------------------------------------+----------+--------------------------------------+
    | ID                                   | Name     | Subnets                              |
    +--------------------------------------+----------+--------------------------------------+
    | 51fed13f-f112-4568-8c35-d041f89ffc71 | internal | 2934c9e1-4ea0-4387-8c1e-74633bc7d379 |
    | 93148f9b-9126-4c48-91c7-0943e9227852 | public   | cac815b1-f536-4607-aa84-76caacbcf15a |
    +--------------------------------------+----------+--------------------------------------+

[Up](../README.md) [Next](Exercise_01_Passphrases.md)
