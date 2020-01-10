#!/bin/bash

## Variables
DBUSER=backupUser
DBPASS=backup.3135
BKPDIR=/backupstg/galera_reportes/mariabackup
DATE=`date +%Y%m%d`
LOGFILE=/backupstg/galera_reportes/$DATE.log


echo "----------------INICIO DESCONEXIONES DE NODO  (`date +%H:%M:%S`)-----------" >> $LOGFILE

## Desconectar al nodo del balanceador 61
ssh 192.168.33.61 "cd /etc/haproxy/ && mv haproxy.cfg hacopy.cfg && mv MODBK.cfg haproxy.cfg && service haproxy restart && exit"
sleep 10s
echo "... Desconectado nodo02 de balanceador 192.168.33.61 (`date +%H:%M:%S`)" >> $LOGFILE
## Desconectar al nodo del balanceador 62
ssh 192.168.33.62 "cd /etc/haproxy/ && mv haproxy.cfg hacopy.cfg && mv MODBK.cfg haproxy.cfg && service haproxy restart && exit"
sleep 10s
echo "... Desconectado nodo02 de balanceador 192.168.33.62 (`date +%H:%M:%S`)" >> $LOGFILE

echo "... Desconectado nodo02 de balanceadores para ejecutar respaldo (`date +%H:%M:%S`)" >> $LOGFILE

## Desconectar el nodo del cluster
mysql -h192.168.33.121 -u $DBUSER -p$DBPASS -e "set global wsrep_desync=ON;"
echo "... Desconectado nodo02 del cluster galera para ejecutar respaldo (`date +%H:%M:%S`)" >> $LOGFILE

echo "----------------INICIO BACKUP FULL DB GALERA reportes (`date +%H:%M:%S`)----------------" >> $LOGFILE
mkdir $BKPDIR/$DATE

mariabackup --backup --galera-info --no-timestamp \
   --target-dir=$BKPDIR/$DATE \
   --user=$DBUSER --password=$DBPASS

if [ $! -eq 0 ]; then
    echo "Fin del Backup full Galera reportes (`date +%H:%M:%S`)" >> $LOGFILE
else
    echo "No se pudo realizar el Backup (`date +%H:%M:%S`)" >> $LOGFILE

## Conecto el nodo de nuevo al cluster MySQL
mysql -h192.168.33.121 -u $DBUSER -p$DBPASS -e "set global wsrep_desync=OFF;"
echo "Nodo03 Conectado al cluster (`date +%H:%M:%S`)" >> $LOGFILE

# Conecto el nodo al balanceador
ssh 192.168.33.61 "cd /etc/haproxy/ && mv haproxy.cfg MODBK.cfg && mv hacopy.cfg haproxy.cfg && service haproxy restart && exit"
echo "Conectado nodo03 al balanceador 192.168.33.61 (`date +%H:%M:%S`)" >> $LOGFILE
sleep 5s
ssh 192.168.33.62 "cd /etc/haproxy/ && mv haproxy.cfg MODBK.cfg && mv hacopy.cfg haproxy.cfg && service haproxy restart && exit"
echo "Conectado nodo03 al balanceador 192.168.33.62 (`date +%H:%M:%S`)" >> $LOGFILE


echo "------------F I N   B A C K U P   G A L E R A (`date +%H:%M:%S`)-----------" >> $LOGFILE

##Mantenemos 2 días
for i in `find $BKPDIR -maxdepth 1 -type d -mtime +2 -print`
do
   rm -Rf $i;
done
echo "Finalizó mantenimiento de $BKPDIR directorios bk (`date +%H:%M:%S`)" >> $LOGFILE

for f in `find $BKPDIR -maxdepth 1 -type f -mtime +2 -print`
do

   rm -f $f;
done
echo "Finalizó mantenimiento de $BKPDIR archivos log (`date +%H:%M:%S`)" >> $LOGFILE

mail -s "Resultado BCK Galera" tecnologia@sondeos.com.ar < $LOGFILE
