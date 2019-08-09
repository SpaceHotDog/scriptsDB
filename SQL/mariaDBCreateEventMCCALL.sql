CREATE EVENT mctruncateagencycontact
	ON SCHEDULE
		EVERY 1 DAY
		STARTS (TIMESTAMP(CURRENT_DATE) + INTERVAL 1 DAY + INTERVAL 12 HOUR)
	COMMENT 'JOB para el Truncado de la tabla "Agency Contact" de la DB MC - ID TT Mantis: 0074130'
	DO
		CALL MC.TruncateAgencyContact();

/*
TEST:
select current_timestamp() ,date_add(current_timestamp(), interval 13 day_hour);
*/
