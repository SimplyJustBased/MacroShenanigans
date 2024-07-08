; /[V2.15Test]\ (Used for auto-update)

#Requires AutoHotkey v2.0
#Include "%A_MyDocuments%\PS99_Macros\Modules\UWBOCRLib.ahk"
#Include "%A_MyDocuments%\PS99_Macros\Modules\_JXON.ahk"
#Include "%A_MyDocuments%\PS99_Macros\Modules\Router.ahk"
#Include "%A_MyDocuments%\PS99_Macros\Modules\EasyUI.ahk"

#SingleInstance Force
CoordMode "Mouse", "Screen"
CoordMode "Pixel", "Screen"
SetMouseDelay -1

global Version := "2.[Test]"
global MacroSetup := false
global TEVal := 0
global TotalEstimatedValue := "1"
global MacroRunTime := 0
global KeysUsed := 0
global WorldResets := 0
global ItemPickMap := Map()
global CharmDetectionAmount := 0

global Routes := Map(
    "SpawnToDoor", "tp:Enchanted Forest|w_nV:TpWaitTime|r:[0%Q10&0%D400&420%W1540&2250%Q10]",
)

Description := "F3 : Start`nF8 : Stop`nF6 : Pause`nF5 : Debug`n`nMake sure to check out the video on the macro below, and join the discord if you have any issues / any questions on the macro"

global PositionMap := Map(
    "IBC_Item1", [620, 630],
    "IBC_Item2", [960, 630],
    "IBC_Item3", [1300, 630],
    "CC_Item1", [515,405],
    "CC_Item2", [860,405],
    "CC_Item3", [1192,405],
    "MMC_Item1", [515,405],
    "MMC_Item2", [860,405],
    "MMC_Item3", [1200,405],
    "MiniXTL", [1259, 232],
    "MiniXBR", [1313, 288],
    "MiniX", [1285, 262],
    "XTL", [1442, 231],
    "XBR", [1499, 285],
    "X", [1470, 257],
    "TPButton", [169, 395],
    "TPButtonTL", [126, 343],
    "TPButtonBR", [189, 415],
    "TPUIMiddle", [960, 360],
    "SearchBar", [1292, 258],
    "YesButtonTL", [663, 682],
    "YesButtonBR", [930, 755],
    "YesButton", [795, 724],
    "OkButtonRightSide", [1085, 715],
    "HomeButton", [966, 934],
    "SpawnWorldButton", [410, 451],
    "TechWorldButton", [410, 511],
)

global OCRMap := Map(
    "OffsetX", 10,
    "OffsetY", 10,
    "SizeX", 292,
    "SizeY", 85,
    "Scale", 5,
    "Scalar", 5
)

global NumberValueMap := Map(
    "DoorOpenWaitTime", 750,
    "OCRDelayTime", 200,
    "TpWaitTime", 7000,
    "WalkWaitTime", 500,
    "DoorOpenWaitTime", 700,
    "KeyResetAmount", 75
)

global ToggleValueMap := Map(
    "SetUnknownRarityToExclusive", false,
    "RarityDestruction", false,
    "DoKeyReset", true
)

global ColorsAndStuffMap := Map(
    "Basic", {
        Color:0xDBDAE6, RarityValue:1, CappedValue:100, ToCapValue:true, Numeral:"I"
    },
    "Rare", {
        Color:0xBFFFA8, RarityValue:2, CappedValue:500, ToCapValue:true, Numeral:"II"
    },
    "Epic", {
        Color:0x9EEFFF, RarityValue:3, CappedValue:3000, ToCapValue:true, Numeral:"III"
    },
    "Legendary", {
        Color:0xFFDAA6, RarityValue:4, CappedValue:65000, ToCapValue:true, Numeral:"IV"
    },
    "Mythical", {
        Color:0xFFB1BC, RarityValue:5, CappedValue:50000, ToCapValue:false, Numeral:"V"
    },
    "Exotic", {
        Color:0xFFBAFE, RarityValue:6, CappedValue:100000, ToCapValue:false, Numeral:"VI"
    },
    "Divine", {
        Color:0xFFF8B9, RarityValue:7, CappedValue:65005, ToCapValue:false, Numeral:"VII"
    },
    "Superior", {
        Color:0xEEFFFF, RarityValue:8, CappedValue:(10**6), ToCapValue:false, Numeral:"VIII"
    },
    "Celestial", {
        Color:0xF6E3FE, RarityValue:9, CappedValue:(25*(10**7)), ToCapValue:false, Numeral:"IX"
    },
    "Exclusive", {
        Color:0xD8BFFF, RarityValue:10, CappedValue:(2*(10**9)), ToCapValue:false, Numeral:"X"
    },
    "Unknown", {
        Color:0x000000, RarityValue:3, CappedValue:(125000), ToCapValue:false, Numeral:"I"
    }
)

