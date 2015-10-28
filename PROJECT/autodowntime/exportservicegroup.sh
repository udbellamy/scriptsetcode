#/bin/bash

/usr/share/centreon/www/modules/centreon-clapi/core/centreon -u admin -p ######## -o SG -a getservice -v "Services_Downtime_HNO" > /tmp/listhnoservicegroup.csv
/usr/share/centreon/www/modules/centreon-clapi/core/centreon -u admin -p ######## -o SERVICE -a show > /tmp/listservices.csv

sed -i 's/;/|/g' /tmp/listhnoservicegroup.csv
sed -i 's/;/|/g' /tmp/listservices.csv

exit 0
