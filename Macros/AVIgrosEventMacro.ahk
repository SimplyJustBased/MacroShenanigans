; /[V1.0.3]\

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1

#Include "%A_MyDocuments%\MacroHubFiles\Modules\BasePositionsAV.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctions.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctionsAV.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\EasyUI.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UWBOCRLib.ahk"

global MacroVersion := "1.1.0"
global PlayerPositionFromSpawn := {W:0, A:0, S:0, D:0}
global MacroEnabled := false
global UnitMap := Map(
    ; Tengons
    "Tengon 1", {Slot:1, Pos:[375, 306], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Tengon 2", {Slot:1, Pos:[375, 339], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Tengon 3", {Slot:1, Pos:[377, 372], MovementFromSpawn:[], UnitData:[], IsPlaced:false},

    ; Julias - es
    "Julias 1", {Slot:2, Pos:[335, 303], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Julias 2", {Slot:2, Pos:[333, 339], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Julias 3", {Slot:2, Pos:[331, 369], MovemeAntFromSpawn:[], UnitData:[], IsPlaced:false},

    ; Vogitas
    "Vogita 1", {Slot:3, Pos:[443, 349], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 2", {Slot:3, Pos:[443, 314], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 3", {Slot:3, Pos:[443, 388], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 4", {Slot:3, Pos:[481, 351], MovementFromSpawn:[], UnitData:[], IsPlaced:false},

    ; SprintWagons
    "SprintWagon 1", {Slot:4, Pos:[192, 236], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "SprintWagon 2", {Slot:4, Pos:[224, 208], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "SprintWagon 3", {Slot:4, Pos:[258, 190], MovementFromSpawn:[], UnitData:[], IsPlaced:false},

    ; Takaroda
    "Takaroda", {Slot:5, Pos:[184, 355], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
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

    ; VOGITIAISRTOASI
    {Unit:"Vogita 1", Action:"Placement", ActionCompleted:false},
    {Unit:"Vogita 2", Action:"Placement", ActionCompleted:false},
    {Unit:"Vogita 3", Action:"Placement", ActionCompleted:false},
    {Unit:"Vogita 4", Action:"Placement", ActionCompleted:false},

    ; Back to being money hungry x2
    {Unit:"SprintWagon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Takaroda", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Takaroda", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Takaroda", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Takaroda", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Takaroda", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Takaroda", Action:"Upgrade", ActionCompleted:false},

    ; TRI-TENGON OF DESTRUCTION
    {Unit:"Tengon 1", Action:"Placement", ActionCompleted:false},
    {Unit:"Tengon 2", Action:"Placement", ActionCompleted:false},
    {Unit:"Tengon 3", Action:"Placement", ActionCompleted:false},

    ; Upgrades of 10x ville USA
    {Unit:"Tengon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 1", Action:"Upgrade", ActionCompleted:false},

    {Unit:"Tengon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 2", Action:"Upgrade", ActionCompleted:false},

    {Unit:"Tengon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Tengon 3", Action:"Upgrade", ActionCompleted:false},

    ; Julili of doom
    {Unit:"Julias 1", Action:"Placement", ActionCompleted:false},
    {Unit:"Julias 2", Action:"Placement", ActionCompleted:false},
    {Unit:"Julias 3", Action:"Placement", ActionCompleted:false},

    ; (9x3)
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

    ; Vegetas! Save me!!!
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
    {Unit:"SprintWagon 1", AfterAction:101, Action:"Sell", IsLooped:false, LoopDelay:100000, LastDelay:0},
    {Unit:"SprintWagon 2", AfterAction:101, Action:"Sell", IsLooped:false, LoopDelay:100000, LastDelay:0},
    {Unit:"SprintWagon 3", AfterAction:101, Action:"Sell", IsLooped:false, LoopDelay:100000, LastDelay:0},
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
    "Main", {Title:"AVIgrosEventMacro", Video:"https://www.youtube.com/watch?v=xwUe6zqHPTA", Description:"F3 : Start`nF6 : Pause`nF8 : Stop", Version:MacroVersion, DescY:"250", MacroName:"AVIgrosEventMacro", IncludeFonts:true, MultiInstancing:false},
    "Settings", [
        {Map:Map("UnitMap", UnitMap, "UnitActionArray", UnitActionArray, "UnitEventArray", UnitEventArray), Name:"Unit Settings", Type:"UnitActionUI", SaveName:"UnitSettings", IsAdvanced:false},
        ; {Map:ToggleMapValues, Name:"Toggle Settings", Type:"Toggle", SaveName:"ToggleSettings", IsAdvanced:false},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"AV_PUBLICTEST_IGROSEVENT_3"}
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
    global BlowUpAndDieChallengeMrBeastV2
    global MacroEnabled

    if not MacroEnabled {
        return
    }

    CameraticView()
    Sleep(500)

    TpToSpawn()
    Sleep(500)
    
    SendEvent "{s Down}"
    Sleep(4180)
    SendEvent "{s Up}"
    Sleep(500)

    loop {
        Sleep(900)
        PM_ClickPos("VoteStartButton", 1)
        Sleep(200)
    
        ReturnedArray_1 := EnableActionAutomation(ActionAutomationSettings)

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

F5::{
    TpToSpawn()
    Sleep(800)
    
    CameraticView()
    Sleep(500)

    Sleep(200)
    SendEvent "{s Down}"
    Sleep(4180)
    SendEvent "{s Up}"
}   
