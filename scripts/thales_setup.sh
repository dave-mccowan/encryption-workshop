set +x

hsm_ip=$1
slot_id="492971157"
module_url=https://vakwetu.fedorapeople.org/berlin_summit_demo/module_3C09-02E0-D947
world_url=https://vakwetu.fedorapeople.org/berlin_summit_demo/world

# add cknfastrc file
echo "Adding Thales config file ..."
cat << EOF > /opt/nfast/cknfastrc
CKNFAST_OVERRIDE_SECURITY_ASSURANCES=explicitness
CKNFAST_DEBUG=9
CKNFAST_DEBUGFILE=/tmp/pkcs11.log
CKNFAST_FAKE_ACCELERATOR_LOGIN=1
CKNFAST_NO_ACCELERATOR_SLOTS=0
EOF
chown nfast:nfast /opt/nfast/cknfastrc

# add kmdata for the HSM
echo "Downloading Thales security world files ..."
pushd /opt/nfast/kmdata/local
curl -O ${module_url}
curl -O ${world_url}
chown nfast:nfast *
popd

# enroll in the HSM
echo "Enrolling in the HSM ..."
anonkneti=`/opt/nfast/bin/anonkneti ${hsm_ip}`
/opt/nfast/bin/nethsmenroll ${hsm_ip} ${anonkneti}

ip_label=`curl icanhazip.com`
barbican_mkek_label="barbican_mkek_${ip_label}"
barbican_hmac_label="barbican_hmac_${ip_label}"

# create MKEK
echo "Creating the MKEK"
/usr/bin/barbican-manage hsm check_mkek --library-path /opt/nfast/toolkits/pkcs11/libcknfast.so --slot-id ${slot_id} --passphrase fake --label $barbican_mkek_label || /usr/bin/barbican-manage hsm gen_mkek --library-path /opt/nfast/toolkits/pkcs11/libcknfast.so --slot-id ${slot_id}  --passphrase fake --label $barbican_mkek_label

# create hmac
echo "Creating the HMAC"
/usr/bin/barbican-manage hsm check_hmac --library-path /opt/nfast/toolkits/pkcs11/libcknfast.so --slot-id ${slot_id} --passphrase fake --label $barbican_hmac_label --key-type CKK_SHA256_HMAC || /usr/bin/barbican-manage hsm gen_hmac --library-path /opt/nfast/toolkits/pkcs11/libcknfast.so --slot-id ${slot_id} --passphrase fake --label $barbican_hmac_label --key-type CKK_SHA256_HMAC --mechanism CKM_NC_SHA256_HMAC_KEY_GEN

# configure Barbican
echo "Configuring Barbican"
crudini --set /etc/barbican/barbican.conf p11_crypto_plugin library_path "/opt/nfast/toolkits/pkcs11/libcknfast.so"
crudini --set /etc/barbican/barbican.conf p11_crypto_plugin login "fake_passphrase"
crudini --set /etc/barbican/barbican.conf p11_crypto_plugin mkek_label "${barbican_mkek_label}"
crudini --set /etc/barbican/barbican.conf p11_crypto_plugin hmac_label "${barbican_hmac_label}"
crudini --set /etc/barbican/barbican.conf p11_crypto_plugin slot_id "${slot_id}"
crudini --set /etc/barbican/barbican.conf p11_crypto_plugin encryption_mechanism "CKM_AES_CBC"
crudini --set /etc/barbican/barbican.conf p11_crypto_plugin hmac_key_type "CKK_SHA256_HMAC"
crudini --set /etc/barbican/barbican.conf p11_crypto_plugin hmac_keygen_mechanism "CKM_NC_SHA256_HMAC_KEY_GEN"
crudini --set /etc/barbican/barbican.conf crypto enabled_crypto_plugins "p11_crypto"
crudini --set /etc/barbican/barbican.conf secretstore enabled_secretstore_plugins "store_crypto"

