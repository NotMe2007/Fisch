#SingleInstance Force
setkeydelay, -1
setmousedelay, -1
setbatchlines, -1
SetTitleMatchMode 2

CoordMode, Tooltip, Relative
CoordMode, Pixel, Relative
CoordMode, Mouse, Relative

; Theme state
DarkMode := 0

; 		GUI		==============================================================================================================;

; If a saved theme exists in default.ini, load it so controls are created with correct colors
IniRead, startDarkMode, %A_ScriptDir%\default.ini, General, DarkMode
if (startDarkMode != "")
	DarkMode := startDarkMode

Gui,+AlwaysOnTop
Gui, +Resize +MinSize
Gui, Margin, 12, 12
if (DarkMode)
{
	Gui, Color, 0x1E1E1E
	Gui, Font, s12 cFFFFFF, Segoe UI
	FontColor := "FFFFFF"
}
else
{
	Gui, Color, 0xF5F5F5
	Gui, Font, s12 c000000, Segoe UI
	FontColor := "000000"
}
; Title label removed from main GUI (window title still set separately)
Gui, Font, s10 c%FontColor%, Segoe UI
Gui, Add, Tab2, x10 y15 w780 h500, General Settings|Shake Settings|Minigame Settings

; General Settings Tab ==============================
Gui, Tab, General Settings
Gui, Add, Text, x30 y50, Lower Graphics:
Gui, Add, Button, x170 y50 w20 h18 gHelpLower, ?
Gui, Add, Checkbox, x266 y50 vAutoLowerGraphics, Enable
Gui, Add, Text, x30 y90, Zoom In:
Gui, Add, Button, x170 y90 w20 h18 gHelpZoom, ?
Gui, Add, Checkbox, x266 y90 vAutoZoomInCamera, Enable
Gui, Add, Text, x30 y130, Enable Camera Mode:
Gui, Add, Button, x170 y130 w20 h18 gHelpEnableCam, ?
Gui, Add, Checkbox, x266 y130 vAutoEnableCameraMode, Enable
Gui, Add, Text, x30 y170, Look Down:
Gui, Add, Button, x170 y170 w20 h18 gHelpLookDown, ?
Gui, Add, Checkbox, x266 y170 vAutoLookDownCamera, Enable
Gui, Add, Text, x30 y210, Blur:
Gui, Add, Button, x170 y210 w20 h18 gHelpBlur, ?
Gui, Add, Checkbox, x266 y210 vAutoBlurCamera, Enable
Gui, Add, Text, x30 y240, Restart Delay (ms):
Gui, Add, Edit, x220 y240 w100 vRestartDelay, 1500
Gui, Add, Text, x30 y280, Hold Rod Cast Duration (ms):
Gui, Add, Edit, x220 y280 w100 vHoldRodCastDuration, 600
Gui, Add, Text, x30 y320, Wait for Bobber to Land (ms):
Gui, Add, Edit, x220 y320 w100 vWaitForBobberDelay, 1000
Gui, Add, Text, x30 y360, Bait Delay (ms):
Gui, Add, Edit, x220 y360 w100 vBaitDelay, 300
Gui, Add, Text, x30 y400, Default at 300

Gui, Add, Text, x380 y300, Seraphic Rod Check:
Gui, Add, Checkbox, x500 y300 vSera, Enable
Gui, Add, Text, x380 y320, Only Enable if youre using Seraphic Rod

; Mini guide (compact clickable) - visible text removed, info available via the small 'i' buttons
Gui, Font, s9 c%FontColor%, Segoe UI
Gui, Add, Button, x360 y40 w16 h16 gInfo1, i
Gui, Add, Button, x360 y60 w16 h16 gInfo2, i
Gui, Add, Button, x360 y80 w16 h16 gInfo3, i
Gui, Add, Button, x360 y120 w16 h16 gInfo4, i
Gui, Add, Button, x360 y200 w16 h16 gInfo5, i
Gui, Add, Button, x360 y240 w16 h16 gInfo6, i
Gui, Add, Button, x360 y280 w16 h16 gInfo7, i
Gui, Add, Button, x360 y360 w16 h16 gInfo8, i
Gui, Font, s10 c%FontColor%, Segoe UI

; Shake Settings Tab =====================================
Gui, Tab, Shake Settings
Gui, Add, Text, x30 y65, Navigation Key:
Gui, Add, Edit, x190 y65 w100 vNavigationKey, \
Gui, Add, Text, x30 y105, Shake Mode:
Gui, Add, ComboBox, x190 y105 w100 vShakeMode, Click|Navigation
Gui, Add, Text, x30 y145, Shake Failsafe (sec):
Gui, Add, Edit, x190 y145 w100 vShakeFailsafe, 20

; Click set
Gui, Add, Text, x30 y185, Click Shake Color Tolerance:
Gui, Add, Edit, x190 y185 w100 vClickShakeColorTolerance, 3
Gui, Add, Text, x30 y225, Click Scan Delay (ms):
Gui, Add, Edit, x190 y225 w100 vClickScanDelay, 10
Gui, Add, Text, x380 y225, Adjust the Click Speed

; Nav set
Gui, Add, Text, x30 y265, Navigation Spam Delay (ms):
Gui, Add, Edit, x190 y265 w100 vNavigationSpamDelay, 10
Gui, Add, Text, x380 y265, Adjust the Navigation spam speed

Gui, Add, Text, x380 y65, Check your Navigation Key in the Roblox settings
Gui, Add, Text, x380 y105, Click for for mouse clicks | Navigation for Navigation spam
Gui, Add, Text, x380 y145, How many seconds before restarting if failed to shake
Gui, Add, Text, x30 y325, If you already set it up, to ensure Shake Mode works:
Gui, Add, Text, x30 y345, Load settings -> Save settings -> Start Macro

; Minigame Settings Tab	============================
Gui, Tab, Minigame Settings

; Bar calc
Gui, Font, Bold
Gui, Add, Text, x30 y65, !!!!! Check the Control stat of your Rod !!!!!
Gui, Font, Norm
Gui, Add, Text, x30 y85, Control Value:
Gui, Add, Edit, x180 y85 w100 vControl, 0
Gui, Add, Text, x30 y125, Fish Bar Tolerance:
Gui, Add, Edit, x180 y125 w100 vFishBarColorTolerance, 5
Gui, Add, Text, x30 y165, White Bar Tolerance:
Gui, Add, Edit, x180 y165 w100 vWhiteBarColorTolerance, 15
Gui, Add, Text, x30 y205, Arrow Tolerance:
Gui, Add, Edit, x180 y205 w100 vArrowColorTolerance, 6

; Bar control
Gui, Add, Text, x30 y245, Scan Delay:
Gui, Add, Edit, x180 y245 w100 vScanDelay, 10
Gui, Add, Text, x30 y285, Side Bar Ratio:
Gui, Add, Edit, x180 y285 w100 vSideBarRatio, 0.7
Gui, Add, Text, x30 y325, Side Bar Delay:
Gui, Add, Edit, x180 y325 w100 vSideDelay, 400

Gui, Add, Text, x30 y365, Minigame Settings Guide
Gui, Add, Text, x30 y385, Make your own config or use others

; Stable
Gui, Add, Text, x400 y65, Stable Right Multiplier:
Gui, Add, Edit, x550 y65 w100 vStableRightMultiplier, 2.36
Gui, Add, Text, x400 y105, Stable Right Division:
Gui, Add, Edit, x550 y105 w100 vStableRightDivision, 1.55
Gui, Add, Text, x400 y145, Stable Left Multiplier:
Gui, Add, Edit, x550 y145 w100 vStableLeftMultiplier, 1.211
Gui, Add, Text, x400 y185, Stable Left Division:
Gui, Add, Edit, x550 y185 w100 vStableLeftDivision, 1.12

