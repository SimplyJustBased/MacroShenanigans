; /[V1.0.2]\

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1

#Include "%A_MyDocuments%\MacroHubFiles\Modules\BasePositionsAV.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctions.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctionsAV.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\EasyUI.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UWBOCRLib.ahk"

global MacroVersion := "1.0.1"
global PlayerPositionFromSpawn := {W:0, A:0, S:0, D:0}
global MacroEnabled := false
global MacroEnabled := false

global UnitMap := Map(
    ; SprintWagon 1
    "Unit_1", {
        Slot:4, Pos:[336, 179], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:1, ActionCompleted:false, Delay:12000},
            {Type:"Upgrade", Wave:2, ActionCompleted:false, Delay:14000},
            {Type:"Upgrade", Wave:3, ActionCompleted:false, Delay:14000},
            {Type:"Upgrade", Wave:4, ActionCompleted:false, Delay:14000},
            {Type:"Sell", Wave:15, ActionCompleted:false, Delay:0},
        ]
    },

    ; SprintWagon 2
    "Unit_2", {
        Slot:4, Pos:[386, 180], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:1, ActionCompleted:false, Delay:12000},
            {Type:"Upgrade", Wave:2, ActionCompleted:false, Delay:14000},
            {Type:"Upgrade", Wave:4, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:5, ActionCompleted:false, Delay:0},
            {Type:"Sell", Wave:15, ActionCompleted:false, Delay:0},
        ]
    },

    ; SprintWagon 3
    "Unit_3", {
        Slot:4, Pos:[333, 230], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:1, ActionCompleted:false, Delay:12000},
            {Type:"Upgrade", Wave:3, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:4, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:5, ActionCompleted:false, Delay:5000},
            {Type:"Sell", Wave:15, ActionCompleted:false, Delay:0},
        ]
    },

    ; Vogita 1
    "Unit_4", {
        Slot:2, Pos:[413, 438], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:0},
        ]
    },

    ; Vogita 2
    "Unit_5", {
        Slot:2, Pos:[446, 434], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:2, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:0},
        ]
    },

    ; Vogita 3
    "Unit_6", {
        Slot:2, Pos:[380, 440], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:2, ActionCompleted:false, Delay:6000},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:0},
        ]
    },

    ; Vogita 4
    "Unit_7", {
        Slot:2, Pos:[339, 442], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:3, ActionCompleted:false, Delay:6000},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:0},
        ]
    },

    ; Sasuke 1
    "Unit_8", {
        Slot:6, Pos:[696, 301], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:1, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:1, ActionCompleted:false, Delay:0},
        ]
    },

    ; Haruka
    "Unit_10", {
        Slot:3, Pos:[405, 388], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:5, ActionCompleted:false, Delay:0},
        ]
    },
    
    ; Cha-in 1
    "Unit_11", {
        Slot:1, Pos:[469, 376], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
        ]
    },

    ; Cha-in 2
    "Unit_12", {
        Slot:1, Pos:[437, 375], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
        ]
    },

    ; Cha-in 3
    "Unit_13", {
        Slot:1, Pos:[405, 347], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
        ]
    },

    ; Cha-in 4
    "Unit_14", {
        Slot:1, Pos:[373, 376], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
        ]
    },

    ; Cha-in 5
    "Unit_15", {
        Slot:1, Pos:[340, 379], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
        ]
    },

    ; Bean 1
    "Unit_16", {
        Slot:5, Pos:[469, 410], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
        ]
    },

    ; Bean 2
    "Unit_17", {
        Slot:5, Pos:[439, 341], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
        ]
    },

    ; Bean 3
    "Unit_18", {
        Slot:5, Pos:[370, 343], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
        ]
    },

    ; Bean 4
    "Unit_19", {
        Slot:5, Pos:[327, 409], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
        ]
    },
)

global ToggleMapValues := Map(
    "NoMovementReset", true,
    "SecondaryOCR", false,
    "WaveDebug", true,
)

global NumberValueMap := Map()

global ModifierCheckMap := Map(
    "CardRed", {
        Color:0x090101,
        SpecificChecks:Map(
            "Strong_Enemies", {ColorChecks:[0x4F1617, 98, 16, 97, 14], Amount:0}
        )
    },

    "CardGreen", {
        Color:0x010903,
        SpecificChecks:Map(
            "Revitalize", {ColorChecks:[0x020202, 86, 46, 86, 46], Amount:0},
            "Regen", {ColorChecks:[0x0F4423, 86, 46, 86, 46], Amount:0}
        )
    },

    "CardBlue", {
        Color:0x010508,
        SpecificChecks:Map(
            "Fast", {ColorChecks:[0x082C3D, 67, 61, 67, 61], Amount:0},
            "Shielded", {ColorChecks:[0x020202, 67, 61, 67, 61], Amount:0}
        )
    },
    "CardOrange", {
        Color:0x0A0501,
        SpecificChecks:Map(
            "Exploding", {ColorChecks:[], Amount:0},
        )
    },

    "CardPurple", {
        Color:0x06020A,
        SpecificChecks:Map(
            "Thrice", {ColorChecks:[], Amount:0},
        )
    },
)

