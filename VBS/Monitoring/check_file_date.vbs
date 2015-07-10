Dim exitState

'Variable de retour d'etat vers NAGIOS
const intOK = 0
const intWarning = 1 
const intCritical = 2

Set objFS = CreateObject("Scripting.FileSystemObject")
strFolder = "D:\QlikView_Data\Prod\Applications\Autres\CRF"
Set objFolder = objFS.GetFolder(strFolder)
Set file = objFolder.Files("Date_Refresh.txt")
const timediff = 2
If DateDiff("d",file.DateLastModified,Now) < timediff Then
   WScript.Echo "OK: File date for " & file & " is less than " & timediff & " days."
   exitState = intOK
else
   WScript.Echo "CRITICAL: File date for " & file & " is greater than " & timediff & " days !!!"
   exitState = intCritical
End If