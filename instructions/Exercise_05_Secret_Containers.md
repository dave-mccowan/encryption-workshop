## Exercise 5 - Secret Containers
Create a couple of Secrets and add them to a Secret Container.

Containers are a useful way to group a few Secrets together.  In this example, you will store two passphrases for production-ready external services in Barbican.  You can group them in a container so that you can easily retrieve all your production-related passphrases in one command.

First create two secret passphrases and store the references in environment variables:

    # DB_PASSWORD_REF=$(openstack secret store \
          --secret-type passphrase \
          --name "Prod DB Password" \
          --payload 'D4taba$ePassw0rd' -c "Secret href" -f value)

    # RABBIT_PASSWORD_REF=$(openstack secret store \
          --secret-type passphrase \
          --name "Prod RabbitMQ Password" \
          --payload 'Rabb1tMQPa$$worD' -c "Secret href" -f value)

Next create the container and store the "Container href":

    # CONTAINER_REF=$(openstack secret container create \
          --type generic \
          --name "Production Credentials" \
          --secret "db=$DB_PASSWORD_REF" \
          --secret "rabbit=$RABBIT_PASSWORD_REF" \
          -c "Container href" -f value)

At this point you only need to store the "Container href".  Since the container has the references to the secrets, you can query the secret container to retrieve the individual "Secret href".

To retrieve the container use this command:

    # openstack secret container get $CONTAINER_REF

Once you retrieve the container you can retrieve the individual secrets as in Exercise 1.


[Back](Exercise_04_Image_Verification.md) [Up](../README.md) [Next](Exercise_06_Generating_Symmetric_Encryption_Keys.md)
