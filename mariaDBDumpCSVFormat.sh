#! /bin/bash

# SOURCES:
# https://stackoverflow.com/questions/12040816/mysqldump-in-csv-format
# https://dba.stackexchange.com/questions/39462/importing-mysql-dump-to-sql-server-2012
# https://www.computerhope.com/unix/usplit.htm
# https://www.mkyong.com/linux/linux-how-to-gzip-a-folder/

# Creamos y nos movemos al entorno de trabajo
export DB="celulares_2019"
export DATE=`date +%Y%m%d`
export WORKDIR=$DB'-'$DATE
export LOGFILE=$DB'-'$DATE.log

mkdir $WORKDIR
cd $WORKDIR/

# Definimos otras variables
export DBHOST="192.168.33.80"
export USER="celulares_admin"
export PWD="celuser.3135"
export N=0
export OFFSET=0

# Comenzamos el DUMP
echo "Comenzamos el proceso" >> $LOGFILE

for TBL in $(mysql -h$DBHOST -u$USER -p$PWD $DB -sN -e "SHOW TABLES;"); do

    export QUERY=$(mysql -h$DBHOST -u$USER -p$PWD $DB -sN -e "SELECT COUNT(id) FROM $TBL;")
    export COUNTER=$((QUERY / 1000000 + 1))

    echo "COUNTER: $COUNTER" >> $LOGFILE
    echo "Comenzamos el dump de la tabla: '$TBL'" >> $LOGFILE

    while [ $COUNTER -ne 0 ]; do
        mysql -B -h$DBHOST -u$USER -p$PWD -e "SELECT * FROM $TBL LIMIT 1000000 OFFSET $OFFSET;" $DB | sed "s/\"/\"\"/g;s/'/\'/;s/\t/\",\"/g;s/^/\"/;s/$/\"/;s/\n//g" | gzip > $DB'-'$DATE'-'$OFFSET.sql.gz

        let COUNTER-=1
        let OFFSET+=1000000
        echo "Dump de la tabla: '$TBL' - Iteracion Num: $COUNTER" >> $LOGFILE
    done

    let N+=1
    echo "Fin del dump de la tabla: '$TBL' - Vuelta $N" >> $LOGFILE
done

# Comprimimos los archivos
cd ..
tar -zcvf $WORKDIR.tar.gz $WORKDIR/
