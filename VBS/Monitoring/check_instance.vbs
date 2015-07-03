strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set IPConfigSet = objWMIService.ExecQuery _
    ("Select * from Win32_NetworkAdapterConfiguration Where IPEnabled=TRUE")

Dim counter
counter = 0
For Each IPConfig in IPConfigSet
    If Not IsNull(IPConfig.IPAddress) Then 
        For i=LBound(IPConfig.IPAddress) to UBound(IPConfig.IPAddress)
			If IPConfig.IPAddress(i) = "172.16.10.240" Or IPConfig.IPAddress(i) = "172.16.10.241" Or IPConfig.IPAddress(i) = "172.16.10.242" Then
				counter = counter + 1
			End If
        Next
    End If
Next

Dim exitState
'Variable de retour d'etat vers NAGIOS
const intOK = 0
const intWarning = 1 
const intCritical = 2

Dim ExitPb

If counter = 0 Then
	Wscript.Echo "CRITICAL: Aucune instance MSSQL detectee !!"
	exitState = intCritical
End If

If counter = 1 Then
	Wscript.Echo "OK: 1 instance MSSQL detectee"
	exitState = intOK
End If

If counter = 2 Then
	Wscript.Echo "WARNING: 2 instances MSSQL detectees"
	exitState = intWarning
End If

If counter = 3 Then
	Wscript.Echo "CRITICAL: 3 instances MSSQL detectees !!"
	exitState = intCritical
End If

Wscript.quit(exitState)
