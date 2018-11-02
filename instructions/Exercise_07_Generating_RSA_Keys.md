## Exercise 7 - Generating RSA Keys
Request and retrieve an RSA private key using an order.

For the Glance image signing and verification feature, the first step is to create an RSA key pair.  Then, the user should request a CA to create a certificate tied to the key pair.  Before the user uploads the image, they sign the image using the private key.  The user uploads the certificate to Barbican and adds the certificate UUID and the image signature to the image metadata.  When the image is uploaded, Glance will retrieve the certificate and use it to verify the signature of the image.  Nova can also be configured to verify the signature again before booting the image.

This exercise shows an example of creating an RSA key pair, and exercise 6 shows an example of uploading a certificate.

Submit an order for a 4096-bit RSA key pair.

    # ORDER_REF=$(openstack secret order create asymmetric \
          --algorithm rsa --bit-length 4096 \
          -c "Order href" -f value)

Once the order’s status changes to ACTIVE the order metadata will include a "Container href" for the newly created RSA Secret Container

    # RSA_CONTAINER_REF=$(openstack secret order get $ORDER_REF \
           -c "Container href" -f value)

Retrieve the public key and save it to a file:

    # PUBLIC_KEY_REF=$(openstack secret container get \
          $RSA_CONTAINER_REF -c "Public Key" -f value)
    # openstack secret get --file generated_rsa.pub $PUBLIC_KEY_REF
    # cat generated_rsa.pub

Retrieve the private key and save it to a file:

    # PRIVATE_KEY_REF=$(openstack secret container get \
          $RSA_CONTAINER_REF -c "Private Key" -f value)
    # openstack secret get --file generated_rsa $PRIVATE_KEY_REF

Verify the contents of the file.

    # cat generated_rsa


[Back](Exercise_06_Generating_Symmetric_Encryption_Keys.md) [Up](../README.md) [Next](Exercise_08_X509_Certifcates.md)
