#!/bin/zsh

# SERVERADMIN="benjamin.nicodeme@icloud.com"
# WEBCVGIT="https://github.com/NicodemeB/WebCV.git"
# DIRECTORY="WebCV"
# DOMAIN="nicode.me"

APACHEREDIRECT="\n\
		<Directory />\n\
			Options FollowSymLinks\n\
			AllowOverride None\n\
		</Directory>\n\
		ScriptAlias /cgi-bin/ /usr/lib/cgi-bin/\n\
		<Directory "/usr/lib/cgi-bin">\n\
			AllowOverride None\n\
			Options +ExecCGI -MultiViews +SymLinksIfOwnerMatch\n\
			Order allow,deny\n\
			Allow from all\n\
		</Directory>"


installWeb () {
	echo Y | apt install apache2 php7.0 php7.0-common libapache2-mod-php7.0	git

	cd /var/www/

	composeGithubURL

	echo $GITHUB_URL

	git clone $GITHUB_URL

	cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/$SITE_DIRECTORY-ssl.conf
	sed -i "/ServerAdmin/i \ServerName ${DOMAIN}" /etc/apache2/sites-available/$SITE_DIRECTORY-ssl.conf
	sed -i "s/ServerName/\t\tServerName/" /etc/apache2/sites-available/$SITE_DIRECTORY-ssl.conf

	sed -i "s|webmaster@localhost|${SERVER_ADMIN}|" /etc/apache2/sites-available/$SITE_DIRECTORY-ssl.conf
	sed -i "s|DocumentRoot /var/www/html|DocumentRoot /var/www/${SITE_DIRECTORY}|" /etc/apache2/sites-available/$SITE_DIRECTORY-ssl.conf

	sed -i "/${SITE_DIRECTORY}/a \ XXX" /etc/apache2/sites-available/$SITE_DIRECTORY-ssl.conf

	sed -i "s|XXX|${APACHEREDIRECT}|" /etc/apache2/sites-available/$SITE_DIRECTORY-ssl.conf

	# cat /etc/apache2/sites-available/$SITE_DIRECTORY-ssl.conf

	rm /var/www/html/index.html

	a2dissite 000-default.conf default-ssl.conf
	a2ensite $SITE_DIRECTORY-ssl.conf
	a2enmod ssl
	systemctl reload apache2

	display $BLUE INFO "apache2 installed and configured, installing letsencrypt"

	# add-apt-repository ppa:certbot/certbot
	# apt update

	# apt install python-certbot-apache

	# certbot --apache -d $DOMAIN -d www.$DOMAIN

}