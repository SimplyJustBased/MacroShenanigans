/**
 * @param TableInfo [NameFromPosMap, Color, Variation, ID, Re-Name]
 * 
 * ID | 1 = Has TL/BR values | 2 = No TL\BR Values
 */
____PSCreationMap := [
    ["RetryButton", 0xD7CD03, 15, 1],
    ["ReturnToLobby", 0x1EB8E1, 15, 1],
    ["StoreCheck", 0x3D0506, 5, 1], ; We use the store check for when we reconnect to make sure we are actually in game / loaded in
    ["QueueLeaveButton", 0xBD3033, 3, 1],
    ["ConfirmButton", 0x4FDA4B, 3, 1],
    ["AutoStart", 0x04EE00, 3, 1],
    ["SettingsX", 0xE13C3E, 5, 1],
    ["UnitXPixel", 0xD3393C, 12, 2, "UnitX"],
    ["ResultBackgroundCheck1", 0x141414, 3, 2],
    ["ResultBackgroundCheck2", 0x030303, 3, 2],
    ["AutoSkipWavesToggle", 0x511818, 15, 2],
    ["DisableCameraShakeToggle", 0x511818, 15, 2],
    ["DisconnectBG_LS", 0x393B3D, 3, 2],
    ["DisconnectBG_RS", 0x393B3D, 3, 2],
    ["ReconnectButton", 0xFFFFFF, 3, 2],
    ["UnitAbilityToggle", 0x511818, 3, 2],
    ["0.9xConfirm", 0x53DC4D, 15, 2],
    ["0.9xLeave", 0xC2393C, 15, 2],
    ["UnitUpgradeGreenCheck", 0x39D038, 4, 1],
    ["BossBarPixel", 0xE62E30, 20, 2],
    ["HairColorSukuna", 0x76524D, 1, 1],
    ["SkinColorSukuna", 0xE4B28E, 2, 1],
]

DetectEndRoundUI() {
    Arg1 := EvilSearch(PixelSearchTables["RetryButton"])[1]
    Arg2 := EvilSearch(PixelSearchTables["ReturnToLobby"])[1]
    Arg3 := EvilSearch(PixelSearchTables["ResultBackgroundCheck1"])[1]
    Arg4 := EvilSearch(PixelSearchTables["ResultBackgroundCheck2"])[1]

    AddArgAmount := (Arg1 + Arg2 + Arg3 + Arg4)

    if AddArgAmount >= 3 {
        return true
    }

    return false
}

global WAVE_DETECTION_CD := 0
global LAST_WAVE_DETECTION_RESULT := 0
global ChosenDetection := 1

WaveSetDetection(LoopAmount := 3) {
    global ChosenDetection
    Obj1_Points := 0 
    Obj2_Points := 0
    Obj3_Points := 0

    loop LoopAmount {
        OCRResult := OCR.FromWindow("ahk_exe RobloxPlayerBeta.exe",,1,OCRObject1, 0)


        if OCRResult.Text != "" and RegExMatch(StrReplace(OCRResult.Text, "o", "0"), "[\d]{1,2}") {
            OutputDebug("`n1++")

            Obj1_Points++
        }
    }

    loop LoopAmount {
        OCRResult := OCR.FromWindow("ahk_exe RobloxPlayerBeta.exe",,1,OCRObject2, 0)


        if OCRResult.Text != "" and RegExMatch(StrReplace(OCRResult.Text, "o", "0"), "[\d]{1,2}") {
            OutputDebug("`n2++")

            Obj2_Points++
        }
    }

    loop LoopAmount {
        OCRResult := OCR.FromWindow("ahk_exe RobloxPlayerBeta.exe",,2,OCRObject3, 0)


        if OCRResult.Text != "" and RegExMatch(StrReplace(OCRResult.Text, "o", "0"), "[\d]{1,2}") {
            OutputDebug("`n3++")
            Obj3_Points++
        }
    }

    if Obj1_Points < Obj2_Points and Obj3_Points <= Obj2_Points {
        ChosenDetection := 2
        OutputDebug("`n2 Succeded")
    } else if Obj1_Points > Obj2_Points and Obj1_Points >= Obj3_Points{
        ChosenDetection := 1
        OutputDebug("`n1 Succeded")
    } else {
        ChosenDetection := 3
        OutputDebug("`n3 Succeded")

    }
}

