# SOURCE:
# https://stackoverflow.com/questions/356578/how-to-output-mysql-query-results-in-csv-format

mysql -h"ip" -u"user" -p -B your_database -e "query" | sed "s/'/\'/;s/\t/\",\"/g;s/^/\"/;s/$/\"/;s/\n//g" > out.csv

mysql -h"ip" -u"user" -p -B your_database < script.sql | sed "s/'/\'/;s/\t/\",\"/g;s/^/\"/;s/$/\"/;s/\n//g" > out.csv
