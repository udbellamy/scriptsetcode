Option Explicit 
Dim fso, count, src, folder, file, exitState

'Variable de retour d'etat vers NAGIOS
const intOK = 0
const intWarning = 1 
const intCritical = 2

Set fso = CreateObject("Scripting.FileSystemObject") 
src = "C:\Program Files (x86)\Microlise\ESIService\ExternalHostIntray" 
Set folder = fso.GetFolder(src) 
count = 0 
For Each file In folder.files 
If LCase(fso.GetExtensionName(file)) = "xml" Then 
count = count + 1 
End If 
Next 

If count > 20 Then
	Wscript.echo "CRITICAL : Number of xml files : " & count & " | files=" & count
	exitState = intCritical
ElseIf count > 10 Then
	Wscript.echo "WARNING : Number of xml files : " & count & " | files=" & count
	exitState = intWarning
Else
	Wscript.echo "OK : Number of xml files : " & count & " | files=" & count
	exitState = intOK
End If

Wscript.quit(exitState)