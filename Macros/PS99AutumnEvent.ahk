; /[V1.1.0]\ (Used for auto-update)
#Requires AutoHotkey v2.0
#Include "%A_MyDocuments%\MacroHubFiles\Modules\BasePositionsPS99.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctions.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctionsPS99.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\EasyUI.ahk"

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1

global MacroEnabled := false
global MultiInstancingEnabled := false

global Version := "1.1.0 [Autumn Event]"

global userRoutes := Map(
    "sw_SpawnToEvent", "tp:Green Forest|w_nV:TpWaitTime|tp:Spawn|w_nV:TpWaitTime|r:[0%Q10&10%W180&240%D1900]",
    "tw_SpawnToEvent", "tp:Mushroom Lab|w_nV:TpWaitTime|tp:Tech Spawn|w_nV:TpWaitTime|r:[0%Q10&10%D1900]",
    "vw_SpawnToEvent", "tp:Prison Tower|w_nV:TpWaitTime|w:3|w_nV:TpWaitTime|r:[0%Q10&20%A500&590%S1600]",
    "EventSpawnToMidZone", "spl:TpButton|sc:[115,223]|spl:X|wt:500|sc:[138,394]|w_nV:TpWaitTime|r:[0%Q10&20%W700]",
    "EventZoneToOuterEventZone", "spl:TpButton|sc:[115,223]|spl:X|wt:500|sc:[147,236]|w_nV:TpWaitTime|r:[0%Q10&20%W900]",
    "ToEgg", "r:[0%A700]",
    "AwayFromEgg", "r:[0%D700]",
    "MinorlyAwayFromEgg", "r:[0%D300]"
)

global NumberValueMap := Map(
    "LoopDelayTime", 1,
    "TpWaitTime", 7000,
)

global BooleanValueMap := Map(
    "ConsumeFruits", true,
    "PlaceFlags", true,
    "UserOwnsAutoFarm", true,
    "EnableAutoHatch", true,
    "EnableAutoHatch_Golden", false,
    "EnableAutoHatch_Charged", true,
    "ShinyFruitToggle", false,
    "AutumnChestCheck", false,
)

global TextValueMap := Map(
    "FlagToUse", "Hasty Flag"
)

global Accounts := []

; -- Copied Functions:
EnableAutoHatch(ValueMap) {
    Clean_UI()

    if not EvilSearch(PixelSearchTables["AutoHatch"], false)[1] { ; and not BooleanValueMap["DoubleHatch"]
        return
    }

    SetPixelSearchLoop("MiniX",12000,1,PM_GetPos("AutoHatch"))

    NameToPos := Map(
        "EnableAutoHatch", [PM_GetPos("AutoHatch_Enable"), PixelSearchTables["AutoHatch_InternalCheck"]],
        "EnableAutoHatch_Golden", [PM_GetPos("AutoHatch_Golden"), PixelSearchTables["AutoHatch_InternalGoldenCheck"]],
        "EnableAutoHatch_Charged", [PM_GetPos("AutoHatch_Charged"), PixelSearchTables["AutoHatch_InternalChargedCheck"]]
    )

    for N, P in NameToPos {
        if ValueMap[N] {
            if not EvilSearch(P[2])[1] and N = "EnableAutoHatch" {
                SendEvent "{Click, " P[1][1] ", " P[1][2] ", 1}"
                Sleep(200)
            }

            if EvilSearch(P[2])[1] { ; and not (BooleanValueMap["DoubleHatch"] and N = "EnableAutoHatch")
                SendEvent "{Click, " P[1][1] ", " P[1][2] ", 1}"
                Sleep(200)
            } 
        }
    }

    Clean_UI()
}

EnableAutofarm(UserOwnsAutoFarm := false) {
    if not UserOwnsAutoFarm {
        return
    }

    Clean_UI()

    if EvilSearch(PixelSearchTables["AutoFarm"], false)[1] {
        PM_ClickPos("AutoFarm")
        Sleep(200)
    } else {
        PM_ClickPos("AutoFarm")
        Sleep(500)
        
        PM_ClickPos("AutoFarm")
        Sleep(200)
    }
}

; Reconnection Function
TheNuclearBomb() {
    Arg1 := EvilSearch(PixelSearchTables["DisconnectBG_LS"], false)[1] 
    Arg2 := EvilSearch(PixelSearchTables["DisconnectBG_RS"], false)[1]
    Arg3 := EvilSearch(PixelSearchTables["ReconnectButton"], false)[1]

    if Arg1 and Arg2 and Arg3 {
        SetPixelSearchLoop("TpButton", 900000, 1, PM_GetPos("ReconnectButton"))

        return true
    }
    return false
}

