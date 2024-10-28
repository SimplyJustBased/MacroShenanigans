; /[V1.0.1]\

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1

#Include "%A_MyDocuments%\MacroHubFiles\Modules\BasePositionsAV.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctions.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctionsAV.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\EasyUI.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UWBOCRLib.ahk"

global MacroVersion := "1.0.1"
global PlayerPositionFromSpawn := {W:0, A:0, S:0, D:0}
global MacroEnabled := false
global UnitMap := Map(
    ; SprintWagons
    "SprintWagon 1", {Slot:3, Pos:[236, 412], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "SprintWagon 2", {Slot:3, Pos:[304, 410], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "SprintWagon 3", {Slot:3, Pos:[298, 341], MovementFromSpawn:[], UnitData:[], IsPlaced:false},

    ; Vogitas
    "Vogita 1", {Slot:2, Pos:[363, 385], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 2", {Slot:2, Pos:[452, 389], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 3", {Slot:2, Pos:[364, 297], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 4", {Slot:2, Pos:[453, 298], MovementFromSpawn:[], UnitData:[], IsPlaced:false},

    ; Igrises
    "Igros 1", {Slot:1, Pos:[478, 456], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Igros 2", {Slot:1, Pos:[400, 461], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Igros 3", {Slot:1, Pos:[484, 394], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
)

global UnitActionArray := [
    ; Vogitas
    {Unit:"Vogita 1", Action:"Placement", ActionCompleted:false},
    {Unit:"Vogita 2", Action:"Placement", ActionCompleted:false},
    {Unit:"Vogita 3", Action:"Placement", ActionCompleted:false},
    {Unit:"Vogita 4", Action:"Placement", ActionCompleted:false},

    ; Farms
    {Unit:"SprintWagon 1", Action:"Placement", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Placement", ActionCompleted:false},
    {Unit:"SprintWagon 3", Action:"Placement", ActionCompleted:false},

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

    ; Igris
    {Unit:"Igros 1", Action:"Placement", ActionCompleted:false},
    {Unit:"Igros 2", Action:"Placement", ActionCompleted:false},
    {Unit:"Igros 3", Action:"Placement", ActionCompleted:false},

    ; Upgrade 1 x 2
    {Unit:"Igros 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 3", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 2", Action:"Upgrade", ActionCompleted:false},
    {Unit:"Igros 3", Action:"Upgrade", ActionCompleted:false},
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
    "FingerCheckBreak", true
)

global ToggleMapValues := Map(
    "NoMovementReset", true,
    "SecondaryOCR", false,
    "WaveDebug", true,
)

global BlowUpAndDieChallengeMrBeastV2 := [false,0,false]
global NumberValueMap := Map()

ReturnedUIObject := CreateBaseUI(Map(
    "Main", {Title:"AVInfSquared", Video:"https://www.youtube.com/watch?v=xwUe6zqHPTA", Description:"Experimental Version`nF3 : Start`nF6 : Pause`nF8 : Stop", Version:MacroVersion, DescY:"250", MacroName:"AVInfSquared", IncludeFonts:true, MultiInstancing:false},
    "Settings", [
        {Map:Map("UnitMap", UnitMap, "UnitActionArray", UnitActionArray, "UnitEventArray", UnitEventArray), Name:"Unit Settings", Type:"UnitActionUI", SaveName:"UnitSettings", IsAdvanced:false},
        ; {Map:ToggleMapValues, Name:"Toggle Settings", Type:"Toggle", SaveName:"ToggleSettings", IsAdvanced:false},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"AV_SHIBUYATEST_1"}
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


        PM_ClickPos("VoteStartButton", 1)
        Sleep(200)
    
        ActionAutomationSettings["ActionBreakNumber"] := 4
        ReturnedArray_1 := EnableActionAutomation(ActionAutomationSettings)

        TotalActions := ReturnedArray_1[1]
        BreakID := ReturnedArray_1[2]

        Sleep(300)
    
        SendEvent "{A Down}"
        Sleep(630)
        SendEvent "{A Up}"
        Sleep(100)
        SendEvent "{W Down}"
        Sleep(6000)
        SendEvent "{W Up}"
        Sleep(100)
        SendEvent "{D Down}"
        Sleep(300)
        SendEvent "{D Up}"
    
        ActionAutomationSettings["ActionBreakNumber"] := -1
        ActionAutomationSettings["PreviousCompletedActions"] := TotalActions
        ReturnedArray_2 := EnableActionAutomation(ActionAutomationSettings)
        ActionAutomationSettings["PreviousCompletedActions"] := 0
        Sleep(300)
    
        if ReturnedArray_2[2] = 100 {
            SellAllUnits()
            BlowUpAndDieChallengeMrBeastV2[3] := true
        }

        loop {
            if DetectEndRoundUI() {
                break
            }

            SendEvent "{Click,416, 156, 1}"
            Sleep(100)

            if BlowUpAndDieChallengeMrBeastV2[1] and not BlowUpAndDieChallengeMrBeastV2[3] {
                if A_TickCount - BlowUpAndDieChallengeMrBeastV2[2] >= 200000 {
                    SellAllUnits()
                    BlowUpAndDieChallengeMrBeastV2[3] := true
                }
            } else if not BlowUpAndDieChallengeMrBeastV2[1] {
                if PresenceInShibuya() {
                    BlowUpAndDieChallengeMrBeastV2[1] := true
                    BlowUpAndDieChallengeMrBeastV2[2] := A_TickCount
                }
            }
        }
        
        Sleep(1000)
        PM_ClickPos("RetryButton", 1)
        ResetActions()
        BlowUpAndDieChallengeMrBeastV2 := [false,0,false]
    }
}

F8::ExitApp()
F6::Pause -1
