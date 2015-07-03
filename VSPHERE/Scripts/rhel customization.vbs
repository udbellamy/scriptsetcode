'# Start configuration

'# vCenter details
	$vcenter = "172.16.98.20"
 


'# Config VM peripherals
	$vmname = "EQXG2IM23"
	$ip = "172.16.138.179"
	$netmask = "255.255.255.0"
	$gateway = "172.16.138.1"
 


'# VM user - must be root user
	$GuestCred = "root"
	$GuestPass = ""
 


'# VM Deployment Details
	$destination_pool = "EQX-CONSO"
	$template_name = "EQXG2ITMP_RHEL6"
	$datastore_name = "SAN11-SAS-ESX-PROD-LIN02"



'# Server configuration
	'# System
		$vcpu = 2 
		$memMB = 2048 
		$Disk1GB = 30
		$Disk2GB = 20  # 0 = no 2nd/3rd disk
		$Disk3GB = 0    # 0 = no 2nd/3rd disk
	
	'# Network
		$ifacenumber = 2
		$vlan1 = ALL-MGMT-BLB-VL410
			$startconnected1 = $true
		$vlan2 = ALL-MGMT-BLB-VL410
			$startconnected2 = $true
		$vlan3 =
			$startconnected3 = 


'# PowerOn function, checks if VM is running and if needed start it
	function Create-VM {
		function PowerOn-VM {
		param ([string] $vm)
 
		if ($vm -eq "" ) {
			Write-Host "No VM defined."
		}
 
		if ((Get-VM $vm).powerstate -eq "PoweredOn" ) {
			Write-Host "$vm is already powered on."
			return "ok"
		} else {
			Start-VM -VM (Get-VM $vm) -Confirm:$false
			Write-Host "Starting $vm now."
			do {
				$status = (Get-vm $vm | Get-View).Guest.ToolsRunningStatus
				sleep 10
			} until ($status -eq "guestToolsRunning")
         
			return "ok"
		}
	}
 
	Set-PowerCLIConfiguration -DefaultVIServerMode Multiple -confirm:$false

	Connect-VIServer -Server $vcenter

	New-VM `
	-Name $vmname `
	-Template $template_name `
	-Datastore $datastore_name `
	-resourcepool $destination_pool 
	}





Create-VM

'#function UpdateVMSettings {
	Set-VM $vmname -MemoryMB $memMB -NumCpu $vcpu -Confirm:$false
	Get-HardDisk -VM $vmname | Set-HardDisk -CapacityKB ($Disk1GB * 1MB) -Confirm:$false    
		if($Disk2GB -gt 0) { New-HardDisk -VM $vmname -CapacityKB ($Disk2GB * 1MB) -Storageformat Thin -Confirm:$false }
		if($Disk3GB -gt 0) { New-HardDisk -VM $vmname -CapacityKB ($Disk3GB * 1MB) -Storageformat Thin -Confirm:$false }
	Get-NetworkAdapter -VM $vmname | Set-NetworkAdapter -DistributedSwitch $vlan1 -StartConnected:$startconnected1 -Confirm:$false
		if($ifacenumber -ge 2) { New-NetworkAdapter -VM $vmname -DistributedSwitch $vlan2 -StartConnected:$startconnected2 -Type Vmxnet3 -Confirm:$false }
		if($ifacenumber -eq 3) { New-NetworkAdapter -VM $vmname -DistributedSwitch $vlan3 -StartConnected:$startconnected3 -Type Vmxnet3 -Confirm:$false }
	}



'#$poweron = PowerOn-VM $vmname

'#if ($poweron -eq "ok") {
'#    Write-Host "$vmname started."
''	#}



'# RHEL Specific Interface Infos
''	#$vm1 = Get-VM -Name $vmname
''	#$guest = Get-VMGuest $vm1
''	#$interface = Get-VMGuestNetworkInterface -VMGuest $guest -GuestUser $GuestCred -GuestPassword $GuestPass -ToolsWaitSecs 100
	
''	#Set-VMGuestNetworkInterface -VMGuestNetworkInterface $interface -GuestUser $GuestCred -GuestPassword $GuestPass -IPPolicy static -IP $ip -Gateway $gateway -DnsPolicy static -Netmask $netmask
	

'# DEBIAN Specific Interface Infos
	$command = "/root/customization.sh $vmname $ip $netmask $gateway"
	Invoke-VMScript -VM $vmname -ScriptText $command -GuestUser $GuestCred -GuestPassword $GuestPass -ScriptType Bash
 

Restart-VMGuest -VM $vmname