; /[V4.0.03]\ (Used for auto-update)
#Requires AutoHotkey v2.0

global Version := "4.0.0"
#Include "%A_MyDocuments%\PS99_Macros\Modules\Router.ahk"
#Include "%A_MyDocuments%\PS99_Macros\Modules\EasyUI.ahk"

CoordMode "Pixel", "Screen"
CoordMode "Mouse", "Screen"
SetMouseDelay -1

global MacroEnabled := false
global MultiInstancingEnabled := false
global CurrentZone := 0
global SubPosition := "Void"
global AutofarmZone := 0
global EmpowerCD := 0
global TotalLoopAmount := 0
global RunTime := 0
global OutPutFile := ""

PositionMap := Map(
    ; Basics
    "MiniXTL", [1259, 232],
    "MiniXBR", [1313, 288],
    "MiniX", [1285, 262],
    "XTL", [1442, 231],
    "XBR", [1499, 285],
    "X", [1470, 257],
    "InventoryBackpackButton", [416, 396],
    "SearchBar", [1292, 258],
    "TopOfGame", [930, 40],
    "ItemMiddle", [523, 411],
    "SearchFieldTL", [1158, 243],
    "SearchFieldBR", [1401, 262],
    "StupidCatBR", [903, 515],
    "StupidCatTL", [1001, 606],
    "TPButton", [169, 395],
    "TPButtonTL", [126, 343],
    "TPButtonBR", [189, 415],
    "TPUIMiddle", [960, 360],
    "InventoryBackpackButton", [416, 396],
    "ItemMiddle", [523, 411],
    "SecondaryItemMiddle", [663, 415],
    "ItemTL", [472, 357],
    "ItemBR", [578, 441],
    "YesButton", [795, 724],
    "MiddleOfScreen", [960, 540],
    "SC_TopMiddle", [956, 274],
    "VoidButton", [409, 580],
    "DisconnectedBackgroundLS", [777, 444],
    "DisconnectedBackgroundRS", [1143, 442],
    "ReconnectButton", [1009, 623],
    "AutoHatch_Enable", [1125, 383],
    "AutoHatch_Charged", [1125, 528],
    "AutoHatch_Golden", [1125, 667],
    "AutoHatch", [57, 477],
    "AutoHatchBR", [22, 445],
    "AutoHatchTL", [102, 514],
    "AutoFarmTL", [122, 453],
    "AutoFarmBR", [193, 519],
    "AutoFarm", [160, 488],
    "EggMaxBuy", [1187, 735],

    ; Empowering
    "EnchantSelectionTL", [807, 271],
    "EnchantSelectionBR", [1467, 776],
    "EmpowerOkayButton", [623, 707],
    "OkayButton", [1030, 715],
    "OkayButtonTL", [503, 664],
    "OkayButtonBR", [749, 748],
    "EnchantsButton", [413, 515],
    "EnchantEquipSlot1", [902, 359],

    ; Daycare
    "DaycareMiniX", [1312, 259],
    "DaycareMiniXTL", [1281, 231],
    "DaycareMiniXBR", [1345, 288],
    "DaycarePetSelection", [1000, 377],
    "DaycareOkButton", [675, 730],
    "DaycareOkButtonTL", [556, 689],
    "DaycareOkButtonBR", [795, 770],

    ; Gifts
    "FreeGiftsButton", [64, 386],
)

ScrollPositions := Map(
    "EmpowerEnchantButton", {Position:[1215, 776], ScrollAmount:0},
    "DaycareButton", {Position:[870, 606], ScrollAmount:0},
    "EnrollButtonScroll", {PositionTL:[462, 682], PositionBR:[1433, 755], ScrollAmount:1}
)

ZoneInformation := {
    FinalZone:{
        Zone_Number:219,
        IsEggInZone:false,
        Zone_Name:"Diamond Mega City",
    }
}

NumberValueMap := Map(
    "LoopDelayTime", 600,
    "TpWaitTime", 7000,
    "Egg&FarmSplitTime", 300,
)

TextValueMap := Map(
    "PetForDaycare", "Rave Butterfly",
    "FlagToUse", "Hasty Flag",
    
)

BooleanValueMap := Map(
    "UserOwnsAutoFarm", true,
    "EnableAutoHatch", true,
    "EnableAutoHatch_Golden", false,
    "EnableAutoHatch_Charged", false,
    "ShinyFruitToggle", false
)

MacroTogglesMap := Map(
    "AutoEmpower", false,
    "FarmZone", true,
    "HatchEggs", false,
    "Anti-Afk", true,
    "AutoFruits", true,
    "AutoGiftClaim", true,
    "AutoDaycare", true,
    "AutoUseItem", true,
    "AutoUseUltimate", true,
    "AutoFlag", true,
    "AutoSprinkler", true,
)
; "tp:Enchanted Forest|w_nV:TpWaitTime|r:[0%Q10&0%D400&420%W1540&2250%Q10]",
Routes := Map(
    "BasicTP", "tp:Prison Tower|w_nV:TpWaitTime",
    "VoidToComputer", "r:[0%Q10&10%D700]",
    "VoidToFinal", "tp:" ZoneInformation.FinalZone.Zone_Name "|w_nV:TpWaitTime|r:[0%Q10&10%D720]",
    "FinalToEgg", "r:[0%W700]",
    "EggToFinal", "r:[0%S700]",
    "EggToAway", "r:[0%A700]",
    "EggToAntiAway", "r:[0%D700]"
)

ColoredTiers := [0xDAD9E4, 0xBEFEA7, 0x9DEEFE, 0xFFDAA6, 0xFFB1BC, 0xFFBAFE, 0xFFF8B9, 0xEAFFFF, 0xF7E3FE]
TierArray := ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]

EnchantEmpowering := Map(
    "Criticals", [{TierText:"IX", TierValue:9, Amount:1}],
    "Strong Pets", [{TierText:"IX", TierValue:9, Amount:1}],
)

EnchantSectionMap := Map(
    "XArray", {X1:911, X2:1061, X3:1211, X4:1363},
    "YArray", {_Y1:350, _Y2:500, _Y3:650}
)

GiftClaimMap := Map(
    "XArray", {X1:713, X2:878, X3:1041, X4:1200},
    "YArray", {_Y1:350, _Y2:500, _Y3:650}
)

AutoItemSelection := Map(
    "Lucky Block", 12
)

global PixelSearchTables := ""

; ---- USEFUL FUNCTIONS -----
; Cleans the UI up
CleanUI() {
    X := PositionMap["X"]
    MiniX := PositionMap["MiniX"]


    BreakTime1 := A_TickCount
    if EvilSearch(PixelSearchTables["X"], false)[1] {
        loop {
            SendEvent "{Click, " X[1] ", " X[2] ", 1}"

            if (A_TickCount - BreakTime1) <= (5*1000) {
                break
            }

            if not EvilSearch(PixelSearchTables["X"], false)[1] {
                break
            }
        }
    }

    BreakTime2 := A_TickCount
    if EvilSearch(PixelSearchTables["MiniX"], false)[1] {
        loop {
            SendEvent "{Click, " MiniX[1] ", " MiniX[2] ", 1}"

            if (A_TickCount - BreakTime2) <= (5*1000) {
                break
            }

            if not EvilSearch(PixelSearchTables["MiniX"], false)[1] {
                break
            }
        }
    }

    Sleep(500)
}

; Creates a set of positions based on a coloumn of X and Y Coordinates
CreatePositions(XArray, YArray) {
    RealArray := []
    for _, Y in YArray {
        for _, X in XArray {
            RealArray.InsertAt(RealArray.Length, [X, Y])
        }
    }
    return RealArray
}

; Find distance between 2 points
GetDistanceBetweenPoints(X1, Y1, X2, Y2) {
    return (((X2 - X1)**2) + ((Y2-Y1)**2 ))**(0.5)
} 

; Pixel search but easier
EvilSearch(SetupTable, ToReturnPositions) {
    Successful := PixelSearch(&u, &u2, SetupTable[1], SetupTable[2], SetupTable[3], SetupTable[4], SetupTable[5], SetupTable[6])

    if ToReturnPositions and Successful {
        return [Successful, u, u2]
    } else if Successful {
        return [Successful]
    } else {
        return [false]
    } 
}

; Slightly Modified From : https://www.autohotkey.com/boards/viewtopic.php?t=70402
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

