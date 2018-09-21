#NoEnv
#Include tf.ahk
SendMode Input
SetWorkingDir %A_ScriptDir%
SetBatchLines,10ms
#SingleInstance Force
FileReadLine, RecoCups, UserInfo.txt, 11
FileReadLine, Time1, UserInfo.txt, 8
FileReadLine, Time2, UserInfo.txt, 9

;Set System Tray Right Click Menu
Menu, Tray, Icon, Smart Water Icon.ico
Menu, Tray, NoStandard
Menu, Tray, Add, Open Smart Water Dashboard, OpenGUI
Menu, Tray, Add, Log hydration, LogWater
Menu, Tray, Add
Menu, Tray, Add, Help
Menu, Tray, Add, About
Menu, Tray, Add
Menu, Tray, Add, Options..., Options
Menu, Tray, Add, Exit

;Add shortcut to start up at computer start up
StartupCommon = %A_Startup%\Smart Water Internal.lnk
ShortCutFile = %A_ScriptDir%\Smart Water Internal.exe
FileSetAttrib, -R, %A_Startup%
if !FileExist("%StartupCommon%")
	FileCreateShortcut, %ShortCutFile%, %StartupCommon%

StartupCommon = %A_Startup%\Smart Water Facts.lnk
ShortCutFile = %A_ScriptDir%\Smart Water Facts.exe
if !FileExist("%StartupCommon%")
	FileCreateShortcut, %ShortCutFile%, %StartupCommon%

StartupCommon = %A_Startup%\Smart Water.lnk
ShortCutFile = %A_ScriptDir%\Smart Water.exe
if !FileExist("%StartupCommon%")
	FileCreateShortcut, %ShortCutFile%, %StartupCommon%
FileSetAttrib, +R, %A_Startup%

;Calculate at what intervals to give reminders
Time1N = %Time1%
Time2N = %Time2%
Time1 = 20180906%Time1%00
Time2 = 20180906%Time2%00

TimeResultUser := FormatMin(Time(Time2,Time1,"m"))
TimeResult := Round(Time(Time2,Time1,"s"), 0)
TimeResultMin := Round(Time(Time2,Time1,"m"), 0)



;Time library
SetBatchLines,-1

