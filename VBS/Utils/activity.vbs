Dim WSHShell

Set WSHShell = CreateObject("WScript.Shell")

Do While True
WSHShell.SendKeys "."
WScript.Sleep 9000
Loop