global OCRObject1 := {
    X:106, Y:54, W:125, H:30, Size:1
}

global OCRObject2 := {
    X:103, Y:99, W:125, H:30, Size:1
}

global OCRObject3 := {
    X:101, Y:30, W:124, H:120, Size:2
}

WaveDetection(JumpOnFail, CurrentWave, WaveDetectionRange, FailureAmount := 0) {
    global LAST_WAVE_DETECTION_RESULT
    global OCRObject1
    global OCRObject2
    global OCRObject3

    OCROBJECTARRAY := [OCRObject1, OCRObject2, OCRObject3]
    TextObject := {Found:false, Number:0}
    FailureCondition := SecondaryFailureCondition := false

    loop {
        SecondaryChosen := ChosenDetection

        try {
            if JumpOnFail and FailureCondition {
                SendEvent "{Space Down}{Space Up}"
                Sleep(150)

                if SecondaryFailureCondition {
                    SendEvent "{Space Down}{Space Up}"
                }
            }

            NumericalArray := []
            OCRResult := ""

            ; if FailureAmount > 3 {
            ;     SecondaryChosen := 3
            ; }

            if FailureAmount > 20 {
                SendEvent "{Click, 787, 583, 1}"
                global CurrentOpenUnit := "nil"
                Sleep(20)
            }

            if ToggleMapValues.Has("SecondaryOCR") and ToggleMapValues["SecondaryOCR"] {
                WinGetPos(&XPos, &Ypos, &XWidth, &YWidth, "ahk_exe RobloxPlayerBeta.exe")
    
                OCRResult := OCR.FromRect(XPos+101, Ypos+30, 124, 120)
            } else {
                OCRResult := OCR.FromWindow("ahk_exe RobloxPlayerBeta.exe",,OCROBJECTARRAY[SecondaryChosen].Size,OCROBJECTARRAY[SecondaryChosen], 0)
            }

            if ToggleMapValues.Has("WaveDebug") and ToggleMapValues["WaveDebug"] {
                switch ToggleMapValues.Has("SecondaryOCR") and ToggleMapValues["SecondaryOCR"] {
                    case true:
                        OCRResult.Highlight(, -2000)
                    case false:
                        OCRResult.Highlight({X:0,Y:0,W:OCROBJECTARRAY[SecondaryChosen].W,H:OCROBJECTARRAY[SecondaryChosen].H}, -2000)
                }

                ToolTip("Found Text: " OCRResult.Text, 13, 640, 4)
                OutputDebug(OCRResult.Text)
            }

            StartingString := StrReplace(OCRResult.Text, "o", "0")
            StartingString := StrReplace(StartingString, "I", "1")

            loop {
                if RegExMatch(StartingString, "[\d]{1,2}", &Returned) {
                    NumericalArray.Push(Returned[])
                    StartingString := SubStr(StartingString, Returned.Pos + Returned.Len)
                } else {
                    break
                }
            }

            if NumericalArray.Length >= 1 {
                TextObject.NumberArray := NumericalArray
                TextObject.Found := true
            }

            if JumpOnFail and FailureCondition {
                Sleep(700)
                FailureCondition := true
                SecondaryFailureCondition := true
            }
        } catch as E {
            FailureCondition := true
            TextObject.Found := false
            TextObject.NumberArray := []
        }

        if TextObject.Found {
            SecondaryFailureCondition := false
            for _, NumericalNumber in TextObject.NumberArray {
                if NumericalNumber > CurrentWave and (not (NumericalNumber > CurrentWave + WaveDetectionRange)) {
                    if LAST_WAVE_DETECTION_RESULT = NumericalNumber {
                        return NumericalNumber
                    } else {
                        LAST_WAVE_DETECTION_RESULT := NumericalNumber
                        TextObject.Found := false
                        TextObject.NumberArray := []
                    }
                }
            }
        } else {
            FailureCondition := true
        }

        if A_Index > 5 {
            return 0
        }
    }
}

