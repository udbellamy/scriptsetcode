#!/bin/bash

red='\e[0;31m'
green='\e[0;32m'
NC='\e[0m'

# Create files

rm -rf change.temp add.temp remove.temp

        echo -e "\n\033[1mPaquets à modifier\033[0m" >> change.temp 2>&1
        echo -e "\n\033[1mPaquets à retirer\033[0m" >> remove.temp 2>&1
        echo -e "\n\033[1mPaquets à ajouter\033[0m" >> add.temp 2>&1

# Set packaging type

echo -e "\n\033[1mVersion de packaging : (1 : squeeze / 2 : wheezy python 2 / 3 : wheezy python 3)\033[0m" && read -e -p "" python

# Set final package name

echo -e "\n\033[1mNom du paquet final :\033[0m" && read -e -p "" paquet

if [[ $python = 3 ]]; then

	paquet=python3-$paquet

elif [[ $paquet = "bluetils" ]] || [[ $paquet = "bluesys-ws" ]] || [[ $paquet = "ansible" ]] || [[ $paquet = "autoslave" ]] || [[ $paquet = "autoslave-maintenance" ]] || [[ $paquet = "bluebus" ]] ||[[ $paquet = "bluecases" ]] || [[ $paquet = "bluecasesindex" ]] ||[[ $paquet = "bluecrash" ]] || [[ $paquet = "bluefinance" ]] ||[[ $paquet = "bluemers" ]] || [[ $paquet = "bluestock" ]] || [[ $paquet = "bluesys-tools" ]] ||[[ $paquet = "blusers" ]] || [[ $paquet = "indigo" ]] || [[ $paquet = "subzero" ]]; then

	paquet=$paquet

else
	
	paquet=python-$paquet

fi

echo -e "\n\033[1mVersion du paquet final :\033[0m" && read -e -p "" version

# Set autocron

if [[ $paquet = autoslave && $python = 1 ]]; then
        echo -e "\n\033[1mRemplacer le cron ? (oui / non):\033[0m" && read -e -p "" cron
        if [[ $cron = "oui" ]]; then
        ./autocron.sh
	fi
fi
	
echo -e "\n\033[1mProcédure de packaging du paquet\033[0m${red}\033[1m $paquet${NC}\033[1m en version${red}\033[1m $version${NC} :\n"

# Enter loop

cat sample | grep \+ | while read line
do

# Set package name

        nom=$(echo a$line | sed -e s/a+//g -e 's/[><=]\{1\}=//g' -e s/'[0-9]\..*'//g -e s/\_/\-/g -e 's/\[><=]//g' -e 's/<//g' -e 's/>//g' -e 's/=//g' | awk '{print tolower($0)}')

# Set number of diff

	ndiff=$(echo $line | grep -oh '[><=].' | wc -l)

# Set diff var

	diff1=$(echo $line | grep -oh -m1 '[><=][><=]' | sed -e s/==/=/g)
	if [[ $ndiff = 2 ]]; then
		diff2=$(echo $line | grep -oh '[><=].' | tail -1 | sed -e s/'[0-9]//g' | sed -e s/==/=/g)
	fi

	if [[ $diff2 = '<' ]]; then
	diff2='<<'
	fi

	case $diff1 in
        =)eqwak=1;;
        *)eqwak=0;;
	esac
	
# Set number of ver

        nver=$(echo $line | grep -oh '[0-9\.]*' | wc -l)

