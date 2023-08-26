#!/bin/sh


# ------------------------
# run flywayMigration
# ------------------------
echo "create DATABASE with ./myapp-init.sql"
mysql -h db -u $VAR_FLYWAY_USER -p$VAR_FLYWAY_PASSWORD < ./myapp-init.sql

cd ./myapp
sh ./gradlew \
 	-Dflyway.driver=$VAR_FLYWAY_DRIVER \
 	-Dflyway.url=$VAR_FLYWAY_URL \
 	-Dflyway.user=$VAR_FLYWAY_USER \
 	-Dflyway.password=$VAR_FLYWAY_PASSWORD \
 	-Dflyway.schemas=$VAR_FLYWAY_SCHEMAS \
 	-Dflyway.defaultSchema=$VAR_FLYWAY_DEFAULT_SCHEMA \
 	-Dflyway.locations=$VAR_FLYWAY_LOCATIONS \
 	flywayMigrate

tail -f /dev/null
