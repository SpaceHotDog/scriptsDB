-- MySQL DUMP AND DELETE BY SUBQUERY
-- SOURCES:
-- https://stackoverflow.com/questions/935556/mysql-dump-by-query
-- https://www.tutorialspoint.com/mysql-select-from-a-subquery-and-then-perform-delete


mysqldump -h "192.168.33.160" -u nsolignac -p --databases opticom2 --tables MCP_notifications --where='fecha BETWEEN "2016-01-01" AND "2016-12-31"' | gzip > /tmp/opticom2_MCP_notifications.sql.gz

DELETE FROM opticom2.MCP_notifications WHERE fecha BETWEEN "2016-01-01" AND "2016-12-31";