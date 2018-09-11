## Exercise 8 - x.509 Certificates
Create a self-signed x.509 certificate and upload all parts.

LBaaS relies on Barbican to store the both the public and the private data necessary to decrypt TLS connections on the Load Balancer. The user uploads their private key, certificate, and any necessary intermediates into a Barbican certificate container. LBaaS understands the certificate container format, and only needs the container's ID when creating a TLS Terminating Load Balancer.

First, generate the new key that will be used to sign the certificate and convert it to PKCS#8 format:

    # openssl genrsa -out private.pem 4096
    # openssl pkcs8 -topk8 -in private.pem -out private.pk8 -nocrypt

Store the PKCS#8 formatted private key.

    # PRIVATE_REF=$(openstack secret store \
          --secret-type private \
          --name 'Private Key for Certificate' \
          --file private.pk8 \
          -c secret_ref -f value)

Next, use openssl to generate the self-signed certificate:

    # openssl req -new -x509 -days 365 -key private.pk8 -out cert.pem

Upload the certificate:

    # CERT_REF=$(openstack secret store \
          --secret-type certificate \
          --name 'myhost.com certificate' \
          --file cert.pem \
          -c secret_ref -f value)

Now create a certificate type container using the private key and certificate references:

    # CONTAINER_REF=$(openstack secret container create \
          --type certificate \
          --name 'Self-signed Certificate Bundle' \
          --secret "certificate=$CERT_REF" \
          --secret "private_key=$PRIVATE_REF" \
          -c container_ref -f value)

To retrieve the certificate container use this command:

    # openstack secret container get $CONTAINER_REF

Once you retrieve the container you can retrieve the individual secrets as in Exercise 1.