NumeralToTier := [
    "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "XI", "XII", "XIII", "XIV", "XV", "XVI"
]

RapUI := Gui()
RapUI.Opt("-SysMenu -Caption +AlwaysOnTop")
RapUI.SetFont("s15")
RapUI.Add("Text","","Getting Rap Values From API | If this gets stuck, Hit F8")
RapUI.Show()

OutputDebug("Getting Rap")
whr := ComObject("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://biggamesapi.io/api/rap", true)
whr.Send()
whr.WaitForResponse()
RapList := whr.ResponseText

RapTable := Jxon_Load(&RapList)
global RapMap := Map()

RapCategoryIgnore := [
    "XPPotion"
]

for _, V1 in RapTable["data"] {
    ItemName := V1["configData"]["id"]

    if RapCategoryIgnore.Has(V1["category"]) {
        continue
    }

    if V1["category"] = "Pet" and not InStr(ItemName, "Huge") {
        continue
    }

    if InStr(ItemName, "Huge") {
        if not InStr(ItemName, "Lumi") {
            continue
        }
    }

    if V1["category"] = "Potion" {
        if not StrLower(ItemName) = StrLower("The CockTail") and not StrLower(ItemName) = StrLower("Lucky") {
            ItemName := ItemName " Potion"
        }
        if StrLower(ItemName) = StrLower("Lucky") {
            ItemName := "Lucky Eggs Potion"
        }
    }

    if V1["category"] = "Charm" {
        ItemName := ItemName " Charm"
    }

    if V1["configData"].has("tn") {
        if V1["configData"]["tn"] > 1 {
            ItemName := ItemName " " NumeralToTier[V1["configData"]["tn"]]
        }
    }

    SplitName := StrSplit(ItemName, " ")
    CurrentFurthestMap := RapMap

    for Num, Word in SplitName {
        TotalIterations := 0

        if CurrentFurthestMap.Has(Word) {
            CurrentFurthestMap := CurrentFurthestMap[Word]
        } else {
            CurrentFurthestMap[Word] := Map()
            CurrentFurthestMap := CurrentFurthestMap[Word]
        }

        if Num = SplitName.Length {
            CurrentFurthestMap["Value"] := V1["value"]
            ; OutputDebug("`nSet Value For Item " ItemName " At Value " V1["value"])
        }
    }
}

OutputDebug("`nFinished Setting up values")

RapUI.Hide()

PixelSearchTables := Map(
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
    ; "StupidCat", [
    ;     PositionMap["StupidCatBR"][1], PositionMap["StupidCatBR"][2],
    ;     PositionMap["StupidCatTL"][1], PositionMap["StupidCatTL"][2],
    ;     0x95AACD, 10
    ; ],
    "TpButton", [
        PositionMap["TPButtonTL"][1], PositionMap["TPButtonTL"][2],
        PositionMap["TPButtonBR"][1], PositionMap["TPButtonBR"][2],
        0xEC0D3A, 15
    ],
    "YesButton", [
        PositionMap["YesButtonTL"][1], PositionMap["YesButtonTL"][2],
        PositionMap["YesButtonBR"][1], PositionMap["YesButtonBR"][2],
        0x7DF50D, 10
    ],
    "OkButtonRightSide", [
        PositionMap["OkButtonRightSide"][1], PositionMap["OkButtonRightSide"][2],
        PositionMap["OkButtonRightSide"][1], PositionMap["OkButtonRightSide"][2],
        0x7DF50D, 10
    ]
)

