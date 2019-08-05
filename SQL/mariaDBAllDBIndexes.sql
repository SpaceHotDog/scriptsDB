SELECT index_schema,
       index_name,
       group_concat(column_name ORDER BY seq_in_index) AS index_columns,
       index_type,
       CASE non_unique
            WHEN 1 THEN 'Not Unique'
            ELSE 'Unique'
            END AS is_unique,
            /*
            REMEMBER TO SPECIFY PATH: INTO OUTFILE 'PATH-TO-SAVE-FILE'
            */
        table_name INTO OUTFILE '/tmp/mc_demo-Indexes.csv'
/* CSV FORMAT */
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM information_schema.statistics
/*
REMEMBER TO SPECIFY DB NAME: WHERE table_schema = 'db_name'
*/
WHERE table_schema = 'mc_demo'
GROUP BY index_schema,
         index_name,
         index_type,
         non_unique,
         table_name
ORDER BY index_schema,
         index_name;
