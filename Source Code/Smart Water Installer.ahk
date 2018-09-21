#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
URLDownloadToFile, https://drive.google.com/uc?export=download&id=10NrJ4egeUoON6zaD1BRojBwUPOLYJ1zY, Smart Water Icon.ico
if !(FileExist("Smart Water Icon.ico"))
{
	MsgBox, 16, Error, Could not connect to the internet. Please check internet connection and firewall settings.
	FileDelete, %A_ScriptDir%\Smart Water Icon.ico
	FileDelete, %A_ScriptDir%\Smart Water Logo small.png
	FileDelete, %A_ScriptDir%\ntimage.gif
	FileDelete, %A_ScriptDir%\Install button hover.png
	FileDelete, %A_ScriptDir%\Install button.png
	ExitApp
}
Menu, Tray, Icon, Smart Water Icon.ico  ; Changes default icon for script
#SingleInstance Force
#NoTrayIcon
setN = 1

;  SCRIPT  =============================================================================
URLDownloadToFile, https://image.ibb.co/kVkfSK/Smart_Water_Logo_small.png, Smart Water Logo small.png
URLDownloadToFile, https://image.ibb.co/cWKwHK/ntimage.gif, ntimage.gif
URLDownloadToFile, https://image.ibb.co/jkX2Pz/Install_button_hover.png, Install button hover.png
URLDownloadToFile, https://image.ibb.co/kHMJxK/Install_button.png, Install button.png

global PBS_SMOOTH            := 0x00000001
global PBM_SETSTATE          := WM_USER + 16
global PBST_ERROR            := 0x00000002
Gui, Color, White
Gui, Add, Picture, x0 y0 h350 w450, ntimage.gif
Gui, Add, Picture, x30 y20 w400 h230 BackgroundTrans, Smart Water Logo small.png
Gui, Add, Picture, x155 y280 w150 h60 BackgroundTrans hwndInstallB vInstallB gSetupPart1, Install button.png
Gui, Show, w450 h350, Smart Water Installer
SetTimer, MouseOverPicture,1
return

MouseOverPicture:
Gui, Submit, NoHide
MouseGetPos,,,,id, 2
if (id = InstallB)
{
   if  (setN = "1")
   {
     GuiControl,, InstallB, Install button hover.png
     setN = 0
   }
   return
}

if (setN = "0" )
{
  GuiControl,, InstallB, Install button.png
  setN = 1
}
return

SetupPart1:
Gui, Destroy
Gui, Color, White
InstallDef = %A_ProgramFiles%\Smart Water
InstallDir = %InstallDef%
Gui, Add, Picture, x0 y0 h350 w450, %A_WinDir%\system32\ntimage.gif
Gui, Font, Bold s16
Gui, Add, Text, x145 y100 BackgroundTrans, Installation folder:
Gui, Font, s12 norm
Gui, Add, Edit, +x11 y140 w400 h25 R1 vSelectFolder +ReadOnly, %InstallDef%
Gui, Add, Button, x+5 w30 h27 vSource gSelectFile, ...
Gui, Font, s10 norm
Gui, Add, Button, h30 x220 y175 vNextInstall gSetupPart2, Next - Install
Gui, Add, Button, h30 x150 y175 gCancel, Cancel
Gui, Show, w450 h350, Smart Water Installer
GuiControl, Focus, NextInstall
return

SetupPart2:
Gui, Destroy
Gui, Color, White
Gui, Add, Picture, x0 y0 h350 w450, %A_WinDir%\system32\ntimage.gif
Gui, Add, Progress, x80 y240 w300 h20 -%PBS_SMOOTH% vInstalling hwndPROR
Gui, Add, Text, vMyText wp  ; wp means "use width of previous"
Gui, Show, w450 h350, Smart Water Installer
Gosub, Install
return

SelectFile:
FileSelectFolder, InstallDir, *%InstallDef%, 3, Select a folder to lock
GuiControl, , SelectFolder, %InstallDir%
Return

Install:
GuiControl,, MyText, Getting Ready...
GuiControl,, Installing, 1
Sleep, 2000

GuiControl,, MyText, Purging temporary files...
GuiControl,, Installing, 10
;  ============================================
FileDelete, Smart Water Logo small.png
FileDelete, ntimage.gif
FileDelete, Install button hover.png
FileDelete, Install button.png
Sleep, 100

GuiControl,, MyText, Downloading Assets...
GuiControl,, Installing, 20
;  ============================================
SetWorkingDir, %InstallDir%
URLDownloadToFile, https://image.ibb.co/bGoZnK/Smart_Water_Icon.png, Smart Water Icon.png
URLDownloadToFile, https://image.ibb.co/hkCS7K/Smart_Water_Logo.png, Smart Water Logo.png
URLDownloadToFile, https://image.ibb.co/ehdZnK/Smart_Water_Logo.jpg, Smart Water Logo.jpg
URLDownloadToFile, https://image.ibb.co/kVkfSK/Smart_Water_Logo_small.png, Smart Water Logo small.png
URLDownloadToFile, https://drive.google.com/uc?export=download&id=10NrJ4egeUoON6zaD1BRojBwUPOLYJ1zY, Smart Water Icon.ico
GuiControl,, Installing, 25
FileCreateDir, %InstallDir%\Attributes
AttributeDir = %A_WorkingDir%\Attributes
URLDownloadToFile, https://image.ibb.co/g3561e/Water_cup_1.png, %AttributeDir%\Water cup 1.png
URLDownloadToFile, https://image.ibb.co/kRC8Ez/Water_cup_2.png, %AttributeDir%\Water cup 2.png
URLDownloadToFile, https://image.ibb.co/k1WeMe/Water_cup_3.png, %AttributeDir%\Water cup 3.png
URLDownloadToFile, https://image.ibb.co/eX28Ez/Water_cup_4.png, %AttributeDir%\Water cup 4.png
Sleep, 100

