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
    ; Chosos
    "Chaso 1", {Slot:1, Pos:[469, 160], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Chaso 2", {Slot:1, Pos:[501, 155], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Chaso 3", {Slot:1, Pos:[532, 150], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Chaso 4", {Slot:1, Pos:[505, 189], MovementFromSpawn:[], UnitData:[], IsPlaced:false},

    ; Julias - es
    "Julias 1", {Slot:2, Pos:[537, 180], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Julias 2", {Slot:2, Pos:[469, 198], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Julias 3", {Slot:2, Pos:[510, 217], MovemeAntFromSpawn:[], UnitData:[], IsPlaced:false},

    ; Vogitas
    "Vogita 1", {Slot:3, Pos:[546, 287], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 2", {Slot:3, Pos:[549, 326], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 3", {Slot:3, Pos:[550, 365], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 4", {Slot:3, Pos:[561, 397], MovementFromSpawn:[], UnitData:[], IsPlaced:false},

    ; SprintWagons
    "SprintWagon 1", {Slot:4, Pos:[203, 172], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "SprintWagon 2", {Slot:4, Pos:[181, 215], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "SprintWagon 3", {Slot:4, Pos:[243, 203], MovementFromSpawn:[], UnitData:[], IsPlaced:false},

    ; Takaroda
    "Takaroda", {Slot:5, Pos:[292, 282], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
)

global UnitActionArray := [
    ; Start placing money units
    {Unit:"SprintWagon 1", Action:"Placement", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Placement", ActionCompleted:false},
    {Unit:"SprintWagon 3", Action:"Placement", ActionCompleted:false},
    {Unit:"Takaroda", Action:"Placement", ActionCompleted:false},

    ; money unit upgrades of absolute destruction and death and malice and death or something
    {Unit:"SprintWagon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 3", Action:"Upgrade", ActionCompleted:false},

    ; Placing the dps of mainical usa
    {Unit:"Julias 1", Action:"Placement", ActionCompleted:false},
    {Unit:"Julias 2", Action:"Placement", ActionCompleted:false},
    {Unit:"Julias 3", Action:"Placement", ActionCompleted:false},
    {Unit:"Chaso 1", Action:"Placement", ActionCompleted:false},
    {Unit:"Chaso 2", Action:"Placement", ActionCompleted:false},
    {Unit:"Chaso 3", Action:"Placement", ActionCompleted:false},
    {Unit:"Chaso 4", Action:"Placement", ActionCompleted:false},

    ; Back to being money hungry
    {Unit:"SprintWagon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Takaroda", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Takaroda", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Takaroda", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Takaroda", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Takaroda", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Takaroda", Action:"Upgrade", ActionCompleted:false},

    ; Maxing a single chaso first (0 -> 10 [1x])
    {Unit:"Chaso 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 1", Action:"Upgrade", ActionCompleted:false},

    ; Julias levels of destruction (0 -> 4 [3x])
    {Unit:"Julias 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 3", Action:"Upgrade", ActionCompleted:false},

    ; Second Chaso Maxing (0 -> 10 [1x])
    {Unit:"Chaso 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 2", Action:"Upgrade", ActionCompleted:false},

    ; Third Chaso Maxing (0 -> 10 [1x])
    {Unit:"Chaso 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 3", Action:"Upgrade", ActionCompleted:false},
    
    ; Fourth Chaso Maxing (0 -> 10 [1x])
    {Unit:"Chaso 4", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 4", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 4", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 4", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 4", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 4", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 4", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 4", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 4", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Chaso 4", Action:"Upgrade", ActionCompleted:false},

    ; Julias O Clock (4 -> 9 [3x])
    {Unit:"Julias 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Julias 3", Action:"Upgrade", ActionCompleted:false},

    ; The glorious Ve geets
    {Unit:"Vogita 1", Action:"Placement", ActionCompleted:false},
    {Unit:"Vogita 2", Action:"Placement", ActionCompleted:false},
    {Unit:"Vogita 3", Action:"Placement", ActionCompleted:false},
    {Unit:"Vogita 4", Action:"Placement", ActionCompleted:false},

    ; WE SAYIANS HAVE NO LIMITS (0 -> 2 [4x])
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
    {Unit:"SprintWagon 1", AfterAction:96, Action:"Sell", IsLooped:false, LoopDelay:100000, LastDelay:0},
    {Unit:"SprintWagon 2", AfterAction:96, Action:"Sell", IsLooped:false, LoopDelay:100000, LastDelay:0},
    {Unit:"SprintWagon 3", AfterAction:96, Action:"Sell", IsLooped:false, LoopDelay:100000, LastDelay:0},
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
    
        ActionAutomationSettings["ActionBreakNumber"] := 96
        ReturnedArray_1 := EnableActionAutomation(ActionAutomationSettings)
        Sleep(1000)

        TotalActions := ReturnedArray_1[1]
        BreakID := ReturnedArray_1[2]

        SendEvent "{A Down}"
        Sleep(1000)
        SendEvent "{A Up}"
        Sleep(300)
        SendEvent "{S Down}"
        Sleep(2000)
        SendEvent "{S Up}"

        ActionAutomationSettings["ActionBreakNumber"] := -1
        ActionAutomationSettings["PreviousCompletedActions"] := TotalActions
        ReturnedArray_2 := EnableActionAutomation(ActionAutomationSettings)
        ActionAutomationSettings["PreviousCompletedActions"] := 0

        Sleep(300)
        loop {
            if DetectEndRoundUI() {
                break
            }

            SendEvent "{Click, 769, 581, 1}"
            Sleep(100)
        }
        
        Sleep(1000)
        PM_ClickPos("RetryButton", 1)
        ResetActions()
    }
}

F8::ExitApp()
F6::Pause -1
