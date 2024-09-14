; /[V4.0.09]\ (Used for auto-update)
#Requires AutoHotkey v2.0

global Version := "4.1.0"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\BasePositionsPS99.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctions.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctionsPS99.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\EasyUI.ahk"

CoordMode "Pixel", "Window"
CoordMode "Mouse", "Window"
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

ZoneInformation := {
    FinalZone:{
        Zone_Number:224,
        IsEggInZone:false,
        Zone_Name:"Kawaii Temple",
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
    "UserOwnsDaycareGamepass", false,
    "EnableAutoHatch", true,
    "EnableAutoHatch_Golden", false,
    "EnableAutoHatch_Charged", false,
    "ShinyFruitToggle", false,
    "UserIsPastRebirth9", true,
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
    "FinalToEgg", "r:[0%W800&950%Q10]",
    "EggToFinal", "r:[0%S700]",
    "EggToAway", "r:[0%A700]",
    "EggToAntiAway", "r:[0%D700]"
)

ColoredTiers := [0xDAD9E4, 0xBEFEA7, 0x9DEEFE, 0xFFDAA6, 0xFFB1BC, 0xFFBAFE, 0xFFF8B9, 0xEAFFFF, 0xF7E3FE]
TierArray := ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]

EnchantEmpowering := Map(
    "Diamonds", [{TierText:"IX", TierValue:9, Amount:1}],
    ; "Strong Pets", [{TierText:"V", TierValue:5, Amount:1}],
)

AutoItemSelection := Map(
    "Lucky Block", 12
)

; ---- MAIN FUNCTIONS FOR LOOP ----
; New as freak!
EmpowerMyEnchant() {
    SuccessfulEmpoweredEnchants := Map()
    OuterBreak := false
    global EmpowerCD

    if not A_TickCount - EmpowerCD >= 0 {
        SendEvent "{A Down}"
        Sleep(1500)
        SendEvent "{A Up}"
    
        Clean_UI()    
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
                    PM_ClickPos("SuperComputer_TopMiddle", 0)
                    Sleep(100)

                    loop 15 {
                        SendEvent "{WheelUp}"
                        Sleep(10)
                    }
        
                    Sleep(200)
    
                    loop 9 {
                        SendEvent "{WheelDown}"
                        Sleep(200)
                    }
    
                    PM_ClickPos("SuperComputer_EmpowerEnchantButton")
                } else {
                    SetPixelSearchLoop("X", 20000, 1,,[{Key:"Space", Time:200, DownTime:10}])

                    loop 15 {
                        SendEvent "{WheelUp}"
                        Sleep(10)
                    }

                    Sleep(200)


                    loop 9 {
                        SendEvent "{WheelDown}"
                        Sleep(200)
                    }
    
                    Sleep(200)
                    PM_ClickPos("SuperComputer_EmpowerEnchantButton")
                }
    
                Sleep(500)
                PM_ClickPos("SearchField")
                Sleep(200)
    
                SendText EnchantName
                Sleep(200)
    
                ; Make sure we searched the thing successfully
                Empower_SearchFunc(*) {
                    PM_ClickPos("TopOfGame")
                    Sleep(200)
                
                    PM_ClickPos("SearchField")
                    Sleep(200)
                
                    SendText EnchantName
                    Sleep(200)
                }

                SetPixelSearchLoop("SearchField", 12000, 1,,,,1,[{Func:Empower_SearchFunc, Time:1000}])
    
                ; Clone the PixelSearchTable and set the color value with the tier of enchant
                ClonedPSTable := PixelSearchTables["Empower_EnchantSelection"].Clone()

                ClonedPSTable[5] := ColoredTiers[EnchantObject.TierValue]

    
                SearchedTable := EvilSearch(ClonedPSTable, true)
                ; OutputDebug()

                if not SearchedTable[1] {
                    OutputDebug("Could Not Find Enchant Tier")
                    Clean_UI()
                    break
                }
    
                ; Create positons for each row
                CreationXArray := []
                CreationYArray := []
                
                loop 4 {
                    CreationXArray.Push(X_PositionMap["Empower_EnchantX" A_Index])
                }

                loop 3 {
                    CreationYArray.Push(Y_PositionMap["Empower_EnchantY" A_Index])
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
                    if EvilSearch(PixelSearchTables["Empower_OkayButton"], false)[1] {
                        Sleep(200)
                        PM_ClickPos("Empower_OkayButton")
    
                        SetPixelSearchLoop("MiniX", 16000, 1,,,,,,)

                        PM_ClickPos("OkayButton")
    
                        try {
                            SuccessfulEmpoweredEnchants[EnchantName].Amount += 1
                        } catch as e {
                            SuccessfulEmpoweredEnchants[EnchantName] := {Amount:1,TierText:EnchantObject.TierText}
                        }

                        break
                    }
    
                    ; Could be a else if but wanted to comment here
                    ; Checks if the player is POOR
                    if EvilSearch(PixelSearchTables["Evil_Empower_OkayButton"], false)[1] {
                        Clean_UI()
                        OutputDebug("Pooron")
                        OuterBreak := true
                        break
                    }
                }
    
                if OuterBreak {
                    break
                }
    
                Sleep(300)
                Clean_UI()
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
    if not BooleanValueMap["UserIsPastRebirth9"] {
        SendEvent "{A Down}"
        Sleep(1500)
        SendEvent "{A Up}"
    }

    Clean_UI()

    Breaktime4 := A_TickCount
    loop {
        SendEvent "{F Down}{F Up}"
        Sleep(500)

        if EvilSearch(PixelSearchTables["X"], false)[1] or (A_TickCount - Breaktime4) >= (15*1000) {
            break
        }
    }
    Sleep(400)

    PM_ClickPos("InventoryEnchantsButton")
    Sleep(1000) ; not taking chances

    ; We gonna equip the enchants now
    for Enchant, AmountTable in SuccessfulEmpoweredEnchants {
        PM_ClickPos("SearchField")
        Sleep(200)

        SendText Enchant " " AmountTable.TierText
        Sleep(200)


        Empower_InvSearchFunc(*) {
            PM_ClickPos("TopOfGame")
            Sleep(200)

            PM_ClickPos("SearchField")
            Sleep(200)

            SendText Enchant " " AmountTable.TierText
            Sleep(200)
        }

        ; Make sure we searched the thing successfully 2.0
        SetPixelSearchLoop("SearchField", 12000, 1,,,,,[{Func:Empower_InvSearchFunc, Time:800}])

        loop AmountTable.Amount {
            PM_ClickPos("EnchantEquipSlot1")

            Sleep(700)
        }
    }

    Clean_UI()
    OutputDebug("Finished")
}

