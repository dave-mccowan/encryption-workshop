## Exercise 9 - Flask Application
In this exercise, we’ll run a Flask application to simulate on a small scale what integrating Barbican using Castellan will look like in your project.

Open port 8000 on the VM:

    # firewall-cmd --zone=public --add-port=8000/tcp --permanent
    success
    # firewall-cmd --reload
    success

Activate the virtual environment:

    # source /root/new_flask/flask_app_venv/bin/activate

Create a random string:

    # SECRET=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)

Store the random string in Barbican:

    # openstack secret store --secret-type passphrase --payload $SECRET
    +---------------+------------------------------------------------------------------------+
    | Field         | Value                                                                  |
    +---------------+------------------------------------------------------------------------+
    | Secret href   | https://127.0.0.1:9311/v1/secrets/aa110849-32d8-4787-ae20-7e630a3027ae |
    | Name          | None                                                                   |
    | Created       | 2018-11-08T13:53:26+00:00                                              |
    | Status        | ACTIVE                                                                 |
    | Content types | {u'default': u'text/plain'}                                            |
    | Algorithm     | aes                                                                    |
    | Bit length    | 256                                                                    |
    | Secret type   | passphrase                                                             |
    | Mode          | cbc                                                                    |
    | Expiration    | None                                                                   |
    +---------------+------------------------------------------------------------------------+

Save the secret UUID as an environment variable.  The UUID is the last part of the secret ref that was printed after creating the secret.  It should be in the format of 00000000-0000-0000-0000-000000000000:

    # export OS_SECRET_UUID=<secret_uuid>

