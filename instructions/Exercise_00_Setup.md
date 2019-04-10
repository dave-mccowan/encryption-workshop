## Setup - Let's Get Started!
Copy this ssh key file and save it in a file called `barbican_workshop.pem`:

    -----BEGIN RSA PRIVATE KEY-----
    MIIEowIBAAKCAQEAuTkydXL6Z3VG6nW7EGBSkkFnBusE70OlkzlsGqBk9z7sof0+
    jrkhfUVN4I+HIneW8ieC3It9jV1q+8AjawLbzvG/F1MXdgjbAn9BaxxPvXOfqWTM
    q9SXefcQL1Ic0IBcr6ALjX6RL/WmPfH0vo2/QF5pTnFwZjzZQN7ze1udM1w6zbji
    s+Sg2RadePoAE54Bz42qgMcGX7EyJpxoKkTE7H552hA60OrAHod+whI7PmysLEVr
    PoKMrzrB1T+CiUNl1mdFSJZPB9h6bdMq3AKsYub29vinTX3aNwAyHPx2ljmXKSOs
    nhY2vsU9xRviqYW9+FBKESJ85Lb/krEOOc336QIDAQABAoIBAHAQ7zqoimC2UGXj
    PX83CD59W7yPzbiGEVP2VjX1/aCqbbnE42ivElgc6nWH4Zc1DBsPVNnje99gOi5/
    ne5NGHkpQxj1qSg9S2VDYW1Q/938awmudzcvtUaR+TToVY7BW1LXXqYJggamdiLc
    ldwFH0Xu2YAgmoUBI+FgA6kLUR2VE7XMiF4bj9vBfZqvpNyHDU/b8xoph1F31FgK
    lY/wQKF6oIgU+qKe5kkHCxIeFnw3X2ojxYM4WsDyycOa8vTj/6P1Qs43MkRl8KQK
    O2zTk5CP9NNh8dDwZRAPbE3o0f56CPkszfKskCm1jWBwRXsZurd91H9echK6vGSA
    wmWJlJECgYEA6nvlEAS0MUGvVj1Cb6TuWRsVb/VMHEsr+b5xI3EB9PkOyrjeDX/1
    kYFosO9yr43J8u2UPlkQ2mqufgFJCN5PgJC2D3fAuDYq6kxI6HJR4Y+/uNnidwdY
    57pUxnD6qWAIqKjgfg0qX0zPmGZc6UPUcWFAO+0w8yn3UbFX93XiwfMCgYEAyjgn
    +Lucf92I12/mkWmgBfBmi6WB4KKCjHeRQ/v68EWxUUProd2WyXwbmeG/vsGdxIVA
    F2QM6m2Sx/UXW/8Lax8ui5vURNqp46Kee80l2l7Q9BQbjWetIjVC4UTUiBVkw+vW
    J+GA/JD9X5rUUZ5OLB7fA6XZM6yQ1sQA9Ne5+bMCgYASEJN4JXSgatgQQ83vffxi
    3wRKyNIhR+VOa06aFWW6Msnh8lYhIh+QIzEmmHv0bG8HiSgnmYMD4L4qtPykc0Qa
    uotcK7SsPHgX7uKbDdujDgkOO7MHyogd6iwH0cJt9BkWrVQGQgtmpitEKXa0/eXL
    ClwBgeeIhE4qfAgz52Ad4wKBgFEo7qn+qlYLVMOajsBn0yjvDkkX2SOONbUou+28
    MT/DyOHjz6t8Yutk2zMMjseBr89S56E7r49bAOEt9f0fRLbuoeC4Xx5vYGYTO2ZW
    tM2K5nQ/qbs8FBm5pKkC1gX0CCg1/BKvh/RWQMrhOjuzvI4qqbkuFBmQNeVsbzHV
    bzfPAoGBAJoDvrS450GgyUq9Xjqej0ebMPYRKw/hRaiwtOF5c+LOLT/MeskyedQU
    Yrlmm28qihtKe+RvWykguZmxS3TdmZKXmxBOaDt8EdCQQqO5lfuJ8h9rIdH1BrFL
    yFZMg/oxL8raSA5Bepq/R9cyrkkIYXwTygzXWSe3a3zJqewK3lv2
    -----END RSA PRIVATE KEY-----

Change the file permissions to read/write for your user only:

    $ chmod 0600 barbican_workshop.pem

Connect to your VM using this ssh key:

    $ ssh -i barbican_workshop.pem centos@<YOUR_VM_IP>

Your assigned VM already has an OpenStack deployment configured and running!   This includes the OpenStack services Keystone, Nova, Cinder, Glance, Neutron, Swift, Horizon, and Barbican.

In addition, a Dogtag instance is deployed, which Barbican is configured to use as a storage backend.  This Dogtag instance is configured to use an NSS database to store its keys.

After logging in to your assigned VM, become the root user and run some OpenStack CLI commands to verify that it is working.

    $ sudo su -
    # source openrc

### catalog

    # openstack catalog list
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

    # openstack user list
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

    # openstack image list
    +--------------------------------------+------------+--------+
    | ID                                   | Name       | Status |
    +--------------------------------------+------------+--------+
    | e578bac0-0b28-480e-afd9-5e7e95ce465f | cirros     | active |
    | 52a2dcfa-d660-4e1b-9219-abd6ffe8b3d8 | cirros_alt | active |
    +--------------------------------------+------------+--------+

### network

    # openstack network list
    +--------------------------------------+----------+--------------------------------------+
    | ID                                   | Name     | Subnets                              |
    +--------------------------------------+----------+--------------------------------------+
    | 51fed13f-f112-4568-8c35-d041f89ffc71 | internal | 2934c9e1-4ea0-4387-8c1e-74633bc7d379 |
    | 93148f9b-9126-4c48-91c7-0943e9227852 | public   | cac815b1-f536-4607-aa84-76caacbcf15a |
    +--------------------------------------+----------+--------------------------------------+

[Up](../README.md) [Next](Exercise_01_Passphrases.md)