Time(to,from="",units="d",params=""){
	static _:="0000000000",s:=1,m:=60,h:=3600,d:=86400
				,Jan:="01",Feb:="02",Mar:="03",Apr:="04",May:="05",Jun:="06",Jul:="07",Aug:="08",Sep:="09",Okt:=10,Nov:=11,Dec:=12
	r:=0
	units:=units ? %units% : 8640
	If (InStr(to,"/") or InStr(to,"-") or InStr(to,".")){
		Loop,Parse,to,/-.,%A_Space%
			_%A_Index%:=RegExMatch(A_LoopField,"\d+") ? A_LoopField : %A_LoopField%
			,_%A_Index%:=(StrLen(_%A_Index%)=1 ? "0" : "") . _%A_Index%
		to:=SubStr(A_Now,1,8-StrLen(_1 . _2 . _3)) . _3 . (RegExMatch(SubStr(to,1,1),"\d") ? (_2 . _1) : (_1 . _2))
		_1:="",_2:="",_3:=""
	}
	If (from and InStr(from,"/") or InStr(from,"-") or InStr(from,".")){
		Loop,Parse,from,/-.,%A_Space%
			_%A_Index%:=RegExMatch(A_LoopField,"\d+") ? A_LoopField : %A_LoopField%
			,_%A_Index%:=(StrLen(_%A_Index%)=1 ? "0" : "") . _%A_Index%
		from:=SubStr(A_Now,1,8-StrLen(_1 . _2 . _3)) . _3 . (RegExMatch(SubStr(from,1,1),"\d") ? (_2 . _1) : (_1 . _2))
	}
   count:=StrLen(to)<9 ? "days" : StrLen(to)<11 ? "hours" : StrLen(to)<13 ? "minutes" : "seconds"
	to.=SubStr(_,1,14-StrLen(to)),(from ? from.=SubStr(_,1,14-StrLen(from)))
	Loop,Parse,params,%A_Space%
		If (unit:=SubStr(A_LoopField,1,1))
			 %unit%1:=InStr(A_LoopField,"-") ? SubStr(A_LoopField,2,InStr(A_LoopField,"-")-2) : ""
			,%unit%2:=SubStr(A_LoopField,InStr(A_LoopField,"-") ? (InStr(A_LoopField,"-")+1) : 2)
	count:=!params ? count : "seconds"
	add:=!params ? 1 : (S2="" ? (M2="" ? (H2="" ? ((D2="" and B2="" and W="") ? d : h) : m) : s) : s)
	While % (from<to){
		FormatTime,year,%from%,YYYY
		FormatTime,month,%from%,MM
		FormatTime,day,%from%,dd
		FormatTime,hour,%from%,H
		FormatTime,minute,%from%,m
		FormatTime,second,%from%,s
		FormatTime,WDay,%from%,WDay
		EnvAdd,from,%add%,%count%
		If (W1 or W2){
			If (W1=""){
				If (W2=WDay or InStr(W2,"." . WDay) or InStr(W2,WDay . ".")){
					Continue=1
				}
			} else If WDay not Between %W1% and %W2%
				Continue=1
			;else if (Wday=W2)
			;	Continue=1
			If (Continue){
				tempvar:=SubStr(from,1,8)
				EnvAdd,tempvar,1,days
				EnvSub,tempvar,%from%,seconds
				EnvAdd,from,%tempvar% ,seconds
				Continue=
				continue
			}
		}
		If (D1 or D2 or B2){
			If (D1=""){
				If (D2=day or B2=(day . month) or InStr(B2,"." . day . month) or InStr(B2,day . month . ".") or InStr(D2,"." . day) or InStr(D2,day . ".")){
					Continue=1
				}
			} else If day not Between %D1% and %D2%
				Continue=1
			;else if (day=D2)
			;	Continue=1
			If (Continue){
				tempvar:=SubStr(from,1,8)
				EnvAdd,tempvar,1,days
				EnvSub,tempvar,%from%,seconds
				EnvAdd,from,%tempvar% ,seconds
				Continue=
				continue
			}
		}
		If (H1 or H2){
			If (H1=""){
				If (H2=hour or InStr(H2,hour . ".") or InStr(H2,"." hour)){
					Continue=1
				}
			} else If hour not Between %H1% and %H2%
				continue=1
			;else if (hour=H2)
			;	continue=1
			If (continue){
				tempvar:=SubStr(from,1,10)
				EnvAdd,tempvar,1,hours
				EnvSub,tempvar,%from%,seconds
				EnvAdd,from,%tempvar% ,seconds
				continue=
				continue
			}
		}
		If (M1 or M2){
			If (M1=""){
				If (M2=minute or InStr(M2,minute . ".") or InStr(M2,"." minute)){
					Continue=1
				}
			} else If minute not Between %M1% and %M2%
				continue=1
			;else if (minute=M2)
			;	continue=1
			If (continue){
				tempvar:=SubStr(from,1,12)
				EnvAdd,tempvar,1,minutes
				EnvSub,tempvar,%from%,seconds
				EnvAdd,from,%tempvar% ,seconds
				continue=
				continue
			}
		}
		If (S1 or S2){
			If (S1=""){
				If (S2=second or InStr(S2,second . ".") or InStr(S2,"." second)){
					Continue
				}
			} else if (second!=S2)
				If second not Between %S1% and %S2%
					continue
		}
		r+=add
	}
	tempvar:=SubStr(count,1,1)
	tempvar:=%tempvar%
	Return (r*tempvar)/units
}

SetBatchLines,10ms

FormatMin(vMin)
{
	if (vMin < 1440)
		return Format("{}:{:02}", Floor(Mod(vMin,1440)/60), Floor(Mod(vMin,60)))
	else
		return Format("{}:{:02}:{:02}", Floor(vMin/1440), Floor(Mod(vMin,1440)/60), Floor(Mod(vMin,60)))
}

Intervals := Round(TimeResult / RecoCups, 0)
IntervalsHHMMSS := FormatSeconds(Intervals) ;This is the finished times at what to give intervals, in HHmmss format

