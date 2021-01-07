#SOURCES:


mongoexport --host='192.168.33.113' --username='rootAdm' --password='PWD' --authenticationDatabase='admin'  --db='celulares' --collection='celulares' --query '{"telco" : "claro"}' --limit="5" --out='/tmp/celulares_mongo.json'
