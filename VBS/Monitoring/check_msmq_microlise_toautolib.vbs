Option explicit

' Queues to monitor
Dim toMonitor(21)
toMonitor(0) = "toautolib,50,75"


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
