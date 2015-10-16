$result = @()
$vms = Get-view  -ViewType VirtualMachine
foreach ($vm in $vms) {
    $obj = new-object psobject
    $obj | Add-Member -MemberType NoteProperty -Name name -Value $vm.Name
    $obj | Add-Member -MemberType NoteProperty -Name vCPUs -Value $vm.config.hardware.NumCPU
    $obj | Add-Member -MemberType NoteProperty -Name vSockets -Value ($vm.config.hardware.NumCPU/$vm.config.hardware.NumCoresPerSocket)
    $obj | Add-Member -MemberType NoteProperty -Name Persocket -Value $vm.config.hardware.NumCoresPerSocket
    $result += $obj
 
}
$result | Sort vCPUs | Export-Csv -path "C:\Users\adm.damien.bellamy\Documents\export.csv"