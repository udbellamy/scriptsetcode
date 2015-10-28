#/bin/bash

dbpass=$(grep dbpassword /var/www/glpi/config/config_db.php | cut -d\' -f2)

echo \
'SELECT glpi_computers.name, glpi_plugin_consigne_elements.service, glpi_plugin_consigne_elements.hno_call_warning, glpi_plugin_consigne_elements.hno_call_critical
FROM glpi_computers, glpi_plugin_consigne_elements
WHERE glpi_plugin_consigne_elements.computers_id = glpi_computers.id;' | \
mysql -D glpidb -u glpi -p$dbpass > /tmp/exportconsignes.csv

sed -i 's/\t/|/g' /tmp/exportconsignes.csv

exit 0
