#!/usr/bin/env bash
# Run this script to install software, but not yet deploy and configure.
# After this run is a good time to take a snapshot.

# start with a centos image
# then log in as centos and sudo su -
# install git, and run this script

# update all packages, set selinux permissive
yum update -y
setenforce 0

# repos to be added
yum install -y wget
wget https://trunk.rdoproject.org/centos7/puppet-passed-ci/delorean.repo -O /etc/yum.repos.d/delorean.repo
wget https://trunk.rdoproject.org/centos7/delorean-deps.repo -O /etc/yum.repos.d/delorean-deps.repo

# install software
wget https://raw.githubusercontent.com/dave-mccowan/encryption-workshop/master/scripts/package.list
yum install -y $(cat package.list)

# setup puppet-openstack
mkdir -p /etc/puppet
rmdir /etc/puppet/modules/
ln -s /usr/share/openstack-puppet/modules /etc/puppet/
git clone https://github.com/openstack/puppet-openstack-integration.git /etc/puppet/modules/openstack_integration

# get script files
cd ~
wget https://raw.githubusercontent.com/dave-mccowan/encryption-workshop/master/scripts/launch_step_2.sh

# chmod +x
chmod +x *.sh

# get cirros image
mkdir -p cache/image
wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img -O ~/cache/image/cirros-0.4.0-x86_64-disk.img

# get the flask app
wget https://vakwetu.fedorapeople.org/summit_demo_prep/flask.tar.gz
cd /root
tar -xzf /root/flask.tar.gz

# barbican gets an import error using ldap3 2.5.2, downgrade to 2.4.1
yum downgrade -y python2-ldap3
