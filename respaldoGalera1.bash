#!/bin/bash

##Variables
DBUSER=backupUser
DBPASS=backup.3135
BKPDIR=/backupstg/galera_reportes
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

## Si la lista de DB's existe: Inicio proceso de respaldo
if [ -f /dbdata/scripts/ListOfDatabases1.txt ]; then
       touch /dbdata/scripts/ListOfDatabases1.txt
        mkdir $BKPDIR/$DATE
        cd $BKPDIR/$DATE

##Por cada DB  de la Lista genero el sql usando mysqldump
        for DB in `cat /dbdata/scripts/ListOfDatabases1.txt`; do

                mysqldump -u $DBUSER -p$DBPASS --opt --routines --triggers --events --single-transaction --no-tablespaces --databases ${DB} | gzip > ${DB}.sql.gz

        done

        echo "Fin del Backup full Galera reportes (`date +%H:%M:%S`)" >> $LOGFILE

else
        echo "La lista de base de datos no está en el directorio (ListOfDatabases1.txt)" >> $LOGFILE

fi

## Conecto el nodo de nuevo al cluster MySQL
mysql -h192.168.33.121 -u $DBUSER -p$DBPASS -e "set global wsrep_desync=OFF;"
echo "Nodo03 Conectado al cluster (`date +%H:%M:%S`)" >> $LOGFILE

# Conecto el nodo al balanceador
ssh 192.168.33.61 "cd /etc/haproxy/ && mv haproxy.cfg MODBK.cfg && mv hacopy.cfg haproxy.cfg && service haproxy restart && exit"
echo "Conectado nodo03 al balanceador 192.168.33.61 (`date +%H:%M:%S`)" >> $LOGFILE
sleep 5s
ssh 192.168.33.62 "cd /etc/haproxy/ && mv haproxy.cfg MODBK.cfg && mv hacopy.cfg haproxy.cfg && service haproxy restart && exit"
echo "Conectado nodo03 al balanceador 192.168.33.62 (`date +%H:%M:%S`)" >> $LOGFILE

#Respaldo los usuarios y permisos
cd $BKPDIR

mysql -u$DBUSER -p$DBPASS -e "call mysql.export_users_perm();"
echo "Se respaldaron los usuarios y permisos" >> $LOGFILE

mv usuarios.txt $BKPDIR/$DATE/usuarios.txt
mv permisos.txt $BKPDIR/$DATE/permisos.txt
mv permisos_tablas.txt $BKPDIR/$DATE/permisos_tablas.txt
mv permisos_procedimientos.txt $BKPDIR/$DATE/permisos_procedimientos.txt 

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

#mail-s "Resultado BCK Galera" cleyvic.toro@sondeos.com.ar < $LOGFILE