; Unstable
Gui, Add, Text, x400 y210, Unstable Right Multiplier:
Gui, Add, Edit, x550 y210 w100 vUnstableRightMultiplier, 2.665
Gui, Add, Text, x400 y250, Unstable Right Division:
Gui, Add, Edit, x550 y250 w100 vUnstableRightDivision, 1.5
Gui, Add, Text, x400 y290, Unstable Left Multiplier:
Gui, Add, Edit, x550 y290 w100 vUnstableLeftMultiplier, 2.19
Gui, Add, Text, x400 y330, Unstable Left Division:
Gui, Add, Edit, x550 y330 w100 vUnstableLeftDivision, 1

; Ankle
Gui, Add, Text, x400 y360, Right Ankle Break Multiplier:
Gui, Add, Edit, x550 y360 w100 vRightAnkleBreakMultiplier, 0.75
Gui, Add, Text, x400 y400, Left Ankle Break Multiplier:
Gui, Add, Edit, x550 y400 w100 vLeftAnkleBreakMultiplier, 0.45

; Buttons
Gui, Tab
Gui, Add, Button, x200 y460 w80 h30 gSaveSettings, Save settings
Gui, Add, Button, x300 y460 w80 h30 gLoadSettings, Load settings
Gui, Add, Button, x400 y460 w80 h30 gExitScript, Exit
Gui, Add, Button, x500 y460 w80 h30 gLaunch, Start Macro
Gui, Add, Button, x600 y460 w80 h30 gToggleDarkMode vDarkModeBtn, Dark Mode
Gui, Add, Text, x30 y440 , Configs list
Gui, Add, Edit, x30 y460 w75 vCfgSearch gCfgSearch, ; search box for configs
; Use a DropDownList so users can open and scroll the whole list; width reduced to ~50%
Gui, Add, DropDownList, x110 y460 w75 vDropItem gSelectItem
Gui, Show,, Fich macro V12.5 Remasterd by SeneX

; Update Dark Mode button label to reflect current state (show action)
if (DarkMode)
	GuiControl,, DarkModeBtn, Light Mode
else
	GuiControl,, DarkModeBtn, Dark Mode

; Ensure edit/dropdown text remains black for readability
gosub, SetEditFonts

; Build a pipe-separated list of config names and set the dropdown once (prevents odd incremental behavior)
; Build master list of configs (used for filtering) — avoid duplicates
masterCfgList := []
cfgSeen := {}
Loop, %A_ScriptDir%\*.ini
{
	StringTrimRight, fileName, A_LoopFileName, 4
	if (cfgSeen[fileName])
		continue
	cfgSeen[fileName] := true
	masterCfgList.Push(fileName)
}
; initially populate dropdown with all items
gosub, FilterConfigs

; start hover checker for help buttons
SetTimer, CheckHelpHover, 200

; Ensure SettingsFileName has a sane default so writes go to a real file
SettingsFileName := A_ScriptDir . "\default.ini"

