mysql -B -h192.168.33.80 -unsolignac -p -e "select date(calldate) as fecha, FLOOR (dst) as destino, disposition as estado, billsec as segundos from froneuscdr.bit_cdr where date(calldate) between '2019-11-01' and '2019-11-31' and dstchannel like 'SIP/IPLAN%' and disposition = 'ANSWERED';" froneuscdr | sed "s/\"/\"\"/g;s/'/\'/;s/\t/\",\"/g;s/^/\"/;s/$/\"/;s/\n//g" | gzip > Froneus-CDR-112019.csv.gz