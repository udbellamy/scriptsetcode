Option Explicit

Dim MSQ, QUEUE, COUNT, COUNTMAX

Dim MSMQQueue, MSMQQueueInfo

REM --------------------------------------------------------------

REM Script de Purge de file MSMQ en fonction du nombre de messages

REM Celien LEGENT - Equipe Architecture - 12.12.2014

REM --------------------------------------------------------------

REM Utilisation :

REM Indiquer le nom de la file cible dans QUEUE ="..."

REM Indiquer la limitation de messages dans COUNTMAX ="..."

REM ----------------------------------------------------------

QUEUE ="mobiletodlc"

COUNTMAX = "500"

REM ----------------------------------------------------------

Set MSQ = CreateObject("MSMQ.MSMQManagement")

MSQ.Init "localhost", , "DIRECT=OS:localhost\private$\" & QUEUE

COUNT = msQ.MessageCount

REM ----------------------------------------------------------

Set MSMQQueueInfo = CreateObject("MSMQ.MSMQQueueInfo")

MSMQQueueInfo.PathName = ".\private$\" & QUEUE

Set MSMQQueue = MSMQQueueInfo.Open(1, 0)

REM ----------------------------------------------------------

' Purge de la file MobileToDLC
' Version: 0.2
' Date: 10/02/2015
'queueInfo.PathName = ".\private$\mobiletodlc"
' Assuming you've already ran Blat --install command
' Blat -install <server addr> <sender's addr> [<try>[<port>[<profile>]]] [-q]
 
' MQ Configuration
Const MQ_RECEIVE_ACCESS = 1
Const MQ_DENY_NONE      = 0 
Const MQ_NO_TRANSACTION = 0
Const MQ_SINGLE_MESSAGE = 3
Const g_receiveTimeout  = 1000
Const MQ_QUEUE_PATHNAME = ".\private$\mobiletodlc"

' Mail Configuration
Const BLAT          = "C:\Blat\blat.exe"
Const MAIL_TO       = "#set mail here#"
Const MAIL_SUBJECT  = "ATTENTION - Purge de la file mobiletodlc"
Const MAIL_PROFILE	= "#set profile here#"

Dim blatCmdLine, mail_body


	If Cint (COUNT) >= Cint (COUNTMAX) Then 
	
		
		wscript.echo(Now)

		wscript.echo "KO, " & COUNT & " messages, depasse la limite de " & COUNTMAX & " messages"

		wscript.echo "Purge en cours..."

		MSMQQueue.Purge

		wscript.echo "Fin de purge, envoi du mail à l'équipe d'exploitation"
		mail_body = "ATTENTION : " & COUNT & " messages purgés dans la file mobiletodlc."

		' Building Blat command line
		blatCmdLine = BLAT & " -to " & MAIL_TO & " -subject " & """" & MAIL_SUBJECT & """" & " -body " & """" & mail_body & """" & " -p " & MAIL_PROFILE
		Wscript.echo blatCmdLine
		' Send mail with Blat
		Dim wshshell
		Set wshshell = WScript.CreateObject("WScript.Shell")
		wshshell.Run blatCmdLine, 1, True	

	Else 
		
		
		wscript.echo(Now)
		
		
		wscript.echo "OK, " & COUNT & " messages"


	End If