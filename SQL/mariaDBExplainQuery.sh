echo "IP del Servidor a consultar"
read SRV

echo "Inserte la QUERY sin comillas y con ';'"
read QUERY

mysql -h$SRV -unsolignac -p MC -e "$QUERY"
