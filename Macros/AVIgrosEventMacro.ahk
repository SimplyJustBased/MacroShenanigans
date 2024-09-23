; /[V1.0.8]\

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1

#Include "%A_MyDocuments%\MacroHubFiles\Modules\BasePositionsAV.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctions.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctionsAV.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\EasyUI.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UWBOCRLib.ahk"

; 461, 117

global MacroVersion := "1.0.0"
global PlayerPositionFromSpawn := {W:0, A:0, S:0, D:0}
global MacroEnabled := false

; Placement | Upgrade | Sell
global UnitMap := Map(
    ;SprintWagon1
    "Unit_1", {
        Slot:5, Pos:[630, 207], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false},{Type:"Upgrade", Wave:2, ActionCompleted:false},{Type:"Upgrade", Wave:3, ActionCompleted:false},
            {Type:"Upgrade", Wave:4, ActionCompleted:false},{Type:"Upgrade", Wave:7, ActionCompleted:false},{Type:"Sell", Wave:30, ActionCompleted:false}
        ]
    },

    ;SprintWagon2
    "Unit_2", {
        Slot:5, Pos:[540, 117], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:2, ActionCompleted:false},{Type:"Upgrade", Wave:2, ActionCompleted:false},{Type:"Upgrade", Wave:3, ActionCompleted:false},
            {Type:"Upgrade", Wave:4, ActionCompleted:false},{Type:"Upgrade", Wave:6, ActionCompleted:false},{Type:"Sell", Wave:30, ActionCompleted:false}
        ]
    },

    ;SprintWagon3
    "Unit_3", {
        Slot:5, Pos:[615, 117], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:2, ActionCompleted:false},{Type:"Upgrade", Wave:3, ActionCompleted:false},{Type:"Upgrade", Wave:4, ActionCompleted:false},
            {Type:"Upgrade", Wave:5, ActionCompleted:false},{Type:"Upgrade", Wave:5, ActionCompleted:false},{Type:"Sell", Wave:30, ActionCompleted:false}
        ]
    },

    ;StupidCoolMerchantGuy
    "Unit_4", {
        Slot:4, Pos:[707, 117], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:2, ActionCompleted:false},{Type:"Upgrade", Wave:5, ActionCompleted:false},{Type:"Upgrade", Wave:7, ActionCompleted:false},
            {Type:"Upgrade", Wave:7, ActionCompleted:false},{Type:"Upgrade", Wave:8, ActionCompleted:false},{Type:"Upgrade", Wave:9, ActionCompleted:false},
            {Type:"Upgrade", Wave:10, ActionCompleted:false}
        ]
    },

    ;Original Cha-In Spot 1
    "Unit_5", {
        Slot:1, Pos:[369, 241], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:6, ActionCompleted:false},{Type:"Sell", Wave:16, ActionCompleted:false}
        ]
    },

    ;Original Cha-In Spot 2
    "Unit_6", {
        Slot:1, Pos:[430, 241], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:6, ActionCompleted:false},{Type:"Sell", Wave:16, ActionCompleted:false}
        ]
    },

    ;Original Cha-In Spot 3
    "Unit_7", {
        Slot:1, Pos:[401, 213], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:6, ActionCompleted:false},{Type:"Sell", Wave:16, ActionCompleted:false}
        ]
    },

    ;Original Cha-In Spot 4
    "Unit_8", {
        Slot:1, Pos:[400, 244], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:6, ActionCompleted:false},{Type:"Sell", Wave:16, ActionCompleted:false}
        ]
    },

    ;Original Cha-In Spot 5
    "Unit_9", {
        Slot:1, Pos:[734, 503], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:6, ActionCompleted:false},{Type:"Upgrade", Wave:6, ActionCompleted:false},{Type:"Sell", Wave:16, ActionCompleted:false}
        ]
    },

    ; Dancing Bitch
    "Unit_10", {
        Slot:2, Pos:[386, 390], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:10, ActionCompleted:false}
        ]
    },

    ; My goat IGROS 1
    "Unit_11", {
        Slot:3, Pos:[349, 376], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:10, ActionCompleted:false},{Type:"Upgrade", Wave:11, ActionCompleted:false},{Type:"Upgrade", Wave:11, ActionCompleted:false},
            {Type:"Upgrade", Wave:11, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false},{Type:"Upgrade", Wave:13, ActionCompleted:false},
            {Type:"Upgrade", Wave:13, ActionCompleted:false},{Type:"Upgrade", Wave:14, ActionCompleted:false},{Type:"Upgrade", Wave:16, ActionCompleted:false},
            {Type:"Upgrade", Wave:22, ActionCompleted:false},{Type:"Upgrade", Wave:26, ActionCompleted:false},{Type:"Upgrade", Wave:30, ActionCompleted:false}
        ]
    },

    ; My goat IGROS 2
    "Unit_12", {
        Slot:3, Pos:[377, 353], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:10, ActionCompleted:false},{Type:"Upgrade", Wave:11, ActionCompleted:false},{Type:"Upgrade", Wave:11, ActionCompleted:false},
            {Type:"Upgrade", Wave:11, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false},{Type:"Upgrade", Wave:13, ActionCompleted:false},
            {Type:"Upgrade", Wave:13, ActionCompleted:false},{Type:"Upgrade", Wave:14, ActionCompleted:false},{Type:"Upgrade", Wave:16, ActionCompleted:false},
            {Type:"Upgrade", Wave:22, ActionCompleted:false},{Type:"Upgrade", Wave:26, ActionCompleted:false},{Type:"Upgrade", Wave:30, ActionCompleted:false}
        ]
    },

    ; My goat IGROS 3
    "Unit_13", {
        Slot:3, Pos:[412, 366], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:10, ActionCompleted:false},{Type:"Upgrade", Wave:11, ActionCompleted:false},{Type:"Upgrade", Wave:11, ActionCompleted:false},
            {Type:"Upgrade", Wave:11, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false},{Type:"Upgrade", Wave:13, ActionCompleted:false},
            {Type:"Upgrade", Wave:14, ActionCompleted:false},{Type:"Upgrade", Wave:15, ActionCompleted:false},{Type:"Upgrade", Wave:15, ActionCompleted:false},
            {Type:"Upgrade", Wave:22, ActionCompleted:false},{Type:"Upgrade", Wave:27, ActionCompleted:false}
        ]
    },

    ;unOriginal Cha-In Spot 1
    "Unit_14", {
        Slot:1, Pos:[330, 406], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:17, ActionCompleted:false},{Type:"Upgrade", Wave:19, ActionCompleted:false},{Type:"Upgrade", Wave:19, ActionCompleted:false},
            {Type:"Upgrade", Wave:19, ActionCompleted:false},{Type:"Upgrade", Wave:19, ActionCompleted:false},{Type:"Upgrade", Wave:19, ActionCompleted:false},
            {Type:"Upgrade", Wave:23, ActionCompleted:false},{Type:"Upgrade", Wave:24, ActionCompleted:false},{Type:"Upgrade", Wave:27, ActionCompleted:false},
            {Type:"Upgrade", Wave:27, ActionCompleted:false}
        ]
    },

    ;unOriginal Cha-In Spot 2
    "Unit_15", {
        Slot:1, Pos:[359, 422], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:17, ActionCompleted:false},{Type:"Upgrade", Wave:19, ActionCompleted:false},{Type:"Upgrade", Wave:19, ActionCompleted:false},
            {Type:"Upgrade", Wave:19, ActionCompleted:false},{Type:"Upgrade", Wave:19, ActionCompleted:false},{Type:"Upgrade", Wave:19, ActionCompleted:false},
            {Type:"Upgrade", Wave:23, ActionCompleted:false},{Type:"Upgrade", Wave:24, ActionCompleted:false},{Type:"Upgrade", Wave:27, ActionCompleted:false},
            {Type:"Upgrade", Wave:28, ActionCompleted:false}
        ]
    },

    ;unOriginal Cha-In Spot 3
    "Unit_16", {
        Slot:1, Pos:[395, 432], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:17, ActionCompleted:false},{Type:"Upgrade", Wave:19, ActionCompleted:false},{Type:"Upgrade", Wave:19, ActionCompleted:false},
            {Type:"Upgrade", Wave:19, ActionCompleted:false},{Type:"Upgrade", Wave:19, ActionCompleted:false},{Type:"Upgrade", Wave:19, ActionCompleted:false},
            {Type:"Upgrade", Wave:23, ActionCompleted:false},{Type:"Upgrade", Wave:24, ActionCompleted:false},{Type:"Upgrade", Wave:28, ActionCompleted:false},
            {Type:"Upgrade", Wave:28, ActionCompleted:false}
        ]
    },

    ;unOriginal Cha-In Spot 4
    "Unit_17", {
        Slot:1, Pos:[419, 405], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:17, ActionCompleted:false},{Type:"Upgrade", Wave:19, ActionCompleted:false},{Type:"Upgrade", Wave:19, ActionCompleted:false},
            {Type:"Upgrade", Wave:19, ActionCompleted:false},{Type:"Upgrade", Wave:20, ActionCompleted:false},{Type:"Upgrade", Wave:20, ActionCompleted:false},
            {Type:"Upgrade", Wave:23, ActionCompleted:false},{Type:"Upgrade", Wave:24, ActionCompleted:false},{Type:"Upgrade", Wave:29, ActionCompleted:false},
            {Type:"Upgrade", Wave:29, ActionCompleted:false}
        ]
    },

    ;unOriginal Cha-In Spot 5
    "Unit_18", {
        Slot:1, Pos:[445, 374], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:17, ActionCompleted:false},{Type:"Upgrade", Wave:20, ActionCompleted:false},{Type:"Upgrade", Wave:20, ActionCompleted:false},
            {Type:"Upgrade", Wave:20, ActionCompleted:false},{Type:"Upgrade", Wave:20, ActionCompleted:false},{Type:"Upgrade", Wave:20, ActionCompleted:false},
            {Type:"Upgrade", Wave:23, ActionCompleted:false},{Type:"Upgrade", Wave:25, ActionCompleted:false},{Type:"Upgrade", Wave:29, ActionCompleted:false},
            {Type:"Upgrade", Wave:30, ActionCompleted:false}
        ]
    },
)


