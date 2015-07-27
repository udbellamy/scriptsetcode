#From VM :

    # Créer une VM depuis le template et attribuer un VLAN de MGMT à la main puis
    # passer la commande suivante en se basant sur cette VM, pour toutes les autres
    # -Whatif `

("PSQL01","MES01","MES02","MES03")| Foreach {
New-VM `
-Name "ILDPRDTLM$_" `
-Datastore "SAN20-SAS-ESX-PROD-LIN01" `
-VM "ILDPRDTLMRDS01" `
-Vmhost "ildprdesx11.production.autolib.eu" `
-Location "BlueTelemetry" `
-RunAsync `
}

    # Passer cette commande pour démarrer chaque VM afin que l'eth0 soit l'interface
    # de management

("RDS01","PSQL01","MES01","MES02","MES03") | Foreach {
Start-VM `
-VM "ILDPRDTLM$_" `
-RunAsync `
}

    # Une fois la VM allumée, passer cette commande pour ajouter la seconde patte.
$bluedvPortGroup = Get-VDPortgroup -name ILD-BACK_INT-VL112
("RDS01","PSQL01","MES01","MES02","MES03") | Foreach {
New-NetworkAdapter `
-VM "ILDPRDTLM$_" `
-StartConnected `
-Type Vmxnet3 `
-PortGroup $bluedvPortGroup `
}


    # Au besoin, passer cette commande pour ajouter une troisième patte
#$bluedvPortGroup = Get-VDPortgroup -name ILD-BACK_INT-VL112
#("RDS01","PSQL01","MES01","MES02","MES03") | Foreach {
#New-NetworkAdapter `
#-VM "ILDPRDTLM$_" `
#-StartConnected `
#-Type Vmxnet3 `
#-PortGroup $bluedvPortGroup `
#}

    # Au besoin, passer cette commande pour modifier le vlan sur une interface
#$portgroupold = "LAN5000"
#$portgroupnew = "LAN5004"
#("CYC01","SAS01","SIN01","WSRT01","WSRT02") | Foreach {
#Get-Vm `
#-Name "ILDPRDTLM$_" | Get-NetworkAdapter | foreach { if( $_.NetworkName -like $portgroupold) { Set-NetworkAdapter $_ -PortGroup $portgroupnew -Confirm:$false }}
#    }