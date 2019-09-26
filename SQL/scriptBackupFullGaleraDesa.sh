##Variables
DBUSER=nsolignac
DBPASS=Nico.123
BKPDIR=/dbdata/backups
DATE=`date +%Y%m%d`
LOGFILE=/dbdata/backups/$DATE.log

echo "Inicio del Backup full Galera Desarollo (`date +%H:%M:%S`)" >> $LOGFILE

if [ -f /dbdata/backups/ListOfDatabases1.txt ]; then
       touch /dbdata/backups/ListOfDatabases1.txt
        mkdir $BKPDIR/$DATE
        cd $BKPDIR/$DATE

##Por cada DB  de la Lista genero el sql usando mysqldump
        for DB in `cat /dbdata/backups/ListOfDatabases1.txt`; do

                mysqldump -u $DBUSER -p$DBPASS --opt --routines --triggers --events --single-transaction --no-tablespaces --databases ${DB} | gzip > ${DB}.sql.gz

        done

        echo "Fin del Backup full Galera Desarollo (`date +%H:%M:%S`)" >> $LOGFILE

else
        echo "La lista de base de datos no está en el directorio (ListOfDatabases1.txt)" >> $LOGFILE

fi
