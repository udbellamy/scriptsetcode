#!/bin/bash

to='!'[to]
x='!'[x]

lp='!'[lp]
mp='!'[mp]
hp='!'[mp]

lk='!'[lk]
mk='!'[mk]
hk='!'[hk]

cr='!'[cr]'!'[dot]
j='!'[j]'!'[dot]

lklegs='!'[qcf]'!'[plus]'!'[lk]
hklegs='!'[qcf]'!'[plus]'!'[hk]

lksbk='!'[cdu]'!'[plus]'!'[lk]

cp sample combo.md

#sed -ie "s/\ /$to/g"			 combo.md
sed -ie "s/\~/$x/g"			 	 combo.md

sed -ie "s/"lk.legs"/$lklegs/g"	 combo.md
sed -ie "s/"hk.legs"/$hklegs/g"	 combo.md
sed -ie "s/"lk.sbk"/$lksbk/g"	 combo.md 

sed -ie "s/"s'\.'"//g"				 combo.md
sed -ie "s/"c'\.'"/$cr/g"			 combo.md
sed -ie "s/"j'\.'"/$j/g"			 combo.md

sed -ie "s/"lp\ "/$lp\ /g"			 combo.md
sed -ie "s/"mp\ "/$mp\ /g"			 combo.md
sed -ie "s/"hp\ "/$hp\ /g"			 combo.md

sed -ie "s/"lk\ "/$lk\ /g"			 combo.md
sed -ie "s/"mk\ "/$mk\ /g"			 combo.md
sed -ie "s/"hk\ "/$hk\ /g"			 combo.md

sed -ie "s/"mk"/$mk/g"			 combo.md 
