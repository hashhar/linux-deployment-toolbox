#!/bin/sh

# Installing and accquiring packages {{{

INSTALL='sudo apt-get install -y'

# Apache2 and MySQL
$INSTALL apache2 mysql-server php-mysql
sudo mysql_secure_installation

# PHP and extensions required for MediaWiki
$INSTALL php libapache2-mod-php php-mcrypt php-intl php-gd php-xml php-mbstring php-apcu

# Download MediaWiki
echo "Where do you want to download MediaWiki tarball (leave empty to download to /tmp): "
read DOWNLOAD_DIR

curl https://releases.wikimedia.org/mediawiki/1.27/mediawiki-1.27.1.tar.gz -o "${DOWNLOAD_DIR='/tmp'}"

# }}}

# Extracting MediaWiki {{{

echo "Where do you want to install MediaWiki (leave empty to set it up under /var/www/html/mediawiki): "
read MEDIAWIKI_ROOT

tar xvf "$DOWNLOAD_DIR"/mediawiki-*.tar.gz
sudo mv "$DOWNLOAD_DIR"/mediawiki* "${MEDIAWIKI_ROOT='/var/www/html/mediawiki'}"

# }}}

# Setting up permissions and symlinks if needed {{{

TEMP="$MEDIAWIKI_ROOT"
while [ "$TEMP" != "/" ]; do
	PERM=$(stat --format=%A "$TEMP" | cut -c 8,10)
	if [ "$PERM" != "rx" ]; then
		echo "$TEMP is not readable by apache. Should I fix this? [y]/n"
		read choice
		if [ "${choice='y'}" = "y" ]; then
			sudo chmod o+rX "$TEMP"
		fi
	fi
	TEMP="$(dirname "$TEMP")"
done

TEMP="$MEDIAWIKI_ROOT"
SYMLINK_NEEDED=1
while [ "$TEMP" != "/" ]; do
	if [ "$TEMP" = "/var/www/html" ]; then
		SYMLINK_NEEDED=0
		break;
	fi
	TEMP="$(dirname "$TEMP")"
done

if [ $SYMLINK_NEEDED -eq 1 ]; then
	sudo ln -s "$MEDIAWIKI_ROOT" /var/www/html/mediawiki
fi

# }}}

# Configuring Apache {{{

# Set upload file size limits
sudo sed -i -e 's/upload_max_filesize\ =\ .*$/upload_max_filesize = 20M/g' /etc/php/7.0/apache2/php.ini

# }}}

# Configuring MySQL databases {{{

echo "Enter your mysql root user password: "
read password

echo "Enter the name for database user to manage the wiki: "
read dbuser

echo "Enter a password for the database user ${dbuser='wikiuser'}: "
read dbpass

SCRIPT=$(cat <<EOF
CREATE DATABASE wikidb;
GRANT ALL PRIVILEGES ON wikidb.* TO '${dbuser}'@'localhost' IDENTIFIED BY '${dbpass=password}';
EOF
)

rm ~/.mysql_history

mysql -u root --password="$password" << EOF
$SCRIPT
EOF

# }}}

# Start the MediaWiki setup {{{

firefox localhost/mediawiki

# }}}
