## Exercise 6 - Image Verification Using Glance
Image verification allows Glance to enforce that only images signed by a trusted administrator with access to the private key can be uploaded to Glance.

In this exercise you will:
- Create a key to sign images and store it in Barbican
- Create two “images”, one with a valid signature and one without
- Using the Glance API, attempt to upload the two images, while providing the UUID for the signing key.
- Verify that only the image with the valid signature was uploaded

The following set of steps would be done by a trusted administrator.  These steps will create two images.  You will sign one image, but not the other.

First, create a key pair to be used for signing and store it in Barbican.  Enter each of these commands to a certificate.  On the fourth command (openssl x509 …) you will be prompted to enter information to be stored in the certificate.  You can take the default (hit return) for each one, or provide a different answer.  The specific answers will not affect this exercise.

    # openssl genrsa -out private_key.pem 1024
    Generating RSA private key, 1024 bit long modulus
    ............++++++
    .................++++++
    e is 65537 (0x10001)
    # openssl rsa -pubout -in private_key.pem -out public_key.pem
    writing RSA key
    # openssl req -new -key private_key.pem -out cert_request.csr
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
    Common Name (eg, your name or your server's hostname) []:Exercise 6
    Email Address []:.

    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:.
    An optional company name []:.
    # openssl x509 -req -days 14 -in cert_request.csr -signkey private_key.pem -out new_cert.crt
    Signature ok
    subject=/CN=Exercise 6
    Getting Private key
    # CERT_REF=$(openstack secret store --name signing-cert \
      --algorithm RSA --secret-type certificate \
      --payload-content-type "application/octet-stream" \
      --payload-content-encoding base64 \
      --payload "$(base64 new_cert.crt)" -c "Secret href" -f value)
    # CERT_UUID=$(echo $CERT_REF | awk -F '/' '{print $NF}')
    # openstack secret list
    +------------------------------------------------------------------------+-----------------------------+---------------------------+--------+-------------------------------------------+-----------+------------+-------------+------+------------+
    | Secret href                                                            | Name                        | Created                   | Status | Content types                             | Algorithm | Bit length | Secret type | Mode | Expiration |
    +------------------------------------------------------------------------+-----------------------------+---------------------------+--------+-------------------------------------------+-----------+------------+-------------+------+------------+
    | https://127.0.0.1:9311/v1/secrets/103aa804-8aa6-4abe-ac35-7848b9ae97df | AES-256 Encryption Key      | 2018-11-08T10:42:37+00:00 | ACTIVE | {u'default': u'application/octet-stream'} | aes       |        256 | symmetric   | cbc  | None       |
    | https://127.0.0.1:9311/v1/secrets/4920ac11-5318-417e-8a8c-2c20322fa5ad | Order for an AES key        | 2018-11-08T12:14:42+00:00 | ACTIVE | {u'default': u'application/octet-stream'} | aes       |        256 | symmetric   | cbc  | None       |
    | https://127.0.0.1:9311/v1/secrets/5c1f5228-481d-4ad2-ae2d-97d97c85b815 | Private Key for Certificate | 2018-11-08T13:19:15+00:00 | ACTIVE | {u'default': u'application/octet-stream'} | aes       |        256 | private     | cbc  | None       |
    | https://127.0.0.1:9311/v1/secrets/6403a26c-1c74-4ae5-8da4-657f6b8c5fd9 | myhost.com certificate      | 2018-11-08T13:22:36+00:00 | ACTIVE | {u'default': u'application/octet-stream'} | aes       |        256 | certificate | cbc  | None       |
    | https://127.0.0.1:9311/v1/secrets/9a29b190-f6de-471d-b130-f67fc0eee8d1 | my passphrase               | 2018-11-08T10:14:22+00:00 | ACTIVE | {u'default': u'text/plain'}               | aes       |        256 | passphrase  | cbc  | None       |
    | https://127.0.0.1:9311/v1/secrets/a38d8c33-fa58-4c13-a3df-298f8e71e9af | signing-cert                | 2018-11-08T13:34:01+00:00 | ACTIVE | {u'default': u'application/octet-stream'} | RSA       |        256 | certificate | cbc  | None       |
    | https://127.0.0.1:9311/v1/secrets/ebcfb632-a6f2-4fdd-9c28-6af377a95c98 | another passphrase          | 2018-11-08T10:16:26+00:00 | ACTIVE | {u'default': u'text/plain'}               | aes       |        256 | passphrase  | cbc  | None       |
    | https://127.0.0.1:9311/v1/secrets/feb71626-f9da-4885-980b-945ea7ac7510 | None                        | 2018-11-08T12:51:26+00:00 | ACTIVE | {u'default': u'application/octet-stream'} | aes       |        256 | symmetric   | None | None       |
    +------------------------------------------------------------------------+-----------------------------+---------------------------+--------+-------------------------------------------+-----------+------------+-------------+------+------------+

Next, create two images.  Normally, these would create software to boot.  Sign one of them.

    # echo This is a trusted image > signed_image
    # echo This image is not trusted. > unsigned_image
    # openssl dgst -sha256 -sign private_key.pem \
        -sigopt rsa_padding_mode:pss \
        -out myimage.signature signed_image
    # base64 -w 0 myimage.signature > myimage.signature.b64
    # image_signature=$(cat myimage.signature.b64)

