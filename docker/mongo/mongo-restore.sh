#!/bin/bash
# https://blog.studiointeract.com/mongodump-and-mongorestore-for-mongodb-in-a-docker-container-8ad0eb747c62

DB_NAME=glam-tablet-dev
SRC=/srv/www/backup
DOCKER_NAME=mongodb
MOUNT_POINT=backup

sudo docker run  --rm  --link ${DOCKER_NAME}:mongo -v ${SRC}/${DB_NAME}:/${MOUNT_POINT} mongo bash -c 'mongorestore /'${MOUNT_POINT}' --drop --db '${DB_NAME}' --host $MONGO_PORT_27017_TCP_ADDR'
