## Exercise 3 - Encrypted Volumes
In this exercise you will:
- Using the Cinder API, create two volumes: an encrypted one and an unencrypted volume
- Using the Nova API, launch an instance and attach the two volumes
- Verify that data written to the encrypted volume has been encrypted

This feature demonstrates a number of Barbican capabilities:
When the encrypted volume is created, a key is generated in Barbican (see exercise 6).
When the volume is attached by Nova to the instance, the key is retrieved from Barbican. (see exercise 2)
Both Nova and Cinder use Castellan to access Barbican.

Create a new volume type in Cinder and configure it to use LUKS encryption.

    # openstack volume type create \
    --encryption-provider nova.volume.encryptors.luks.LuksEncryptor \
    --encryption-cipher aes-xts-plain64 \
    --encryption-key-size 256 \
    --encryption-control-location front-end LUKS

List the volume types that are now configured.

    # openstack volume type list

Create a volume with the default (unencrypted) type.

    # openstack volume create --size 1 clear_volume

Create a volume with the LUKS (encrypted) type.

    # openstack volume create --size 1 --type LUKS encrypted_volume

List the volumes that are now configured.

    # openstack volume list

View the details of the volume.  Look for the “encrypted” and “type” attributes of each volume.

    # openstack volume show clear_volume
    # openstack volume show encrypted_volume

Create a new server and configure it’s networking.

    # INTERNAL_NETID=`openstack network show internal -f value -c id`

    # openstack server create --flavor m1.tiny --image cirros \
    --nic net-id=$INTERNAL_NETID my_vm

    # IP_ADDR=`openstack floating ip create public -f value \
    -c floating_ip_address`

    # openstack server add floating ip my_vm $IP_ADDR

    # ping $IP_ADDR

Attach the volumes to the server.

    # openstack server add volume my_vm clear_volume
    # openstack server add volume my_vm encrypted_volume

Login to the server, format and mount the volumes, then write some data.  You’ll write “public” data to the unencrypted volume and “private” information to the encrypted volume.

    # ssh cirros@$IP_ADDR    # password is “cubswin:)”
    $ sudo su -
    # mkfs.ext4 /dev/vdb
    # mkfs.ext4 /dev/vdc
    # mkdir -p /data/clear
    # mkdir -p /data/encrypted
    # mount /dev/vdb /data/clear
    # mount /dev/vdc /data/encrypted
    # echo “public information” > /data/clear/public.txt
    # echo “private information” > /data/encrypted/private.txt
    # exit
    $ exit

Now, you can verify what happened.  List the secrets from Barbican and you can see that Cinder created a secret with the volume that Nova read when you launched the new VM.

    $ openstack secret list

In this deployment, the volumes that you created are stored in a logical file located named /var/lib/cinder/cinder-volumes.  Now, look for the data you wrote.  You should be able to find the “public” data, but not the “private” data since it is encrypted.

    # head -c 300M /var/lib/cinder/cinder-volumes | fold | grep public
    # head -c 300M /var/lib/cinder/cinder-volumes | fold | grep private


[Back](Exercise_02_Symmetric_Enrcryption_Keys.md) [Up](../README.md) [Next](Exercise_04_Image_Verification.md)
