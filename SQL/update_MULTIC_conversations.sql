SELECT * FROM multic.conversation
WHERE company_id = '99' AND messenger_id = '197';

SELECT COUNT(id) FROM multic.conversation
WHERE company_id = '99' AND messenger_id = '197';

SELECT * FROM multic.conversation
WHERE company_id = '99' AND messenger_id = '197' AND last_updated >= NOW() - INTERVAL 50 DAY;

UPDATE multic.conversation
SET status = 'closed'
WHERE company_id = '99' AND messenger_id = '197' AND last_updated >= NOW() - INTERVAL 50 DAY;

UPDATE multic.conversation
SET last_activity = NOW(), status = 'closed'
WHERE company_id = '122';

UPDATE multic.conversation
SET last_activity = NOW(), status = 'closed'
WHERE company_id = '122' and status = 'available';

---

company_id = '134'
messenger_id = '265'
messenger_id = '197'

UPDATE multic.conversation
SET status = 'closed'
WHERE company_id = '134' AND messenger_id = '265' AND last_updated < CURDATE();

SELECT count(*) FROM conversation
WHERE company_id = '134' AND messenger_id = '265' AND last_updated < CURDATE();
