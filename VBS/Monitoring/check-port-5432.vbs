Option Explicit

Dim Stdout, objShell, objScriptExec, strPingResults, exitState

'Variable de retour d'etat vers NAGIOS
const intOK = 0
const intWarning = 1 
const intCritical = 2

Sub PortMonitor (strCommand)

  Set StdOut = WScript.StdOut
  Set objShell = CreateObject("WScript.Shell")
  set objScriptExec = objShell.Exec (strCommand)

  strPingResults = LCase(objScriptExec.StdOut.ReadAll)

  if len (strPingResults) > 0 then
     WScript.Echo "OK: Connexion UDP 5432 established"
	 	exitState = intOK
	else
	 WScript.Echo "CRITICAL: Connexion UDP 5432 KO !!"
	 	exitState = intCritical
  End if
end Sub

Dim strcommand
strCommand = "cmd /C ""netStat -an -proto UDP |find ""0.0.0.0:5432"""""
Call PortMonitor (strCommand)