global PMString := ""
PrintMap(Map, SpaceIndicator) {
    global PMString
    Ind := ""

    loop (SpaceIndicator * 3) {
        Ind := Ind " "
    }


    For Key, value in Map {
        if Type(value) = "Map" {
            PMString := PMString "`n" Ind Key ":["
            OutputDebug("`n" Ind Key ":[")
            PrintMap(value, SpaceIndicator + 1)
            OutputDebug("`n" Ind "]")
            PMString := PMString "`n" Ind "]"
        } else {
            PMString := PMString "`n" Ind Key ":" value
            OutputDebug("`n" Ind Key ":" value)
        }
    }

    A_Clipboard := PMString
}

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

ItemCheck(ItemNum) {
    ColorCheckCoord := PositionMap["CC_Item" ItemNum]
    MouseMoveCoord := PositionMap["MMC_Item" ItemNum]
    
    OffsetX := OCRMap["OffsetX"]
    OffsetY := OCRMap["OffsetY"]
    SizeX := OCRMap["SizeX"]
    SizeY := OCRMap["SizeY"]
    Scale := OCRMap["Scale"]
    Scalar := OCRMap["Scalar"]

    LastRarity := ""
    LastRarityValue := -1
    for Rarity, RarityInformation in ColorsAndStuffMap {
        if PixelSearch(&u, &u, ColorCheckCoord[1], ColorCheckCoord[2], ColorCheckCoord[1], ColorCheckCoord[2], RarityInformation.Color, 5) {
            if LastRarityValue < RarityInformation.RarityValue {
                LastRarity := Rarity
                LastRarityValue := RarityInformation.RarityValue
            }
        }
    }

    if LastRarityValue <= -1 {
        if ToggleValueMap["SetUnknownRarityToExclusive"] {
            LastRarity := "Exclusive"
        } else {
            LastRarity := "Unknown"
        }
    }
    
    Sleep(100)
    SendEvent "{Click, " MouseMoveCoord[1] ", " MouseMoveCoord[2] ", 0}"
    Sleep(NumberValueMap["OCRDelayTime"])
    
    PhsyicalValue := 0
    Value := 0
    SetValue := false
    CappedValue := false
    CurrentFurthestMap := RapMap
    ItemName := ""

    loop 3 {
        OCRResults := OCR.FromRect(
            (MouseMoveCoord[1] + OffsetX) - ((A_Index-1) * Scalar * 0.5), 
            (MouseMoveCoord[2] + OffsetY) - ((A_Index-1) * Scalar * 0.5), 
            (SizeX) + ((A_Index-1) * Scalar), 
            (SizeY) + ((A_Index-1) * Scalar), 
            ("en-US"), 
            (Scale)
        )

        for _, OCR_Word in OCRResults.Words {
            if RegExMatch(OCR_Word.Text, "i)hug|huge|lum|lumi|axo|axol|axolotl") {
                Value := (10 ** 9)
                SetValue := true
            }
    
            if RegExMatch(OCR_Word.Text, "i)over|overlo|overload|roy|royal|royalty") {
                global CharmDetectionAmount += 1
            }
            Word := OCR_Word.Text
    
            if CurrentFurthestMap.Has(Word) {
                
                if ItemName = "" {
                    ItemName := Word
                } else {
                    ItemName := ItemName " " Word
                }
    
                CurrentFurthestMap := CurrentFurthestMap[Word]

                if CurrentFurthestMap.Has("Value") {
                    PhsyicalValue := CurrentFurthestMap["Value"]
                    if not SetValue {
                        Value := CurrentFurthestMap["Value"]
                    }
                }
            }

            if A_Index = OCRResults.Words.Length {
                if CurrentFurthestMap.Has(ColorsAndStuffMap[LastRarity].Numeral) {
                    ItemName := ItemName " " ColorsAndStuffMap[LastRarity].Numeral

                    CurrentFurthestMap := CurrentFurthestMap[ColorsAndStuffMap[LastRarity].Numeral]

                    if CurrentFurthestMap.Has("Value") {
                        PhsyicalValue := CurrentFurthestMap["Value"]
                        if not SetValue {
                            Value := CurrentFurthestMap["Value"]
                        }
                    }
                }
            }
        }

        if Value > 0 or PhsyicalValue > 0{
            break
        } else {
            ItemName := ""
            CurrentFurthestMap := RapMap
            CappedValue := false
            SetValue := false
        }
    }

    lastValue := Value
    Value := Min(lastValue, ColorsAndStuffMap[LastRarity].CappedValue)
    if lastValue != Value {
        CappedValue := true
    }

    return {ItemName:ItemName, Rarity:LastRarity, RarityValue:LastRarityValue, RapValue:Value, ValueCapped:CappedValue, PHYV:PhsyicalValue}
}

