; =======================================================================================
; Name ..........: Smart Water
; Description ...: Easily keep hydrated
; Modified ......: 16.09.2018
; Version .......: v1.00
; AHK Version ...: 1.1.22.06 x64 Unicode
; Platform ......: Windows 10 Professional
; Language ......: English (en-AU)
; Author(s) .....: Blake Tourneur <blaketourneur@gmail.com>
; =======================================================================================

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include tf.ahk
#Include PleasantNotify.ahk
#Include SetBtnTxtColor.ahk
#SingleInstance Force
#NoTrayIcon

Setup:
Menu, Tray, Icon, Smart Water Icon.ico
FileReadLine, Setup, UserInfo.txt, 1
if (Setup = "")
{
	;You haven't used the app before
	Gui, Destroy
	Gui, Add, Picture, w300 h175, Smart Water Logo small.png
	Gui, Font, s20 Bold Underline
	Gui, Add, Text, x90 y+10 gSetupPartOne, Get Started
	Gui, Color, 97befc
	Gui, Show,, Smart Water
}
else
{
	;You have used the app before
	Goto, Dashboard
}
return

Exit:
ExitApp
return

GuiClose:
ExitApp
return

SetupPartOne:
Gui, Destroy
Gui, Font, Bold
Gui, Add, Text, , Welcome to Smart Water! To set correct recommendations just for you, please fill out the details below:
Gui, Font, Norm
Gui, Add, Text, , Please enter your first name:
Gui, Add, Edit, vNAME
Gui, Add, Text, , `nPlease set your age:
Gui, Add, Edit, +ReadOnly
Gui, Add, UpDown, vYourAge Range10-150, 10
Gui, Add, Text, , `nPlease set your weight in kilograms (kg):
Gui, Add, Edit, +ReadOnly
Gui, Add, UpDown, vYourWeight Range1-300, 40
Gui, Add, Text, , `nPlease select your gender:
Gui, Add, Radio, vGender1, Male
Gui, Add, Radio, vGender2, Female
Gui, Add, Text, , `nPlease select the fitness range most similiar to what you do:
Gui, Add, Radio, vCheckBox1 Checked, No exercise
Gui, Add, Radio, vCheckBox2, Light exercise
Gui, Add, Radio, vCheckBox3, Mild exercise
Gui, Add, Radio, vCheckBox4, Moderate exercise
Gui, Add, Radio, vCheckBox5, Vigorous exercise
Gui, Font, s4
Gui, Add, Text,, `n
Gui, Font, s9
Gui, Add, Button, h25 w100 y400 x10 gExit, Cancel
Gui, Add, Button, x120 y400 h25 w100 gShowReco, Next  >
Gui, Color, 97befc
Gui, Show,, Smart Water Setup
return

ShowReco:
GuiControlGet, NAME
GuiControlGet, YourAge
GuiControlGet, YourWeight
GuiControlGet, CheckBox1
GuiControlGet, CheckBox2
GuiControlGet, CheckBox3
GuiControlGet, CheckBox4
GuiControlGet, CheckBox5
GuiControlGet, Gender1
GuiControlGet, Gender2

if (NAME = "") 
{
	MsgBox, 48, Error, Please enter your name
	return
}
if (Gender1 = "0" and Gender2 = "0")
{
	MsgBox, 48, Error, Please select your gender
	return
}

;Find out what gender you are
if Gender1
	Gender = Male
else
	Gender = Female

;Find out what fitness category you are
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

Gosub, RecoMath
Gui, Destroy
Gui, Font, s9 norm
Gui, Add, Text, x-2 w504 center, Based on your age and fitness rating, the amount of water you should drink per day is:
Gui, Font, s20 bold
Gui, Add, Text, x-2 w504 center, %RecoMillis%mL
Gui, Font, s9 norm
Gui, Add, Text, x-2 w504 center, In glasses of water (250mL), this is about:
Gui, Font, s20 bold
Gui, Add, Text, x-2 w504 center, %RecoCups% glasses
Gui, Font, s9 norm
if (FitnessCat = "No Exercise" or FitnessCat = "Light Exercise")
	Gui, Add, Text, x-2 w504 center, Remember that for every 10-20 minutes you exercise, you should drink 200-300mL (1 cup) of water.
if (FitnessCat = "Mild Exercise" or FitnessCat = "Moderate Exercise")
	Gui, Add, Text, x-2 w504 center, Remember that for every 10-20 minutes you exercise, you should drink 200-300mL (1 cup) of water, and even more if you sweat alot.
if (FitnessCat = "Vigorous Exercise")
	Gui, Add, Text, x-2 w504 center, Remember that for every 10-20 minutes you exercise, you should drink 200-300mL (1 cup) of water, and even more if you sweat alot. This is very important since you exercise so much.
Gui, Add, Text, x-2 w504 center, `nPlease select below between which times you would like to recieve reminders to drink water: (e.g. 7.00 to 7.00)
Gui, Add, Datetime, x10 y210 w240 1 Choose20180101070000 vTimeFrom, ' From' hh:mm tt
Gui, Add, Datetime, x260 y210 w240 1 Choose20180101190000 vTimeTo, ' To' hh:mm tt
Gui, Add, Button, x400 h25 w100 y250 gFinishSetup, Next  >
Gui, Add, Button, x10 h25 w100 y250 gSetupPartOne, <  Back
Gui, Color, 97befc
Gui, Show,, Smart Water Setup
return

