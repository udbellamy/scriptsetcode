#!/bin/bash

to='!'[to]
x='!'[x]
x1='!'[x1]
x2='!'[x2]
x3='!'[x3]
x4='!'[x4]
x5='!'[x5]
x6='!'[x6]

ap='!'[ap]
lp='!'[lp]
mp='!'[mp]
hp='!'[hp]
exp='!'[exp]

ak='!'[ak]
lk='!'[lk]
mk='!'[mk]
hk='!'[hk]
hp='!'[mp]

cr='!'[cr]'!'[dot]
j='!'[j]'!'[dot]
f='!'[f]'!'[dot]
df='!'[df]'!'[dot]

vt='!'[vt]
vs='!'[vs]
super='!'[qcf]'!'[qcf]'!'[ak]

lklegs='!'[qcf]'!'[plus]'!'[lk]
mklegs='!'[qcf]'!'[plus]'!'[mk]
hklegs='!'[qcf]'!'[plus]'!'[hk]
exlegs='!'[qcf]'!'[plus]'!'[exk]

lksbk='!'[cdu]'!'[plus]'!'[lk]
mksbk='!'[cdu]'!'[plus]'!'[mk]
hksbk='!'[cdu]'!'[plus]'!'[hk]
exsbk='!'[cdu]'!'[plus]'!'[exk]

lpkikoken='!'[clr]'!'[plus]'!'[lp]
mpkikoken='!'[clr]'!'[plus]'!'[mp]
hpkikoken='!'[clr]'!'[plus]'!'[hp]
exkikoken='!'[clr]'!'[plus]'!'[exp]

rm -rf combo.md
cat sample >> combo.md

sed -ie "s/"lp"\ /$lp\ /g"			 combo.md
sed -ie "s/"mp"\ /$mp\ /g"			 combo.md
sed -ie "s/"hp"\ /$hp\ /g"			 combo.md

sed -ie "s/"lk"\ /$lk\ /g"			 combo.md
sed -ie "s/"mk"\ /$mk\ /g"			 combo.md
sed -ie "s/"hk"\ /$hk\ /g"			 combo.md

sed -ie "s/\ \~\ /$x/g"				 combo.md
sed -ie "s/\ \~1\ /$x1/g"			 combo.md
sed -ie "s/\ \~2\ /$x2/g"			 combo.md
sed -ie "s/\ \~3\ /$x3/g"			 combo.md
sed -ie "s/\ \~4\ /$x4/g"			 combo.md
sed -ie "s/\ \~5\ /$x5/g"			 combo.md
sed -ie "s/\ \~6\ /$x6/g"			 combo.md

sed -ie "s/\ /$to/g"			 combo.md

sed -ie "s/"lk.legs"/$lklegs/g"	 combo.md
sed -ie "s/"mk.legs"/$mklegs/g"	 combo.md
sed -ie "s/"hk.legs"/$hklegs/g"	 combo.md
sed -ie "s/"ex.legs"/$exlegs/g"	 combo.md
sed -ie "s/"lk.sbk"/$lksbk/g"	 combo.md
sed -ie "s/"mk.sbk"/$mksbk/g"	 combo.md
sed -ie "s/"hk.sbk"/$hksbk/g"	 combo.md 
sed -ie "s/"ex.sbk"/$exsbk/g"	 combo.md 
sed -ie "s/"lp.kikoken"/$lpkikoken/g"	 combo.md
sed -ie "s/"mp.kikoken"/$mpkikoken/g"	 combo.md
sed -ie "s/"hp.kikoken"/$hpkikoken/g"	 combo.md 
sed -ie "s/"ex.kikoken"/$exkikoken/g"	 combo.md

sed -ie "s/"df'\.'"/$df/g"			 combo.md
sed -ie "s/"s'\.'"//g"				 combo.md
sed -ie "s/"f'\.'"/$f/g"			 combo.md
sed -ie "s/"c'\.'"/$cr/g"			 combo.md
sed -ie "s/"j'\.'"/$j/g"			 combo.md 

sed -ie "s/"VT"/$vt\ /g"			 combo.md
sed -ie "s/"VS"/$vs\ /g"			 combo.md

cat moves.md >> combo.md