GuiControl,, MyText, Downloading Config Files...
GuiControl,, Installing, 30
;  ============================================
URLDownloadToFile, https://pastebin.com/raw/mELGuQXc, Help.txt
URLDownloadToFile, https://pastebin.com/raw/wjhmHvrT, About.txt
URLDownloadToFile, https://pastebin.com/raw/jujndWy6, Config.txt
URLDownloadToFile, https://pastebin.com/raw/MPQWrEWP, LinkDownloads.txt
URLDownloadToFile, https://pastebin.com/raw/59xgt3yg, tf.ahk
URLDownloadToFile, https://pastebin.com/raw/vYbERGwD, SetBtnTxtColor.ahk
URLDownloadToFile, https://pastebin.com/raw/fKt6VZab, PleasantNotify.ahk
Sleep, 100

GuiControl,, MyText, Downloading App (This may take a while)...
GuiControl,, Installing, 40
;  ============================================
FileReadLine, TempURLPath, LinkDownloads.txt, 1
URLDownloadToFile, %TempURLPath%, 12Hour Refresh TM.exe
GuiControl,, Installing, 42.5
FileReadLine, TempURLPath, LinkDownloads.txt, 2
URLDownloadToFile, %TempURLPath%, Smart Water.exe
GuiControl,, Installing, 45
FileReadLine, TempURLPath, LinkDownloads.txt, 3
URLDownloadToFile, %TempURLPath%, Smart Water Internal.exe
GuiControl,, Installing, 47.5
FileReadLine, TempURLPath, LinkDownloads.txt, 4
URLDownloadToFile, %TempURLPath%, Smart Water Facts.exe
Sleep, 100

GuiControl,, MyText, Configuring Files...
GuiControl,, Installing, 50
;  ============================================
Loop, %A_WinDir%\system32\*.*
{
	GuiControlGet, Installing
	Installing := Installing + 0.1
    GuiControl,, Installing, %Installing%
	GuiControl,, MyText, Configuring %A_LoopFileName%...
    Sleep, 10
    if A_Index = 90
        break
}
Sleep, 100

GuiControl,, MyText, Verifying Installation...
GuiControl,, Installing, 90
;  ============================================
if !(FileExist("12Hour Refresh TM.exe") and FileExist("Smart Water.exe") and FileExist("Smart Water Internal.exe") and FileExist("Smart Water Facts.exe") and FileExist("Smart Water Logo small.png") and FileExist("Smart Water Logo.jpg") and FileExist("Smart Water Logo.png") and FileExist("Smart Water Icon.png") and FileExist("Smart Water Icon.ico") and FileExist("Help.txt") and FileExist("About.txt") and FileExist("Config.txt") and FileExist("tf.ahk") and FileExist("SetBtnTxtColor.ahk") and FileExist("PleasantNotify.ahk"))
{
	DllCall("User32.dll\SendMessage", "Ptr", PROR, "Int", PBM_SETSTATE, "Ptr", PBST_ERROR, "Ptr", 0)
	GuiControl,, MyText, Error: Verification returned error. Not all files were downloaded.
	MsgBox, 21, Error, Error: Verification returned error. Not all files were successfully downloaded.
	ifMsgBox, Retry
	{
		FileRemoveDir, %InstallDir%
		SetWorkingDir, %A_ScriptDir%
		Goto, SetupPart2
	}
	ifMsgBox, Cancel
	{
		FileRemoveDir, %InstallDir%
		Goto, Cancel
	}
}
GuiControl,, MyText, Finishing up...
GuiControl,, Installing, 95
FileReadLine, VERSION, Config.txt, 1
FileAppend,%VERSION%, CurrentConfig.txt
Sleep, 1000
GuiControl,, Installing, 100
Sleep, 1000
MsgBox, 64, Smart Water, Setup successfully completed! You can now delete the installer.
MsgBox, 36, Smart Water, Would you like to open Smart Water now?
ifMsgBox, Yes
{
	Run, Smart Water.exe
	Goto, Cancel
}
ifMsgBox, No
	Goto, Cancel
return

Cancel:
GuiClose:
FileDelete, %A_ScriptDir%\Smart Water Icon.ico
FileDelete, %A_ScriptDir%\Smart Water Logo small.png
FileDelete, %A_ScriptDir%\ntimage.gif
FileDelete, %A_ScriptDir%\Install button hover.png
FileDelete, %A_ScriptDir%\Install button.png
ExitApp
