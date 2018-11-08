## Exercise 4 - Encrypted Volumes
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
    +-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | Field       | Value                                                                                                                                                                              |
    +-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | description | None                                                                                                                                                                               |
    | encryption  | cipher='aes-xts-plain64', control_location='front-end', encryption_id='19b5c3f7-1dcc-48f8-b32a-30533c001882', key_size='256', provider='nova.volume.encryptors.luks.LuksEncryptor' |
    | id          | 123a16cc-2bbb-423a-8533-7fbf2cef936c                                                                                                                                               |
    | is_public   | True                                                                                                                                                                               |
    | name        | LUKS                                                                                                                                                                               |
    +-------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

List the volume types that are now configured.

    # openstack volume type list
    +--------------------------------------+-----------+-----------+
    | ID                                   | Name      | Is Public |
    +--------------------------------------+-----------+-----------+
    | 123a16cc-2bbb-423a-8533-7fbf2cef936c | LUKS      | True      |
    | 679aa85f-8237-4fae-96b1-15da908ede39 | BACKEND_1 | True      |
    +--------------------------------------+-----------+-----------+

Create a volume with the default (unencrypted) type.

    # openstack volume create --size 1 clear_volume
    +---------------------+--------------------------------------+
    | Field               | Value                                |
    +---------------------+--------------------------------------+
    | attachments         | []                                   |
    | availability_zone   | nova                                 |
    | bootable            | false                                |
    | consistencygroup_id | None                                 |
    | created_at          | 2018-11-08T12:50:10.000000           |
    | description         | None                                 |
    | encrypted           | False                                |
    | id                  | ad3bb625-b29e-4d0d-bd4a-1ed303849896 |
    | migration_status    | None                                 |
    | multiattach         | False                                |
    | name                | clear_volume                         |
    | properties          |                                      |
    | replication_status  | None                                 |
    | size                | 1                                    |
    | snapshot_id         | None                                 |
    | source_volid        | None                                 |
    | status              | creating                             |
    | type                | BACKEND_1                            |
    | updated_at          | None                                 |
    | user_id             | e3b64775d08d4448a45fbf2a4bb8d0ae     |
    +---------------------+--------------------------------------+

Create a volume with the LUKS (encrypted) type.

    # openstack volume create --size 1 --type LUKS encrypted_volume
    +---------------------+--------------------------------------+
    | Field               | Value                                |
    +---------------------+--------------------------------------+
    | attachments         | []                                   |
    | availability_zone   | nova                                 |
    | bootable            | false                                |
    | consistencygroup_id | None                                 |
    | created_at          | 2018-11-08T12:51:27.000000           |
    | description         | None                                 |
    | encrypted           | True                                 |
    | id                  | e1978ee7-de6a-427c-9917-cbfece8e156a |
    | migration_status    | None                                 |
    | multiattach         | False                                |
    | name                | encrypted_volume                     |
    | properties          |                                      |
    | replication_status  | None                                 |
    | size                | 1                                    |
    | snapshot_id         | None                                 |
    | source_volid        | None                                 |
    | status              | creating                             |
    | type                | LUKS                                 |
    | updated_at          | None                                 |
    | user_id             | e3b64775d08d4448a45fbf2a4bb8d0ae     |
    +---------------------+--------------------------------------+

List the volumes that are now configured.

    # openstack volume list
    +--------------------------------------+------------------+-----------+------+-------------+
    | ID                                   | Name             | Status    | Size | Attached to |
    +--------------------------------------+------------------+-----------+------+-------------+
    | e1978ee7-de6a-427c-9917-cbfece8e156a | encrypted_volume | available |    1 |             |
    | ad3bb625-b29e-4d0d-bd4a-1ed303849896 | clear_volume     | available |    1 |             |
    +--------------------------------------+------------------+-----------+------+-------------+