;MsgBox, %IntervalsHHMMSS%
FormatSeconds(NumberOfSeconds)
{
    time = 19990101
    time += %NumberOfSeconds%, seconds
    FormatTime, mmss, %time%, mm:ss
    return NumberOfSeconds//3600 ":" mmss
}

;Now calculate the times to give the reminders
intervals_array := StrSplit(IntervalsHHMMSS, ":")
IntervalsNew := intervals_array[1] . intervals_array[2] . intervals_array[3]
StartTime = %Time1N%00
FinishTime = %Time2N%00
Time_Start_Sec := StrSplit(Time1N)
TempHo1 := Time_Start_Sec[1] . Time_Start_Sec[2]
TempHo2 := Time_Start_Sec[3] . Time_Start_Sec[4]
TimeStartSec := TempHo1*3600 + TempHo2*60

Time_Start_Sec := StrSplit(Time2N)
TempHo1 := Time_Start_Sec[1] . Time_Start_Sec[2]
TempHo2 := Time_Start_Sec[3] . Time_Start_Sec[4]
TimeFinishSec := TempHo1*3600 + TempHo2*60

;MsgBox, %Time1N% to %StartTime% to %TimeStartSec%, and %Time2N% to %FinishTime% to %TimeFinishSec%

/* Variables we currently have:
Time1: Start time in HHmm format e.g. 0700
Time2: End time in HHmm format e.g. 1900
StartTime: Start time in HHmmss format e.g. 070000
FinishTime: Finish time in HHmmss format e.g. 190000
TimeStartSec: Start time in seconds e.g. 7200000
TimeFinishSec: Finish time in seconds e.g. 18000000
IntervalsHHMMSS: Intervals in HH:mm:ss format e.g. 03:00:00
IntervalsNew: Intervals in Hmmss format e.g. 30000
Intervals: Intervals in seconds e.g. 720000
A_Hour: Current Hour in (00-23) in HH format e.g. 08
A_Min: Current 2-digit Minute (00-59) e.g. 54
A_Sec: Current 2-digit Second (00-59) e.g. 50
*/

loop, %RecoCups%
{
	RepoSecs%A_Index% := TimeStartSec + Intervals*A_Index
	%A_Index% := TimeStartSec + Intervals*A_Index
	RepoMins%A_Index% := FormatSeconds(%A_Index%)
	CurNameN := "RepoMins"A_Index
	/*Time_Start_Sec := StrSplit(%CurNameN%)
	TempHo1 := Time_Start_Sec[1] . Time_Start_Sec[2]
	TempHo2 := Time_Start_Sec[4] . Time_Start_Sec[5]
	RepoMins%A_Index% := TempHo1 . TempHo2 . 00
	*/
}

;Now create a loop that waits for the specified times, and then calls up the DrinkWaterReminder subroutine to create a toast notification
Loop %RecoCups%
{
	TimeFull = %A_Hour%:%A_Min%:%A_Sec%
	Name := "RepoMins"A_Index
	if (StrLen(%Name%) = 7)
		%Name% := 0 . %Name%
	while %Name% > TimeFull
	{
		TimeFull = %A_Hour%:%A_Min%:%A_Sec%
		Sleep, 900
	}
	gosub, DrinkWaterReminder
}

return

DrinkWaterReminder:
TrayTip, Smart Water Reminder, Make sure you remember to drink water! Click here to log how much you have drunk so far today.
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

OpenGUI:
;Open Main GUI for the app (Smart Water.ahk)
Run, Smart Water.ahk
Return

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

Help:
Gui, Destroy
Gui, Font, s9 bold
Gui, Add, Text, x-2 w504 center, Help with Smart Water
Gui, Font, s9 Norm
FileRead, HelpSmartWater, Help.txt
Gui, Add, Edit, +ReadOnly x10 w500 R10, %HelpSmartWater%
Gui, Add, Button, x10 w500 gCloseN h30 vClose, Close
Gui, Color, 97befc
Gui, Show,, Smart Water Help
GuiControl, Focus, Close
return

