#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#NoTrayIcon
; #Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent

;Add shortcut to start up at computer start up
StartupCommon = %A_Startup%\12Hour Refresh TM.lnk
ShortCutFile = %A_ScriptDir%\12Hour Refresh TM.exe
FileSetAttrib, -R, %A_Startup%
if !FileExist("%StartupCommon%")
	FileCreateShortcut, %ShortCutFile%, %StartupCommon%
FileSetAttrib, +R, %A_Startup%

Loop
{
	CurTime = %A_Hour%%A_Min%%A_Sec%
	if (CurTime = 000000)
	{
		Process, Close, Smart Water.exe
		Process, Close, Smart Water Internal.exe
		Process, Close, Smart Water Facts.exe
		Sleep, 1000
		Run, Smart Water Internal.exe
		Run, Smart Water Facts.exe
		Sleep, 1000
	}
	
	else
	{
		CurTime = %A_Hour%%A_Min%%A_Sec%
	}
}