SelectItem:
    Gui, Submit, NoHide
	; If user picked the special '(no matches)', warn and do nothing
	if (DropItem = "(no matches)") {
		MsgBox, 0x40030, Config, No matching configuration to load.
		Return
	}
	if (DropItem = "") {
		; fall back to default
		SettingsFileName := A_ScriptDir . "\default.ini"
	} else {
		SettingsFileName := A_ScriptDir . "\" . DropItem . ".ini"
	}

	; Only attempt to load if the file exists
	if !FileExist(SettingsFileName) {
		MsgBox, 0x40030, Config, The selected config file does not exist:`n%SettingsFileName%
		Return
	}

	; Load and apply the selected config
	Gosub, LoadSettings
Return

HelpLower:
	Tooltip, Lowers in-game graphics automatically to improve performance., 200, 200
	SetTimer, ClearTooltip, -1500
Return

HelpZoom:
	Tooltip, Zooms the camera in to improve detection of targets., 200, 200
	SetTimer, ClearTooltip, -1500
Return

HelpEnableCam:
	Tooltip, Enables camera-mode automatically before starting the macro., 200, 200
	SetTimer, ClearTooltip, -1500
Return

HelpLookDown:
	Tooltip, Automatically looks down to position the bobber in view., 200, 200
	SetTimer, ClearTooltip, -1500
Return

HelpBlur:
	Tooltip, Toggles blur effect handling (used to open certain menus)., 200, 200
	SetTimer, ClearTooltip, -1500
Return

Info1:
	; Create a small persistent info GUI with clickable labels
	Gui, Info1: New, +AlwaysOnTop -SysMenu +ToolWindow, Info - Join White Sands Macros
	Gui, Info1: Font, s10 c%FontColor%, Segoe UI
	Gui, Info1: Add, Text, x10 y10, Join White Sands Macros
	Gui, Info1: Add, Text, x10 y30 gOpenRemaster c00AEEF, was remasted by SenX
	Gui, Info1: Add, Text, x170 y30 gOpenDiscord c00AEEF, https://discord.gg/dHUM2ejQGY
	Gui, Info1: Add, Button, x10 y60 w60 h22 gCloseInfo1, Close
	Gui, Info1: Show, AutoSize Center, Info
Return

Info2:
	MsgBox, 0x40000, Info, Check out the pre-setup before you begin (Only available in the discord above)
Return

Info3:
	MsgBox, 0x40000, Info, If its your first time, please check all the boxes
Return

Info4:
	MsgBox, 0x40000, Info, Click the camera icon top right in case it doesnt work
Return

Info5:
	MsgBox, 0x40000, Info, If youre wondering, this will open the menu after enabling camera mode
Return

Info6:
	MsgBox, 0x40000, Info, Adjust wait time before restarting the macro
Return

Info7:
	MsgBox, 0x40000, Info, Increase the Hold duration if you have high ping
Return

Info8:
	MsgBox, 0x40000, Info, If you cant load or save settings, Right click the macro and choose Run as Admin`n( requires AutoHotkey v2 )
Return

OpenRemaster:
	; Open the discord for now (no separate URL was provided for remaster credit)
	Run, https://discord.gg/dHUM2ejQGY
Return

OpenDiscord:
	Run, https://discord.gg/dHUM2ejQGY
Return

CloseInfo1:
	Gui, Info1: Destroy
Return

ClearTooltip:
	Tooltip
Return

CheckHelpHover:
	; Check mouse over each help button and show tooltip accordingly
	MouseGetPos, mx, my
	; check each button by getting its position
	ControlGetPos, x, y, w, h, Button3, A
	; Note: the control names vary; we'll test by approximate areas used earlier
	; Lower help approx at x270 y50
	if (mx >= 270 && mx <= 290 && my >= 50 && my <= 68) {
		Tooltip, Lowers in-game graphics automatically to improve performance., %mx%, %my%
		return
	}
	if (mx >= 270 && mx <= 290 && my >= 90 && my <= 108) {
		Tooltip, Zooms the camera in to improve detection of targets., %mx%, %my%
		return
	}
	if (mx >= 270 && mx <= 290 && my >= 130 && my <= 148) {
		Tooltip, Enables camera-mode automatically before starting the macro., %mx%, %my%
		return
	}
	if (mx >= 270 && mx <= 290 && my >= 170 && my <= 188) {
		Tooltip, Automatically looks down to position the bobber in view., %mx%, %my%
		return
	}
	if (mx >= 270 && mx <= 290 && my >= 210 && my <= 228) {
		Tooltip, Toggles blur effect handling (used to open certain menus)., %mx%, %my%
		return
	}
	Tooltip
Return

; Called when search box changes (gCfgSearch) — re-populates the dropdown with filtered items
CfgSearch:
	Gui, Submit, NoHide
	gosub, FilterConfigs
Return

FilterConfigs:
	; Build a pipe-separated string of items that contain the search substring (case-insensitive)
	search := CfgSearch
	if (search = "")
		search := ""
	StringLower, lowerSearch, search
	out := ""
	for index, name in masterCfgList
	{
		StringLower, lowerName, name
		if (lowerSearch = "" || InStr(lowerName, lowerSearch))
		{
			out := (out = "" ? name : out "|" name)
		}
	}
	if (out = "")
		out := "(no matches)"
	GuiControl,, DropItem, %out%
	; if there are matches, open the dropdown so user can scroll immediately
	if (out != "(no matches)") {
		; give GUI a moment to update, then send dropdown open to that control
		SetTimer, OpenCfgDropdown, -80
	}
Return

OpenCfgDropdown:
	; Focus the dropdown and open it
	GuiControl, Focus, DropItem
	Send, {Down}
Return


; Save settings
SaveSettings:
	Gui, Submit, NoHide
    if (DropItem = "")
        SettingsFileName := A_ScriptDir . "\default.ini"
    else
        SettingsFileName := A_ScriptDir . "\" . DropItem . ".ini"
    
    FileAppend, , %SettingsFileName%  ; Create the file if it doesn't exist

    IniWrite, %AutoLowerGraphics%, %SettingsFileName%, General, AutoLowerGraphics
    IniWrite, %AutoZoomInCamera%, %SettingsFileName%, General, AutoZoomInCamera
    IniWrite, %AutoEnableCameraMode%, %SettingsFileName%, General, AutoEnableCameraMode
    IniWrite, %AutoLookDownCamera%, %SettingsFileName%, General, AutoLookDownCamera
    IniWrite, %AutoBlurCamera%, %SettingsFileName%, General, AutoBlurCamera

    IniWrite, %RestartDelay%, %SettingsFileName%, General, RestartDelay
    IniWrite, %HoldRodCastDuration%, %SettingsFileName%, General, HoldRodCastDuration
    IniWrite, %WaitForBobberDelay%, %SettingsFileName%, General, WaitForBobberDelay
	IniWrite, %BaitDelay%, %SettingsFileName%, General, BaitDelay
	IniWrite, %Sera%, %SettingsFileName%, General, Sera

    IniWrite, %NavigationKey%, %SettingsFileName%, Shake, NavigationKey
    IniWrite, %ShakeMode%, %SettingsFileName%, Shake, ShakeMode
    IniWrite, %ShakeFailsafe%, %SettingsFileName%, Shake, ShakeFailsafe

    IniWrite, %ClickShakeColorTolerance%, %SettingsFileName%, Shake, ClickShakeColorTolerance
    IniWrite, %ClickScanDelay%, %SettingsFileName%, Shake, ClickScanDelay
    IniWrite, %NavigationSpamDelay%, %SettingsFileName%, Shake, NavigationSpamDelay

    IniWrite, %Control%, %SettingsFileName%, Minigame, Control
    IniWrite, %FishBarColorTolerance%, %SettingsFileName%, Minigame, FishBarColorTolerance
    IniWrite, %WhiteBarColorTolerance%, %SettingsFileName%, Minigame, WhiteBarColorTolerance
    IniWrite, %ArrowColorTolerance%, %SettingsFileName%, Minigame, ArrowColorTolerance

    IniWrite, %ScanDelay%, %SettingsFileName%, Minigame, ScanDelay
    IniWrite, %SideBarRatio%, %SettingsFileName%, Minigame, SideBarRatio
    IniWrite, %SideDelay%, %SettingsFileName%, Minigame, SideDelay

    IniWrite, %StableRightMultiplier%, %SettingsFileName%, Minigame, StableRightMultiplier
    IniWrite, %StableRightDivision%, %SettingsFileName%, Minigame, StableRightDivision
    IniWrite, %StableLeftMultiplier%, %SettingsFileName%, Minigame, StableLeftMultiplier
    IniWrite, %StableLeftDivision%, %SettingsFileName%, Minigame, StableLeftDivision

    IniWrite, %UnstableRightMultiplier%, %SettingsFileName%, Minigame, UnstableRightMultiplier
    IniWrite, %UnstableRightDivision%, %SettingsFileName%, Minigame, UnstableRightDivision
    IniWrite, %UnstableLeftMultiplier%, %SettingsFileName%, Minigame, UnstableLeftMultiplier
    IniWrite, %UnstableLeftDivision%, %SettingsFileName%, Minigame, UnstableLeftDivision
	
	IniWrite, %RightAnkleBreakMultiplier%, %SettingsFileName%, Minigame, RightAnkleBreakMultiplier
    IniWrite, %LeftAnkleBreakMultiplier%, %SettingsFileName%, Minigame, LeftAnkleBreakMultiplier
	
    ; Done
	Gui, -AlwaysOnTop
	MsgBox, 0x40040, Saved, Settings saved successfully as %SettingsFileName% !, 0.8
	Gui, +AlwaysOnTop
Return

; Toggle Dark Mode
ToggleDarkMode:
	DarkMode := !DarkMode
	; persist choice to the currently selected settings file (if set)
	if (SettingsFileName != "") {
		IniWrite, %DarkMode%, %SettingsFileName%, General, DarkMode
	}
	; always write to default.ini so startup (which reads default.ini) reflects the choice
	IniWrite, %DarkMode%, %A_ScriptDir%\default.ini, General, DarkMode
	; reload script so all controls are recreated with the correct font color
	Reload
Return

; Apply theme based on DarkMode
ApplyTheme:
	if (DarkMode)
	{
		Gui, Color, 0x1E1E1E
	FontColor := "FFFFFF"
	Gui, Font, s12 c%FontColor%, Segoe UI
	Gui, Font, s10 c%FontColor%, Segoe UI
		GuiControl,, DarkModeBtn, Light Mode
	}
	else
	{
		Gui, Color, 0xF5F5F5
	FontColor := "000000"
	Gui, Font, s12 c%FontColor%, Segoe UI
	Gui, Font, s10 c%FontColor%, Segoe UI
		GuiControl,, DarkModeBtn, Dark Mode
	}

	; Reapply black text to edit-like controls for readability
	gosub, SetEditFonts
	Return

SetEditFonts:
	; Force edit and dropdown controls' text color to black so they remain visible on dark backgrounds
	Gui, Font, s10 c000000, Segoe UI
	GuiControl, Font, RestartDelay
	GuiControl, Font, HoldRodCastDuration
	GuiControl, Font, WaitForBobberDelay
	GuiControl, Font, BaitDelay
	GuiControl, Font, NavigationKey
	GuiControl, Font, ShakeFailsafe
	GuiControl, Font, ClickShakeColorTolerance
	GuiControl, Font, ClickScanDelay
	GuiControl, Font, NavigationSpamDelay
	GuiControl, Font, Control
	GuiControl, Font, FishBarColorTolerance
	GuiControl, Font, WhiteBarColorTolerance
	GuiControl, Font, ArrowColorTolerance
	GuiControl, Font, ScanDelay
	GuiControl, Font, SideBarRatio
	GuiControl, Font, SideDelay
	GuiControl, Font, StableRightMultiplier
	GuiControl, Font, StableRightDivision
	GuiControl, Font, StableLeftMultiplier
	GuiControl, Font, StableLeftDivision
	GuiControl, Font, UnstableRightMultiplier
	GuiControl, Font, UnstableRightDivision
	GuiControl, Font, UnstableLeftMultiplier
	GuiControl, Font, UnstableLeftDivision
	GuiControl, Font, RightAnkleBreakMultiplier
	GuiControl, Font, LeftAnkleBreakMultiplier
	Gui, Font, s10 c%FontColor%, Segoe UI
Return

; Load settings
LoadSettings:
	IniRead, lAutoLowerGraphics, %SettingsFileName%, General, AutoLowerGraphics
	IniRead, lAutoZoomInCamera, %SettingsFileName%, General, AutoZoomInCamera
	IniRead, lAutoEnableCameraMode, %SettingsFileName%, General, AutoEnableCameraMode
	IniRead, lAutoLookDownCamera, %SettingsFileName%, General, AutoLookDownCamera
	IniRead, lAutoBlurCamera, %SettingsFileName%, General, AutoBlurCamera

	IniRead, lRestartDelay, %SettingsFileName%, General, RestartDelay
	IniRead, lHoldRodCastDuration, %SettingsFileName%, General, HoldRodCastDuration
	IniRead, lWaitForBobberDelay, %SettingsFileName%, General, WaitForBobberDelay
	IniRead, lBaitDelay, %SettingsFileName%, General, BaitDelay
	IniRead, lSera, %SettingsFileName%, General, Sera

	IniRead, lNavigationKey, %SettingsFileName%, Shake, NavigationKey
	IniRead, lShakeMode, %SettingsFileName%, Shake, ShakeMode
	IniRead, lShakeFailsafe, %SettingsFileName%, Shake, ShakeFailsafe

	IniRead, lClickShakeColorTolerance, %SettingsFileName%, Shake, ClickShakeColorTolerance
	IniRead, lClickScanDelay, %SettingsFileName%, Shake, ClickScanDelay
	IniRead, lNavigationSpamDelay, %SettingsFileName%, Shake, NavigationSpamDelay

	IniRead, lControl, %SettingsFileName%, Minigame, Control
	IniRead, lFishBarColorTolerance, %SettingsFileName%, Minigame, FishBarColorTolerance
	IniRead, lWhiteBarColorTolerance, %SettingsFileName%, Minigame, WhiteBarColorTolerance
	IniRead, lArrowColorTolerance, %SettingsFileName%, Minigame, ArrowColorTolerance

	IniRead, lScanDelay, %SettingsFileName%, Minigame, ScanDelay
	IniRead, lSideBarRatio, %SettingsFileName%, Minigame, SideBarRatio
	IniRead, lSideDelay, %SettingsFileName%, Minigame, SideDelay

	IniRead, lStableRightMultiplier, %SettingsFileName%, Minigame, StableRightMultiplier
	IniRead, lStableRightDivision, %SettingsFileName%, Minigame, StableRightDivision
	IniRead, lStableLeftMultiplier, %SettingsFileName%, Minigame, StableLeftMultiplier
	IniRead, lStableLeftDivision, %SettingsFileName%, Minigame, StableLeftDivision

	IniRead, lUnstableRightMultiplier, %SettingsFileName%, Minigame, UnstableRightMultiplier
	IniRead, lUnstableRightDivision, %SettingsFileName%, Minigame, UnstableRightDivision
	IniRead, lUnstableLeftMultiplier, %SettingsFileName%, Minigame, UnstableLeftMultiplier
	IniRead, lUnstableLeftDivision, %SettingsFileName%, Minigame, UnstableLeftDivision

	IniRead, lRightAnkleBreakMultiplier, %SettingsFileName%, Minigame, RightAnkleBreakMultiplier
	IniRead, lLeftAnkleBreakMultiplier, %SettingsFileName%, Minigame, LeftAnkleBreakMultiplier

	
	; Update GUI
	if FileExist(SettingsFileName) {
	Gui, Submit, NoHide
	GuiControl,, AutoLowerGraphics, %lAutoLowerGraphics%
	GuiControl,, AutoZoomInCamera, %lAutoZoomInCamera%
	GuiControl,, AutoEnableCameraMode, %lAutoEnableCameraMode%
	GuiControl,, AutoLookDownCamera, %lAutoLookDownCamera%
	GuiControl,, AutoBlurCamera, %lAutoBlurCamera%

	GuiControl,, RestartDelay, %lRestartDelay%
	GuiControl,, HoldRodCastDuration, %lHoldRodCastDuration%
	GuiControl,, WaitForBobberDelay, %lWaitForBobberDelay%
	GuiControl,, BaitDelay, %lBaitDelay%
	GuiControl,, Sera, %lSera%

	GuiControl,, NavigationKey, %lNavigationKey%
	GuiControl,Choose, ShakeMode, %lShakeMode%
	GuiControl,, ShakeFailsafe, %lShakeFailsafe%

	GuiControl,, ClickShakeColorTolerance, %lClickShakeColorTolerance%
	GuiControl,, ClickScanDelay, %lClickScanDelay%
	GuiControl,, NavigationSpamDelay, %lNavigationSpamDelay%

	GuiControl,, Control, %lControl%
	GuiControl,, FishBarColorTolerance, %lFishBarColorTolerance%
	GuiControl,, WhiteBarColorTolerance, %lWhiteBarColorTolerance%
	GuiControl,, ArrowColorTolerance, %lArrowColorTolerance%

	GuiControl,, ScanDelay, %lScanDelay%
	GuiControl,, SideBarRatio, %lSideBarRatio%
	GuiControl,, SideDelay, %lSideDelay%

	GuiControl,, StableRightMultiplier, %lStableRightMultiplier%
	GuiControl,, StableRightDivision, %lStableRightDivision%
	GuiControl,, StableLeftMultiplier, %lStableLeftMultiplier%
	GuiControl,, StableLeftDivision, %lStableLeftDivision%

	GuiControl,, UnstableRightMultiplier, %lUnstableRightMultiplier%
	GuiControl,, UnstableRightDivision, %lUnstableRightDivision%
	GuiControl,, UnstableLeftMultiplier, %lUnstableLeftMultiplier%
	GuiControl,, UnstableLeftDivision, %lUnstableLeftDivision%

	GuiControl,, RightAnkleBreakMultiplier, %lRightAnkleBreakMultiplier%
	GuiControl,, LeftAnkleBreakMultiplier, %lLeftAnkleBreakMultiplier%

	; read theme and apply if present
	IniRead, lDarkMode, %SettingsFileName%, General, DarkMode
	if (lDarkMode != "") {
		prevDark := DarkMode
		DarkMode := lDarkMode
		if (DarkMode != prevDark) {
			; persist chosen theme as default so Reload keeps it and controls are recreated
			IniWrite, %DarkMode%, %A_ScriptDir%\default.ini, General, DarkMode
			Reload
		} else {
			gosub, ApplyTheme
		}
	}

	; Reapply font color to controls so text updates immediately
	Gui, Font, s10 c%FontColor%, Segoe UI

	; Done
		Gui, -AlwaysOnTop
		MsgBox, 0x40040, Loaded, Loaded %SettingsFileName% !, 0.8
		Gui, +AlwaysOnTop
	} else {
		Gui, -AlwaysOnTop
		MsgBox, 0x40030, Loaded, Settings failed to load.
		Gui, +AlwaysOnTop
	}
	; do not auto-save after loading — user should Save manually if desired
Return

ExitScript:
    ExitApp
Return

GuiClose:
ExitApp

;====================================================================================================;
Launch:
Gui, Hide
	IniRead, lAutoLowerGraphics, %SettingsFileName%, General, AutoLowerGraphics
	IniRead, lAutoZoomInCamera, %SettingsFileName%, General, AutoZoomInCamera
	IniRead, lAutoEnableCameraMode, %SettingsFileName%, General, AutoEnableCameraMode
	IniRead, lAutoLookDownCamera, %SettingsFileName%, General, AutoLookDownCamera
	IniRead, lAutoBlurCamera, %SettingsFileName%, General, AutoBlurCamera
	IniRead, lRestartDelay, %SettingsFileName%, General, RestartDelay
	IniRead, lHoldRodCastDuration, %SettingsFileName%, General, HoldRodCastDuration
	IniRead, lWaitForBobberDelay, %SettingsFileName%, General, WaitForBobberDelay
	IniRead, lBaitDelay, %SettingsFileName%, General, BaitDelay
	IniRead, lSera, %SettingsFileName%, General, Sera

	IniRead, lNavigationKey, %SettingsFileName%, Shake, NavigationKey
	IniRead, lShakeMode, %SettingsFileName%, Shake, ShakeMode
	; thanks @sai.kyo
	ShakeMode := lShakeMode
	IniRead, lShakeFailsafe, %SettingsFileName%, Shake, ShakeFailsafe

	IniRead, lClickShakeColorTolerance, %SettingsFileName%, Shake, ClickShakeColorTolerance
	IniRead, lClickScanDelay, %SettingsFileName%, Shake, ClickScanDelay
	IniRead, lNavigationSpamDelay, %SettingsFileName%, Shake, NavigationSpamDelay

	IniRead, lControl, %SettingsFileName%, Minigame, Control
	IniRead, lFishBarColorTolerance, %SettingsFileName%, Minigame, FishBarColorTolerance
	IniRead, lWhiteBarColorTolerance, %SettingsFileName%, Minigame, WhiteBarColorTolerance
	IniRead, lArrowColorTolerance, %SettingsFileName%, Minigame, ArrowColorTolerance

	IniRead, lScanDelay, %SettingsFileName%, Minigame, ScanDelay
	IniRead, lSideBarRatio, %SettingsFileName%, Minigame, SideBarRatio
	IniRead, lSideDelay, %SettingsFileName%, Minigame, SideDelay

	IniRead, lStableRightMultiplier, %SettingsFileName%, Minigame, StableRightMultiplier
	IniRead, lStableRightDivision, %SettingsFileName%, Minigame, StableRightDivision
	IniRead, lStableLeftMultiplier, %SettingsFileName%, Minigame, StableLeftMultiplier
	IniRead, lStableLeftDivision, %SettingsFileName%, Minigame, StableLeftDivision

	IniRead, lUnstableRightMultiplier, %SettingsFileName%, Minigame, UnstableRightMultiplier
	IniRead, lUnstableRightDivision, %SettingsFileName%, Minigame, UnstableRightDivision
	IniRead, lUnstableLeftMultiplier, %SettingsFileName%, Minigame, UnstableLeftMultiplier
	IniRead, lUnstableLeftDivision, %SettingsFileName%, Minigame, UnstableLeftDivision
	
	IniRead, lRightAnkleBreakMultiplier, %SettingsFileName%, Minigame, RightAnkleBreakMultiplier
	IniRead, lLeftAnkleBreakMultiplier, %SettingsFileName%, Minigame, LeftAnkleBreakMultiplier
	
if (ShakeMode != "Navigation" and ShakeMode != "Click")
	{
	msgbox, Shake Mode wasnt saved, remember to Save before you Start
	exitapp
	}
;====================================================================================================;

WinActivate, Roblox
if WinActive("ahk_exe RobloxPlayerBeta.exe") || WinActive("ahk_exe eurotruck2.exe")
	{
	WinMaximize, Roblox
	}
else
	{
	MsgBox, 0x40030, Error, Make sure you are using the Roblox Player (not from Microsoft)
	exitapp
	}

if (A_ScreenDPI != 96) {
    MsgBox, 0x40030, Error, Display Scale is not set to 100.`nPress the Windows key > Find "Change the resolution of the display" > Set the Scale to 100
	exitapp
}

;====================================================================================================;

send {lbutton up}
send {rbutton up}
send {shift up}

;====================================================================================================;

Calculations:
WinGetActiveStats, Title, WindowWidth, WindowHeight, WindowLeft, WindowTop

CameraCheckLeft := WindowWidth/2.8444
CameraCheckRight := WindowWidth/1.5421
CameraCheckTop := WindowHeight/1.28
CameraCheckBottom := WindowHeight

ClickShakeLeft := WindowWidth/4
ClickShakeRight := WindowWidth/1.2736
ClickShakeTop := WindowHeight/9
ClickShakeBottom := WindowHeight/1.3409

FishBarLeft := WindowWidth/3.3160
FishBarRight := WindowWidth/1.4317
FishBarTop := WindowHeight/1.1871
FishBarBottom := WindowHeight/1.1512

ProgressAreaLeft := WindowWidth/2.55
ProgressAreaRight := WindowWidth/1.63
ProgressAreaTop := WindowHeight/1.13
ProgressAreaBottom := WindowHeight/1.08

FishBarTooltipHeight := WindowHeight/1.0626

; Thanks Lunar res calculation
ResolutionScaling := WindowWidth / (WindowWidth * 2.37)

LookDownX := WindowWidth/2
LookDownY := WindowHeight/4

runtimeS := 0
runtimeM := 0
runtimeH := 0
PixelScaling := 1034/(FishBarRight-FishBarLeft)

TooltipX := WindowWidth/20
Tooltip1 := (WindowHeight/2)-(20*9)
Tooltip2 := (WindowHeight/2)-(20*8)
Tooltip3 := (WindowHeight/2)-(20*7)
Tooltip4 := (WindowHeight/2)-(20*6)
Tooltip5 := (WindowHeight/2)-(20*5)
Tooltip6 := (WindowHeight/2)-(20*4)
Tooltip7 := (WindowHeight/2)-(20*3)
Tooltip8 := (WindowHeight/2)-(20*2)
Tooltip9 := (WindowHeight/2)-(20*1)
Tooltip10 := (WindowHeight/2)
Tooltip11 := (WindowHeight/2)+(20*1)
Tooltip12 := (WindowHeight/2)+(20*2)
Tooltip13 := (WindowHeight/2)+(20*3)
Tooltip14 := (WindowHeight/2)+(20*4)
Tooltip15 := (WindowHeight/2)+(20*5)
Tooltip16 := (WindowHeight/2)+(20*6)
Tooltip17 := (WindowHeight/2)+(20*7)
Tooltip18 := (WindowHeight/2)+(20*8)
Tooltip19 := (WindowHeight/2)+(20*9)
Tooltip20 := (WindowHeight/2)+(20*10)

SplitPath, SettingsFileName, FileNameNoExt
StringTrimRight, FileNameNoExt, FileNameNoExt, 4
tooltip, Made By AsphaltCake - this is remasterd version, %TooltipX%, %Tooltip1%, 1
tooltip, Fisch Macro V12 - Config: %FileNameNoExt%, %TooltipX%, %Tooltip2%, 2
tooltip, Runtime: 0h 0m 0s, %TooltipX%, %Tooltip3%, 3

tooltip, Press "P" to Start, %TooltipX%, %Tooltip4%, 4
tooltip, Press "O" to Reload, %TooltipX%, %Tooltip5%, 5
tooltip, Press "M" to Exit, %TooltipX%, %Tooltip6%, 6

if (AutoLowerGraphics == true)
	{
	tooltip, AutoLowerGraphics: true, %TooltipX%, %Tooltip8%, 8
	}
else
	{
	tooltip, AutoLowerGraphics: false, %TooltipX%, %Tooltip8%, 8
	}
	
if (AutoEnableCameraMode == true)
	{
	tooltip, AutoEnableCameraMode: true, %TooltipX%, %Tooltip9%, 9
	}
else
	{
	tooltip, AutoEnableCameraMode: false, %TooltipX%, %Tooltip9%, 9
	}
	
if (AutoZoomInCamera == true)
	{
	tooltip, AutoZoomInCamera: true, %TooltipX%, %Tooltip10%, 10
	}
else
	{
	tooltip, AutoZoomInCamera: false, %TooltipX%, %Tooltip10%, 10
	}
	
if (AutoLookDownCamera == true)
	{
	tooltip, AutoLookDownCamera: true, %TooltipX%, %Tooltip11%, 11
	}
else
	{
	tooltip, AutoLookDownCamera: false, %TooltipX%, %Tooltip11%, 11
	}
	
if (AutoBlurCamera == true)
	{
	tooltip, AutoBlurCamera: true, %TooltipX%, %Tooltip12%, 12
	}
else
	{
	tooltip, AutoBlurCamera: false, %TooltipX%, %Tooltip12%, 12
	}

tooltip, Navigation Key: "%NavigationKey%", %TooltipX%, %Tooltip14%, 14

if (ShakeMode == "Click")
	{
	tooltip, Shake Mode: "Click", %TooltipX%, %Tooltip16%, 16
	}
else
	{
	tooltip, Shake Mode: "Navigation", %TooltipX%, %Tooltip16%, 16
	}
return

;====================================================================================================;

; Thanks Lunar
runtime:
    runtimeS++
    if (runtimeS >= 60)
    {
        runtimeS := 0
        runtimeM++
    }
    if (runtimeM >= 60)
    {
        runtimeM := 0
        runtimeH++
    }

    tooltip, Runtime: %runtimeH%h %runtimeM%m %runtimeS%s, %TooltipX%, %Tooltip3%, 3

    if (WinExist("ahk_exe RobloxPlayerBeta.exe") || WinExist("ahk_exe eurotruck2.exe")) {
        if (!WinActive("ahk_exe RobloxPlayerBeta.exe") || !WinActive("ahk_exe eurotruck2.exe")) {
            WinActivate
        }
    }
    else {
        exitapp
    }
return

;====================================================================================================;

#IfWinNotActive, ahk_class AutoHotkeyGUI
; Disabled annoying global shortcuts per request
$o::Reload
$m::ExitApp
$p:: goto StartCalculation
#IfWinNotActive

StartCalculation:
;====================================================================================================;

gosub, Calculations
settimer, runtime, 1000

tooltip, Press "O" to Reload, %TooltipX%, %Tooltip4%, 4
tooltip, Press "M" to Exit, %TooltipX%, %Tooltip5%, 5
tooltip, Do NOT use Roblox in Fullscreen, %TooltipX%, %Tooltip6%, 6
tooltip, , , , 10
tooltip, , , , 11
tooltip, , , , 12
tooltip, , , , 14
tooltip, , , , 16

if (ShakeMode == "Navigation")
{
	send {lshift}
	AutoBlurCamera := false
}

tooltip, Current Task: AutoLowerGraphics, %TooltipX%, %Tooltip7%, 7
tooltip, F10 Count: 0/20, %TooltipX%, %Tooltip9%, 9
f10counter := 0
if (AutoLowerGraphics == true)
	{
	send {shift}
	tooltip, Action: Press Shift, %TooltipX%, %Tooltip8%, 8
	sleep 50
	send {shift down}
	tooltip, Action: Hold Shift, %TooltipX%, %Tooltip8%, 8
	sleep 50
	loop, 20
		{
		f10counter++
		tooltip, F10 Count: %f10counter%/20, %TooltipX%, %Tooltip9%, 9
		send {f10}
		tooltip, Action: Press F10, %TooltipX%, %Tooltip8%, 8
		sleep 50
		}
	send {shift up}
	tooltip, Action: Release Shift, %TooltipX%, %Tooltip8%, 8
	sleep 50
	}

tooltip, Current Task: AutoZoomInCamera, %TooltipX%, %Tooltip7%, 7
tooltip, Scroll In: 0/20, %TooltipX%, %Tooltip9%, 9
tooltip, Scroll Out: 0/1, %TooltipX%, %Tooltip10%, 10
scrollcounter := 0
if (AutoZoomInCamera == true)
	{
	sleep 50
	loop, 20
		{
		scrollcounter++
		tooltip, Scroll In: %scrollcounter%/20, %TooltipX%, %Tooltip9%, 9
		send {wheelup}
		tooltip, Action: Scroll In, %TooltipX%, %Tooltip8%, 8
		sleep 50
		}
	send {wheeldown}
	tooltip, Scroll Out: 1/1, %TooltipX%, %Tooltip10%, 10
	tooltip, Action: Scroll Out, %TooltipX%, %Tooltip8%, 8
	AutoZoomDelay := AutoZoomDelay*5
	sleep 50
	}

RestartMacro:
sleep 100
if (AutoBlurCamera == true)
	{
		if (EndMinigame == true or NavigationFail == true)
		{
			send ``
		}
	}
tooltip, , , , 10

tooltip, Current Task: AutoEnableCameraMode, %TooltipX%, %Tooltip7%, 7
tooltip, Right Count: 0/10, %TooltipX%, %Tooltip9%, 9
rightcounter := 0
if (AutoEnableCameraMode == true)
	{
	PixelSearch, , , CameraCheckLeft, CameraCheckTop, CameraCheckRight, CameraCheckBottom, 0xFFFFFF, 0, Fast
	if !ErrorLevel
		{
		sleep 50
		if (NavigationFail == true)
		{
			sleep 50
			send {%NavigationKey%}
			sleep 50
			send {2}
			sleep 50
			NavigationFail := false
		}
		sleep 50
		send {2}
		tooltip, Action: Presss 2, %TooltipX%, %Tooltip8%, 8
		sleep 50
		send {1}
		tooltip, Action: Press 1, %TooltipX%, %Tooltip8%, 8
		sleep 50
		send {%NavigationKey%}
		tooltip, Action: Press %NavigationKey%, %TooltipX%, %Tooltip8%, 8
		sleep 50
		loop, 10
			{
			rightcounter++
			tooltip, Right Count: %rightcounter%/10, %TooltipX%, %Tooltip9%, 9
			send {right}
			tooltip, Action: Press Right, %TooltipX%, %Tooltip8%, 8
			sleep 150
			}
		send {enter}
		tooltip, Action: Press Enter, %TooltipX%, %Tooltip8%, 8
		sleep 50
		}
	}

tooltip, , , , 9
tooltip, Current Task: AutoLookDownCamera, %TooltipX%, %Tooltip7%, 7
if (AutoLookDownCamera == true)
	{
	send {rbutton up}
	sleep 50
	mousemove, LookDownX, LookDownY
	tooltip, Action: Position Mouse, %TooltipX%, %Tooltip8%, 8
	sleep 50
	send {rbutton down}
	tooltip, Action: Hold Right Click, %TooltipX%, %Tooltip8%, 8
	sleep 50
	DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", 10000)
	tooltip, Action: Move Mouse Down, %TooltipX%, %Tooltip8%, 8
	sleep 50
	send {rbutton up}
	tooltip, Action: Release Right Click, %TooltipX%, %Tooltip8%, 8
	sleep 50
	mousemove, LookDownX, LookDownY
	tooltip, Action: Position Mouse, %TooltipX%, %Tooltip8%, 8
	sleep 50
	}
	
tooltip, Current Task: AutoBlurCamera, %TooltipX%, %Tooltip7%, 7	
if (AutoBlurCamera == true)
	{
	sleep 50
	send ``
	tooltip, Action: Press ``, %TooltipX%, %Tooltip8%, 8
	sleep 50
	}

tooltip, Current Task: Casting Rod, %TooltipX%, %Tooltip7%, 7
send {lbutton down}
tooltip, Action: Casting For %HoldRodCastDuration%ms, %TooltipX%, %Tooltip8%, 8
sleep %HoldRodCastDuration%
send {lbutton up}
tooltip, Action: Waiting For Bobber (%WaitForBobberDelay%ms), %TooltipX%, %Tooltip8%, 8
sleep %WaitForBobberDelay%

if (ShakeMode == "Click")
goto ClickShakeMode
else if (ShakeMode == "Navigation")
goto NavigationShakeMode

;====================================================================================================;

ClickShakeFailsafe:
ClickFailsafeCount++
tooltip, Failsafe: %ClickFailsafeCount%/%ShakeFailsafe%, %TooltipX%, %Tooltip14%, 14
if (ClickFailsafeCount >= ShakeFailsafe)
	{
	settimer, ClickShakeFailsafe, off
	ForceReset := true
	}
return

ClickShakeMode:

tooltip, Current Task: Shaking, %TooltipX%, %Tooltip7%, 7
tooltip, Looking for White pixels, %TooltipX%, %Tooltip8%, 8
tooltip, Click X: None, %TooltipX%, %Tooltip9%, 9
tooltip, Click Y: None, %TooltipX%, %Tooltip10%, 10
tooltip, Click Count: 0, %TooltipX%, %Tooltip11%, 11

tooltip, Failsafe: 0/%ShakeFailsafe%, %TooltipX%, %Tooltip14%, 14

ClickFailsafeCount := 0
ClickCount := 0
ClickShakeRepeatBypassCounter := 0
MemoryX := 0
MemoryY := 0
ForceReset := false

settimer, ClickShakeFailsafe, 1000

ClickShakeModeRedo:
if (ForceReset == true)
	{
	tooltip, , , , 11
	tooltip, , , , 12
	tooltip, , , , 14
	goto RestartMacro
	}
sleep %ClickScanDelay%
PixelSearch, , , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, %FishBarColorTolerance%, Fast
if !ErrorLevel
	{
	settimer, ClickShakeFailsafe, off
	tooltip, , , , 9
	tooltip, , , , 11
	tooltip, , , , 12
	tooltip, , , , 14
	goto BarMinigame
	}
else
	{
	PixelSearch, ClickX, ClickY, ClickShakeLeft, ClickShakeTop, ClickShakeRight, ClickShakeBottom, 0xFFFFFF, %ClickShakeColorTolerance%, Fast
	if !ErrorLevel
		{

		tooltip, Click X: %ClickX%, %TooltipX%, %Tooltip9%, 9
		tooltip, Click Y: %ClickY%, %TooltipX%, %Tooltip10%, 10

		if (ClickX != MemoryX and ClickY != MemoryY)
			{
			ClickShakeRepeatBypassCounter := 0
			ClickCount++
			click, %ClickX%, %ClickY%
			tooltip, Click Count: %ClickCount%, %TooltipX%, %Tooltip11%, 11
			MemoryX := ClickX
			MemoryY := ClickY
			goto ClickShakeModeRedo
			}
		else
			{
			ClickShakeRepeatBypassCounter++
			if (ClickShakeRepeatBypassCounter >= 10)
				{
				MemoryX := 0
				MemoryY := 0
				}
			goto ClickShakeModeRedo
			}
		}
	else
		{
		goto ClickShakeModeRedo
		}
	}

;====================================================================================================;

NavigationShakeFailsafe:
NavigationFailsafeCount++
tooltip, Failsafe: %NavigationFailsafeCount%/%ShakeFailsafe%, %TooltipX%, %Tooltip10%, 10
if (NavigationFailsafeCount >= ShakeFailsafe)
	{
	settimer, NavigationShakeFailsafe, off
	ForceReset := true
	}
return

NavigationShakeMode:

tooltip, Current Task: Shaking, %TooltipX%, %Tooltip7%, 7
tooltip, Attempt Count: 0, %TooltipX%, %Tooltip8%, 8

tooltip, Failsafe: 0/%ShakeFailsafe%, %TooltipX%, %Tooltip10%, 10

NavigationFailsafeCount := 0
NavigationCounter := 0
ForceReset := false
settimer, NavigationShakeFailsafe, 1000
send {%NavigationKey%}
NavigationShakeModeRedo:
if (ForceReset == true)
	{
	tooltip, , , , 10
	NavigationFail := true
	goto RestartMacro
	}
sleep %NavigationSpamDelay%
PixelSearch, , , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, %FishBarColorTolerance%, Fast
if !ErrorLevel
	{
	settimer, NavigationShakeFailsafe, off
	goto BarMinigame
	}
else
	{
	NavigationCounter++
	tooltip, Attempt Count: %NavigationCounter%, %TooltipX%, %Tooltip8%, 8
	sleep 1
	send {s}
	sleep 1
	send {enter}
	goto NavigationShakeModeRedo
	}

;=========== BAR ====================================================================================================;
BarMinigame:
sleep %BaitDelay%
if (Sera == true)
	{
		tooltip, Current Task: Stablizing Seraphic, %TooltipX%, %Tooltip7%, 7
		tooltip, , , , 8
		loop, 25
		{
			send {lbutton down}
			sleep 50
			send {lbutton up}
			sleep 30
		}
		send {lbutton down}
		sleep 800
		send {lbutton up}
	}
; Thanks Lunar ==================
if Control == 0:
	Control := 0.001
WhiteBarSize := Round((A_ScreenWidth / 247.03) * (InStr(Control, "0.") ? (Control * 100) : Control) + (A_ScreenWidth / 8.2759), 0)
sleep 50
goto BarMinigameSingle


;====================================================================================================;

BarMinigameSingle:

	EndMinigame := false
	tooltip, Current Task: Playing Bar Minigame, %TooltipX%, %Tooltip7%, 7
	tooltip, Bar Size: %WhiteBarSize%, %TooltipX%, %Tooltip8%, 8
	tooltip, Looking for Bar, %TooltipX%, %Tooltip10%, 10
	HalfBarSize := WhiteBarSize/2
	Deadzone := WhiteBarSize*0.1
	Deadzone2 := HalfBarSize*0.75
	
	MaxLeftBar := FishBarLeft+(WhiteBarSize*SideBarRatio)
	MaxRightBar := FishBarRight-(WhiteBarSize*SideBarRatio)
	settimer, BarMinigame2, %ScanDelay%
	
BarMinigameAction:
if (EndMinigame == true)
	{
		sleep %RestartDelay%
		goto RestartMacro
	}
if (Action == 0)
	{
		SideToggle := false
		send {lbutton down}
		sleep 10
		send {lbutton up}
		sleep 10
	}
else if (Action == 1)
	{
		SideToggle := false
		send {lbutton up}
		if (AnkleBreak == false)
		{
			sleep %AnkleBreakDuration%
			AnkleBreakDuration := 0
		}
		AdaptiveDuration := 0.5 + 0.5 * (DistanceFactor ** 1.2)
		if (DistanceFactor < 0.2)
			AdaptiveDuration := 0.15 + 0.15 * DistanceFactor
		Duration := Abs(Direction) * StableLeftMultiplier * PixelScaling * AdaptiveDuration
		sleep %Duration%
		send {lbutton down}
		CounterStrafe := Duration/StableLeftDivision
		sleep %CounterStrafe%
		AnkleBreak := true
		AnkleBreakDuration := AnkleBreakDuration+(Duration-CounterStrafe)*LeftAnkleBreakMultiplier
	}
else if (Action == 2)
	{
		SideToggle := false
		send {lbutton down}
		if (AnkleBreak == true)
		{
			sleep %AnkleBreakDuration%
			AnkleBreakDuration := 0
		}
		AdaptiveDuration := 0.5 + 0.5 * (DistanceFactor ** 1.2)
		if (DistanceFactor < 0.2)
			AdaptiveDuration := 0.15 + 0.15 * DistanceFactor
		Duration := Abs(Direction) * StableRightMultiplier * PixelScaling * AdaptiveDuration
		sleep %Duration%
		send {lbutton up}
		CounterStrafe := Duration/StableRightDivision
		sleep %CounterStrafe%
		AnkleBreak := false
		AnkleBreakDuration := AnkleBreakDuration+(Duration-CounterStrafe)*RightAnkleBreakMultiplier
	}
else if (Action == 3)
	{
		if (SideToggle == false)
		{
			AnkleBreak := none
			AnkleBreakDuration := 0
			SideToggle := true
			send {lbutton up}
			sleep %SideDelay%
		}
		sleep %ScanDelay%
	}
else if (Action == 4)
	{
		if (SideToggle == false)
		{
			AnkleBreak := none
			AnkleBreakDuration := 0
			SideToggle := true
			send {lbutton down}
			sleep %SideDelay%
		}
		sleep %ScanDelay%
	}
else if (Action == 5)
	{
		SideToggle := false
		send {lbutton up}
		if (AnkleBreak == false)
		{
			sleep %AnkleBreakDuration%
			AnkleBreakDuration := 0
		}
		MinDuration := 10
		if (Control == 0.15 or Control > 0.15){
			MaxDuration := WhiteBarSize*0.88
		}else if(Control == 0.2 or Control > 0.2){
			MaxDuration := WhiteBarSize*0.8
		}else if(Control == 0.25 or Control > 0.25){
			MaxDuration := WhiteBarSize*0.75
		}else{
			MaxDuration := WhiteBarSize + (Abs(Direction) * 0.2)
		}
		Duration := Max(MinDuration, Min(Abs(Direction) * UnstableLeftMultiplier * PixelScaling, MaxDuration))
		sleep %Duration%
		send {lbutton down}
		CounterStrafe := Duration/UnstableLeftDivision
		sleep %CounterStrafe%
		AnkleBreak := true
		AnkleBreakDuration := AnkleBreakDuration+(Duration-CounterStrafe)*LeftAnkleBreakMultiplier
	}
else if (Action == 6)
	{
		SideToggle := false
		send {lbutton down}
		if (AnkleBreak == true)
		{
			sleep %AnkleBreakDuration%
			AnkleBreakDuration := 0
		}
		MinDuration := 10
		if (Control == 0.15 or Control > 0.15){
			MaxDuration := WhiteBarSize*0.88
		}else if(Control == 0.2 or Control > 0.2){
			MaxDuration := WhiteBarSize*0.8
		}else if(Control == 0.25 or Control > 0.25){
			MaxDuration := WhiteBarSize*0.75
		}else{
			MaxDuration := WhiteBarSize + (Abs(Direction) * 0.2)
		}	
		Duration := Max(MinDuration, Min(Abs(Direction) * UnstableRightMultiplier * PixelScaling, MaxDuration))
		sleep %Duration%
		send {lbutton up}
		CounterStrafe := Duration/UnstableRightDivision
		sleep %CounterStrafe%
		AnkleBreak := false
		AnkleBreakDuration := AnkleBreakDuration+(Duration-CounterStrafe)*RightAnkleBreakMultiplier
	}
else
	{
		sleep %ScanDelay%
	}
goto BarMinigameAction



BarMinigame2:
sleep 1
PixelSearch, FishX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, %FishBarColorTolerance%, Fast
if !ErrorLevel
	{
	tooltip, +, %FishX%, %FishBarTooltipHeight%, 20
	if (FishX < MaxLeftBar)
		{
			Action := 3
			tooltip, |, %MaxLeftBar%, %FishBarTooltipHeight%, 19
			tooltip, Direction: Max Left, %TooltipX%, %Tooltip10%, 10
			PixelSearch, ArrowX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x878584, %ArrowColorTolerance%, Fast
				if !ErrorLevel
				{	
					tooltip, <-, %ArrowX%, %FishBarTooltipHeight%, 18
					if (MaxLeftBar < ArrowX)
					{	
						SideToggle := false
					}
				}
			return
		}
	else if (FishX > MaxRightBar)
		{
			Action := 4
			tooltip, |, %MaxRightBar%, %FishBarTooltipHeight%, 19
			tooltip, Direction: Max Right, %TooltipX%, %Tooltip10%, 10
			PixelSearch, ArrowX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x878584, %ArrowColorTolerance%, Fast
				if !ErrorLevel
				{	
					tooltip, ->, %ArrowX%, %FishBarTooltipHeight%, 18
					if (MaxRightBar > ArrowX)
					{	
						SideToggle := false
					}
				}
			return
		}
	PixelSearch, BarX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0xFFFFFF, %WhiteBarColorTolerance%, Fast
	if !ErrorLevel
		{
			tooltip, , , , 18
			BarX := BarX + HalfBarSize
			Direction := BarX - FishX
			DistanceFactor := Abs(Direction) / HalfBarSize

			Ratio2 := Deadzone2/WhiteBarSize
			if (Direction > Deadzone && Direction < Deadzone2)
			{
				Action := 1
				tooltip, Tracking direction: <, %TooltipX%, %Tooltip10%, 10
				tooltip, <, %BarX%, %FishBarTooltipHeight%, 19
			}
			else if (Direction < -Deadzone && Direction > -Deadzone2)
			{
				Action := 2
				tooltip, Tracking direction: >, %TooltipX%, %Tooltip10%, 10
				tooltip, >, %BarX%, %FishBarTooltipHeight%, 19
			}
			else if (Direction > Deadzone2)
			{
				Action := 5
				tooltip, Tracking direction: <<<, %TooltipX%, %Tooltip10%, 10
				tooltip, <, %BarX%, %FishBarTooltipHeight%, 19
			}
			else if (Direction < -Deadzone2)
			{
				Action := 6
				tooltip, Tracking direction: >>>, %TooltipX%, %Tooltip10%, 10
				tooltip, >, %BarX%, %FishBarTooltipHeight%, 19
			}
			else
			{
				Action := 0
				tooltip, Stabilizing, %TooltipX%, %Tooltip10%, 10
				tooltip, ., %BarX%, %FishBarTooltipHeight%, 19
			}
		}
	else
		{
			Direction := HalfBarSize
			PixelSearch, ArrowX, , FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x878584, %ArrowColorTolerance%, Fast
			ArrowX := ArrowX-FishX
			if (ArrowX > 0)
			{	
				Action := 5
				BarX := FishX+HalfBarSize
				tooltip, Tracking direction: <<<, %TooltipX%, %Tooltip10%, 10
				tooltip, <, %BarX%, %FishBarTooltipHeight%, 19
			}
			else
			{	
				Action := 6
				BarX := FishX-HalfBarSize
				tooltip, Tracking direction: >>>, %TooltipX%, %Tooltip10%, 10
				tooltip, >, %BarX%, %FishBarTooltipHeight%, 19
			}
		}
	}
else
	{
		tooltip, , , , 10
		tooltip, , , , 11
		tooltip, , , , 12
		tooltip, , , , 13
		tooltip, , , , 14
		tooltip, , , , 15
		tooltip, , , , 17
		tooltip, , , , 18
		tooltip, , , , 19
		tooltip, , , , 20
		EndMinigame := true
		settimer, BarMinigame2, Off
	}