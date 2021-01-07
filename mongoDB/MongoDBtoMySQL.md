                                            -----------------------------
                                            MongoDB to MySQL (And back!!)
                                            -----------------------------

SOURCES:
--------
https://dasini.net/blog/2019/04/02/mysql-json-document-store/

Docker:
-------
https://docs.docker.com/engine/reference/commandline/cp/
https://hub.docker.com/r/mysql/mysql-server

MongoDB:
--------
https://docs.mongodb.com/v4.0/reference/program/mongoexport/
https://docs.mongodb.com/v4.0/reference/program/mongoexport/#mongoexport-fields-example

MySQL:
------
https://mysqlserverteam.com/importing-data-from-mongodb-to-mysql-using-python/
https://mysqlserverteam.com/import-json-to-mysql-made-easy-with-the-mysql-shell/
https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-utilities.html
https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-utilities-json.html
https://dev.mysql.com/doc/internals/en/x-protocol.html

GO:
---
- MongoDB - Hacemos el export en el formato que sea (JSON, BSON o como en el Ej. CSV):
    mongoexport --host='192.168.33.113' --username='rootAdm' --password='L0thlori3n.13' --authenticationDatabase='admin' --db='celulares' --collection='celulares' --query '{"telco" : "claro"}' --limit='5' --type='csv' --fieldFile='/tmp/fields.txt' --out='/tmp/celulares_mongo_count_csv.csv'

- Docker - run mysql-server:latest
- Docker - logs - grep ... Buscamos PWD root
- Docker - exec & MySQL ALTER ... Cambiamos PWD y permitimos localhost login
- MySQL - CREATE DB ... Creamos la DB
- Docker - exec & mysqlsh --mx ... Conectamos sesion con protocolo X

Con export CSV:
----------------
- MySQL - CREATE table ... Creamos la tabla
    CREATE TABLE `celulares` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `numero` BIGINT DEFAULT 0 NOT NULL,
    `doc` BIGINT DEFAULT 0 NOT NULL,
    `localidad` VARCHAR(64),
    `telco` VARCHAR(64),
    `codigo_postal` INT,
    `provincia` VARCHAR(64),
    `partido` VARCHAR(64),
    PRIMARY KEY (`id`)
    );

- MySQL - mysql ... Importamos la data
    LOAD DATA INFILE '/tmp/celulares.csv' INTO TABLE celulares.celulares IGNORE FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES (numero,doc,localidad,telco,codigo_postal,provincia,partido);
- Como comando en segundo plano...
  nohup mysql -h"172.17.0.2" -uroot -p celulares -e"LOAD DATA INFILE '/tmp/celulares_mongo.csv' INTO TABLE celulares.celulares IGNORE FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES (numero,doc,localidad,telco,codigo_postal,provincia,partido);" &

Con export JSON:
----------------
- mysqlsh - importJson() .. Importamos archivo Json a una Collection en MySQL:
    util.importJson("/tmp/celulares_mongo_count.json", {"schema": "test", "collection": "celularesCol", "convertBsonOid": 1})

- MySQL - ALTER table ... Creamos las columnas para la data
    ALTER TABLE test.celularesCol ADD COLUMN doc INT GENERATED ALWAYS AS (doc->>"$.doc") VIRTUAL, WITH VALIDATION';

- MySQL - ALTER table ... Generamos los indices
    ALTER TABLE test.my_restaurants ADD INDEX cuisine_idx (cuisine);
    o
    CREATE INDEX celulares_doc_IDX USING BTREE ON celulares.celulares (doc);
    CREATE INDEX celulares_numero_IDX USING BTREE ON celulares.celulares (numero);
