Option Explicit 
'On Error Resume Next 

Dim objWMIService , colProcessList , objProcess , ProcesstoWatch , objLocator 
Dim objShell , objFSO , StrFileLog , Result , CritCount , exitState

Const For_AppEnding = 8, ForReading = 1, FailIfNotExist = 0, OpenAsASCII = -2, Tristate = 0

'Variable de retour d'etat vers NAGIOS
const intOK = 0
const intWarning = 1 
const intCritical = 2

'Set up report file
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objShell = CreateObject("WScript.Shell")
StrFileLog = objShell.CurrentDirectory & "\_report_mem_AVLService.txt"

'liste des process to Check
ProcesstoWatch = "QVS.exe"

'process 
Set objLocator = CreateObject( "WbemScripting.SWbemLocator" ) 
Set objWMIService = objLocator.ConnectServer ( "localhost", "root/cimv2")
objWMIService.Security_.impersonationlevel = 3
Set colProcessList = objWMIService.ExecQuery("Select * from Win32_Process")

For Each objProcess in colProcessList
	'msgbox (objProcess.Name )
	if objProcess.Name = ProcesstoWatch then
		CritCount = objProcess.WorkingSetSize / ( 1024 * 1024 )
	End if
Next

If critCount > 8000 Then
	exitState = intCritical
ElseIf critCount > 7500 Then
	exitState = intWarning
Else
	exitState = intOK
End If

Wscript.echo "AVL Memory usage : " & CInt(CritCount) & " Mo | used=" & CritCount
Wscript.quit(exitState)