# Set version var

        gwak=$(echo $line | grep -e "<" | grep -v ">" | grep -v "=" | wc -l)

	ver1=$(echo $line | sed -e s/'^.*'\=//g -e s/,'.*$'//g -e s/\+//g -e s/$nom//g -e s/\<//g)
	if [[ $nver = 2 ]]; then
		ver2=$(echo $line | grep -oh '[0-9\.]*' | tail -1)
	fi

	if [[ $gwak = 1 ]]; then
	diff1='<<'
	fi

	if [[ $ver1 = "" ]]; then
	ver1=","
	fi

        if [[ $eqwak = 1 ]]; then
        nver=2
        diff1='>='
        diff2='<<'
        ver2=$red'#A modifier#'$NC
        fi

# Set if packaging is needed

if [[ gwak -ne 1 ]]; then	
	case $python in
	1)pack=$(ssh infr101.auto -n "locate $nom\_$ver1" | grep -v old | grep main | grep -v wheezy | grep -v jessie | wc -l);;
	2)pack=$(ssh infr101.auto -n "locate $nom\_$ver1" | grep -v old | grep wheezy | grep -v python3 | grep -v jessie | wc -l);;
	3)pack=$(ssh infr101.auto -n "locate $nom\_$ver1" | grep -v old | grep wheezy | grep -v python- | grep -v jessie | wc -l);;
	esac	

	if [[ $nver = 0 ]]; then
		        case $python in
        		1)pack=$(ssh infr101.auto -n "locate $nom\_" | grep -v old | grep main | grep -v wheezy | grep -v jessie | wc -l);;
        		2)pack=$(ssh infr101.auto -n "locate $nom\_" | grep -v old | grep wheezy | grep -v python3 | grep -v jessie | wc -l);;
        		3)pack=$(ssh infr101.auto -n "locate $nom\_" | grep -v old | grep wheezy | grep -v python- | grep -v jessie | wc -l);;
			esac
	fi
fi

# Set category

        nom=$(echo $line | grep \+ | sed -e s/+//g -e 's/[><=]\{1\}=//g' -e s/'[0-9]\..*'//g -e 's/<//g' -e 's/>//g' -e 's/=//g')
	cat1=$(grep -i $nom sample | grep -E '[+-]' | wc -l)
	nom=$(echo $line | sed -e s/+//g -e 's/[><=]\{1\}=//g' -e s/'[0-9]\..*'//g -e s/\_/\-/g -e 's/<//g' -e 's/>//g' -e 's/=//g' | awk '{print tolower($0)}')

# Set flag

case $python in

	1)flag=$(ssh suppack.auto -n "grep $nom /opt/packaging/debian/$paquet/control | grep $ver1 | wc -l");;
	2|3)flag=$(ssh suppack.auto -n "grep $nom /opt/packaging/debian_wheezy/$paquet/control | grep $ver1 | wc -l");;

esac

	if [[ $flag -ge 1 ]]; then
		flag2=$(echo -e "$green✔$NC")
	else
		flag2=$(echo -e "$red✗$NC")
	fi

############################################################################### MAIN ######################################################################################

if [[ $nom = "bluetils" ]] || [[ $nom = "bluesys-ws" ]] || [[ $nom = "ansible" ]] || [[ $nom = "autoslave" ]] || [[ $nom = "autoslave-maintenance" ]] || [[ $nom = "bluebus" ]] ||[[ $nom = "bluecases" ]] || [[ $nom = "bluecasesindex" ]] ||[[ $nom = "bluecrash" ]] || [[ $nom = "bluefinance" ]] ||[[ $nom = "bluemers" ]] || [[ $nom = "bluestock" ]] || [[ $nom = "bluesys-tools" ]] ||[[ $nom = "blusers" ]] || [[ $nom = "indigo" ]] || [[ $nom = "subzero" ]]; then
	
	nomtype=1

elif [[ $python = 3 ]]; then

	nomtype=3

else

	nomtype=0

fi

case $python in
	1)
	nom=$nom
	script="packaging.py";;
	
	2)
	nom="$nom"
	script="packaging.wheezy.python2.py";;

        3)
	nom="python3-$nom"
        script="packaging.wheezy.python3.py";;
esac

case $nomtype in
	1)nom=$nom;;
	0)nom=python-$nom;;
	3)nom=$nom
