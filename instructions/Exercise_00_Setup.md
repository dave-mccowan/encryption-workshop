## Setup - Let's Get Started!
Copy this ssh key file and save it in a file called `barbican_workshop.pem`:

    -----BEGIN RSA PRIVATE KEY-----
    MIIEogIBAAKCAQEAroUtvCfVfhRFS3nWDWsQCptAsSBzKSal0dG3hL+wN6JkrfzI
    rlGMnbSmDJevazb2hx1TEBXeU4G3ggsxfTOATGkdo3AOmGPS2Q346DK71zMzl6N9
    FsvagffLt4YY9YQ1+wEQZIlRNEMaHLozw0GZt5rwZTXBC6UnpmtjKJj9fK9XN1KP
    JMmTFtL9h9+7ORaha9tOhtFPGnm6N1vIme8L7kEvbxTrWlgjQYEnpsx0z3FcQDIz
    Hw2AyFiEeGjNdB2fxhwjJPql+O/p1Iqd4eP9qdtFgfyQy7zU8ju52U1aXFZgEZkb
    AO4/dyoX/O10bRpLHsTqHlZtmKj8m2HBmiZxtwIDAQABAoIBAHzqTIMZzAEzhynv
    6huun0vINnTR8jvpMtVNE9uLzRj1PrUec5H6Qvj6vcPTqrbGH400myivTnRdK7mE
    Q4cHHvUSZCmA4qGHCftcueWRssvlFS+b0MRJY3yVnhYdgK3zVSP1bgNYGmya/wzC
    5pwCz4ERALKg2C16qDfBM7dyUjY0p/MJ2Yav6jQ363wLCS/4JsKxvI4MO+CyO9et
    Ah5ImYwiHf74STGmRd8dWvgEnpOFQj1XbcB06p9DyNBaNx8C6dp+4e/fJxCGS+UB
    NJy4Gc5gTlZAOKRbY0FFvB1bhXetFfmx0h9cvkdHHU6redJJlFrM9d/nhFiOPSW+
    nLiJ8kkCgYEA3k4hZjzioktR4kHfcAEye3+127DbGNJDFRzQbOHuOGQzf8SjN/KA
    t00eKaFrQ8fH/hII6Uq2JTtYgrv1IqSEG+kT7DjQhpsxUh3NjSUM2qVs5kx6ZTgO
    lddYNUDAF1nWp57fUgRidRrcpVZHA4UeGjlh8VasKVWtd80uH580BiUCgYEAyPjm
    QntNq7srcv7YVWsKlJfos4BbyPzUg0/m5VzyzqgIW+1nk5QdWB1uLImiy/3HeNpJ
    6BgNfdrXgHBzx3z686k0cFGuoMBbd9G8Ud8wzzuriiwBD2tLwQDaBoTldZfU3OeU
    hIc3+8hNRSBxjm/1eZSrma4y6DNnaaZQpws7y6sCgYAlTktAkvsdbTJim9dZPnow
    S3BDW9yIv9BOHLXFb+zAPeB+kospemKrYB+tsM8FYuNm+bPRIp6KhPkHh29Nzvn0
    jRqwy6AC1sxiEWpLQ2pyzswFodPwZIXeE3NUDHev832YR4sGgoHbURSyElZ8erxg
    fjy3eWoOzbf8oMwatmbOmQKBgHUQvxfUuU6ibVHD7wH6oyQhRLRivZRa6fM/dNEA
    DpOgP5ZEuMO3UEyGgCnDVqgawLm99bUTZbB87HDtkBOQ0qFiW6BdhCoxQlaOPnM2
    XjkomeiXb1qq9mqLc3S+ruaLtbujzdhQ56Rrbc8pcdw1jTjwB/EyDodBgiiBb5OO
    MJuXAoGATEGeXk9GyqS4zFyHDdgbU0V1WOflloWgVN1X8XLvk+NH8xWs/JoP0aNF
    ttBVno6BHWxLEva5Vi2RTyzfg5AZgxgqQ85K0JaOOiH2H/R28AaNwTK2WGi+4LMk
    PHSvI8dVlOn6APoKd5uybgNKLAfEuncBeoqcuVGewevmbtID6e0=
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
