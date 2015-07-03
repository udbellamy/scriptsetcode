Option explicit

' Queues to monitor
Dim toMonitor(21)
toMonitor(0) = "avlfaileddatainsert,400,500"
toMonitor(1) = "esiinqueue,500,600"
toMonitor(2) = "esioutqueue,500,600"
toMonitor(3) = "ivcservicein,100,600"
toMonitor(4) = "ivcserviceout,500,600"
toMonitor(5) = "loopbackin,500,600"
toMonitor(6) = "loopbackout,500,600"
toMonitor(7) = "mccpm,500,600"
toMonitor(8) = "mdlccontroltimeouts,500,600"
toMonitor(9) = "mdtservicefailed,500,600"
toMonitor(10) = "mdtservicein,500,600"
toMonitor(11) = "mdtserviceout,500,600"
toMonitor(12) = "mdtspingin,500,600"
toMonitor(13) = "mdtspingout,500,600"
toMonitor(14) = "mfd_cpm_mcs_inbound,500,600"
toMonitor(15) = "mobiledlclog,500,600"
toMonitor(16) = "mobiletodlc,500,600"
toMonitor(17) = "tmc_in,500,600"
toMonitor(18) = "tmc_out,500,600"
toMonitor(19) = "toautolib,500,600"
toMonitor(20) = "udpserverinvalidmessagequeue,500,600"
toMonitor(21) = "udpserverinvalidmobilemessagequeue,500,600"


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
