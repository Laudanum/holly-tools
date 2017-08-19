#!/bin/bash
# https://blog.studiointeract.com/mongodump-and-mongorestore-for-mongodb-in-a-docker-container-8ad0eb747c62

DEST=/srv/www/backup/mongo
DATE=`eval date +%Y%m%d-%H%M`
DOCKER_NAME=mongodb
MOUNT_POINT=backup

mkdir -p ${DEST}/${DATE}

sudo docker run  --rm  --link mongo:mongo  -v ${DEST}/${DATE}:/${MOUNT_POINT}  mongo  bash -c 'mongodump --out /'${MOUNT_POINT}' --host $MONGO_PORT_27017_TCP_ADDR'