; ---- MAIN FUNCTIONS FOR LOOP ----
; New as freak!
EmpowerMyEnchant() {
    EEB := ScrollPositions["EmpowerEnchantButton"].Position
    EEBSA := ScrollPositions["EmpowerEnchantButton"].ScrollAmount
    SB := PositionMap["SearchBar"]
    TOG := PositionMap["TopOfGame"]
    EOB := PositionMap["EmpowerOkayButton"]
    OkB := PositionMap["OkayButton"]
    EB := PositionMap["EnchantsButton"]
    ES1 := PositionMap["EnchantEquipSlot1"]
    STM := PositionMap["SC_TopMiddle"]

    SuccessfulEmpoweredEnchants := Map()
    OuterBreak := false
    global EmpowerCD

    if not A_TickCount - EmpowerCD >= 0 {
        SendEvent "{A Down}"
        Sleep(1500)
        SendEvent "{A Up}"
    
        CleanUI()    
        return
    }

    ; Add time delay for 8 hours and 10 seconds before re-empowering
    EmpowerCD := (A_TickCount + 28810000)

    ; Start looping through each enchant to empower
    for EnchantName, EnchantArray in EnchantEmpowering {
        for _, EnchantObject in EnchantArray {
            loop EnchantObject.Amount {
                BreakTime1 := A_TickCount
                ; Make sure we open the right button at super computer
                if EvilSearch(PixelSearchTables["X"], false)[1] {
                    SendEvent "{Click, " STM[1] ", " STM[2] ", 0}"
                    Sleep(100)
                    loop 15 {
                        SendEvent "{WheelUp}"
                        Sleep(10)
                    }
        
                    Sleep(200)
    
                    loop EEBSA {
                        SendEvent "{WheelDown}"
                        Sleep(200)
                    }
    
                    SendEvent "{Click, " EEB[1] ", " EEB[2] ", 1}"
                } else {
                    loop {
                        SendEvent "{Space Down}{Space Up}"
                        Sleep(100)
    
                        if EvilSearch(PixelSearchTables["X"], false)[1] or (A_TickCount - BreakTime1) >= (20*1000) {
                            OutputDebug("Free")
                            break
                        }
                    }
    
                    Sleep(200)
                    SendEvent "{Click, " EEB[1] ", " EEB[2] ", 1}"
                }
    
                Sleep(500)
                SendEvent "{Click, " SB[1] ", " SB[2] ", 1}"
                Sleep(200)
    
                SendText EnchantName
                Sleep(200)
    
                ; Make sure we searched the thing successfully
                if not EvilSearch(PixelSearchTables["SearchField"], false)[1] {
                    BreakTime2 := A_TickCount
                    loop {
                        SendEvent "{Click, " TOG[1] ", " TOG[2] ", 1}"
                        Sleep(200)
    
                        SendEvent "{Click, " SB[1] ", " SB[2] ", 1}"
                        Sleep(200)
                
                        SendText EnchantName
                        Sleep(200)
    
                        if EvilSearch(PixelSearchTables["SearchField"], false)[1] or (A_TickCount - BreakTime2) >= (12*1000) {
                            break
                        }
                    }
                }
    
                ; Clone the PixelSearchTable and set the color value with the tier of enchant
                ClonedPSTable := PixelSearchTables["EnchantSearch"].Clone()
                ClonedPSTable[5] := ColoredTiers[EnchantObject.TierValue]
    
                SearchedTable := EvilSearch(ClonedPSTable, true)
    
                if not SearchedTable[1] {
                    OutputDebug("Could Not Find Enchant Tier")
                    CleanUI()
                    break
                }
    
                ; Create positons for each row
                CreationXArray := []
                CreationYArray := []
                __Arrays := [EnchantSectionMap["XArray"], EnchantSectionMap["YArray"]]
    
                for _2, Obj in __Arrays {
                    for _, Value in Obj.OwnProps() {
                        switch _2 {
                            case 1:
                                CreationXArray.InsertAt(CreationXArray.Length + 1, Value)
                            case 2:
                                CreationYArray.InsertAt(CreationYArray.Length + 1, Value)
                        }
                    }
                }
    
    
                CreatedPositions := CreatePositions(CreationXArray, CreationYArray)
                ClosestPosition := []
                ClosestPositionDist := 9999
    
                ; Check which upward position is the closest to the PixelSearch Position
                for _PositionIndex, Position in CreatedPositions {
                    PointDistance := GetDistanceBetweenPoints(Position[1], Position[2], SearchedTable[2], SearchedTable[3])
    
                    if PointDistance < ClosestPositionDist {
                        ClosestPosition := Position
                        ClosestPositionDist := PointDistance
                    }
                }
    
    
                ; Loop through 45 times increasing the degree amount by 8 degrees each time, if the ok button pops up then do function based on color
                loop (360/8) {
                    
                    SendEvent "{Click, " ClosestPosition[1] " ," ClosestPosition[2] ", Down}"
                    Sleep(20)
    
                    CircularNonsense(40, 1, 0, (A_Index * 8))
    
                    Sleep(100)
                    MouseGetPos(&Cx, &Cy)
                    SendEvent "{Click, " Cx " ," Cy ", Up}"
                    
                    ; If the green button pops up
                    if EvilSearch(PixelSearchTables["OkayButton"], false)[1] {
                        Sleep(200)
                        SendEvent "{Click, " EOB[1] ", " EOB[2] ", 1}"
    
                        BreakTime3 := A_TickCount
    
                        loop {
                            if EvilSearch(PixelSearchTables["MiniX"], false)[1] or (A_TickCount - BreakTime3) >= (16*1000) {
                                SendEvent "{Click, " OkB[1] ", " OkB[2] ", 1}"
    
                                try {
                                    SuccessfulEmpoweredEnchants[EnchantName].Amount += 1
                                } catch as e {
                                    SuccessfulEmpoweredEnchants[EnchantName] := {Amount:1,TierText:EnchantObject.TierText}
                                }
    
                                break
                            }
                        }
    
                        break
                    }
    
                    ; Could be a else if but wanted to comment here
                    ; Checks if the player is POOR
                    if EvilSearch(PixelSearchTables["AntiOkayButton"], false)[1] {
                    
                        CleanUI()
                        OutputDebug("Pooron")
                        OuterBreak := true
                        break
                    }
                }
    
                if OuterBreak {
                    break
                }
    
                Sleep(300)
                CleanUI()
            }

            if OuterBreak {
                break
            }
        }

        if OuterBreak {
            break
        }
    } 

    ; LEAVE THE COMPUTER NOWWWWWWWWWWW
    SendEvent "{A Down}"
    Sleep(1500)
    SendEvent "{A Up}"

    CleanUI()

    Breaktime4 := A_TickCount
    loop {
        SendEvent "{F Down}{F Up}"
        Sleep(500)

        if EvilSearch(PixelSearchTables["X"], false)[1] or (A_TickCount - Breaktime4) >= (15*1000) {
            break
        }
    }
    Sleep(400)

    SendEvent "{Click, " EB[1] ", " EB[2] ", 1}"
    Sleep(1000) ; not taking chances

    ; We gonna equip the enchants now
    for Enchant, AmountTable in SuccessfulEmpoweredEnchants {
        SendEvent "{Click, " SB[1] ", " SB[2] ", 1}"
        Sleep(200)

        SendText Enchant " " AmountTable.TierText
        Sleep(200)

        ; Make sure we searched the thing successfully 2.0
        if not EvilSearch(PixelSearchTables["SearchField"], false)[1] {
            BreakTime5 := A_TickCount
            loop {
                SendEvent "{Click, " TOG[1] ", " TOG[2] ", 1}"
                Sleep(200)

                SendEvent "{Click, " SB[1] ", " SB[2] ", 1}"
                Sleep(200)
        
                SendText Enchant  " " AmountTable.TierText
                Sleep(200)

                if EvilSearch(PixelSearchTables["SearchField"], false)[1] or (A_TickCount - BreakTime5) >= (12*1000) {
                    break
                }
            }
        }
        Sleep(200)

        loop AmountTable.Amount {
            SendEvent "{Click, " ES1[1] ", " ES1[2] ", 1}"

            Sleep(700)
        }
    }

    CleanUI()
    OutputDebug("Finished")
}