About:
Gui, Destroy
Gui, Font, s9 bold
Gui, Add, Text, x-2 w504 center, About Smart Water
Gui, Font, s9 Norm
FileRead, AboutSmartWater, About.txt
Gui, Add, Edit, +ReadOnly x10 w500 R10, %AboutSmartWater%
Gui, Add, Button, x10 w500 gCloseN h30 vClose, Close
Gui, Color, 97befc
Gui, Show,, About Smart Water
GuiControl, Focus, Close
return

Options:
/*
Here is what is required in the GroupBox function:

GroupBox(GBvName			;Name for GroupBox control variable
		,Title				;Title for GroupBox
		,TitleHeight		;Height in pixels to allow for the Title
		,Margin				;Margin in pixels around the controls
		,Piped_CtrlvNames	;Pipe (|) delimited list of Controls
		,FixedWidth=""		;Optional fixed width
		,FixedHeight="")	;Optional fixed height
*/

;Retrieve the current info
FileReadLine, YourNameN, UserInfo.txt, 3
FileReadLine, YourAgeN, UserInfo.txt, 4
FileReadLine, YourWeightN, UserInfo.txt, 5
FileReadLine, FitnessCat, UserInfo.txt, 7
FileReadLine, Time1N, UserInfo.txt, 8
FileReadLine, Time2N, UserInfo.txt, 9
Time1N = 20180101%Time1N%00
Time2N = 20180101%Time2N%00

;Add the GUI Controls and window
Gui, Destroy
GBTHeight:=10
Gui, +LastFound
Gui, Font, s9 Bold
Gui, Add, Text, vFirstName, Your First Name
Gui, Font, s9 norm
Gui, Add, Edit, Section vNameControl xMargin w300, %YourNameN%
Gui, Font, Bold
Gui, Add, Text, vAge, Your Age
Gui, Font, norm
Gui, Add, Edit, +ReadOnly vAgeControl xMargin w300
Gui, Add, UpDown, vYourAge Range10-150, %YourAgeN%
Gui, Font, Bold
Gui, Add, Text, vWeight, Your Weight
Gui, Font, norm
Gui, Add, Edit, vWeightControl xMargin w300 +ReadOnly
Gui, Add, UpDown, vYourWeight Range1-300, %YourWeightN%
GroupBox("General", "General", GBTHeight, 10, "FirstName|NameControl|Age|AgeControl|YourAge|Weight|WeightControl|YourWeight", "320")

Gui, Font, s9 Bold
Gui, Add, Text, vRemindersL, Times to recieve reminders
Gui, Font, s9 norm
Gui, Add, Datetime, w300 1 Choose%Time1N% vTimeFrom, ' From' hh:mm tt
Gui, Add, Datetime, w300 1 Choose%Time2N% vTimeTo, ' To' hh:mm tt
Gui, Add, Checkbox, vFunFactsL, Recieve a fun fact on hydration daily
GroupBox("Reminders", "Reminders", GBTHeight, 10, "RemindersL|TimeFrom|TimeTo|FunFactsL", "320")

Gui, Font, s9 Bold
Gui, Add, Text, vFitnessCat, Your Fitness Category
Gui, Font, s9 norm
if (FitnessCat = "No exercise")
{
	Gui, Add, Radio, vCheckBox1 Checked, No exercise
	Gui, Add, Radio, vCheckBox2, Light exercise
	Gui, Add, Radio, vCheckBox3, Mild exercise
	Gui, Add, Radio, vCheckBox4, Moderate exercise
	Gui, Add, Radio, vCheckBox5, Vigorous exercise
}
	
else if (FitnessCat = "Light exercise")
{
	Gui, Add, Radio, vCheckBox1, No exercise
	Gui, Add, Radio, vCheckBox2 Checked, Light exercise
	Gui, Add, Radio, vCheckBox3, Mild exercise
	Gui, Add, Radio, vCheckBox4, Moderate exercise
	Gui, Add, Radio, vCheckBox5, Vigorous exercise
}

else if (FitnessCat = "Mild exercise")
{
	Gui, Add, Radio, vCheckBox1, No exercise
	Gui, Add, Radio, vCheckBox2, Light exercise
	Gui, Add, Radio, vCheckBox3 Checked, Mild exercise
	Gui, Add, Radio, vCheckBox4, Moderate exercise
	Gui, Add, Radio, vCheckBox5, Vigorous exercise
}

