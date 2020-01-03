#!/bin/bash

##Variables
DBUSER=backupUser
DBPASS=backup.3135
BKPDIR=/backupstg/galera-audios
DATE=`date +%Y%m%d`
LOGFILE=/backupstg/galera-audios/$DATE.log


echo "------------I N I C I O   B A C K U P (`date +%H:%M:%S`)-----------" >> $LOGFILE

if [ -f /var/lib/scripts/Lista.txt ]; then

        mkdir $BKPDIR/$DATE
        cd $BKPDIR/$DATE

        ##Por cada DB  de la Lista genero el sql usando mysqldump
        for DB in `cat /var/lib/scripts/Lista.txt`; do

                mysqldump -u $DBUSER -p$DBPASS --opt --routines --triggers --events --single-transaction --no-tablespaces --databases ${DB} | gzip > ${DB}.sql.gz

        done

        echo "Fin del Backup Full 192.168.34.126 (`date +%H:%M:%S`)" >> $LOGFILE

else
        echo "La lista de base de datos a respaldar no estaba en el directorio (Lista.txt)" >> $LOGFILE

    mysql -u $DBUSER -p$DBPASS -e "SHOW DATABASES;" > /var/lib/scripts/Lista.txt
    echo "La lista de base de datos se generó nuevamente, ejecute una vez mas el respaldo" >> $LOGFILE
fi

echo "------------F I N     B A C K U P (`date +%H:%M:%S`)-----------" >> $LOGFILE

##Respaldo usuarios y permisos

mysql -u$DBUSER -p$DBPASS -e "call mysql.export_users_perm();"
echo "Se respaldan los usuarios y permisos" >> $LOGFILE

mv /var/lib/scripts/perm_usu/usuarios.txt $BKPDIR/$DATE/usuarios.txt
mv /var/lib/scripts/perm_usu/permisos.txt $BKPDIR/$DATE/permisos.txt
mv /var/lib/scripts/perm_usu/permisos_tablas.txt $BKPDIR/$DATE/permisos_tablas.txt
mv /var/lib/scripts/perm_usu/permisos_procedimientos.txt $BKPDIR/$DATE/permisos_procedimientos.txt


##Mantenemos 2 días
for i in `find $BKPDIR -maxdepth 1 -type d -mtime +2 -print`
do
  echo -e "Borrando respaldo $i";  >> $LOGFILE
   rm -rf $i;
done
echo "Finalizó mantenimiento de $BKPDIR directorios bk (`date +%H:%M:%S`)" >> $LOGFILE

for f in `find $BKPDIR -maxdepth 1 -type f -mtime +2 -print`
do
  echo -e "Borrando log $f";  >> $LOGFILE
   rm -rf $f;
done
echo "Finalizó mantenimiento de $BKPDIR archivos log (`date +%H:%M:%S`)" >> $LOGFILE

mail -s "Resultado BKP" tecnologia@sondeos.com.ar < $LOGFILE
