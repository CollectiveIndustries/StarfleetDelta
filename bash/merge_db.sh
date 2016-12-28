#!/bin/bash
PASSWORD=password
USER=root
#mysql --user=$USER --password=$PASSWORD -e "DROP DATABASE IF EXISTS \`StarfleetDelta\`;CREATE DATABASE \`StarfleetDelta\`;"
for table in $(mysql --user=$USER --password=$PASSWORD -B -N -e "SHOW TABLES;" StarfleetDelta-1)
do
  mysql --user=$USER --password=$PASSWORD -e "RENAME TABLE \`StarfleetDelta-1\`.\`$table\` to \`StarfleetDelta\`.\`$table\`"
done
#mysql -u$USER -p$PASSWORD -e "DROP DATABASE \`StarfleetDelta-1\`;"
