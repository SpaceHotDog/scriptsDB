#!/bin/bash

# SOURCE: https://dev.mysql.com/doc/mysql-replication-excerpt/5.7/en/replication-howto-mysqldump.html
# CFG TO FILE SOURCE: https://www.linode.com/docs/databases/mysql/use-mysqldump-to-back-up-mysql-or-mariadb/#automate-backups-with-cron

echo "NOMBRE DE LA DB"
read DBNAME
echo "IP SERVER DESTINO"
read SVD
echo "IP SERVER ORIGEN"
read SVO
echo "USUARIO LOGIN"
read USER

mysqldump -h$SVO -u$USER -p --opt --routines --triggers --events --single-transaction --no-tablespaces ${DBNAME} | gzip > ${DBNAME}.sql.gz

du -hs $DBNAME.sql.gz

scp $DBNAME.sql.gz $USER@$SVD:/tmp
