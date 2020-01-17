#!/bin/bash

## Variables
DBUSER=backupUser
DBPASS=backupUser.31
BKPDIR=/dbdata/mariabackup
DATE=`date +%Y%m%d`
LOGFILE=/dbdata/mariabackup/$DATE.log

echo "----------------INICIO BACKUP (`date +%H:%M:%S`)----------------" >> $LOGFILE
mkdir $BKPDIR/$DATE

mariabackup --backup --galera-info --no-timestamp \
   --target-dir=$BKPDIR/$DATE \
   --user=$DBUSER --password=$DBPASS

if [ $! -eq 0 ]; then
    echo "Fin del Backup (`date +%H:%M:%S`)" >> $LOGFILE
else
    echo "No se pudo realizar el Backup (`date +%H:%M:%S`)" >> $LOGFILE


echo "------------F I N   B A C K U P (`date +%H:%M:%S`)-----------" >> $LOGFILE

##Mantenemos 2 días
for i in `find $BKPDIR -maxdepth 1 -type d -mtime +2 -print`
do
   rm -Rf $i;
done
echo "Finalizó mantenimiento de $BKPDIR directorios bkp (`date +%H:%M:%S`)" >> $LOGFILE

for f in `find $BKPDIR -maxdepth 1 -type f -mtime +2 -print`
do

   rm -f $f;
done
echo "Finalizó mantenimiento de $BKPDIR archivos log (`date +%H:%M:%S`)" >> $LOGFILE
