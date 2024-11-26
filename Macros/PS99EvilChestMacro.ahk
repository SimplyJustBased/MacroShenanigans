; /[V1.0.55]\ (Used for auto-update)
#Requires AutoHotkey v2.0
#Include "%A_MyDocuments%\MacroHubFiles\Modules\BasePositionsPS99.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctions.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctionsPS99.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\EasyUI.ahk"

global Version := "V1.0.5"
global MacroEnabled := false
global CheckPixel := false

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
CoordMode "ToolTip", "Window"
SetMouseDelay -1

global userRoutes := Map(
    "sw_SpawnToEvent", "tp:Green Forest|w_nV:TpWaitTime|tp:Spawn|w_nV:TpWaitTime|r:[0%Q10&10%W230&240%D1900]",
    "tw_SpawnToEvent", "tp:Mushroom Lab|w_nV:TpWaitTime|tp:Tech Spawn|w_nV:TpWaitTime|r:[0%Q10&10%D1900]",
    "vw_SpawnToEvent", "tp:Prison Tower|w_nV:TpWaitTime|w:3|w_nV:TpWaitTime|r:[0%Q10&20%A500&590%S1600]",
    "rToChest", "spl:TpButton|wt:1000|sc:[115,223]|spl:X|wt:500|sc:[674,390]|w_nV:TpWaitTime|r:[0%Q10&20%W950&980%D1200&3000%Q10]"
)

global NumberValueMap := Map(
    "TpWaitTime", 7000,
    "BreakTime", 600000,
    "World", 1
)

global ToggleValuesMap := Map(
    "BasicLeaderboardSwitch", false
)

JoinNewServer() {
    ControlClickWorks := true

    if WinExist("ahk_exe RobloxPlayerBeta.exe") {
        loop {
            WinClose("ahk_exe RobloxPlayerBeta.exe")
            Sleep(100)
        } until not WinExist("ahk_exe RobloxPlayerBeta.exe")
    }

    loop {
        for Id in WinGetList("","","Program Manager") {
            this_class := WinGetClass(Id)
            this_title := WinGetTitle(Id)
    
            if InStr(this_title, "account") and InStr(this_title, "manager") {
                OutputDebug("A")
                WinActivate Id
                Sleep(500)

                for Number, ControlName in WinGetControls(Id) {
                    if InStr(ControlGetText(ControlName, Id), "Join") and InStr(ControlGetText(ControlName, Id), "Server") {
                        ControlClick(ControlName, Id)
                        break
                    }
                }
            }
        }
    } until WinActive("ahk_exe Roblox Account Manager.exe")

    lastAttemptTime := A_TickCount
    loop {
        if (A_TickCount - lastAttemptTime) >= 60000 {
            if not WinActive("ahk_exe Roblox Account Manager.exe") and not WinExist("ahk_exe RobloxPlayerBeta.exe") {
                loop {
                    for Id in WinGetList("","","Program Manager") {
                        this_class := WinGetClass(Id)
                        this_title := WinGetTitle(Id)
                
                        if InStr(this_title, "account") and InStr(this_title, "manager") {
                            OutputDebug("A")
                            WinActivate Id
                            Sleep(500)

                            for Number, ControlName in WinGetControls(Id) {
                                if InStr(ControlGetText(ControlName, Id), "Join") and InStr(ControlGetText(ControlName, Id), "Server") {
                                    ControlClick(ControlName, Id)
                                    break
                                }
                            }
                        }
                    }
                } until WinActive("ahk_exe Roblox Account Manager.exe")
            }

            lastAttemptTime := A_TickCount
        }

        Sleep(100)
    } until WinExist("ahk_exe RobloxPlayerBeta.exe")

    SetPixelSearchLoop("TpButton", 40000, 1,,,,200)
}