esac

	if [[ $nver = 2 ]]; then
		if [[ $pack -ge 1 ]]; then

				if [[ $cat1 -ge 2 ]] && [[ $nver = 0 ]]; then
					echo -e "$flag2 $nom," | awk '{print tolower($0)}' >> change.temp
					elif [[ $cat1 -ge 2 ]] && [[ $nver > 0 ]]; then
					echo -e "$flag2 $nom ($diff1 $ver1), $nom ($diff2 $ver2)," | awk '{print tolower($0)}' >> change.temp
				fi
				
				if [[ $cat1 = 1 ]] && [[ $nver = 0 ]]; then
					echo -e "$flag2 $nom," | awk '{print tolower($0)}' >> add.temp
					elif [[ $cat1 = 1 ]] && [[ $nver > 0 ]]; then
					echo -e "$flag2 $nom ($diff1 $ver1), $nom ($diff2 $ver2)," | awk '{print tolower($0)}' >> add.temp
					
				fi
		else
			

				if [[ $cat1 -ge 2 ]] && [[ $nver = 0 ]]; then
					echo -e "$flag2 $nom,${red}\033[1m A PACKAGER${NC}" >> change.temp
					echo -e "${red}\033[1m---------->${NC} 	python $script $nom #VERSION# 'New Release'" >> change.temp
					elif [[ $cat1 -ge 2 ]] && [[ $nver > 0 ]]; then
					echo -e "$flag2 $nom ($diff1 $ver1), $nom ($diff2 $ver2),${red}\033[1m A PACKAGER${NC}" >> change.temp
					echo -e "${red}\033[1m---------->${NC} 	python $script $nom $ver1 'New Release'" >> change.temp
					
				fi
				
				if [[ $cat1 = 1 ]] && [[ $nver = 0 ]]; then
					echo -e "$flag2 $nom,${red}\033[1m A PACKAGER${NC}" >> add.temp
					echo -e "${red}\033[1m---------->${NC}  python $script $nom #VERSION# 'New Release'" >> add.temp
					elif [[ $cat1 = 1 ]] && [[ $nver > 0 ]]; then
					echo -e "$flag2 $nom ($diff1 $ver1), $nom ($diff2 $ver2),${red}\033[1m A PACKAGER${NC}" >> add.temp
					echo -e "${red}\033[1m---------->${NC} 	python $script $nom $ver1 'New Release'" >> add.temp
					
				fi
		fi

####################################################################################

	else

	if [[ $pack -ge 1 ]]; then
		
				if [[ $cat1 -ge 2 ]] && [[ $nver = 0 ]]; then
					echo -e "$flag2 $nom," | awk '{print tolower($0)}' >> change.temp
					elif [[ $cat1 -ge 2 ]] && [[ $nver > 0 ]]; then
					echo -e "$flag2 $nom ($diff1 $ver1)," | awk '{print tolower($0)}' >> change.temp
					
				fi

				if [[ $cat1 = 1 ]] && [[ $nver = 0 ]]; then
					echo -e "$flag2 $nom," | awk '{print tolower($0)}' >> add.temp
					elif [[ $cat1 = 1 ]] && [[ $nver > 0 ]]; then
					echo -e "$flag2 $nom ($diff1 $ver1)," | awk '{print tolower($0)}' >> add.temp
					
				fi
	else

				if [[ $cat1 -ge 2 ]] && [[ $nver = 0 ]]; then
					echo -e "$flag2 $nom,${red}\033[1m A PACKAGER${NC}" >> change.temp
                                	echo -e "${red}\033[1m---------->${NC}       python $script $nom #VERSION# 'New Release'" >> change.temp
					elif [[ $cat1 -ge 2 ]] && [[ $nver > 0 ]]; then
					echo -e "$flag2 $nom ($diff1 $ver1),${red}\033[1m A PACKAGER${NC}" >> change.temp
                                	echo -e "${red}\033[1m---------->${NC}       python $script $nom $ver1 'New Release'" >> change.temp
					
				fi

				if [[ $cat1 = 1 ]] && [[ $nver = 0 ]]; then
					echo -e "$flag2 $nom,${red}\033[1m A PACKAGER${NC}" >> add.temp
	                               	echo -e "${red}\033[1m---------->${NC}       python $script $nom #VERSION# 'New Release'" >> add.temp
					elif [[ $cat1 = 1 ]] && [[ $nver > 0 ]]; then
					echo -e "$flag2 $nom ($diff1 $ver1),${red}\033[1m A PACKAGER${NC}" >> add.temp
	                               	echo -e "${red}\033[1m---------->${NC}       python $script $nom $ver1 'New Release'" >> add.temp
					
				fi
	fi