FinishSetup:
GuiControlGet, TimeFrom
GuiControlGet, TimeTo
FormatTime, TimeFromNew, %TimeFrom%, HHmm
FormatTime, TimeToNew, %TimeTo%, HHmm
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
Gui, Destroy
Gui, Font, s9 Bold
Gui, Add, Text,, Congratulations, %NAME%! Now that Smart Water is setup, you can get started!
Gui, Add, Text,, Here are the main features of the Smart Water desktop app:
Gui, Font, s9 Norm
Gui, Add, Text,, ● Personalised reminders to hydrate
Gui, Add, Text,, ● Log hydration every day
Gui, Add, Text,, ● View on calendar your hyrdation history
Gui, Add, Text,, ● (Optional) Recieve fun facts occasionally on why hydrating is so important
Gui, Add, Text,, ● Recommendations on daily hydration based on age and fitness rating
Gui, Font, s9 Bold
Gui, Add, Text,, You are now ready to go! Press Continue to open your Smart Water dashboard.
Gui, Font, s9 Norm
Gui, Add, Button, h25 w100 gDashboard, Continue
FileAppend,Yes, UserInfo.txt
FileAppend,`n%A_YYYY%%A_MM%%A_DD%, UserInfo.txt
FileAppend,`n%NAME%, UserInfo.txt
FileAppend,`n%YourAge%, UserInfo.txt
FileAppend,`n%YourWeight%, UserInfo.txt
FileAppend,`n%Gender%, UserInfo.txt
FileAppend,`n%FitnessCat%, UserInfo.txt
FileAppend,`n%TimeFromNew%, UserInfo.txt
FileAppend,`n%TimeToNew%, UserInfo.txt
FileAppend,`n%RecoMillis%, UserInfo.txt
FileAppend,`n%RecoCups%, UserInfo.txt
FileAppend,`n1, UserInfo.txt
FileSetAttrib, +RH, UserInfo.txt
Gui, Color, 97befc
Gui, Show,, Smart Water Setup
return

Dashboard:
;Run the internal systems for Smart Water
Process, Exist, Smart Water Internal.exe
if errorlevel=0
{
	MsgBox, Running Internal now
	Run, Smart Water Internal.exe
}

Process, Exist, Smart Water Facts.exe
if errorlevel=0
{
	MsgBox, Running Facts now
	Run, Smart Water Facts.exe
}

Process, Exist, 12Hour Refresh TM.exe
if errorlevel=0
{
	MsgBox, Running 12Hour now
	Run, 12Hour Refresh TM.exe
}

; PleasantNotify syntax:
;
; Title - Title of the notification
; Message - Text in the notification
; pnW - Width of the notification
; pnH - Height of the notification
; Position - Position on the screen (first letter: b, m or t)  (second letter: l, m or r)
; Time - How long the notification is displayed for
; bgcolor - Background colour of the notification
; TTcolor - Title colour of the notification
; tcolor - Text colour of the notification

URLDownloadToFile, https://pastebin.com/raw/jujndWy6, Config.txt
FileReadLine, UpdateVal, Config.txt, 1
FileReadLine, YourVal, CurrentConfig.txt, 1
Gui, Destroy
Gui, Add, Picture, h40 w40, Smart Water Icon.ico
Gui, Font, Bold s24
Gui, Add, Text, y8 x57, Smart Water Dashboard
Gui, Font, Norm s9
Gui, Add, Button, h50 w130 y56 x10 gOpenCal, View Calendar
Gui, Add, Button, h50 w130 y56 x150 gLogWater, Log water for today
Gui, Add, Button, h50 w130 y56 x290 gRecoStat, View Recommendations and Statistics
Gui, Add, Button, h50 w130 y116 x10 gOptionsSM, Options
Gui, Add, Button, h50 w130 y116 x150 gHelpSM, Help
Gui, Add, Button, h50 w130 y116 x290 gAboutSM, About
if (UpdateVal != YourVal)
{
	Gui, Font, Bold 
	Gui, Add, Button, cRed x10 w410 y+10 hwndUpdateS vUpdateS gUpdateSM, --- Update Smart Water ---
	SetBtnTxtColor(UpdateS, "Red")
	Gui, Color, 97befc
	Gui, Show,, Smart Water - UPDATE AVAILABLE
	PleasantNotify("Smart Water Update", "An update is available for Smart Water. Click 'Update' on the dashboard for more information.", 400, 150, , 5,, "001aff", "000000")
}
else
{
	Gui, Color, 97befc
	Gui, Show,, Smart Water
}
return

UpdateSM:
return

AboutSM:
Gui, Destroy
Gui, Font, s9 bold
Gui, Add, Text, x-2 w504 center, About Smart Water
Gui, Font, s9 Norm
FileRead, AboutSmartWater, About.txt
Gui, Add, Edit, +ReadOnly x10 w500 R10, %AboutSmartWater%
Gui, Add, Button, x10 w500 gDashboard h30 vBackB, Back
Gui, Color, 97befc
Gui, Show,, About Smart Water
GuiControl, Focus, BackB
return

HelpSM:
Gui, Destroy
Gui, Font, s9 bold
Gui, Add, Text, x-2 w504 center, Smart Water Help
Gui, Font, s9 Norm
FileRead, HelpSmartWater, Help.txt
Gui, Add, Edit, +ReadOnly x10 w500 R10, %HelpSmartWater%
Gui, Add, Button, x10 w500 gDashboard h30 vBackB, Back
Gui, Color, 97befc
Gui, Show,, Smart Water Help
GuiControl, Focus, BackB
return

OptionsSM:
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
FileReadLine, CurrentFunFS, UserInfo.txt, 12
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
if (CurrentFunFS = 1)
	Gui, Add, Checkbox, vFunFactsL Checked, Recieve a fun fact on hydration daily
else
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
Gui, Add, Button, h40 w90 y470 x145 gDashboard, Back
Gui, Add, Button, h40 w90 y470 x240 gDashboard, Cancel

Gui, Color, 97befc
Gui, Show, , Smart Water Options





;Groupbox library
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
GuiControlGet, FunFactsL
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
FileAppend,`n%FunFactsL%, UserInfo.txt
FileSetAttrib, +RH, UserInfo.txt

