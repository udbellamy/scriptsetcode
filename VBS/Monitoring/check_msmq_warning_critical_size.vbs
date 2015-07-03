Option Explicit
Dim Folder, WarningSize, CriticalSize, oFs, oFolder, Size, exitState
REM -----------------------------------------------------------------------------------
REM Script de verification de la taille d un repertoire
REM Celien LEGENT - Equipe Architecture - 17.12.2014
REM -----------------------------------------------------------------------------------
REM Utilisation :
REM Indiquer le chemin dans Folder ="..."
REM Indiquer la taille des seuils WarningSize ="..." et CriticalSize ="..." (en octets)
REM -----------------------------------------------------------------------------------
Folder = "C:\Windows\System32\msmq\storage"
REM Folder = "D:\MSMQ"
WarningSize = "838860800"
CriticalSize = "1073741824"
REM -----------------------------------------------------------------------------------
REM Variables de retour d'etat pour la supervision
REM Sonde en mode metrologie. Pour la remettre en alerte, passer Warning à 1 et Critical à 2.
REM -----------------------------------------------------------------------------------
const OK = 0
const Warning = 0 
const Critical = 0
REM -----------------------------------------------------------------------------------
Set oFs=CreateObject("Scripting.FileSystemObject")
Set oFolder=oFs.GetFolder(Folder)
Size = oFolder.Size
	If Int(Size) >= Int (CriticalSize) Then 
		wscript.echo "Critique, " & Size & " octets, depasse la limite de " & CriticalSize & " octets |msmq_folder_size=" & Size & ""
		exitState=Critical
	ElseIf Int(Size) >= Int (WarningSize) Then 
		wscript.echo "Attention, " & Size & " octets, depasse " & WarningSize & " octets |msmq_folder_size=" & Size & ""
		exitState=Warning
	Else
		wscript.echo "OK, " & Size & " octets, est sous la limite de " & WarningSize & " octets |msmq_folder_size=" & Size & ""
		exitState=OK
	End If
wscript.quit(exitState)