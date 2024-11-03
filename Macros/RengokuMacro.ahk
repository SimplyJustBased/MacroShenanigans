; /[V1.0.6]\

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
    "SprintWagon 1", {Slot:3, Pos:[392, 143], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "SprintWagon 2", {Slot:3, Pos:[418, 129], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "SprintWagon 3", {Slot:3, Pos:[443, 118], MovementFromSpawn:[], UnitData:[], IsPlaced:false},

    ; Vogitas
    "Vogita 1", {Slot:1, Pos:[476, 334], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 2", {Slot:1, Pos:[510, 342], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 3", {Slot:1, Pos:[476, 282], MovementFromSpawn:[], UnitData:[], IsPlaced:false},
    "Vogita 4", {Slot:1, Pos:[508, 286], MovementFromSpawn:[], UnitData:[], IsPlaced:false},

    ; Blossom
    "Blossom 1", {Slot:2, Pos:[494, 312], MovementFromSpawn:[], UnitData:[], IsPlaced:false}
)


global UnitActionArray := [
    ; Farms
    {Unit:"SprintWagon 1", Action:"Placement", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Placement", ActionCompleted:false},
    {Unit:"SprintWagon 3", Action:"Placement", ActionCompleted:false},

    ; 4 x 1 Upgrade
    {Unit:"SprintWagon 1", Action:"Upgrade", ActionCompleted:false},
    {Unit:"SprintWagon 2", Action:"Upgrade", ActionCompleted:false},
    
    {Unit:"Vogita 1", Action:"Placement", ActionCompleted:false},

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
    "BossBarBreak", true
)

global ToggleMapValues := Map(
    ; "NoMovementReset", true,
    ; "SecondaryOCR", false,
    ; "WaveDebug", true,
)

global BlowUpAndDieChallengeMrBeastV2 := [false,0,false]
global NumberValueMap := Map()

ReturnedUIObject := CreateBaseUI(Map(
    "Main", {Title:"AVRengokuMacro", Video:"https://www.youtube.com/watch?v=xwUe6zqHPTA", Description:"Public Version`n`nF3 to Start (After enabling macro)`nF6 to Pause`nF8 to Close Macro", Version:MacroVersion, DescY:"250", MacroName:"AVRengokuMacro", IncludeFonts:false, MultiInstancing:false},
    "Settings", [
        {Map:Map("UnitMap", UnitMap, "UnitActionArray", UnitActionArray, "UnitEventArray", UnitEventArray), Name:"Unit Settings", Type:"UnitActionUI", SaveName:"UnitSettings", IsAdvanced:false},
        ; {Map:ToggleMapValues, Name:"Toggle Settings", Type:"Toggle", SaveName:"ToggleSettings", IsAdvanced:false},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"AvRengokuMacroV1.1"}
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

    TpToSpawn()
    Sleep(500)

    SendEvent "{a Down}"
    Sleep(2000)
    SendEvent "{a Up}"
    Sleep(500)
    SendEvent "{s Down}"
    Sleep(1000)
    SendEvent "{s Up}"

    Sleep(200)
    CameraticView()
    Sleep(200)

    loop {
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
                if A_TickCount - BlowUpAndDieChallengeMrBeastV2[2] >= 66000 {
                    loop 20 {
                        BaseUnitAction("Blossom 1", "Placement", true, ActionAutomationSettings)
                        BaseUnitAction("Blossom 1", "Upgrade", true, ActionAutomationSettings)
                        BaseUnitAction("Blossom 1", "Upgrade", true, ActionAutomationSettings)
                        BaseUnitAction("Blossom 1", "Upgrade", true, ActionAutomationSettings)
                        Sleep(1200)
                        BaseUnitAction("Blossom 1", "Ability", true, ActionAutomationSettings)
                        Sleep(400)
                        BaseUnitAction("Blossom 1", "Sell", true, ActionAutomationSettings)
                        
                        loop 5 {
                            SendEvent "{Click, 769, 581, 1}"
                            Sleep(100) 
                        }

                        if DetectEndRoundUI() {
                            break
                        }

                        Sleep(1000)
                    }
                    BlowUpAndDieChallengeMrBeastV2[3] := true
                }
            } else if not BlowUpAndDieChallengeMrBeastV2[1] {
                if BossBarBreak() {
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
    }
}

F8::ExitApp()
F6::Pause -1

; F5::{
;     BaseUnitAction("Blossom 1", "Placement", true, ActionAutomationSettings)
;     BaseUnitAction("Blossom 1", "Upgrade", true, ActionAutomationSettings)
;     BaseUnitAction("Blossom 1", "Upgrade", true, ActionAutomationSettings)
;     BaseUnitAction("Blossom 1", "Upgrade", true, ActionAutomationSettings)
;     Sleep(600)
;     BaseUnitAction("Blossom 1", "Ability", true, ActionAutomationSettings)
; }
