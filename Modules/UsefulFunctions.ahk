#Warn VarUnset, Off

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
CoordMode "ToolTip", "Window"
SetMouseDelay -1

;-- Variables
global PixelSearchTables := Map()

____ADVTextToFunctionMap := Map(
    "w_nV:", ____W_nV,
    "wt:", ____Wt,
    "r:", ____R,
    "Sc:", ____SC,
    "Spl:", ____SPL,
    "ASpl:", ____ASPL,
)

;-- Debug Variables | EasyUI Debug
global Debug_PmClickArray := []
global Debug_PsLoopArray := []
global Debug_CurrentPsLoop := {}
global Debug_RouteArray := []

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
    global Debug_PmClickArray

    if PositionMap.Has(Name) {
        Pos := PM_GetPos(Name)

        SendEvent "{Click, " Pos[1] ", " Pos[2] ", 0}"
        Sleep(15)
        SendEvent "{Click, " Pos[1] ", " Pos[2] ", " Amount "}"
        
        Debug_PmClickArray.InsertAt(1, {Name:Name, Time:A_TickCount, S:true})
    } else {
        OutputDebug("Failure to click position : " Name)

        Debug_PmClickArray.InsertAt(1, {Name:Name, Time:A_TickCount, S:false})

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
    global Debug_CurrentPsLoop
    global Debug_PsLoopArray

    if not PixelSearchTables.Has(Key) {
        OutputDebug("Invalid Key")
        return false
    }

    for _, CoolArray in [ExtendedFunctionObject, KeysToPress] {
        for _, ArrayObj in CoolArray {
            ArrayObj.StartTime := 0
        }
    }

    StartTime := A_TickCount
    Debug_CurrentPsLoop := {Name:Key, Time:StartTime}

    if (not EvilSearch(PixelSearchTables[Key], false)[1] and Type = 1) or (EvilSearch(PixelSearchTables[Key], false)[1] and Type = 2) {
        loop {
            if (A_TickCount - StartTime) >= (BreakTime) {
                Debug_CurrentPsLoop := {Name:"None", Time:0}
                Debug_PsLoopArray.InsertAt(1, {Name:Key, Time:A_TickCount, Rt:A_TickCount - StartTime, S:false})
                return false
            }

            if (EvilSearch(PixelSearchTables[Key], false)[1] and Type = 1) or (not EvilSearch(PixelSearchTables[Key], false)[1] and Type = 2) {
                Debug_CurrentPsLoop := {Name:"None", Time:0}
                Debug_PsLoopArray.InsertAt(1, {Name:Key, Time:A_TickCount, Rt:A_TickCount - StartTime, S:true})
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
 * Routes player based on RouteText
 * @param RouteText String used for routing player
 * 
 * Added : V1 | Modified : V1
 */
RouteUser(RouteText) {
    RouteArray := StrSplit(RouteText, "|")

    Debug_RouteArray.InsertAt(1, {Name:RouteText})

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

DebugBasicInfo_UsefulFunctions() {
    MousePos := {
        Name:"mPos", 
        Type:"Text", 
        Data:{
            Amount:6,
            3:{Opt:"Center", Font:"s11", Text:"Mouse Pos"},
            4:{Opt:"Center", Font:"s10", Text:"[X, X]"},
        }
    }

    Clicks := {
        Name:"clicklist", 
        Type:"Text", 
        Data:{
            Amount:4,
            1:{Opt:"", Font:"s11", Text:"Prev. Clicks:"},
            2:{Opt:"", Font:"s7", Text:"1: None"},
            3:{Opt:"", Font:"s7", Text:"2: None"},
            4:{Opt:"", Font:"s7", Text:"3: None"},
        }
    }

    PsLoops := {
        Name:"psloops", 
        Type:"Text", 
        Data:{
            Amount:4,
            1:{Opt:"", Font:"s11", Text:"Prev. Ps. Loops:"},
            2:{Opt:"", Font:"s7", Text:"1: None"},
            3:{Opt:"", Font:"s7", Text:"2: None"},
            4:{Opt:"", Font:"s7", Text:"3: None"},
        }
    }
    
    CurrentPsLoop := {
        Name:"currentPSLoop", 
        Type:"Text", 
        Data:{
            Amount:5,
            2:{Opt:"Center", Font:"s9", Text:"Current Ps. Loop"},
            3:{Opt:"Center", Font:"s9", Text:"None"},
            4:{Opt:"Center", Font:"s9", Text:"0"},
        }
    }
    
    RouteArray := {
        Name:"routesArray", 
        Type:"Text", 
        Data:{
            Amount:4,
            1:{Opt:"", Font:"s11", Text:"Prev. Routes:"},
            2:{Opt:"", Font:"s6", Text:"1: None"},
            3:{Opt:"", Font:"s6", Text:"2: None"},
            4:{Opt:"", Font:"s6", Text:"3: None"},
        }
    }

    CreateDebugItems([Clicks, RouteArray, PsLoops, CurrentPsLoop, MousePos])
    UsefulFuncDebugLoop() {
        global Debug_PmClickArray
        global Debug_PsLoopArray
        global Debug_CurrentPsLoop
        global Debug_RouteArray

        for _Num, DebugArray in [Debug_RouteArray, Debug_PmClickArray, Debug_PsLoopArray] {
            try {
                if DebugArray.Length > 3 {
                    Excess := DebugArray.Length - 3
    
                    loop Excess {
                        DebugArray.RemoveAt(4, Excess)
                    }
                }
            }
        }

        global EasyUI_Debug_Items

        _PrevClicks := EasyUI_Debug_Items["clicklist"]
        _PrevPsLoops := EasyUI_Debug_Items["psloops"]
        _PrevRoutes := EasyUI_Debug_Items["routesArray"]
        _CurrentPsLoop := EasyUI_Debug_Items["currentPSLoop"]
        _MousePos := EasyUI_Debug_Items["mPos"]

        for _1, Match in [[_PrevClicks, Debug_PmClickArray], [_PrevPsLoops, Debug_PsLoopArray], [_PrevRoutes, Debug_RouteArray]] {
            loop 3 {
                Match[1][A_Index + 1].Text := A_Index ": None"
            }

            for _2, Value in Match[2] {
                try {
                    switch _1 {
                        case 1:
                            Match[1][_2 + 1].Text := _2 ": " Value.Name " | " Floor((A_TickCount - Value.Time)/1000) " | " Value.S
                        case 2:
                            Match[1][_2 + 1].Text := _2 ": " Value.Name " | " Floor((A_TickCount - Value.Time)/1000) " | " Value.Rt " | " Value.S
                        case 3:
                            Match[1][_2 + 1].Text := _2 ": " Value.Name
                    }
                }
            }
        }

        if Debug_CurrentPsLoop.HasOwnProp("Name") and Debug_CurrentPsLoop.Name != "None" {
            _CurrentPsLoop[3].Text := Debug_CurrentPsLoop.Name
            _CurrentPsLoop[4].Text := (A_TickCount - Debug_CurrentPsLoop.Time)
        } else {
            _CurrentPsLoop[3].Text := "None"
            _CurrentPsLoop[4].Text := 0
        }

        MouseGetPos(&X, &Y)
        _MousePos[4].Text := "[" X ", " Y "]"
    }
    SetTimer(UsefulFuncDebugLoop, 40)
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
