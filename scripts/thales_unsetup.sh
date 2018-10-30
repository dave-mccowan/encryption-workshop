set +x

# configure Barbican
echo "Configuring Barbican"
crudini --set /etc/barbican/barbican.conf dogtag_plugin dogtag_port 18443
crudini --set /etc/barbican/barbican.conf dogtag_plugin pem_path /etc/barbican/kra_admin_cert.pem
crudini --set /etc/barbican/barbican.conf dogtag_plugin nss_db_path /etc/barbican/alias
crudini --set /etc/barbican/barbican.conf dogtag_plugin nss_password redhat123
crudini --set /etc/barbican/barbican.conf secretstore enabled_secretstore_plugins "dogtag_crypto"

