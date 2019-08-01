#!/bin/bash

mysql -h192.168.10.93 --defaults-extra-file=/dbdata/scripts/.nsolignac.cnf -u nsolignac -e 'TRUNCATE TABLE mcqa.agency_contact;'
status=$?

if [ $status -eq 0 ]
    then
    echo "La operacion se realizo correctamente" | mail --config-verbose -s "Test" -H "nicolas.solignac@sondeos.com.ar" | echo ""
else
    echo "Hubo un error con la ejecucion" | mail --config-verbose -s "Test" -H "nicolas.solignac@sondeos.com.ar" | echo ""
fi
