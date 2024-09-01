CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
CoordMode "ToolTip", "Window"
SetMouseDelay -1

;-- Variables
global PixelSearchTables := Map()

____ADVTextToFunctionMap := Map(
    "Tp:", ____TP,
    "w_nV:", ____W_nV,
    "wt:", ____Wt,
    "r:", ____R,
    "w:", ____W,
    "Sc:", ____SC,
    "Spl:", ____SPL,
    "ASpl:", ____ASPL,
)

/**
 * @param TableInfo [NameFromPosMap, Color, Variation, ID, Re-Name]
 * 
 * ID | 1 = Has TL/BR values | 2 = No TL\BR Values
 */
____PSCreationMap := [
    ["TpButtonCheck", 0xEC0D3A, 15, 1],
    ["TpButton", 0xEC0D3A, 5, 1],
    ["SearchField", 0x1E1E1E, 3, 1],
    ["StupidCat", 0x95AACD, 10, 1],
    ["MiniX", 0xFF0B4E, 5, 1],
    ["X", 0xEC0D3A, 10, 1],
    ["Empower_EnchantSelection", 0x000000, 2, 1],
    ["AutoFarm", 0xFF1055, 20, 1],
    ["AutoHatch", 0xFF1055, 20, 1],
    ["Daycare_OkayButton", 0x7FF60E, 5, 1],
    ["Empower_OkayButton", 0x7EF50D, 3, 1],
    ["Empower_OkayButton", 0xACAFC5, 3, 1, "Evil_Empower_OkayButton"],
    ["Daycare_EnrollButton", 0x61E0FE, 5, 1],
    ["DaycareGP_EnrollButton", 0x61E0FE, 5, 1],

    ["DisconnectBG_LS", 0x393B3D, 3, 2],
    ["DisconnectBG_RS", 0x393B3D, 3, 2],
    ["ReconnectButton", 0xFFFFFF, 3, 2],
    ["AutoHatch_InternalCheck", 0xFF145C, 5, 2],
    ["LB_Star", 0xCE9440, 10, 2],
    ["LB_Diamond", 0x4C93B7, 10, 2],
]

;-- Functions

/**
 * Obtains Position from PositionMap
 * @param Name The Name of position to get from PositionMap
 * 
 * Added : V1 | Modified : V1
 */
PM_GetPos(Name := "") {
    if PositionMap.Has(Name) {
        return PositionMap[Name].Position
    } else {
        OutputDebug("Failure to obtain position")
        return [1,1]
    }
}

/**
 * Clicks Position from PositionMap
 * @param Name The Name of position to get form PositionMap
 * 
 * Added : V1 | Modified : V1
 */
PM_ClickPos(Name := "", Amount := 1) {
    if PositionMap.Has(Name) {
        Pos := PM_GetPos(Name)

        SendEvent "{Click, " Pos[1] ", " Pos[2] ", 0}"
        Sleep(15)
        SendEvent "{Click, " Pos[1] ", " Pos[2] ", " Amount "}"
    } else {
        OutputDebug("Failure to click position : " Name)
    }
}

/**
 * Returns PixelSearchResult & Positions using name from PixelSearchTables
 * @param SetupTable Key of PixelSearchTable to use
 * @param ToReturnPositions If positions are to be included in the return
 * 
 * Added : V1 | Modified : Pre-V1
 */
EvilSearch(SetupTable, ToReturnPositions := false) {
    Successful := PixelSearch(&u, &u2, SetupTable[1], SetupTable[2], SetupTable[3], SetupTable[4], SetupTable[5], SetupTable[6])

    if ToReturnPositions and Successful {
        return [Successful, u, u2]
    } else if Successful {
        return [Successful]
    } else {
        return [false]
    } 
}

/**
 * Closes all UI off of players screen
 * 
 * Added : V1 | Modified : V1
 */
Clean_UI() {
    SetPixelSearchLoop("X", 10000, 2, PM_GetPos("X"),,,10,)
    SetPixelSearchLoop("MiniX", 10000, 2, PM_GetPos("MiniX"),,,10,)
}

/**
 * Creates a PixelSearchLoop From PixelSearchTables that breaks if requirement is met or has surpassed the time limit
 * @param Key Key of PixelSearchTable to use
 * @param BreakTime How long till the loop breaks if requirement isnt met
 * @param Type 1 = Loop Till Found | 2 = Loop Till Not Found
 * @param ClickPostions A position array to click during the loop
 * @param KeysToPress [{Key:D, Time:800, DownTime:10}] | Key = Key to press | Time = Delay Between Presses | DownTime = how long to hold down
 * @param ReturnResult If it should return the result if the pixel was found (true) or if it had to break of off time (false)
 * @param SleepTime How long to sleep inbetween loops
 * @param ExtendedFunctionObject [{Func:X, Time:X}] | Basically other function(s) to call inbetween the loop incase of special conditions
 * 
 * Added : V1 | Modified : V1
 */
