CREATE DEFINER=`ederep`@`192.168.%` PROCEDURE `campania`.`common_reportesLlamados`(
    _idcampania INT(11),
    _fecha DATE
)
BEGIN
SELECT s.* From
(
 SELECT
    llO.id                  AS 'id',
    o.id                    AS 'Outid',
    llO.did                 AS 'numeroDestino',
    o.DATE                  AS 'fechaLlamado',
    o.STATE                 AS 'estadoLlamado',
    o.DURATION              AS 'duracion',
    llO.calls               AS 'cantLlamados',
    llP.valor               AS 'numeroCuenta'
 FROM
    CMP_OutBound o
 INNER JOIN
    CMP_LlamadosOld llO ON llO.id = o.O_VC_0
 INNER JOIN
    CMP_LlamadosParametros llP ON llO.id = llP.idLlamada
 AND
    (o.DATE like DATE_FORMAT(_fecha,'%Y-%m-%d %'))
 AND
    llO.id_campania = _idcampania
 AND
    llP.nombre = "cuenta"

UNION

 SELECT
    llO.id                  AS 'id',
    null                    AS 'Outid',
    llO.did                 AS 'numeroDestino',
    llO.date                AS 'fechaLlamado',
    if (llO.id_EstadoLLamada is null, 'FUERA_HORARIO', e.nombre)  AS 'estadoLlamado',
    null                    AS 'duracion',
    llO.calls               AS 'cantLlamados',
    llP.valor               AS 'numeroCuenta'
 FROM
    CMP_LlamadosOld llO
 JOIN
    CMP_EstadoLlamada e ON e.id = llO.id_EstadoLLamada
 INNER JOIN
    CMP_LlamadosParametros llP ON llO.id = llP.idLlamada
 WHERE
    llO.id_campania = _idcampania
 AND
    llO.calls = 0
 AND
    llP.nombre = "cuenta"
) s
ORDER BY s.id, s.fechaLlamado ASC
;
END
