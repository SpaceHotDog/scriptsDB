/*
SOURCE: https://www.a2hosting.com/kb/developer-corner/mysql/determining-the-size-of-mysql-databases-and-tables
*/

SELECT table_schema AS "Database",
ROUND(SUM(data_length + index_length) / 1024 / 1024 / 1024, 2) AS "Size (GB)"
FROM information_schema.TABLES
GROUP BY table_schema;

SELECT table_name, engine, row_format, table_rows,
ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "size (mb)"
FROM information_schema.tables
WHERE table_schema = "<database>" 
ORDER BY (data_length + index_length)
DESC;