else if (FitnessCat = "Moderate exercise")
{
	Gui, Add, Radio, vCheckBox1, No exercise
	Gui, Add, Radio, vCheckBox2, Light exercise
	Gui, Add, Radio, vCheckBox3, Mild exercise
	Gui, Add, Radio, vCheckBox4 Checked, Moderate exercise
	Gui, Add, Radio, vCheckBox5, Vigorous exercise
}

else if (FitnessCat = "Vigorous exercise")
{
	Gui, Add, Radio, vCheckBox1, No exercise
	Gui, Add, Radio, vCheckBox2, Light exercise
	Gui, Add, Radio, vCheckBox3 Checked, Mild exercise
	Gui, Add, Radio, vCheckBox4, Moderate exercise
	Gui, Add, Radio, vCheckBox5 Checked, Vigorous exercise
}
GroupBox("Fitness Category", "Fitness Category", GBTHeight, 10, "FitnessCat|CheckBox1|CheckBox2|CheckBox3|CheckBox4|CheckBox5", "320")

Gui, Add, Button, h40 w130 y470 x10 gApplySettings, Apply (recalculate recommendation)
Gui, Add, Button, h40 w90 y470 x145 gCloseN, Close
Gui, Add, Button, h40 w90 y470 x240 gCloseN, Cancel

Gui, Color, 97befc
Gui, Show, , Smart Water Options



;Groupbox function
GroupBox(GBvName			;Name for GroupBox control variable
		,Title				;Title for GroupBox
		,TitleHeight		;Height in pixels to allow for the Title
		,Margin				;Margin in pixels around the controls
		,Piped_CtrlvNames	;Pipe (|) delimited list of Controls
		,FixedWidth=""		;Optional fixed width
		,FixedHeight="")	;Optional fixed height
{
	Local maxX, maxY, minX, minY, xPos, yPos ;all else assumed Global
	minX:=99999
	minY:=99999
	maxX:=0
	maxY:=0
	Loop, Parse, Piped_CtrlvNames, |, %A_Space%
	{
		;Get position and size of each control in list.
		GuiControlGet, GB, Pos, %A_LoopField%
		;creates GBX, GBY, GBW, GBH
		if(GBX<minX) ;check for minimum X
			minX:=GBX
		if(GBY<minY) ;Check for minimum Y
			minY:=GBY
		if(GBX+GBW>maxX) ;Check for maximum X
			maxX:=GBX+GBW
		if(GBY+GBH>maxY) ;Check for maximum Y
			maxY:=GBY+GBH

		;Move the control to make room for the GroupBox
		xPos:=GBX+Margin
		yPos:=GBY+TitleHeight+Margin ;fixed margin
		GuiControl, Move, %A_LoopField%, x%xPos% y%yPos%
	}
	;re-purpose the GBW and GBH variables
	if(FixedWidth)
		GBW:=FixedWidth
	else
		GBW:=maxX-minX+2*Margin ;calculate width for GroupBox
	if(FixedHeight)
		GBH:=FixedHeight
	else
		GBH:=maxY-MinY+TitleHeight+2*Margin ;calculate height for GroupBox ;fixed 2*margin

	;Add the GroupBox
	Gui, Add, GroupBox, v%GBvName% x%minX% y%minY% w%GBW% h%GBH%, %Title%
	return
}

return

ApplySettings:
;Get the values of all the options
GuiControlGet, NameControl
GuiControlGet, YourAge
GuiControlGet, YourWeight
GuiControlGet, CheckBox1
GuiControlGet, CheckBox2
GuiControlGet, CheckBox3
GuiControlGet, CheckBox4
GuiControlGet, CheckBox5
GuiControlGet, TimeFrom
GuiControlGet, TimeTo
FormatTime, TimeFromNew, %TimeFrom%, HHmm
FormatTime, TimeToNew, %TimeTo%, HHmm
FileReadLine, CurrentDateN, UserInfo.txt, 2
FileReadLine, Gender, UserInfo.txt, 6

