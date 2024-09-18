/**
 * @param TableInfo [NameFromPosMap, Color, Variation, ID, Re-Name]
 * 
 * ID | 1 = Has TL/BR values | 2 = No TL\BR Values
 */
____PSCreationMap := [
    ["RetryButton", 0xD7CD03, 15, 1],
    ["ReturnToLobby", 0x1EB8E1, 15, 1],

    ["ResultBackgroundCheck1", 0x141414, 3, 2],
    ["ResultBackgroundCheck2", 0x030303, 3, 2],
    ["AutoSkipWavesToggle", 0x511818, 15, 2],
    ["DisableCameraShakeToggle", 0x511818, 15, 2],
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

WaveDetection() {
    try {
        OCRResult := OCR.FromWindow("ahk_exe RobloxPlayerBeta.exe",,1,{
            X:101,
            Y:50,
            W:124,
            H:80
        }, 0)
    
        return StrSplit(OCRResult.Text, " ")[2]
    } catch as E {
        return 0
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
    PM_ClickPos("SettingButton")
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

EnableWaveAutomation(WavesToBreak := [], BreakOnLose := true, WaveDetectionRange := 1, MaxWave := 15) {
    Wave := 1

    InverseKeys := Map(
        "W", "S",
        "S", "W",
        "A", "D",
        "D", "A",
    )

    loop {
        FoundNumber := WaveDetection()

        if IsNumber(FoundNumber) and FoundNumber > Wave and (not FoundNumber > FoundNumber + WaveDetectionRange) and (not FoundNumber > MaxWave) {
            Wave := FoundNumber
            OutputDebug("`nNew Wave #: " Wave)
        }

        if BreakOnLose and DetectEndRoundUI() {
            break
        }

        for _, WaveBreak in WavesToBreak {
            if WaveBreak = Wave {
                break 2
            }
        }

        for _UnitName, UnitObject in UnitMap {
            for _, ActionObject in UnitObject.UnitData {
                if ActionObject.ActionCompleted = false and ActionObject.Wave <= Wave {
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
                    }

                    Sleep(300)
                    switch ActionObject.Type {
                        case "Placement":
                            SendEvent "{" UnitObject.Slot " Down}{" UnitObject.Slot " Up}"
                            Sleep(200)
                            SendEvent "{Click, " UnitObject.Pos[1] ", " UnitObject.Pos[2] ", 0}"
                            Sleep(15)
                            SendEvent "{Click, " UnitObject.Pos[1] ", " UnitObject.Pos[2] ", 1}"
                            Sleep(200)
                            PM_ClickPos("UnitX", 1)
                        case "Upgrade":
                            SendEvent "{Click, " UnitObject.Pos[1] ", " UnitObject.Pos[2] ", 0}"
                            Sleep(15)
                            SendEvent "{Click, " UnitObject.Pos[1] ", " UnitObject.Pos[2] ", 1}"
                            Sleep(200)
                            SendEvent "{T Down}{T Up}"
                            Sleep(200)
                            PM_ClickPos("UnitX", 1)
                        case "Sell":
                            SendEvent "{Click, " UnitObject.Pos[1] ", " UnitObject.Pos[2] ", 0}"
                            Sleep(15)
                            SendEvent "{Click, " UnitObject.Pos[1] ", " UnitObject.Pos[2] ", 1}"
                            Sleep(200)
                            SendEvent "{T Down}{T Up}"
                    }

                    ActionObject.ActionCompleted := true
                }
            }
        }

        Sleep(400)
    }
}

for _, CreationArray in ____PSCreationMap {
    ____CreatePSInstance(CreationArray)
}

