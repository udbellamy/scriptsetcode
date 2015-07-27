
'__     ____  __                        
'\ \   / /  \/  |_      ____ _ _ __ ___ 
'' \ \ / /| |\/| \ \ /\ / / _` | '__/ _ \
''  \ V / | |  | |\ V  V / (_| | | |  __/
''   \_/  |_|  |_| \_/\_/ \__,_|_|  \___|
                                       


'#### Source ####

'https://www.vmware.com/support/developer/PowerCLI/PowerCLI51/html/New-VM.html

'#### Connect to vCenter with PowerCLI from Powershell ####

get-vc "IP" or "localhost"


'#### For VM with different name ####

'From Template :

("WSRT02","SAS01","SIN01","CYC01","POL01","WS02","WS04","WS05","WS07","WS08","OPS01","OPS02","WWW01","WWW02","API01","API02") | Foreach {
New-VM `
-Name "ALLEH1LND$_" `
-Datastore "SAN20-SAS-ESX-EHP-LIN01" `
-Template "TPL_Debian_8.0.0_Secure_64bits_v0.4" `
-Vmhost "ildprdesx21.production.autolib.eu" `
-RunAsync `
-Whatif `
}

'From VM :

("PSQL01","MES01","MES02","MES03") | Foreach {
New-VM `
-Name "EQXPRDTLM$_" `
-Datastore "SAN11-SAS-ESX-PROD-LIN02" `
-VM "EQXPRDTLMRDS01" `
-Vmhost "eqxprdesx12.production.autolib.eu" `
-Location "BlueTelemetry" `
-RunAsync `
}

("RDS01","PSQL01","MES01","MES02","MES03") | Foreach {
Start-VM `
-VM "EQXPRDTLM$_" `
-RunAsync `
}

$bluedvPortGroup = Get-VDPortgroup -name EQX-BACK_INT-VL111
("RDS01","PSQL01","MES01","MES02","MES03") | Foreach {
New-NetworkAdapter `
-VM "EQXPRDTLM$_" `
-StartConnected `
-Type Vmxnet3 `
-PortGroup $bluedvPortGroup `
}


$bluedvPortGroup = Get-VDPortgroup -name EQX-FRONT_INT-VL221
("RDS01","PSQL01","MES01","MES02","MES03") | Foreach {
New-NetworkAdapter `
-VM "EQXPRDTLM$_" `
-StartConnected `
-Type Vmxnet3 `
-PortGroup $bluedvPortGroup `
-Whatif `
}

'From Temmplate :

("CRON01","MAJ01","WRK01","WRK02","WS01","WS02","WS04","WS05","WS07","WS08","OPS01","OPS02","WWW01","WWW02","API02","RDS01","RDS02","RAB01","RAB02","PSQL01","PSQL02","PSQL03","NFS01","NFS02","CYC01") | Foreach {
New-VM `
-Name "NAMPRDIND$_" `
-Datastore "CH3-SAS-ESX-PROD-LIN01" `
-VM "NAMPRDINDAPI01" `
-Vmhost "172.30.106.80" `
-Location "Linux" `
-RunAsync `
}

'#### Script de test : ####

("CRON01") | Foreach {
New-VM `
-Name "NAMPRDIND$_" `
-Datastore "CH3-SAS-ESX-PROD-LIN01" `
-VM "NAMPRDINDAPI01" `
-Vmhost "172.30.106.80" `
-RunAsync `
-Location "Linux" `
-whatif 
}


-RunAsync (Aurgument lancer la création des vm en parallèle)
-Location (Argument pour spécifier la localisation des VM dans le VMHost)


'#### Add new network adaptater #### (not working)

("CRON01") | 
Foreach {
New-NetworkAdapter `
-vm "NAMPRDIND$_" `
-Network


'#### Mv vm #### (not working)

 Get-VM | %{Get-View | select $_.name, $_.summary.config.guestFullName} 


'##### Note ####

$destination_pool = "vDC-USA-1"
$template_name = "EQXG2ITMP_RHEL6"
$datastore_name = "CH3-SAS-ESX-PROD-LIN01"
template_name
get-vc <ip-du-vcenter>            172.30.106.20


get-vm | where {$_.guest.osfullname -match "linux"} | select name