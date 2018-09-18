## Exercise 2 - Symmetric Encryption Keys
Store and retrieve an AES-256 Symmetric Encryption key.

For the (work in progress) Swift encryption features, users configure Swift to retrieve a master symmetric key, given the key’s UUID.  The user can upload an existing key themselves, which is especially useful if they’ve already been using a local key and would like to upgrade to using a centralized key manager.  In this exercise, you will follow the commands to store a symmetric key.

First, create a file containing a new random AES-256 encryption key:

    # openssl rand 32 > aes_key

Store the file as a new secret:

    # SECRET_REF=$(openstack secret store \
      --secret-type 'symmetric' \
      --name 'AES-256 Encryption Key' \
      --file aes_key \
      -c "Secret href" -f value)

You can retrieve the metadata:

    # openstack secret get $SECRET_REF

Or download the key to a file using the secret get command. (The key will be written to the file “retrieved_key”.

    # openstack secret get \
      --file retrieved_key \
      --payload_content_type application/octet-stream \
      $SECRET_REF

You can verify the retrieved key is identical to the original using the diff command:

    # diff aes_key retrieved_key


[Back](Exercise_01_Passphrases.md) [Up](../README.md) [Next](Exercise_03_Encrypted_Volumes.md)
