#!/bin/bash
location=$(pwd)
echo Hello!

apt-get install libapache2-mod-wsgi python-dev
a2enmod wsgi 

echo Give your project a cool name...

read name
echo $name is a good choice
sleep 1
clear

echo Note that your project will be automatically deployed to /var/www
sleep 1
clear

cd /var/www

sudo rm -rf $name
sudo mkdir $name
cd $name
sudo mkdir $name
cd $name
mkdir static templates

cp $location/__init__.py .
pip install virtualenv
virtualenv venv

source venv/bin/activate
pip install Flask
echo Ok everything is setup!
deactivate
sleep 1
clear



echo Lets configure Apache now!
sleep 1
clear
cd /etc/apache2/sites-available
rm -rf $name.conf
touch $name.conf
chmod 0777 $name.conf
echo "<VirtualHost *:5000>
		ServerName localhost
		ServerAdmin $USER@localhost
		WSGIScriptAlias / /var/www/$name/$name.wsgi
		<Directory /var/www/$name/$name/>
			Order allow,deny
			Allow from all
		</Directory>
		Alias /static /var/www/$name/$name/static
		<Directory /var/www/$name/$name/static/>
			Order allow,deny
			Allow from all
		</Directory>
		ErrorLog ${APACHE_LOG_DIR}/error.log
		LogLevel warn
		CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>" >> /etc/apache2/sites-available/$name.conf

a2ensite $name
cd /var/www/$name
rm -rf $name.wsgi
touch $name.wsgi
chmod 0777 $name.wsgi


echo "#!/usr/bin/python
python_home = '/var/www/$name/$name/venv'
activate_this = python_home + '/bin/activate_this.py'
execfile(activate_this, dict(__file__=activate_this))
import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0,\"/var/www/$name/\")

from $name import app as application
application.secret_key = '$USER'">> $name.wsgi
service apache2 restart

