#SingleInstance Force
#Warn All, OutputDebug

SetTitleMatchMode 2

; Application/version label (change this string to update the GUI title)
AppVersion := "V13 Remasterd by SeneX"

; Theme state
DarkMode := 0

; Central script/config paths
ScriptDir := A_ScriptDir
ConfigDir := ScriptDir "\\Configs"
if !FileExist(ConfigDir)
	DirCreate(ConfigDir)

; If not running elevated, relaunch the script as administrator and exit this instance.
if (!A_IsAdmin) {
	try {
		; Use ShellExecuteW with the "runas" verb to trigger UAC and run the current AHK executable with this script as argument.
		DllCall("Shell32\ShellExecuteW", "ptr", 0, "wstr", "runas", "wstr", A_AhkPath, "wstr", A_ScriptFullPath, "wstr", A_ScriptDir, "int", 1)
	} catch {
		MsgBox("Error: Unable to relaunch script as administrator. Please run the script as admin manually.", "Error", "Icon!")
	}
	ExitApp()
}

; Runtime tracking variables
runtimeS := 0
runtimeM := 0
runtimeH := 0
f10counter := 0

; Macro start flag
IsStarted := false

; Config search variables
masterCfgList := []


; Simple INI helpers (AHK v2-compatible). Use IniReadVar/IniWriteVar to access INI files.
IniReadVar(file, section, key, default := "") {
	return IniRead(file, section, key, default)
}

IniWriteVar(file, section, key, value) {
	; Ensure target directory exists and gracefully handle permission errors.
	try {
		; extract directory from path
		dir := RegExReplace(file, "\\[^\\]+$", "")
		if (dir != "" && !FileExist(dir))
			DirCreate(dir)
	} catch {
		; ignore dir creation errors, we'll handle write error below
	}

	try {
		IniWrite(file, section, key, value)
		return true
	} catch {
		; Fallback: try writing to script root default.ini
		fallback := A_ScriptDir "\\default.ini"
		try {
			IniWrite(fallback, section, key, value)
			MsgBox("Warning: Unable to write to '" file "'. Settings saved to '" fallback "' instead.", "Warning", "Icon!")
			return true
		} catch {
			MsgBox("Error: Unable to save settings to '" file "' or fallback '" fallback "'. Check folder permissions or run the script as an administrator.", "Error", "Icon!")
			return false
		}
	}
}

; GUI==============================================================================================================;
; Require AHK v2 and build object-style GUI

#Requires AutoHotkey v2

; If a saved theme exists in default.ini, load it so controls are created with correct colors
startDarkMode := IniReadVar(ConfigDir "\\default.ini", "General", "DarkMode", "0")
if (startDarkMode = "1" || startDarkMode = 1)
	DarkMode := 1
else
	DarkMode := 0

; Create GUI (AHK v2 style)
MainGui := Gui("+Resize +MinSize +AlwaysOnTop", "Fisch Macro " . AppVersion)
MainGui.MarginX := 12
MainGui.MarginY := 12

; Set base font and color depending on theme
if (DarkMode) {
	MainGui.Font := "s12 cFFFFFF Segoe UI"
	MainGui.Color := 0x1E1E1E
	FontColor := "FFFFFF"
} else {
	MainGui.Font := "s12 c000000 Segoe UI"
	MainGui.Color := 0xF5F5F5
	FontColor := "000000"
}

MainGui.Font := "s10 c" FontColor " Segoe UI"

Tab := MainGui.Add("Tab", "x10 y15 w780 h500", ["General Settings", "Shake Settings", "Minigame Settings"])

if (DarkMode)
	Tab.BackColor := 0x1E1E1E
else
	Tab.BackColor := 0xF5F5F5

; General Settings Tab
Tab.UseTab("General Settings")
MainGui.Add("Text", "x30 y50", "Lower Graphics:")
AutoLowerGraphics := MainGui.Add("Checkbox", "x170 y50 vAutoLowerGraphics", "Enable")
MainGui.Add("Text", "x30 y90", "Zoom In:")
AutoZoomInCamera := MainGui.Add("Checkbox", "x170 y90 vAutoZoomInCamera", "Enable")
MainGui.Add("Text", "x30 y130", "Enable Camera Mode:")
AutoEnableCameraMode := MainGui.Add("Checkbox", "x170 y130 vAutoEnableCameraMode", "Enable")
MainGui.Add("Text", "x30 y170", "Look Down:")
AutoLookDownCamera := MainGui.Add("Checkbox", "x170 y170 vAutoLookDownCamera", "Enable")
MainGui.Add("Text", "x30 y210", "Blur:")
AutoBlurCamera := MainGui.Add("Checkbox", "x170 y210 vAutoBlurCamera", "Enable")
MainGui.Add("Text", "x30 y240", "Restart Delay (ms):")
RestartDelay := MainGui.Add("Edit", "x220 y240 w100 vRestartDelay", "1500")
RestartDelay.OnEvent("Change", EditChangeDispatcher)
MainGui.Add("Text", "x30 y280", "Hold Rod Cast Duration (ms):")
HoldRodCastDuration := MainGui.Add("Edit", "x220 y280 w100 vHoldRodCastDuration", "600")
HoldRodCastDuration.OnEvent("Change", EditChangeDispatcher)
MainGui.Add("Text", "x30 y320", "Wait for Bobber to Land (ms):")
WaitForBobberDelay := MainGui.Add("Edit", "x220 y320 w100 vWaitForBobberDelay", "1000")
WaitForBobberDelay.OnEvent("Change", EditChangeDispatcher)
MainGui.Add("Text", "x30 y360", "Bait Delay (ms):")
BaitDelay := MainGui.Add("Edit", "x220 y360 w100 vBaitDelay", "300")
BaitDelay.OnEvent("Change", EditChangeDispatcher)

MainGui.Add("Text", "x380 y300", "Seraphic Rod Check:")
Sera := MainGui.Add("Checkbox", "x500 y300 vSera", "Enable")
MainGui.Add("Text", "x380 y320", "Only Enable if youre using Seraphic Rod")

; Mini guide (compact clickable) - info buttons
MainGui.Font := "s9 c" FontColor " Segoe UI"
; Replace small info button with a Join Discord badge
MainGui.Add("Button", "x330 y36 w120 h22 c00AEEF", "Join Discord").OnEvent("Click", (*) => Run("https://discord.gg/dHUM2ejQGY"))
MainGui.Add("Button", "x360 y60 w16 h16", "i").OnEvent("Click", (*) => Info2())
MainGui.Add("Button", "x360 y80 w16 h16", "i").OnEvent("Click", (*) => Info3())
MainGui.Add("Button", "x360 y120 w16 h16", "i").OnEvent("Click", (*) => Info4())
MainGui.Add("Button", "x360 y200 w16 h16", "i").OnEvent("Click", (*) => Info5())
MainGui.Add("Button", "x360 y240 w16 h16", "i").OnEvent("Click", (*) => Info6())
MainGui.Add("Button", "x360 y280 w16 h16", "i").OnEvent("Click", (*) => Info7())
MainGui.Add("Button", "x360 y360 w16 h16", "i").OnEvent("Click", (*) => Info8())
MainGui.Font := "s10 c" FontColor " Segoe UI"