fi

############################################################################################################################################################################

done


cat change.temp
cat add.temp

rm -f change.temp
rm -f add.temp

cat sample | grep \- | grep -v \+ | while read line
do

# Set package name

        nom2=$(echo a$line | sed -e s/a-//g -e 's/[><=]\{1\}=//g' -e s/'[0-9]\..*'//g -e s/\_/\-/g -e 's/<//g' -e 's/>//g' -e 's/=//g' | awk '{print tolower($0)}')

# Set number of diff

        ndiff=$(echo $line | grep -oh '[><=].' | wc -l)

# Set diff var

        diff1=$(echo $line | grep -oh -m1 '[><=][><=]')
        if [[ $ndiff = 2 ]]; then
                diff2=$(echo $line | grep -oh '[><=].' | tail -1 | sed -e s/'[0-9]//g')
        fi

# Set number of ver

        nver=$(echo $line | grep -oh '[0-9\.]*' | wc -l)

# Set version var
	
	if [[ $nver = 0 ]]; then
		ver1=""
	fi

	if [[ $nver = 1 ]]; then
        	ver1=$(echo $line | sed -e s/'^.*'\=//g -e s/,'.*$'//g)
	fi

	if [[ $nver = 2 ]]; then
                ver2=$(echo $line | grep -oh '[0-9\.]*' | tail -1)
        fi

	space=$(echo $ver1 | grep -e + -e \> -e \< | wc -l)
        if [[ $space -ge 1 ]];
        then ver1="\ "
        fi

# Set category
	
	nom=$(echo a$line | sed -e s/a-//g -e 's/[><=]\{1\}=//g' -e s/'[0-9]\..*'//g -e 's/<//g' -e 's/>//g' -e 's/=//g')
        cat2=$(grep -i $nom sample | grep '[+-]' | wc -l)
        nom=$(echo a$line | sed -e s/a-//g -e 's/[><=]\{1\}=//g' -e s/'[0-9]\..*'//g -e s/\_/\-/g -e 's/<//g' -e 's/>//g' -e 's/=//g' | awk '{print tolower($0)}')

# Set flag

case $python in

        1)flag=$(ssh suppack.auto -n "grep $nom /opt/packaging/debian/$paquet/control");;
        2|3)flag=$(ssh suppack.auto -n "grep $nom /opt/packaging/debian_wheezy/$paquet/control");;

esac

        if [[ $flag = 0 ]]; then
                flag2=$(echo -e "$green✔$NC")
        else
                flag2=$(echo -e "$red✗$NC")
        fi

############################################################################### MAIN ######################################################################################

if [[ $nom = "bluetils" ]] || [[ $nom = "bluesys-ws" ]] || [[ $nom = "ansible" ]] || [[ $nom = "autoslave" ]] || [[ $nom = "autoslave-maintenance" ]] || [[ $nom = "bluebus" ]] ||[[ $nom = "bluecases" ]] || [[ $nom = "bluecasesindex" ]] ||[[ $nom = "bluecrash" ]] || [[ $nom = "bluefinance" ]] ||[[ $nom = "bluemers" ]] || [[ $nom = "bluestock" ]] || [[ $nom = "bluesys-tools" ]] ||[[ $nom = "blusers" ]] || [[ $nom = "indigo" ]] || [[ $nom = "subzero" ]]; then

        nomtype=1

elif [[ $python = 3 ]]; then

        nomtype=3

else

        nomtype=0

fi

case $python in
        1)
        nom=$nom
        script="packaging.py";;

        2)
        nom="$nom"
        script="packaging.wheezy.python2.py";;

        3)
        nom="python3-$nom"
        script="packaging.wheezy.python3.py";;