DbJump() {
    SendEvent "{Space Down}{Space Up}"
    Sleep(150)
    SendEvent "{Space Down}{Space Up}"
    Sleep(10)
    SendEvent "{Space Down}{Space Up}"
    Sleep(10)
    SendEvent "{Space Down}{Space Up}"
    Sleep(10)
    SendEvent "{Space Down}{Space Up}"
    Sleep(10)
}

CameraticView() {
    loop 15 {
        SendEvent "{WheelDown}"
        Sleep(10)
    }
    
    PM_ClickPos("CamSet1", "Right Down")
    Sleep(200)
    PM_ClickPos("CamSet2", "Right Up")

}

TpToSpawn() {
    SetPixelSearchLoop("SettingsX", 6000, 1, PM_GetPos("SettingButton"),,,600)
    Sleep(400)
    PM_ClickPos("SettingMiddle")
    Sleep(300)
    PM_ClickPos("TeleportToSpawnButton")
    Sleep(200)
    loop 3 {
        PM_ClickPos("SettingsX")
        Sleep(50)
    }

    global PlayerPositionFromSpawn := {W:0, A:0, S:0, D:0}
}

ResetActions() {
    for _UnitName, UnitObject in UnitMap {
        for _, ActionObject in UnitObject.UnitData {
            ActionObject.ActionCompleted := false
        }
    }

    try {
        for _, ActionObject in UnitActionArray {
            ActionObject.ActionCompleted := false
        }
    }
}

_EnableWaveAutomation_Helper_UnitUICheck(CurrentOpenUnit, _UnitName, UnitObject) {
    SubtractiveOffset := 0

    if not CurrentOpenUnit = _UnitName {
        if EvilSearch(PixelSearchTables["UnitX"])[1] {
            PM_ClickPos("UnitX", 1)
            Sleep(100)
        }

        loop {
            loop 3 {
                SendEvent "{Click, " UnitObject.Pos[1] + SubtractiveOffset ", " UnitObject.Pos[2] + SubtractiveOffset ", 0}"
                Sleep(15)
            }
            Sleep(15)
            SendEvent "{Click, " UnitObject.Pos[1] + SubtractiveOffset ", " UnitObject.Pos[2] + SubtractiveOffset ", 1}"
            Sleep(300)

            if EvilSearch(PixelSearchTables["UnitX"])[1] or A_Index > 10 {
                break
            }

            SubtractiveOffset -= 1
        }
    }

    return _UnitName
}

/**
global UnitMap := Map(
    "Unit_1", {Slot:4, Pos:[670, 335], MovementFromSpawn:[], UnitData:[]},
)

UnitActionArray := [
    {Unit:"Unit_1", ActionList:["Placement", "Upgrade", "Action"], ActionCompleted:false}
]
*/

DetectPlacementIcons() {
    MouseGetPos(&MouseX, &MouseY)

    OffsetCoords := [MouseX + 43, MouseY - 8]

    if PixelSearch(&u,&u,OffsetCoords[1], OffsetCoords[2], OffsetCoords[1], OffsetCoords[2], 0x1F1F1F, 3) {
        return true
    }

    return false
}

BreakChecks(T_A_C, A_B_N, U_A_A) {
    if DetectEndRoundUI() {
        return true
    }

    if not (A_B_N < 0) and T_A_C >= A_B_N {
        return true
    }

    if DisconnectedCheck() {
        return true
    }

    if T_A_C >= U_A_A.Length {
        return true
    }

    return false
}

