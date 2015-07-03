Option explicit
'On Error Resume Next

' Queues to monitor
Dim toMonitor(29)
toMonitor(0) = "blackboxin,5,15"
toMonitor(1) = "esiinqueue,5,15"
toMonitor(2) = "esioutqueue,5,15"
toMonitor(3) = "ivcserviceg2in,5,15"
toMonitor(4) = "ivcserviceg2out,5,15"
toMonitor(5) = "ivcserviceg3in,5,15"
toMonitor(6) = "ivcserviceg3out,5,15"
toMonitor(7) = "ivcservicein,5,15"
toMonitor(8) = "ivcserviceout,5,15"
toMonitor(9) = "ivcservicepdain,5,15"
toMonitor(10) = "ivcservicepdaout,5,15"
toMonitor(11) = "ivcservicetempoin,5,15"
toMonitor(12) = "ivcservicetempoout,5,15"
toMonitor(13) = "ivcserviceungroupedunitin,5,15"
toMonitor(14) = "ivcserviceungroupedunitout,5,15"
toMonitor(15) = "loopbackin,5,15"
toMonitor(16) = "loopbackout,5,15"
toMonitor(17) = "mccpm,5,15"
toMonitor(18) = "mdlccontroltimeouts,5,15"
toMonitor(19) = "mdtservicefailed,5,15"
toMonitor(20) = "mdtservicein,5,15"
toMonitor(21) = "mdtserviceout,5,15"
toMonitor(22) = "mdtspingin,5,15"
toMonitor(23) = "mdtspingout,5,15"
toMonitor(24) = "mfd_cpm_mcs_inbound,5,15"
toMonitor(25) = "mobiledlclog,5,15"
toMonitor(26) = "mobiletodlc,5,15"
toMonitor(27) = "tmc_in,5,15"
toMonitor(28) = "tmc_out,5,15"
toMonitor(29) = "toautolib,5,15"


Dim queueInfo , queue , oldestMessageTime , OldestMessageAgeSeconds , message
Dim okCount, critCount, warnCount, exitState, perfData, finalOutput
Dim i, j, queueAnalysis, queueWarn, queueCrit

Set queueInfo = CreateObject("MSMQ.MSMQQueueInfo")

' Error Handling
If Err.Number <> 0 Then
	Wscript.echo "CRITICAL: MSMQueue service not installed or not started!"
	Wscript.quit(2)
End If

exitState = 2
okCount = 0
critCount = 0
warnCount = 0
perfData = "|"

For i = LBound(toMonitor) to UBound(toMonitor)
	
	queueAnalysis = Split(toMonitor(i),",")
	queueWarn = queueAnalysis(1)
	queueCrit = queueAnalysis(2)

	queueInfo.FormatName = "DIRECT=OS:.\private$\" & queueAnalysis(0)

	On Error Resume Next 
	Set queue = queueInfo.Open(32, 0) 'Peek access mode
	
	if Err.Number < 0 then
		wscript.echo "Erreur : " & Err.Number & " / QUEUE : " & queueInfo.FormatName & " n'existe pas !"
	else	
		If Err.Number > 0 then
			OldestMessageAgeSeconds = -1
		Else 

		  Set message = queue.PeekCurrent(False, false, 0)
		
			if not message is nothing then
			  oldestMessageTime = message.ArrivedTime
			  OldestMessageAgeSeconds = DateDiff("s", oldestMessageTime, Now)

			else
			 OldestMessageAgeSeconds = 0

			End If
		End If
	End If
	
	If ( OldestMessageAgeSeconds > Cint(queueCrit) ) then
		finalOutput = finalOutput & "CRITICAL: " & queueAnalysis(0) & ": " & OldestMessageAgeSeconds & " seconds ! "
		critCount = critCount + 1
				
	ElseIf OldestMessageAgeSeconds >= Cint(queueWarn) Then
		finalOutput = finalOutput & "WARNING: " & queueAnalysis(0) & ": " & OldestMessageAgeSeconds & " seconds! "
		warnCount = warnCount + 1

	Else
		okCount = okCount + 1
	End If
	
	perfData = perfData & queueAnalysis(0) & "=" & OldestMessageAgeSeconds & ";" & queueWarn & ";" & queueCrit & " "
		
Next


' Script exit state
If critCount <> 0 Then
	exitState = 2
ElseIf warnCount <> 0 Then
	exitState = 1
Elseif critCount = 0 AND warnCount = 0 Then
	exitState = 0
End If


If okCount <> 0 Then
	finalOutput = finalOutput + "OK: " & okCount & " queues without problem."
End If
finalOutput = finalOutput & perfData
Wscript.echo finalOutput
Wscript.quit(exitState)