
SET FOREIGN_KEY_CHECKS=0;


-- ----------------------------
-- Table structure for user_tmp
-- ----------------------------
DROP TABLE IF EXISTS `user_tmp`;
CREATE TABLE `user_tmp` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `version` bigint(20) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `external_id` varchar(64) DEFAULT NULL,
  `messenger_id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `picture` varchar(500) DEFAULT NULL,
  `last_conversation` datetime DEFAULT NULL,
  `company_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK76c09528e5ce132c9d3f9c578863` (`messenger_id`,`external_id`),
  KEY `FK2yuxsfrkkrnkn5emoobcnnc3r` (`company_id`)
) ENGINE=InnoDB AUTO_INCREMENT=194510 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Procedure structure for CM_1_CopyUsers
-- ----------------------------
DROP PROCEDURE IF EXISTS `CM_1_CopyUsers`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CM_1_CopyUsers`(`company_id_old` int,`company_id_new` int,`messenger_id_old` int,`messenger_id_new` int)
BEGIN
	insert into user_tmp 
	select * from user b where b.company_id=company_id_old and b.messenger_id= messenger_id_old;
	
	update user_tmp set 
	company_id = company_id_new, messenger_id = messenger_id_new;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for CM_2_UsersToNewCompany
-- ----------------------------
DROP PROCEDURE IF EXISTS `CM_2_UsersToNewCompany`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CM_2_UsersToNewCompany`(`company_id_new` int,`messenger_id_new` int,`extra_field_id_old` int,`extra_field_id_new` int)
BEGIN
	
		DECLARE fin INT;
    DECLARE id_contact BIGINT;
    DECLARE n INT DEFAULT 0;
    /*extra_field*/
    DECLARE version_ef BIGINT;
    DECLARE user_id_ef BIGINT;
    DECLARE extra_field_ef BIGINT DEFAULT extra_field_id_new; /*CORRESPONDE AL EXTRAFIELD DNI EN BBVA*/
    DECLARE value_ef VARCHAR(1024);
    DECLARE idnotfound INT;
    DECLARE count_contacts INT DEFAULT 0;
	
	/*seleccionar todos los registros que no existan en la tabla user de la compañia 38(BBVA)*/
    DECLARE contacts CURSOR FOR select A.id from user_tmp A 
								where not exists 
								(select 1 from user B 
                                where B.company_id=company_id_new and B.messenger_id = messenger_id_new
                                and (A.messenger_id=B.messenger_id and A.external_id=B.external_id));

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin=1;

    SET fin =0;
	OPEN contacts;

			

    /*bucle:LOOP*/
    bucle:LOOP
		FETCH NEXT FROM contacts into id_contact; /*tomo el id_del contacto*/
		IF fin=1 THEN LEAVE bucle;
		END IF;
	    
        BEGIN
        /*Busco en la tabla extra_field si el usuario tiene datos*/
			DECLARE CONTINUE HANDLER FOR NOT FOUND SET idnotfound = 1;
			SET idnotfound = 0;
			Select id from user_extra_field where user_id = id_contact and extra_field_id = extra_field_id_old  INTO n;
	        IF idnotfound = 0 THEN
                 
              Insert ignore into user(version, email, external_id, messenger_id, name, picture, last_conversation, company_id) 
			        select version, email, external_id, messenger_id, name, picture, last_conversation, company_id from user_tmp B where B.id= id_contact  ; 
			        commit;    
            
		      SELECT LAST_INSERT_ID() INTO user_id_ef;
					
					SET count_contacts = count_contacts + 1;
					
					SELECT version, user_id, value 
			    FROM user_extra_field WHERE user_id=id_contact and extra_field_id = extra_field_id_old
          INTO version_ef, user_id_ef, value_ef ;	
					
			    insert ignore into user_extra_field(version, user_id, extra_field_id, value)
				  values (version_ef, user_id_ef, extra_field_ef, value_ef);
          commit;

				else
                    Insert ignore into user(version, email, external_id, messenger_id, name, picture, last_conversation, company_id) 
			        select version, email, external_id, messenger_id, name, picture, last_conversation, company_id from user_tmp B where B.id= id_contact  ; 
			        commit;
	            END IF;
		END;      
	END LOOP;
	select count_contacts;
    CLOSE contacts;
    SET fin =0;

END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for CM_3_CleanTmp
-- ----------------------------
DROP PROCEDURE IF EXISTS `CM_3_CleanTmp`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CM_3_CleanTmp`()
BEGIN
	#Routine body goes here...
	TRUNCATE TABLE user_tmp;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for CM_ALL
-- ----------------------------
DROP PROCEDURE IF EXISTS `CM_ALL`;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CM_ALL`(`company_id_old` int,`company_id_new` int,`messenger_id_old` int,`messenger_id_new` int,`extra_field_id_old` int,`extra_field_id_new` int)
BEGIN
		
	#Limpio user_tmp
	call CM_3_CleanTmp();

	#Copio Usuarios
	call CM_1_CopyUsers(company_id_old,company_id_new,messenger_id_old,messenger_id_new);

	#importo usuarios
	call CM_2_UsersToNewCompany(company_id_new,messenger_id_new,extra_field_id_old,extra_field_id_new);

	#Limpio user_tmp
	call CM_3_CleanTmp();
END
;;
DELIMITER ;