SetPixelSearchLoop(
    Key := "", 
    BreakTime := 10000,
    Type := 1,
    ClickPositions := [],
    KeysToPress := [],
    ReturnResult := true,
    SleepTime := 100,
    ExtendedFunctionObject := []
) {
    if not PixelSearchTables.Has(Key) {
        OutputDebug("Invalid Key")
        return false
    }

    for _, CoolArray in [ExtendedFunctionObject, KeysToPress] {
        for _, ArrayObj in CoolArray {
            ArrayObj.StartTime := A_TickCount
        }
    }

    StartTime := A_TickCount
    if (not EvilSearch(PixelSearchTables[Key], false)[1] and Type = 1) or (EvilSearch(PixelSearchTables[Key], false)[1] and Type = 2) {
        loop {
            if (A_TickCount - StartTime) >= (BreakTime) {
                return false
            }

            if (EvilSearch(PixelSearchTables[Key], false)[1] and Type = 1) or (not EvilSearch(PixelSearchTables[Key], false)[1] and Type = 2) {
                return true
            }

            if ClickPositions.Length >= 2 {
                SendEvent "{Click, " ClickPositions[1] ", " ClickPositions[2] ", 1}"
            }

            for _, CoolArray in [ExtendedFunctionObject, KeysToPress] {
                for _2, ArrayObj in CoolArray {
                    if (A_TickCount - ArrayObj.StartTime) >= ArrayObj.Time {
                        switch _ {
                            case 1:
                                ArrayObj.Func()
                            case 2:
                                SendEvent "{" ArrayObj.Key " Down}"
                                Sleep(ArrayObj.Downtime)
                                SendEvent "{" ArrayObj.Key " Up}"
                        }

                        ArrayObj.StartTime := A_TickCount
                    }
                }
            }

            Sleep(SleepTime)
        }
    }

}

/**
 * Checks if the StupidCat is on screen
 * 
 * Added : V1 | Modified : V1
 */
StupidCatCheck() {
    if EvilSearch(PixelSearchTables["MiniX"])[1] and EvilSearch(PixelSearchTables["StupidCat"])[1] {
        return true
    }
    
    return false
}

/**
 * Routes player based on RouteText
 * @param RouteText String used for routing player
 * 
 * Added : V1 | Modified : V1
 */
RouteUser(RouteText) {
    RouteArray := StrSplit(RouteText, "|")

    for _, RText in RouteArray {
        F_f := false
        for SearchFor, Function in ____ADVTextToFunctionMap {
            if RegExMatch(RText, "i)" SearchFor) {
                Function(SubStr(RText, StrLen(SearchFor) + 1))
                F_f := true
                break
            }
        }
        if not F_f {
            OutputDebug("Unknown Event")
        }
    }
}

LeaderBoardThingy() {

}

/**
 * Creates an array of positions based on a XCoord Array and a YCoord array
 * @param XArray [XPos1, XPos2, XPos3...]
 * @param YArray [YPos1, YPos2, YPos3...]
 * 
 * Added : V1 | Modified : V1
 */
CreatePositions(
    XArray := [1],
    YArray := [1]
) {
    ReturnArray := []

    for _, Y in YArray {
        for _, X in XArray {
            ReturnArray.Push([X, Y])
        }
    }

    return ReturnArray
}

/**
 * Returns distance between 2 points
 * @param X1 First XCoord
 * @param Y1 First YCoord
 * @param X2 Second XCoord
 * @param Y2 Second YCoord
 * 
 * Added : V1 | Modified : V1
 */
GetDistanceBetweenPoints(
    X1 := 1,
    Y1 := 1,
    X2 := 1,
    Y2 := 1
) {
    return (((X2 - X1)**2) + ((Y2-Y1)**2 ))**(0.5)
}

/**
 * Funny Circle Function
 * 
 * Modified From : https://www.autohotkey.com/boards/viewtopic.php?t=70402
 * 
 * (UNSURE ABOUT THESE PARAMS)
 * @param R How offset the mouse is (in pixels maybe?)
 * @param degInc how many degrees each movement should be
 * @param speed basically delay between each circle movement
 * @param Dist the distance to go around the circle (360 for full rotation)
 * 
 * Added : V1 | Modified : V1
 */
CircularNonsense(r := 200, degInc := 5, speed := 0, Dist := 36) {
    radPerDeg := 3.14159265359 / 180 
	MouseGetPos(&cx, &cy)
    angle := 0
    cy += r
	loop (Dist / degInc) {
		angle += degInc * radPerDeg
		MouseMove(cx + r * Sin(angle), cy - r * Cos(angle))
		Sleep(speed)
	}
}

