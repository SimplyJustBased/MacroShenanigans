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
    ["ResultBackgroundCheck1", 0x141414, 3, 2],
    ["ResultBackgroundCheck2", 0x030303, 3, 2],
    ["AutoSkipWavesToggle", 0x511818, 15, 2],
    ["DisableCameraShakeToggle", 0x511818, 15, 2],
    ["DisconnectBG_LS", 0x393B3D, 3, 2],
    ["DisconnectBG_RS", 0x393B3D, 3, 2],
    ["ReconnectButton", 0xFFFFFF, 3, 2],
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
        OCRResult := OCR.FromWindow("ahk_exe RobloxPlayerBeta.exe",,2,{
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


EnableWaveAutomation(WavesToBreak := [], BreakOnLose := true, WaveDetectionRange := 1, MaxWave := 15) {
    Wave := 0

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

        if DisconnectedCheck() {
            break
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

