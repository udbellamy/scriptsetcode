#!/bin/bash

# Vars

  # Centreon CLAPI path
  clapi="/usr/share/centreon/www/modules/centreon-clapi/core/centreon"

  # Exports path
  ctnlist="/tmp/listhnoservicegroup.csv"
  ctnfulllist="/tmp/listservices.csv"
  glpilist="/tmp/exportconsignes.csv"

echo -e "Liste des services retirés du downtime :\n" > /tmp/downtimeoff.txt

cat $ctnlist | tail -n+2 | while read line 

# Define if a service doesn't belong to the downtimed service group, remove it and report by mail

do
        ctnhostname=`echo $line | awk -F "|" '{print $2}'`
        ctnsname="`echo $line | awk -F "|" '{print $4}'`"
        hostehp=`echo $line | grep -i 'EHP\|EH1\|AIIER\|EBUR' | wc -l`
        glpimatch=`grep -i $ctnhostname $glpilist | grep -e "|$ctnsname|"`
        glpimatchok=`echo $glpimatch | wc -w`

    case $glpimatchok in
        0)
        ;;
        *)
        hnowarning=`echo $glpimatch | awk -F "|" '{print $3}'`
        hnocritical=`echo $glpimatch | awk -F "|" '{print $4}'`

	case $hnowarning in
    		0) warningstatus="Consigne warning non définie";;
    		1) warningstatus="Consigne warning : pas d'appel";;		
    		2) warningstatus="Consigne warning : appel HNO";;
    	esac

    	case $hnocritical in
    		0) criticalstatus="Consigne critical non définie";;
    		1) criticalstatus="Consigne critical : pas d'appel";;		
    		2) criticalstatus="Consigne critical : appel HNO";;
    	esac

    if [[ $hnowarning -ne 2 ]] || [[ $hnocritical -ne 2 ]] && [[ $hostehp == 0 ]]; then
        echo "$ctnhostname - $ctnsname - $warningstatus - $criticalstatus" >> /tmp/downtimeoff.txt
	#$clapi -u admin -p ######## -o SG -a delservice -v "Services_Downtime_HNO;$ctnhostname,$ctnsname"
    fi
        ;;
    esac

done

# Define if a service belongs to the downtimed service group and add it

echo -e "Liste des services ajoutés au downtime :\n" > /tmp/downtimeon.txt

cat $glpilist | tail -n+2 | while read line 

do
        glpihostname=`echo $line | awk -F "|" '{print toupper($1)}'`
        glpisname="`echo $line | awk -F "|" '{print $2}'`"
	hnowarning=`echo $line | awk -F "|" '{print $3}'`
        hnocritical=`echo $line | awk -F "|" '{print $4}'`
	ctnmatch=`grep $glpihostname $ctnfulllist | grep -e "|$glpisname|"`
	ctnsgmatch=`grep $glpihostname $ctnlist | grep -e "|$glpisname|"`
	ctnmatchok=`echo $ctnmatch | wc -w`
	ctnsgmatchok=`echo $ctnsgmatch | wc -w`
	hostehp=`echo $line | grep -i 'EHP\|EH1\|AIIER\|EBUR' | wc -l`

echo $hnowarning - $hnocritical - $hostehp - $ctnmatchok - $ctnsgmatchok

	if [[ $hnowarning -eq 2 ]] && [[ $hnocritical -eq 2 ]] && [[ $hostehp -ne 1 ]] && [[ $ctnmatchok -ne 0 ]] && [[ $ctnsgmatchok -eq 0 ]]; then
		#$clapi -u admin -p ######## -o SG -a addservice -v "Services_Downtime_HNO;$glpihostname,$glpisname"
		echo "$glpihostname - $glpisname" >> /tmp/downtimeon.txt
	elif [[ $hostehp -eq 1 ]] && [[ $ctnmatchok -ne 0 ]] && [[ $ctnsgmatchok -eq 0 ]]; then
		#$clapi -u admin -p ######## -o SG -a addservice -v "Services_Downtime_HNO;$glpihostname,$glpisname"
		echo "$glpihostname - $glpisname" >> /tmp/downtimeon.txt
	fi

done

# Count how many services were processed

	added=`tail -n+2 /tmp/downtimeon.txt | wc -l`
	removed=`tail -n+2 /tmp/downtimeoff.txt | wc -l`

# Report by mail

echo -e "Bonjour,\n\nVeuillez trouver ci-joints les rapports des alertes downtimées.\n\n$added services downtimés.\n\n$removed services retirés du downtime\n\nCordialement,\n\neqxsupctngui01." | mail -s "Rapport des services downtimés" -a /tmp/downtimeon.txt -a /tmp/downtimeoff.txt ########.########@########.fr

exit 0
