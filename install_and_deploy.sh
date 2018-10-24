#!/bin/bash
location=$(pwd)
echo Hello!

sudo apt-get install libapache2-mod-wsgi python-dev
sudo a2enmod wsgi 

echo Give your project a cool name...

read name
echo $name is a good choice
sleep 1
clear
echo note that your project will be automatically deployed to /var/www
sleep 1
clear
cd /var/www
sudo mkdir $name
cd $name
sudo mkdir $name
cd $name
sudo mkdir static templates
sudo cp $location/__init__.py .
sudo pip install virtualenv
sudo virtualenv venv
source venv/bin/activate
sudo pip install Flask
echo Ok everything is setup!
deactivate
sleep 1
clear
echo Lets configure Apache now!
sleep 1
clear
cd /etc/apache2/sites-available
sudo touch $name.conf
sudo chmod 0777 $name.conf
sudo echo "<VirtualHost *:80>
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
sudo a2ensite $name
cd /var/www/$name
sudo touch $name.wsgi
sudo chmod 0777 $name.wsgi
sudo echo "#!/usr/bin/python
python_home = '/var/www/$name/$name/venv'
activate_this = python_home + '/bin/activate_this.py'
execfile(activate_this, dict(__file__=activate_this))
import sys
import logging
logging.basicConfig(stream=sys.stderr)
sys.path.insert(0,\"/var/www/$name/\")

from $name import app as application
application.secret_key = '$USER'">> $name.wsgi
sudo service apache2 restart
