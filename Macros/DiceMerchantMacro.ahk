; /[V1.0.02]\ (Used for auto-update)


#Include "%A_MyDocuments%\PS99_Macros\Modules\BasePositions.ahk"
#Include "%A_MyDocuments%\PS99_Macros\Modules\UsefulFunctions.ahk"
#Include "%A_MyDocuments%\PS99_Macros\Modules\EasyUI.ahk"

global MacroEnabled := false
global NumberValueMap := Map(
    "TpWaitTime", 7000,
    "ClickNumber", 4,
    "ClickDelay", 250,
    "LoopDownTime", 0,
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

DisconnectPositions := [
    [214, 324, 0x393B3D], [599, 327, 0x393B3D], [500, 427, 0xFFFFFF]
]

DcCheck() {
    Num := 0
    for _, Check in DisconnectPositions {
        if PixelSearch(&u,&u2, Check[1], Check[2], Check[1], Check[2], Check[3], 5) {
            Num++
        }
    }

    if Num >= 3 {
        return true
    }

    return false
}

global UI := CreateBaseUI(Map(
    "Main", {Title:"DiceMerchantMacro", Video:"https://www.roblox.com/users/2052029634/profile", Description:"", Version:"V1.0.0", DescY:250, MacroName:"DiceMerchantMacro", IncludeFonts:false, MultiInstancing:false},
    "Settings", [{Map:NumberValueMap, Type:"Number", Name:"Number Settings", SaveName:"NVs", IsAdvanced:false}, {Map:Routes, Type:"Text", Name:"Route Settings", SaveName:"NVs", IsAdvanced:true}],
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

F6::{
    OutputDebug(EvilSearch(PixelSearchTables["TpButton"], false)[1])
}

F3::{
    if not MacroEnabled {
        return
    }

    loop {
        for _, Inst_ID in InstancesArray {
            WinActivate("ahk_id " Inst_ID)
            WinMove(,,200,200,"ahk_id " Inst_ID)
            Sleep(100)

            if DcCheck() {
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

            for _, Pos in ClickPositions {
                loop NumberValueMap["ClickNumber"] {
                    Offset1 := Random(-20,20)
                    Offset2 := Random(-2,2)

                    MouseMove((Pos[1] + Offset1), (Pos[2] + Offset2))
                    SendEvent "{Click, " (Pos[1] + Offset1) ", " (Pos[2] + Offset2) ", 1}"
                    Sleep(NumberValueMap["ClickDelay"])
                }
            }

            Sleep(100)
        }

        Sleep(NumberValueMap["LoopDownTime"])
    }
}

F8::ExitApp