Itemical() {
    global ItemPickMap
    ItemMap := Map()
    HighestItem := "Item1"
    HighestValue := 0
    HighestItemRarity := "Basic"

    loop 3 {
        ItemObject := ItemCheck(A_Index)

        ItemMap["Item" A_Index] := ItemObject
        OutputDebug("`nItem" A_Index " Is a " ItemObject.ItemName " which is worth " ItemObject.RapValue " gems and has a rarity of " ItemObject.Rarity " | CappedValue:" ItemObject.ValueCapped)

        if HighestValue < ItemObject.RapValue {
            HighestItem := "Item" A_Index
            HighestValue := ItemObject.RapValue
            HighestItemRarity := ItemObject.Rarity
        }
    }
    Sleep(100)

    if ToggleValueMap["RarityDestruction"] {
        if ColorsAndStuffMap[HighestItemRarity].RarityValue <= 3 {
            for Item, ItemObject in ItemMap {
                if ItemObject.RarityValue > 3 and ColorsAndStuffMap[HighestItemRarity].RarityValue < ItemObject.RarityValue {
                    HighestItem := Item
                    HighestValue := ItemObject.RapValue
                    HighestItemRarity := ItemObject.Rarity
                }
            }
        }
    }

    ButtonCoord := PositionMap["IBC_" HighestItem]

    BreakTime := A_TickCount
    loop {
        SendEvent "{Click, " ButtonCoord[1] + (Random(-5, 5)) ", " ButtonCoord[2] + (Random(-5, 5)) ", 1}"

        if (A_TickCount - BreakTime) >= 12000 {
            break
        }

        if not EvilSearch(PixelSearchTables["X"], false)[1] {
            global TEVal += ItemMap[HighestItem].PHYV

            if ItemPickMap.Has(ItemMap[HighestItem].ItemName) {
                ItemPickMap[ItemMap[HighestItem].ItemName].Amount += 1
            } else {
                ItemPickMap[ItemMap[HighestItem].ItemName] := {
                    Amount:1,
                    Rap:ItemMap[HighestItem].PHYV
                }
            }

            break
        }

        Sleep(10)
    }
}