global ToggleMapValues := Map(
    "NoMovementReset", true,
    "Auto-Reconnect", true,
    "SecondaryOCR", false,
    "WaveDebug", false
)

global NumberValueMap := Map()

ReturnedUIObject := CreateBaseUI(Map(
    "Main", {Title:"AVIgrosEventMacro", Video:"X", Description:"Experimental Version`nF3 : Start`nF6:Pause`nF8 : Stop`n`nMake sure to set font to times new roman in extras tab!`n`nfollow directions i sent in the discord", Version:MacroVersion, DescY:"250", MacroName:"AVIgrosEventMacro", IncludeFonts:true, MultiInstancing:false},
    "Settings", [
        {Map:UnitMap, Name:"Unit Settings", Type:"UnitUI", SaveName:"UnitSettings", IsAdvanced:false},
        {Map:ToggleMapValues, Name:"Toggle Settings", Type:"Toggle", SaveName:"ToggleSettings", IsAdvanced:false},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"AV_PUBLICTEST_IGROSEVENT_1"}
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



Main() {
    if not MacroEnabled {
        return
    }

    try {
        WinMove(,,800, 600, "ahk_exe RobloxPlayerBeta.exe")
    }
    
    if EvilSearch(PixelSearchTables["AutoStart"])[1] {
        PM_ClickPos("AutoStart")
        Sleep(200)
    }


    loop {
        Sleep(500)

        EnableWaveAutomation([30], true, 1, 30, ToggleMapValues["WaveDebug"])

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

ReturnedUIObject.BaseUI.Show()
ReturnedUIObject.BaseUI.OnEvent("Close", (*) => ExitApp())
ReturnedUIObject.EnableButton.OnEvent("Click", (*) => EnableFunction())


F3::Main()
F8::ExitApp()
F6::Pause -1
