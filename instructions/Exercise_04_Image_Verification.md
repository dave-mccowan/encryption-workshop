## Exercise 4 - Image Verification Using Glance
Image verification allows Glance to enforce that only images signed by a trusted administrator with access to the private key can be uploaded to Glance.

In this exercise you will:
- Create a key to sign images and store it in Barbican
- Create two “images”, one with a valid signature and one without
- Using the Glance API, attempt to upload the two images, while providing the UUID for the signing key.
- Verify that only the image with the valid signature was uploaded

The following set of steps would be done by a trusted administrator.  These steps will create two images.  You will sign one image, but not the other.

First, create a key pair to be used for signing and store it in Barbican.  Enter each of these commands to a certificate.  On the fourth command (openssl x509 …) you will be prompted to enter information to be stored in the certificate.  You can take the default (hit return) for each one, or provide a different answer.  The specific answers will not affect this exercise.

    # openssl genrsa -out private_key.pem 1024
    # openssl rsa -pubout -in private_key.pem -out public_key.pem
    # openssl req -new -key private_key.pem -out cert_request.csr
    # openssl x509 -req -days 14 -in cert_request.csr -signkey private_key.pem -out new_cert.crt
    # CERT_REF=$(openstack secret store --name signing-cert \
      --algorithm RSA --secret-type certificate \
      --payload-content-type "application/octet-stream" \
      --payload-content-encoding base64 \
      --payload "$(base64 new_cert.crt)" -c "Secret href" -f value)
    # CERT_UUID=$(echo $CERT_REF | awk -F '/' '{print $NF}')
    # openstack secret list

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

Now, attempt to upload the unsigned_image, using the signed image’s signature.  This will fail, since Glance will validate the signature before accepting the image.

    # glance image-create --name myUnsignedImage \
       --container-format bare --disk-format qcow2 \
       --property img_signature="$image_signature" \
       --property img_signature_certificate_uuid="$CERT_UUID" \
       --property img_signature_hash_method='SHA-256' \
       --property img_signature_key_type='RSA-PSS' < unsigned_image

You can expect to see this error message:

    Signature verification failed (HTTP 400)

Verify that only the signed image was uploaded.

    # openstack image list


[Back](Exercise_03_Encrypted_Volumes.md) [Up](../README.md) [Next](Exercise_05_Secret_Containers.md)
