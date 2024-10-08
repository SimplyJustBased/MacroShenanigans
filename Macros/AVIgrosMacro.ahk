; /[V1.0.8]\

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

; Placement | Upgrade | Sell
global UnitMap := Map(
    "Unit_1", {
        Slot:1, 
        Pos:[152, 150], 
        UnitData:[
            {Type:"Placement", Wave:4, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false}
        ], 
        MovementFromSpawn:[
            {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
        ]
    },
    "Unit_2", {
        Slot:1, 
        Pos:[152, 192], 
        UnitData:[
            {Type:"Placement", Wave:5, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false}
        ], 
        MovementFromSpawn:[
            {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
        ]
    },
    "Unit_3", {
        Slot:1, 
        Pos:[152, 262], 
        UnitData:[
            {Type:"Placement", Wave:6, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false}
        ], 
        MovementFromSpawn:[
            {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
        ]
    },
    "Unit_4", {
        Slot:1, 
        Pos:[152, 305], 
        UnitData:[
            {Type:"Placement", Wave:7, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false},{Type:"Upgrade", Wave:12, ActionCompleted:false}
        ], 
        MovementFromSpawn:[
            {Key:"A", TimeDown:700, Delay:200}, {Key:"S", TimeDown:400, Delay:200}
        ]
    },
)

global ToggleMapValues := Map(
    "NoMovementReset", true,
    "Auto-Reconnect", true,
    "SecondaryOCR", false,
)

global NumberValueMap := Map(
    "SlotForStatues", 2,
)

ReturnedUIObject := CreateBaseUI(Map(
    "Main", {Title:"AV Igros Macro", Video:"X", Description:"Public Release Version`nF3 : Start`nF6:Pause`nF8 : Stop`n`nMake sure to set font to times new roman in extras tab!`n`nI wish you the best of luck getting igros", Version:MacroVersion, DescY:"250", MacroName:"AVIgrosMacro", IncludeFonts:true, MultiInstancing:false},
    "Settings", [
        {Map:UnitMap, Name:"Unit Settings", Type:"UnitUI", SaveName:"UnitSettings", IsAdvanced:false},
        {Map:ToggleMapValues, Name:"Toggle Settings", Type:"Toggle", SaveName:"ToggleSettings", IsAdvanced:false},
        {Map:NumberValueMap, Name:"Number Settings", Type:"Number", SaveName:"NumberSettings", IsAdvanced:false},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"AV_PublicTest_Igros_1"}
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

StatueDetection(Num) {
    TArgs := EvilArray[Num]
    
    return (PixelSearch(&u, &u2, TArgs[1], TArgs[2], TArgs[3], TArgs[4], 0x47FFFF, 10))
}

EvilArray := [
    [18, 139, 240, 264],
    [18, 139, 240, 264],
    [33, 105, 261, 197],

    [539, 45, 801, 389],
    [539, 45, 801, 389],
    [448, 42, 667, 223],

    [510, 313, 802, 614],
    [510, 313, 802, 614],
    [510, 232, 804, 624],

    [8, 235, 226, 506],
    [8, 280, 170, 568],
    [20, 395, 260, 611],
]

RouteStatues(Quadrant) {
    Inner(Num := 1) {
        Sleep(200)
        Result2 := StatueDetection(Num)
        Sleep(200)
        DbJump()
        Sleep(125)
        Result1 := StatueDetection(Num)
        Sleep(200)

        if Result1 or Result2 {
            SendEvent "{" NumberValueMap["SlotForStatues"] "}"
            Sleep(200)
            SendEvent "{Click, 411, 344, 0}"
            Sleep(200)
            SendEvent "{Click, 411, 344, 1}"
            Sleep(100)
            SendEvent "{Click, 231, 266, 0}"
            Sleep(100)
            SendEvent "{Click, 231, 266, 1}"
            ; OutputDebug("Found")
        }
    }

    switch Quadrant {
        case 1:
            SendEvent "{A Down}{W Down}"
            Sleep(1200)
            SendEvent "{W Up}"
            Sleep(3300)
            SendEvent "{A Up}"
            Sleep(200)
            SendEvent "{D Down}{W Down}"
            Sleep(600)
            SendEvent "{D Up}{W Up}"
            Inner(1)
            DbJump()
            Sleep(200)
            SendEvent "{W Down}"
            Sleep(700)
            SendEvent "{D Down}"
            Sleep(800)
            SendEvent "{D Up}{W Up}"
            Inner(2)
            Sleep(200)
            SendEvent "{D Down}{W Down}"
            Sleep(1600)
            SendEvent "{D Up}{W Up}"
            Inner(3)
        case 2:
            SendEvent "{D Down}{W Down}"
            Sleep(1200)
            SendEvent "{W Up}"
            Sleep(3300)
            SendEvent "{D Up}"
            Sleep(200)
            SendEvent "{A Down}{W Down}"
            Sleep(600)
            SendEvent "{A Up}{W Up}"
            Inner(4)
            DbJump()
            Sleep(200)
            SendEvent "{W Down}"
            Sleep(700)
            SendEvent "{A Down}"
            Sleep(800)
            SendEvent "{A Up}{W Up}"
            Inner(5)
            Sleep(200)
            SendEvent "{A Down}{W Down}"
            Sleep(1600)
            SendEvent "{A Up}{W Up}"
            Inner(6)
        case 3:
            SendEvent "{D Down}{S Down}"
            Sleep(1200)
            SendEvent "{S Up}"
            Sleep(3300)
            SendEvent "{D Up}"
            Sleep(200)
            SendEvent "{A Down}{S Down}"
            Sleep(600)
            SendEvent "{A Up}{S Up}"
            Inner(7)
            DbJump()
            Sleep(200)
            SendEvent "{S Down}"
            Sleep(700)
            SendEvent "{A Down}"
            Sleep(800)
            SendEvent "{A Up}{S Up}"
            Inner(8)
            Sleep(200)
            SendEvent "{A Down}{S Down}"
            Sleep(1600)
            SendEvent "{A Up}{S Up}"
            Inner(9)
        case 4:
            SendEvent "{A Down}{S Down}"
            Sleep(1200)
            SendEvent "{S Up}"
            Sleep(3300)
            SendEvent "{A Up}"
            Sleep(200)
            SendEvent "{D Down}{S Down}"
            Sleep(600)
            SendEvent "{D Up}{S Up}"
            Inner(10)
            DbJump()
            Sleep(200)
            SendEvent "{S Down}"
            Sleep(700)
            SendEvent "{D Down}"
            Sleep(800)
            SendEvent "{D Up}{S Up}"
            Inner(11)
            Sleep(200)
            SendEvent "{D Down}{S Down}"
            Sleep(1600)
            SendEvent "{D Up}{S Up}"
            Inner(12)
    }

    Sleep(200)
    TpToSpawn()
}

Reconnection() {
    if not ToggleMapValues["Auto-Reconnect"] {
        return false
    }

    if ReconnecticalNightmares() {
        Sleep(400)
        PM_ClickPos("LegendStagesButton_Select")
        Sleep(400)
        PM_ClickPos("Dungeon_2_Select")
        Sleep(400)
        PM_ClickPos("Act3_Igros_Select")
        Sleep(400)
        PM_ClickPos("ConfirmButton")
        Sleep(600)
        PM_ClickPos("QueueStartButton")
        SetPixelSearchLoop("AutoStart", 90000, 1)
        SendEvent "{Tab Down}{Tab Up}"
        Sleep(200)
        PM_ClickPos("AutoStart")
        Sleep(200)
        return true
    }

    return false

}

Main() {
    if not MacroEnabled {
        return
    }
    

    try {
        WinMove(,,800, 600, "ahk_exe RobloxPlayerBeta.exe")
    }
    
    CameraticView()
    Sleep(200)

    if EvilSearch(PixelSearchTables["AutoStart"])[1] {
        PM_ClickPos("AutoStart")
        Sleep(200)
    }


    loop {
        if Reconnection() {
            continue
        }

        TpToSpawn()
        Sleep(500)

        EnableWaveAutomation([15], true, 1, 15)
        if Reconnection() {
            ResetActions()
            continue
        }

        if not DetectEndRoundUI() {
            TpToSpawn()
            Sleep(500)
            RouteStatues(1)
            Sleep(500)
            RouteStatues(2)
            Sleep(500)
            RouteStatues(3)
            Sleep(500)
            RouteStatues(4)
        }

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
