#!/bin/bash

# SOURCE: https://dev.mysql.com/doc/mysql-replication-excerpt/5.7/en/replication-howto-mysqldump.html
# CFG TO FILE SOURCE: https://www.linode.com/docs/databases/mysql/use-mysqldump-to-back-up-mysql-or-mariadb/#automate-backups-with-cron
# EXCLUDE TABLES: https://dev.mysql.com/doc/refman/5.7/en/mysqlpump.html#option_mysqlpump_exclude-tables

echo "NOMBRE DE LA DB ORIGEN:"
read DBO
echo "NOMBRE DE LA DB DESTINO:"
read DBD
echo "IP SERVER DESTINO:"
read SVD
echo "IP SERVER ORIGEN:"
read SVO
echo "USUARIO DB:"
read USERDB
echo "USUARIO SSH:"
read USERSSH

mysqldump -h$SVO -u$USERDB -p --opt --routines --triggers --events --single-transaction --no-tablespaces --ignore-tables= ${DBO} | gzip > ./${DBO}.sql.gz

| BATCH_JOB_EXECUTION             |
| BATCH_JOB_EXECUTION_CONTEXT     |
| BATCH_JOB_EXECUTION_PARAMS      |
| BATCH_JOB_EXECUTION_SEQ         |
| BATCH_JOB_INSTANCE              |
| BATCH_JOB_SEQ                   |
| BATCH_STEP_EXECUTION            |
| BATCH_STEP_EXECUTION_CONTEXT    |
| BATCH_STEP_EXECUTION_SEQ        |

DBSIZE=$(du -hs ./$DBO.sql.gz)
echo "El archivo dump de la DB $DBO, pesa: $DBSIZE MB"

scp $DBO.sql.gz $USERSSH@$SVD:/tmp

mysql -h$SVD -u$USERDB -p -e "CREATE DATABASE $DBD CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';"
