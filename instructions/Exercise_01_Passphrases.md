## Exercise 1 - Passphrases
Store and retrieve a Passphrase using the openstack command line client.

Sahara is the OpenStack project for provisioning a data-intensive application cluster, such as Hadoop or Spark, on top of OpenStack.  Sahara can be configured to store cluster-specific passphrases in Barbican.  The exercise has you manually follow the steps what Sahara is doing on the backend on the user’s behalf.

Store a passphrase, the secret will be saved and metadata about the stored secret will be returned:

    # openstack secret store --secret-type passphrase \
          --name 'my passphrase' --payload 'Pa$$phrasE'
    +---------------+------------------------------------------------------+
    | Field         | Value                                                |
    +---------------+------------------------------------------------------+
    | Secret href   | https://127.0.0.1:9311/v1/secrets/4866a7f2-ab6a-4..  |
    | Name          | my passphrase                                        |
    | Created       | 2018-11-08T10:16:26+00:00                            |
    | Status        | ACTIVE                                               |
    | Content types | {u'default': u'text/plain'}                          |
    | Algorithm     | aes                                                  |
    | Bit length    | 256                                                  |
    | Secret type   | passphrase                                           |
    | Mode          | cbc                                                  |
    | Expiration    | None                                                 |
    +---------------+------------------------------------------------------+

The "Secret href" can be used to retrieve the secret metadata.  Copy and paste the value from your output.

    # openstack secret get https://127.0.0.1:9311/v1/secrets/4866a7f2-ab6a-4..
    

Note that this only shows metadata.  To retrieve the actual secret value you use the --payload parameter.

    # openstack secret get --payload https://127.0.0.1:9311/v1/secrets/4866a7f2-ab6a-4..
    +---------+------------+
    | Field   | Value      |
    +---------+------------+
    | Payload | Pa$$phrasE |
    +---------+------------+

An easy way to store a passphrase in Barbican and save the "Secret href" value in an environment variable is by using the -f (--format) and -c (--column) flags.  Store a second secret using the command like this:

    # SECRET_REF=$(openstack secret store --secret-type passphrase \
          --name "another passphrase" --payload 'Be77erPa$$phrazE' \
          -c "Secret href" -f value)

Now you can retrieve the secret and secret metadata by using the stored "Secret href":

    # openstack secret get $SECRET_REF
    +---------------+------------------------------------------------------------------------+
    | Field         | Value                                                                  |
    +---------------+------------------------------------------------------------------------+
    | Secret href   | https://127.0.0.1:9311/v1/secrets/ebcfb632-a6f2-4fdd-9c28-6af377a95c98 |
    | Name          | another passphrase                                                     |
    | Created       | 2018-11-08T10:16:26+00:00                                              |
    | Status        | ACTIVE                                                                 |
    | Content types | {u'default': u'text/plain'}                                            |
    | Algorithm     | aes                                                                    |
    | Bit length    | 256                                                                    |
    | Secret type   | passphrase                                                             |
    | Mode          | cbc                                                                    |
    | Expiration    | None                                                                   |
    +---------------+------------------------------------------------------------------------+
    
    # openstack secret get --payload $SECRET_REF
    +---------+------------------+
    | Field   | Value            |
    +---------+------------------+
    | Payload | Be77erPa$$phrazE |
    +---------+------------------+

To use the passphrase in a script you can use the -f flag again:

    # PASSPHRASE=$(openstack secret get --payload $SECRET_REF -f value)
    # echo $PASSPHRASE
    Be77erPa$$phrazE

[Back](Exercise_00_Setup.md) [Up](../README.md) [Next](Exercise_02_Symmetric_Enrcryption_Keys.md)