;-- Not Main Functions
____CreatePSInstance(InstArray) {
    global PixelSearchTables
    Name := InstArray[1]
    Color := InstArray[2]
    Variation := InstArray[3]
    ID := InstArray[4]

    SetupTable := []
    switch ID {
        case 1:
            P_TL := PM_GetPos(Name "TL")
            P_BR := PM_GetPos(Name "BR")

            SetupTable := [
                P_TL[1], P_TL[2], P_BR[1], P_BR[2], Color, Variation
            ]
        case 2:
            P := PM_GetPos(Name)

            SetupTable := [
                P[1], P[2], P[1], P[2], Color, Variation
            ]
    }

    if InstArray.Length >= 5 {
        PixelSearchTables[InstArray[5]] := SetupTable
        return
    }

    PixelSearchTables[Name] := SetupTable
}

; Used for RouteUser
____TP(Value) {
    SetPixelSearchLoop("TpButton", 20000, 1)


    Sleep(400)
    PM_ClickPos("TpButton")
    Sleep(400)

    SetPixelSearchLoop("X", 20000, 1,,,150,,[{Func:____TP_1, Time:6000}])
    PM_ClickPos("SearchField")
    Sleep(200)
    SendText Value

    SetPixelSearchLoop("SearchField", 5000,1,,,,)
    loop 3 {
        Sleep(250)
        PM_ClickPos("TpMiddle")
    }
    Sleep(500)

    if StupidCatCheck() {
        Clean_UI()
    }
}

____TP_1(*) {
    Clean_UI()
    PM_ClickPos("TpButton")
}

____W(Value) {
    SetPixelSearchLoop("TpButton", 20000, 1)

    Sleep(400)
    PM_ClickPos("TpButton")
    Sleep(400)

    SetPixelSearchLoop("X", 20000, 1,,,150,,[{Func:____TP_1, Time:6000}])

    ButtonOrder := ["SpawnButton", "TechButton", "VoidButton"]
    PositionToUse := ButtonOrder[Value]

    Sleep(200)
    PM_ClickPos(PositionToUse)
    Sleep(400)

    SetPixelSearchLoop("MiniX", 15000, 2, PM_GetPos("YesButton"))
}

; Used for RouteUser
____W_nV(Value) {
    Sleep(NumberValueMap[Value])
}

; Used for RouteUser
____Wt(Value) {
    Sleep(Value)
}

; Used for RouteUser
____R(Value) {
    OutputDebug("`nRoute Function Value: " Value)

    switch {
        case RegExMatch(Value, "&"):
            SplitStringicals := StrSplit(SubStr(Value, 2, StrLen(Value) - 2), "&")
            RouteArray := []

            for _, S_2 in SplitStringicals {
                OtherSplitical := StrSplit(S_2, "%")

                Delay := OtherSplitical[1]
                KeyAndTime := OtherSplitical[2]
                RouteArray.Push({
                    Key:(SubStr(KeyAndTime, 1, 1)), Delay:Delay, DownTime:(SubStr(KeyAndTime, 2)), KeyIsDown:false, KeyIsFinished:false
                })
            }

            StartTime := A_TickCount
            loop {
                KeysFinished := 0

                for _, RouteObject in RouteArray {
                    if RouteObject.KeyIsFinished {
                        KeysFinished++
                        continue
                    }

                    if RouteObject.KeyIsDown {
                        if A_TickCount - (StartTime + RouteObject.Delay + RouteObject.Downtime) >= 0 {
                            SendEvent "{" RouteObject.Key " Up}"
                            RouteArray[_].KeyIsFinished := true
                        }
                    }
    
                    if A_TickCount - (StartTime + RouteObject.Delay) >= 0 and not RouteObject.KeyIsDown and not RouteObject.KeyIsFinished {
                        SendEvent "{" RouteObject.Key " Down}"
                        RouteArray[_].KeyIsDown := true
                    }
                }

                if KeysFinished >= RouteArray.Length {
                    break
                }

                Sleep(1)
            }
        default:
            StringOfEvil := StrSplit(SubStr(Value, 2, StrLen(Value) - 2), "%")

            Delay := StringOfEvil[1]
            Key := SubStr(StringOfEvil[2], 1, 1)
            Downtime := SubStr(StringOfEvil[2], 2)

            if Delay > 0 {
                Sleep(Delay)
            }

            SendEvent "{" Key " Down}"
            Sleep(Downtime)
            SendEvent "{" Key " Up}"
    }
}


; Used for RouteUser
____SC(Value) {
    StringOfEvil := StrSplit(SubStr(Value, 2, StrLen(Value) - 2), ",")

    XPos := StringOfEvil[1]
    YPos := StringOfEvil[2]

    SendEvent "{Click, " XPos ", " YPos ", 0}"
    Sleep(15)
    SendEvent "{Click, " XPos ", " YPos ", 1}"
}

; Used for RouteUser
____SPL(Value) {
    SetPixelSearchLoop(Value, 30000)
}

; Used for RouteUser
____ASPL(Value) {
    SetPixelSearchLoop(Value, 30000, 2)
}

;-- Main
for _, CreationArray in ____PSCreationMap {
    ____CreatePSInstance(CreationArray)
}

