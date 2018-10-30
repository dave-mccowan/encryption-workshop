## Exercise 10 - HSM Integration
Users sometimes need their secrets to be stored in a Hardware Security Module (HSM) to provide an extra level of security.  HSMs enforce process isolation - allowing secrets to be retrieved only through strictly defined interfaces and widely accepted algorithms, and provide tamper detection and resistance.  They will typically comply with standards like FIPS-140-1 and Common Criteria.

In this exercise, you will configure Barbican to use the PKCS#11 plugin to interface with a Thales nShield 6000 HSM.

To minimize typing errors, the changes needed have been encapsulated in a simple script.  The script does the following:

* Downloads the client files and credentials needed to communicate with the HSM
* Registers the client VM with the HSM
* Creates a master encryption key (MKEK) and master HMAC key for the Barbican PKCS#11 plugin
* Configures Barbican to use the PKCS#11 plugin.

To use the HSM, simply run the following script and restart the barbican service:

    # /root/thales_setup.sh <thales_hsm_ip>
    # systemctl restart httpd.service

It should now be possible to store and retrieve secrets by following the steps in Exercises 1-9.
You can confirm that HSM activity by tailing the HSM client's PKCS#11 logs in /tmp/pkcs11.log.

If you wish to re-configure the Barbican instance to talk to the local Dogtag instance, then run the following script and restart the barbican service:

    # /root/thales_unsetup.sh
    # systemctl restart httpd.service


[Back](Exercise_09_Flask_Application.md) [Up](../README.md)
