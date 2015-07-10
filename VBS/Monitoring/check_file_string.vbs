Option Explicit

 '*************Configuration**************
 'Define the location of the text/log file
 Const sFileName = "TaskLog.txt"
 Const sStringToFind = "The Source Document was NOT reloaded successfully"
 Const sPathToFile = "C:\Documents and Settings\All Users\Application Data\QlikTech\DistributionService\1\Log\20150710\010000 - Prod_Applications_Autres_CRF_CRF.qvw\"
 '***********End Configuration'***********

 '''''Declare Variables
 'Used in the script
 Dim nCount, sMsg, nResult, strLine
 'Objects
 Dim oReadFile


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

 'Set the results

 If nCount = 0 Then
Wscript.echo "Pas Caca"
 Else
Wscript.echo "Caca"
 End If

 'Close text file and remove network drive
 oReadFile.Close

 'Clean up objects from memory
 Set oFSO = Nothing