esac

case $nomtype in
        1)nom=$nom;;
        0)nom=python-$nom;;
        3)nom=$nom
esac

        if [[ $nver = 2 ]]; then

                                if [[ $cat2 = 1 ]]; then
                                        echo -e "$flag2 $nom ($diff1 $ver1), $nom ($diff2 $ver2)," | awk '{print tolower($0)}' >> remove.temp
                                fi

####################################################################################

        else

                                if [[ $cat2 = 1 ]] && [[ $ver > 0 ]]; then
                                        echo -e "$flag2 $nom ($diff1 $ver1)," | awk '{print tolower($0)}' >> remove.temp
                                elif [[ $cat2 = 1 ]]; then
                                        echo -e "$flag2 $nom," | awk '{print tolower($0)}' >> remove.temp
                                fi
fi

############################################################################################################################################################################

done

cat remove.temp

rm -rf remove.temp

# PROC

case $python in
        1)
        script="packaging.py"
	send="deb_send";;
        2)
        script="packaging.wheezy.python2.py"
	send="deb_send_wheezy";;

        3)
        script="packaging.wheezy.python3.py"
	send="deb_send_wheezy";;
esac


echo -e "\n\033[1mRéaliser les actions suivantes :"
echo -e "- Packagez les dépendances comme indiqué ci dessus"
echo -e "- Remplacez les dépendances dans le fichier control de ${red}\033[1m$paquet${NC}\033[1m comme indiqué ci dessus"
echo -e "- Envoyez les dépendances sur le repo et patientez un instant :${NC} $send\033[1m"
echo -e "- \033[1mPurgez les dépendances :${NC} deb_purge\033[1m"
echo -e "- \033[1mLancez un ${NC}updatedb\033[1m sur le serveur infr101 et relancez ce script. Controlez que les mentions A PACKAGER disparaissent et que les flag soient tous à ✔\033[1m"
echo -e "- Packager le paquet final :${NC} python $script${red}\033[1m $paquet $version${NC} 'New Release'\033[1m"
if [[ $paquet = autoslave ]]; then
echo -e "- \033[1mModifiez le fichier de cron dans le dossier d'autoslave-app\033[1m"
echo -e "- Packagez autoslave-app   :${NC} python $script ${red}\033[1mautoslave-app $version${NC} 'New Release'\033[1m"
fi
echo -e "- \033[1mEnvoyez le paquet final sur le repo :${NC} deb_send\033[1m"
echo -e "- \033[1mPurgez les .deb restants :${NC} deb_purge\033[1m"
if [[ $paquet = autoslave && $python = 1 ]]; then
echo -e "- \033[1mTestez l'install sur un serveur applicatif : ${NC}apt-get install --dry-run ${red}\033[1mautoslave autoslave-app${NC}\n"
elif [[ $paquet = "bluebus" ]] ||[[ $paquet = "bluecases" ]] || [[ $paquet = "bluecrash" ]] || [[ $paquet = "bluemers" ]] || [[ $paquet = "bluestock" ]] ||[[ $paquet = "bluesup" ]] || [[ $paquet = "blusers" ]] || [[ $paquet = "indigo" ]]; then 
echo -e "- \033[1mTestez l'install sur un serveur applicatif : ${NC}apt-get install --dry-run ${NC}$paquet${NC}\n"
else
echo -e "-\033[1m Remplacez cette dépendance dans le fichier control du paquet final et continuez avec les dépendances suivantes${NC}\n"
fi
echo -e "Mangez des pommes. C'est bon les pommes." 

exit 0
