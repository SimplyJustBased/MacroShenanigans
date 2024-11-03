; /[V1.0.10]\

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1

#Include "%A_MyDocuments%\MacroHubFiles\Modules\BasePositionsAV.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctions.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctionsAV.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\EasyUI.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UWBOCRLib.ahk"

global MacroVersion := "1.0.2"
global PlayerPositionFromSpawn := {W:0, A:0, S:0, D:0}
global MacroEnabled := false
global UnitMap := Map(
    ; SprintWagons
    "SprintWagon 1", {Slot:3, Pos:[569, 260], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "SprintWagon 2", {Slot:3, Pos:[528, 259], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "SprintWagon 3", {Slot:3, Pos:[489, 257], MovementFromSpawn:[], UnitData:[], IsPlaced:false},

    ; Vogitas
    "Vogita 1", {Slot:1, Pos:[192, 147], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 2", {Slot:1, Pos:[228, 145], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 3", {Slot:1, Pos:[190, 180], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 4", {Slot:1, Pos:[227, 180], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
)


global UnitActionArray := [
    ; Farms
    {Unit:"SprintWagon 1", Action:"Placement", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Placement", ActionCompleted:false},
    {Unit:"SprintWagon 3", Action:"Placement", ActionCompleted:false},

    {Unit:"Vogita 1", Action:"Placement", ActionCompleted:false},

    ; 4 x 1 Upgrade
    {Unit:"SprintWagon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 3", Action:"Upgrade", ActionCompleted:false},

    {Unit:"Vogita 2", Action:"Placement", ActionCompleted:false},
    {Unit:"Vogita 3", Action:"Placement", ActionCompleted:false},
    {Unit:"Vogita 4", Action:"Placement", ActionCompleted:false},

    {Unit:"SprintWagon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 3", Action:"Upgrade", ActionCompleted:false},

    {Unit:"Vogita 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 4", Action:"Upgrade", ActionCompleted:false},

    {Unit:"Vogita 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 4", Action:"Upgrade", ActionCompleted:false},

    {Unit:"Vogita 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 4", Action:"Upgrade", ActionCompleted:false},

    {Unit:"Vogita 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 4", Action:"Upgrade", ActionCompleted:false},
]

global UnitEventArray := [
    ; {Unit:"Igros 1", AfterAction:25, Action:"Sell", IsLooped:false, LoopDelay:100000, LastDelay:0}
]

global WaveAutomationSettings := Map(
    ; "WavesToBreak", [],
    ; "BreakOnLose", true,
    ; "WaveDetectionRange", 1,
    ; "MaxWave", 35,
    ; "DelayBreakTime", 0,
    ; "Debug", false,
    ; "EnableSecondaryJump", true,
    ; "WaveCheckDelays", {},
    ; "TimedWaveDelays", {}
)

global ActionAutomationSettings := Map(
    "ActionBreakNumber", -1,
    "PreviousCompletedActions", 0,
    "BossBarBreak_Double", true
)

global ToggleMapValues := Map(
    ; "NoMovementReset", true,
    ; "SecondaryOCR", false,
    ; "WaveDebug", true,
)

global NumberValueMap := Map(
    "SlotForStatues", 2,
)

global BlowUpAndDieChallengeMrBeastV2 := [false,0,false]

ReturnedUIObject := CreateBaseUI(Map(
    "Main", {Title:"AvIgrosMacro", Video:"https://www.youtube.com/watch?v=xwUe6zqHPTA", Description:"Public Version`n`nF3 to Start (After enabling macro)`nF6 to Pause`nF8 to Close Macro", Version:MacroVersion, DescY:"250", MacroName:"AvIgrosMacro", IncludeFonts:false, MultiInstancing:false},
    "Settings", [
        {Map:Map("UnitMap", UnitMap, "UnitActionArray", UnitActionArray, "UnitEventArray", UnitEventArray), Name:"Unit Settings", Type:"UnitActionUI", SaveName:"UnitSettings", IsAdvanced:false},
        {Map:NumberValueMap, Name:"Number Settings", Type:"Number", SaveName:"NumberSettings", IsAdvanced:false},
        ; {Map:ToggleMapValues, Name:"Toggle Settings", Type:"Toggle", SaveName:"ToggleSettings", IsAdvanced:false},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"AvIgrosMacroV1.1"}
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


ReturnedUIObject.BaseUI.Show()
ReturnedUIObject.BaseUI.OnEvent("Close", (*) => ExitApp())
ReturnedUIObject.EnableButton.OnEvent("Click", (*) => EnableFunction())

F3::{
    global BlowUpAndDieChallengeMrBeastV2
    global MacroEnabled

    global ____BBDCHECK
    global ____BBDTIMER

    if not MacroEnabled {
        return
    }

    Sleep(200)
    CameraticView()
    Sleep(200)

    loop {
        TpToSpawn()
        Sleep(500)

        Sleep(500)
        PM_ClickPos("VoteStartButton", 1)
        Sleep(200)

        ReturnedArray_1 := EnableActionAutomation(ActionAutomationSettings)
        BreakID := ReturnedArray_1[2]

        loop {
            if DetectEndRoundUI() {
                break
            }

            if BlowUpAndDieChallengeMrBeastV2[1] and not BlowUpAndDieChallengeMrBeastV2[3] {
                TpToSpawn()
                Sleep(500)
                RouteStatues(1)
                Sleep(500)
                RouteStatues(2)
                Sleep(500)
                RouteStatues(3)
                Sleep(500)
                RouteStatues(4)

                BlowUpAndDieChallengeMrBeastV2[3] := true
            } else if not BlowUpAndDieChallengeMrBeastV2[1] {
                if BossBarBreak_Double() {
                    BlowUpAndDieChallengeMrBeastV2[1] := true
                    BlowUpAndDieChallengeMrBeastV2[2] := A_TickCount
                }
            }

            SendEvent "{Click, 769, 581, 1}"
            Sleep(100)
        }
        
        Sleep(1000)
        PM_ClickPos("RetryButton", 1)
        ResetActions()
        global BlowUpAndDieChallengeMrBeastV2 := [false,0,false]
        global ____BBDCHECK := false
    }
}

F8::ExitApp()
F6::Pause -1

F5::{
    loop {
        if BossBarBreak() {
            ToolTip("Found Pixel")
        }
    }
}
