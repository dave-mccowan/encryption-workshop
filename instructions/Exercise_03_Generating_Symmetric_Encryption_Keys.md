## Exercise 3 - Generating Symmetric Encryption Keys
Request and retrieve an AES-256 encryption key using an Order.

Volume encryption is one feature in OpenStack that uses symmetric encryption keys.  Cinder will request that Barbican creates a key when the volume is created and will associate the key ID with the volume metadata.  Then, Nova will retrieve the key and use it when attaching the volume to an instance.

Ephemeral disk encryption is another feature in OpenStack that uses symmetric encryption keys.  Nova will request key creation, will retrieve the key, and will use it when encrypting the LVM disks.

This exercise has you manually follow the steps of what Cinder and Nova are doing on the backend.

Submit an order for the AES Key:

    # ORDER_REF=$(openstack secret order create key \
          --name "Order for an AES key" \
          --algorithm aes --bit-length 256 \
          -c "Order href" -f value)

Orders may take some time to be fulfilled by the Barbican service.  You can check the status of your order by retrieving the order metadata:

    # openstack secret order get $ORDER_REF

Once the order’s status changes from PENDING to ACTIVE the order metadata will include a "Secret href" for the newly created secret.  You can retrieve the key just as in Example 2:

    # SECRET_REF=$(openstack secret order get $ORDER_REF \
           -c "Secret href" -f value)
    # openstack secret get --file ordered_key --payload_content_type 'application/octet-stream' $SECRET_REF


[Back](Exercise_02_Symmetric_Enrcryption_Keys.md) [Up](../README.md) [Next](Exercise_04_Encrypted_Volumes.md)
