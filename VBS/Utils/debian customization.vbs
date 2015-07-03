'# Start configuration
'# vCenter details
$vcenter = "172.16.100.20"
 
'# Config VM peripherals
$vmname = "DBTEST01"
$ip = "192.168.0.100"
$netmask = "255.255.255.0"
$gateway = "192.168.0.1"
 
'# VM user - must be root user
$GuestCred = "root"
$GuestPass = ""
 
'# VM Deployment Details
$destination_host = "host01.local.lab"
$template_name = "tpl-debian6-clean"
$datastore_name = "LOCAL01"
'# End configuration
 
'# PowerOn function, checks if VM is running and if needed start it
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
 
Connect-VIServer -confirm:$false -Server $vcenter
 
'#New-VM -Name $vmname -Template $template_name -VMHost $destination_host -Datastore $datastore_name
 
$poweron = PowerOn-VM $vmname
 
if ($poweron -eq "ok") {
    Write-Host "$vmname started."
}
 
$command = "/root/customization.sh $vmname $ip $netmask $gateway"
Invoke-VMScript -VM $vmname -ScriptText $command -GuestUser $GuestCred -GuestPassword $GuestPass -ScriptType Bash
 
Restart-VMGuest -VM $vmname
 
Disconnect-VIServer -Server $vcenter -Confirm:$false