DestroyChest() {
    global CheckPixel
    
    TimeSinceNotFound := A_TickCount
    TimeSinceRan := A_TickCount

    loop {
        if (A_TickCount - TimeSinceNotFound) >= 10000 {
            OutputDebug("`nFinished")
            break
        }

        if (A_TickCount - TimeSinceRan) >= NumberValueMap["BreakTime"] {
            break
        }

        ; SendEvent "{Click, 687, 265, 1}"
        if not CheckPixel {
            SendEvent "{Click, 687, 265, 1}"
        }
        Sleep(100)

        Pos1 := 0
        Pos2 := 0
        SearchColorArray := [{c:0x483A29, v:10},{c:0xFFE76B, v:5},{c:0xEB6F10, v:5},{c:0xFFFFFF, v:5}]
    
        if PixelSearch(&u, &u2, 800, 36, 400, 330, 0xDAF9FE, 4) {
            Pos1 := u
            Pos2 := u2
        }
    
        if (Pos1 + Pos2) >= 1 {

            if CheckPixel {
                SendEvent "{Click, " Pos1 ", " Pos2 ", 1}"
            }

            PosTable := [Pos1 - 50, Pos2 - 50, Pos1 + 50, Pos2 + 50]
            FoundPos := 0
            FoundShenanigans := [1,1,1,1]
    
            for _, psObject in SearchColorArray {
                if PixelSearch(&u, &u, PosTable[1], PosTable[2], PosTable[3], PosTable[4], psObject.c, psObject.v) {
                    FoundPos++
                    OutputDebug("`nFound: " _)
                    FoundShenanigans[_] += 1
                }
            }

            if FoundPos >= 3 {
                TimeSinceNotFound := A_TickCount
            }
    
            tfa := ["False", "True"]

            WinGetPos(&XPos, &YPos, &XSize, &YSize, "ahk_exe RobloxPlayerBeta.exe")
            PosX := XPos + XSize
            PosY := YPos

            ToolTip("Check[1]: " tfa[FoundShenanigans[1]] "`nCheck[2]: " tfa[FoundShenanigans[2]] "`nCheck[3]: " tfa[FoundShenanigans[3]] "`nCheck[4]: " tfa[FoundShenanigans[4]] "`nTotal Found: " FoundPos, PosX, PosY)
            OutputDebug("`nTotal Found: " FoundPos "`n------ " A_Index " ------")
        }
    }
}

CreationMap := Map(
    "Main", {Title:"EvilChestMacro", Video:"", Description:"F3 : Start`nF6 : Pause`nF8 : Stop/Close Macro", Version:Version, DescY:250, MacroName:"EvilChestMacro", IncludeFonts:false, MultiInstancing:false},
    "Settings", [
        {Map:NumberValueMap, Name:"Number Settings", Type:"Number", SaveName:"NumberValues", IsAdvanced:false},
        {Map:ToggleValuesMap, Name:"Toggles", Type:"Toggle", SaveName:"Toggles", IsAdvanced:false},
        {Map:userRoutes, Name:"Routes", Type:"Text", SaveName:"Routes", IsAdvanced:true},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"EvilChestMacroV104"}
)

ReturnedUITable := CreateBaseUI(CreationMap)
ReturnedUITable.BaseUI.Show()
ReturnedUITable.BaseUI.OnEvent("Close", (*) => ExitApp())

LastButton := ""
EnableFunction() {
    global MacroEnabled
    ; global MultiInstancingEnabled

    if not MacroEnabled {
        MacroEnabled := true
        ; MultiInstancingEnabled := ReturnedUITable.Instances.Multi

        ReturnedUITable.BaseUI.Hide()
        for _, UI in __HeldUIs["UID" ReturnedUITable.UID] {
            try {
                UI.submit()
            }
        }
    }
}

loop {
    Sleep(100)
    if ReturnedUITable.EnableButton != LastButton {
        LastButton := ReturnedUITable.EnableButton
        LastButton.OnEvent("Click", (*) => EnableFunction())
    }
}

F3::{
    if not MacroEnabled {
        return
    }

    RouteToUse := userRoutes[(["sw_SpawnToEvent", "tw_SpawnToEvent", "vw_SpawnToEvent"][NumberValueMap["World"]])]

    loop {
        if ToggleValuesMap["BasicLeaderboardSwitch"] {
            SendEvent "{Tab Down}{Tab Up}"
            Sleep(500)
        } else {
            LeaderBoardThingy()
            Sleep(500)
        }

        RouteUser(RouteToUse)
        Sleep(500)

        RouteUser(userRoutes["rToChest"])
        Sleep(500)

        DestroyChest()
        Sleep(500)

        JoinNewServer()
        Sleep(500)
    }
}

F5::{
    global CheckPixel := !CheckPixel
    OutputDebug(CheckPixel)
}
F6::Pause -1
F8::ExitApp()
