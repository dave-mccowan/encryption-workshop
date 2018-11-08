## Exercise 2 - Symmetric Encryption Keys
Store and retrieve an AES-256 Symmetric Encryption key.

For the (work in progress) Swift encryption features, users configure Swift to retrieve a master symmetric key, given the key’s UUID.  The user can upload an existing key themselves, which is especially useful if they’ve already been using a local key and would like to upgrade to using a centralized key manager.  In this exercise, you will follow the commands to store a symmetric key.

First, create a file containing a new random AES-256 encryption key:

    # openssl rand 32 > aes_key
    # hexdump -C aes_key 
    00000000  a2 0d 98 e5 f5 8d ac fb  3a d6 f8 71 d0 f6 ef 22  |........:..q..."|
    00000010  74 11 e5 d9 90 94 76 9e  72 30 b6 48 ca af 19 e1  |t.....v.r0.H....|
    00000020

Store the file as a new secret:

    # SECRET_REF=$(openstack secret store \
          --secret-type 'symmetric' \
          --name 'AES-256 Encryption Key' \
          --file aes_key \
          -c "Secret href" -f value)

You can retrieve the metadata:

    # openstack secret get $SECRET_REF
    +---------------+------------------------------------------------------------------------+
    | Field         | Value                                                                  |
    +---------------+------------------------------------------------------------------------+
    | Secret href   | https://127.0.0.1:9311/v1/secrets/103aa804-8aa6-4abe-ac35-7848b9ae97df |
    | Name          | AES-256 Encryption Key                                                 |
    | Created       | 2018-11-08T10:42:37+00:00                                              |
    | Status        | ACTIVE                                                                 |
    | Content types | {u'default': u'application/octet-stream'}                              |
    | Algorithm     | aes                                                                    |
    | Bit length    | 256                                                                    |
    | Secret type   | symmetric                                                              |
    | Mode          | cbc                                                                    |
    | Expiration    | None                                                                   |
    +---------------+------------------------------------------------------------------------+

Or download the key to a file using the secret get command. (The key will be written to the file “retrieved_key”.

    # openstack secret get \
          --file retrieved_key \
          --payload_content_type application/octet-stream \
          $SECRET_REF
    # hexdump -C retrieved_key
    00000000  a2 0d 98 e5 f5 8d ac fb  3a d6 f8 71 d0 f6 ef 22  |........:..q..."|
    00000010  74 11 e5 d9 90 94 76 9e  72 30 b6 48 ca af 19 e1  |t.....v.r0.H....|
    00000020

You can verify the retrieved key is identical to the original using the diff command:

    # diff aes_key retrieved_key


[Back](Exercise_01_Passphrases.md) [Up](../README.md) [Next](Exercise_03_Generating_Symmetric_Encryption_Keys.md)
