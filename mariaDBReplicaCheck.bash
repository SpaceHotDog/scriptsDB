#!/bin/bash


# Script encargado de monitorear la replicacion mutisource de mariadb para zabbix


# Genero lista con todas las replicas definidas en el servidor mariadb

replicas=(`mysql -uzabbix -e "show all slaves status\G" | grep Connection_name | awk '{print ""$2""}' | sed ':a;N;$!ba;s/\n/ /g'`)


# Recorro lista de replicas para chequear que todos las replicas esten corriendo

Replicas_Up()
{
	for i in ${replicas[@]}
		do
			slave_count=`mysql -uzabbix -e "set @@default_master_connection=$i;show slave status\G" | grep -A1 Slave_IO_Running | grep -i yes -c`
			if [ $slave_count -lt 2 ]
				then
					replicas_error+=($i)
			fi
		done

	if [ ${#replicas_error[@]} -eq 0 ]
		then
			echo "Replicas OK"
		else
			echo "ERROR hay replicas que no corren: ${replicas_error[@]}"
			echo "`date +%Y%m%d%H%M`-ERROR hay replicas que no corren" >> /tmp/logdereplicas.log
	fi
}

Logs_Files_Check()
{
	for j in ${replicas[@]}
		do
			log_file=`mysql -uzabbix -e "set @@default_master_connection=$j;show slave status\G" | grep Log_File | grep -v relay | grep -v Until`
			log1=`echo $log_file | awk '{print $2}'`
			log2=`echo $log_file | awk '{print $4}'`
			if [ $log1 != $log2 ]
				then
					logs_error+=($j)
			fi
		done

	if [ ${#logs_error[@]} -eq 0 ]
		then
			echo "Logs replicas OK"
		else
			echo "ERROR hay replicas con logs restrasados: ${logs_error[@]}"
			echo "`date +%Y%m%d%H%M`-ERROR hay replicas con logs restrasados" >> /tmp/logdereplicas.log
	fi
}

Seconds_Check()
{
        for k in ${replicas[@]}
                do
                        seconds_delay=`mysql -uzabbix -e "set @@default_master_connection=$k;show slave status\G" | grep Seconds_Behind_Master`
                        seconds=`echo $seconds_delay | awk '{print $2}'`
                        if [ $seconds != 'NULL' ] && [ $seconds -gt 20000 ]
                                then
                                        seconds_error+=($k)
                        fi
                done

        if [ ${#seconds_error[@]} -eq 0 ]
                then
                        echo "Segundos replicas OK"
                else
                        echo "ERROR hay replicas con retraso de tiempo: ${seconds_error[@]}"
			echo "`date +%Y%m%d%H%M`-ERROR hay replicas con retraso de tiempo" >> /tmp/logdereplicas.log
        fi
}

Replicas_Up
Logs_Files_Check
Seconds_Check
