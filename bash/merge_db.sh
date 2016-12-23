#!/bin/bash
mysql -e "DROP DATABASE IF EXISTS \`StarfleetDelta\`;CREATE DATABASE \`StarfleetDelta\`;"
for table in `mysql -B -N -e "SHOW TABLES;" StarfleetDelta-1` do
  mysql -e "RENAME TABLE \`StarfleetDelta-1\`.\`$table\` to \`StarfleetDelta\`.\`$table\`"
done
mysql -e "DROP DATABASE \`StarfleetDelta-1\`;"
