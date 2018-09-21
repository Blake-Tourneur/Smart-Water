#NoEnv
#Include tf.ahk
SendMode Input
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
FileReadLine, Time1, UserInfo.txt, 8
FileReadLine, FunFactN, UserInfo.txt, 12
Menu, Tray, NoStandard
Menu, Tray, Icon, Smart Water Icon.ico
Menu, Tray, NoIcon

if (FunFactN = 1)
{
;Calculate one hour after the starting time you want to recieve reminders
RemTime := Time1 + 100
RemTime = %RemTime%00
if (StrLen(RemTime) = 5)
	RemTime = 0%RemTime%

;Now create a loop that waits for the specified times, and then calls up the FunFact subroutine to create a toast notification
Loop, 1
{
	TimeFull = %A_Hour%%A_Min%%A_Sec%
	while TimeFull < %RemTime%
	{
		TimeFull = %A_Hour%%A_Min%%A_Sec%
		Sleep, 900
	}
	gosub, FunFact
}

}
return

FunFact:
URLDownloadToFile, https://pastebin.com/raw/ieJnXL0r, Fun Facts.txt
FileRead, Text, Fun Facts.txt
Loop, Parse, Text, `n, `r
    LastNumR := A_Index
Random, lineR, 1, %LastNumR%
FileReadLine, YourFunFact, Fun Facts.txt, %lineR%
Menu, Tray, Icon
TrayTip, Smart Water Fun Fact, Here is your daily fun fact: %YourFunFact%,, 32
Menu, Tray, NoIcon
OnMessage(0x404, Func("AHK_NOTIFYICON"))
AHK_NOTIFYICON(wParam, lParam, msg, hwnd)
{
	if (hwnd != A_ScriptHwnd)
		return
	if (lParam = 1029) {
		;Open a GUI window to log how much water you have drunk
		Gosub, LogWater
	}
}
return

LogWater:
Gosub, CalculateToday
Gui, Destroy
Gui, Font, Bold s9
Gui, Add, Text, x10, Log how many glasses of water you have drunk so far today below (1 glass is 250mL):
Gui, Font, norm
Gui, Add, Edit, w210 y+10 x10 +ReadOnly
Gui, Add, UpDown, Range0-100 vWaterToday gUngrayApply y+10 x10, %WaterToday%
FileReadLine, RecoCupsN, UserInfo.txt, 11
FileReadLine, RecoMilsN, UserInfo.txt, 10
Gui, Font, bold
Gui, Add, Text, ,Remember your goal is %RecoCupsN% cups of water (%RecoMilsN%mL)
Gui, Font, norm
Gui, Add, Button, h30 x10 y80 w100 gLogWaterApply vApplyWat, Apply
Gui, Add, Button, y80 x120 gCloseN h30 w100, Close
GuiControl, Disable, ApplyWat
Gui, Color, 97befc
Gui, Show,, Today's Hydration
Return

UngrayApply:
GuiControl, Enable, ApplyWat
return

CloseN:
Gui, Destroy
return

LogWaterApply:
GuiControl, Disable, ApplyWat
GuiControlGet, WaterToday
TodaysDate = %A_YYYY%%A_MM%%A_DD%
if FileExist("WaterLog.txt")
{
	FileRead, Text, DatesLog.txt
	Loop, Parse, Text, `n, `r
		FileListNoN := A_Index
	FileReadLine, testDate, DatesLog.txt, %FileListNoN%
	
	if (TodaysDate = testDate)
	{
		FileSetAttrib, -RH, WaterLog.txt
		TF_RemoveLines("WaterLog.txt", FileListNoN, FileListNoN)
		FileDelete, WaterLog.txt
		FileMove, WaterLog_copy.txt, WaterLog.txt
		FileRead, Text, DatesLog.txt
		Loop, Parse, Text, `n, `r
			FileListNoY := A_Index
		if (FileListNoY = "1")
			FileAppend,%WaterToday%, WaterLog.txt
		else
			FileAppend,`n%WaterToday%, WaterLog.txt
		FileSetAttrib, +RH, WaterLog.txt
		FileSetAttrib, +RH, DatesLog.txt
		return
	}
	else
	{
		FileSetAttrib, -RH, WaterLog.txt
		FileSetAttrib, -RH, DatesLog.txt
		FileAppend,`n%WaterToday%, WaterLog.txt
		FileAppend,`n%TodaysDate%, DatesLog.txt
		FileSetAttrib, +RH, WaterLog.txt
		FileSetAttrib, +RH, DatesLog.txt
		return
	}
}
else
{
	FileSetAttrib, -RH, WaterLog.txt
	FileSetAttrib, -RH, DatesLog.txt
	FileAppend,%WaterToday%, WaterLog.txt
	FileAppend,%TodaysDate%, DatesLog.txt
	FileSetAttrib, +RH, WaterLog.txt
	FileSetAttrib, +RH, DatesLog.txt
	return
}
return

CalculateToday:
FileRead, Text, DatesLog.txt
Loop, Parse, Text, `n, `r
    FileListNoN := A_Index
FileReadLine, testDate, DatesLog.txt, %FileListNoN%
TodaysDate = %A_YYYY%%A_MM%%A_DD%
if (TodaysDate = testDate)
{
	FileReadLine, WaterToday, WaterLog.txt, %FileListNoN%
	return
}
else
{
	WaterToday = 0
	return
}
return