ItemUseicalFunction(ItemArray, UseSecondary := false) {
    IM := PM_GetPos("ItemMiddle")
    ITL := PM_GetPos("ItemTL")
    IBR := PM_GetPos("ItemBR")

    Clean_UI()
    for _LoopNum, Item in ItemArray {
        RandomPositions := [
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])],
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])],
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])],
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])],
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])]
        ]

        if UseSecondary and Item != "Rainbow Fruit" {
            IM := PM_GetPos("SecondaryItemMiddle")
        } else {
            IM := PM_GetPos("ItemMiddle")
        }

        if not EvilSearch(PixelSearchTables["X"], false)[1] {
            Breaktime1 := A_TickCount
            loop {
                SendEvent "{F Down}{F Up}"
                Sleep(500)
        
                if EvilSearch(PixelSearchTables["X"], false)[1] or (A_TickCount - Breaktime1) >= (15*1000) {
                    break
                }
            }
            Sleep(200)

            PM_ClickPos("InventoryBackpackButton")
            Sleep(200)
        }

        PM_ClickPos("TopOfGame")
        Sleep(100)

        PM_ClickPos("SearchField")
        Sleep(100)

        SendText Item
        Sleep(250)

        ; you see i was gonna change all these but im lazy as hell and they work as is so.
        if not EvilSearch(PixelSearchTables["SearchField"], false)[1] {
            BreakTime2 := A_TickCount
            loop {
                PM_ClickPos("TopOfGame")
                Sleep(200)

                PM_ClickPos("SearchField")
                Sleep(200)
        
                SendText Item
                Sleep(200)

                if EvilSearch(PixelSearchTables["SearchField"], false)[1] or (A_TickCount - BreakTime2) >= (12*1000) {
                    break
                }
            }
        }

        ColorTable := Map()
        WhiteColorFound := 0
        for _, Position in RandomPositions {
            ColorTable[Position] := PixelGetColor(Position[1], Position[2])

            if PixelSearch(&u, &u, Position[1], Position[2], Position[1], Position[2], 0xFFFFFF, 5) {
                WhiteColorFound += 1
            }
        }

        if WhiteColorFound >= 4 {
            OutputDebug("`nProbably a evil item on " Item)
            continue
        }

        TotalResearches := 0
        ToRs := 0
        loop 100 {
            if not EvilSearch(PixelSearchTables["X"], false)[1] {
                Sleep(200)

                if EvilSearch(PixelSearchTables["StupidCat"], false)[1] {
                    Clean_UI()
                    break
                }

                SetPixelSearchLoop("X",15000,1,,[{Key:"F", Time:500, Downtime:10}])
                PM_ClickPos("InventoryBackpackButton")
                Sleep(200)
            }

            FoundColors := 0
            for Position, Color in ColorTable {
                if FoundColors >= 3 {
                    break
                }

                if PixelSearch(&u, &u, Position[1], Position[2], Position[1], Position[2], Color, 2) {
                    FoundColors += 1
                }
            }

            if FoundColors < 3 {

                ToRs += 1

                if ToRs >= 4 {
                    PM_ClickPos("TopOfGame")
                    Sleep(200)
    
                    PM_ClickPos("SearchField")
                    Sleep(200)
            
                    SendText Item
                    Sleep(250)

                    TotalResearches += 1
                }
        
                Breaktimeidk := A_TickCount
                if not EvilSearch(PixelSearchTables["SearchField"], false)[1] {
                    loop {
                        PM_ClickPos("TopOfGame")
                        Sleep(200)
        
                        PM_ClickPos("SearchField")
                        Sleep(200)        
                
                        SendText Item
                        Sleep(200)
        
                        if EvilSearch(PixelSearchTables["SearchField"], false)[1] or (A_TickCount - Breaktimeidk) >= (12*1000) {
                            break
                        }
                    }
                }
            } else {
                ToRs := 0

                SendEvent "{Click, " IM[1] ", " IM[2] ", 1}"

                Sleep(100)
                if EvilSearch(PixelSearchTables["StupidCat"], false)[1] {
                    Breaktime3 := A_TickCount

                    loop {
                        PM_ClickPos("OkayButton")
                        Sleep(500)
    
                        if not EvilSearch(PixelSearchTables["StupidCat"], false)[1] or (A_TickCount - Breaktime3) >= (12*1000) {
                            break
                        }
    
                        Sleep(100)
                    }
    
                    break
                }
            }

            if TotalResearches >= 10 {
                break
            }
        }
    }

    Sleep(300)
    Clean_UI()
    OutputDebug("Function Over")
}