; The return.
ItemUseicalFunction(ItemArray, UseSecondary := false) {
    IBB := PositionMap["InventoryBackpackButton"]
    SB := PositionMap["SearchBar"]
    TOG := PositionMap["TopOfGame"]
    IM := PositionMap["ItemMiddle"]
    ITL := PositionMap["ItemTL"]
    IBR := PositionMap["ItemBR"]
    OkB := PositionMap["OkayButton"]

    CleanUI()
    for _LoopNum, Item in ItemArray {
        RandomPositions := [
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])],
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])],
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])],
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])],
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])]
        ]

        if UseSecondary and Item != "Rainbow Fruit" {
            IM := PositionMap["SecondaryItemMiddle"]
        } else {
            IM := PositionMap["ItemMiddle"]
        }

        if not EvilSearch(PixelSearchTables["X"], false)[1] {
            Breaktime1 := A_TickCount
            loop {
                SendEvent "{F Down}{F Up}"
                Sleep(500)
        
                if EvilSearch(PixelSearchTables["X"], false)[1] or (A_TickCount - Breaktime1) >= (15*1000) {
                    break
                }
            }
            Sleep(200)

            SendEvent "{Click, " IBB[1] ", " IBB[2] ", 1}"
            Sleep(200)
        }

        SendEvent "{Click, " SB[1] ", " SB[2] ", 1}"
        Sleep(100)

        SendText Item
        Sleep(250)

        if not EvilSearch(PixelSearchTables["SearchField"], false)[1] {
            BreakTime2 := A_TickCount
            loop {
                SendEvent "{Click, " TOG[1] ", " TOG[2] ", 1}"
                Sleep(200)

                SendEvent "{Click, " SB[1] ", " SB[2] ", 1}"
                Sleep(200)
        
                SendText Item
                Sleep(200)

                if EvilSearch(PixelSearchTables["SearchField"], false)[1] or (A_TickCount - BreakTime2) >= (12*1000) {
                    break
                }
            }
        }

        ColorTable := Map()
        WhiteColorFound := 0
        for _, Position in RandomPositions {
            ColorTable[Position] := PixelGetColor(Position[1], Position[2])

            if PixelSearch(&u, &u, Position[1], Position[2], Position[1], Position[2], 0xFFFFFF, 5) {
                WhiteColorFound += 1
            }
        }

        if WhiteColorFound >= 4 {
            OutputDebug("`nProbably a evil item on " Item)
            continue
        }

        TotalResearches := 0
        ToRs := 0
        loop 100 {
            if not EvilSearch(PixelSearchTables["X"], false)[1] {
                if EvilSearch(PixelSearchTables["StupidCat"], false)[1] {
                    CleanUI()
                    break
                }

                Breaktime1 := A_TickCount
                loop {
                    SendEvent "{F Down}{F Up}"
                    Sleep(500)
            
                    if EvilSearch(PixelSearchTables["X"], false)[1] or (A_TickCount - Breaktime1) >= (15*1000) {
                        break
                    }
                }
                Sleep(200)
    
                SendEvent "{Click, " IBB[1] ", " IBB[2] ", 1}"
                Sleep(200)
            }

            FoundColors := 0
            for Position, Color in ColorTable {
                if FoundColors >= 3 {
                    break
                }

                if PixelSearch(&u, &u, Position[1], Position[2], Position[1], Position[2], Color, 2) {
                    FoundColors += 1
                }
            }

            if FoundColors < 3 {

                ToRs += 1

                if ToRs >= 4 {
                    SendEvent "{Click, " TOG[1] ", " TOG[2] ", 1}"
                    Sleep(200)
    
                    SendEvent "{Click, " SB[1] ", " SB[2] ", 1}"
                    Sleep(200)
            
                    SendText Item
                    Sleep(250)

                    TotalResearches += 1
                }
        
                Breaktimeidk := A_TickCount
                if not EvilSearch(PixelSearchTables["SearchField"], false)[1] {
                    loop {
                        SendEvent "{Click, " TOG[1] ", " TOG[2] ", 1}"
                        Sleep(200)
        
                        SendEvent "{Click, " SB[1] ", " SB[2] ", 1}"
                        Sleep(200)
                
                        SendText Item
                        Sleep(200)
        
                        if EvilSearch(PixelSearchTables["SearchField"], false)[1] or (A_TickCount - Breaktimeidk) >= (12*1000) {
                            break
                        }
                    }
                }
            } else {
                ToRs := 0

                loop 5 {
                    SendEvent "{Click, " IM[1] " ," IM[2] ", 2}"
                    Sleep(50)
                }
    
                Sleep(100)
                if EvilSearch(PixelSearchTables["StupidCat"], false)[1] {
                    Breaktime3 := A_TickCount

                    loop {
                        SendEvent "{Click, " OkB[1] ", " OkB[2] ", 1}"
                        Sleep(500)
    
                        if not EvilSearch(PixelSearchTables["StupidCat"], false)[1] or (A_TickCount - Breaktime3) >= (12*1000) {
                            break
                        }
    
                        Sleep(100)
                    }
    
                    break
                }
            }

            if TotalResearches >= 10 {
                break
            }
        }
    }
    OutputDebug("Function Over")
}

; The eviler return
ItemUseicalFunctionSingular(ItemMap) {
    IBB := PositionMap["InventoryBackpackButton"]
    SB := PositionMap["SearchBar"]
    TOG := PositionMap["TopOfGame"]
    IM := PositionMap["ItemMiddle"]
    ITL := PositionMap["ItemTL"]
    IBR := PositionMap["ItemBR"]
    OkB := PositionMap["OkayButton"]

    CleanUI()
    for Item, Delay in ItemMap {
        if not EvilSearch(PixelSearchTables["X"], false)[1] {
            Breaktime1 := A_TickCount
            loop {
                SendEvent "{F Down}{F Up}"
                Sleep(500)
        
                if EvilSearch(PixelSearchTables["X"], false)[1] or (A_TickCount - Breaktime1) >= (15*1000) {
                    break
                }
            }
            Sleep(200)

            SendEvent "{Click, " IBB[1] ", " IBB[2] ", 1}"
            Sleep(200)
        }

        SendEvent "{Click, " SB[1] ", " SB[2] ", 1}"
        Sleep(100)

        SendText Item
        Sleep(100)

        if not EvilSearch(PixelSearchTables["SearchField"], false)[1] {
            BreakTime2 := A_TickCount
            loop {
                SendEvent "{Click, " TOG[1] ", " TOG[2] ", 1}"
                Sleep(200)

                SendEvent "{Click, " SB[1] ", " SB[2] ", 1}"
                Sleep(200)
        
                SendText Item
                Sleep(200)

                if EvilSearch(PixelSearchTables["SearchField"], false)[1] or (A_TickCount - BreakTime2) >= (12*1000) {
                    break
                }
            }
        }

        Sleep(20)
        SendEvent "{Click, " IM[1] " ," IM[2] ", 2}"
        Sleep(Delay * 1000)

        if EvilSearch(PixelSearchTables["StupidCat"], false)[1] {
            Breaktime3 := A_TickCount
            loop {
                SendEvent "{Click, " OkB[1] ", " OkB[2] ", 1}"
                Sleep(500)

                if not EvilSearch(PixelSearchTables["StupidCat"], false)[1] or (A_TickCount - Breaktime3) >= (4*1000) {
                    break
                }

                Sleep(100)
            }
        }
    }
}

