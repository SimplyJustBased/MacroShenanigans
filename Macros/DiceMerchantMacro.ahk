; /[V1.0.08]\ (Used for auto-update)

#Include "%A_MyDocuments%\PS99_Macros\Modules\BasePositions.ahk"
#Include "%A_MyDocuments%\PS99_Macros\Modules\UsefulFunctions.ahk"
#Include "%A_MyDocuments%\PS99_Macros\Modules\EasyUI.ahk"

global MacroEnabled := false
global NumberValueMap := Map(
    "TpWaitTime", 7000,
    "ClickNumber", 4,
    "ClickDelay", 250,
    "LoopDownTime", 0,
    "ColorBuyMaxTime", 5000,
)

global TogglesMap := Map(
    ; "BuyBasedOnColor", true,
    "UseAlternateAccounts", true
)

global Routes := Map(
    "SpawnToMinigame", "Tp:Colorful Forest|w_nV:TpWaitTime|Tp:Spawn|w_nV:TpWaitTime|r:[0%Q10&20%W250&190%D900]",
    "MinigameToMerchant", "r:[0%W1000&1030%A1500]"
)

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1

InstancesMap := Map()
InstancesArray := []
SortThrough := [WinGetList("ahk_exe RobloxPlayerBeta.exe"), WinGetList("Roblox", "Roblox")]

for _, InAry in SortThrough {
    for _, Id in InAry {
        if not InstancesMap.Has(Id) {
            InstancesMap[Id] := true
            InstancesArray.Push(Id)
        }
    }
}

ClickPositions := [
    [183, 266], [411, 263],
    [652, 271], [177, 430],
    [419, 425], [649, 430]
]

ColorPositions := [
    [131, 271], [360, 267],
    [593, 268], [127, 425],
    [359, 427], [591, 428]
]

DisconnectPositions := [
    [214, 324, 0x393B3D], [599, 327, 0x393B3D], [500, 427, 0xFFFFFF]
]

LbPositions := [
    [598, 73, 618, 88, 0xCB8C37],
    [653, 74, 674, 89, 0x4B8FB3], 
    [737, 75, 751, 88, 0xC04B5D]
]

ArrayCheck(ArrayToCheck := []) {
    NumWanted := ArrayToCheck.Length
    Num := 0

    for _, Check in ArrayToCheck {

        if Check.Length = 3 {
            if PixelSearch(&u,&u2, Check[1], Check[2], Check[1], Check[2], Check[3], 5) {
                Num++
            }
        } else if Check.Length = 5 {
            if PixelSearch(&u,&u2, Check[1], Check[2], Check[3], Check[4], Check[5], 25) {
                Num++
            }
        }
    }

    if Num >= NumWanted {
        return true
    }

    return false
}


global UI := CreateBaseUI(Map(
    "Main", {Title:"DiceMerchantMacro", Video:"https://www.roblox.com/users/2052029634/profile", Description:"Auto-Buys Merchant, Start macro with account(s) on merchant circle w/ it open`nF3 : Start`nF6 : Pause`nF8 : Stop/Close Macro", Version:"V1.0.1", DescY:250, MacroName:"DiceMerchantMacro", IncludeFonts:false, MultiInstancing:false},
    "Settings", [
        {Map:NumberValueMap, Type:"Number", Name:"Number Settings", SaveName:"NVs", IsAdvanced:false}, {Map:Routes, Type:"Text", Name:"Route Settings", SaveName:"NVs", IsAdvanced:true},
        {Map:TogglesMap, Type:"Toggle", Name:"Toggle Settings", SaveName:"TSs", IsAdvanced:false},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\PS99_Macros\SavedSettings\", FolderName:"DiceMerchantMacro"}
))

UI.BaseUI.Show()
UI.BaseUI.OnEvent("Close", (*) => ExitApp())

UI.EnableButton.OnEvent("Click", (*) => McEnabled())

McEnabled() {
    global UI
    UI.BaseUI.Hide()
    
    for _, UI in __HeldUIs["UID" UI.UID] {
        try {
            UI.Hide()
        }
    }

    global MacroEnabled := true
}

Mainical() {
    if ArrayCheck(DisconnectPositions) {
        SetPixelSearchLoop("TpButton", 120000,, DisconnectPositions[3],,100)
        Sleep(100)
        Send "{Tab Down}{Tab Up}"
        Sleep(100)
        RouteUser(Routes["SpawnToMinigame"])
        Sleep(4000)
        RouteUser(Routes["MinigameToMerchant"])
        Sleep(100)
        SendEvent "{Click, 300, 81, 1}"
        Sleep(100)
        SendEvent "{W Down}"
        SetPixelSearchLoop("X", 40000, 1,,,100)
        SendEvent "{W Up}"
        Sleep(200)
    }

    if ArrayCheck(LbPositions) {
        Send "{Tab Down}{Tab Up}"
        Sleep(200)
        PM_ClickPos("X")
        SendEvent "{D Down}"
        Sleep(500)
        SendEvent "{D Up}"
        Sleep(100)
        SendEvent "{A Down}"
        SetPixelSearchLoop("X", 40000, 1,,,100)
        SendEvent "{A Up}"
    }

    ; if TogglesMap["BuyBasedOnColor"] {
    ;     loop 6 {
    ;         Pos := ClickPositions[A_Index]
    ;         ColorCheck := ColorPositions[A_Index]

    ;         StartTime := A_TickCount
    ;         loop {                
    ;             Offset1 := Random(-20,20)
    ;             Offset2 := Random(-2,2)

    ;             MouseMove((Pos[1] + Offset1), (Pos[2] + Offset2))
    ;             SendEvent "{Click, " (Pos[1] + Offset1) ", " (Pos[2] + Offset2) ", 1}"
    ;             ExternalTime := A_TickCount

    ;             if PixelSearch(&u,&u,ColorCheck[1], ColorCheck[2], ColorCheck[1], ColorCheck[2], 0x535353, 1) {
    ;                 break
    ;             }

    ;             if A_TickCount - StartTime >= NumberValueMap["ColorBuyMaxTime"] {
    ;                 break
    ;             }

    ;             Sleep(NumberValueMap["ClickDelay"] - (A_TickCount - ExternalTime))
    ;         }
    ;     }

    ;     return
    ; }

    for _, Pos in ClickPositions {
        loop NumberValueMap["ClickNumber"] {
            Offset1 := Random(-20,20)
            Offset2 := Random(-2,2)

            MouseMove((Pos[1] + Offset1), (Pos[2] + Offset2))
            SendEvent "{Click, " (Pos[1] + Offset1) ", " (Pos[2] + Offset2) ", 1}"
            Sleep(NumberValueMap["ClickDelay"])
        }
    }
}

F3::{
    if not MacroEnabled {
        return
    }

    loop {
        switch TogglesMap["UseAlternateAccounts"] {
            case true:
                for _, Inst_ID in InstancesArray {
                    WinActivate("ahk_id " Inst_ID)
                    WinMove(,,816,638,"ahk_id " Inst_ID)
                    Sleep(100)

                    Mainical()

                    Sleep(100)
                }
            case false:
                Mainical()
            default:
                MsgBox("How")
        }

        Sleep(NumberValueMap["LoopDownTime"])

    }
}

F8::ExitApp
F6::Pause -1
