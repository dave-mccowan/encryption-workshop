#########################
# setup hostname and ip
#########################
local_ip=`ip addr show eth0 | grep -Po 'inet \K[\d.]+'`
short_host=`hostname -s`
local_host=$short_host.localdomain

echo "::1 localhost localhost.localdomain localhost6 localhost6.localdomain6" > /etc/hosts
echo "127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/hosts
echo "$local_ip $local_host $short_host" >> /etc/hosts

# setup cirros image
mkdir -p /tmp/openstack/image/
cp ~/cache/image/cirros* /tmp/openstack/image/

############################################################
#  Install and configure Openstack services through puppet
############################################################

cat > scenario.pp << EOF
include ::openstack_integration
class { '::openstack_integration::config':
  ssl  => true,
  ipv6 => false,
}
include ::openstack_integration::cacert
include ::openstack_integration::memcached
include ::openstack_integration::rabbitmq
include ::openstack_integration::mysql
include ::openstack_integration::keystone
class { '::openstack_integration::glance':
  backend => 'swift',
}
include ::openstack_integration::swift

include ::openstack_integration::placement
class { '::openstack_integration::nova':
  volume_encryption => true,
}

class { '::openstack_integration::cinder':
  volume_encryption => true,
  cinder_backup     => 'swift',
}

include ::openstack_integration::barbican
include ::openstack_integration::horizon
class { '::openstack_integration::neutron':
  driver => 'linuxbridge',
}
include ::openstack_integration::provision
EOF

puppet apply --modulepath /etc/puppet/modules:/usr/share/puppet/modules scenario.pp

# Open all hosts for horizon
sed -i "s/^ALLOWED_HOSTS = .*/ALLOWED_HOSTS = \[\'\*\'\]/" /etc/openstack-dashboard/local_settings

# Restart httpd (barbican and horizon)
systemctl restart httpd.service

# Open firewall port for horizon
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --reload

# Add security group rules
source ~/openrc
openstack security group rule create --proto icmp default
openstack security group rule create --proto tcp --dst-port 22 default

# Add Neutron internal network and router
openstack network create internal --share
openstack subnet create int-subnet \
    --gateway 192.168.200.1 \
    --allocation-pool start=192.168.200.20,end=192.168.200.254 \
    --network internal --subnet-range 192.168.200.0/24
sleep 1
openstack router create router1
openstack router set router1 --external-gateway public
openstack router add subnet router1 int-subnet

# Launch a VM and attach a floating IP Address
INTERNAL_NETID=`openstack network show internal -f value -c id`
openstack server create --flavor m1.tiny --image cirros --nic net-id=$INTERNAL_NETID my_vm
IP_ADDR=`openstack floating ip create public -f value -c floating_ip_address`
sleep 5
openstack server add floating ip my_vm $IP_ADDR

# Reconfigure Glance to use Barbican and restart
cat >> /etc/glance/glance-api.conf << EOF
[barbican]
auth_endpoint=https://127.0.0.1:5000/v3
barbican_endpoint=https://127.0.0.1:9311
barbican_api_version=v1
[key_manager]
api_class=castellan.key_manager.barbican_key_manager.BarbicanKeyManager
EOF

openstack-service restart openstack-glance-api

# tag as done
touch /root/go.done.txt