; Absolute evil
DaycareOfDestruction() {
    PsEbMap1 := PixelSearchTables["EnrollButton"]
    PsEbMap2 := PsEbMap1.Clone()
    DcB := ScrollPositions["DaycareButton"].Position
    DcbSA := ScrollPositions["DaycareButton"].ScrollAmount
    EbSA := ScrollPositions["EnrollButtonScroll"].ScrollAmount
    DcMx := PositionMap["DaycareMiniX"]
    SB := PositionMap["SearchBar"]
    TOG := PositionMap["TopOfGame"]
    DcPs := PositionMap["DaycarePetSelection"]
    DcOb := PositionMap["DaycareOkButton"]
    Yb := PositionMap["YesButton"]
    STM := PositionMap["SC_TopMiddle"]

    PsEbMap2[5] := 0x6DF207

    ;-- making sure we enter the daycare and also supercomputer is open or whatever idk
    ;-- its just copied from the empower enchant func
    loop 2 {
        if EvilSearch(PixelSearchTables["X"], false)[1] {
            SendEvent "{Click, " STM[1] ", " STM[2] ", 0}"
            Sleep(100)
            loop 15 {
                SendEvent "{WheelUp}"
                Sleep(10)
            }

            Sleep(200)
    
            loop DcbSA {
                SendEvent "{WheelDown}"
                Sleep(200)
            }
    
            SendEvent "{Click, " DcB[1] ", " DcB[2] ", 1}"
        } else {
            BreakTime1 := A_TickCount
    
            loop {
                SendEvent "{Space Down}{Space Up}"
                Sleep(100)
    
                if EvilSearch(PixelSearchTables["X"], false)[1] or (A_TickCount - BreakTime1) >= (20*1000) {
                    OutputDebug("Free")
                    break
                }
            }
            Sleep(200)
    
            loop DcbSA {
                SendEvent "{WheelDown}"
                Sleep(200)
            }
    
            SendEvent "{Click, " DcB[1] ", " DcB[2] ", 1}"
        }
        Sleep(500)
    
        loop EbSA {
            SendEvent "{WheelDown}"
            Sleep(200)
        }
    
        SearchForBlue := EvilSearch(PsEbMap1, true)
        SearchForGreen := EvilSearch(PsEbMap2, true)
    
        switch {
            case SearchForBlue[1] and not SearchForGreen[1]:
                BluePos := [SearchForBlue[2], SearchForBlue[3]]

                SendEvent "{Click, " BluePos[1] ", " BluePos[2] ", 1}"
                Sleep(1500)

                B_BreakTime1 := A_TickCount
                loop {
                    if not A_Index = 1 {
                        SendEvent "{Click, " TOG[1] ", " TOG[2] ", 1}"
                        Sleep(200)
                    }

                    SendEvent "{Click, " SB[1] ", " SB[2] ", 1}"
                    Sleep(200)
    
                    SendText(TextValueMap["PetForDaycare"])
                    Sleep(200)

                    if EvilSearch(PixelSearchTables["SearchField"], false)[1] {
                        break
                    } else if A_TickCount - B_BreakTime1 >= 12500 {
                        break
                    }
                }
                Sleep(200)
                
                SendEvent "{Shift Down}"
                Sleep(100)
                SendEvent "{Click, " DcPs[1] ", " DcPs[2] ", 1}"
                Sleep(100)
                SendEvent "{Shift Up}"
                Sleep(300)

                if EvilSearch(PixelSearchTables["DaycareOkButton"], false)[1] {
                    SendEvent "{Click, " DcOb[1] ", " DcOb[2] ", 1}"

                    B_BreakTime2 := A_TickCount
                    if not EvilSearch(PixelSearchTables["MiniX"], false)[1] {
                        loop {
                            if (A_TickCount - B_BreakTime2) <= (5*1000) {
                                break
                            }
                
                            if not EvilSearch(PixelSearchTables["MiniX"], false)[1] {
                                break
                            }
                        }
                    }
                    Sleep(400)
                        
                    SendEvent "{Click, " Yb[1] ", " Yb[2] ", 1}"
                    
                    B_BreakTime3 := A_TickCount

                    loop {
                        if EvilSearch(PixelSearchTables["X"], false)[1] {
                            break
                        }

                        if (A_TickCount - B_BreakTime3) <= (5*1500) {
                            break
                        }

                        Sleep(100)
                    }
                }
                break
            case SearchForGreen[1]:
                GreenPos := [SearchForGreen[2], SearchForGreen[3]]
    
                SendEvent "{Click, " GreenPos[1] ", " GreenPos[2] ", 1}"
                G_BreakTime1 := A_TickCount
    
                loop {
                    Sleep(200)
    
                    if EvilSearch(PixelSearchTables["DaycareMiniX"], false)[1] {
                        break
                    }
    
                    if A_TickCount - G_BreakTime1 >= 25000 {
                        break
                    }
                }
    
                SendEvent "{Click, " DcMx[1] ", " DcMx[2] ", 1}"
                
                G_BreakTime2 := A_TickCount
                loop {
                    SendEvent "{Space Down}{Space Up}"
                    Sleep(200)

                    if EvilSearch(PixelSearchTables["X"], false)[1] {
                        break
                    }

                    if A_TickCount - G_BreakTime2 >= 15000 {
                        break
                    }
                }
            default:
                break
        }
    }

    Sleep(1000)
    CleanUI()
}

; Very Simple!
GiftClaimNonsense() {
    FGB := PositionMap["FreeGiftsButton"]

    CleanUI()
    BreakTime1 := A_TickCount

    loop {
        if EvilSearch(PixelSearchTables["MiniX"], false)[1] {
            break
        } else if A_TickCount - BreakTime1 >= 15000 {
            break
        }

        SendEvent "{Click, " FGB[1] ", " FGB[2] ", 1}"
        Sleep(500)
    }

    ; Creating Points again
    CreationXArray := []
    CreationYArray := []
    __Arrays := [GiftClaimMap["XArray"], GiftClaimMap["YArray"]]

    for _2, Obj in __Arrays {
        for _, Value in Obj.OwnProps() {
            switch _2 {
                case 1:
                    CreationXArray.InsertAt(CreationXArray.Length + 1, Value)
                case 2:
                    CreationYArray.InsertAt(CreationYArray.Length + 1, Value)
            }
        }
    }


    CreatedPositions := CreatePositions(CreationXArray, CreationYArray)

    for _PosIndex, Position in CreatedPositions {
        SendEvent "{Click, " Position[1] ", " Position[2] ", 1}"
        Sleep(300)
    }

    CleanUI()
}

; and then i get the new layer 2 bell
ReturnToVoid() {
    TpB := PositionMap["TPButton"]
    Vb := PositionMap["VoidButton"]

    UBT1 := A_TickCount 
    loop {
        if EvilSearch(PixelSearchTables["X"], false)[1] {
            break
        } else if A_TickCount - UBT1 >= 15000 {
            break
        }

        SendEvent "{Click, " TpB[1] ", " TpB[2] ", 1}"
        Sleep(300)
    }

    Sleep(200)
    loop 8 {
        SendEvent "{Click, " Vb[1] ", " Vb[2] ", 1}"
        Sleep(100)
    }
    
    Sleep(NumberValueMap["TpWaitTime"])
}
; ---- Some Other Functions ----
EnableAutoHatch() {
    AH := PositionMap["AutoHatch"]
    Ah1 := PositionMap["AutoHatch_Enable"]
    Ah2 := PositionMap["AutoHatch_Charged"]
    Ah3 := PositionMap["AutoHatch_Golden"]

    UBT1 := A_TickCount

    if not EvilSearch(PixelSearchTables["AutoHatchEnable"], false)[1] {
        return
    }

    loop {
        if EvilSearch(PixelSearchTables["MiniX"], false)[1] {
            break
        } else if A_TickCount - UBT1 >= 12000 {
            break
        }

        SendEvent "{Click, " AH[1] ", " AH[2] ", 1}"
        Sleep(300)
    }

    NameToPos := Map(
        "EnableAutoHatch", Ah1,
        "EnableAutoHatch_Golden", Ah3,
        "EnableAutoHatch_Charged", Ah2
    )

    for N, P in NameToPos {
        if BooleanValueMap[N] {
            SendEvent "{Click, " P[1] ", " P[2] ", 1}"
            Sleep(200)
        }
    }

    CleanUI()
}

EnableAutofarm() {
    if not BooleanValueMap["UserOwnsAutoFarm"] or CurrentZone = AutofarmZone {
        return
    }

    AF := PositionMap["AutoFarm"]

    if EvilSearch(PixelSearchTables["AutoFarmEnable"], false)[1] {
        SendEvent "{Click, " AF[1] ", " AF[2] ", 1}"
        Sleep(200)
    } else if EvilSearch(PixelSearchTables["AutoFarmRenable"], false)[1] {
        SendEvent "{Click, " AF[1] ", " AF[2] ", 1}"
        Sleep(500)
        SendEvent "{Click, " AF[1] ", " AF[2] ", 1}"
        Sleep(200)
    }

    global AutofarmZone := CurrentZone
}

; Disconnect Function :):):):):):):):
TheNuclearBomb() {
    Arg1 := EvilSearch(PixelSearchTables["DBGLS"], false)[1] 
    Arg2 := EvilSearch(PixelSearchTables["DBGRS"], false)[1]
    Arg3 := EvilSearch(PixelSearchTables["ReconnectButton"], false)[1]

    if Arg1 and Arg2 and Arg3 {
        TickTimeIDK := A_TickCount

        loop {
            SendEvent "{Click, " PositionMap["ReconnectButton"][1] ", " PositionMap["ReconnectButton"][2] ", 1}"

            if EvilSearch(PixelSearchTables["TpButton"], false)[1] {
                break
            } else if A_TickCount - TickTimeIDK >= 900000 {
                break
            }

            Sleep(10)
        }

        return true
    }
    return false
}

; ---- UI TOWN USA -----
; Just easier this way
HalfPosMap := Map(
    "X1", true,
    "X2", true,
    "X3", true,
    "X4", true,
    "X5", true,
    "_Y1", true,
    "_Y2", true,
    "_Y3", true,
    "_Y4", true,
    "_Y5", true,
)

