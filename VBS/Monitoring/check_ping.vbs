' Store the arguments in a variable:
Set objArgs = Wscript.Arguments

Dim objShell , objFSO , StrFileLog , Result , exitState



Function Ping(strHost)
	Dim objSh, strCommand, intWindowStyle, blnWaitOnReturn
 
	blnWaitOnReturn = True
	intWindowStyle = 0
	strCommand = "%ComSpec% /C %SystemRoot%\system32\ping.exe -n 1 " _
	& strHost & " | " & "%SystemRoot%\system32\find.exe /i " _
	& Chr(34) & "TTL=" & Chr(34)
 
	Set objSh = WScript.CreateObject("WScript.Shell")
	Ping = Not CBool(objSh.Run(strCommand, intWindowStyle, blnWaitOnReturn))
	Set objSh = Nothing
End Function

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

If Ping(objArgs(0)) Then
	Wscript.echo "OK: Host " & objARGS(1) & " is reachable."
	exitState = 2
Else
	Wscript.echo "CRITICAL: Can not reach host " & objARGS(1)
	exitState = 0
End If