Next, upload the signed image.

    # glance image-create --name mySignedImage \
          --container-format bare --disk-format qcow2 \
          --property img_signature="$image_signature" \
          --property img_signature_certificate_uuid="$CERT_UUID" \
          --property img_signature_hash_method='SHA-256' \
          --property img_signature_key_type='RSA-PSS' < signed_image
    +--------------------------------+----------------------------------------------------------------------------------+
    | Property                       | Value                                                                            |
    +--------------------------------+----------------------------------------------------------------------------------+
    | checksum                       | f5eb20ccd2d61605a18b53cbcc21d5cf                                                 |
    | container_format               | bare                                                                             |
    | created_at                     | 2018-11-08T13:39:13Z                                                             |
    | disk_format                    | qcow2                                                                            |
    | id                             | 648e93f1-d926-4c73-aa0a-bb8e1fcd9710                                             |
    | img_signature                  | pIkpUi/yHAVSeVz8+5sx+rN9/rIJAtSfs6IWNdF2qTHyaWW81CDVOS2up+ucAvDNvnpVXILj6xln+mpZ |
    |                                | u/RTJXue+3E2UAG6xLS+2cfm2RdIq7bvJJPJode5gGEriIRDLQthkaI7uXxa41mk47TRlpSfjdlGV0cY |
    |                                | 9v6tfTTK6Pc=                                                                     |
    | img_signature_certificate_uuid | a38d8c33-fa58-4c13-a3df-298f8e71e9af                                             |
    | img_signature_hash_method      | SHA-256                                                                          |
    | img_signature_key_type         | RSA-PSS                                                                          |
    | min_disk                       | 0                                                                                |
    | min_ram                        | 0                                                                                |
    | name                           | mySignedImage                                                                    |
    | os_hash_algo                   | sha512                                                                           |
    | os_hash_value                  | 79f3d6dc429b64b9d5b9d59dc809087246129ce0ef6b4220ee99c22956fabecc23a92952a0b11136 |
    |                                | 0ca9bed46f45387d9f0e82f41a4023c44fbe4b1794b8168b                                 |
    | os_hidden                      | False                                                                            |
    | owner                          | 38ca2cc64f204a6fb0ee1e85398c6380                                                 |
    | protected                      | False                                                                            |
    | size                           | 24                                                                               |
    | status                         | active                                                                           |
    | tags                           | []                                                                               |
    | updated_at                     | 2018-11-08T13:39:17Z                                                             |
    | virtual_size                   | Not available                                                                    |
    | visibility                     | shared                                                                           |
    +--------------------------------+----------------------------------------------------------------------------------+

Now, attempt to upload the unsigned_image, using the signed image’s signature.  This will fail, since Glance will validate the signature before accepting the image.

    # glance image-create --name myUnsignedImage \
          --container-format bare --disk-format qcow2 \
          --property img_signature="$image_signature" \
          --property img_signature_certificate_uuid="$CERT_UUID" \
          --property img_signature_hash_method='SHA-256' \
          --property img_signature_key_type='RSA-PSS' < unsigned_image
    +--------------------------------+----------------------------------------------------------------------------------+
    | Property                       | Value                                                                            |
    +--------------------------------+----------------------------------------------------------------------------------+
    | checksum                       | None                                                                             |
    | container_format               | bare                                                                             |
    | created_at                     | 2018-11-08T13:39:34Z                                                             |
    | disk_format                    | qcow2                                                                            |
    | id                             | 8f927b0c-0fb4-4219-bb2a-775c09baae5d                                             |
    | img_signature                  | pIkpUi/yHAVSeVz8+5sx+rN9/rIJAtSfs6IWNdF2qTHyaWW81CDVOS2up+ucAvDNvnpVXILj6xln+mpZ |
    |                                | u/RTJXue+3E2UAG6xLS+2cfm2RdIq7bvJJPJode5gGEriIRDLQthkaI7uXxa41mk47TRlpSfjdlGV0cY |
    |                                | 9v6tfTTK6Pc=                                                                     |
    | img_signature_certificate_uuid | a38d8c33-fa58-4c13-a3df-298f8e71e9af                                             |
    | img_signature_hash_method      | SHA-256                                                                          |
    | img_signature_key_type         | RSA-PSS                                                                          |
    | min_disk                       | 0                                                                                |
    | min_ram                        | 0                                                                                |
    | name                           | myUnsignedImage                                                                  |
    | os_hash_algo                   | None                                                                             |
    | os_hash_value                  | None                                                                             |
    | os_hidden                      | False                                                                            |
    | owner                          | 38ca2cc64f204a6fb0ee1e85398c6380                                                 |
    | protected                      | False                                                                            |
    | size                           | None                                                                             |
    | status                         | queued                                                                           |
    | tags                           | []                                                                               |
    | updated_at                     | 2018-11-08T13:39:34Z                                                             |
    | virtual_size                   | Not available                                                                    |
    | visibility                     | shared                                                                           |
    +--------------------------------+----------------------------------------------------------------------------------+
    400 Bad Request: Signature verification failed for image 8f927b0c-0fb4-4219-bb2a-775c09baae5d: Signature verification failed (HTTP 400)

You can expect to see this error message:

    Signature verification failed (HTTP 400)

Verify that only the signed image was uploaded.

    # openstack image list
    +--------------------------------------+---------------+--------+
    | ID                                   | Name          | Status |
    +--------------------------------------+---------------+--------+
    | e578bac0-0b28-480e-afd9-5e7e95ce465f | cirros        | active |
    | 52a2dcfa-d660-4e1b-9219-abd6ffe8b3d8 | cirros_alt    | active |
    | 648e93f1-d926-4c73-aa0a-bb8e1fcd9710 | mySignedImage | active |
    +--------------------------------------+---------------+--------+

[Back](Exercise_05_X509_Certifcates.md) [Up](../README.md) [Next](Exercise_07_Secret_Containers.md)