CreationMap := Map(
    "Main", {Title:"Multi-Macro", Video:"", Description:"A all around afk-grinding macro`nF3 : Start`nF6 : Pause`nF8 : Stop/Close Macro`n`nDebug is saved into `"Storage\MultiMacroV4Debug`"", Version:Version, DescY:250, MacroName:"Multi-Macro", IncludeFonts:false, MultiInstancing:true},
    "Settings", [
        {Map:MacroTogglesMap, Name:"Macro Toggles", Type:"Toggle", SaveName:"MacroToggles", IsAdvanced:false, MultiInstanceIgnore:Map("AutoDropItem", true)},
        {Map:TextValueMap, Name:"Text Settings", Type:"Text", SaveName:"TextValues", IsAdvanced:false},
        {Map:BooleanValueMap, Name:"Toggle Settings", Type:"Toggle", SaveName:"ToggleValues", IsAdvanced:false},
        {Map:NumberValueMap, Name:"Number Settings", Type:"Number", SaveName:"NumberValues", IsAdvanced:false},
        {Map:EnchantEmpowering, Name:"Enchant-Empowering", Type:"MM_Empower", SaveName:"EnchantEmpowering", IsAdvanced:false},
        {Map:AutoItemSelection, Name:"Auto-Item Settings", Type:"Selection", SaveName:"AIS", IsAdvanced:false, SelectionType:"number"},
        {Map:EnchantSectionMap, Name:"SC_EmpowerPositions", SaveName:"SCEP", Type:"Object", IsAdvanced:true, ObjectOrder:["XArray", "YArray"], ObjectsPerPage:2, HalfPositions:HalfPosMap},
        {Map:GiftClaimMap, Name:"GiftClaimingPositions", SaveName:"GCM", Type:"Object", IsAdvanced:true, ObjectOrder:["XArray", "YArray"], ObjectsPerPage:2, HalfPositions:HalfPosMap},
        {Map:ScrollPositions, Name:"ScrollPositions", SaveName:"ScP", Type:"Object", IsAdvanced:true, ObjectOrder:["EmpowerEnchantButton", "DaycareButton", "EnrollButtonScroll"], ObjectsPerPage:5, HalfPositions:HalfPosMap},
        {Map:PositionMap, Name:"Re-Positioning", Type:"Position", SaveName:"Positions", IsAdvanced:true},
        {Map:Routes, Name:"Routes", Type:"Text", SaveName:"Routes", IsAdvanced:true},

    ],
    "SettingsFolder", {Folder:A_MyDocuments "\PS99_Macros\SavedSettings\", FolderName:"MultiMacroV4"}
)

ReturnedUITable := CreateBaseUI(CreationMap)

LastButton := ""


ReturnedUITable.BaseUI.Show()
ReturnedUITable.BaseUI.OnEvent("Close", (*) => ExitApp())

EnableFunction() {
    global MacroEnabled
    global MultiInstancingEnabled
    global OutPutFile

    if not MacroEnabled {
        MacroEnabled := true
        MultiInstancingEnabled := ReturnedUITable.Instances.Multi

        ReturnedUITable.BaseUI.Hide()
        for _, UI in __HeldUIs["UID" ReturnedUITable.UID] {
            try {
                UI.submit()
            }
        }
    }
}

loop {
    Sleep(100)
    if ReturnedUITable.EnableButton != LastButton {
        LastButton := ReturnedUITable.EnableButton
        LastButton.OnEvent("Click", (*) => EnableFunction())
    }
}

; Town of multi-instance functions
; Turns the RecMap into a more readable map
CleanUpMulti(IDMAP) {
    NameToBetterName := Map(
        "Macro Toggles", "MacroTogglesMap",
        "Text Settings", "TextValueMap",
        "Toggle Settings", "BooleanValueMap",
        "Number Settings", "NumberValueMap",
        "Enchant-Empowering", "EnchantEmpowering",
        "SC_EmpowerPositions", "EnchantSectionMap",
        "GiftClaimingPositions", "GiftClaimMap",
        "ScrollPositions", "ScrollPositions",
        "Re-Positioning", "PositionMap",
        "Routes", "Routes",
        "Auto-Item Settings", "AutoItemSelection"
    )
    FinalizedMap := Map()

    for ID, IDOBJ in IDMAP {
        CleanMap := Map()

        switch IDOBJ.Action {
            case "Macro":
                CleanMap["Action"] := "Macro"
                for _, SettingObj in IDOBJ.Clone["Settings"] {
                    if NameToBetterName.Has(SettingObj.Name) {
                        CleanMap[NameToBetterName[SettingObj.Name]] := SettingObj.Map
                    } else {
                        OutputDebug("`nIssue condensing to map _ MACRO _ " SettingObj.Name)
                    }
                }

                CleanMap["LastActivated"] := 0
                CleanMap["PreviousRunTime"] := 0
                CleanMap["CurrentZone"] := 0
                CleanMap["AutoFarmZone"] := 0
                CleanMap["EmpowerCD"] := 0
                CleanMap["TotalLoopAmount"] := 0
                CleanMap["SubPosition"] := 0

                FinalizedMap[ID] := CleanMap
            default:
                CleanMap["Action"] := "Anti-Afk"
                CleanMap["AfkSettings"] := IDOBJ.Map["Afk Settings"]

                CleanMap["LastActivated"] := 0
                FinalizedMap[ID] := CleanMap
        }
    }

    return FinalizedMap
}

; Changes the current global maps into the one used by the current instance
MapChange(CleanMap) {
    global PositionMap := CleanMap["PositionMap"]
    global ScrollPositions := CleanMap["ScrollPositions"]
    global MacroTogglesMap := CleanMap["MacroTogglesMap"]
    global BooleanValueMap := CleanMap["BooleanValueMap"]
    global TextValueMap := CleanMap["TextValueMap"]
    global NumberValueMap := CleanMap["NumberValueMap"]
    global EnchantEmpowering := CleanMap["EnchantEmpowering"]
    global EnchantSectionMap := CleanMap["EnchantSectionMap"]
    global GiftClaimMap := CleanMap["GiftClaimMap"]
    global CurrentZone := CleanMap["CurrentZone"]
    global Routes := CleanMap["Routes"]
    global AutoItemSelection := CleanMap["AutoItemSelection"]

    ; reset pixelsearchtables cuz it wont work else wise
    global PixelSearchTables := Map(
        "X", [
            PositionMap["XTL"][1], PositionMap["XTL"][2],
            PositionMap["XBR"][1], PositionMap["XBR"][2],
            0xFF0B4E, 5
        ],
        "MiniX", [
            PositionMap["MiniXTL"][1], PositionMap["MiniXTL"][2],
            PositionMap["MiniXBR"][1], PositionMap["MiniXBR"][2],
            0xFF0B4E, 5
        ],
        "SearchField", [
            PositionMap["SearchFieldTL"][1], PositionMap["SearchFieldTL"][2],
            PositionMap["SearchFieldBR"][1], PositionMap["SearchFieldBR"][2],
            0x1E1E1E, 3
        ],
        "EnchantSearch", [
            PositionMap["EnchantSelectionTL"][1], PositionMap["EnchantSelectionTL"][2],
            PositionMap["EnchantSelectionBR"][1], PositionMap["EnchantSelectionBR"][2],
            0x000000, 0
        ],
        "OkayButton", [
            PositionMap["OkayButtonTL"][1], PositionMap["OkayButtonTL"][2],
            PositionMap["OkayButtonBR"][1], PositionMap["OkayButtonBR"][2],
            0x7EF50D , 3
        ], 
        "AntiOkayButton", [
            PositionMap["OkayButtonTL"][1], PositionMap["OkayButtonTL"][2],
            PositionMap["OkayButtonBR"][1], PositionMap["OkayButtonBR"][2],
            0xC1C4DC, 1
        ],
        "StupidCat", [
            PositionMap["StupidCatBR"][1], PositionMap["StupidCatBR"][2],
            PositionMap["StupidCatTL"][1], PositionMap["StupidCatTL"][2],
            0x95AACD, 10
        ],
        "EnrollButton", [
            ScrollPositions["EnrollButtonScroll"].PositionTL[1], ScrollPositions["EnrollButtonScroll"].PositionTL[2],
            ScrollPositions["EnrollButtonScroll"].PositionBR[1], ScrollPositions["EnrollButtonScroll"].PositionBR[2],
            0x61E0FE, 5
        ],
        "DaycareMiniX", [
            PositionMap["DaycareMiniXTL"][1], PositionMap["DaycareMiniXTL"][2],
            PositionMap["DaycareMiniXBR"][1], PositionMap["DaycareMiniXBR"][2],
            0xFF0B4E, 5
        ],
        "DaycareOkButton", [
            PositionMap["DaycareOkButtonTL"][1], PositionMap["DaycareOkButtonTL"][2],
            PositionMap["DaycareOkButtonBR"][1], PositionMap["DaycareOkButtonBR"][2],
            0x7FF60E, 5
        ],
        "AutoHatchEnable", [
            PositionMap["AutoHatchTL"][1], PositionMap["AutoHatchTL"][2],
            PositionMap["AutoHatchBR"][1], PositionMap["AutoHatchBR"][2],
            0xFF1055, 20
        ],
        "AutoFarmEnable", [
            PositionMap["AutoFarmTL"][1], PositionMap["AutoFarmTL"][2],
            PositionMap["AutoFarmBR"][1], PositionMap["AutoFarmBR"][2],
            0xFF1055, 20
        ],
        "AutoFarmRenable", [
            PositionMap["AutoFarmTL"][1], PositionMap["AutoFarmTL"][2],
            PositionMap["AutoFarmBR"][1], PositionMap["AutoFarmBR"][2],
            0x82F60F, 20
        ],
        "TpButton", [
            PositionMap["TPButtonTL"][1], PositionMap["TPButtonTL"][2],
            PositionMap["TPButtonBR"][1], PositionMap["TPButtonBR"][2],
            0xEC0D3A, 15
        ],
        "DBGLS", [
            PositionMap["DisconnectedBackgroundLS"][1], PositionMap["DisconnectedBackgroundLS"][2],
            PositionMap["DisconnectedBackgroundLS"][1], PositionMap["DisconnectedBackgroundLS"][2],
            0x393B3D, 3
        ],
        "DBGRS", [
            PositionMap["DisconnectedBackgroundRS"][1], PositionMap["DisconnectedBackgroundRS"][2],
            PositionMap["DisconnectedBackgroundRS"][1], PositionMap["DisconnectedBackgroundRS"][2],
            0x393B3D, 3
        ],
        "ReconnectButton", [
            PositionMap["ReconnectButton"][1], PositionMap["ReconnectButton"][2],
            PositionMap["ReconnectButton"][1], PositionMap["ReconnectButton"][2],
            0xFFFFFF, 3
        ],
    )

    ; Setting extras
    global CurrentZone := CleanMap["CurrentZone"]
    global AutofarmZone := CleanMap["AutoFarmZone"]
    global EmpowerCD := CleanMap["EmpowerCD"]
    global TotalLoopAmount := CleanMap["TotalLoopAmount"]
    global SubPosition := CleanMap["SubPosition"]
}

