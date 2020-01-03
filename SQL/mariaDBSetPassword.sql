UPDATE mysql.user SET Password=PASSWORD('analista.3135') WHERE User='analista' AND Host='192.168.%';
FLUSH PRIVILEGES;
