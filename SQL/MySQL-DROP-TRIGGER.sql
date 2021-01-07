-- No es posible realizar un DROP TRIGGER sin romper la TRANSACTION debido al  'implicit commit'
-- https://dev.mysql.com/doc/refman/8.0/en/implicit-commit.html
-- Como alternativa usamos el LOCK TABLE 'table' WRITE
-- https://stackoverflow.com/questions/19126562/alter-mysql-trigger-within-transaction

SET autocommit = 0;

LOCK TABLES `suscripcion` WRITE;

START TRANSACTION;

UPDATE suscripcion sus INNER JOIN bitel_fix bf ON bf.transid = sus.external_suscription_id SET sus.fecha_baja = bf.fecha WHERE bf.transid = sus.external_suscription_id AND sus.estado = 3 AND sus.canal_baja = 'FIX';

COMMIT;

DELIMITER $$
  DROP TRIGGER Hermes.`agregarFechaBaja` $$
  CREATE DEFINER=`analista`@`192.168.%` TRIGGER agregarFechaBaja

  BEFORE UPDATE ON suscripcion
  FOR EACH ROW
  BEGIN
  IF new.estado = 3
  THEN
  set new.fecha_baja = now();
  END IF;
  END;
  $$
DELIMITER ;

UNLOCK TABLES;

SET autocommit = 1;