View the details of the volume.  Look for the “encrypted” and “type” attributes of each volume.

    # openstack volume show clear_volume
    +--------------------------------+--------------------------------------+
    | Field                          | Value                                |
    +--------------------------------+--------------------------------------+
    | attachments                    | []                                   |
    | availability_zone              | nova                                 |
    | bootable                       | false                                |
    | consistencygroup_id            | None                                 |
    | created_at                     | 2018-11-08T12:50:10.000000           |
    | description                    | None                                 |
    | encrypted                      | False                                |
    | id                             | ad3bb625-b29e-4d0d-bd4a-1ed303849896 |
    | migration_status               | None                                 |
    | multiattach                    | False                                |
    | name                           | clear_volume                         |
    | os-vol-host-attr:host          | moises6@BACKEND_1#BACKEND_1          |
    | os-vol-mig-status-attr:migstat | None                                 |
    | os-vol-mig-status-attr:name_id | None                                 |
    | os-vol-tenant-attr:tenant_id   | 38ca2cc64f204a6fb0ee1e85398c6380     |
    | properties                     |                                      |
    | replication_status             | None                                 |
    | size                           | 1                                    |
    | snapshot_id                    | None                                 |
    | source_volid                   | None                                 |
    | status                         | available                            |
    | type                           | BACKEND_1                            |
    | updated_at                     | 2018-11-08T12:50:11.000000           |
    | user_id                        | e3b64775d08d4448a45fbf2a4bb8d0ae     |
    +--------------------------------+--------------------------------------+
    # openstack volume show encrypted_volume
    +--------------------------------+--------------------------------------+
    | Field                          | Value                                |
    +--------------------------------+--------------------------------------+
    | attachments                    | []                                   |
    | availability_zone              | nova                                 |
    | bootable                       | false                                |
    | consistencygroup_id            | None                                 |
    | created_at                     | 2018-11-08T12:51:27.000000           |
    | description                    | None                                 |
    | encrypted                      | True                                 |
    | id                             | e1978ee7-de6a-427c-9917-cbfece8e156a |
    | migration_status               | None                                 |
    | multiattach                    | False                                |
    | name                           | encrypted_volume                     |
    | os-vol-host-attr:host          | moises6@BACKEND_1#BACKEND_1          |
    | os-vol-mig-status-attr:migstat | None                                 |
    | os-vol-mig-status-attr:name_id | None                                 |
    | os-vol-tenant-attr:tenant_id   | 38ca2cc64f204a6fb0ee1e85398c6380     |
    | properties                     |                                      |
    | replication_status             | None                                 |
    | size                           | 1                                    |
    | snapshot_id                    | None                                 |
    | source_volid                   | None                                 |
    | status                         | available                            |
    | type                           | LUKS                                 |
    | updated_at                     | 2018-11-08T12:51:28.000000           |
    | user_id                        | e3b64775d08d4448a45fbf2a4bb8d0ae     |
    +--------------------------------+--------------------------------------+

View the VM that is already running.

    # openstack server list
    +--------------------------------------+-------+--------+--------------------------------------+--------+---------+
    | ID                                   | Name  | Status | Networks                             | Image  | Flavor  |
    +--------------------------------------+-------+--------+--------------------------------------+--------+---------+
    | 2575daa8-afec-4fb8-a993-6208aea68f82 | my_vm | ACTIVE | internal=192.168.200.31, 172.24.5.15 | cirros | m1.tiny |
    +--------------------------------------+-------+--------+--------------------------------------+--------+---------+    

Capture the IP Address of the server

    # IP_ADDR=$(openstack server show my_vm -c addresses -f value|awk '{print $2}')

Attach the volumes to the server.

    # openstack server add volume my_vm clear_volume
    # openstack server add volume my_vm encrypted_volume

