## Exercise 9 - Flask Application
In this exercise, we’ll run a Flask application to simulate on a small scale what integrating Barbican using Castellan will look like in your project.

Open port 8000 on the VM:

    # firewall-cmd --zone=public --add-port=8000/tcp --permanent
    # firewall-cmd --reload

Activate the virtual environment:

    # source /root/new_flask/flask_app_venv/bin/activate

Create a random string:

    # SECRET=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32)

Store the random string in Barbican:

    # openstack secret store --secret-type passphrase --payload $SECRET

Save the secret UUID as an environment variable.  The UUID is the last part of the secret ref that was printed after creating the secret.  It should be in the format of 00000000-0000-0000-0000-000000000000:

    # export OS_SECRET_UUID=<secret_uuid>

Ensure all the requirements are installed:

    # cd /root/new_flask/hide-your-tweets
    # yum install -y python-pip
    # pip install -r requirements.txt

Change directories and run the server:

    # cd /root/new_flask/hide-your-tweets/src
    # python server.py

As long as the server is running, there should be a webapp available at <your-vm-ip>:8000.  Try entering a message to encrypt.  Please note that the tweet must be less than 15 characters.  The web app will use your randomly generated secret to encrypt the Tweet.  If you wish, you can log into Twitter and post the tweet.  If you don’t have a Twitter account or don’t wish to post the tweet, you can copy the tweet to your clipboard.  When you need to decrypt the tweet, copy the encrypted text and paste it into the web app.

Note the castellan.conf file in hide-your-tweets/src.  Similarly to OpenStack projects, this is where you can configure Castellan.  For example, when you need to configure Nova to use Barbican, you will use the same [key_manager] section that can be found in this castellan.conf.

At the end of the exercise, deactivate the virtual environment:

    # deactivate


[Back](Exercise_08_X509_Certifcates.md) [Up](../README.md) [Next](Exercise_10_HSM_Integration.md)
