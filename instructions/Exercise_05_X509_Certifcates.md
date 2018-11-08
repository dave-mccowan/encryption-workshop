## Exercise 5 - x.509 Certificates
Create a self-signed x.509 certificate and upload all parts.

LBaaS relies on Barbican to store the both the public and the private data necessary to decrypt TLS connections on the Load Balancer. The user uploads their private key, certificate, and any necessary intermediates into a Barbican certificate container. LBaaS understands the certificate container format, and only needs the container's ID when creating a TLS Terminating Load Balancer.

First, generate the new key that will be used to sign the certificate and convert it to PKCS#8 format:

    # openssl genrsa -out private.pem 4096
    Generating RSA private key, 4096 bit long modulus
    ...............................................................++
    ................................................................................++
    e is 65537 (0x10001)
    # openssl pkcs8 -topk8 -in private.pem -out private.pk8 -nocrypt

Store the PKCS#8 formatted private key.

    # PRIVATE_REF=$(openstack secret store \
          --secret-type private \
          --name 'Private Key for Certificate' \
          --file private.pk8 \
          -c "Secret href" -f value)

Next, use openssl to generate the self-signed certificate:

    # openssl req -new -x509 -days 365 -key private.pk8 -out cert.pem
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    Country Name (2 letter code) [XX]:.
    State or Province Name (full name) []:.
    Locality Name (eg, city) [Default City]:.
    Organization Name (eg, company) [Default Company Ltd]:.
    Organizational Unit Name (eg, section) []:.
    Common Name (eg, your name or your server's hostname) []:LBaaS
    Email Address []:.    

Upload the certificate:

    # CERT_REF=$(openstack secret store \
          --secret-type certificate \
          --name 'myhost.com certificate' \
          --file cert.pem \
          -c "Secret href" -f value)

Now create a certificate type container using the private key and certificate references:

    # CONTAINER_REF=$(openstack secret container create \
          --type certificate \
          --name 'Self-signed Certificate Bundle' \
          --secret "certificate=$CERT_REF" \
          --secret "private_key=$PRIVATE_REF" \
          -c "Container href" -f value)

To retrieve the certificate container use this command:

    # openstack secret container get $CONTAINER_REF
    +----------------+---------------------------------------------------------------------------+
    | Field          | Value                                                                     |
    +----------------+---------------------------------------------------------------------------+
    | Container href | https://127.0.0.1:9311/v1/containers/47188fdd-0bfa-4f10-b5ac-0da1cb2850d5 |
    | Name           | Self-signed Certificate Bundle                                            |
    | Created        | 2018-11-08 13:22:46+00:00                                                 |
    | Status         | ACTIVE                                                                    |
    | Type           | certificate                                                               |
    | Certificate    | https://127.0.0.1:9311/v1/secrets/6403a26c-1c74-4ae5-8da4-657f6b8c5fd9    |
    | Intermediates  | None                                                                      |
    | Private Key    | https://127.0.0.1:9311/v1/secrets/5c1f5228-481d-4ad2-ae2d-97d97c85b815    |
    | PK Passphrase  | None                                                                      |
    | Consumers      | None                                                                      |
    +----------------+---------------------------------------------------------------------------+

Once you retrieve the container you can retrieve the individual secrets as in Exercise 1.

[Back](Exercise_04_Encrypted_Volumes.md) [Up](../README.md) [Next](Exercise_06_Image_Verification.md)
