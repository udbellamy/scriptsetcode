Option Explicit

 '*************Configuration**************
 'Define the location of the text/log file

dim dtMonth, dtDate, sFileName

dtMonth = Right(String(2, "0") & Month(date), 2)
dtDate = DatePart("yyyy", Now) & dtMonth & DatePart("d", Now - 1)

 sFileName = "C:\ProgramData\QlikTech\DistributionService\1\Log\" & dtDate & "\234500 - Prod_Extraction_Extraction.qvw\TaskLog.txt"
 Const sStringToFind = "The Source Document was NOT reloaded successfully"
 Const sPathToFile = ""
 '***********End Configuration'***********

 '''''Declare Variables
 'Used in the script
 Dim nCount, sMsg, nResult, strLine, exitState
 'Objects
 Dim oReadFile, oFSO

'Variable de retour d'etat vers NAGIOS
const intOK = 0
const intWarning = 1 
const intCritical = 2

 'Create Objects
 Set oFSO = CreateObject("Scripting.FileSystemObject")

 'Opens text file to read only.
 Set oReadFile = oFSO.OpenTextFile(sFileName, 1, False)

 'Count the number of times the string is found.
 nCount = 0

 'Loops through each line until it reaches the end of the text file.
 Do Until oReadFile.AtEndOfStream
 strLine = oReadFile.ReadLine
 'If string is found in the text file, count will no longer = "0" and a message will appear.
 If InStr(strLine, sStringToFind) Then
 nCount = nCount + 1
 End If
 Loop
 'Set the results

 

 If nCount = 0 Then
Wscript.echo "OK: The Source Document was reloaded successfully"
	exitState = intOK
 Else
Wscript.echo "CRITICAL: The Source Document was NOT reloaded successfully"
	exitState = intCRITICAL
 End If

 'Close text file and remove network drive
 oReadFile.Close

 'Clean up objects from memory
 Set oFSO = Nothing