PresenceInShibuya() {
    ; return false
    Arg1 := EvilSearch(PixelSearchTables["BossBarPixel"])[1]
    Arg2 := EvilSearch(PixelSearchTables["HairColorSukuna"])[1]
    Arg3 := EvilSearch(PixelSearchTables["SkinColorSukuna"])[1]

    AddArgAmount := (Arg1 + Arg2 + Arg3)

    ; OutputDebug("Arguments Found`nArg1: " Arg1 "`nArg2: " Arg2 "`nArg3: " Arg3)
    if AddArgAmount >= 3 {
        return true
    }

    return false
}

EventActionSimplicity(Action) {
    switch Action {
        case "Sell":
            SendEvent "X"
        case "Ability":
            PM_ClickPos("UnitAbility")
        case "Target":
            SendEvent "R"
    }
}

EnableActionAutomation(SettingsTable := Map()) {
    ; Global Values
    global BlowUpAndDieChallengeMrBeastV2

    ; Setting Values
    ActionBreakNumber := SettingsTable["ActionBreakNumber"]
    PreviousCompletedActions := SettingsTable["PreviousCompletedActions"]

    ; Settings that dont need to be set
    FingerCheckBreak := false


    if SettingsTable.Has("FingerCheckBreak") {
        FingerCheckBreak := SettingsTable["FingerCheckBreak"]
    }

    ; Base Variables
    FailedPlacements := []
    CompletedPlacements := []
    TotalActionsCompleted := (0 + PreviousCompletedActions)
    CurrentSelectedUnit := ""
    BreakID := -1

    PlacementCheck(UnitID, CurrentSelectedUnit_F) {
        ReturnedUnitID := CurrentSelectedUnit_F

        if (((not CurrentSelectedUnit) and EvilSearch(PixelSearchTables["UnitX"])[1]) or (CurrentSelectedUnit != UnitID)) and UnitMap[UnitID].IsPlaced {
            if EvilSearch(PixelSearchTables["UnitX"])[1] {
                PM_ClickPos("UnitX")
                Sleep(10)
            }

            loop 6 {
                SendEvent "{Click, " UnitMap[UnitID].Pos[1] + (A_Index - 1) ", " UnitMap[UnitID].Pos[2] + (A_Index - 1) ", 0}"
                Sleep(15)
                SendEvent "{Click, " UnitMap[UnitID].Pos[1] + (A_Index - 1) ", " UnitMap[UnitID].Pos[2] + (A_Index - 1) ", 1}"

                Sleep(300)
                if EvilSearch(PixelSearchTables["UnitX"])[1] {
                    ReturnedUnitID := UnitID
                    break
                }
            }
        }

        return ReturnedUnitID
    }

    for _, ActionObject in UnitActionArray {
        if ActionObject.ActionCompleted {
            CompletedPlacements.Push(_)
            continue
        }

        if BreakChecks(TotalActionsCompleted, ActionBreakNumber, UnitActionArray) {
            BreakID := 1
            break
        }

        if FingerCheckBreak and not BlowUpAndDieChallengeMrBeastV2[1] {
            if PresenceInShibuya() {
                BlowUpAndDieChallengeMrBeastV2[1] := true
                BlowUpAndDieChallengeMrBeastV2[2]:= A_TickCount
            }
        } else if FingerCheckBreak and BlowUpAndDieChallengeMrBeastV2[1] {
            ; OutputDebug("Checking Finger Time")
            if (A_TickCount - BlowUpAndDieChallengeMrBeastV2[2]) >= 200000 {
                BreakID := 100
                break
            }
        }
        ; Checks if Unit is placed, and is not currently selected. If so then select unit
        CurrentSelectedUnit := PlacementCheck(ActionObject.Unit, CurrentSelectedUnit)

        switch ActionObject.Action {
            case "Placement":
                UnitPlacementFails := 0

                loop {
                    if FingerCheckBreak and not BlowUpAndDieChallengeMrBeastV2[1] {
                        if PresenceInShibuya() {
                            BlowUpAndDieChallengeMrBeastV2[1] := true
                            BlowUpAndDieChallengeMrBeastV2[2] := A_TickCount
                        }
                    } else if FingerCheckBreak and BlowUpAndDieChallengeMrBeastV2[1] {
                    ; OutputDebug("Checking Finger Time")
                    if (A_TickCount - BlowUpAndDieChallengeMrBeastV2[2]) >= 200000 {
                            BreakID := 100
                            break 2
                        }
                    }

                    if BreakChecks(TotalActionsCompleted, ActionBreakNumber, UnitActionArray) {
                        BreakID := 1
                        break 2
                    }

                    if not DetectPlacementIcons() {
                        SendEvent UnitMap[ActionObject.Unit].Slot
                    }
                    Sleep(100)

                    SendEvent "{Click, " UnitMap[ActionObject.Unit].Pos[1] ", " UnitMap[ActionObject.Unit].Pos[2] ", 0}"
                    Sleep(15)
                    SendEvent "{Click, " UnitMap[ActionObject.Unit].Pos[1] ", " UnitMap[ActionObject.Unit].Pos[2] ", 1}"

                    Sleep(500)
                    FoundUnitX := EvilSearch(PixelSearchTables["UnitX"])[1]
                    FoundPlacementIcons := DetectPlacementIcons()
                    
                    if FoundPlacementIcons and FoundUnitX {
                        ; We probably already placed this unit, but due to lag some stupid stuff happened
                        ; (or user is trying to place a unit on another unit [Which is not my problem.])

                        UnitMap[ActionObject.Unit].IsPlaced := true
                        SendEvent UnitMap[ActionObject.Unit].Slot
                        CurrentSelectedUnit := ActionObject.Unit
                        break
                    } else if not FoundPlacementIcons and FoundUnitX {
                        ; Unit has been placed

                        UnitMap[ActionObject.Unit].IsPlaced := true
                        CurrentSelectedUnit := ActionObject.Unit
                        break
                    } else if FoundPlacementIcons and not FoundUnitX {
                        ; Probably placing unit in a spot we cant

                        UnitPlacementFails++

                        if UnitPlacementFails >= 8 {
                            FailedPlacements.Push(ActionObject.unit)
                            SendEvent UnitMap[ActionObject.Unit].Slot
                            break
                        }
                    } else {
                        ; Unit failed to place due to invalid money count / max units placed

                        ; No clue what to put here as of now but yeah were goated
                        Sleep(200)
                    }
                }
            
                Sleep(100)
            case "Upgrade":
                loop {
                    if FingerCheckBreak and not BlowUpAndDieChallengeMrBeastV2[1] {
                        if PresenceInShibuya() {
                            OutputDebug("Set Finger Time")
                            BlowUpAndDieChallengeMrBeastV2[1] := true
                            BlowUpAndDieChallengeMrBeastV2[2] := A_TickCount
                        }
                    } else if FingerCheckBreak and BlowUpAndDieChallengeMrBeastV2[1] {
                        ; OutputDebug("Checking Finger Time")
                        if (A_TickCount - BlowUpAndDieChallengeMrBeastV2[2]) >= 200000 {
                            BreakID := 100
                            break 2
                        }
                    }

                    if BreakChecks(TotalActionsCompleted, ActionBreakNumber, UnitActionArray) {
                        BreakID := 1
                        break 2
                    }

                    if EvilSearch(PixelSearchTables["UnitUpgradeGreenCheck"])[1] {
                        SendEvent "T"
                        break
                    }
                    Sleep(60)
                }

                ; Sleep(200)
                ; SendEvent "R"
        }

        TotalActionsCompleted += 1
        ActionObject.ActionCompleted := true

        for _, EventObject in UnitEventArray {
            if EventObject.AfterAction >= TotalActionsCompleted {
                switch EventObject.IsLooped {
                    case true:
                        if EventObject.LastDelay = 0 {
                            EventObject.LastDelay := A_TickCount
                        }

                        if (A_TickCount - EventObject.LastDelay) >= EventObject.LoopDelay {
                            CurrentSelectedUnit := PlacementCheck(EventObject.Unit, CurrentSelectedUnit)

                            EventActionSimplicity(EventObject.Action)
                            EventObject.LastDelay := A_TickCount
                        }
                    case false:
                        CurrentSelectedUnit := PlacementCheck(EventObject.Unit, CurrentSelectedUnit)

                        EventActionSimplicity(EventObject.Action)
                }

            }
        }
    }

    return [TotalActionsCompleted, BreakID]
}


