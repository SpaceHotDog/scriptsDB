#!/bin/bash
PASSWORD=XXXXXX
HOST=XXXXXX
USER=XXXXXX
DATABASE=databasename
DB_FILE=dump.sql
DB_DDL=DDL.sql
EXCLUDED_TABLES=(
table1
table2
table3
table4
tableN
)

IGNORED_TABLES_STRING=''
for TABLE in "${EXCLUDED_TABLES[@]}"
do :
   IGNORED_TABLES_STRING+=" --ignore-table=${DATABASE}.${TABLE}"
done

echo "Dump structure - DDL"
mysqldump --host=${HOST} --user=${USER} --password=${PASSWORD} --single-transaction --no-data --routines ${DATABASE} > ${DB_DDL}

echo "Dump content - DATA"
mysqldump --host=${HOST} --user=${USER} --password=${PASSWORD} ${DATABASE} --no-create-info --skip-triggers ${IGNORED_TABLES_STRING} >> ${DB_FILE}