global ModifierInfoMap := Map(
    "Strong_Enemies", {Priority:1, Maxium:999, PostMaxiumPriority:11},
    "Regen", {Priority:2, Maxium:999, PostMaxiumPriority:11},
    "Thrice", {Priority:3, Maxium:20, PostMaxiumPriority:5},
    "Shielded", {Priority:4, Maxium:999, PostMaxiumPriority:11},
    "Revitalize", {Priority:5, Maxium:999, PostMaxiumPriority:11},
    "Exploding", {Priority:6, Maxium:999, PostMaxiumPriority:11},
    "Fast", {Priority:10, Maxium:999, PostMaxiumPriority:11}
)

global CardCheckPositions := Map(
    "Slot1", {B_CC:{X1:102,Y1:405,X2:298,Y2:435}, Offset:[102, 185], ClickPos:[202, 385]},
    "Slot2", {B_CC:{X1:310,Y1:405,X2:505,Y2:435}, Offset:[310, 185], ClickPos:[410, 385]},
    "Slot3", {B_CC:{X1:520,Y1:405,X2:715,Y2:435}, Offset:[520, 185], ClickPos:[620, 385]},
)

global ResetMap := Map(
    "Rejoin_Settings", {ToRejoin:false, PrivateServerLink:"", RunRejoinAmount:20}
)

CardFunction() {
    global CardCheckPositions, ModifierInfoMap, ModifierCheckMap

    LastChosenSlot := ""
    loop {
        CardMap := Map(
            "Slot1", {Name:"", Priority:9},
            "Slot2", {Name:"", Priority:9},
            "Slot3", {Name:"", Priority:9},
        )

        OuterTickTime := A_TickCount

        loop {
            PM_ClickPos("CamSet1", 0)
            Sleep(15)
    
            if PixelSearch(&u, &u2, 701, 420, 701, 420, 0x020202, 9) {
                Sleep(200)
                break
            }

            if (A_TickCount - OuterTickTime) >= (4000) {
                break 2 
            }
        }

        for SlotID, SlotObject in CardMap {
            PSOBJ := CardCheckPositions[SlotID].B_CC

            for CardColor, CardObject in ModifierCheckMap {
                if PixelSearch(&u, &u2, PSOBJ.X1, PSOBJ.Y1, PSOBJ.X2, PSOBJ.Y2, CardObject.Color, 0) {
                    if CardObject.SpecificChecks.Count = 1 {
                        for Name, _ in CardObject.SpecificChecks {
                            SlotObject.Name := Name
                        }
                    } else {
                        for Name, SpecificObject in CardObject.SpecificChecks {
                            PSOBJ2 := SpecificObject.ColorChecks
                            Offset := CardCheckPositions[SlotID].Offset

                            if PixelSearch(&u, &u2, Offset[1] + PSOBJ2[2], Offset[2] + PSOBJ2[3], Offset[1] + PSOBJ2[4], Offset[2] + PSOBJ2[5], PSOBJ2[1], 2) {
                                SlotObject.Name := Name
                                break
                            }
                        }
                    }

                    if SlotObject.Name != "" {
                        if CardObject.SpecificChecks[SlotObject.Name].Amount >= ModifierInfoMap[SlotObject.Name].Maxium {
                            SlotObject.Priority := ModifierInfoMap[SlotObject.Name].PostMaxiumPriority
                        } else {
                            SlotObject.Priority := ModifierInfoMap[SlotObject.Name].Priority
                        }
                    } else {
                        SlotObject.Name := "Unknown"
                    }

                    break
                }
            }
        }

        LowestSlot := ""

        for SlotID, SlotObject in CardMap {
            if LowestSlot = "" {
                LowestSlot := SlotID
                continue
            }

            if CardMap[LowestSlot].Priority > SlotObject.Priority {
                LowestSlot := SlotID
            }
        }

        if LastChosenSlot = LowestSlot {
            OuterTickTime_2 := A_TickCount

            loop {
                SendEvent "{Click, " CardCheckPositions[LowestSlot].ClickPos[1] ", " CardCheckPositions[LowestSlot].ClickPos[2] ", 1}"

                if not PixelSearch(&u, &u2, 690, 210, 690, 210, 0x020202, 3) or (A_TickCount - OuterTickTime_2 >= 5000) {
                    break
                }

                Sleep(100)
            }

            LastChosenSlot := ""
        } else {
            LastChosenSlot := LowestSlot
        }
    }
    Sleep(100)
}