; Shake Settings Tab
Tab.UseTab("Shake Settings")
MainGui.Add("Text", "x30 y65", "Navigation Key:")
NavigationKey := MainGui.Add("Edit", "x190 y65 w100 vNavigationKey", '\')
MainGui.Add("Text", "x30 y105", "Shake Mode:")
ShakeMode := MainGui.Add("DropDownList", "x190 y105 w100 vShakeMode", ["Click", "Navigation"])
MainGui.Add("Text", "x30 y145", "Shake Failsafe (sec):")
ShakeFailsafe := MainGui.Add("Edit", "x190 y145 w100 vShakeFailsafe", "20")
ShakeFailsafe.OnEvent("Change", EditChangeDispatcher)

; Click set
MainGui.Add("Text", "x30 y185", "Click Shake Color Tolerance:")
ClickShakeColorTolerance := MainGui.Add("Edit", "x190 y185 w100 vClickShakeColorTolerance", "3")
ClickShakeColorTolerance.OnEvent("Change", EditChangeDispatcher)
MainGui.Add("Text", "x30 y225", "Click Scan Delay (ms):")
ClickScanDelay := MainGui.Add("Edit", "x190 y225 w100 vClickScanDelay", "10")
ClickScanDelay.OnEvent("Change", EditChangeDispatcher)
MainGui.Add("Text", "x380 y225", "Adjust the Click Speed")

; Nav set
MainGui.Add("Text", "x30 y265", "Navigation Spam Delay (ms):")
NavigationSpamDelay := MainGui.Add("Edit", "x190 y265 w100 vNavigationSpamDelay", "10")
NavigationSpamDelay.OnEvent("Change", EditChangeDispatcher)
MainGui.Add("Text", "x380 y265", "Adjust the Navigation spam speed")

MainGui.Add("Text", "x380 y65", "Check your Navigation Key in the Roblox settings")
MainGui.Add("Text", "x380 y105", "Click for for mouse clicks | Navigation for Navigation spam")
MainGui.Add("Text", "x380 y145", "How many seconds before restarting if failed to shake")
MainGui.Add("Text", "x30 y325", "If you already set it up, to ensure Shake Mode works:")
MainGui.Add("Text", "x30 y345", "Load settings -> Save settings -> Start Macro")

; Minigame Settings Tab
Tab.UseTab("Minigame Settings")

MainGui.Font := "Bold"
MainGui.Add("Text", "x30 y65", "!!!!! Check the Control stat of your Rod !!!!!")
MainGui.Font := "s10 c" FontColor " Segoe UI"
MainGui.Add("Text", "x30 y85", "Control Value:")
Control := MainGui.Add("Edit", "x180 y85 w100 vControl", "0")
Control.OnEvent("Change", EditChangeDispatcher)
MainGui.Add("Text", "x30 y125", "Fish Bar Color Tolerance:")
FishBarColorTolerance := MainGui.Add("Edit", "x180 y125 w100 vFishBarColorTolerance", "5")
FishBarColorTolerance.OnEvent("Change", EditChangeDispatcher)
MainGui.Add("Text", "x30 y165", "White Bar Color Tolerance:")
WhiteBarColorTolerance := MainGui.Add("Edit", "x180 y165 w100 vWhiteBarColorTolerance", "15")
WhiteBarColorTolerance.OnEvent("Change", EditChangeDispatcher)
MainGui.Add("Text", "x30 y205", "Arrow Color Tolerance:")
ArrowColorTolerance := MainGui.Add("Edit", "x180 y205 w100 vArrowColorTolerance", "6")
ArrowColorTolerance.OnEvent("Change", EditChangeDispatcher)

MainGui.Add("Text", "x30 y245", "Scan Delay:")
ScanDelay := MainGui.Add("Edit", "x180 y245 w100 vScanDelay", "10")
ScanDelay.OnEvent("Change", EditChangeDispatcher)
MainGui.Add("Text", "x30 y285", "Side Bar Ratio:")
SideBarRatio := MainGui.Add("Edit", "x180 y285 w100 vSideBarRatio", "0.7")
SideBarRatio.OnEvent("Change", EditChangeDispatcher)
MainGui.Add("Text", "x30 y325", "Side Delay:")
SideDelay := MainGui.Add("Edit", "x180 y325 w100 vSideDelay", "400")
SideDelay.OnEvent("Change", EditChangeDispatcher)

MainGui.Add("Text", "x30 y365", "Minigame Settings Guide")
MainGui.Add("Text", "x30 y385", "Make your own config or use others")

; Right side labels for multiplier/division settings
MainGui.Add("Text", "x380 y65", "Stable Right Multiplier:")
; Stable
StableRightMultiplier := MainGui.Add("Edit", "x550 y65 w100 vStableRightMultiplier", "2.36")
MainGui.Add("Text", "x380 y105", "Stable Right Division:")
StableRightDivision := MainGui.Add("Edit", "x550 y105 w100 vStableRightDivision", "1.55")
MainGui.Add("Text", "x380 y145", "Stable Left Multiplier:")
StableLeftMultiplier := MainGui.Add("Edit", "x550 y145 w100 vStableLeftMultiplier", "1.211")
MainGui.Add("Text", "x380 y185", "Stable Left Division:")
StableLeftDivision := MainGui.Add("Edit", "x550 y185 w100 vStableLeftDivision", "1.12")

; Unstable
MainGui.Add("Text", "x380 y210", "Unstable Right Multiplier:")
UnstableRightMultiplier := MainGui.Add("Edit", "x550 y210 w100 vUnstableRightMultiplier", "2.665")
MainGui.Add("Text", "x380 y250", "Unstable Right Division:")
UnstableRightDivision := MainGui.Add("Edit", "x550 y250 w100 vUnstableRightDivision", "1.5")
MainGui.Add("Text", "x380 y290", "Unstable Left Multiplier:")
UnstableLeftMultiplier := MainGui.Add("Edit", "x550 y290 w100 vUnstableLeftMultiplier", "2.19")
MainGui.Add("Text", "x380 y330", "Unstable Left Division:")
UnstableLeftDivision := MainGui.Add("Edit", "x550 y330 w100 vUnstableLeftDivision", "1")

; Ankle
MainGui.Add("Text", "x380 y360", "Right Ankle Break Multiplier:")
RightAnkleBreakMultiplier := MainGui.Add("Edit", "x550 y360 w100 vRightAnkleBreakMultiplier", "0.75")
MainGui.Add("Text", "x380 y400", "Left Ankle Break Multiplier:")
LeftAnkleBreakMultiplier := MainGui.Add("Edit", "x550 y400 w100 vLeftAnkleBreakMultiplier", "0.45")

;
; --- Input sanitizers for numeric fields ---
SanitizeInt(ctrl) {
	try val := ctrl.Value
	catch
		return
	cleaned := RegExReplace(val, "[^0-9]")
	if (cleaned != val)
		ctrl.Value := cleaned
}

SanitizeFloat(ctrl) {
	try val := ctrl.Value
	catch
		return
	; allow digits and one decimal point
	cleaned := RegExReplace(val, "[^0-9\.]")
	; collapse multiple decimals to single
	if (RegExMatch(cleaned, "\.(.*)\."))
		cleaned := RegExReplace(cleaned, "\.(?=.*\.)", "")
	if (cleaned != val)
		ctrl.Value := cleaned
}

; End of tab content - place buttons outside tabs
Tab.UseTab()

; Buttons row
; Position dropdown-aligned button row closer to the dropdown. Buttons keep 100px spacing but start near the dropdown.
BtnSave := MainGui.Add("Button", "x120 y460 w80 h30", "Save settings")
BtnSave.OnEvent("Click", (*) => SaveSettings())
BtnClear := MainGui.Add("Button", "x220 y460 w80 h30", "Clear settings")
BtnClear.OnEvent("Click", (*) => ClearSettings())
BtnExit := MainGui.Add("Button", "x420 y460 w80 h30", "Exit")
BtnExit.OnEvent("Click", (*) => ExitScript())
BtnLaunch := MainGui.Add("Button", "x520 y460 w80 h30", "Start Macro")
BtnLaunch.OnEvent("Click", (*) => Launch())
BtnToggleDark := MainGui.Add("Button", "x320 y460 w80 h30 vDarkModeBtn", "Dark Mode")
BtnToggleDark.OnEvent("Click", (*) => ToggleDarkMode())
if (DarkMode)
	BtnToggleDark.Text := "Light Mode"
else
	BtnToggleDark.Text := "Dark Mode"
MainGui.Add("Text", "x30 y440", "Config:")
; Dropdown is created only by FilterConfigs()

SetEditFonts()  ; Apply theme colors to all controls

MainGui.Show("x100 y100")
MainGui.OnEvent("Close", (*) => ExitScript())

; Ensure edit/dropdown text remains black for readability
SetEditFonts()
ApplyTheme()

; Build master list of config names from Configs/ and root; keep "default" separate
masterCfgList := []
tmpList := []

; Ensure SettingsFileName has a sensible default early so it's safe to reference
SettingsFileName := ConfigDir "\\default.ini"

; Collect from Configs folder first
Loop Files, ConfigDir "\\*.ini" {
	fileName := RegExReplace(A_LoopFileName, "\.ini$")
	if (fileName == "" || fileName == ".")
		continue
	tmpList.Push(fileName)
}

; Collect from root folder as well
Loop Files, ScriptDir "\\*.ini" {
	fileName := RegExReplace(A_LoopFileName, "\.ini$")
	if (fileName == "" || fileName == ".")
		continue
	tmpList.Push(fileName)
}

; Deduplicate while preserving order and skip the default entry here (we add default manually in dropdown)
seen := {}
for index, name in tmpList {
	if (name = "default")
		continue
	if (seen.HasProp(name))
		continue
	seen.%name% := true
	masterCfgList.Push(name)
}

; End of auto-execute portion - functions start after this Return

; Now that masterCfgList is built, populate dropdown and load default
FilterConfigs()
try DropItem.Choose(1)  ; choose first item (default)
catch
	; ignore if dropdown isn't ready
SettingsFileName := ConfigDir "\\default.ini"
if FileExist(SettingsFileName)
	LoadSettings()


; Hotkeys - work only when Roblox is active and macro is started
#HotIf WinActive("ahk_exe RobloxPlayerBeta.exe") || WinActive("ahk_exe eurotruck2.exe")

o::
{
	global IsStarted
	if !IsStarted
		return
	Reload()
}

m::
{
	global IsStarted
	if !IsStarted
		return
	ExitApp()
}

p::
{
	global IsStarted
	if !IsStarted
		return
	StartCalculation()
}

q::
{
	global IsStarted
	if !IsStarted
		return
	Pause
}

#HotIf
    

; Restore previously selected config if it exists
savedConfig := IniReadVar(ConfigDir "\\default.ini", "General", "CurrentConfig", "")
if (savedConfig != "" && savedConfig != "ERROR") {
	for index, configName in masterCfgList {
		if (configName = savedConfig) {
			DropItem.Value := savedConfig
			SettingsFileName := ConfigDir '\\' savedConfig '.ini'
			LoadSettings()
			break
		}
	}
}

; start hover checker for help buttons
SetTimer(CheckHelpHover, 200)

; Ensure SettingsFileName has a sane default so writes go to a real file
SettingsFileName := ConfigDir "\\default.ini"

; Load default settings on startup only if no config was restored
if (DropItem = "") {
	LoadSettings()
}

Return

SelectItem(ctrl, eventInfo)
{
	selected := ctrl.Value
	if (selected = "(no configs)" || selected = "(no matches)")
		return
	if (selected = "default") {
	SettingsFileName := ConfigDir "\\default.ini"
	} else {
		SettingsFileName := ConfigDir '\\' selected '.ini'
		; If not found in Configs folder, try root folder
		if !FileExist(SettingsFileName)
			SettingsFileName := ScriptDir '\\' selected '.ini'
	}
	if !FileExist(SettingsFileName)
		return
	LoadSettings()
	ctrl.Value := selected
}

FilterConfigs()
{
	global DropItem, masterCfgList, MainGui

	; Build the list starting with default
	local configList := ["default"]
	for name in masterCfgList {
		configList.Push(name)
	}
	if (configList.Length <= 1) {
		configList := ["default", "(no configs)"]
	}
	try {
		DropItem.Delete()
	} catch {
		; ignore if control doesn't exist yet
	}
	; Create dropdown matching Save button size (w80 h30). r7 keeps expanded list scrollable.
	DropItem := MainGui.Add("DropDownList", "x30 y460 w80 h30 r7", configList)
	DropItem.OnEvent("Change", SelectItem)
	SetEditFonts()
}

OpenCfgDropdown()
{
	global DropItem
	DropItem.Focus()
	Send("{Down}")
}

HelpLower() {
	Tooltip("Lowers in-game graphics automatically to improve performance.", 200, 200)
	SetTimer(ClearTooltip, -1500)
}

HelpZoom() {
	Tooltip("Zooms the camera in to improve detection of targets.", 200, 200)
	SetTimer(ClearTooltip, -1500)
}

HelpEnableCam() {
	Tooltip("Enables camera-mode automatically before starting the macro.", 200, 200)
	SetTimer(ClearTooltip, -1500)
}

HelpLookDown() {
	Tooltip("Automatically looks down to position the bobber in view.", 200, 200)
	SetTimer(ClearTooltip, -1500)
}

HelpBlur() {
	Tooltip("Toggles blur effect handling (used to open certain menus).", 200, 200)
	SetTimer(ClearTooltip, -1500)
}

; persistent small info GUI
Info1() {
	global Info1Gui, FontColor
	Info1Gui := Gui("+AlwaysOnTop -SysMenu +ToolWindow", "Info - Join White Sands Macros")
	Info1Gui.Font := "s10 c" FontColor " Segoe UI"
	Info1Gui.Add("Text", "x10 y10", "Join White Sands Macros")
	t1 := Info1Gui.Add("Text", "x10 y30 c00AEEF", "was remasted by SenX")
	t1.OnEvent("Click", (*) => OpenRemaster())
	t2 := Info1Gui.Add("Text", "x170 y30 c00AEEF", "https://discord.gg/dHUM2ejQGY")
	t2.OnEvent("Click", (*) => OpenDiscord())
	btn := Info1Gui.Add("Button", "x10 y60 w60 h22", "Close")
	btn.OnEvent("Click", (*) => CloseInfo1())
	Info1Gui.Show("AutoSize Center")
}

Info2() {
	MsgBox("Check out the pre-setup before you begin (Only available in the discord above)", "Info", 0x40000)
}

Info3() {
	MsgBox("If its your first time, please check all the boxes", "Info", 0x40000)
}

Info4() {
	MsgBox("Click the camera icon top right in case it doesnt work", "Info", 0x40000)
}

Info5() {
	MsgBox("If youre wondering, this will open the menu after enabling camera mode", "Info", 0x40000)
}

Info6() {
	MsgBox("Adjust wait time before restarting the macro", "Info", 0x40000)
}

Info7() {
	MsgBox("Increase the Hold duration if you have high ping", "Info", 0x40000)
}

Info8() {
	MsgBox("If you cant load or save settings, Right click the macro and choose Run as Admin`n( requires AutoHotkey v2 )", "Info", 0x40000)
}

OpenRemaster() {
	; Open the discord for now (no separate URL was provided for remaster credit)
	Run("https://discord.gg/dHUM2ejQGY")
}

OpenDiscord() { 
	Run("https://discord.gg/dHUM2ejQGY") 
}

CloseInfo1() {
	global Info1Gui
	if IsObject(Info1Gui)
		Info1Gui.Destroy()
}

ClearTooltip() { 
	Tooltip() 
}

CheckHelpHover() {
	MouseGetPos(&mx, &my)

	; If mouse is over the config dropdown area, skip tooltip processing to avoid
	; interfering with dropdown expansion/interaction.
	; Dropdown is placed at x30 y460 w70 h22 (closed). Allow a slightly larger
	; region to cover expanded list area.
	if (mx >= 30 && mx <= 110 && my >= 440 && my <= 540)
		return
	if (mx >= 270 && mx <= 290 && my >= 50 && my <= 68) {
		Tooltip("Lowers in-game graphics automatically to improve performance.", mx, my)
		return
	}
	if (mx >= 270 && mx <= 290 && my >= 90 && my <= 108) {
		Tooltip("Zooms the camera in to improve detection of targets.", mx, my)
		return
	}
	if (mx >= 270 && mx <= 290 && my >= 130 && my <= 148) {
		Tooltip("Enables camera-mode automatically before starting the macro.", mx, my)
		return
	}
	if (mx >= 270 && mx <= 290 && my >= 170 && my <= 188) {
		Tooltip("Automatically looks down to position the bobber in view.", mx, my)
		return
	}
	if (mx >= 270 && mx <= 290 && my >= 210 && my <= 228) {
		Tooltip("Toggles blur effect handling (used to open certain menus).", mx, my)
		return
	}
	Tooltip()
}

; Search/filtering removed — users must pick from dropdown to change configs

; Save settings
SaveSettings() {
	; read values from control objects and write to INI
	SettingsFileName := ConfigDir "\\default.ini"

	FileAppend("", SettingsFileName) ; ensure file exists

	IniWriteVar(SettingsFileName, "General", "AutoLowerGraphics", AutoLowerGraphics.Value)
	IniWriteVar(SettingsFileName, "General", "AutoZoomInCamera", AutoZoomInCamera.Value)
	IniWriteVar(SettingsFileName, "General", "AutoEnableCameraMode", AutoEnableCameraMode.Value)
	IniWriteVar(SettingsFileName, "General", "AutoLookDownCamera", AutoLookDownCamera.Value)
	IniWriteVar(SettingsFileName, "General", "AutoBlurCamera", AutoBlurCamera.Value)

	IniWriteVar(SettingsFileName, "General", "RestartDelay", RestartDelay.Value)
	IniWriteVar(SettingsFileName, "General", "HoldRodCastDuration", HoldRodCastDuration.Value)
	IniWriteVar(SettingsFileName, "General", "WaitForBobberDelay", WaitForBobberDelay.Value)
	IniWriteVar(SettingsFileName, "General", "BaitDelay", BaitDelay.Value)
	IniWriteVar(SettingsFileName, "General", "Sera", Sera.Value)

	IniWriteVar(SettingsFileName, "Shake", "NavigationKey", NavigationKey.Value)
	; Save ShakeMode as text value instead of index
	ShakeModeText := (ShakeMode.Value = 1) ? "Click" : "Navigation"
	IniWriteVar(SettingsFileName, "Shake", "ShakeMode", ShakeModeText)
	IniWriteVar(SettingsFileName, "Shake", "ShakeFailsafe", ShakeFailsafe.Value)

	IniWriteVar(SettingsFileName, "Shake", "ClickShakeColorTolerance", ClickShakeColorTolerance.Value)
	IniWriteVar(SettingsFileName, "Shake", "ClickScanDelay", ClickScanDelay.Value)
	IniWriteVar(SettingsFileName, "Shake", "NavigationSpamDelay", NavigationSpamDelay.Value)

	IniWriteVar(SettingsFileName, "Minigame", "Control", Control.Value)
	IniWriteVar(SettingsFileName, "Minigame", "FishBarColorTolerance", FishBarColorTolerance.Value)
	IniWriteVar(SettingsFileName, "Minigame", "WhiteBarColorTolerance", WhiteBarColorTolerance.Value)
	IniWriteVar(SettingsFileName, "Minigame", "ArrowColorTolerance", ArrowColorTolerance.Value)

	IniWriteVar(SettingsFileName, "Minigame", "ScanDelay", ScanDelay.Value)
	IniWriteVar(SettingsFileName, "Minigame", "SideBarRatio", SideBarRatio.Value)
	IniWriteVar(SettingsFileName, "Minigame", "SideDelay", SideDelay.Value)

	IniWriteVar(SettingsFileName, "Minigame", "StableRightMultiplier", StableRightMultiplier.Value)
	IniWriteVar(SettingsFileName, "Minigame", "StableRightDivision", StableRightDivision.Value)
	IniWriteVar(SettingsFileName, "Minigame", "StableLeftMultiplier", StableLeftMultiplier.Value)
	IniWriteVar(SettingsFileName, "Minigame", "StableLeftDivision", StableLeftDivision.Value)

	IniWriteVar(SettingsFileName, "Minigame", "UnstableRightMultiplier", UnstableRightMultiplier.Value)
	IniWriteVar(SettingsFileName, "Minigame", "UnstableRightDivision", UnstableRightDivision.Value)
	IniWriteVar(SettingsFileName, "Minigame", "UnstableLeftMultiplier", UnstableLeftMultiplier.Value)
	IniWriteVar(SettingsFileName, "Minigame", "UnstableLeftDivision", UnstableLeftDivision.Value)

	IniWriteVar(SettingsFileName, "Minigame", "RightAnkleBreakMultiplier", RightAnkleBreakMultiplier.Value)
	IniWriteVar(SettingsFileName, "Minigame", "LeftAnkleBreakMultiplier", LeftAnkleBreakMultiplier.Value)

	; briefly toggle AlwaysOnTop to refresh if needed
	MainGui.AlwaysOnTop := false
	MainGui.AlwaysOnTop := true
}

; Toggle Dark Mode
ToggleDarkMode() {
	global DarkMode, SettingsFileName
	DarkMode := !DarkMode
	; Persist to default config in ConfigDir
	IniWriteVar(ConfigDir "\\default.ini", "General", "DarkMode", DarkMode)
	; Also write to current SettingsFileName if set
	if (SettingsFileName != "")
		IniWriteVar(SettingsFileName, "General", "DarkMode", DarkMode)
	ApplyTheme()
}

; Apply theme based on DarkMode (idempotent)
ApplyTheme() {
	global DarkMode, MainGui, FontColor, BtnToggleDark, Tab
	if (DarkMode) {
		MainGui.Color := 0x1E1E1E
		FontColor := "FFFFFF"
		if IsObject(BtnToggleDark)
			BtnToggleDark.Text := "Light Mode"
		if IsObject(Tab)
			Tab.BackColor := 0x1E1E1E
	} else {
		MainGui.Color := 0xF5F5F5
		FontColor := "000000"
		if IsObject(BtnToggleDark)
			BtnToggleDark.Text := "Dark Mode"
		if IsObject(Tab)
			Tab.BackColor := 0xF5F5F5
	}
	SetEditFonts()
	try {
		DllCall("RedrawWindow", "Ptr", MainGui.Hwnd, "Ptr", 0, "Ptr", 0, "UInt", 0x1)
	} catch {
		; ignore redraw failures
	}
}

SetEditFonts() {
	global RestartDelay, HoldRodCastDuration, WaitForBobberDelay, BaitDelay, NavigationKey, ShakeFailsafe
	global ClickShakeColorTolerance, ClickScanDelay, NavigationSpamDelay, Control, FishBarColorTolerance
	global WhiteBarColorTolerance, ArrowColorTolerance, ScanDelay, SideBarRatio, SideDelay
	global StableRightMultiplier, StableRightDivision, StableLeftMultiplier, StableLeftDivision
	global UnstableRightMultiplier, UnstableRightDivision, UnstableLeftMultiplier, UnstableLeftDivision
	global RightAnkleBreakMultiplier, LeftAnkleBreakMultiplier, DropItem, ShakeMode, FontColor, DarkMode
	; Use appropriate text color based on theme
	global FontColor
	local fontSpec := "s10 c" FontColor " Segoe UI"
	; Use numeric color values for BackColor so controls render correctly
	local bgColor := DarkMode ? 0x1E1E1E : 0xF5F5F5
	RestartDelay.Font := fontSpec
	RestartDelay.BackColor := bgColor
	HoldRodCastDuration.Font := fontSpec
	HoldRodCastDuration.BackColor := bgColor
	WaitForBobberDelay.Font := fontSpec
	WaitForBobberDelay.BackColor := bgColor
	BaitDelay.Font := fontSpec
	BaitDelay.BackColor := bgColor
	NavigationKey.Font := fontSpec
	NavigationKey.BackColor := bgColor
	ShakeFailsafe.Font := fontSpec
	ShakeFailsafe.BackColor := bgColor
	ClickShakeColorTolerance.Font := fontSpec
	ClickShakeColorTolerance.BackColor := bgColor
	ClickScanDelay.Font := fontSpec
	ClickScanDelay.BackColor := bgColor
	NavigationSpamDelay.Font := fontSpec
	NavigationSpamDelay.BackColor := bgColor
	Control.Font := fontSpec
	Control.BackColor := bgColor
	FishBarColorTolerance.Font := fontSpec
	FishBarColorTolerance.BackColor := bgColor
	WhiteBarColorTolerance.Font := fontSpec
	WhiteBarColorTolerance.BackColor := bgColor
	ArrowColorTolerance.Font := fontSpec
	ArrowColorTolerance.BackColor := bgColor
	ScanDelay.Font := fontSpec
	ScanDelay.BackColor := bgColor
	SideBarRatio.Font := fontSpec
	SideBarRatio.BackColor := bgColor
	SideDelay.Font := fontSpec
	SideDelay.BackColor := bgColor
	StableRightMultiplier.Font := fontSpec
	StableRightMultiplier.BackColor := bgColor
	StableRightDivision.Font := fontSpec
	StableRightDivision.BackColor := bgColor
	StableLeftMultiplier.Font := fontSpec
	StableLeftMultiplier.BackColor := bgColor
	StableLeftDivision.Font := fontSpec
	StableLeftDivision.BackColor := bgColor
	UnstableRightMultiplier.Font := fontSpec
	UnstableRightMultiplier.BackColor := bgColor
	UnstableRightDivision.Font := fontSpec
	UnstableRightDivision.BackColor := bgColor
	UnstableLeftMultiplier.Font := fontSpec
	UnstableLeftMultiplier.BackColor := bgColor
	UnstableLeftDivision.Font := fontSpec
	UnstableLeftDivision.BackColor := bgColor
	RightAnkleBreakMultiplier.Font := fontSpec
	RightAnkleBreakMultiplier.BackColor := bgColor
	RestartDelay.Font := fontSpec
	RestartDelay.BackColor := bgColor
	HoldRodCastDuration.Font := fontSpec
	HoldRodCastDuration.BackColor := bgColor
	WaitForBobberDelay.Font := fontSpec
	WaitForBobberDelay.BackColor := bgColor
	BaitDelay.Font := fontSpec
	BaitDelay.BackColor := bgColor
	NavigationKey.Font := fontSpec
	NavigationKey.BackColor := bgColor
	ShakeFailsafe.Font := fontSpec
	ShakeFailsafe.BackColor := bgColor
	ClickShakeColorTolerance.Font := fontSpec
	ClickShakeColorTolerance.BackColor := bgColor
	ClickScanDelay.Font := fontSpec
	ClickScanDelay.BackColor := bgColor
	NavigationSpamDelay.Font := fontSpec
	NavigationSpamDelay.BackColor := bgColor
	Control.Font := fontSpec
	Control.BackColor := bgColor
	FishBarColorTolerance.Font := fontSpec
	FishBarColorTolerance.BackColor := bgColor
	WhiteBarColorTolerance.Font := fontSpec
	WhiteBarColorTolerance.BackColor := bgColor
	ArrowColorTolerance.Font := fontSpec
	ArrowColorTolerance.BackColor := bgColor
	ScanDelay.Font := fontSpec
	ScanDelay.BackColor := bgColor
	SideBarRatio.Font := fontSpec
	SideBarRatio.BackColor := bgColor
	SideDelay.Font := fontSpec
	SideDelay.BackColor := bgColor
	StableRightMultiplier.Font := fontSpec
	StableRightMultiplier.BackColor := bgColor
	StableRightDivision.Font := fontSpec
	StableRightDivision.BackColor := bgColor
	StableLeftMultiplier.Font := fontSpec
	StableLeftMultiplier.BackColor := bgColor
	StableLeftDivision.Font := fontSpec
	StableLeftDivision.BackColor := bgColor
	UnstableRightMultiplier.Font := fontSpec
	UnstableRightMultiplier.BackColor := bgColor
	UnstableRightDivision.Font := fontSpec
	UnstableRightDivision.BackColor := bgColor
	UnstableLeftMultiplier.Font := fontSpec
	UnstableLeftMultiplier.BackColor := bgColor
	UnstableLeftDivision.Font := fontSpec
	UnstableLeftDivision.BackColor := bgColor
	RightAnkleBreakMultiplier.Font := fontSpec
	RightAnkleBreakMultiplier.BackColor := bgColor
	LeftAnkleBreakMultiplier.Font := fontSpec
	LeftAnkleBreakMultiplier.BackColor := bgColor
	if IsSet(DropItem) && IsObject(DropItem) {
		DropItem.Font := fontSpec
		DropItem.BackColor := bgColor
	}
	if IsSet(ShakeMode) && IsObject(ShakeMode) {
		ShakeMode.Font := fontSpec
		ShakeMode.BackColor := bgColor
	}
	UnstableRightDivision.Value := ""
	UnstableLeftMultiplier.Value := ""
	UnstableLeftDivision.Value := ""
	
	RightAnkleBreakMultiplier.Value := ""
	LeftAnkleBreakMultiplier.Value := ""
	
	; keep config selection intact when clearing other settings
}

; Load settings
LoadSettings() {
	global DarkMode, SettingsFileName, AutoLowerGraphics, AutoZoomInCamera, AutoEnableCameraMode, AutoLookDownCamera, AutoBlurCamera
	global RestartDelay, HoldRodCastDuration, WaitForBobberDelay, BaitDelay, Sera, NavigationKey, ShakeMode, ShakeFailsafe
	global ClickShakeColorTolerance, ClickScanDelay, NavigationSpamDelay, Control, FishBarColorTolerance
	global WhiteBarColorTolerance, ArrowColorTolerance, ScanDelay, SideBarRatio, SideDelay
	global StableRightMultiplier, StableRightDivision, StableLeftMultiplier, StableLeftDivision
	global UnstableRightMultiplier, UnstableRightDivision, UnstableLeftMultiplier, UnstableLeftDivision
	global RightAnkleBreakMultiplier, LeftAnkleBreakMultiplier
	; read INI values and populate controls
	lAutoLowerGraphics := IniReadVar(SettingsFileName, "General", "AutoLowerGraphics", "")
	lAutoZoomInCamera := IniReadVar(SettingsFileName, "General", "AutoZoomInCamera", "")
	lAutoEnableCameraMode := IniReadVar(SettingsFileName, "General", "AutoEnableCameraMode", "")
	lAutoLookDownCamera := IniReadVar(SettingsFileName, "General", "AutoLookDownCamera", "")
	lAutoBlurCamera := IniReadVar(SettingsFileName, "General", "AutoBlurCamera", "")

	lRestartDelay := IniReadVar(SettingsFileName, "General", "RestartDelay", "")
	lHoldRodCastDuration := IniReadVar(SettingsFileName, "General", "HoldRodCastDuration", "")
	lWaitForBobberDelay := IniReadVar(SettingsFileName, "General", "WaitForBobberDelay", "")
	lBaitDelay := IniReadVar(SettingsFileName, "General", "BaitDelay", "")
	lSera := IniReadVar(SettingsFileName, "General", "Sera", "")

	lNavigationKey := IniReadVar(SettingsFileName, "Shake", "NavigationKey", "")
	lShakeMode := IniReadVar(SettingsFileName, "Shake", "ShakeMode", "")
	lShakeFailsafe := IniReadVar(SettingsFileName, "Shake", "ShakeFailsafe", "")

	lClickShakeColorTolerance := IniReadVar(SettingsFileName, "Shake", "ClickShakeColorTolerance", "")
	lClickScanDelay := IniReadVar(SettingsFileName, "Shake", "ClickScanDelay", "")
	lNavigationSpamDelay := IniReadVar(SettingsFileName, "Shake", "NavigationSpamDelay", "")

	lControl := IniReadVar(SettingsFileName, "Minigame", "Control", "")
	lFishBarColorTolerance := IniReadVar(SettingsFileName, "Minigame", "FishBarColorTolerance", "")
	lWhiteBarColorTolerance := IniReadVar(SettingsFileName, "Minigame", "WhiteBarColorTolerance", "")
	lArrowColorTolerance := IniReadVar(SettingsFileName, "Minigame", "ArrowColorTolerance", "")

	lScanDelay := IniReadVar(SettingsFileName, "Minigame", "ScanDelay", "")
	lSideBarRatio := IniReadVar(SettingsFileName, "Minigame", "SideBarRatio", "")
	lSideDelay := IniReadVar(SettingsFileName, "Minigame", "SideDelay", "")

	lStableRightMultiplier := IniReadVar(SettingsFileName, "Minigame", "StableRightMultiplier", "")
	lStableRightDivision := IniReadVar(SettingsFileName, "Minigame", "StableRightDivision", "")
	lStableLeftMultiplier := IniReadVar(SettingsFileName, "Minigame", "StableLeftMultiplier", "")
	lStableLeftDivision := IniReadVar(SettingsFileName, "Minigame", "StableLeftDivision", "")

	lUnstableRightMultiplier := IniReadVar(SettingsFileName, "Minigame", "UnstableRightMultiplier", "")
	lUnstableRightDivision := IniReadVar(SettingsFileName, "Minigame", "UnstableRightDivision", "")
	lUnstableLeftMultiplier := IniReadVar(SettingsFileName, "Minigame", "UnstableLeftMultiplier", "")
	lUnstableLeftDivision := IniReadVar(SettingsFileName, "Minigame", "UnstableLeftDivision", "")

	lRightAnkleBreakMultiplier := IniReadVar(SettingsFileName, "Minigame", "RightAnkleBreakMultiplier", "")
	lLeftAnkleBreakMultiplier := IniReadVar(SettingsFileName, "Minigame", "LeftAnkleBreakMultiplier", "")

	if FileExist(SettingsFileName) {
		; populate control objects
		AutoLowerGraphics.Value := lAutoLowerGraphics
		AutoZoomInCamera.Value := lAutoZoomInCamera
		AutoEnableCameraMode.Value := lAutoEnableCameraMode
		AutoLookDownCamera.Value := lAutoLookDownCamera
		AutoBlurCamera.Value := lAutoBlurCamera

		RestartDelay.Value := lRestartDelay
		HoldRodCastDuration.Value := lHoldRodCastDuration
		WaitForBobberDelay.Value := lWaitForBobberDelay
		BaitDelay.Value := lBaitDelay
		Sera.Value := lSera

		NavigationKey.Value := lNavigationKey
		; Convert ShakeMode from text to index (1=Click, 2=Navigation)
		if (lShakeMode = "Click")
			ShakeMode.Value := 1
		else if (lShakeMode = "Navigation") 
			ShakeMode.Value := 2
		else if (lShakeMode = "1")
			ShakeMode.Value := 1
		else if (lShakeMode = "2")
			ShakeMode.Value := 2
		else
			ShakeMode.Value := 1  ; Default to Click
		ShakeFailsafe.Value := lShakeFailsafe

		ClickShakeColorTolerance.Value := lClickShakeColorTolerance
		ClickScanDelay.Value := lClickScanDelay
		NavigationSpamDelay.Value := lNavigationSpamDelay

		Control.Value := lControl
		FishBarColorTolerance.Value := lFishBarColorTolerance
		WhiteBarColorTolerance.Value := lWhiteBarColorTolerance
		ArrowColorTolerance.Value := lArrowColorTolerance

		ScanDelay.Value := lScanDelay
		SideBarRatio.Value := lSideBarRatio
		SideDelay.Value := lSideDelay

		StableRightMultiplier.Value := lStableRightMultiplier
		StableRightDivision.Value := lStableRightDivision
		StableLeftMultiplier.Value := lStableLeftMultiplier
		StableLeftDivision.Value := lStableLeftDivision

		UnstableRightMultiplier.Value := lUnstableRightMultiplier
		UnstableRightDivision.Value := lUnstableRightDivision
		UnstableLeftMultiplier.Value := lUnstableLeftMultiplier
		UnstableLeftDivision.Value := lUnstableLeftDivision

		RightAnkleBreakMultiplier.Value := lRightAnkleBreakMultiplier
		LeftAnkleBreakMultiplier.Value := lLeftAnkleBreakMultiplier

		; read theme and apply if present
		lDarkMode := IniReadVar(SettingsFileName, "General", "DarkMode", "")
		newDarkMode := 0
		if (lDarkMode == "1")
			newDarkMode := 1
		if (newDarkMode != DarkMode) {
			DarkMode := newDarkMode
			IniWriteVar(ConfigDir "\\default.ini", "General", "DarkMode", DarkMode)
			ApplyTheme()  ; Apply theme immediately without reloading
		}

	MainGui.Font := "s10 c" FontColor " Segoe UI"
	MainGui.AlwaysOnTop := true
	} else {
		MainGui.AlwaysOnTop := true
	}
}

ExitScript() {
	ExitApp()
}

Launch() {
	global IsStarted
	IsStarted := true
	MainGui.AlwaysOnTop := false
	MainGui.Hide()
	lAutoLowerGraphics := IniReadVar(SettingsFileName, "General", "AutoLowerGraphics", "")
	lAutoZoomInCamera := IniReadVar(SettingsFileName, "General", "AutoZoomInCamera", "")
	lAutoEnableCameraMode := IniReadVar(SettingsFileName, "General", "AutoEnableCameraMode", "")
	lAutoLookDownCamera := IniReadVar(SettingsFileName, "General", "AutoLookDownCamera", "")
	lAutoBlurCamera := IniReadVar(SettingsFileName, "General", "AutoBlurCamera", "")
	lRestartDelay := IniReadVar(SettingsFileName, "General", "RestartDelay", "")
	lHoldRodCastDuration := IniReadVar(SettingsFileName, "General", "HoldRodCastDuration", "")
	lWaitForBobberDelay := IniReadVar(SettingsFileName, "General", "WaitForBobberDelay", "")
	lBaitDelay := IniReadVar(SettingsFileName, "General", "BaitDelay", "")
	lSera := IniReadVar(SettingsFileName, "General", "Sera", "")

	lNavigationKey := IniReadVar(SettingsFileName, "Shake", "NavigationKey", "")
	lShakeMode := IniReadVar(SettingsFileName, "Shake", "ShakeMode", "")
	; thanks @sai.kyo
	ShakeMode := lShakeMode
	lShakeFailsafe := IniReadVar(SettingsFileName, "Shake", "ShakeFailsafe", "")

	lClickShakeColorTolerance := IniReadVar(SettingsFileName, "Shake", "ClickShakeColorTolerance", "")
	lClickScanDelay := IniReadVar(SettingsFileName, "Shake", "ClickScanDelay", "")
	lNavigationSpamDelay := IniReadVar(SettingsFileName, "Shake", "NavigationSpamDelay", "")

	lControl := IniReadVar(SettingsFileName, "Minigame", "Control", "")
	lFishBarColorTolerance := IniReadVar(SettingsFileName, "Minigame", "FishBarColorTolerance", "")
	lWhiteBarColorTolerance := IniReadVar(SettingsFileName, "Minigame", "WhiteBarColorTolerance", "")
	lArrowColorTolerance := IniReadVar(SettingsFileName, "Minigame", "ArrowColorTolerance", "")

	lScanDelay := IniReadVar(SettingsFileName, "Minigame", "ScanDelay", "")
	lSideBarRatio := IniReadVar(SettingsFileName, "Minigame", "SideBarRatio", "")
	lSideDelay := IniReadVar(SettingsFileName, "Minigame", "SideDelay", "")

	lStableRightMultiplier := IniReadVar(SettingsFileName, "Minigame", "StableRightMultiplier", "")
	lStableRightDivision := IniReadVar(SettingsFileName, "Minigame", "StableRightDivision", "")
	lStableLeftMultiplier := IniReadVar(SettingsFileName, "Minigame", "StableLeftMultiplier", "")
	lStableLeftDivision := IniReadVar(SettingsFileName, "Minigame", "StableLeftDivision", "")

	lUnstableRightMultiplier := IniReadVar(SettingsFileName, "Minigame", "UnstableRightMultiplier", "")
	lUnstableRightDivision := IniReadVar(SettingsFileName, "Minigame", "UnstableRightDivision", "")
	lUnstableLeftMultiplier := IniReadVar(SettingsFileName, "Minigame", "UnstableLeftMultiplier", "")
	lUnstableLeftDivision := IniReadVar(SettingsFileName, "Minigame", "UnstableLeftDivision", "")
    
	lRightAnkleBreakMultiplier := IniReadVar(SettingsFileName, "Minigame", "RightAnkleBreakMultiplier", "")
	lLeftAnkleBreakMultiplier := IniReadVar(SettingsFileName, "Minigame", "LeftAnkleBreakMultiplier", "")
	
	; Validate ShakeMode before proceeding
	if (ShakeMode != "Navigation" and ShakeMode != "Click")
	{
		; Silent exit if shake mode invalid
		ExitApp()
	}
	
	if WinExist("Roblox")
		WinActivate("Roblox")
	if WinActive("ahk_exe RobloxPlayerBeta.exe") || WinActive("ahk_exe eurotruck2.exe")
	{
		; Resize Roblox to standard 1920x1080 resolution for proper macro functionality
		WinMove(0, 0, 1920, 1080, "Roblox")
		Sleep 500  ; Wait for window to resize
		WinActivate("Roblox")
	}
	else
	{
		; Show message if Roblox not found
		MsgBox("Roblox is not running. Please start Roblox first.", "Error", "Icon!")
		ExitApp()
	}
	
	if (A_ScreenDPI != 96) {
		; Silent exit when DPI not 96
		ExitApp()
	}
	
	Send("{lbutton up}")
	Send("{rbutton up}")
	Send("{shift up}")
}

;====================================================================================================;

Calculations() {
; AHK v2: replace WinGetActiveStats with explicit calls
Title := WinGetTitle("A")
WinGetPos &WindowLeft, &WindowTop, &WindowWidth, &WindowHeight, "A"

; Declare global variables that will be used outside this function
global TooltipX, Tooltip1, Tooltip2, Tooltip3, Tooltip4, Tooltip5, Tooltip6, Tooltip7, Tooltip8, Tooltip9, Tooltip10
global Tooltip11, Tooltip12, Tooltip13, Tooltip14, Tooltip15, Tooltip16, Tooltip17, Tooltip18, Tooltip19, Tooltip20
global CameraCheckLeft, CameraCheckRight, CameraCheckTop, CameraCheckBottom
global ClickShakeLeft, ClickShakeRight, ClickShakeTop, ClickShakeBottom
global FishBarLeft, FishBarRight, FishBarTop, FishBarBottom
global ProgressAreaLeft, ProgressAreaRight, ProgressAreaTop, ProgressAreaBottom
global LookDownX, LookDownY, PixelScaling, ResolutionScaling, FishBarTooltipHeight
global WhiteBarSize, Action, Direction, DistanceFactor
global HalfBarSize, Deadzone, Deadzone2, MaxLeftBar, MaxRightBar, EndMinigame, FishX

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

SplitPath(SettingsFileName, &FileNameNoExt)
; remove extension if present
FileNameNoExt := RegExReplace(FileNameNoExt, '\.[^\.]+$', '')
Tooltip('Made By AsphaltCake - this is remasterd version', TooltipX, Tooltip1)
Tooltip('Fisch Macro V12 - Config: ' . FileNameNoExt, TooltipX, Tooltip2)
Tooltip('Runtime: 0h 0m 0s', TooltipX, Tooltip3)

Tooltip('Press "P" to Start', TooltipX, Tooltip4)
Tooltip('Press "O" to Reload', TooltipX, Tooltip5)
Tooltip('Press "M" to Exit', TooltipX, Tooltip6)

if (AutoLowerGraphics)
	Tooltip("AutoLowerGraphics: true", TooltipX, Tooltip8)
else
	Tooltip("AutoLowerGraphics: false", TooltipX, Tooltip8)

if (AutoEnableCameraMode)
	Tooltip("AutoEnableCameraMode: true", TooltipX, Tooltip9)
else
	Tooltip("AutoEnableCameraMode: false", TooltipX, Tooltip9)

if (AutoZoomInCamera)
	Tooltip("AutoZoomInCamera: true", TooltipX, Tooltip10)
else
	Tooltip("AutoZoomInCamera: false", TooltipX, Tooltip10)

if (AutoLookDownCamera)
	Tooltip("AutoLookDownCamera: true", TooltipX, Tooltip11)
else
	Tooltip("AutoLookDownCamera: false", TooltipX, Tooltip11)

if (AutoBlurCamera)
	Tooltip("AutoBlurCamera: true", TooltipX, Tooltip12)
else
	Tooltip("AutoBlurCamera: false", TooltipX, Tooltip12)

Tooltip("Navigation Key: " . NavigationKey.Text, TooltipX, Tooltip14)

if (ShakeMode.Text == "Click")
	Tooltip('Shake Mode: "Click"', TooltipX, Tooltip16)
else
	Tooltip('Shake Mode: "Navigation"', TooltipX, Tooltip16)

}

;====================================================================================================;

StartCalculation()
{
	global f10counter, TooltipX, Tooltip8, Tooltip9
	Calculations()
	SetTimer(runtime, 1000)

	; --- Main macro actions ---
	f10counter := 0
	Send("{shift down}")
	Tooltip("Action: Hold Shift", TooltipX, Tooltip8)
	Sleep 50
	loop 20
	{
		f10counter++
		Tooltip("F10 Count: " . f10counter . "/20", TooltipX, Tooltip9)
		Send "{f10}"
		Tooltip("Action: Press F10", TooltipX, Tooltip8)
		Sleep 50
	}
	Send("{shift up}")
	Tooltip("Action: Release Shift", TooltipX, Tooltip8)
	Sleep 50

	Tooltip("Current Task: AutoZoomInCamera", TooltipX, Tooltip7)
	Tooltip("Scroll In: 0/20", TooltipX, Tooltip9)
	Tooltip("Scroll Out: 0/1", TooltipX, Tooltip10)
	scrollcounter := 0

	if (AutoZoomInCamera == true)
	{
		Sleep 50
		loop 20
		{
			scrollcounter++
			Tooltip("Scroll In: " . scrollcounter . "/20", TooltipX, Tooltip9)
			Send "{wheelup}"
			Tooltip("Action: Scroll In", TooltipX, Tooltip8)
			Sleep 50
		}
		Send("{wheeldown}")
		Tooltip("Scroll Out: 1/1", TooltipX, Tooltip10)
		Tooltip("Action: Scroll Out", TooltipX, Tooltip8)
		AutoZoomDelay := AutoZoomDelay*5
		Sleep 50
	}

	Tooltip("Current Task: AutoEnableCameraMode", TooltipX, Tooltip7)
	Tooltip("Right Count: 0/10", TooltipX, Tooltip9)
	rightcounter := 0
	if (AutoEnableCameraMode == true)
	{
		if !PixelSearch(&foundX, &foundY, CameraCheckLeft, CameraCheckTop, CameraCheckRight, CameraCheckBottom, 0xFFFFFF, 0)
		{
			Sleep 50
			if (NavigationFail == true)
			{
				Sleep 50
				Send "{" . NavigationKey . "}"
				Sleep 50
				Send "{2}"
				Sleep 50
				NavigationFail := false
			}
			Sleep 50
			Send "{2}"
			Tooltip("Action: Presss 2", TooltipX, Tooltip8)
			Sleep 50
			Send "{1}"
			Tooltip("Action: Press 1", TooltipX, Tooltip8)
			Sleep 50
			Send "{" . NavigationKey . "}"
			Tooltip("Action: Press " . NavigationKey, TooltipX, Tooltip8)
			Sleep 50
			loopCount := 10
			while (loopCount > 0)
			{
				rightcounter++
				Tooltip("Right Count: " . rightcounter . "/10", TooltipX, Tooltip9)
				Send "{right}"
				Tooltip("Action: Press Right", TooltipX, Tooltip8)
				Sleep 150
				loopCount--
			}
			Send "{enter}"
			Tooltip("Action: Press Enter", TooltipX, Tooltip8)
			Sleep 50
		}
	}

	Tooltip("Current Task: AutoLookDownCamera", TooltipX, Tooltip7)
	if (AutoLookDownCamera)
	{
		Send "{rbutton up}"
		Sleep 50
		MouseMove(LookDownX, LookDownY)
		Tooltip("Action: Position Mouse", TooltipX, Tooltip8)
		Sleep 50
		Send "{rbutton down}"
		Tooltip("Action: Hold Right Click", TooltipX, Tooltip8)
		Sleep 50
		DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", 10000)
		Tooltip("Action: Move Mouse Down", TooltipX, Tooltip8)
		Sleep 50
		Send "{rbutton up}"
		Tooltip("Action: Release Right Click", TooltipX, Tooltip8)
		Sleep 50
		MouseMove(LookDownX, LookDownY)
		Tooltip("Action: Position Mouse", TooltipX, Tooltip8)
		Sleep 50
	}

	Tooltip("Current Task: AutoBlurCamera", TooltipX, Tooltip7)
	if (AutoBlurCamera)
	{
		Sleep 50
		Send(Chr(96))
		Tooltip("Action: Press " . Chr(96), TooltipX, Tooltip8)
		Sleep 50
	}

	Tooltip("Current Task: Casting Rod", TooltipX, Tooltip7)
	Send "{lbutton down}"
	Tooltip("Action: Casting For " . HoldRodCastDuration . "ms", TooltipX, Tooltip8)
	Sleep HoldRodCastDuration
	Send "{lbutton up}"
	Tooltip("Action: Waiting For Bobber (" . WaitForBobberDelay . "ms)", TooltipX, Tooltip8)
	Sleep WaitForBobberDelay

	if (ShakeMode == "Click")
		ClickShakeMode()
	else if (ShakeMode == "Navigation")
		NavigationShakeMode()

}

runtime()
{
	global runtimeS, runtimeM, runtimeH, TooltipX, Tooltip3
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

	Tooltip("Runtime: " . runtimeH . "h " . runtimeM . "m " . runtimeS . "s", TooltipX, Tooltip3)

	if (WinExist("ahk_exe RobloxPlayerBeta.exe") || WinExist("ahk_exe eurotruck2.exe")) {
		if (!WinActive("ahk_exe RobloxPlayerBeta.exe") || !WinActive("ahk_exe eurotruck2.exe")) {
				WinActivate()
			}
	}
	else {
		ExitApp()
	}
}

ClickShakeFailsafe()
{
	ClickFailsafeCount++
	Tooltip("Failsafe: " . ClickFailsafeCount . "/" . ShakeFailsafe, TooltipX, Tooltip14)
	if (ClickFailsafeCount >= ShakeFailsafe)
	{
		SetTimer(ClickShakeFailsafe, 0)
		ForceReset := true
	}
}

ClickShakeMode()
{
	Tooltip("Current Task: Shaking", TooltipX, Tooltip7)
	Tooltip("Looking for White pixels", TooltipX, Tooltip8)
	Tooltip("Click X: None", TooltipX, Tooltip9)
	Tooltip("Click Y: None", TooltipX, Tooltip10)
	Tooltip("Click Count: 0", TooltipX, Tooltip11)

	Tooltip("Failsafe: 0/" . ShakeFailsafe, TooltipX, Tooltip14)

	ClickFailsafeCount := 0
	ClickCount := 0
	ClickShakeRepeatBypassCounter := 0
	MemoryX := 0
	MemoryY := 0
	ForceReset := false

	SetTimer(ClickShakeFailsafe, 1000)

	while (true)
	{
		if (ForceReset)
		{
			Tooltip()
			Tooltip()
			Tooltip()
			RestartMacro()
			return
		}

		Sleep ClickScanDelay

		if !PixelSearch(&foundX, &foundY, FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, FishBarColorTolerance)
		{
			SetTimer(ClickShakeFailsafe, 0)
			Tooltip()
			Tooltip()
			Tooltip()
			Tooltip()
			BarMinigame()
			return
		}
		else
		{
			if !PixelSearch(&ClickX, &ClickY, ClickShakeLeft, ClickShakeTop, ClickShakeRight, ClickShakeBottom, 0xFFFFFF, ClickShakeColorTolerance)
			{
				Tooltip("Click X: " . ClickX, TooltipX, Tooltip9)
				Tooltip("Click Y: " . ClickY, TooltipX, Tooltip10)

				if (ClickX != MemoryX && ClickY != MemoryY)
				{
					ClickShakeRepeatBypassCounter := 0
					ClickCount++
					Click ClickX, ClickY
					Tooltip("Click Count: " . ClickCount, TooltipX, Tooltip11)
					MemoryX := ClickX
					MemoryY := ClickY
					continue
				}
				else
				{
					ClickShakeRepeatBypassCounter++
					if (ClickShakeRepeatBypassCounter >= 10)
					{
						MemoryX := 0
						MemoryY := 0
					}
					continue
				}
			}
			else
			{
				continue
			}
		}
	}
}

;====================================================================================================;

NavigationShakeFailsafe()
{
	NavigationFailsafeCount++
	Tooltip("Failsafe: " . NavigationFailsafeCount . "/" . ShakeFailsafe, TooltipX, Tooltip10)
	if (NavigationFailsafeCount >= ShakeFailsafe)
	{
		SetTimer(NavigationShakeFailsafe, 0)
		ForceReset := true
	}
}

NavigationShakeMode()
{
	Tooltip("Current Task: Shaking", TooltipX, Tooltip7)
	Tooltip("Attempt Count: 0", TooltipX, Tooltip8)
	Tooltip("Failsafe: 0/" . ShakeFailsafe, TooltipX, Tooltip10)

	NavigationFailsafeCount := 0
	NavigationCounter := 0
	ForceReset := false
	SetTimer(NavigationShakeFailsafe, 1000)
	Send "{" . NavigationKey . "}"

	while (true)
	{
		if (ForceReset)
		{
			Tooltip()
			NavigationFail := true
			RestartMacro()
			return
		}

		Sleep NavigationSpamDelay

		if !PixelSearch(&foundX, &foundY, FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, FishBarColorTolerance)
		{
			SetTimer(NavigationShakeFailsafe, 0)
			BarMinigame()
			return
		}
		else
		{
			NavigationCounter++
			Tooltip("Attempt Count: " . NavigationCounter, TooltipX, Tooltip8)
			Sleep 1
			Send "{s}"
			Sleep 1
			Send "{enter}"
			; continue looping
		}
	}
}

;=========== BAR ====================================================================================================;

BarMinigame()
{
	Sleep BaitDelay
	if (Sera == true)
	{
		Tooltip("Current Task: Stablizing Seraphic", TooltipX, Tooltip7)
		Tooltip()
		loop 25
		{
			Send "{lbutton down}"
			Sleep 50
			Send "{lbutton up}"
			sleep 30
		}
		Send("{lbutton down}")
		Sleep 800
		Send("{lbutton up}")
	}
	
	; Thanks Lunar ==================
	if (Control == 0) {
		Control := 0.001
	}
	global WhiteBarSize
	WhiteBarSize := Round((A_ScreenWidth / 247.03) * (InStr(Control, "0.") ? (Control * 100) : Control) + (A_ScreenWidth / 8.2759), 0)
	sleep 50
	BarMinigameSingle()
}


;====================================================================================================;

BarMinigameSingle()
{
	global Action, Direction, DistanceFactor, HalfBarSize, Deadzone, Deadzone2, MaxLeftBar, MaxRightBar, EndMinigame, FishX
	Action := 0
	Direction := 0
	DistanceFactor := 0
	FishX := 0
	EndMinigame := false
	Tooltip("Current Task: Playing Bar Minigame", TooltipX, Tooltip7)
	Tooltip("Bar Size: " . WhiteBarSize, TooltipX, Tooltip8)
	Tooltip("Looking for Bar", TooltipX, Tooltip10)
	HalfBarSize := WhiteBarSize/2
	Deadzone := WhiteBarSize*0.1
	Deadzone2 := HalfBarSize*0.75

	MaxLeftBar := FishBarLeft+(WhiteBarSize*SideBarRatio)
	MaxRightBar := FishBarRight-(WhiteBarSize*SideBarRatio)
	SetTimer(BarMinigame2, ScanDelay)

	while (true)
	{
		if (EndMinigame)
		{
			Sleep RestartDelay
			RestartMacro()
			return
		}

		if (Action == 0)
		{
			SideToggle := false
			Send "{lbutton down}"
			Sleep 10
			Send "{lbutton up}"
			Sleep 10
		}
		else if (Action == 1)
		{
			SideToggle := false
			Send "{lbutton up}"
			if (AnkleBreak == false)
			{
				Sleep AnkleBreakDuration
				AnkleBreakDuration := 0
			}
			AdaptiveDuration := 0.5 + 0.5 * (DistanceFactor ** 1.2)
			if (DistanceFactor < 0.2)
				AdaptiveDuration := 0.15 + 0.15 * DistanceFactor
			Duration := Abs(Direction) * StableLeftMultiplier * PixelScaling * AdaptiveDuration
			Sleep Duration
			Send "{lbutton down}"
			CounterStrafe := Duration/StableLeftDivision
			Sleep CounterStrafe
			AnkleBreak := true
			AnkleBreakDuration += (Duration-CounterStrafe)*LeftAnkleBreakMultiplier
		}
		else if (Action == 2)
		{
			SideToggle := false
			Send "{lbutton down}"
			if (AnkleBreak == true)
			{
				Sleep AnkleBreakDuration
				AnkleBreakDuration := 0
			}
			AdaptiveDuration := 0.5 + 0.5 * (DistanceFactor ** 1.2)
			if (DistanceFactor < 0.2)
				AdaptiveDuration := 0.15 + 0.15 * DistanceFactor
			Duration := Abs(Direction) * StableRightMultiplier * PixelScaling * AdaptiveDuration
			Sleep Duration
			Send "{lbutton up}"
			CounterStrafe := Duration/StableRightDivision
			Sleep CounterStrafe
			AnkleBreak := false
			AnkleBreakDuration += (Duration-CounterStrafe)*RightAnkleBreakMultiplier
		}
		else if (Action == 3)
		{
			if (SideToggle == false)
			{
				AnkleBreak := "none"
				AnkleBreakDuration := 0
				SideToggle := true
				Send "{lbutton up}"
				Sleep SideDelay
			}
			Sleep ScanDelay
		}
		else if (Action == 4)
		{
			if (SideToggle == false)
			{
				AnkleBreak := "none"
				AnkleBreakDuration := 0
				SideToggle := true
				Send "{lbutton down}"
				Sleep SideDelay
			}
			Sleep ScanDelay
		}
		else if (Action == 5)
		{
			SideToggle := false
			Send "{lbutton up}"
			if (AnkleBreak == false)
			{
				Sleep AnkleBreakDuration
				AnkleBreakDuration := 0
			}
			MinDuration := 10
			if (Control == 0.15 || Control > 0.15)
				MaxDuration := WhiteBarSize*0.88
			else if (Control == 0.2 || Control > 0.2)
				MaxDuration := WhiteBarSize*0.8
			else if (Control == 0.25 || Control > 0.25)
				MaxDuration := WhiteBarSize*0.75
			else
				MaxDuration := WhiteBarSize + (Abs(Direction) * 0.2)
			Duration := Max(MinDuration, Min(Abs(Direction) * UnstableLeftMultiplier * PixelScaling, MaxDuration))
			Sleep Duration
			Send "{lbutton down}"
			CounterStrafe := Duration/UnstableLeftDivision
			Sleep CounterStrafe
			AnkleBreak := true
			AnkleBreakDuration += (Duration-CounterStrafe)*LeftAnkleBreakMultiplier
		}
		else if (Action == 6)
		{
			SideToggle := false
			Send "{lbutton down}"
			if (AnkleBreak == true)
			{
				Sleep AnkleBreakDuration
				AnkleBreakDuration := 0
			}
			MinDuration := 10
			if (Control == 0.15 || Control > 0.15)
				MaxDuration := WhiteBarSize*0.88
			else if (Control == 0.2 || Control > 0.2)
				MaxDuration := WhiteBarSize*0.8
			else if (Control == 0.25 || Control > 0.25)
				MaxDuration := WhiteBarSize*0.75
			else
				MaxDuration := WhiteBarSize + (Abs(Direction) * 0.2)
			Duration := Max(MinDuration, Min(Abs(Direction) * UnstableRightMultiplier * PixelScaling, MaxDuration))
			Sleep Duration
			Send "{lbutton up}"
			CounterStrafe := Duration/UnstableRightDivision
			Sleep CounterStrafe
			AnkleBreak := false
			AnkleBreakDuration += (Duration-CounterStrafe)*RightAnkleBreakMultiplier
		}
		else
		{
			Sleep ScanDelay
		}
		; loop back
		continue
		}
	}

; BarMinigame2: timer-driven scanning function
BarMinigame2()
{
	global Action, Direction, DistanceFactor, HalfBarSize, Deadzone, Deadzone2, MaxLeftBar, MaxRightBar, FishX
	
	; Search for the fish position (assuming fish is represented by a specific color)
	if !PixelSearch(&FishX, &FishY, FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x5B4B43, FishBarColorTolerance)
	{
		; If fish not found, default to center
		FishX := (FishBarLeft + FishBarRight) / 2
	}
	
	Tooltip("+", FishX, FishBarTooltipHeight)
	if (FishX < MaxLeftBar)
	{
		Action := 3
		Tooltip("|", MaxLeftBar, FishBarTooltipHeight)
		Tooltip("Direction: Max Left", TooltipX, Tooltip10)
		if !PixelSearch(&ArrowX, &ArrowY, FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x878584, ArrowColorTolerance)
		{
			Tooltip("<-", ArrowX, FishBarTooltipHeight)
			if (MaxLeftBar < ArrowX)
				SideToggle := false
		}
		return
	}
	else if (FishX > MaxRightBar)
	{
		Action := 4
		Tooltip("|", MaxRightBar, FishBarTooltipHeight)
		Tooltip("Direction: Max Right", TooltipX, Tooltip10)
		if !PixelSearch(&ArrowX, &ArrowY, FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x878584, ArrowColorTolerance)
		{
			Tooltip("->", ArrowX, FishBarTooltipHeight)
			if (MaxRightBar > ArrowX)
				SideToggle := false
		}
		return
	}

	if !PixelSearch(&BarX, &BarY, FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0xFFFFFF, WhiteBarColorTolerance)
	{
		Tooltip()
		BarX := BarX + HalfBarSize
		Direction := BarX - FishX
		DistanceFactor := Abs(Direction) / HalfBarSize

		Ratio2 := Deadzone2/WhiteBarSize
		if (Direction > Deadzone && Direction < Deadzone2)
		{
			Action := 1
			Tooltip("Tracking direction: <", TooltipX, Tooltip10)
			Tooltip("<", BarX, FishBarTooltipHeight)
		}
		else if (Direction < -Deadzone && Direction > -Deadzone2)
		{
			Action := 2
			Tooltip("Tracking direction: >", TooltipX, Tooltip10)
			Tooltip(">", BarX, FishBarTooltipHeight)
		}
		else if (Direction > Deadzone2)
		{
			Action := 5
			Tooltip("Tracking direction: <<<", TooltipX, Tooltip10)
			Tooltip("<", BarX, FishBarTooltipHeight)
		}
		else if (Direction < -Deadzone2)
		{
			Action := 6
			Tooltip("Tracking direction: >>>", TooltipX, Tooltip10)
			Tooltip(">", BarX, FishBarTooltipHeight)
		}
		else
		{
			Action := 0
			Tooltip("Stabilizing", TooltipX, Tooltip10)
			Tooltip(".", BarX, FishBarTooltipHeight)
		}
	}
	else
	{
		Direction := HalfBarSize
		if !PixelSearch(&ArrowX, &ArrowY, FishBarLeft, FishBarTop, FishBarRight, FishBarBottom, 0x878584, ArrowColorTolerance)
			ArrowX := ArrowX - FishX
		if (ArrowX > 0)
		{
			Action := 5
			BarX := FishX+HalfBarSize
			Tooltip("Tracking direction: <<<", TooltipX, Tooltip10)
			Tooltip("<", BarX, FishBarTooltipHeight)
		}
		else
		{
			Action := 6
			BarX := FishX-HalfBarSize
			Tooltip("Tracking direction: >>>", TooltipX, Tooltip10)
			Tooltip(">", BarX, FishBarTooltipHeight)
		}
	}

	Tooltip()
	EndMinigame := true
	SetTimer(BarMinigame2, 0)
}

RestartMacro()
{
	global EndMinigame
	sleep 100
	if (AutoBlurCamera == true)
	{
		if (EndMinigame == true or NavigationFail == true)
		{
			Send(Chr(96))
		}
	}
	Tooltip()

	Tooltip("Current Task: AutoEnableCameraMode", TooltipX, Tooltip7)
	Tooltip("Right Count: 0/10", TooltipX, Tooltip9)
	rightcounter := 0
	if (AutoEnableCameraMode == true)
	{
		if !PixelSearch(&foundX, &foundY, CameraCheckLeft, CameraCheckTop, CameraCheckRight, CameraCheckBottom, 0xFFFFFF, 0)
		{
			sleep 50
			if (NavigationFail == true)
			{
				Sleep 50
				Send "{" . NavigationKey . "}"
				Sleep 50
				Send "{2}"
				Sleep 50
				NavigationFail := false
			}
			Sleep 50
			Send "{2}"
			Tooltip("Action: Presss 2", TooltipX, Tooltip8)
			Sleep 50
			Send "{1}"
			Tooltip("Action: Press 1", TooltipX, Tooltip8)
			Sleep 50
			Send "{" . NavigationKey . "}"
			Tooltip("Action: Press " . NavigationKey, TooltipX, Tooltip8)
			Sleep 50
			loopCount := 10
			while (loopCount > 0)
			{
				rightcounter++
				Tooltip("Right Count: " . rightcounter . "/10", TooltipX, Tooltip9)
				Send "{right}"
				Tooltip("Action: Press Right", TooltipX, Tooltip8)
				Sleep 150
				loopCount--
			}
			Send "{enter}"
			Tooltip("Action: Press Enter", TooltipX, Tooltip8)
			Sleep 50
		}
	}

	Tooltip()
	Tooltip("Current Task: AutoLookDownCamera", TooltipX, Tooltip7)
	if (AutoLookDownCamera)
	{
		Send "{rbutton up}"
		Sleep 50
		MouseMove(LookDownX, LookDownY)
		Tooltip("Action: Position Mouse", TooltipX, Tooltip8)
		Sleep 50
		Send "{rbutton down}"
		Tooltip("Action: Hold Right Click", TooltipX, Tooltip8)
		Sleep 50
		DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", 10000)
		Tooltip("Action: Move Mouse Down", TooltipX, Tooltip8)
		Sleep 50
		Send "{rbutton up}"
		Tooltip("Action: Release Right Click", TooltipX, Tooltip8)
		Sleep 50
		MouseMove(LookDownX, LookDownY)
		Tooltip("Action: Position Mouse", TooltipX, Tooltip8)
		Sleep 50
	}

	Tooltip("Current Task: AutoBlurCamera", TooltipX, Tooltip7)
	if (AutoBlurCamera)
	{
		Sleep 50
		Send(Chr(96))
		Tooltip("Action: Press " . Chr(96), TooltipX, Tooltip8)
		Sleep 50
	}

	Tooltip("Current Task: Casting Rod", TooltipX, Tooltip7)
	Send "{lbutton down}"
	Tooltip("Action: Casting For " . HoldRodCastDuration . "ms", TooltipX, Tooltip8)
	Sleep HoldRodCastDuration
	Send "{lbutton up}"
	Tooltip("Action: Waiting For Bobber (" . WaitForBobberDelay . "ms)", TooltipX, Tooltip8)
	Sleep WaitForBobberDelay

	if (ShakeMode == "Click")
		ClickShakeMode()
	else if (ShakeMode == "Navigation")
		NavigationShakeMode()
}

EditChangeDispatcher(ctrl, eventInfo) {
	; ctrl is the control object that raised the event
	try {
		name := ctrl.Name
	} catch {
		name := ""
	}
	; Map controls to sanitizer choice. Use object identity where possible.
	if (IsObject(ctrl)) {
		; numeric integer-only controls
		intControls := [RestartDelay, HoldRodCastDuration, WaitForBobberDelay, BaitDelay
			, ShakeFailsafe, ClickShakeColorTolerance, ClickScanDelay, NavigationSpamDelay
			, Control, FishBarColorTolerance, WhiteBarColorTolerance, ArrowColorTolerance
			, ScanDelay, SideDelay]
		for each, c in intControls {
			if (c == ctrl) {
				SanitizeInt(ctrl)
				return
			}
		}
		; float controls
		floatControls := [SideBarRatio, StableRightMultiplier, StableRightDivision
			, StableLeftMultiplier, StableLeftDivision, UnstableRightMultiplier
			, UnstableRightDivision, UnstableLeftMultiplier, UnstableLeftDivision
			, RightAnkleBreakMultiplier, LeftAnkleBreakMultiplier]
		for each, c in floatControls {
			if (c == ctrl) {
				SanitizeFloat(ctrl)
				return
			}
		}
	}
}

; Clear settings back to defaults (keeps config selection intact)
ClearSettings() {
	global AutoLowerGraphics, AutoZoomInCamera, AutoEnableCameraMode, AutoLookDownCamera, AutoBlurCamera
	global RestartDelay, HoldRodCastDuration, WaitForBobberDelay, BaitDelay, Sera, NavigationKey, ShakeMode, ShakeFailsafe
	global ClickShakeColorTolerance, ClickScanDelay, NavigationSpamDelay, Control, FishBarColorTolerance
	global WhiteBarColorTolerance, ArrowColorTolerance, ScanDelay, SideBarRatio, SideDelay
	global StableRightMultiplier, StableRightDivision, StableLeftMultiplier, StableLeftDivision
	global UnstableRightMultiplier, UnstableRightDivision, UnstableLeftMultiplier, UnstableLeftDivision
	global RightAnkleBreakMultiplier, LeftAnkleBreakMultiplier

	; Uncheck feature checkboxes
	try {
		AutoLowerGraphics.Value := 0
		AutoZoomInCamera.Value := 0
		AutoEnableCameraMode.Value := 0
		AutoLookDownCamera.Value := 0
		AutoBlurCamera.Value := 0
	} catch {
		; ignore missing controls
	}

	; General defaults
	RestartDelay.Value := "1500"
	HoldRodCastDuration.Value := "600"
	WaitForBobberDelay.Value := "1000"
	BaitDelay.Value := "300"
	Sera.Value := 0

	; Shake defaults
	NavigationKey.Value := '\'
	ShakeMode.Value := 1
	ShakeFailsafe.Value := "20"
	ClickShakeColorTolerance.Value := "3"
	ClickScanDelay.Value := "10"
	NavigationSpamDelay.Value := "10"

	; Minigame defaults
	Control.Value := "0"
	FishBarColorTolerance.Value := "5"
	WhiteBarColorTolerance.Value := "15"
	ArrowColorTolerance.Value := "6"
	ScanDelay.Value := "10"
	SideBarRatio.Value := "0.7"
	SideDelay.Value := "400"

	StableRightMultiplier.Value := "2.36"
	StableRightDivision.Value := "1.55"
	StableLeftMultiplier.Value := "1.211"
	StableLeftDivision.Value := "1.12"

	UnstableRightMultiplier.Value := "2.665"
	UnstableRightDivision.Value := "1.5"
	UnstableLeftMultiplier.Value := "2.19"
	UnstableLeftDivision.Value := "1"

	RightAnkleBreakMultiplier.Value := "0.75"
	LeftAnkleBreakMultiplier.Value := "0.45"

	SetEditFonts()
	MsgBox("Settings cleared to defaults.", "Info", 0x40000)
}