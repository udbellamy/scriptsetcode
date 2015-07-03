#!/bin/bash
#
#Codé par Brice CAMINADE
#
#Sonde Nagios qui va chercher l'heure exacte de l'équipement via SNMP et la compare a la date du serveur nagios
#Arguments adresse IP et communauté SNMP

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

usage() {
    cat << EOF
    check_time_offset : Vérifie l'offset en seconde entre l'heure de l'équipement voulu et le serveur nagios

    Options :
        -c : Communauté SNMP
        -v : Version SNMP (1 ou 2)
	-h : Host
	-C : Seuil alerte critical en secondes 

    Exemple : check_time_offset -c supervision -v 1 -h 192.168.1.10 -C 30

EOF
}

if [ $# -ne 8 ]; then
    usage;
    exit 0;
fi

while [ $# -ne 0 ]
do
case $1 in
        "-c")
            COMMUNITY=$2;;
        "-h")
            HOST=$2;;
	"-C")
	    CRITICAL=$2;;
	"-v")
	    VERSION=$2;;
esac
shift
done



        datesup=$(date +%s)

	if [ $VERSION ==  "2" ]; then

        dateserv=$(snmpget -v2c -Ih -O v -c $COMMUNITY $HOST 1.3.6.1.2.1.25.1.2.0 | awk -F' ' '{ year=strtonum("0x"$2$3); mon=strtonum("0x"$4); day=strtonum("0x"$5); hour=strtonum("0x"$6); min=strtonum("0x"$7); sec=strtonum("0x"$8); if(int(sec) <= 9 ) {sec="0"sec}; if(int(min) <= 9) {min="0"min}; if(int(hour) <= 9) {hour="0"hour}; print year"-"mon"-"day" "hour":"min":"sec; }')

	elif [ $VERSION == "1" ]; then

        dateserv=$(snmpget -v1 -O v -Ih -c $COMMUNITY $HOST 1.3.6.1.2.1.25.1.2.0 | awk -F' ' '{ year=strtonum("0x"$2$3); mon=strtonum("0x"$4); day=strtonum("0x"$5); hour=strtonum("0x"$6); min=strtonum("0x"$7); sec=strtonum("0x"$8); if(int(sec) <= 9 ) {sec="0"sec}; if(int(min) <= 9) {min="0"min}; if(int(hour) <= 9) {hour="0"hour}; print year"-"mon"-"day" "hour":"min":"sec; }')

	else
	echo "    check_time_offset : Vérifie l'offset en seconde entre l'heure de l'équipement voulu et le serveur nagios

    Options :
        -c : Communauté SNMP
        -v : Version SNMP (1 ou 2)
        -h : Host
        -C : Seuil alerte critical en secondes 

    Exemple : check_time_offset -c supervision -v 1 -h 192.168.1.10 -C 30"
	
	fi

        if [ -z "$dateserv" ]; then
            echo "Unknown :  No response from $HOST (Timeout)"
            exit $STATE_UNKNOWN
        fi

        dateserv=$(date -d "$dateserv" "+%s")
        offset=$(($dateserv - $datesup))
        offset=${offset#-}

        if test $offset -gt 30
        then
            echo "CRITICAL :  Time offset > 30s (value = "$offset"s)"
            exit $STATE_CRITICAL
        else
            echo "OK :  Time offset < 30s (value = "$offset"s)"
            exit $STATE_OK
        fi