EnableFunction() {
    global MacroEnabled

    if not MacroEnabled {
        MacroEnabled := true

        ReturnedUIObject.BaseUI.Hide()
        for _, UI in __HeldUIs["UID" ReturnedUIObject.UID] {
            try {
                UI.submit()
            }
        }
    }
}

SetTo0Point9X() {
    SetPixelSearchLoop("SettingsX", 6000, 1, PM_GetPos("SettingButton"),,,600)
    Sleep(400)
    PM_ClickPos("SettingMiddle")
    Sleep(300)

    loop 15 {
        SendEvent "{WheelDown}"
        Sleep(10)
    }

    Sleep(100)
    SendEvent "{Click, 429, 557, 1}"
    Sleep(760)

    ; Settings X
    SendEvent "{Click, 563, 178, 0}"
    Sleep(15)
    SendEvent "{Click, 563, 178, 1}"
    Sleep(100)
}

SetTo1Point5X() {
    ; Settings
    SendEvent "{Click, 24, 616, 1}"
    Sleep(450)
    ; Setting Middle
    SendEvent "{Click, 409, 202, 1}"
    Sleep(100)

    loop 15 {
        SendEvent "{WheelDown}"
        Sleep(10)
    }

    Sleep(100)
    ; UISCALE 1.5
    SendEvent "{Click, 514, 465, 1}"
    Sleep(1000)
    PM_ClickPos("SettingsX")
}

ReconnecticalOfSimplicity() {
    if not DisconnectedCheck() {
        return false
    }

    YeahYeahFunction(true)
    return true
}

YeahYeahFunction(BooleanValue := false) {
    if BooleanValue {
        SetPixelSearchLoop("StoreCheck", 90000, 1, PM_GetPos("ReconnectButton"))
    } else {
        SetPixelSearchLoop("StoreCheck", 90000, 1)
    }
    
    SendEvent "{Tab Down}{Tab Up}"
    Sleep(300)
    PM_ClickPos("PlayerX")
    Sleep(300)
    PM_ClickPos("AreaButton")
    Sleep(300)
    PM_ClickPos("Area_PlayButton")
    Sleep(300)
    PM_ClickPos("AreaButtonX")
    Sleep(500)
    RouteUser("r:[0%W600&650%A600&1300%W4000]")
    Sleep(500)

    SetTo0Point9X()
    loop {
        SendEvent "{A Down}{Space Down}"
        
        Issue := 0
        loop {
            for _1, SearchName in ["0.9xLeave", "0.9xConfirm"] {
                if EvilSearch(PixelSearchTables[SearchName])[1] {
                    Issue := _1
                    SendEvent "{A Up}{Space Up}"
                    break 2
                }
            }
            Sleep(10)
        }

        switch Issue {
            case 1:
                SendEvent "{Click, 622, 456, 1}"
                Sleep(5000)
                OutputDebug("Retrying")
            case 2:
                OutputDebug("Perfection")
                break
        }
    }

    Sleep(400)
    SendEvent "{Click, 	426, 275, 1}"
    Sleep(300)

    loop 15 {
        SendEvent "{WheelDown}"
        Sleep(10)
    }
    Sleep(300)
    SendEvent "{Click, 422, 395, 1}"
    Sleep(700)
    SendEvent "{Click, 743, 245, 1}"
    Sleep(300)
    PM_ClickPos("0.9xConfirm")
    Sleep(500)
    SendEvent "{Click, 584, 454, 1}"
    Sleep(4000)
}


ModifierOrder := ["Strong_Enemies", "Regen", "Thrice", "Shielded", "Revitalize", "Exploding", "Fast"]
ReturnedUIObject := CreateBaseUI(Map(         
    "Main", {Title:"AVParagonic", Video:"https://www.youtube.com/watch?v=xwUe6zqHPTA", Description:"Experimental Version`nF3 : Start`nF6:Pause`nF8 : Stop`n`nMake sure to set font to times new roman in extras tab!", Version:MacroVersion, DescY:"250", MacroName:"AVParagonic", IncludeFonts:true, MultiInstancing:false},
    "Settings", [
        {Map:UnitMap, Name:"Unit Settings", Type:"UnitUI", SaveName:"UnitSettings", IsAdvanced:false},
        {Map:ToggleMapValues, Name:"Toggle Settings", Type:"Toggle", SaveName:"ToggleSettings", IsAdvanced:false},
        {Map:ModifierInfoMap, Name:"Modifier Settings", Type:"Object", SaveName:"ModSettings", IsAdvanced:false, ObjectOrder:ModifierOrder, ObjectIgnore:Map(), Booleans:Map(), ObjectsPerPage:3},
        {Map:ResetMap, Name:"Reset Fix Settings", Type:"Object", SaveName:"RejoinSettings", IsAdvanced:false, ObjectOrder:["Rejoin_Settings"], ObjectIgnore:Map(), Booleans:Map("ToRejoin", true), ObjectsPerPage:1},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"AV_PARAGONTEST_1"}
))

