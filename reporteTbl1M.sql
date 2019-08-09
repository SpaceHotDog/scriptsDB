SELECT m.date, m.sourceAddress, m.destAddress, m.shortMessage
INTO OUTFILE '/dbdata/tbl1m.csv'
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n'
    case when m.IO='I' then 'MT'
     when m.IO='O' then 'MO' end as 'MT/MO',
    case when m.esmeID in(2,3) then 'Movistar'
         when m.esmeID in(6,7) then 'Nextel'
     when m.esmeID in(4,5) then 'Personal'
         when m.esmeID in(44) then 'Claro'
    end as 'Empresa'
    from Tbl_Mensajes_1M m
    where (m.sourceAddress = '72720' or m.destAddress = '72720')
    and m.date between '2019-07-25' and '2019-07-25 23:59:59');
