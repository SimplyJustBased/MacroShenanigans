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
    ; SprintWagons
    "SprintWagon 1", {Slot:2, Pos:[260, 201], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "SprintWagon 2", {Slot:2, Pos:[260, 235], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "SprintWagon 3", {Slot:2, Pos:[195, 202], MovementFromSpawn:[], UnitData:[], IsPlaced:false},

    ; Vogitas
    "Vogita 1", {Slot:1, Pos:[533, 192], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 2", {Slot:1, Pos:[536, 158], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 3", {Slot:1, Pos:[531, 226], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 4", {Slot:1, Pos:[493, 189], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
)

global UnitActionArray := [
    ; Vogitas
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
    {Unit:"SprintWagon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 3", Action:"Upgrade", ActionCompleted:false},


    {Unit:"Vogita 2", Action:"Placement", ActionCompleted:false},
    {Unit:"Vogita 3", Action:"Placement", ActionCompleted:false},
    {Unit:"Vogita 4", Action:"Placement", ActionCompleted:false},

    ; Vogita Upgrade
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
    {Unit:"Vogita 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Vogita 4", Action:"Upgrade", ActionCompleted:false},
]

global UnitEventArray := [
    ; {Unit:"Igros 1", AfterAction:25, Action:"Sell", IsLooped:false, LoopDelay:100000, LastDelay:0}
]

global WaveAutomationSettings := Map(
    "WavesToBreak", [],
    "BreakOnLose", true,
    "WaveDetectionRange", 1,
    "MaxWave", 35,
    "DelayBreakTime", 0,
    "Debug", false,
    "EnableSecondaryJump", true,
    "WaveCheckDelays", {},
    "TimedWaveDelays", {}
)

global ActionAutomationSettings := Map(
    "ActionBreakNumber", -1,
    "PreviousCompletedActions", 0,
    "FingerCheckBreak", false
)

global ToggleMapValues := Map(
    "NoMovementReset", true,
    "SecondaryOCR", false,
    "WaveDebug", true,
)

global BlowUpAndDieChallengeMrBeastV2 := [false,0,false]
global NumberValueMap := Map()

ReturnedUIObject := CreateBaseUI(Map(
    "Main", {Title:"AVShibuyaLegend", Video:"https://www.youtube.com/watch?v=xwUe6zqHPTA", Description:"Experimental Version`nF3 : Start`nF6 : Pause`nF8 : Stop", Version:MacroVersion, DescY:"250", MacroName:"AVShibuyaLegend", IncludeFonts:true, MultiInstancing:false},
    "Settings", [
        {Map:Map("UnitMap", UnitMap, "UnitActionArray", UnitActionArray, "UnitEventArray", UnitEventArray), Name:"Unit Settings", Type:"UnitActionUI", SaveName:"UnitSettings", IsAdvanced:false},
        ; {Map:ToggleMapValues, Name:"Toggle Settings", Type:"Toggle", SaveName:"ToggleSettings", IsAdvanced:false},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"AV_LStage_1_3"}
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

SellAllUnits() {
    SendEvent 'F'
    Sleep(650)
    SendEvent "{Click, 627, 595, 0}"
    Sleep(15)
    SendEvent "{Click, 627, 595, 1}"
    Sleep(400)
    SendEvent "{Click, 326, 352, 0}"
    Sleep(15)
    SendEvent "{Click, 326, 352, 1}"
    Sleep(500)
    SendEvent 'F'
}

ReturnedUIObject.BaseUI.Show()
ReturnedUIObject.BaseUI.OnEvent("Close", (*) => ExitApp())
ReturnedUIObject.EnableButton.OnEvent("Click", (*) => EnableFunction())

F3::{
    global BlowUpAndDieChallengeMrBeastV2
    global MacroEnabled

    if not MacroEnabled {
        return
    }

    CameraticView()
    Sleep(500)

    loop {
        TpToSpawn()
        Sleep(500)

        SendEvent "{A Down}"
        Sleep(2000)
        SendEvent "{A Up}"

        PM_ClickPos("VoteStartButton", 1)
        Sleep(200)
    
        ReturnedArray_1 := EnableActionAutomation(ActionAutomationSettings)

        loop {
            if DetectEndRoundUI() {
                break
            }

            SendEvent "{Click,416, 156, 1}"
            Sleep(100)
        }
        
        Sleep(1000)
        PM_ClickPos("RetryButton", 1)
        ResetActions()
    }
}

F8::ExitApp()
F6::Pause -1

F5::{
    SendEvent "{A Down}"
    Sleep(2000)
    SendEvent "{A Up}"
}   
