USE ministerio_seguridad;

DROP TABLE IF EXISTS `Prueba_Lotes`;

CREATE TABLE `Prueba_Lotes`(
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `Destino` bigint(20),
  `Mensaje` VARCHAR(130),
  primary key (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

LOAD DATA INFILE '/tmp/ReporteMensajesSalientes-campania-140454-1128.csv' INTO TABLE Prueba_Lotes FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n' (Destino, Mensaje);