; The return.
ItemUseicalFunction(ItemArray, UseSecondary := false) {
    IM := PM_GetPos("ItemMiddle")
    ITL := PM_GetPos("ItemTL")
    IBR := PM_GetPos("ItemBR")

    Clean_UI()
    for _LoopNum, Item in ItemArray {
        RandomPositions := [
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])],
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])],
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])],
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])],
            [Random(IBR[1], ITL[1]), Random(IBR[2], ITL[2])]
        ]

        if UseSecondary and Item != "Rainbow Fruit" {
            IM := PM_GetPos("SecondaryItemMiddle")
        } else {
            IM := PM_GetPos("ItemMiddle")
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

            PM_ClickPos("InventoryBackpackButton")
            Sleep(200)
        }

        PM_ClickPos("TopOfGame")
        Sleep(100)

        PM_ClickPos("SearchField")
        Sleep(100)

        SendText Item
        Sleep(250)

        ; you see i was gonna change all these but im lazy as hell and they work as is so.
        if not EvilSearch(PixelSearchTables["SearchField"], false)[1] {
            BreakTime2 := A_TickCount
            loop {
                PM_ClickPos("TopOfGame")
                Sleep(200)

                PM_ClickPos("SearchField")
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
                Sleep(200)

                if EvilSearch(PixelSearchTables["StupidCat"], false)[1] {
                    Clean_UI()
                    break
                }

                SetPixelSearchLoop("X",15000,1,,[{Key:"F", Time:500, Downtime:10}])
                PM_ClickPos("InventoryBackpackButton")
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
                    PM_ClickPos("TopOfGame")
                    Sleep(200)
    
                    PM_ClickPos("SearchField")
                    Sleep(200)
            
                    SendText Item
                    Sleep(250)

                    TotalResearches += 1
                }
        
                Breaktimeidk := A_TickCount
                if not EvilSearch(PixelSearchTables["SearchField"], false)[1] {
                    loop {
                        PM_ClickPos("TopOfGame")
                        Sleep(200)
        
                        PM_ClickPos("SearchField")
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

                SendEvent "{Click, " IM[1] ", " IM[2] ", 1}"

                Sleep(100)
                if EvilSearch(PixelSearchTables["StupidCat"], false)[1] {
                    Breaktime3 := A_TickCount

                    loop {
                        PM_ClickPos("OkayButton")
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

    Sleep(300)
    Clean_UI()
    OutputDebug("Function Over")
}

; The eviler return
ItemUseicalFunctionSingular(ItemMap) {
    Clean_UI()
    for Item, Delay in ItemMap {
        SetPixelSearchLoop("X",15000,1,,[{Key:"F", Time:500, Downtime:10}])
        Sleep(200)

        PM_ClickPos("InventoryBackpackButton")
        Sleep(200)

        PM_ClickPos("SearchField")
        Sleep(100)

        SendText Item
        Sleep(100)

        if not EvilSearch(PixelSearchTables["SearchField"], false)[1] {
            BreakTime2 := A_TickCount
            loop {
                PM_ClickPos("TopOfGame")
                Sleep(200)

                PM_ClickPos("SearchField")
                Sleep(200)
        
                SendText Item
                Sleep(200)

                if EvilSearch(PixelSearchTables["SearchField"], false)[1] or (A_TickCount - BreakTime2) >= (12*1000) {
                    break
                }

                if not EvilSearch(PixelSearchTables["X"])[1] {
                    SendEvent "{F Down}{F Up}"
                }
            }
        }

        Sleep(20)
        PM_ClickPos("ItemMiddle")
        Sleep(Delay * 1000)

        SetPixelSearchLoop("StupidCat", 4000, 2, PM_GetPos("OkayButton"),)
    }
}

; Absolute evil
DaycareOfDestruction() {
    ;-- making sure we enter the daycare and also supercomputer is open or whatever idk
    ;-- its just copied from the empower enchant func
    loop 2 {
        if EvilSearch(PixelSearchTables["X"], false)[1] {
            PM_ClickPos("SuperComputer_TopMiddle", 0)
            Sleep(100)

            loop 15 {
                SendEvent "{WheelUp}"
                Sleep(10)
            }

            Sleep(200)
            PM_ClickPos("SuperComputer_DaycareButton")
        } else {
            SetPixelSearchLoop("X", 20000, 1,,[{Key:"Space", Time:100, Downtime:10}])
            Sleep(200)

            loop 15 {
                SendEvent "{WheelUp}"
                Sleep(10)
            }
    
            Sleep(200)
            PM_ClickPos("SuperComputer_DaycareButton")
        }
        Sleep(500)
    
        PsEbMap1 := PixelSearchTables["DaycareGP_EnrollButton"]
        
        if not BooleanValueMap["UserOwnsDaycareGamepass"] {
            SendEvent "{WheelDown}"
            Sleep(200)

            PsEbMap1 := PixelSearchTables["Daycare_EnrollButton"]
        }

        PsEbMap2 := PsEbMap1.Clone()
        PsEbMap2[5] := 0x6DF207
    
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
                        PM_ClickPos("TopOfGame")
                        Sleep(200)
                    }

                    PM_ClickPos("SearchField")
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
                PM_ClickPos("Daycare_PetSelection")
                Sleep(100)
                SendEvent "{Shift Up}"
                Sleep(300)

                if EvilSearch(PixelSearchTables["Daycare_OkayButton"], false)[1] {
                    PM_ClickPos("Daycare_OkayButton")

                    SetPixelSearchLoop("MiniX", 5000, 1)
                    Sleep(400)
                        
                    PM_ClickPos("YesButton")
                    SetPixelSearchLoop("X", 7500, 1)
                }

                break
            case SearchForGreen[1]:
                GreenPos := [SearchForGreen[2], SearchForGreen[3]]
    
                SendEvent "{Click, " GreenPos[1] ", " GreenPos[2] ", 1}"
                G_BreakTime1 := A_TickCount
    
                SetPixelSearchLoop("MiniX", 25000, 1)
                PM_ClickPos("MiniX")
                SetPixelSearchLoop("X", 15000, 1,,[{Key:"Space", Time:200, DownTime:10}])
            default:
                break
        }
    }

    Sleep(1000)
    Clean_UI()
}

; Very Simple!
GiftClaimNonsense() {
    Clean_UI()
    BreakTime1 := A_TickCount

    SetPixelSearchLoop("MiniX", 15000, 1, PM_GetPos("FreeGiftsButton"))

    ; Creating Points again
    CreationXArray := []
    CreationYArray := []

    loop 4 {
        CreationXArray.Push(X_PositionMap["GiftX" A_Index])
    }

    loop 3 {
        CreationYArray.Push(Y_PositionMap["GiftY" A_Index])
    }

    CreatedPositions := CreatePositions(CreationXArray, CreationYArray)

    for _PosIndex, Position in CreatedPositions {
        SendEvent "{Click, " Position[1] ", " Position[2] ", 1}"
        Sleep(300)
    }

    Clean_UI()
}

; and then i get the new layer 2 bell
ReturnToVoid() {
    SetPixelSearchLoop("X", 15000, 1, PM_GetPos("TpButton"))

    Sleep(200)
    loop 8 {
        PM_ClickPos("VoidButton")
        Sleep(100)
    }
    
    Sleep(NumberValueMap["TpWaitTime"])
    Clean_UI()
}

; ---- Some Other Functions ----
EnableAutoHatch() {
    Clean_UI()

    if not EvilSearch(PixelSearchTables["AutoHatch"], false)[1] {
        return
    }

    SetPixelSearchLoop("MiniX",12000,1,PM_GetPos("AutoHatch"))

    NameToPos := Map(
        "EnableAutoHatch", PM_GetPos("AutoHatch_Enable"),
        "EnableAutoHatch_Golden", PM_GetPos("AutoHatch_Golden"),
        "EnableAutoHatch_Charged", PM_GetPos("AutoHatch_Charged")
    )

    for N, P in NameToPos {
        if BooleanValueMap[N] {
            if N = "EnableAutoHatch" {
                if not EvilSearch(PixelSearchTables["AutoHatch_InternalCheck"])[1] {
                    SendEvent "{Click, " P[1] ", " P[2] ", 1}"
                    Sleep(200)
                }
            }

            SendEvent "{Click, " P[1] ", " P[2] ", 1}"
            Sleep(200)
        }
    }

    Clean_UI()
}

EnableAutofarm() {
    Clean_UI()

    if not BooleanValueMap["UserOwnsAutoFarm"] or CurrentZone = AutofarmZone {
        return
    }

    if EvilSearch(PixelSearchTables["AutoFarm"], false)[1] {
        PM_ClickPos("AutoFarm")
        Sleep(200)
    } else {
        PM_ClickPos("AutoFarm")
        Sleep(500)
        
        PM_ClickPos("AutoFarm")
        Sleep(200)
    }

    global AutofarmZone := CurrentZone
}

; Disconnect Function :):):):):):):):
TheNuclearBomb() {
    Arg1 := EvilSearch(PixelSearchTables["DisconnectBG_LS"], false)[1] 
    Arg2 := EvilSearch(PixelSearchTables["DisconnectBG_RS"], false)[1]
    Arg3 := EvilSearch(PixelSearchTables["ReconnectButton"], false)[1]

    if Arg1 and Arg2 and Arg3 {
        SetPixelSearchLoop("TpButton", 900000, 1, PM_GetPos("ReconnectButton"))

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
        {Map:Routes, Name:"Routes", Type:"Text", SaveName:"Routes", IsAdvanced:true},

    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"MultiMacroV4"}
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
    global MacroTogglesMap := CleanMap["MacroTogglesMap"]
    global BooleanValueMap := CleanMap["BooleanValueMap"]
    global TextValueMap := CleanMap["TextValueMap"]
    global NumberValueMap := CleanMap["NumberValueMap"]
    global EnchantEmpowering := CleanMap["EnchantEmpowering"]
    global CurrentZone := CleanMap["CurrentZone"]
    global Routes := CleanMap["Routes"]
    global AutoItemSelection := CleanMap["AutoItemSelection"]

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
                        PM_ClickPos("MiddleOfScreen")
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

        SendEvent "{Q Down}{Q Up}{S Down}"
        Sleep(750)
        SendEvent "{S Up}"

        UBT1 := A_TickCount
        TpDetections := 0
        loop {
            PM_ClickPos("MiddleOfScreen")

            if EvilSearch(PixelSearchTables["TpButton"], false)[1] {
                TpDetections += 1
            } else {
                TpDetections := 0
            }

            if A_TickCount - UBT1 >= 15000 {
                break
            } else if TpDetections >= 40 {
                break
            }

            OutputDebug("CHECKING")
            Sleep(20)
        }

        SubPosition := "FinalArea"
    }
}