AntiAfkCheck_Multi(InstanceMap, PreviousID := -1) {
    if not MultiInstancingEnabled {
        return TheNuclearBomb()
    }

    global SubPosition
    global CurrentZone
    global TotalLoopAmount
    global AutofarmZone
    global EmpowerCD

    P_SubPosition := SubPosition
    P_CurrentZone := CurrentZone
    P_TotalLoopAmount := TotalLoopAmount
    P_AutofarmZone := AutofarmZone
    P_EmpowerCD := EmpowerCD

    ReturnValue := false

    for ID, CleanMap in InstanceMap {
        OutputDebug("`n ID: " ID " | PID: " PreviousID)
        if PreviousID = ID {
            ReturnValue := TheNuclearBomb()
            continue
        }
        OutputDebug("`nAYYYY")

        LATime := 600000

        if CleanMap["Action"] = "Anti-Afk" {
            LATime := CleanMap["AfkSettings"].ClickTime
        }

        if (A_TickCount - CleanMap["LastActivated"]) >= LATime {
            BT1 := A_TickCount
            if not WinExist("ahk_id " ID) {
                InstanceMap.Delete(ID)
                continue
            }

            loop {
                WinActivate("ahk_id " ID)

                if WinActive("ahk_id " ID) {
                    break
                } else if A_TickCount - BT1 >= 20000 {
                    break
                }
                Sleep(100)
            }

            Sleep(200)
            switch CleanMap["Action"] {
                case "Macro":
                    MapChange(CleanMap)

                    if TheNuclearBomb() {
                        CleanMap["CurrentZone"] := 0
                        CleanMap["AutoFarmZone"] := 0
                        CleanMap["SubPosition"] := "Void" 
                        CleanMap["PreviousRunTime"] := 0
                        CleanMap["LastActivated"] := A_TickCount
                    }

                    loop 5 {
                        SendEvent "{Click, " PositionMap["MiddleOfScreen"][1] ", " PositionMap["MiddleOfScreen"][2] ", 1}"
                        Sleep(100)
                    }
                default:
                    loop 5 {
                        SendEvent "{Click, " CleanMap["AfkSettings"].ClickPosition[1] ", " CleanMap["AfkSettings"].ClickPosition[2] ", 1}"
                        Sleep(100)
                    }
            }

            CleanMap["LastActivated"] := A_TickCount
        }
    }

    if PreviousID != -1 {
        BT2 := A_TickCount
        loop {
            WinActivate("ahk_id " PreviousID)

            if WinActive("ahk_id " PreviousID) {
                break
            } else if A_TickCount - BT2 >= 20000 {
                break
            }
            Sleep(100)
        }

        MapChange(InstanceMap[PreviousID])
        SubPosition := P_SubPosition
        CurrentZone := P_CurrentZone
        TotalLoopAmount := P_TotalLoopAmount
        AutofarmZone := P_AutofarmZone
        EmpowerCD := P_EmpowerCD
    }

    return ReturnValue
}

; Macro Functions

; Runs at the start before anything
; Moves character away from eggs currently if hatch eggs
M_Fn1() {
    global SubPosition
    global CurrentZone
    global TotalLoopAmount
    global AutofarmZone
    global EmpowerCD

    if MacroTogglesMap["HatchEggs"] and TotalLoopAmount > 0 {
        SaveToDebug("Having character escape utter defeat")

        SendEvent "{S Down}"
        Sleep(900)
        SendEvent "{S Up}"

        UBT1 := A_TickCount
        TpDetections := 0
        loop {
            SendEvent "{Click, " PositionMap["MiddleOfScreen"][1] ", " PositionMap["MiddleOfScreen"][2] ", 1}"

            if EvilSearch(PixelSearchTables["TpButton"], false)[1] {
                TpDetections += 1
            } else {
                TpDetections := 0
            }

            if A_TickCount - UBT1 >= 15000 {
                break
            } else if TpDetections >= 10 {
                break
            }

            Sleep(20)
        }
    }
}

; Daycare & Empower
M_Fn2() {
    global SubPosition
    global CurrentZone
    global TotalLoopAmount
    global AutofarmZone
    global EmpowerCD

    if MacroTogglesMap["AutoDaycare"] or MacroTogglesMap["AutoEmpower"] {
        if SubPosition = "Void" or CurrentZone = 0 {
            RouteUser(Routes["BasicTP"])
        }
        ReturnToVoid()

        CurrentZone := 0
        SubPosition := "Void"

        RouteUser(Routes["VoidToComputer"])

        switch true {
            case (MacroTogglesMap["AutoEmpower"] and MacroTogglesMap["AutoDaycare"]):
                SaveToDebug("Daycare & Empower")
                DaycareOfDestruction()
                EmpowerMyEnchant()

            case (MacroTogglesMap["AutoDaycare"] and not MacroTogglesMap["AutoEmpower"]):
                SaveToDebug("Daycare & NO EMPOWERRAHGHHH")

                DaycareOfDestruction()

                SendEvent "{A Down}"
                Sleep(1500)
                SendEvent "{A Up}"
                CleanUI()
            case (MacroTogglesMap["AutoEmpower"] and not MacroTogglesMap["AutoDaycare"]):
                SaveToDebug("NO DAYCARE BUT VERY MUCH EMPOWER")

                EmpowerMyEnchant()
            default:
                SaveToDebug("if you got here shits fucked up")
                OutputDebug("`nNeither or something idk somethings probably fucked")
        } 
    }
}

; GiftClaim
M_Fn3() {
    if MacroTogglesMap["AutoGiftClaim"] {
        SaveToDebug("Birthday simulator")

        GiftClaimNonsense()
    }
}

; Fruits
M_Fn4() {
    if MacroTogglesMap["AutoFruits"] {
        SaveToDebug("Fruitville USA")

        ItemUseicalFunction(["Apple", "Banana", "Orange", "Pineapple", "Watermelon", "Rainbow Fruit"], BooleanValueMap["ShinyFruitToggle"])
    }
}

