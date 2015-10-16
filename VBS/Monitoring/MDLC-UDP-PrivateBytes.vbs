Dim CritCount , exitState

strComputer = "." 
Set objWMIService = GetObject("winmgmts:" _ 
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
set objRefresher = CreateObject("WbemScripting.SWbemRefresher") 
Set colItems = objRefresher.AddEnum _ 
    (objWMIService, "Win32_PerfFormattedData_PerfProc_Process").objectSet 
objRefresher.Refresh 

'Variable de retour d'etat vers NAGIOS
const intOK = 0
const intWarning = 1 
const intCritical = 2

ProcesstoWatch="MobileDLCServer"

For Each objItem in colItems
    if objItem.Name = ProcesstoWatch then
    	CritCount = objItem.PrivateBytes / ( 1024 * 1024 )
    	ProcName = objItem.Name
    End if 
Next

If critCount > 800 Then
	exitState = intCritical
ElseIf critCount > 700 Then
	exitState = intWarning
Else
	exitState = intOK
End If

Wscript.echo ProcName & " Private Bytes usage " & CInt(CritCount) & " Mo | used=" & CritCount
Wscript.quit(exitState)
