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
)

____PSCreationMap := [
    ["TpButtonCheck", 0xEC0D3A, 15],
    ["TpButton", 0xEC0D3A, 5],
    ["SearchField", 0x1E1E1E, 3],
    ["StupidCat", 0x95AACD, 10],
    ["MiniX", 0xFF0B4E, 5],
    ["X", 0xEC0D3A, 10],
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
PM_ClickPos(Name := "") {
    if PositionMap.Has(Name) {
        Pos := PM_GetPos(Name)

        SendEvent "{Click, " Pos[1] ", " Pos[2] ", 1}"
    } else {
        OutputDebug("Failure to click position")
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

}

/**
 * Creates a PixelSearchLoop From PixelSearchTables that breaks if requirement is met or has surpassed the time limit
 * @param Key Key of PixelSearchTable to use
 * @param BreakTime How long till the loop breaks if requirement isnt met
 * @param Type 1 = Loop Till Found | 2 = Loop Till Not Found
 * @param ClickPostions A position array to click during the loop
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
    ReturnResult := true,
    SleepTime := 100,
    ExtendedFunctionObject := []
) {
    if not PixelSearchTables.Has(Key) {
        OutputDebug("Invalid Key")
        return false
    }

    for _, FuncOBJ in ExtendedFunctionObject {
        FuncOBJ.StartTime := A_TickCount
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

            for _, FuncOBJ in ExtendedFunctionObject {
                if (A_TickCount - FuncOBJ.StartTime) >= FuncOBJ.Time {
                    FuncOBJ.Func()
                    FuncOBJ.StartTime := A_TickCount
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
____CreatePSInstance(Name, Color, Variation) {
    global PixelSearchTables
    Pos_TL := PM_GetPos(Name "TL")
    Pos_BR := PM_GetPos(Name "BR")

    PixelSearchTables[Name] := [
        Pos_TL[1], Pos_TL[2], Pos_BR[1], Pos_BR[2], Color, Variation
    ]
}

; Used for RouteUser
____TP(Value) {
    Sleep(400)
    PM_ClickPos("TpButton")
    Sleep(400)

    SetPixelSearchLoop("X", 20000, 1,,,150,[{Func:____TP_1, Time:6000}])
    PM_ClickPos("SearchField")
    Sleep(200)
    SendText Value

    SetPixelSearchLoop("SearchField", 5000,1,,,,)
    OutputDebug("A")
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
    Sleep(400)
    PM_ClickPos("TpButton")
    Sleep(400)

    SetPixelSearchLoop("X", 20000, 1,,,150,[{Func:____TP_1, Time:6000}])

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

;-- Main
for _, CreationArray in ____PSCreationMap {
    ____CreatePSInstance(CreationArray[1], CreationArray[2], CreationArray[3])
}