ReturnedUIObject.BaseUI.Show()
ReturnedUIObject.BaseUI.OnEvent("Close", (*) => ExitApp())
ReturnedUIObject.EnableButton.OnEvent("Click", (*) => EnableFunction())

F3::{
    global MacroEnabled
    if not MacroEnabled {
        return
    }

    ResetRuns := TotalRuns := 0

    CardFunction()
    Sleep(500)
    TpToSpawn()
    Sleep(950)
    CameraticView()
    Sleep(200)

    WaveSetDetection(5)

    if EvilSearch(PixelSearchTables["AutoStart"])[1] {
        PM_ClickPos("AutoStart")
        Sleep(200)
    }

    loop {
        Sleep(500)

        EnableWaveAutomation([125], true, 1, 16, 20000, ToggleMapValues["WaveDebug"], true, {1:13000,2:13000,3:13000,4:13000})

        loop {
            if DetectEndRoundUI() {
                break
            }

            SendEvent "{Click, 416, 156, 1}"
            Sleep(100)
        }
        Sleep(1000)

        loop 5 {
            PM_ClickPos("ContinueButton", 1)
            Sleep(300)

            if not DetectEndRoundUI() {
                break
            }
        }

        if DetectEndRoundUI {
            PM_ClickPos("RetryButton", 1)
            Sleep(1000)
        }

        if ResetRuns >= ResetMap["Rejoin_Settings"].RunRejoinAmount and ResetMap["Rejoin_Settings"].ToRejoin {
            ResetRuns := 0
            loop {
                try {
                    WinClose("ahk_exe RobloxPlayerBeta.exe")
                }

                Sleep(1000)

                if not WinExist("ahk_exe RobloxPlayerBeta.exe") {
                    break
                }

                Sleep(200)
            }
            Sleep(1000)
            OutputDebug(ResetMap["Rejoin_Settings"].PrivateServerLink)
            Run(ResetMap["Rejoin_Settings"].PrivateServerLink)

            Timical := A_TickCount
            loop {
                if WinExist("ahk_exe RobloxPlayerBeta.exe") {
                    break
                }

                Sleep(1000)

                if A_TickCount - Timical >= 120000 {
                    Run(ResetMap["Rejoin_Settings"].PrivateServerLink)
                }
            }
            Sleep(400)
            WinActivate("ahk_exe RobloxPlayerBeta.exe")
            Sleep(200)
            WinMove(,,800,600,"ahk_exe RobloxPlayerBeta.exe")
            Sleep(200)
            YeahYeahFunction()
            Sleep(2500)

            loop {
                SendEvent "{Click, 24, 616, 1}"
                Sleep(500)

                if PixelSearch(&u, &u, 545, 166, 579, 197, 0xD43335, 2) {
                    ; Setting Middle
                    SendEvent "{Tab Down}{Tab Up}"
                    Sleep(100)

                    SendEvent "{Click, 409, 202, 1}"
                    Sleep(100)

                    loop 15 {
                        SendEvent "{WheelDown}"
                        Sleep(10)
                    }

                    Sleep(100)
                    ; UISCALE 1.5
                    SendEvent "{Click, 514, 479, 1}"
                    Sleep(200)
                    PM_ClickPos("SettingsX")
                    break
                }
            }

            CameraticView()
            Sleep(200)
        }

        if ReconnecticalOfSimplicity() {
            loop {
                SendEvent "{Click, 24, 616, 1}"
                Sleep(500)

                if PixelSearch(&u, &u, 545, 166, 579, 197, 0xD43335, 2) {
                    ; Setting Middle
                    SendEvent "{Tab Down}{Tab Up}"
                    Sleep(100)

                    SendEvent "{Click, 409, 202, 1}"
                    Sleep(100)

                    loop 15 {
                        SendEvent "{WheelDown}"
                        Sleep(10)
                    }

                    Sleep(100)
                    ; UISCALE 1.5
                    SendEvent "{Click, 514, 479, 1}"
                    Sleep(200)
                    PM_ClickPos("SettingsX")
                    break
                }
            }

            CameraticView()
            Sleep(200)
        }


        CardFunction()
        Sleep(500)
        TpToSpawn()
        Sleep(950)
        WaveSetDetection(5)
        Sleep(400)
        PM_ClickPos("VoteStartButton", 1)
        ResetActions()
        ResetRuns++
        TotalRuns++
    }
}

F8::ExitApp()
F6::Pause -1

F5::YeahYeahFunction(false)
