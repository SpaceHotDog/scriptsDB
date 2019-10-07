#! /bin/bash

# SOURCES:
# https://stackoverflow.com/questions/12040816/mysqldump-in-csv-format
# https://dba.stackexchange.com/questions/39462/importing-mysql-dump-to-sql-server-2012
# https://www.computerhope.com/unix/usplit.htm
# https://www.mkyong.com/linux/linux-how-to-gzip-a-folder/

### TODO ###
# OFFSET: El offset hace que no se registren los datos de las ultimas 3 tablas (empresa, nrolocalidad, nroprovincia) - !!DONE
# NAMING: Guardar los csv.gz usando tambien el nombre de la tabla (Variable $TBL) - !!DONE

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

    export ROWS=$(mysql -h$DBHOST -u$USER -p$PWD $DB -sN -e "SELECT COUNT(id) FROM $TBL;")
    export COUNTER=$((ROWS / 1000000 + 1) + 1)

    echo "COUNTER: $COUNTER" >> $LOGFILE
    echo "Comenzamos el dump de la tabla: '$TBL'" >> $LOGFILE

    while [ $COUNTER -ne 0 ]; do
        if [ $TBL = 'celulares' ]
        then
            mysql -B -h$DBHOST -u$USER -p$PWD -e "SELECT nrodoc, linea, localidad_id, provincia_id FROM $TBL LIMIT 1000000 OFFSET $OFFSET;" $DB | sed "s/\"/\"\"/g;s/'/\'/;s/\t/\",\"/g;s/^/\"/;s/$/\"/;s/\n//g" | gzip > $DB'-'$DATE'-'$TBL'-'$OFFSET.csv.gz
        else
            let OFFSET=0

            mysql -B -h$DBHOST -u$USER -p$PWD -e "SELECT * FROM $TBL LIMIT 1000000 OFFSET $OFFSET;" $DB | sed "s/\"/\"\"/g;s/'/\'/;s/\t/\",\"/g;s/^/\"/;s/$/\"/;s/\n//g" | gzip > $DB'-'$DATE'-'$TBL'-'$OFFSET.csv.gz
        fi

        echo "Fin del Dump de la tabla: '$TBL' - Ciclos restantes: $COUNTER - OFFSET: $OFFSET" >> $LOGFILE

        let COUNTER-=1
        let OFFSET+=1000000
    done

    let N+=1
    echo "Fin del dump de la tabla: '$TBL' - Vuelta $N" >> $LOGFILE
done

# Comprimimos los archivos
echo "Comprimimos la carpeta WORKDIR: '$WORKDIR'" >> $LOGFILE
cd ..
tar -zcvf $WORKDIR.tar.gz $WORKDIR/
