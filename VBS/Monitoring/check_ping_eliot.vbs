Dim exitState

'Variable de retour d'etat vers NAGIOS
const intOK = 0
const intWarning = 1 
const intCritical = 2

Function Ping(strHost)
    Dim oPing, oRetStatus, bReturn
    Set oPing = GetObject("winmgmts:{impersonationLevel=impersonate}").ExecQuery("select * from Win32_PingStatus where address='" & strHost & "'")
 
    For Each oRetStatus In oPing
        If IsNull(oRetStatus.StatusCode) Or oRetStatus.StatusCode <> 0 Then
            bReturn = False
 
            ' WScript.Echo "Status code is " & oRetStatus.StatusCode
        Else
            bReturn = True
 
            ' Wscript.Echo "Bytes = " & vbTab & oRetStatus.BufferSize
            ' Wscript.Echo "Time (ms) = " & vbTab & oRetStatus.ResponseTime
            ' Wscript.Echo "TTL (s) = " & vbTab & oRetStatus.ResponseTimeToLive
        End If
        Set oRetStatus = Nothing
    Next
    Set oPing = Nothing
 
    Ping = bReturn
End Function

If Ping("10.146.4.2") Then
	Wscript.echo "OK: Host Eliot is reachable."
	exitState = intOK
Else
	Wscript.echo "CRITICAL: Can not reach host Eliot."
	exitState = intCritical
End If

Wscript.quit(exitState)
