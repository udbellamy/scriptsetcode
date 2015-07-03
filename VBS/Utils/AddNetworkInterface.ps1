
$portgrouptmp = "ILD-SUPERVISION-VL212"
$portgroup1 = "ALL-EHP-MGMT_LONDRES-VL473"
$portgroup2 = "ALL-EHP-LND-523"
$bluedvPortGroup1 = Get-VDPortgroup -name $portgroup1
$bluedvPortGroup2 = Get-VDPortgroup -name $portgroup2

function UpdateVMNetwork {
# Create second network adapter and set the portgroup specified in $portgroup2
New-NetworkAdapter -vm $vmname -StartConnected -Type Vmxnet3 -PortGroup $bluedvPortGroup2
# Change the portgroup for mgmt adapter from template default to what's specified in $portgroup1
Get-Vm -name $vmname | Get-NetworkAdapter | foreach { if( $_.NetworkName -like $portgrouptmp) { Set-NetworkAdapter $_ -PortGroup $bluedvPortGroup1 -Confirm:$false }}
	}

$vmname = "ALLEH1LNDAPI01"
UpdateVMNetwork
$vmname = "ALLEH1LNDAPI02"
UpdateVMNetwork
$vmname = "ALLEH1LNDCRON01"
UpdateVMNetwork
$vmname = "ALLEH1LNDMAJ01"
UpdateVMNetwork
$vmname = "ALLEH1LNDOPS01"
UpdateVMNetwork
$vmname = "ALLEH1LNDOPS02"
UpdateVMNetwork
$vmname = "ALLEH1LNDWRK01"
UpdateVMNetwork
$vmname = "ALLEH1LNDWRK02"
UpdateVMNetwork
$vmname = "ALLEH1LNDWS01"
UpdateVMNetwork
$vmname = "ALLEH1LNDWS02"
UpdateVMNetwork
$vmname = "ALLEH1LNDWS04"
UpdateVMNetwork
$vmname = "ALLEH1LNDWS05"
UpdateVMNetwork
$vmname = "ALLEH1LNDWS07"
UpdateVMNetwork
$vmname = "ALLEH1LNDWS08"
UpdateVMNetwork
$vmname = "ALLEH1LNDWWW01"
UpdateVMNetwork
$vmname = "ALLEH1LNDWWW02"
UpdateVMNetwork


# Set Network Adapter from PortGroup $bluedvPortGroup Connected
Get-Vm -name $vmname | Get-NetworkAdapter | foreach { if( $_.NetworkName -like $portgroup) { Set-NetworkAdapter $_ -Connected $true -whatif }}get-vm

#$DistributedSwitch = "ILD_vSwitch0"
#$distributedSwitchPortGroup = Get-VirtualSwitch -Distributed -Name $DistributedSwitch