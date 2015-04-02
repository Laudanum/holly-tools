#!/bin/bash

DOMAIN=$1
DOCROOT=/srv/www
CONFDIR=/etc/apache2/other

if [ ! $DOMAIN ]
then
  echo "Please specify a domain name as the first argument."
  exit
fi

echo Removing site $DOMAIN

if [ -d $DOCROOT/$DOMAIN ]
then
  echo "Removing directory for $DOCROOT/$DOMAIN"
  sudo rm -Rf $DOCROOT/$DOMAIN
fi

if [ -f $CONFDIR/*-local.$DOMAIN.conf ]
then
  echo "Removing $CONFDIR/25-local.$DOMAIN.conf"
  sudo rm $CONFDIR/25-local.$DOMAIN.conf
  echo -n "Apache control: "
  /usr/sbin/apachectl configtest
fi

BASENAME=`echo $DOMAIN | cut -d. -f1`
SQLDB=${BASENAME}_local
SQLUSER=$BASENAME
[ ${#SQLUSER} -gt 15 ] && SQLUSER=${SQLUSER:0:15}

echo "Dropping MySQL database $SQLDB and user $SQLUSER"
mysql -uroot -h 127.0.0.1 <<EOFMYSQL
DROP DATABASE $SQLDB;
DROP USER $SQLUSER;
EOFMYSQL

sudo echo "Please remove local.$DOMAIN from /etc/hosts file."
# Doesn't work
# sudo sed -i '' '/local."$DOMAIN"/d' /etc/hosts


echo "All done."