;Make sure you entered your Name
if (NameControl = "") 
{
	MsgBox, 48, Error, Please enter your name
	return
}

;Make sure the start time and end times are valid
if (TimeFromNew >= TimeToNew)
{
	MsgBox, 48, Error, Please make sure that your starting time to recieve reminders is earlier than the finish time.
	return
}

if (TimeFromNew + 100 >= TimeToNew)
{
	MsgBox, 48, Error, Please make the amount of time to recieve reminders more than 1 hour.
	return
}

;Check what fitness category you selected
if CheckBox1
	FitnessCat = No Exercise
if CheckBox2
	FitnessCat = Light Exercise
if CheckBox3
	FitnessCat = Mild Exercise
if CheckBox4
	FitnessCat = Moderate Exercise
if CheckBox5
	FitnessCat = Vigorous Exercise

;Re-calculate your recommendation, and alert user if it has changed
FileReadLine, RecoCupsOld, UserInfo.txt, 11
Gosub, RecoMath
if (RecoCupsOld != RecoCups)
{
if (FitnessCat = "No Exercise" or FitnessCat = "Light Exercise")
	MsgBox, 64, Smart Water Recommendation, Your new daily hydration recommendation is about %RecoCups% cups of water (%RecoMillis%mL). Remember that for every 10-20 minutes you exercise, you should drink 200-300mL (1 cup) of water.
if (FitnessCat = "Mild Exercise" or FitnessCat = "Moderate Exercise")
	MsgBox, 64, Smart Water Recommendation, Your new daily hydration recommendation is about %RecoCups% cups of water (%RecoMillis%mL). Remember that for every 10-20 minutes you exercise, you should drink 200-300mL (1 cup) of water, and even more if you sweat alot.
if (FitnessCat = "Vigorous Exercise")
	MsgBox, 64, Smart Water Recommendation, Your new daily hydration recommendation is about %RecoCups% cups of water (%RecoMillis%mL). Remember that for every 10-20 minutes you exercise, you should drink 200-300mL (1 cup) of water, and even more if you sweat alot. This is very important since you exercise so much.
}
;Save the new values in UserInfo.txt
FileSetAttrib, -RH, UserInfo.txt
FileDelete, UserInfo.txt
FileAppend,Yes, UserInfo.txt
FileAppend,`n%CurrentDateN%, UserInfo.txt
FileAppend,`n%NameControl%, UserInfo.txt
FileAppend,`n%YourAge%, UserInfo.txt
FileAppend,`n%YourWeight%, UserInfo.txt
FileAppend,`n%Gender%, UserInfo.txt
FileAppend,`n%FitnessCat%, UserInfo.txt
FileAppend,`n%TimeFromNew%, UserInfo.txt
FileAppend,`n%TimeToNew%, UserInfo.txt
FileAppend,`n%RecoMillis%, UserInfo.txt
FileAppend,`n%RecoCups%, UserInfo.txt
FileSetAttrib, +RH, UserInfo.txt

;Alert the user of success
MsgBox, 64, Smart Water, Successfully applied the new settings.
return

RecoMath:
/*
Variables:
Name: NAME
Age: YourAge
Weight: YourWeight
Gender: Gender
Fitness Category: FitnessCat

Output mL = RecoMillis
Output cups no. = RecoCups
*/

if YourAge between 10 and 13
{
	if (Gender = "Male")
	{
		RecoMillis = 1600
		RecoCups = 6
		return
	}
	
	else
	{
		RecoMillis = 1400
		RecoCups = 5
		return
	}
}

if YourAge between 14 and 18
{
	if (Gender = "Male")
	{
		RecoMillis = 1900
		RecoCups = 8
		return
	}
	
	else
	{
		RecoMillis = 1600
		RecoCups = 6
		return
	}
}

if YourAge between 19 and 150
{
	if (Gender = "Male")
	{
		RecoMillis = 2600
		RecoCups = 10
		return
	}
	
	else
	{
		RecoMillis = 2100
		RecoCups = 8
		return
	}
}
return

Exit:
Process, Close, Smart Water Facts.exe
ExitApp