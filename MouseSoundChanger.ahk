#SingleInstance Force
#NoEnv

title := "MouseSoundChanger by itstd"
configPath = %A_AppData%\MouseSoundChangerConfig.ini
linkPath = %A_Startup%\MouseSoundChanger.lnk

isInStartup := 0
tipOnStart := 0
runAsAdmin := 0

Menu, Tray, NoStandard

IfExist, %linkPath%
{
    isInStartup := 1
}

IniRead, tipOnStart, % configPath, set, tipOnStart, 1
IniRead, runAsAdmin, % configPath, set, runAsAdmin, 0

Menu, Settings, Add, Add to startup, addToStartup
Menu, Settings, Add, Show tip on startup, showTipOnStartup
Menu, Settings, Add, Run as administrator, runAsAdmin
Menu, Settings, Add,
Menu, Settings, Add, Reset settings, reset

if (tipOnStart)
    Menu, Settings, Check, Show tip on startup

if (runAsAdmin)
    Menu, Settings, Check, Run as administrator

if (runAsAdmin && !A_IsAdmin) {
    Run, *RunAs "%A_ScriptFullPath%",, UseErrorLevel
    exitapp
    return
}

if (isInStartup)
    Menu, Settings, Check, Add to startup

if (tipOnStart)
    TrayTip, % title, Working, 3

Menu, Tray, Add, Developer's GitHub, dev
Menu, Tray, Add,
Menu, Tray, Add, Settings, :Settings
Menu, Tray, Add, 
Menu, Tray, Add, Close, exitapp
Menu, Tray, Default, Settings
return

addToStartup:
if (isInStartup) {
    FileDelete, % linkPath
    Menu, Settings, Uncheck, Add to startup
    isInStartup := 0
} else {
    FileCreateShortcut, % A_ScriptFullPath, % linkPath
    Menu, Settings, Check, Add to startup
    isInStartup := 1
}
return

showTipOnStartup:
if (tipOnStart) {
    IniWrite, 0, % configPath, set, tipOnStart
    Menu, Settings, Uncheck, Show tip on startup
    tipOnStart := 0
} else {
    IniWrite, 1, % configPath, set, tipOnStart
    Menu, Settings, Check, Show tip on startup
    tipOnStart := 1
}
return

runAsAdmin:
if (runAsAdmin) {
    IniWrite, 0, % configPath, set, runAsAdmin
    Menu, Settings, Uncheck, Run as administrator
    runAsAdmin := 0
} else {
    IniWrite, 1, % configPath, set, runAsAdmin
    Menu, Settings, Check, Run as administrator
    runAsAdmin := 1
}
return

reset:
FileDelete, % configPath
FileDelete, % linkPath
reload

useTooltip = 0
isInStartup = 0
runAsAdmin = 0
return

dev:
Run, http://github.com/streleckiy
return

exitapp:
exitapp
return

XButton1::
settimer, nextTooltip, 1
Send, {Media_Next}
return

XButton2::
settimer, prevTooltip, 1
Send, {Media_Prev}
return

nextTooltip:
settimer, nextTooltip, off
Tooltip, Next >>
sleep 1000
Tooltip
return

prevTooltip:
settimer, prevTooltip, off
Tooltip, << Prev
sleep 1000
Tooltip
return