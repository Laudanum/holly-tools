# call with sudo ./_skel.sh example.com

DOMAIN=$1
DOCROOT=/srv/www
CONFDIR=/etc/apache2/other

if [ ! $DOMAIN ]
then
	echo "Please specify a domain name as the first argument."
	exit
fi

echo "Setting up skeleton for $DOMAIN"

if [ ! -d $DOCROOT/$DOMAIN ]
then
	echo "Creating directories in $DOCROOT/$DOMAIN"
	mkdir -p $DOCROOT/$DOMAIN/local \
		$DOCROOT/$DOMAIN/content \
		$DOCROOT/$DOMAIN/log \
		$DOCROOT/$DOMAIN/backup \
		$DOCROOT/$DOMAIN/versions
	sudo chown -R _www:_www $DOCROOT/$DOMAIN/content $DOCROOT/$DOMAIN/log
else
	echo "Document root $DOCROOT/$DOMAIN already exists."
fi

# mkdir $DOCROOT/$DOMAIN/versions/staging
# ln -s $DOCROOT/$DOMAIN/versions/staging $DOCROOT/$DOMAIN/staging

if [ ! -f $CONFDIR/*-local.$DOMAIN.conf ]
then
	echo "Creating config file in $CONFDIR/$DOMAIN.conf"
	sudo sed -e "s/xxx.xxx/$DOMAIN/g" $CONFDIR/_skel.conf.disabled | sudo tee $CONFDIR/25-local.$DOMAIN.conf > /dev/null
	echo -n "Apache control: "
	/usr/sbin/apachectl configtest
else
	echo "$CONFDIR/$DOMAIN.conf already exists."
fi


BASENAME=`echo $DOMAIN | cut -d. -f1`
SQLUSER=$BASENAME
[ ${#SQLUSER} -gt 15 ] && SQLUSER=${SQLUSER:0:15}
SQLPASS=`mkpasswd -l 12 -s 0`

SQLDB=${BASENAME}_local
mysql -uroot -h 127.0.0.1 <<EOFMYSQL
CREATE DATABASE $SQLDB;
GRANT ALL PRIVILEGES ON $SQLDB.* TO '$SQLUSER'@'localhost' IDENTIFIED BY '$SQLPASS';
FLUSH PRIVILEGES;
EOFMYSQL

OUTPUT=$DOCROOT/$DOMAIN/SERVER.info
echo "# Server details for $DOMAIN" > $OUTPUT
echo DBNAME=$SQLDB >> $OUTPUT
echo DBUSER=$SQLUSER >> $OUTPUT
echo DBPASS=$SQLPASS >> $OUTPUT

cat $OUTPUT

echo "Updating hosts file."
echo "127.0.0.1 		local.$DOMAIN
" | sudo tee -a /etc/hosts
# sudo sh -c 'echo "127.0.0.1 		local.${DOMAIN}\n" >> /etc/hosts'

echo "All done. Please run sudo apachectl graceful to start using local.$DOMAIN."
