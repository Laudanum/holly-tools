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
	chown -R _www:_www $DOCROOT/$DOMAIN/content $DOCROOT/$DOMAIN/log
else
	echo "Document root $DOCROOT/$DOMAIN already exists."
fi

# mkdir $DOCROOT/$DOMAIN/versions/staging
# ln -s $DOCROOT/$DOMAIN/versions/staging $DOCROOT/$DOMAIN/staging

if [ ! -f $CONFDIR/*-local.$DOMAIN.conf ]
then
	echo "Creating config file in $CONFDIR/$DOMAIN.conf"
	cp $CONFDIR/_skel.conf.disabled $CONFDIR/25-local.$DOMAIN.conf
	sed -ie "s/xxx.xxx/$DOMAIN/g" $CONFDIR/25-local.$DOMAIN.conf
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
mysql -h 127.0.0.1 <<EOFMYSQL
CREATE DATABASE $SQLDB;
GRANT ALL PRIVILEGES ON $SQLDB.* TO '$SQLUSER'@'%' IDENTIFIED BY '$SQLPASS';
FLUSH PRIVILEGES;
EOFMYSQL

OUTPUT=$DOMAIN/SERVER.info
echo "# Server details for $DOMAIN" > $OUTPUT
echo DBNAME=$SQLDB >> $OUTPUT
echo DBUSER=$SQLUSER >> $OUTPUT
echo DBPASS=$SQLPASS >> $OUTPUT

cat $OUTPUT

echo "Updating hosts file."
echo "127.0.0.1 		local.$DOMAIN\n" >> /etc/hosts


echo "All done."