Login to the server, format and mount the volumes, then write some data.  You’ll write “public” data to the unencrypted volume and “private” information to the encrypted volume.

    # ssh cirros@$IP_ADDR    # password is “gocubsgo”
    $ sudo su -
    # mkfs.ext4 /dev/vdb
    mke2fs 1.42.12 (29-Aug-2014)
    Creating filesystem with 262144 4k blocks and 65536 inodes
    Filesystem UUID: 232edbb8-fd20-4b6a-b90c-d3cbb4388a67
    Superblock backups stored on blocks: 
            32768, 98304, 163840, 229376

    Allocating group tables: done                            
    Writing inode tables: done                            
    Creating journal (8192 blocks): done
    Writing superblocks and filesystem accounting information: done

    # mkfs.ext4 /dev/vdc
    mke2fs 1.42.12 (29-Aug-2014)
    Creating filesystem with 261632 4k blocks and 65408 inodes
    Filesystem UUID: c26105a2-d5bb-467c-8ee2-a444ce3742a9
    Superblock backups stored on blocks: 
            32768, 98304, 163840, 229376

    Allocating group tables: done                            
    Writing inode tables: done                            
    Creating journal (4096 blocks): done
    Writing superblocks and filesystem accounting information: done
    
    # mkdir -p /data/clear
    # mkdir -p /data/encrypted
    # mount /dev/vdb /data/clear
    # mount /dev/vdc /data/encrypted
    # echo “public information” > /data/clear/public.txt
    # echo “private information” > /data/encrypted/private.txt
    # exit
    $ exit

Now, you can verify what happened.  List the secrets from Barbican and you can see that Cinder created a secret with the volume that Nova read when you launched the new VM.

    # openstack secret list
    +------------------------------------------------------------------------+------------------------+---------------------------+--------+-------------------------------------------+-----------+------------+-------------+------+------------+
    | Secret href                                                            | Name                   | Created                   | Status | Content types                             | Algorithm | Bit length | Secret type | Mode | Expiration |
    +------------------------------------------------------------------------+------------------------+---------------------------+--------+-------------------------------------------+-----------+------------+-------------+------+------------+
    | https://127.0.0.1:9311/v1/secrets/103aa804-8aa6-4abe-ac35-7848b9ae97df | AES-256 Encryption Key | 2018-11-08T10:42:37+00:00 | ACTIVE | {u'default': u'application/octet-stream'} | aes       |        256 | symmetric   | cbc  | None       |
    | https://127.0.0.1:9311/v1/secrets/1efb79e1-879e-4406-b8f6-76426bc99f71 | Order for an AES key   | 2018-11-08T12:05:21+00:00 | ACTIVE | {u'default': u'application/octet-stream'} | aes       |        256 | symmetric   | cbc  | None       |
    | https://127.0.0.1:9311/v1/secrets/9a29b190-f6de-471d-b130-f67fc0eee8d1 | my passphrase          | 2018-11-08T10:14:22+00:00 | ACTIVE | {u'default': u'text/plain'}               | aes       |        256 | passphrase  | cbc  | None       |
    | https://127.0.0.1:9311/v1/secrets/ebcfb632-a6f2-4fdd-9c28-6af377a95c98 | another passphrase     | 2018-11-08T10:16:26+00:00 | ACTIVE | {u'default': u'text/plain'}               | aes       |        256 | passphrase  | cbc  | None       |
    | https://127.0.0.1:9311/v1/secrets/feb71626-f9da-4885-980b-945ea7ac7510 | None                   | 2018-11-08T12:51:26+00:00 | ACTIVE | {u'default': u'application/octet-stream'} | aes       |        256 | symmetric   | None | None       |
    +------------------------------------------------------------------------+------------------------+---------------------------+--------+-------------------------------------------+-----------+------------+-------------+------+------------+

In this deployment, the volumes that you created are stored in a logical file located named /var/lib/cinder/cinder-volumes.  Now, look for the data you wrote.  You should be able to find the “public” data, but not the “private” data since it is encrypted.

    # head -c 300M /var/lib/cinder/cinder-volumes | fold | grep public
    Binary file (standard input) matches
    # echo $?
    0
    # head -c 300M /var/lib/cinder/cinder-volumes | fold | grep private
    # echo $?
    1

[Back](Exercise_03_Generating_Symmetric_Encryption_Keys.md) [Up](../README.md) [Next](Exercise_05_X509_Certifcates.md)