ObjectOrder := ["Basic", "Rare", "Epic", "Legendary", "Mythical", "Exotic", "Divine", "Superior", "Celestial", "Exclusive", "Unknown"]
UIOBject := CreateBaseUI(Map(
    "Main", {Title:"TreeHouseMacro", Video:"X", Description:Description, Version:Version, DescY:250, MacroName:"Tree House Macro", IncludeFonts:true},
    "Settings", [
        {Map:ToggleValueMap, Name:"Toggle Settings", SaveName:"ToggleSettings", Type:"Toggle", IsAdvanced:false},
        {Map:NumberValueMap, Name:"Number Settings", SaveName:"NumberSettings", Type:"Number", IsAdvanced:false},
        {Map:PositionMap, Name:"Positioning Settings", SaveName:"PositionSettings", Type:"Position", IsAdvanced:false},
        {
        Map:ColorsAndStuffMap, Name:"Rarity Settings", SaveName:"RaritySettings", Type:"Object", IsAdvanced:false, 
        Booleans:Map("ToCapValue", true), ObjectIgnore:Map("Color", true, "RarityValue", true), ObjectOrder:ObjectOrder,
        ObjectsPerPage:5
        },
        {Map:Routes, Name:"Routes", SaveName:"Routes", Type:"Text", IsAdvanced:true},
        {Map:OCRMap, Name:"Ocr Settings", SaveName:"OcrSettings", Type:"Number", IsAdvanced:true},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\PS99_Macros\SavedSettings\", FolderName:"TreeHouseMacroV2"}
))

UIOBject.BaseUI.Show()

MacroEnabled(*) {
    global MacroSetup := true
    global MacroRunTime := A_TickCount
    UIOBject.BaseUI.Hide()

    for _, UI in __HeldUIs["UID" UIOBject.UID] {
        try {
            UI.Hide()
        }
    }

    global InformativeUI := Gui()
    InformativeUI.Opt("+LastFound +AlwaysOnTop -Caption +ToolWindow")
    InformativeUI.BackColor := "EEAA99"
    WinSetTransColor("EEAA99 255", InformativeUI)
    InformativeUI.SetFont("c0x000000 s20 w700")

    global Text := InformativeUI.AddText("w700 h200 Center", "Times Opened : " KeysUsed " | Estimated RAP Value : " TheMostScuffedNumberCreation(TEVal) "`nMacro Run Time : " Floor((A_TickCount - MacroRunTime)/1000) "s | World Resets : " WorldResets)
    InformativeUI.GetPos(&u, &u, &UIWidth, &UIHeight)
    InformativeUI.Show("X" A_ScreenWidth/2 - UIWidth/2 " Y" (A_ScreenHeight*.8) " ")
    InformativeUI.GetPos(&u, &u, &UIWidth, &UIHeight)
    InformativeUI.Show("X" A_ScreenWidth/2 - UIWidth/2 " Y" (A_ScreenHeight*.72) " ")
  

}

TheMostScuffedNumberCreation(Num) {
    NumMap := Map(
        "K", 1000,
        "M", 1000000,
        "B", 1000000000,
    )
    NumOrder := ["K", "M", "B"]

    BestText := Num

    for _, Abrev in NumOrder {
        if Num / (NumMap[Abrev]) > 1 {
            BestText := String(Floor((Num / (NumMap[Abrev]))*1000)/1000)
            if InStr(BestText, ".") {
                Split := StrSplit(BestText, ".")
                NewPastPeriod := SubStr(Split[2], 1, 3)
                BestText := Split[1] "." NewPastPeriod Abrev
            } else {
                BestText := BestText Abrev
            }
        }
    }

    return BestText
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

UpdateText() {
    global Text
    global WorldResets
    Text.Text := "Times Opened : " KeysUsed " | Estimated RAP Value : " TheMostScuffedNumberCreation(TEVal) "`nMacro Run Time : " TheMostScuffedTimeCreation((A_TickCount - MacroRunTime)) " | World Resets : " WorldResets
}

UIOBject.EnableButton.OnEvent("Click", MacroEnabled)

StupidWorldSwtich() {
    EscapeTime_8 := A_TickCount
    loop {
        SendEvent "{Click, " PositionMap["TPButton"][1] ", " PositionMap["TPButton"][2] ", 1}"

        if EvilSearch(PixelSearchTables["TpButton"], false)[1] {
            break
        }

        if A_TickCount - EscapeTime_8 >= 12000 {
            break
        }

        Sleep(200)
    }

    Sleep(400)
    
    EscapeTime_9 := A_TickCount
    loop {
        SendEvent "{Click, " PositionMap["TechWorldButton"][1] ", " PositionMap["TechWorldButton"][2] ", 1}"
        Sleep(500)
        SendEvent "{Click, " PositionMap["YesButton"][1] ", " PositionMap["YesButton"][2] ", 1}"
        
        if not EvilSearch(PixelSearchTables["TpButton"], false)[1] {
            break
        }

        if A_TickCount - EscapeTime_9 >= 10000 {
            break
        }

        Sleep(200)
    }

    EscapeTime_10 := A_TickCount

    loop {
        if EvilSearch(PixelSearchTables["TpButton"], false)[1] {
            break
        }

        if A_TickCount - EscapeTime_10 >= 60000 {
            break
        }

        Sleep(100)
    }

    Sleep(200)
    EscapeTime_11 := A_TickCount
    loop {
        SendEvent "{Click, " PositionMap["TPButton"][1] ", " PositionMap["TPButton"][2] ", 1}"

        if EvilSearch(PixelSearchTables["TpButton"], false)[1] {
            break
        }

        if A_TickCount - EscapeTime_11 >= 12000 {
            break
        }

        Sleep(200)
    }

    Sleep(400)
    
    EscapeTime_12 := A_TickCount
    loop {
        SendEvent "{Click, " PositionMap["SpawnWorldButton"][1] ", " PositionMap["SpawnWorldButton"][2] ", 1}"
        Sleep(500)
        SendEvent "{Click, " PositionMap["YesButton"][1] ", " PositionMap["YesButton"][2] ", 1}"
    
        if not EvilSearch(PixelSearchTables["TpButton"], false)[1] {
            break
        }

        if A_TickCount - EscapeTime_12 >= 10000 {
            break
        }

        Sleep(200)
    }


    EscapeTime_13 := A_TickCount

    loop {
        if EvilSearch(PixelSearchTables["TpButton"], false)[1] {
            break
        }

        if A_TickCount - EscapeTime_13 >= 60000 {
            break
        }

        Sleep(100)
    }
    Sleep(1200)
}

F3::{
    if not MacroSetup {
        return
    }

    global MacroSetup
    global MacroRunTime
    global TotalEstimatedValue
    global TEVal
    global KeysUsed
    KeyResetAmount := 0
    SetTimer(UpdateText, 1)

    MacroRunTime := A_TickCount
    loop {
        SkipOpening := false
        ;-- Route User to the door once they spawn in
        RouteUser(Routes["SpawnToDoor"])
        Sleep(100)

        if not EvilSearch(PixelSearchTables["TpButton"], false)[1] {
            SkipOpening := true
        }
    
        if not SkipOpening {
            ;-- Oncer user is at the door, hit E and if the wait for the UI
            EscapeTime_1 := A_TickCount
            Die := false
            loop {
                SendEvent "{E Down}{E Up}"
                Sleep(10)

                if EvilSearch(PixelSearchTables["MiniX"], false)[1] {
                    break
                }

                if A_TickCount - EscapeTime_1 >= 5000 {
                    StupidWorldSwtich()
                    WorldResets += 1
                    Die := true
                    break
                }
            }

            if Die {
                continue
            }

            ;-- Back up so the door doesnt absolutely kill the user in real life
            SendEvent "{S Down}"
            Sleep(700)
            SendEvent "{S Up}"


            ;-- Does Yes of evil evil???
            UserHasKeys := false

            if EvilSearch(PixelSearchTables["YesButton"], false)[1] {
                if not EvilSearch(PixelSearchTables["OkButtonRightSide"], false)[1] {
                    Sleep(20)
                    SendEvent "{Click, " PositionMap["YesButton"][1] ", " PositionMap["YesButton"][2] ", 1}"
                    KeysUsed += 1
                    KeyResetAmount += 1
                    UserHasKeys := true
                }
            }

            ;-- Ok so we MAY have keys and if we do we gotta go inside lowkey
            if UserHasKeys {
                SendEvent "{W Down}"
                EscapeTime_2 := A_TickCount

                loop {
                    if not EvilSearch(PixelSearchTables["TpButton"], false)[1] {
                        break
                    }

                    if A_TickCount - EscapeTime_2 >= 12000 {
                        break
                    }

                    Sleep(10)
                }

                SendEvent "{W Up}"
            } else {
                MsgBox("Yea its so over....")
            }
        }

        ;-- So heres the main loop, we start with the inside part so we can save on code
        loop {
            BlowUpAndDie := false
            Sleep(NumberValueMap["WalkWaitTime"])
            SendEvent "{W Down}"

            EscapeTime_3 := A_TickCount
            loop {
                if EvilSearch(PixelSearchTables["X"], false)[1] {
                    break
                }

                if A_TickCount - EscapeTime_3 >= 12000 {
                    break
                }
            }

            ;-- we are in the thingy so pick a item!!!!
            SendEvent "{W Up}"
            Sleep(20)
            Itemical()
            Sleep(100)
            
            loop 5 {
                SendEvent "{Click, " PositionMap["HomeButton"][1] ", " PositionMap["HomeButton"][2] ", 1}"
                Sleep(20)
            }


            EscapeTime_4 := A_TickCount
            loop {
                if EvilSearch(PixelSearchTables["TpButton"], false)[1] {
                    break
                }

                if A_TickCount - EscapeTime_4 >= 10000 {
                    break
                }

                Sleep(10)
            }

            if KeyResetAmount >= NumberValueMap["KeyResetAmount"] and ToggleValueMap["DoKeyReset"] {
                KeyResetAmount := 0
                break
            }

            SkipOpening := false
            ;-- ok so now we are going back in but the door is flip like a jip
            Sleep(200)
            SendEvent "{S Down}"
            Sleep(800)
            SendEvent "{S Up}"

            if not EvilSearch(PixelSearchTables["TpButton"], false)[1] {
                SkipOpening := true
            }

            if not SkipOpening {
                EscapeTime_5 := A_TickCount
                loop {
                    SendEvent "{E Down}{E Up}"
                    Sleep(10)
        
                    if EvilSearch(PixelSearchTables["MiniX"], false)[1] {
                        break
                    }
        
                    if A_TickCount - EscapeTime_5 >= 5000 {
                        break
                    }
                }
    
                SendEvent "{W Down}"
                Sleep(700)
                SendEvent "{W Up}"
                
                UserHasKeys := false
    
                if EvilSearch(PixelSearchTables["YesButton"], false)[1] {
                    if not EvilSearch(PixelSearchTables["OkButtonRightSide"], false)[1] {
                        Sleep(20)
                        SendEvent "{Click, " PositionMap["YesButton"][1] ", " PositionMap["YesButton"][2] ", 1}"
                        UserHasKeys := true
                        KeysUsed += 1
                        KeyResetAmount += 1
                    }
                }
    
                if UserHasKeys {
                    ;-- Stuff gets a little confusing ehre, but we are going to walk back 1000, if we enter the first time then a-okay
                    Sleep(NumberValueMap["DoorOpenWaitTime"])
                    EscapeTime_6 := A_TickCount
                    SendEvent "{S Down}"
                    loop {
                        if not EvilSearch(PixelSearchTables["TpButton"], false)[1] {
                            break
                        }
        
                        if A_TickCount - EscapeTime_6 >= 1000 {
                            break
                        }
    
                        Sleep(10)
                    }
                    SendEvent "{S Up}"
    
                    ;-- This function will like insta break if we are already in the thingy
                    EscapeTime_7 := A_TickCount
                    loop {
                        if not EvilSearch(PixelSearchTables["TpButton"], false)[1] {
                            break
                        }
        
                        if A_TickCount - EscapeTime_6 >= 20000 {
                            StupidWorldSwtich()
                            KeyResetAmount := 0
                            BlowUpAndDie := true
                            break
                        }
    
                        SendEvent "{W Down}"
                        Sleep(300)
                        SendEvent "{W Up}{S Down}"
                        Sleep(500)
                        SendEvent "{S Up}"
                        Sleep(10)
                    }

                    if BlowUpAndDie {
                        break
                    }
                }
            }
        }

        ;-- get me the fuck out of here
        Sleep(200)
        StupidWorldSwtich()
        global WorldResets += 1
    }
}

F6::Pause -1

EvilUI := ""
F5::{
    EvilText := "TreeHouseMacroV2 Debug`n--Item Picks--`n"

    for Item, ItemInfo in ItemPickMap {
        EvilText := EvilText Item " | Amount : " ItemInfo.Amount " | TotalValue : " (ItemInfo.Amount * ItemInfo.Rap) " | Rap Value : " ItemInfo.Rap "`n"
    }

    
    EvilText := EvilText "`nValueCharmDetections: " CharmDetectionAmount

    if not DirExist(A_MyDocuments "\PS99_Macros\Storage\TreeHouseMacroV2Debug") {
        DirCreate(A_MyDocuments "\PS99_Macros\Storage\TreeHouseMacroV2Debug")
    }

    if FileExist(A_MyDocuments "\PS99_Macros\Storage\TreeHouseMacroV2Debug\Output.txt") {
        FileDelete(A_MyDocuments "\PS99_Macros\Storage\TreeHouseMacroV2Debug\Output.txt")
    }

    FileAppend(EvilText, A_MyDocuments "\PS99_Macros\Storage\TreeHouseMacroV2Debug\Output.txt")
    Run A_MyDocuments "\PS99_Macros\Storage\TreeHouseMacroV2Debug\Output.txt"
}
F8::ExitApp