/**
    "Unit_2", {
        Slot:4, Pos:[670, 335], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:1, ActionCompleted:false, Delay:16000},
            {Type:"Upgrade", Wave:4, ActionCompleted:false, Delay:1500},
            {Type:"Upgrade", Wave:5, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Sell", Wave:20, ActionCompleted:false, Delay:0},
        ]  
    },
 */

EnableWaveAutomation(SettingsTable := Map()) {
    Wave := -1
    WaveObject := {}
    NewerTable := {Active:false}
    global CurrentOpenUnit := "nil"
    CompletedList := {}
    FailureAmount := 0
    TimedWaveDelay_CD := 0

    ; From : Settings table
    WavesToBreak := SettingsTable["WavesToBreak"]
    BreakOnLose := SettingsTable["BreakOnLose"]
    WaveDetectionRange := SettingsTable["WaveDetectionRange"]
    MaxWave := SettingsTable["MaxWave"]
    DelayBreakTime := SettingsTable["DelayBreakTime"]
    Debug := SettingsTable["Debug"]
    EnableSecondaryJump := SettingsTable["EnableSecondaryJump"]
    WaveCheckDelays := SettingsTable["WaveCheckDelays"]
    TimedWaveDelays := SettingsTable["TimedWaveDelays"]

    InverseKeys := Map(
        "W", "S",
        "S", "W",
        "A", "D",
        "D", "A",
    )

    loop {
        FoundNumber := ""

        if TimedWaveDelays.HasOwnProp("D") {
            if TimedWaveDelay_CD = 0 {
                TimedWaveDelay_CD := A_TickCount
            }

            if TimedWaveDelays.HasOwnProp(Wave + 1) {
                if A_TickCount - TimedWaveDelay_CD >= TimedWaveDelays.%Wave+1% {
                    FoundNumber := Wave + 1
                    TimedWaveDelay_CD := A_TickCount
                }
            } else {
                if A_TickCount - TimedWaveDelay_CD >= TimedWaveDelays.D {
                    FoundNumber := Wave + 1
                    TimedWaveDelay_CD := A_TickCount
                }
            }
        } else {
            if WaveCheckDelays.HasOwnProp(Wave) and WaveObject.HasOwnProp("Num" Wave) and (A_TickCount - WaveObject.%"Num" Wave%) >= WaveCheckDelays.%Wave% {
                FoundNumber := WaveDetection(EnableSecondaryJump, Wave, WaveDetectionRange, FailureAmount)
            } else if not WaveCheckDelays.HasOwnProp(Wave) or not WaveObject.HasOwnProp("Num" Wave) {
                FoundNumber := WaveDetection(EnableSecondaryJump, Wave, WaveDetectionRange, FailureAmount)
            }
        }

        if IsNumber(FoundNumber) and FoundNumber > Wave and (not (FoundNumber > Wave + WaveDetectionRange)) and (not FoundNumber > MaxWave) {
            Wave := FoundNumber

            if Debug {
                ToolTip("`nNew Wave #: " Wave,18, 566)
            }

            OutputDebug("`nNew Wave #: " Wave)

            if not WaveObject.HasOwnProp("Num" Wave) {
                OutputDebug("`nNew Wave Added: " Wave)

                WaveObject.%"Num" Wave% := A_TickCount
            } else {
                OutputDebug("`nFailure Wave Value: " WaveObject.%"Num" Wave%)
            }

            if Wave >= 1 {
                loop(Wave) {
                    if not WaveObject.HasOwnProp("Num" A_Index - 1) {
                        WaveObject.%"Num" A_Index - 1% := A_TickCount
                    }
                }
            }

            FailureAmount := 0
        } else {
            FailureAmount++
        }

        if DisconnectedCheck() {
            break
        }

        if ObjOwnPropCount(CompletedList) = UnitMap.Count {
            OutputDebug("`nBroke Due to The Evil")
            break
        }

        if BreakOnLose and DetectEndRoundUI() {
            break
        }

        for _, WaveBreak in WavesToBreak {
            if WaveBreak = Wave and not NewerTable.Active {
                NewerTable.Active := true
                NewerTable.Time := A_TickCount
            }

            if NewerTable.HasOwnProp("Active") and NewerTable.Active {
                if A_TickCount - NewerTable.Time >= DelayBreakTime {
                    break 2
                }
            }
        }

        for _UnitName, UnitObject in UnitMap {
            if CompletedList.HasOwnProp(_UnitName) {
                continue
            }

            CompletedActions := 0

            for _, ActionObject in UnitObject.UnitData {
                if ActionObject.ActionCompleted = false and ActionObject.Wave <= Wave {
                    if ActionObject.HasOwnProp("Delay") {
                        if WaveObject.HasOwnProp("Num" ActionObject.Wave) {
                            if not A_TickCount - WaveObject.%"Num" ActionObject.Wave% >= ActionObject.Delay {
                                continue 2
                            }
                        } else {
                            continue 2
                        }
                    }

                    OffsetArray := []
                    
                    for _, MovementObject in UnitObject.MovementFromSpawn {
                        if PlayerPositionFromSpawn.%MovementObject.Key% != MovementObject.TimeDown {
                            if ToggleMapValues["NoMovementReset"] {
                                OffsetArray.Push({Key:MovementObject.Key, Timedown:(MovementObject.TimeDown - PlayerPositionFromSpawn.%MovementObject.Key%), Delay:MovementObject.Delay})
                            } else {
                                OffsetArray.Push(MovementObject)
                            }
                        }
                    }

                    if not ToggleMapValues["NoMovementReset"] and OffsetArray.Length > 1 {
                        TpToSpawn()
                        Sleep(500)
                    }

                    for _, Movement in OffsetArray {
                        Sleep(Movement.Delay)

                        if Movement.TimeDown < 0 {
                            SendEvent "{" InverseKeys[Movement.Key] " Down}"
                            Sleep(Abs(Movement.TimeDown))
                            SendEvent "{" InverseKeys[Movement.Key] " Up}"
                        } else {
                            SendEvent "{" Movement.Key " Down}"
                            Sleep(Movement.TimeDown)
                            SendEvent "{" Movement.Key " Up}"
                        }


                        PlayerPositionFromSpawn.%Movement.Key% += Movement.TimeDown
                        Sleep(300)
                    }

                    if CurrentOpenUnit != _UnitName {                        
                        if EvilSearch(PixelSearchTables["UnitX"])[1] {
                            PM_ClickPos("UnitX", 1)
                            Sleep(200)
                        }
                    }

                    switch ActionObject.Type {
                        case "Placement":
                            if EvilSearch(PixelSearchTables["UnitX"])[1] {
                                PM_ClickPos("UnitX", 1)
                                Sleep(200)
                            }

                            SendEvent "{" UnitObject.Slot " Down}{" UnitObject.Slot " Up}"
                            Sleep(100)
                            loop 3 {
                                SendEvent "{Click, " UnitObject.Pos[1] ", " UnitObject.Pos[2] ", 0}"
                                Sleep(15)
                            }
                            Sleep(150)
                            SendEvent "{Click, " UnitObject.Pos[1] ", " UnitObject.Pos[2] ", 1}"
                            CurrentOpenUnit := _UnitName
                            Sleep(100)
                        case "Upgrade":
                            CurrentOpenUnit := _EnableWaveAutomation_Helper_UnitUICheck(CurrentOpenUnit, _UnitName, UnitObject)

                            Sleep(200)
                            PM_ClickPos("UnitUpgradeButton")
                        case "Sell":
                            CurrentOpenUnit := _EnableWaveAutomation_Helper_UnitUICheck(CurrentOpenUnit, _UnitName, UnitObject)

                            Sleep(200)
                            PM_ClickPos("UnitSell")
                            
                            Sleep(400)
                            if EvilSearch(PixelSearchTables["UnitX"])[1] {
                                PM_ClickPos("UnitSell")
                            }
                        case "Ability":
                            CurrentOpenUnit := _EnableWaveAutomation_Helper_UnitUICheck(CurrentOpenUnit, _UnitName, UnitObject)

                            SetPixelSearchLoop("UnitAbilityToggle", 3000, 1,,,,50)
                            PM_ClickPos("UnitAbility")
                        case "Target":
                            CurrentOpenUnit := _EnableWaveAutomation_Helper_UnitUICheck(CurrentOpenUnit, _UnitName, UnitObject)

                            Sleep(150)
                            SendEvent "{R Down}{R Up}"
                    }

                    ActionObject.ActionCompleted := true
                } else if ActionObject.ActionCompleted {
                    CompletedActions++
                }
            }

            if CompletedActions = UnitObject.UnitData.Length {
                OutputDebug("`nAdded Completetion: " _UnitName)
                CompletedList.%_UnitName% := true
            }
        }

        Sleep(400)
    }
}

