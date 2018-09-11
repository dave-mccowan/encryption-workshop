## Exercise 10 - HSM Integration
Users sometimes need their secrets to be stored in a Hardware Security Module (HSM) to provide an extra level of security.  HSMs enforce process isolation - allowing secrets to be retrieved only through strictly defined interfaces and widely accepted algorithms, and provide tamper detection and resistance.  They will typically comply with standards like FIPS-140-1 and Common Criteria.

In this exercise, you will connect Barbican to a Dogtag instance that has been configured to store its key encryption keys in a Thales nShield 6000 HSM.  This involves simply changing the Dogtag plugin configuration in /etc/barbican.conf to point to the relevant Dogtag instance, which is currently hosted in a public VM in the OVH cloud.

The credentials to connect to the HSM (agent certificate) have already been copied to /etc/barbican by the setup script.  In addition, the CA certificate for the remote Dogtag instance has already been added to the trusted certificate bundle at /etc/ssl/certs/ca-bundle.trust.crt.

To minimize typing errors, the changes have been encapsulated in a simple script.  To use the remote Dogtag instance, simply run the following script and restart the barbican service:

    # /root/convert_to_dogtag_with_hsm.sh
    # systemctl restart httpd.service

The script simply changes the hostname of Dogtag instance in /etc/barbican/barbican.conf to point to the IP address of the remote Dogtag instance, and redirects to the path of the correct credentials.

It should now be possible to store and retrieve secrets by following the steps in Exercises 1-9.

If you wish to re-configure the Barbican instance to talk to the local Dogtag instance, then run the following script and restart the barbican service:

    # /root/convert_to_local_dogtag.sh
    # systemctl restart httpd.service
