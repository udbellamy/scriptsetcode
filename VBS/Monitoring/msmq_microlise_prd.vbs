Option explicit

' Queues to monitor
Dim toMonitor(25)
toMonitor(0) = "avlfaileddatainsert,16000,17000"
toMonitor(1) = "email_send,400,500"
toMonitor(2) = "esiinqueue,500,600"
toMonitor(3) = "esioutqueue,500,600"
toMonitor(4) = "ivcservicein,50,100"
toMonitor(5) = "ivcserviceout,500,600"
toMonitor(6) = "loopbackin,500,600"
toMonitor(7) = "loopbackout,500,600"
toMonitor(8) = "mccpm,500,600"
toMonitor(9) = "mdlccontroltimeouts,500,600"
toMonitor(10) = "mdtservicefailed,500,600"
toMonitor(11) = "mdtservicein,500,600"
toMonitor(12) = "mdtserviceout,500,600"
toMonitor(13) = "mdtspingin,500,600"
toMonitor(14) = "mdtspingout,500,600"
toMonitor(15) = "mfd_cpm_mcs_inbound,500,600"
toMonitor(16) = "mobiledlclog,500,600"
toMonitor(17) = "mobiletodlc,500,600"
toMonitor(18) = "sms_send,500,600"
toMonitor(19) = "tmc_in,500,600"
toMonitor(20) = "tmc_out,500,600"
toMonitor(21) = "toautolib,50,75"
toMonitor(22) = "udpserverinvalidmessagequeue,500,600"
toMonitor(23) = "udpserverinvalidmobilemessagequeue,500,600"
toMonitor(24) = "ivcserviceg2in,50,100"
toMonitor(25) = "ivcserviceg3in,50,100"


Dim serverQueues, objMsmqApp, objMsmqMgmt
Dim messageCount, globalCount, nfCount, okCount, critCount, warnCount, exitState, perfData, finalOutput
Dim i, j, queueAnalysis, queueName, queueWarn, queueCrit, nfNames

Set objMsmqApp = CreateObject("MSMQ.MSMQApplication")
On Error Resume Next
serverQueues = objMsmqApp.PrivateQueues


' Error Handling
If Err.Number <> 0 Then
	Wscript.echo "CRITICAL: MSMQueue service not installed or not started!"
	Wscript.quit(2)
End If


exitState = 2
globalCount = 0
messageCount = 0
nfCount = 0
okCount = 0
critCount = 0
warnCount = 0
perfData = "|"


For i = LBound(toMonitor) to UBound(toMonitor)
	
	queueAnalysis = Split(toMonitor(i),",")
	queueName = objMsmqApp.Machine & "\private$\" & queueAnalysis(0)
	queueWarn = queueAnalysis(1)
	queueCrit = queueAnalysis(2)
	
	For j = LBound(serverQueues) to UBound(serverQueues)
			
			Set objMsmqMgmt = CreateObject("MSMQ.MSMQManagement")
					
			If ucase(serverQueues(j)) = ucase(queueName) Then
								
				serverQueues(j) = "DIRECT=OS:" & serverQueues(j)
				On Error Resume Next
				objMsmqMgmt.Init ,,serverQueues(j)
				messageCount = objMsmqMgmt.MessageCount				
				
				If Cint(messageCount) >= Cint(queueCrit) Then
					
					finalOutput = finalOutput & "CRITICAL: " & queueAnalysis(0) & ": " & messageCount & " messages! "
					critCount = critCount + 1
					
				ElseIf Cint(messageCount) >= Cint(queueWarn) Then
					
					finalOutput = finalOutput & "WARNING: " & queueAnalysis(0) & ": " & messageCount & " messages! "
					warnCount = warnCount + 1
				
				Else
				
					okCount = okCount + 1
				
				End If
				
				globalCount = globalCount + 1
				serverQueues(j) = "null"
				perfData = perfData & queueAnalysis(0) & "=" & messageCount & ";" & queueWarn & ";" & queueCrit & " "
				messageCount = 0
				
			End If	
				
	Next
		
	If globalCount <> i+1 Then
		globalCount = globalCount + 1
		critCount = critCount + 1
		nfCount = nfCount + 1
		nfNames = nfNames & queueAnalysis(0) & ", "
		perfData = perfData & queueAnalysis(0) & "=0;" & queueWarn & ";" & queueCrit & " "
	End If
			
Next

If nfCount <> 0 Then
	finalOutput = finalOutput & "CRITICAL: " & nfNames & "not found!"
	finalOutput = Replace(finalOutput, ", not found!", " not found! ")
End If

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