;Restart Smart Water processes
Process, Close, Smart Water Internal.exe
Process, Close, Smart Water Facts.exe
Sleep, 100
Run, Smart Water Internal.exe
Run, Smart Water Facts.exe

;Alert the user of success
MsgBox, 64, Smart Water, Successfully applied the new settings.
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
Gui, Add, Button, y80 x120 gDashboard h30 w100, Back
GuiControl, Disable, ApplyWat
Gui, Color, 97befc
Gui, Show,, Today's Hydration
Return

UngrayApply:
GuiControl, Enable, ApplyWat
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

OpenCal:
Gui, Destroy
Gui, Font, Bold s10
Gui, Add, Text, , Click on a day on the calendar to`n see how much water you drunk:
TodaysDate = %A_YYYY%%A_MM%%A_DD%
FileReadLine, DateDownloaded, UserInfo.txt, 2
Gui, Add, MonthCal, Range%DateDownloaded%-%TodaysDate% gUpdateWaterDrunkCal vSelectedDate center x18 16
Gui, Font, Norm s9
Gui, Add, Edit, +ReadOnly x43 w175 vWaterDrunk R2 -VScroll
Gui, Add, Picture, w25 h30 x15 y195 vWaterIndicator, %A_WorkingDir%\Attributes\Water cup 1.png
Gosub, UpdateWaterDrunkCal
Gui, Add, Button, x20 gDashboard h30 w200, <  Back
Gui, Color, 97befc
Gui, Show, , Smart Water Calendar
return

UpdateWaterDrunkCal:
TodaysDate = %A_YYYY%%A_MM%%A_DD%
GuiControlGet, SelectedDate
Gui, Font, Norm s9
LineNoCal := TF_Find("DatesLog.txt", "", "", SelectedDate, 0, 0)
if (LineNoCal = "0")
{
	GuiControl,, WaterIndicator, %A_WorkingDir%\Attributes\Water cup 1.png
	GuiControl,, WaterDrunk, No data recorded for this day
	return
}
else
{
	FileReadLine, WatDruN, WaterLog.txt, %LineNoCal%
	GuiControl,, WaterDrunk, You drunk %WatDruN% cups of water on this day.
	Gosub, WaterIndicatorM
	return
}
return

WaterIndicatorM:
FileReadLine, RecoCups, UserInfo.txt, 11
if (WatDruN >= RecoCups)
{
	GuiControl,, WaterIndicator, %A_WorkingDir%\Attributes\Water cup 4.png
	return
}

if (WatDruN + 2 >= RecoCups)
{
	GuiControl,, WaterIndicator, %A_WorkingDir%\Attributes\Water cup 3.png
	return
}

if (WatDruN > 1)
{
	GuiControl,, WaterIndicator, %A_WorkingDir%\Attributes\Water cup 2.png
	return
}

else
{
	GuiControl,, WaterIndicator, %A_WorkingDir%\Attributes\Water cup 1.png
	return
}


RecoStat:
FileReadLine, RecoMillis, UserInfo.txt, 10
FileReadLine, RecoCups, UserInfo.txt, 11
Gui, Destroy
Gui, Font, Bold Underline s15
Gui, Add, Text, x-2 w504 center, Your recommendations
Gui, Font, s9 norm
Gui, Add, Text, x-2 w504 center, Based on your age and fitness rating, the amount of water you should drink per day is:
Gui, Font, s20 bold
Gui, Add, Text, x-2 w504 center, %RecoMillis%mL
Gui, Font, s9 norm
Gui, Add, Text, x-2 w504 center, In glasses of water (250mL), this is:
Gui, Font, s20 bold
Gui, Add, Text, x-2 w504 center, %RecoCups% glasses
Gui, Font, Bold Underline s15
Gui, Add, Text, x-2 w504 center y+20, Your statistics
Gui, Font, norm s9

FileRead, Text, DatesLog.txt
Loop, Parse, Text, `n, `r
    WaterDrunkNum := A_Index
if (WaterDrunkNum = "")
	WaterDrunkNum = 0
Gui, Add, Text, x-2 w504 center, You have recorded your water drunk for %WaterDrunkNum% days

if (WaterDrunkNum = 0)
	TotalCupsN = 0
else
{
	TotalCupsN = 0
	Loop, %WaterDrunkNum%
	{
		FileReadLine, TempNo, WaterLog.txt, %A_Index%
		TotalCupsN  := TotalCupsN + TempNo
	}
}
Gui, Add, Text, x-2 w504 center, In total from recorded water drunk, you have drunk %TotalCupsN% cups of water.

if (WaterDrunkNum = 0)
	DaysBeatReco = 0
else
{
	DaysBeatReco = 0
	Loop, %WaterDrunkNum%
	{
		FileReadLine, TempNo, WaterLog.txt, %A_Index%
		if (TempNo >= RecoCups)
			DaysBeatReco  := DaysBeatReco + 1
	}
}
Gui, Add, Text, x-2 w504 center, You have met or exceeded %RecoCups% cups of water (recommended) %DaysBeatReco% days.

if (WaterDrunkNum = 0)
	AverageCupsN = 0
else
{
	AverageCupsT := TotalCupsN / WaterDrunkNum
	AverageCupsN := Round(AverageCupsT, 2)
}

Gui, Add, Text, x-2 w504 center, On average, you drink %AverageCupsN% (2 d.p.) cups of water a day.

Gui, Add, Button, x200 h25 w100 y325 gDashboard, <  Back
Gui, Color, 97befc
Gui, Show,, Smart Water Setup
return