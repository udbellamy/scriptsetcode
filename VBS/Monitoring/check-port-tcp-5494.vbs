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
     WScript.Echo "OK: Connection TCP 5494 listening"
	 	exitState = intOK
	else
	 WScript.Echo "CRITICAL: Connection TCP 5494 KO !!"
	 	exitState = intCritical
  End if
end Sub

Dim strcommand
strCommand = "cmd /C ""netStat -an -proto TCP |find ""5494"" |find ""LISTENING"""""
Call PortMonitor (strCommand)