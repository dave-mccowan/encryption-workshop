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


####################################################
# configure directory server for Dogtag internal DB
####################################################

cd ~
cat > ~/389.inf << EOF
[General]
FullMachineName=$local_host
SuiteSpotUserID=nobody
ServerRoot=/var/lib/dirsrv
[slapd]
ServerPort=389
ServerIdentifier=dogtag-389
Suffix=dc=example,dc=com
RootDN=cn=Directory Manager
RootDNPwd=redhat123
EOF

setup-ds.pl --silent -f ~/389.inf

##############################
# configure dogtag CA and KRA
##############################

cat > ~/spawn.cfg << EOF
[DEFAULT]
pki_instance_name=pki-tomcat
pki_https_port=18443
pki_http_port=18080

pki_admin_password=redhat123
pki_security_domain_password=redhat123
pki_security_domain_https_port=18443
pki_client_pkcs12_password=redhat123
pki_client_database_password=redhat123
pki_ds_password=redhat123

[Tomcat]
pki_ajp_port=18009
pki_tomcat_server_port=18005

[KRA]
pki_issuing_ca_https_port=18443
EOF

pkispawn -s CA -f spawn.cfg
sleep 20
pkispawn -s KRA -f spawn.cfg
sleep 20

################################
# Set up barbican to use dogtag
################################

# create admin cert PEM file
cat > create_admin_cert_pem << EOF
#!/usr/bin/expect -f
#

set timeout -1
spawn openssl pkcs12 -in /root/.dogtag/pki-tomcat/ca_admin_cert.p12 -out /etc/barbican/kra_admin_cert.pem -nodes
match_max 100000
expect -exact "Enter Import Password:"
send -- "redhat123\r"
expect eof
EOF

expect create_admin_cert_pem
chown barbican: /etc/barbican/kra_admin_cert.pem

# create nssdb and store transport cert
mkdir /etc/barbican/alias
echo "password123" > pwfile
certutil -N -d /etc/barbican/alias -f pwfile
rm -f pwfile
chown -R barbican: /etc/barbican/alias

pki  -p 18080 -h localhost cert-show 0x7 --output transport.pem
certutil -d /etc/barbican/alias/ -A -n "KRA transport cert" -t "u,u,u" -i transport.pem

# modify barbican config and restart barbican
crudini --set /etc/barbican/barbican.conf secretstore enabled_secretstore_plugins dogtag_crypto
crudini --set /etc/barbican/barbican.conf dogtag_plugin dogtag_port 18443
crudini --set /etc/barbican/barbican.conf dogtag_plugin pem_path /etc/barbican/kra_admin_cert.pem
crudini --set /etc/barbican/barbican.conf dogtag_plugin nss_db_path /etc/barbican/alias
crudini --set /etc/barbican/barbican.conf dogtag_plugin nss_password redhat123

# Open all hosts for horizon
sed -i "s/^ALLOWED_HOSTS = .*/ALLOWED_HOSTS = \[\'\*\'\]/" /etc/openstack-dashboard/local_settings

# Restart httpd (barbican and horizon)
systemctl restart httpd.service

# Open firewall port for horizon
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --zone=public --add-port=443/tcp --permanent
firewall-cmd --reload

# add thales hsm scripts for last part of lab
# wget -O /root/thales_setup.sh https://raw.githubusercontent.com/dave-mccowan/encryption-workshop/master/scripts/thales_setup.sh
# wget -O /root/thales_unsetup.sh https://raw.githubusercontent.com/dave-mccowan/encryption-workshop/master/scripts/thales_unsetup.sh
# chmod +x thales_setup.sh
# chmod +x thales_unsetup.sh

# get and set up creds to access hsm through shared dogtag
wget -O /root/hsm_config.tar.gz https://vakwetu.fedorapeople.org/berlin_summit/hsm_config.tar.gz
tar -xzf /root/hsm_config.tar.gz -C /
chown -R barbican: /etc/barbican/alias_hsm
chown -R barbican: /etc/barbican/kra_admin_cert_hsm.pem
cat /etc/barbican/ca_cert_hsm.pem >> /etc/ssl/certs/ca-bundle.trust.crt

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


#########################
# allow password login
#########################
#usermod -p '$1$6EE.AFpC$9c9o2IkQRCVy84uq4qAjm0' centos
#sed -i 's|[#]*PasswordAuthentication no|PasswordAuthentication yes|g' /etc/ssh/sshd_config
#systemctl restart  sshd.service

# tag as done
touch /root/go.done.txt