; Support to Daycare & Empower
YeahCheck() {
    if BooleanValueMap["UserIsPastRebirth9"] {
        ItemUseicalFunctionSingular(Map("SuperComputer Radio", 1))
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
        if not BooleanValueMap["UserIsPastRebirth9"] {
            if SubPosition = "Void" or CurrentZone = 0 {
                RouteUser(Routes["BasicTP"])
            }
            ReturnToVoid()
    
            CurrentZone := 0
            SubPosition := "Void"
    
            RouteUser(Routes["VoidToComputer"])
        }

        switch true {
            case (MacroTogglesMap["AutoEmpower"] and MacroTogglesMap["AutoDaycare"]):
                SaveToDebug("Daycare & Empower")
                YeahCheck()
                DaycareOfDestruction()
                YeahCheck()
                EmpowerMyEnchant()

            case (MacroTogglesMap["AutoDaycare"] and not MacroTogglesMap["AutoEmpower"]):
                SaveToDebug("Daycare & NO EMPOWERRAHGHHH")

                YeahCheck()
                DaycareOfDestruction()

                if not BooleanValueMap["UserIsPastRebirth9"] {
                    SendEvent "{A Down}"
                    Sleep(1500)
                    SendEvent "{A Up}"
                }

                Clean_UI()
            case (MacroTogglesMap["AutoEmpower"] and not MacroTogglesMap["AutoDaycare"]):
                SaveToDebug("NO DAYCARE BUT VERY MUCH EMPOWER")

                YeahCheck()
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
                PM_ClickPos("MiddleOfScreen")

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
    
        Clean_UI()
        EnableAutoHatch()

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
                            Clean_UI()
                            SendEvent "{R Down}{R Up}"
                        }
    
                        if A_TickCount - BreakTime >= (NumberValueMap["LoopDelayTime"] * 1000) + 1000 {
                            break
                        }
                    }
                } else {
                    if MacroTogglesMap["AutoUseUltimate"] {
                        Clean_UI()
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
    

                PM_ClickPos("EggMaxBuy")
                Sleep(300)
    
                if not MultiInstancingEnabled {
                    BreakTime := A_TickCount
                    loop {
                        PM_ClickPos("MiddleOfScreen")
    
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
                            Clean_UI()
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
    
                    PM_ClickPos("EggMaxBuy")
                    Sleep(300)
    
                    BreakTime += 600
                    loop {
                        PM_ClickPos("MiddleOfScreen")
    
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
    
                    PM_ClickPos("EggMaxBuy")
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

    if not DirExist(A_MyDocuments "\MacroHubFiles\Storage\Debug\MultiMacroV4Debug") {
        DirCreate(A_MyDocuments "\MacroHubFiles\Storage\Debug\MultiMacroV4Debug")
    }

    OpF_Num := 1
    loop files, A_MyDocuments "\MacroHubFiles\Storage\Debug\MultiMacroV4Debug\*.txt" {
        OpF_Num++
    }

    OutPutFile := A_MyDocuments "\MacroHubFiles\Storage\Debug\MultiMacroV4Debug\MMV4_Output_" OpF_Num ".txt"
    FileAppend("-/ Macro Started at [" FormatTime(A_Now, "MM/dd/yyyy | h:mm tt") "] \-", OutPutFile)
    RunTime := A_TickCount


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
            OutputDebug(_)
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