DisconnectedCheck() {
    Arg1 := EvilSearch(PixelSearchTables["DisconnectBG_LS"])[1]
    Arg2 := EvilSearch(PixelSearchTables["DisconnectBG_RS"])[1]
    Arg3 := EvilSearch(PixelSearchTables["ReconnectButton"])[1]

    if not (Arg1 and Arg2 and Arg3) {
        return false
    }

    return true
}

ReconnecticalNightmares() {
    if not DisconnectedCheck() {
        return false
    }

    SetPixelSearchLoop("StoreCheck", 90000, 1, PM_GetPos("ReconnectButton"))
    SendEvent "{Tab Down}{Tab Up}"
    Sleep(300)
    PM_ClickPos("PlayerX")
    Sleep(300)
    PM_ClickPos("AreaButton")
    Sleep(300)
    PM_ClickPos("Area_PlayButton")
    Sleep(300)
    PM_ClickPos("AreaButtonX")
    Sleep(500)
    RouteUser("r:[0%W600&650%A600&1300%W4000]")
    Sleep(500)

    loop {
        SendEvent "{A Down}{Space Down}"
        
        Issue := 0
        loop {
            for _1, SearchName in ["QueueLeaveButton", "ConfirmButton"] {
                if EvilSearch(PixelSearchTables[SearchName])[1] {
                    Issue := _1
                    SendEvent "{A Up}{Space Up}"
                    break 2
                }
            }
            Sleep(10)
        }

        switch Issue {
            case 1:
                PM_ClickPos("QueueLeaveButton")
                Sleep(5000)
                OutputDebug("Retrying")
            case 2:
                OutputDebug("Perfection")
                return true
        }
    }
}

for _, CreationArray in ____PSCreationMap {
    ____CreatePSInstance(CreationArray)
}