; Main Function for farming / hatching
M_Fn5() {
    global SubPosition
    global CurrentZone
    global TotalLoopAmount
    global AutofarmZone
    global EmpowerCD
    global PixelSearchTables

    if MacroTogglesMap["FarmZone"] or MacroTogglesMap["HatchEggs"] {
        if not CurrentZone = ZoneInformation.FinalZone.Zone_Number {
            SaveToDebug("Going to the zone of evil")

            RouteUser(Routes["VoidToFinal"])
            CurrentZone := ZoneInformation.FinalZone.Zone_Number
            SubPosition := "FinalArea"

            EnableAutofarm()
            EnableAutoHatch()
        } else if SubPosition = "Egg" or SubPosition = "Egg_S" {
            SaveToDebug("Going to the zone of evil but we are eggical")

            switch SubPosition {
                case "Egg":
                    RouteUser(Routes["EggToFinal"])
                case "Egg_S":
                    RouteUser(Routes["EggToAway"])
            }
            SubPosition := "FinalArea"

            UBT1 := A_TickCount
            TpDetections := 0
            loop {
                SendEvent "{Click, " PositionMap["MiddleOfScreen"][1] ", " PositionMap["MiddleOfScreen"][2] ", 1}"

                if EvilSearch(PixelSearchTables["TpButton"], false)[1] {
                    TpDetections += 1
                } else {
                    TpDetections := 0
                }

                if A_TickCount - UBT1 >= 15000 {
                    break
                } else if TpDetections >= 10 {
                    break
                }

                Sleep(20)
            }

            EnableAutofarm()
            EnableAutoHatch()
        }

        StupendousArray := []

        if MacroTogglesMap["AutoFlag"] {
            SaveToDebug("Autoflagicals")

            StupendousArray.InsertAt(StupendousArray.Length + 1, TextValueMap["FlagToUse"])
        }

        if MacroTogglesMap["AutoSprinkler"] {
            SaveToDebug("AutoSprinkicals")

            StupendousArray.InsertAt(StupendousArray.Length + 1, "Sprinkler")
        }

        if StupendousArray.Length > 0 {
            SaveToDebug("Mr. SouthWest approves this line")

            ItemUseicalFunction(StupendousArray)
        }

        if SubPosition = "Egg_S" {
            RouteUser(Routes["EggToAntiAway"])
        }
    
        CleanUI()

        SaveToDebug("Here we kinda do alot and im not setting up debug lines for allat")
        switch {
            case MacroTogglesMap["FarmZone"] and not MacroTogglesMap["HatchEggs"]:
                if Not MultiInstancingEnabled {
                    BreakTime := A_TickCount
                    loop {
                        if MacroTogglesMap["AutoUseItem"] {
                            ItemUseicalFunctionSingular(AutoItemSelection)
                        }
    
                        if MacroTogglesMap["AutoUseUltimate"] {
                            CleanUI()
                            SendEvent "{R Down}{R Up}"
                        }
    
                        if A_TickCount - BreakTime >= (NumberValueMap["LoopDelayTime"] * 1000) + 1000 {
                            break
                        }
                    }
                } else {
                    if MacroTogglesMap["AutoUseUltimate"] {
                        CleanUI()
                        SendEvent "{R Down}{R Up}"
                    }
                }
            case MacroTogglesMap["HatchEggs"] and not MacroTogglesMap["FarmZone"]:
                if not ZoneInformation.FinalZone.IsEggInZone {
                    RouteUser(Routes["FinalToEgg"])
                    SubPosition := "Egg"
                } else {
                    SubPosition := "Egg_S"
                }
    
                UBT1 := A_TickCount
                MiniXNum := 0
                loop {
                    SendEvent "{E Down}{E Up}"
    
                    if EvilSearch(PixelSearchTables["MiniX"], false)[1] {
                        MiniXNum += 1

                        if MiniXNum >= 3 {
                            break
                        }

                    } else if A_TickCount - UBT1 >= 12000 {
                        break
                    } else {
                        MiniXNum := 0
                    }
    
                    Sleep(200)
                }
    

                SendEvent "{Click, " PositionMap["EggMaxBuy"][1] ", " PositionMap["EggMaxBuy"][2] ", 1}"
                Sleep(300)
    
                if not MultiInstancingEnabled {
                    BreakTime := A_TickCount
                    loop {
                        SendEvent "{Click, " PositionMap["MiddleOfScreen"][1] ", " PositionMap["MiddleOfScreen"][2] ", 1}"
    
                        if A_TickCount - BreakTime >= (NumberValueMap["LoopDelayTime"] * 1000) + 1000 {
                            break
                        }
    
                        Sleep(10)
                    }
                }
            case MacroTogglesMap["FarmZone"] and MacroTogglesMap["HatchEggs"]:
                if not MultiInstancingEnabled {
                    BreakTime := A_TickCount
                    loop {
                        if MacroTogglesMap["AutoUseItem"] {
                            ItemUseicalFunctionSingular(AutoItemSelection)
                        }
    
                        if MacroTogglesMap["AutoUseUltimate"] {
                            CleanUI()
                            SendEvent "{R Down}{R Up}"
                        }
    
                        if A_TickCount - BreakTime >= (NumberValueMap["Egg&FarmSplitTime"] * 1000) + 1000 {
                            break
                        }
                    }
    
                    if not ZoneInformation.FinalZone.IsEggInZone {
                        RouteUser(Routes["FinalToEgg"])
                        SubPosition := "Egg"
                    }
    
                    UBT1 := A_TickCount
                    loop {
                        SendEvent "{E Down}{E Up}"
    
                        if EvilSearch(PixelSearchTables["MiniX"], false)[1] {
                            break
                        } else if A_TickCount - UBT1 >= 12000 {
                            break
                        }
    
                        Sleep(200)
                    }
    
                    SendEvent "{Click, " PositionMap["EggMaxBuy"][1] ", " PositionMap["EggMaxBuy"][2] ", 1}"
                    Sleep(300)
    
                    BreakTime += 600
                    loop {
                        SendEvent "{Click, " PositionMap["MiddleOfScreen"][1] ", " PositionMap["MiddleOfScreen"][2] ", 1}"
    
                        if A_TickCount - BreakTime >= (NumberValueMap["LoopDelayTime"] * 1000) + 1000 {
                            break
                        }
    
                        Sleep(10)
                    }
                } else {
                    if not ZoneInformation.FinalZone.IsEggInZone {
                        RouteUser(Routes["FinalToEgg"])
                        SubPosition := "Egg"
                    } else {
                        SubPosition := "Egg_S"
                    }
    
                    UBT1 := A_TickCount
                    loop {
                        SendEvent "{E Down}{E Up}"
    
                        if EvilSearch(PixelSearchTables["MiniX"], false)[1] {
                            break
                        } else if A_TickCount - UBT1 >= 12000 {
                            break
                        }
    
                        Sleep(200)
                    }
    
                    SendEvent "{Click, " PositionMap["EggMaxBuy"][1] ", " PositionMap["EggMaxBuy"][2] ", 1}"
                    Sleep(300)
                }
        }
    }

}

