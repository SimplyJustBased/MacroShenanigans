; /[V1.0.1]\

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1

#Include "%A_MyDocuments%\MacroHubFiles\Modules\BasePositionsAV.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctions.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctionsAV.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\EasyUI.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UWBOCRLib.ahk"

; 461, 117

global MacroVersion := "1.0.1 [Experimental]"
global PlayerPositionFromSpawn := {W:0, A:0, S:0, D:0}
global MacroEnabled := false

; Placement | Upgrade | Sell
global UnitMap := Map(
    ;SprintWagon1
    "Unit_1", {
        Slot:5, Pos:[496, 130], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:27180},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:41000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:60260},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:81220},
            {Type:"Sell", Wave:0, ActionCompleted:false, Delay:650000},
        ]
    },

    ;SprintWagon2
    "Unit_2", {
        Slot:5, Pos:[499, 80], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:20230},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:27180},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:46120},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:68260},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:90000},
            {Type:"Sell", Wave:0, ActionCompleted:false, Delay:650000},
        ]
    },

    ;SprintWagon3
    "Unit_3", {
        Slot:5, Pos:[197, 185], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:20230},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:41000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:46120},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:68260},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:90000},
            {Type:"Sell", Wave:0, ActionCompleted:false, Delay:650000},
        ]
    },

    ;StupidCoolMerchantGuy
    "Unit_4", {
        Slot:4, Pos:[269, 132], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:20230},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:121000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:129000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:129000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:161000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:166000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:180500},
        ]
    },

    ;Cha-in 1
    "Unit_5", {
        Slot:2, Pos:[355, 315], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:6, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:126000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:144000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:168000},
            {Type:"Upgrade", Wave:30, ActionCompleted:false, Delay:20000},
        ]
    },
    
    ;Cha-in 2
    "Unit_6", {
        Slot:2, Pos:[336, 296], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:6, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:126000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:144000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:168000},
            {Type:"Upgrade", Wave:30, ActionCompleted:false, Delay:20000},
        ]
    },

    ;Cha-in 3
    "Unit_7", {
        Slot:2, Pos:[365, 364], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:7, ActionCompleted:false, Delay:8000},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:1000},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:1000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:126000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:144000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:168000},
            {Type:"Upgrade", Wave:30, ActionCompleted:false, Delay:20000},
        ]
    },

    ;Cha-in 4
    "Unit_8", {
        Slot:2, Pos:[345, 385], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:7, ActionCompleted:false, Delay:8000},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:1000},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:1000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:92000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:126000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:144000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:168000},
            {Type:"Upgrade", Wave:30, ActionCompleted:false, Delay:75000},
        ]
    },

    ;Tengon 1
    "Unit_9", {
        Slot:1, Pos:[342, 343], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:190000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:190000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:190000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:190000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:190000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:208000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:208000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:248000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:248000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:248000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:268000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:268000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:268000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:268000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:268000},
        ]
    },

    ;Tengon 2
    "Unit_10", {
        Slot:1, Pos:[317, 321], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:288000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:300000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:300000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:300000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:300000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:5000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:5000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:5000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:5000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:5000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:5000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:5000},
            {Type:"Target", Wave:20, ActionCompleted:false, Delay:5000},
            {Type:"Target", Wave:20, ActionCompleted:false, Delay:5000},
            {Type:"Target", Wave:20, ActionCompleted:false, Delay:5000},
        ]
    },

    ;Tengon 3
    "Unit_11", {
        Slot:1, Pos:[316, 368], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:288000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:308000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:308000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:308000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:308000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:5000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:5000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:23000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:23000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:45000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:45000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:65000},
            {Type:"Target", Wave:20, ActionCompleted:false, Delay:65000},
            {Type:"Target", Wave:20, ActionCompleted:false, Delay:65000},
            {Type:"Target", Wave:20, ActionCompleted:false, Delay:65000},
        ]
    },

    ; Haruka
    "Unit_12", {
        Slot:3, Pos:[373, 336], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:5, ActionCompleted:false, Delay:18000},
        ]
    },

    ; Croc 1
    "Unit_13", {
        Slot:6, Pos:[342, 143], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:215000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:230000},
        ]
    },

    ; Croc 2
    "Unit_14", {
        Slot:6, Pos:[478, 275], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:215000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:230000},
        ]
    },

    ; Croc 3
    "Unit_15", {
        Slot:6, Pos:[472, 430], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:215000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:230000},
        ]
    },

    ; Croc 4
    "Unit_16", {
        Slot:6, Pos:[292, 608], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:215000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Upgrade", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:230000},
            {Type:"Target", Wave:0, ActionCompleted:false, Delay:230000},
        ]
    },
)


global ToggleMapValues := Map(
    "NoMovementReset", true,
    ; "Auto-Reconnect", true,
    "SecondaryOCR", false,
    "WaveDebug", false
)

global NumberValueMap := Map()

ReturnedUIObject := CreateBaseUI(Map(
    "Main", {Title:"AVIgrosEventMacro", Video:"https://www.youtube.com/watch?v=Oq3mnED6Ym8", Description:"Public Version`nF3 : Start`nF6:Pause`nF8 : Stop`n`nMake sure to set font to times new roman in extras tab!", Version:MacroVersion, DescY:"250", MacroName:"AVIgrosEventMacro", IncludeFonts:true, MultiInstancing:false},
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

    Sleep(200)
    SendEvent "{s Down}"
    Sleep(4180)
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

ReturnedUIObject.BaseUI.Show()
ReturnedUIObject.BaseUI.OnEvent("Close", (*) => ExitApp())
ReturnedUIObject.EnableButton.OnEvent("Click", (*) => EnableFunction())


F3::Main()
F5::{
    for _UnitData, UnitObject in UnitMap {
        OutputDebug("`nInfo For " _UnitData)

        for I, V in UnitObject.UnitData {
            OutputDebug("`n[" I "]:" V.ActionCompleted)
        }
    }
}
F8::ExitApp()
F6::Pause -1
