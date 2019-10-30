#!/bin/bash
## SOURCES ##
# https://mariadb.com/kb/en/library/manual-sst-of-galera-cluster-node-with-mariabackup/
# https://mariadb.com/kb/en/library/mariabackup-overview/
# https://www.symmcom.com/docs/how-tos/databases/how-to-recover-mariadb-galera-cluster-after-partial-or-full-crash

## TODO
#1 -
#2 -

echo "### INSTALO DEPENDENCIAS ###"
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash
sudo apt-get install mariadb-backup-10.1
echo "                            "

echo "### VAR DUMP ###"
echo "                "

VERSION=$(mariabackup --version)
echo "... MariaDB Version ..."
echo $VERSION
echo "                       "

MYSQL_BACKUP_DIR=/dbdata
echo "... Backups DIR ..."
echo $MYSQL_BACKUP_DIR
echo "                   "

SCRIPTS_DIR=$MYSQL_BACKUP_DIR/scripts/
echo "... Scripts DIR ..."
echo $SCRIPTS_DIR
echo "                   "

BACKUP_SCRIPT="respaldoGalera1.bash"
echo "... Backup Script ..."
echo $BACKUP_SCRIPT
echo "                   "

echo "... FULL BACKUP ..."
echo "                   "
/bin/bash $BACKUP_SCRIPT
echo "                   "

DATFILEPWD="/var/lib/mysql/"
echo "... ARCHIVO 'grastate.dat' EN DIRECTORIO: ..."
echo $DATFILEPWD
echo "                                             "
