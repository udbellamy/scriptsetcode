on error resume next

'Variable de retour d'etat vers NAGIOS
const intOK = 0
const intWarning = 1 
const intCritical = 2

Dim Array_URL(10) , i
Dim ExitPb

Array_URL (0) = "http://localhost/AutolibWebservice/AutolibService.asmx"
Array_URL (1) = "http://localhost/TMC.Data.WebService/TMCDataService.asmx"

i=0

Set Http = CreateObject("Microsoft.XMLHttp")

Do while Array_URL(i)  <> ""

	Http.Open "GET" , Array_URL(i) , false
	Http.Send

	If Http.Status <> 200 Then
		ExitPb = ExitPb & Http.Status & " -" & Array_URL(i) & "-" & vbCrLf
	End If
	
	i = i + 1
Loop

if ExitPb = "" then
	Wscript.echo "Web Services : Ok"
	exitState = intOK
else
	Wscript.echo "Web Services : " & ExitPb
	exitState = intCritical
end if
	
Wscript.quit(exitState)