; Main
F3::{
    global OutPutFile
    global RunTime

    if not MacroEnabled {
        return
    }

    if not DirExist(A_MyDocuments "\PS99_Macros\Storage\MultiMacroV4Debug") {
        DirCreate(A_MyDocuments "\PS99_Macros\Storage\MultiMacroV4Debug")
    }

    OpF_Num := 1
    loop files, A_MyDocuments "\PS99_Macros\Storage\MultiMacroV4Debug\*.txt" {
        OpF_Num++
    }

    OutPutFile := A_MyDocuments "\PS99_Macros\Storage\MultiMacroV4Debug\MMV4_Output_" OpF_Num ".txt"
    FileAppend("-/ Macro Started at [" FormatTime(A_Now, "MM/dd/yyyy | h:mm tt") "] \-", OutPutFile)
    RunTime := A_TickCount


    global PixelSearchTables := Map(
        "X", [
            PositionMap["XTL"][1], PositionMap["XTL"][2],
            PositionMap["XBR"][1], PositionMap["XBR"][2],
            0xFF0B4E, 5
        ],
        "MiniX", [
            PositionMap["MiniXTL"][1], PositionMap["MiniXTL"][2],
            PositionMap["MiniXBR"][1], PositionMap["MiniXBR"][2],
            0xFF0B4E, 5
        ],
        "SearchField", [
            PositionMap["SearchFieldTL"][1], PositionMap["SearchFieldTL"][2],
            PositionMap["SearchFieldBR"][1], PositionMap["SearchFieldBR"][2],
            0x1E1E1E, 3
        ],
        "EnchantSearch", [
            PositionMap["EnchantSelectionTL"][1], PositionMap["EnchantSelectionTL"][2],
            PositionMap["EnchantSelectionBR"][1], PositionMap["EnchantSelectionBR"][2],
            0x000000, 0
        ],
        "OkayButton", [
            PositionMap["OkayButtonTL"][1], PositionMap["OkayButtonTL"][2],
            PositionMap["OkayButtonBR"][1], PositionMap["OkayButtonBR"][2],
            0x7EF50D , 3
        ], 
        "AntiOkayButton", [
            PositionMap["OkayButtonTL"][1], PositionMap["OkayButtonTL"][2],
            PositionMap["OkayButtonBR"][1], PositionMap["OkayButtonBR"][2],
            0xC1C4DC, 1
        ],
        "StupidCat", [
            PositionMap["StupidCatBR"][1], PositionMap["StupidCatBR"][2],
            PositionMap["StupidCatTL"][1], PositionMap["StupidCatTL"][2],
            0x95AACD, 10
        ],
        "EnrollButton", [
            ScrollPositions["EnrollButtonScroll"].PositionTL[1], ScrollPositions["EnrollButtonScroll"].PositionTL[2],
            ScrollPositions["EnrollButtonScroll"].PositionBR[1], ScrollPositions["EnrollButtonScroll"].PositionBR[2],
            0x61E0FE, 5
        ],
        "DaycareMiniX", [
            PositionMap["DaycareMiniXTL"][1], PositionMap["DaycareMiniXTL"][2],
            PositionMap["DaycareMiniXBR"][1], PositionMap["DaycareMiniXBR"][2],
            0xFF0B4E, 5
        ],
        "DaycareOkButton", [
            PositionMap["DaycareOkButtonTL"][1], PositionMap["DaycareOkButtonTL"][2],
            PositionMap["DaycareOkButtonBR"][1], PositionMap["DaycareOkButtonBR"][2],
            0x7FF60E, 5
        ],
        "AutoHatchEnable", [
            PositionMap["AutoHatchTL"][1], PositionMap["AutoHatchTL"][2],
            PositionMap["AutoHatchBR"][1], PositionMap["AutoHatchBR"][2],
            0xFF1055, 20
        ],
        "AutoFarmEnable", [
            PositionMap["AutoFarmTL"][1], PositionMap["AutoFarmTL"][2],
            PositionMap["AutoFarmBR"][1], PositionMap["AutoFarmBR"][2],
            0xFF1055, 20
        ],
        "AutoFarmRenable", [
            PositionMap["AutoFarmTL"][1], PositionMap["AutoFarmTL"][2],
            PositionMap["AutoFarmBR"][1], PositionMap["AutoFarmBR"][2],
            0x82F60F, 20
        ],
        "TpButton", [
            PositionMap["TPButtonTL"][1], PositionMap["TPButtonTL"][2],
            PositionMap["TPButtonBR"][1], PositionMap["TPButtonBR"][2],
            0xEC0D3A, 15
        ],
        "DBGLS", [
            PositionMap["DisconnectedBackgroundLS"][1], PositionMap["DisconnectedBackgroundLS"][2],
            PositionMap["DisconnectedBackgroundLS"][1], PositionMap["DisconnectedBackgroundLS"][2],
            0x393B3D, 3
        ],
        "DBGRS", [
            PositionMap["DisconnectedBackgroundRS"][1], PositionMap["DisconnectedBackgroundRS"][2],
            PositionMap["DisconnectedBackgroundRS"][1], PositionMap["DisconnectedBackgroundRS"][2],
            0x393B3D, 3
        ],
        "ReconnectButton", [
            PositionMap["ReconnectButton"][1], PositionMap["ReconnectButton"][2],
            PositionMap["ReconnectButton"][1], PositionMap["ReconnectButton"][2],
            0xFFFFFF, 3
        ],
    )

    ; Uh this shit here gets a little confusing id say,
    ; RecMap is basically (ID1, IDOBJ, ID2, IDOBJ)
    ; If action is "Macro" (IDOBJ.Action), it is strututureufdud like:
    ; {
    ;     Obj:UI, Clone:MapIndexClone, Action:"Macro"
    ; } MapIndexClone is basically a clone of the Entire map sent through the UI
    ; If the action is "Anti-Afk":
    ; {
    ;     Map:ObtainedMap, Obj:UI, Action:ToDo
    ; }
    ; ObtainedMap is basically just: Map(
    ;     "Afk Settings", {ClickTime:Num, ClickPosition:[Pos1, Pos2]}
    ; )

    InstanceMap := ""

    if MultiInstancingEnabled {
        SaveToDebug("Cleaning Up Multi-Instance")
        InstanceMap := CleanUpMulti(ReturnedUITable.Instances.RecMap)
    }

    CurrentID := -1

    loop {
        if MultiInstancingEnabled {
            FollowThroughWithLoop := false

            for ID, CleanMap in InstanceMap {
                if CleanMap["Action"] = "Macro" and (A_TickCount - CleanMap["PreviousRunTime"]) >= (CleanMap["NumberValueMap"]["LoopDelayTime"] * 1000) {
                SaveToDebug("- Staring loop for ID:" ID " -")

                    MapChange(CleanMap)
                    FollowThroughWithLoop := true
                    CurrentID := ID
                    break
                }

                Sleep(200)
                AntiAfkCheck_Multi(InstanceMap, CurrentID)
            }

            if not FollowThroughWithLoop {
                continue
            }

            BT3 := A_TickCount

            loop {
                WinActivate("ahk_id " CurrentID)

                if WinActive("ahk_id " CurrentID) {
                    break
                } else if A_TickCount - BT3 >= 20000 {
                    break
                }

                Sleep(100)
            }
        }

        ; Main Functions here!!!!
        global SubPosition
        global CurrentZone
        global TotalLoopAmount
        global AutofarmZone
        global EmpowerCD
        SaveToDebug("LoopAmount:" TotalLoopAmount " | SubPosition:" SubPosition " | CurrentZone:" CurrentZone " | EmpowerCD:" EmpowerCD)

        ForceNextLoop := false
        for _, Function in [M_Fn1, M_Fn2, M_Fn3, M_Fn4, M_Fn5] {
            SaveToDebug("Starting Function in list : " _)
            Function()
            SaveToDebug("Finished Funciton in list : " _)
            

            if AntiAfkCheck_Multi(InstanceMap, CurrentID) {
                SaveToDebug("Disconnect Issue : Reconnecting")

                CurrentZone := 0
                AutofarmZone := 0
                SubPosition := "Void"

                if MultiInstancingEnabled {
                    CleanMap := InstanceMap[CurrentID]
                    CleanMap["CurrentZone"] := CurrentZone
                    CleanMap["AutoFarmZone"] := AutofarmZone
                    CleanMap["EmpowerCD"] := EmpowerCD
                    CleanMap["TotalLoopAmount"] := TotalLoopAmount
                    CleanMap["SubPosition"] := SubPosition 
                    CleanMap["PreviousRunTime"] := 0
                    CleanMap["LastActivated"] := A_TickCount
                }

                ForceNextLoop := true
                break
            }
        }

        if ForceNextLoop {
            continue
        }
        SaveToDebug("Finished Loop sequence")


        TotalLoopAmount += 1
        SendEvent "{Q Down}{Q Up}"

        if MultiInstancingEnabled {
        SaveToDebug("Saving Current information to CleanMap Of ID:" CurrentID)

            CleanMap := InstanceMap[CurrentID]
            CleanMap["CurrentZone"] := CurrentZone
            CleanMap["AutoFarmZone"] := AutofarmZone
            CleanMap["EmpowerCD"] := EmpowerCD
            CleanMap["TotalLoopAmount"] := TotalLoopAmount
            CleanMap["SubPosition"] := SubPosition 
            CleanMap["PreviousRunTime"] := A_TickCount
            CleanMap["LastActivated"] := A_TickCount
        }
    }
}

TheMostScuffedTimeCreation(Num) {
    NumMap := Map(
        "s", 1000,
        "m", (1000 * 60),
        "h", ((1000 * 60) * 60),
        "d", (((1000*60)*60)*24)
    )
    NumOrder := ["d", "h", "m", "s"]
    CurrentNum := Num

    BestText := ""

    for _, Abrev in NumOrder {
        if CurrentNum / (NumMap[Abrev]) > 1 {
            Amount := Floor(CurrentNum/NumMap[Abrev])
            CurrentNum -= (NumMap[Abrev] * Amount)

            Huh := String("" Amount)
            if InStr(Huh, ".") {
                Split := StrSplit(BestText, ".")
                NewPastPeriod := SubStr(Split[2], 1, 3)
                BestText := BestText Split[1] Abrev " "
            } else {
                BestText := BestText Huh Abrev " "
            }
        }
    }

    return BestText
}

SaveToDebug(Text, IncludeTime := true, IncludeRunTime := true) {
    global OutPutFile
    DebugString := ""

    if IncludeTime {
        DebugString := "[" FormatTime(A_Now, "MM/dd/yyyy | h:mm tt") "]"
    }

    if IncludeRunTime {
        DebugString := DebugString "[" TheMostScuffedTimeCreation(A_TickCount - RunTime) "]"
    }
    
    if IncludeRunTime or IncludeRunTime {
        DebugString := DebugString ": "
    }

    DebugString := "`n" DebugString Text

    FileAppend(DebugString, OutPutFile)
}

F8::ExitApp
F6::Pause -1
