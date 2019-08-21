# SOURCES
# Dump: https://docs.mongodb.com/manual/reference/program/mongodump/#mongodump
# Restore: https://docs.mongodb.com/manual/reference/program/mongorestore/#mongorestore

# DUMP
mongodump --host "192.168.33.133" --port 27017 --username adapter --password "Adp.3135" --db cmp --collection bb2_MensajesSum --out ./bb2_MensajesSum3

# RESTORE
mongorestore --host "192.168.10.70" --port 27017 --db cmp_prepro --collection bb2_MensajesSum3 {PATH_TO_DUMP}
