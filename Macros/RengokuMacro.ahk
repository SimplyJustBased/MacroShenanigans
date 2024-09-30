; /[V1.0.2]\

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
        Slot:4, Pos:[468, 307], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:4, ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:5, ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:7 , ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:16000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:0},
        ]
    },

    ; SprintWagon 2
    "Unit_2", {
        Slot:4, Pos:[503, 279], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:1, ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:4, ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:7, ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:0},
        ]  
    },

    ; SprintWagon 3
    "Unit_3", {
        Slot:4, Pos:[448, 271], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:2, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:5, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:7, ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:0},
        ]
    },

    ; Takaroda
    "Unit_4", {
        Slot:5, Pos:[324, 282], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:4, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:10, ActionCompleted:false, Delay:4000},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:4000},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:16000},
        ]
    },

    ; Tengon 1
    "Unit_5", {
        Slot:1, Pos:[73, 291], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:3, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:10, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:16, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:18, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:2000},
        ]
    },

    ; Tengon 2
    "Unit_6", {
        Slot:1, Pos:[110, 278], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:3, ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:10, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:16, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:18, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:2000},
        ]
    },

    ; Tengon 3
    "Unit_7", {
        Slot:1, Pos:[147, 262], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:6, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:10, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:16, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:18, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:19, ActionCompleted:false, Delay:0},
        ]
    },

    ; Haruka
    "Unit_8", {
        Slot:3, Pos:[61, 263], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:6, ActionCompleted:false, Delay:0},
        ]
    },

    ; Blossom
    "Unit_9", {
        Slot:2, Pos:[92, 247], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:50000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:50000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:50000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:50000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:50000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:5000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:53000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:53000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:53000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:53000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:53000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:53000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:56000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:56000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:56000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:56000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:56000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:56000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:59000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:59000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:59000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:59000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:59000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:59000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:62000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:62000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:62000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:62000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:62000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:62000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:65000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:65000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:65000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:65000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:65000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:65000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:68000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:68000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:68000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:68000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:68000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:68000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:71000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:71000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:71000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:71000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:71000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:71000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:74000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:74000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:74000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:74000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:74000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:74000},

            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:77000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:77000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:77000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:77000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:77000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:77000},
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
    "Main", {Title:"AVRengokuMacro", Video:"https://www.youtube.com/watch?v=xwUe6zqHPTA", Description:"Experimental Version`nF3 : Start`nF6:Pause`nF8 : Stop`n`nMake sure to set font to times new roman in extras tab!", Version:MacroVersion, DescY:"250", MacroName:"AVRengokuMacro", IncludeFonts:true, MultiInstancing:false},
    "Settings", [
        {Map:UnitMap, Name:"Unit Settings", Type:"UnitUI", SaveName:"UnitSettings", IsAdvanced:false},
        {Map:ToggleMapValues, Name:"Toggle Settings", Type:"Toggle", SaveName:"ToggleSettings", IsAdvanced:false},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"AV_RENGOKUTEST_1"}
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

    SendEvent "{w Down}"
    Sleep(1000)
    SendEvent "{w Up}"
    Sleep(400)
    SendEvent "{d Down}"
    Sleep(1400)
    SendEvent "{d Up}"
    Sleep(400)

    Sleep(200)
    CameraticView()
    Sleep(200)

    if EvilSearch(PixelSearchTables["AutoStart"])[1] {
        PM_ClickPos("AutoStart")
        Sleep(200)
    }


    loop {
        Sleep(500)

        EnableWaveAutomation([125], true, 20, 30, 20000, ToggleMapValues["WaveDebug"], false)

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
