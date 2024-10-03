; /[V1.0.4]\

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1

#Include "%A_MyDocuments%\MacroHubFiles\Modules\BasePositionsAV.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctions.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctionsAV.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\EasyUI.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UWBOCRLib.ahk"

global MacroVersion := "1.0.0"
global PlayerPositionFromSpawn := {W:0, A:0, S:0, D:0}
global MacroEnabled := false
global MacroEnabled := false
global UnitMap := Map(
    ; SprintWagon 1
    "Unit_1", {
        Slot:4, Pos:[352, 234], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:3, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:5, ActionCompleted:false, Delay:15000},
            {Type:"Upgrade", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:0},
        ]
    },

    ; SprintWagon 2
    "Unit_2", {
        Slot:4, Pos:[373, 195], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:1, ActionCompleted:false, Delay:15000},
            {Type:"Upgrade", Wave:3, ActionCompleted:false, Delay:15000},
            {Type:"Upgrade", Wave:5, ActionCompleted:false, Delay:15000},
            {Type:"Upgrade", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:0},
        ]  
    },

    ; SprintWagon 3
    "Unit_3", {
        Slot:4, Pos:[400, 234], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:2, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:4, ActionCompleted:false, Delay:15000},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:7, ActionCompleted:false, Delay:15000},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:15000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:0},
        ]
    },

    ; Takaroda
    "Unit_4", {
        Slot:5, Pos:[422, 144], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:2, ActionCompleted:false, Delay:15000},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:15000},
            {Type:"Upgrade", Wave:10, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:0},
        ]
    },

    ; Tengon 1
    "Unit_5", {
        Slot:1, Pos:[482, 211], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:4, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:16, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:17, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:18, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:19, ActionCompleted:false, Delay:0},
        ]
    },

    ; Tengon 2
    "Unit_6", {
        Slot:1, Pos:[506, 241], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:5, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:16, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:17, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:18, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:0},
        ]
    },

    ; Tengon 3
    "Unit_7", {
        Slot:1, Pos:[473, 312], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:6, ActionCompleted:false, Delay:8000},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:16, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:17, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:18, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:19, ActionCompleted:false, Delay:0},
        ]
    },

    ; Haruka
    "Unit_8", {
        Slot:3, Pos:[475, 255], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:9, ActionCompleted:false, Delay:0},
        ]
    },

    ; Blossom
    "Unit_9", {
        Slot:2, Pos:[492, 283], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:80000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:80000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:80000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:80000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:80000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:80000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:83000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:83000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:83000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:83000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:83000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:83000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:86000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:86000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:86000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:86000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:86000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:86000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:89000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:89000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:89000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:89000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:89000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:89000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:92000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:95000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:95000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:95000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:95000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:95000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:95000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:98000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:98000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:98000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:98000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:98000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:98000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:101000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:101000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:101000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:101000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:101000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:101000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:104000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:104000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:104000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:104000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:104000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:104000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:107000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:107000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:107000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:107000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:107000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:107000},
        ]
    },
)

global ToggleMapValues := Map(
    "NoMovementReset", true,
    "SecondaryOCR", false,
    "WaveDebug", true,
)

global NumberValueMap := Map()

ReturnedUIObject := CreateBaseUI(Map(
    "Main", {Title:"AVRengokuMacro", Video:"https://www.youtube.com/watch?v=xwUe6zqHPTA", Description:"Experimental Version`nF3 : Start`nF6 : Pause`nF8 : Stop`n`nMake sure to set font to times new roman in extras tab!", Version:MacroVersion, DescY:"250", MacroName:"AVRengokuMacro", IncludeFonts:true, MultiInstancing:false},
    "Settings", [
        {Map:UnitMap, Name:"Unit Settings", Type:"UnitUI", SaveName:"UnitSettings", IsAdvanced:false},
        {Map:ToggleMapValues, Name:"Toggle Settings", Type:"Toggle", SaveName:"ToggleSettings", IsAdvanced:false},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"AV_RENGOKUTEST_3"}
))


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


ReturnedUIObject.BaseUI.Show()
ReturnedUIObject.BaseUI.OnEvent("Close", (*) => ExitApp())
ReturnedUIObject.EnableButton.OnEvent("Click", (*) => EnableFunction())

F3::{
    global MacroEnabled

    if not MacroEnabled {
        return
    }

    ; loop {
    ;     WaveDetection()
    ;     Sleep(1)
    ; }

    TpToSpawn()
    Sleep(500)

    Sleep(200)
    SendEvent "{a Down}"
    Sleep(2000)
    SendEvent "{a Up}"
    Sleep(500)
    SendEvent "{s Down}"
    Sleep(1000)
    SendEvent "{s Up}"

    Sleep(200)
    CameraticView()
    Sleep(500)

    if EvilSearch(PixelSearchTables["AutoStart"])[1] {
        PM_ClickPos("AutoStart")
        Sleep(200)
    }


    loop {
        Sleep(500)

        EnableWaveAutomation([125], true, 20, 30, 20000, ToggleMapValues["WaveDebug"], true)

        loop {
            if DetectEndRoundUI() {
                break
            }

            SendEvent "{Click,416, 156, 1}"
            Sleep(100)
        }
        Sleep(1000)

        PM_ClickPos("RetryButton", 1)
        Sleep(1000)
        PM_ClickPos("VoteStartButton", 1)
        ResetActions()
    }
}

F8::ExitApp()
F6::Pause()
