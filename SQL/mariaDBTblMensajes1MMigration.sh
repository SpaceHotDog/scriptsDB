#!/bin/bash

: <<'END'
SOURCES
-------
DATE FORMATING:
https://unix.stackexchange.com/questions/49053/linux-add-x-days-to-date-and-get-new-virtual-date
https://unix.stackexchange.com/questions/230464/how-to-format-date-output-with-spaces-as-variable-in-script
END

# Variables
IPO=192.168.9.163
IPD=192.168.33.80
DBO=esme
DBD=THISISATEST
TABLE=Tbl_Mensajes_1M
DBUSER=nsolignac
DBPASS=Nico.123
BKPDIR=
DATE=`date "+%Y-%m-%d %H:%M:%S"`
LOGFILE=$TABLE-$DATE.log

echo "----------------INICIO DUMP DE LA TABLA $TABLE (`date +%H:%M:%S`)----------------" >> $LOGFILE

mysqldump -h$IPO -u$DBUSER -p$DBPASS --opt --single-transaction --no-tablespaces --skip-triggers --no-create-info --where="date BETWEEN now() AND now() - INTERVAL 1 HOUR" --databases $DBO --tables $TABLE | gzip > $DBO.sql.gz

echo "----------------INICIO IMPORT DE LA TABLA $TABLE EN $DBD DEL DIA (`date +%H:%M:%S`)----------------" >> $LOGFILE
