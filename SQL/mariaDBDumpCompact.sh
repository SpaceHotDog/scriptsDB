mysqldump -h192.168.10.93 -unsolignac -p mc_demo strategy --compact --no-tablespaces --single-transaction --no-create-info --lock-tables=false > mc_demo_tables_2.sql.gz
