-- SOURCES:
-- https://dba.stackexchange.com/questions/1229/how-do-you-calculate-mysql-max-connections-variable
-- http://www.mysqlcalculator.com/

SHOW VARIABLES LIKE '%buffer%';

/*
+-------------------------------------+----------------+
| Variable_name                       | Value          |
+-------------------------------------+----------------+
| aria_pagecache_buffer_size          | 134217728      |
| aria_sort_buffer_size               | 268434432      |
| bulk_insert_buffer_size             | 16777216       |
| innodb_buffer_pool_dump_at_shutdown | OFF            |
| innodb_buffer_pool_dump_now         | OFF            |
| innodb_buffer_pool_dump_pct         | 100            |
| innodb_buffer_pool_filename         | ib_buffer_pool |
| innodb_buffer_pool_instances        | 8              |
| innodb_buffer_pool_load_abort       | OFF            |
| innodb_buffer_pool_load_at_startup  | OFF            |
| innodb_buffer_pool_load_now         | OFF            |
| innodb_buffer_pool_populate         | OFF            |
| innodb_buffer_pool_size             | 2147483648     |
| innodb_change_buffer_max_size       | 25             |
| innodb_change_buffering             | all            |
| innodb_log_buffer_size              | 16777216       |
| innodb_sort_buffer_size             | 1048576        |
| join_buffer_size                    | 262144         |
| join_buffer_space_limit             | 2097152        |
| key_buffer_size                     | 65536          |
| mrr_buffer_size                     | 262144         |
| myisam_sort_buffer_size             | 134216704      |
| net_buffer_length                   | 16384          |
| preload_buffer_size                 | 32768          |
| read_buffer_size                    | 131072         |
| read_rnd_buffer_size                | 262144         |
| sort_buffer_size                    | 4194304        |
| sql_buffer_result                   | OFF            |
+-------------------------------------+----------------+
*/

SHOW VARIABLES LIKE '%buffer%';

-- Available RAM = Global Buffers + (Thread Buffers x max_connections)

-- Global Buffers: key_buffer_size(64), innodb_buffer_pool_size(2048), innodb_log_buffer_size(16), innodb_additional_mem_pool_size(1), net_buffer_size, query_cache_size(128)

-- Thread Buffers: sort_buffer_size(4), myisam_sort_buffer_size(134), read_buffer_size(0,13), join_buffer_size(0,26), read_rnd_buffer_size(0,26), thread_stack




-- max_connections = (Available RAM - Global Buffers) / Thread Buffers
-- ?? = (3965 - 2259) / 139
