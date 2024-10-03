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
WaveDetection(JumpOnFail) {
    global WAVE_DETECTION_CD
    global LAST_WAVE_DETECTION_RESULT

    TextObject := {Found:false, Number:0}

    loop 2 {
        try {
            switch ToggleMapValues["SecondaryOCR"] {
                case true:
                    WinGetPos(&XPos, &Ypos, &XWidth, &YWidth, "ahk_exe RobloxPlayerBeta.exe")
    
                    OCRResult := OCR.FromRect(XPos+101, Ypos+30, 124, 120)
                case false:
                    OCRResult := OCR.FromWindow("ahk_exe RobloxPlayerBeta.exe",,2,{
                        X:101,
                        Y:30,
                        W:124,
                        H:120
                    }, 0)
            }
            
            Arg1 := RegExMatch(OCRResult.Text, "[\d]{3}")
            ; OutputDebug("`nTry1 | Text: " OCRResult.Text)
            if not Arg1 {
                RegExMatch(OCRResult.Text, "[\d]{1,2}", &Returned)
                TextObject.Number := Returned[]
                TextObject.Found := true
                ; OutputDebug("`nTry1 Succeed | Num: " Returned[])
            }
        } catch as E {
            ; OutputDebug(E.Message)
            if JumpOnFail {
                try {
                    SendEvent "{Space Down}{Space Up}"
                    Sleep(150)
            
                    switch ToggleMapValues["SecondaryOCR"] {
                        case true:
                            WinGetPos(&XPos, &Ypos, &XWidth, &YWidth, "ahk_exe RobloxPlayerBeta.exe")
            
                            OCRResult := OCR.FromRect(XPos+101, Ypos+30, 124, 120)
                        case false:
                            OCRResult := OCR.FromWindow("ahk_exe RobloxPlayerBeta.exe",,2,{
                                X:101,
                                Y:30,
                                W:124,
                                H:120
                            }, 0)
                    }
                    Arg1 := RegExMatch(OCRResult.Text, "[\d]{3}")
                    ; OutputDebug("`nTry2 | Text: " OCRResult.Text)
                
                    if not Arg1 {
                        RegExMatch(OCRResult.Text, "[\d]{1,2}", &Returned)
                        TextObject.Number := Returned[]
                        TextObject.Found := true
                        ; OutputDebug("`nTry2 Succeed | Num: " Returned[])
                    }
        
                    Sleep(550)
                }
            }
        }
    
        if TextObject.Found {
            if LAST_WAVE_DETECTION_RESULT = TextObject.Number {
                return TextObject.Number
            } else {
                OutputDebug("`nL:" LAST_WAVE_DETECTION_RESULT " D:" TextObject.Number)
            }
    
            LAST_WAVE_DETECTION_RESULT := TextObject.Number
        }
    }

    return 0 
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

    loop 15 {
        SendEvent "{WheelDown}"
        Sleep(10)
    }

    Sleep(200)
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
}

_EnableWaveAutomation_Helper_UnitUICheck(CurrentOpenUnit, _UnitName, UnitObject) {
    SubtractiveOffset := 0

    if not CurrentOpenUnit = _UnitName {
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

EnableWaveAutomation(WavesToBreak := [], BreakOnLose := true, WaveDetectionRange := 1, MaxWave := 15, DelayBreakTime := 0, Debug := false, EnableSecondaryJump := true) {
    Wave := -1
    WaveObject := {}
    NewerTable := {Active:false}
    CurrentOpenUnit := "nil"
    CompletedList := {}

    InverseKeys := Map(
        "W", "S",
        "S", "W",
        "A", "D",
        "D", "A",
    )

    loop {
        FoundNumber := WaveDetection(EnableSecondaryJump)

        if IsNumber(FoundNumber) and FoundNumber > Wave and (not FoundNumber > FoundNumber + WaveDetectionRange) and (not FoundNumber > MaxWave) {
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
                            Sleep(200)
                            loop 3 {
                                SendEvent "{Click, " UnitObject.Pos[1] ", " UnitObject.Pos[2] ", 0}"
                                Sleep(15)
                            }
                            Sleep(150)
                            SendEvent "{Click, " UnitObject.Pos[1] ", " UnitObject.Pos[2] ", 1}"
                            Sleep(100)
                            CurrentOpenUnit := _UnitName
                        case "Upgrade":
                            CurrentOpenUnit := _EnableWaveAutomation_Helper_UnitUICheck(CurrentOpenUnit, _UnitName, UnitObject)

                            Sleep(299)
                            PM_ClickPos("UnitUpgradeButton")
                            Sleep(200)
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

