SELECT index_schema,
       index_name,
       group_concat(column_name ORDER BY seq_in_index) AS index_columns,
       index_type,
       CASE non_unique
            WHEN 1 THEN 'Not Unique'
            ELSE 'Unique'
            END AS is_unique,
        table_name
FROM information_schema.statistics
WHERE table_schema NOT IN ('information_schema', 'mysql',
                           'performance_schema', 'sys')
GROUP BY index_schema,
         index_name,
         index_type,
         non_unique,
         table_name
ORDER BY index_schema,
         index_name;
