# SOURCES:
# https://dba.stackexchange.com/questions/46011/how-to-determine-master-in-mysql-master-slave
# MariaDB Replication: https://mariadb.com/kb/en/standard-replication/
# MySQL Troubleshooting Replication: https://dev.mysql.com/doc/refman/5.7/en/replication-problems.html

mysql -h192.168.34.121 -unsolignac -p -e "SELECT COUNT(1) SlaveThreadCount FROM information_schema.processlist WHERE user='system user';"
