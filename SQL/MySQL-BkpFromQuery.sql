-- SOURCE: https://stackoverflow.com/questions/935556/mysql-dump-by-query

mysqldump --databases X --tables Y --where="1 limit 1000000"

select * from MCP_notifications order by fecha ASC limit 1;