Ensure all the requirements are installed:

    # cd /root/new_flask/hide-your-tweets
    # yum install -y python-pip
    Loaded plugins: fastestmirror
    Loading mirror speeds from cached hostfile
    epel/x86_64/metalink                                        |  12 kB  00:00:00     
     * epel: epel.mirror.constant.com
    base                                                        | 3.6 kB  00:00:00     
    centos7-virt-container                                      | 2.9 kB  00:00:00     
    delorean                                                    | 3.0 kB  00:00:00     
    delorean-master-build-deps                                  | 2.9 kB  00:00:00     
    delorean-master-testing                                     | 2.9 kB  00:00:00     
    epel                                                        | 3.2 kB  00:00:00     
    extras                                                      | 3.4 kB  00:00:00     
    rdo-qemu-ev                                                 | 2.9 kB  00:00:00     
    updates                                                     | 3.4 kB  00:00:00     
    (1/2): epel/x86_64/updateinfo                               | 930 kB  00:00:00     
    (2/2): epel/x86_64/primary                                  | 3.6 MB  00:00:00     
    epel                                                                   12696/12696
    Package python-pip is obsoleted by python2-pip, trying to install python2-pip-8.1.2-6.el7.noarch instead
    Resolving Dependencies
    --> Running transaction check
    ---> Package python2-pip.noarch 0:8.1.2-6.el7 will be installed
    --> Finished Dependency Resolution
    Dependencies Resolved
    ===================================================================================
     Package               Arch             Version               Repository      Size
    ===================================================================================
    Installing:
     python2-pip           noarch           8.1.2-6.el7           epel           1.7 M
    Transaction Summary
    ===================================================================================
    Install  1 Package
    Total download size: 1.7 M
    Installed size: 7.2 M
    Downloading packages:
    python2-pip-8.1.2-6.el7.noarch.rpm                          | 1.7 MB  00:00:00     
    Running transaction check
    Running transaction test
    Transaction test succeeded
    Running transaction
      Installing : python2-pip-8.1.2-6.el7.noarch                                  1/1 
      Verifying  : python2-pip-8.1.2-6.el7.noarch                                  1/1 
    Installed:
      python2-pip.noarch 0:8.1.2-6.el7                                                 
    Complete!
    # pip install -r requirements.txt
    Collecting Flask==0.10.0 (from -r requirements.txt (line 1))
      Downloading https://files.pythonhosted.org/packages/f3/46/53d83cbdb79b27678c7b032d5deaa556655dd034cc747ee609b3e3cbf95b/Flask-0.10.tar.gz (544kB)
        100% |████████████████████████████████| 552kB 1.6MB/s 
    Collecting Flask-WTF==0.12 (from -r requirements.txt (line 2))
      Downloading https://files.pythonhosted.org/packages/2e/2f/47f6bc1d15d7df32a49582028d71caa7f6a8b53b61e0ca48ebdc9ed2c881/Flask_WTF-0.12-py2-none-any.whl
    Collecting WTForms==2.1 (from -r requirements.txt (line 3))
      Downloading https://files.pythonhosted.org/packages/bf/91/2e553b86c55e9cf2f33265de50e052441fb753af46f5f20477fe9c61280e/WTForms-2.1.zip (553kB)
        100% |████████████████████████████████| 563kB 1.8MB/s 
    Requirement already satisfied (use --upgrade to upgrade): pytz in /usr/lib/python2.7/site-packages (from -r requirements.txt (line 4))
    Requirement already satisfied (use --upgrade to upgrade): cryptography in /usr/lib64/python2.7/site-packages (from -r requirements.txt (line 5))
    Requirement already satisfied (use --upgrade to upgrade): keystoneauth1 in /usr/lib/python2.7/site-packages (from -r requirements.txt (line 6))
    Requirement already satisfied (use --upgrade to upgrade): python-barbicanclient in /usr/lib/python2.7/site-packages (from -r requirements.txt (line 7))
    Requirement already satisfied (use --upgrade to upgrade): oslo.context in /usr/lib/python2.7/site-packages (from -r requirements.txt (line 8))
    Requirement already satisfied (use --upgrade to upgrade): castellan in /usr/lib/python2.7/site-packages (from -r requirements.txt (line 9))
    Collecting packaging>=16.8 (from -r requirements.txt (line 10))
      Downloading https://files.pythonhosted.org/packages/89/d1/92e6df2e503a69df9faab187c684585f0136662c12bb1f36901d426f3fab/packaging-18.0-py2.py3-none-any.whl
    Requirement already satisfied (use --upgrade to upgrade): Werkzeug>=0.7 in /usr/lib/python2.7/site-packages (from Flask==0.10.0->-r requirements.txt (line 1))
    Requirement already satisfied (use --upgrade to upgrade): Jinja2>=2.4 in /usr/lib/python2.7/site-packages (from Flask==0.10.0->-r requirements.txt (line 1))
    Requirement already satisfied (use --upgrade to upgrade): itsdangerous>=0.21 in /usr/lib/python2.7/site-packages (from Flask==0.10.0->-r requirements.txt (line 1))
    Requirement already satisfied (use --upgrade to upgrade): idna>=2.1 in /usr/lib/python2.7/site-packages (from cryptography->-r requirements.txt (line 5))
    Requirement already satisfied (use --upgrade to upgrade): asn1crypto>=0.21.0 in /usr/lib/python2.7/site-packages (from cryptography->-r requirements.txt (line 5))
    Requirement already satisfied (use --upgrade to upgrade): six>=1.4.1 in /usr/lib/python2.7/site-packages (from cryptography->-r requirements.txt (line 5))
    Requirement already satisfied (use --upgrade to upgrade): cffi>=1.7 in /usr/lib64/python2.7/site-packages (from cryptography->-r requirements.txt (line 5))
    Requirement already satisfied (use --upgrade to upgrade): enum34 in /usr/lib/python2.7/site-packages (from cryptography->-r requirements.txt (line 5))
    Requirement already satisfied (use --upgrade to upgrade): ipaddress in /usr/lib/python2.7/site-packages (from cryptography->-r requirements.txt (line 5))
    Requirement already satisfied (use --upgrade to upgrade): pyparsing>=2.0.2 in /usr/lib/python2.7/site-packages (from packaging>=16.8->-r requirements.txt (line 10))
    Requirement already satisfied (use --upgrade to upgrade): MarkupSafe>=0.23 in /usr/lib64/python2.7/site-packages (from Jinja2>=2.4->Flask==0.10.0->-r requirements.txt (line 1))
    Requirement already satisfied (use --upgrade to upgrade): pycparser in /usr/lib/python2.7/site-packages (from cffi>=1.7->cryptography->-r requirements.txt (line 5))
    Installing collected packages: Flask, WTForms, Flask-WTF, packaging
      Found existing installation: Flask 1.0.2
        Uninstalling Flask-1.0.2:
          Successfully uninstalled Flask-1.0.2
      Running setup.py install for Flask ... done
      Running setup.py install for WTForms ... done
    Successfully installed Flask-0.10 Flask-WTF-0.12 WTForms-2.1 packaging-18.0
    You are using pip version 8.1.2, however version 18.1 is available.
    You should consider upgrading via the 'pip install --upgrade pip' command.

Change directories and run the server:

    # cd /root/new_flask/hide-your-tweets/src
    # python server.py
     * Running on http://0.0.0.0:8000/ (Press CTRL+C to quit)

As long as the server is running, there should be a webapp available at <your-vm-ip>:8000.  Try entering a message to encrypt.  Please note that the tweet must be less than 15 characters.  The web app will use your randomly generated secret to encrypt the Tweet.  If you wish, you can log into Twitter and post the tweet.  If you don’t have a Twitter account or don’t wish to post the tweet, you can copy the tweet to your clipboard.  When you need to decrypt the tweet, copy the encrypted text and paste it into the web app.

Note the castellan.conf file in hide-your-tweets/src.  Similarly to OpenStack projects, this is where you can configure Castellan.  For example, when you need to configure Nova to use Barbican, you will use the same [key_manager] section that can be found in this castellan.conf.

At the end of the exercise, deactivate the virtual environment:

    # deactivate

[Back](Exercise_08_Generating_RSA_Keys.md) [Up](../README.md) [Next](Exercise_10_HSM_Integration.md)
