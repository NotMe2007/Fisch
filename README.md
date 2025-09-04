# Fisch

Lightweight Roblox fishing macro (AutoHotkey v2) — remastered UI and config support. (Please note it's still AHK V1) V13 will be ahk v2 also a lot of improvements will be made so don't be mad.

## Overview

This repository contains an AutoHotkey v2 script that provides a GUI-driven macro for Roblox fishing. The UI was updated to use a non-searchable configs dropdown, silent load/save behavior (no MsgBox popups), and an improved Dark Mode that applies instantly without restarting the script.

## Key Features

- Non-searchable configs dropdown: pick one of the .ini files from the `Configs/` folder to load or save settings.
- Config-per-file design: each configuration is a separate .ini under `Configs/`.
- Dark Mode: applies immediately without reloading the GUI and uses readable fonts for inputs and dropdowns.
- Silent operation: modal popups (MsgBox) were removed; loads/saves happen quietly to avoid interruptions.
- Shake Mode: selectable DropDownList with consistent look-and-feel.
- Minigame bar tracking and adjustable thresholds/multipliers.
- Launcher (`start.bat`) checks for AutoHotkey and will attempt to run a bundled installer (`AutoHotkey_2.0.19_setup.exe`) if AHK is not found.

## Installation

1. Ensure AutoHotkey v2 is installed. If not, place `AutoHotkey_2.0.19_setup.exe` next to `start.bat` and run `start.bat` — the batch will run the installer if no AutoHotkey is detected.
2. Run `start.bat` to start the macro. The batch file looks for AutoHotkey in common Program Files locations and will launch the script using the detected executable.

## Usage

- Open the GUI (it shows a window titled `Fisch macro <version>` where `<version>` is controlled by the `AppVersion` variable at the top of `V12 - Feb 8th.ahk`).
- Select a configuration from the Configs dropdown. The dropdown lists every `.ini` in the `Configs/` folder (no search box — pick from the list).
- Click `Load settings` to apply the selected config (this action is silent).
- Modify GUI values and click `Save settings` to write the changes to the selected `.ini` in `Configs/`.
- Use `Start Macro` to hide the GUI and run the macro; `Exit` closes the script.
- Toggle Dark Mode with the `Dark Mode` button; the theme is applied immediately.

## Configs

- All configuration files are stored in the `Configs/` directory, one file per configuration (e.g., `Configs\volcanic.ini`).
- If you add a new `.ini` to `Configs/`, restart the script to populate the dropdown (or re-open the GUI if you prefer).
- Config files contain sections like `[General]`, `[Shake]`, and `[Minigame]` and are read/written by the script.

## Where to change the Version string

Open `V12 - Feb 8th.ahk` and find the `AppVersion := "..."` line near the top of the file. Editing that value updates the GUI title shown to users.

## Notes & Behavior

- The configs dropdown is intentionally non-searchable to make selection explicit.
- The GUI will not reload when loading a config; theme and fonts are applied dynamically.
- Popups (MsgBox) were removed for a quieter experience. Critical failures may exit the script silently.
- The script expects Roblox Player to be available when starting the macro; if it cannot find Roblox, it may exit.

## Troubleshooting

- If `start.bat` cannot find AutoHotkey and no installer is present, the batch prints a message and pauses; install AutoHotkey v2 manually or place the installer next to the batch.
- If configs don't appear in the dropdown, ensure the `.ini` files are placed directly in `Configs/` and that filenames end with `.ini`.
- For consistent GUI scaling, use 100% display scaling in Windows.

## Want more?

If you want sample `.ini` templates, tuning tips for the minigame settings, or a small section describing each GUI control, tell me which you'd like and I'll add it to the README.
