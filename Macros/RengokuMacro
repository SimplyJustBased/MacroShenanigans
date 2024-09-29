; /[V1.0.0]\

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

global UnitMap := Map(
    ; SprintWagon 1
    "Unit_1", {
        Slot:4, Pos:[605, 230], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:3, ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:4, ActionCompleted:false, Delay:17000},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:16000},
            ; Yes i forgot a upgrade here (In the Setting-Creation video) but it still works so idc
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:0},
        ]
    },

    ; SprintWagon 2
    "Unit_2", {
        Slot:4, Pos:[691, 306], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:1, ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:4, ActionCompleted:false, Delay:1500},
            {Type:"Upgrade", Wave:5, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:0},
        ]  
    },

    ; SprintWagon 3
    "Unit_3", {
        Slot:4, Pos:[638, 462], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:2, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:4, ActionCompleted:false, Delay:1500},
            {Type:"Upgrade", Wave:5, ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:0},
        ]
    },

    ; Takaroda
    "Unit_4", {
        Slot:5, Pos:[562, 383], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:3, ActionCompleted:false, Delay:5000},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:10, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
        ]
    },

    ; Vogita 1
    "Unit_5", {
        Slot:1, Pos:[172, 260], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:3, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:17, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:18, ActionCompleted:false, Delay:2000},
        ]
    },

    ; Vogita 2
    "Unit_6", {
        Slot:1, Pos:[203, 257], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:6, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:17, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:18, ActionCompleted:false, Delay:2000},
        ]
    },

    ; Vogita 3
    "Unit_7", {
        Slot:1, Pos:[232, 253], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:6, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:17, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:18, ActionCompleted:false, Delay:2000},
        ]
    },

    ; Vogita 4
    "Unit_8", {
        Slot:1, Pos:[259, 251], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:6, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:12, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:17, ActionCompleted:false, Delay:2000},
            {Type:"Upgrade", Wave:18, ActionCompleted:false, Delay:2000},
        ]
    },

    ; Croc 1
    "Unit_9", {
        Slot:3, Pos:[564, 232], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:19, ActionCompleted:false, Delay:0},
        ]
    },

    ; Croc 2
    "Unit_10", {
        Slot:3, Pos:[580, 256], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:19, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:19, ActionCompleted:false, Delay:0},
        ]
    },

    ; Blossom
    "Unit_11", {
        Slot:2, Pos:[216, 277], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:34700},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:34700},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:34700},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:34700},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:34700},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:34700},
            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:36700},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:36700},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:36700},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:36700},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:36700},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:36700},
            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:51000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:51000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:51000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:51000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:51000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:51000},
            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:53000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:53000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:53000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:53000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:53000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:53000},
            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:54000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:54000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:54000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:54000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:54000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:54000},
            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:57000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:57000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:57000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:57000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:57000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:57000},
            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:60000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:60000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:60000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:60000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:60000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:60000},
            {Type:"Placement", Wave:20, ActionCompleted:false, Delay:63000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:63000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:63000},
            {Type:"Upgrade", Wave:20, ActionCompleted:false, Delay:63000},
            {Type:"Ability", Wave:20, ActionCompleted:false, Delay:63000},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:63000},
        ]
    },
)

global ToggleMapValues := Map(
    "NoMovementReset", true,
    "SecondaryOCR", false,
    "WaveDebug", true,
)

global NumberValueMap := Map()

F3::{
    ; loop {
    ;     WaveDetection()
    ;     Sleep(1)
    ; }

    TpToSpawn()
    Sleep(500)

    SendEvent "{w Down}"
    Sleep(400)
    SendEvent "{w Up}{d Down}"
    Sleep(2000)
    SendEvent "{d Up}{w Down}"
    Sleep(500)
    SendEvent "{w Up}"

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