; -- UI Setup
CreationMap := Map(
    "Main", {Title:"Event Macro", Video:"", Description:"F3 : Start`nF6 : Pause`nF8 : Stop/Close Macro", Version:Version, DescY:250, MacroName:"Event Macro", IncludeFonts:false, MultiInstancing:true},
    "Settings", [
        {Map:TextValueMap, Name:"Text Settings", Type:"Text", SaveName:"TextValues", IsAdvanced:false},
        {Map:BooleanValueMap, Name:"Toggle Settings", Type:"Toggle", SaveName:"ToggleValues", IsAdvanced:false},
        {Map:NumberValueMap, Name:"Number Settings", Type:"Number", SaveName:"NumberValues", IsAdvanced:false},
        {Map:userRoutes, Name:"Routes", Type:"Text", SaveName:"Routes", IsAdvanced:true},

    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"EventMacro_AutumnEvent_v1.1"}
)

ReturnedUITable := CreateBaseUI(CreationMap)
ReturnedUITable.BaseUI.Show()
ReturnedUITable.BaseUI.OnEvent("Close", (*) => ExitApp())

LastButton := ""
EnableFunction() {
    global MacroEnabled
    global MultiInstancingEnabled

    if not MacroEnabled {
        MacroEnabled := true
        MultiInstancingEnabled := ReturnedUITable.Instances.Multi

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

;-- Main
CleanUpMulti(IDMAP) {
    NameToBetterName := Map(
        "Text Settings", "TextValueMap",
        "Toggle Settings", "BooleanValueMap",
        "Number Settings", "NumberValueMap",
        "Routes", "Routes",
    )
    FinalizedMap := Map()

    for ID, IDOBJ in IDMAP {
        CleanMap := Map()

        switch IDOBJ.Action {
            case "Macro":
                CleanMap["Action"] := "Macro"
                for _, SettingObj in IDOBJ.Clone["Settings"] {
                    if NameToBetterName.Has(SettingObj.Name) {
                        CleanMap[NameToBetterName[SettingObj.Name]] := SettingObj.Map
                    } else {
                        OutputDebug("`nIssue condensing to map _ MACRO _ " SettingObj.Name)
                    }
                }

                CleanMap["LastActivated"] := 0
                CleanMap["PreviousRunTime"] := 0
                CleanMap["TotalLoopAmount"] := 0
                CleanMap["IsSetup"] := false

                FinalizedMap[ID] := CleanMap
            default:
                CleanMap["Action"] := "Anti-Afk"
                CleanMap["AfkSettings"] := IDOBJ.Map["Afk Settings"]

                CleanMap["LastActivated"] := 0
                FinalizedMap[ID] := CleanMap
        }
    }

    return FinalizedMap
}

CheckForAntiAfk(InstanceMap := Map(), CurrentID := -1) {
    for InstanceID, InstanceInfo in InstanceMap {
        if InstanceID = CurrentID {
            continue
        }

        if (A_TickCount - InstanceInfo["LastActivated"]) >= 720000 {
            loop {
                WinActivate("ahk_id " InstanceID)
                Sleep(100)
            } until  WinActive("ahk_id " InstanceID)

            ; Tbh idk if the anti action here is needed but just incase 
            if not InstanceInfo["Action"] = "Anti-Afk" and TheNuclearBomb() {
                InstanceInfo["IsSetup"] := false
                InstanceInfo["LastActivated"] := A_TickCount
                continue
            }

            loop 5 {
                PM_ClickPos("TopOfGame")
                Sleep(200)
            }

            InstanceInfo["LastActivated"] := A_TickCount
        }
    }

    if CurrentID != -1 {
        loop {
            WinActivate("ahk_id " CurrentID)
            Sleep(100)
        } until  WinActive("ahk_id " CurrentID)
    }
}

Main() {
    Runtime := A_TickCount
    InstanceMap := Map(WinGetID("ahk_exe RobloxPlayerBeta.exe"), Map(
        "LastActivated", 0,
        "PreviousRunTime", 0,
        "TotalLoopAmount", 0,
        "Action", "Macro",
        "IsSetup", false,
        "TextValueMap", TextValueMap,
        "BooleanValueMap", BooleanValueMap,
        "NumberValueMap", NumberValueMap,
        "Routes", userRoutes
    ))

    if MultiInstancingEnabled {
        OutputDebug("Cleaing Up Multi`n")
        InstanceMap := CleanUpMulti(ReturnedUITable.Instances.RecMap)
    }

    OutputDebug(InstanceMap.Count)
    CurrentID := -1

    loop {
        Sleep(300)

        ; We keep this seperate because if the user needs to reconnect then we'd rather have this called here.
        for InstanceID, InstanceInfo in InstanceMap {
            CheckForAntiAfk(InstanceMap, -1)
            if InstanceInfo.Has("IsSetup") and not InstanceInfo["IsSetup"] {
                loop {
                    WinActivate("ahk_id " InstanceID)
                    Sleep(100)
                } until  WinActive("ahk_id " InstanceID)
                WinMove(,,800,600,"ahk_id " InstanceID)

                SetPixelSearchLoop("TpButton", 20000, 1,,,150,,[{Func:Clean_UI, Time:10000}])
                LeaderBoardThingy()

                for _, AreaName in ["Cherry Blossom", "Mushroom Lab", "Prison Tower"] {
                    SetPixelSearchLoop("X", 20000, 1,,,150,,[{Func:____TP_1, Time:6000}])
                    Sleep(400)
                    PM_ClickPos("SearchField")
                    Sleep(400)
                    SendText AreaName
                    Sleep(400)

                    if EvilSearch(PixelSearchTables["TpButtonGreenCheck"])[1] {
                        InstanceInfo["World"] := _
                        OutputDebug("`nWorld is World " _)
                        break
                    } else {
                        PM_ClickPos("TopOfGame")
                    }
                }

                Clean_UI()
                RouteUser(InstanceInfo["Routes"][(["sw_SpawnToEvent", "tw_SpawnToEvent", "vw_SpawnToEvent"][InstanceInfo["World"]])])
                Sleep(1000)
                SetPixelSearchLoop("TpButton", 20000, 1)
                RouteUser(InstanceInfo["Routes"]["EventSpawnToMidZone"])

                InstanceInfo["IsSetup"] := true
                InstanceInfo["IsHatching"] := false
            }
        }

        for InstanceID, InstanceInfo in InstanceMap {
            CheckForAntiAfk(InstanceMap, -1)

            if (InstanceInfo.Has("IsSetup") and not InstanceInfo["IsSetup"]) or not (InstanceInfo["Action"] = "Macro") or not ((A_TickCount - InstanceInfo["PreviousRunTime"]) >= InstanceInfo["NumberValueMap"]["LoopDelayTime"] * 1000) {
                continue
            }

            loop {
                WinActivate("ahk_id " InstanceID)
                Sleep(100)
            } until  WinActive("ahk_id " InstanceID)

            if InstanceInfo["IsHatching"] {
                RouteUser(InstanceInfo["Routes"]["AwayFromEgg"])
                Sleep(1000)

                TpDetections := 0
                BreakTime_1 := A_TickCount
                loop {
                    PM_ClickPos("MiddleOfScreen")

                    if EvilSearch(PixelSearchTables["TpButton"], false)[1] {
                        TpDetections += 1
                    } else {
                        TpDetections := 0
                    }

                    if (A_TickCount - BreakTime_1) >= 20000 or TpDetections >= 40 {
                        break
                    }

                    Sleep(100)
                }

                LeaderBoardThingy()

                ; if not InstanceInfo["BooleanValueMap"]["UserOwnsAutoFarm"] {
                RouteUser(InstanceInfo["Routes"]["EventZoneToOuterEventZone"])
                Sleep(300)
                RouteUser(InstanceInfo["Routes"]["EventSpawnToMidZone"])
                ; }
            }

            if InstanceInfo["BooleanValueMap"]["ConsumeFruits"] {
                ItemUseicalFunction(["Apple", "Banana", "Pineapple", "Watermelon", "Orange", "Rainbow Fruit"], InstanceInfo["BooleanValueMap"]["ShinyFruitToggle"])
            }

            if InstanceInfo["BooleanValueMap"]["PlaceFlags"] {
                ItemUseicalFunction([InstanceInfo["TextValueMap"]["FlagToUse"]], false)
            }

            EnableAutofarm(InstanceInfo["BooleanValueMap"]["UserOwnsAutoFarm"])
            EnableAutoHatch(InstanceInfo["BooleanValueMap"])

            RouteUser(InstanceInfo["Routes"]["ToEgg"])
            Sleep(500)
            SetPixelSearchLoop("MiniX", 20000, 1,,[{Key:"E", Time:200, DownTime:20}])
            Sleep(500)
            PM_ClickPos("EggMaxBuy")

            InstanceInfo["LastActivated"] := InstanceInfo["PreviousRunTime"] := A_TickCount
            InstanceInfo["IsHatching"] := true

            if not InstanceInfo["BooleanValueMap"]["UserOwnsAutoFarm"] {
                RouteUser(InstanceInfo["Routes"]["MinorlyAwayFromEgg"])
            }

            if InstanceMap.Count = 1 {
                loop {
                    PM_ClickPos("MiddleOfScreen")
                    Sleep(10)
                } until (A_TickCount - InstanceInfo["PreviousRunTime"]) >= InstanceInfo["NumberValueMap"]["LoopDelayTime"] * 1000
            }
        }
    }
}

F3::Main()
F5::{
    global DebugEnabled
    global __DebugGUI

    if __DebugGUI = "" {
        CreateDebugGui()
        DebugBasicInfo_UsefulFunctions()
        DebugBasicInfo()
        AttachToWindow(WinGetID("ahk_exe RobloxPlayerBeta.exe"), [8,1])
    }

    DebugEnabled := !DebugEnabled
}
F6::Pause -1
F8::ExitApp()
