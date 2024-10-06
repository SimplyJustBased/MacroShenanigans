; /[V1.0.1]\

CoordMode "Mouse", "Window"
CoordMode "Pixel", "Window"
SetMouseDelay -1

#Include "%A_MyDocuments%\MacroHubFiles\Modules\BasePositionsAV.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctions.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UsefulFunctionsAV.ahk"    
#Include "%A_MyDocuments%\MacroHubFiles\Modules\EasyUI.ahk"
#Include "%A_MyDocuments%\MacroHubFiles\Modules\UWBOCRLib.ahk"

global MacroVersion := "1.0.0"
global PlayerPositionFromSpawn := {W:0, A:0, S:0, D:0}
global MacroEnabled := false
global MacroEnabled := false

global UnitMap := Map(
    ; SprintWagon 1
    "Unit_1", {
        Slot:4, Pos:[336, 179], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:1, ActionCompleted:false, Delay:12000},
            {Type:"Upgrade", Wave:2, ActionCompleted:false, Delay:14000},
            {Type:"Upgrade", Wave:3, ActionCompleted:false, Delay:14000},
            {Type:"Upgrade", Wave:4, ActionCompleted:false, Delay:14000},
            {Type:"Sell", Wave:15, ActionCompleted:false, Delay:0},
        ]
    },

    ; SprintWagon 2
    "Unit_2", {
        Slot:4, Pos:[386, 180], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:1, ActionCompleted:false, Delay:12000},
            {Type:"Upgrade", Wave:2, ActionCompleted:false, Delay:14000},
            {Type:"Upgrade", Wave:4, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:5, ActionCompleted:false, Delay:0},
            {Type:"Sell", Wave:15, ActionCompleted:false, Delay:0},
        ]
    },

    ; SprintWagon 3
    "Unit_3", {
        Slot:4, Pos:[333, 230], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:1, ActionCompleted:false, Delay:12000},
            {Type:"Upgrade", Wave:3, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:4, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:5, ActionCompleted:false, Delay:5000},
            {Type:"Sell", Wave:15, ActionCompleted:false, Delay:0},
        ]
    },

    ; Vogita 1
    "Unit_4", {
        Slot:2, Pos:[413, 438], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:0},
        ]
    },

    ; Vogita 2
    "Unit_5", {
        Slot:2, Pos:[446, 434], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:2, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:0},
        ]
    },

    ; Vogita 3
    "Unit_6", {
        Slot:2, Pos:[380, 440], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:2, ActionCompleted:false, Delay:6000},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:0},
        ]
    },

    ; Vogita 4
    "Unit_7", {
        Slot:2, Pos:[339, 442], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:3, ActionCompleted:false, Delay:6000},
            {Type:"Upgrade", Wave:6, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:14, ActionCompleted:false, Delay:0},
        ]
    },

    ; Sasuke 1
    "Unit_8", {
        Slot:6, Pos:[696, 301], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:0, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:1, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:1, ActionCompleted:false, Delay:0},
        ]
    },

    ; Haruka
    "Unit_10", {
        Slot:3, Pos:[405, 388], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:5, ActionCompleted:false, Delay:0},
        ]
    },
    
    ; Cha-in 1
    "Unit_11", {
        Slot:1, Pos:[469, 376], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
        ]
    },

    ; Cha-in 2
    "Unit_12", {
        Slot:1, Pos:[437, 375], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
        ]
    },

    ; Cha-in 3
    "Unit_13", {
        Slot:1, Pos:[405, 347], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
            {Type:"Target", Wave:13, ActionCompleted:false, Delay:0},
        ]
    },

    ; Cha-in 4
    "Unit_14", {
        Slot:1, Pos:[373, 376], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
        ]
    },

    ; Cha-in 5
    "Unit_15", {
        Slot:1, Pos:[340, 379], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:7, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:8, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:9, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:11, ActionCompleted:false, Delay:0},
            {Type:"Upgrade", Wave:13, ActionCompleted:false, Delay:0},
        ]
    },

    ; Bean 1
    "Unit_16", {
        Slot:5, Pos:[469, 410], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
        ]
    },

    ; Bean 2
    "Unit_17", {
        Slot:5, Pos:[439, 341], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
        ]
    },

    ; Bean 3
    "Unit_18", {
        Slot:5, Pos:[370, 343], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
        ]
    },

    ; Bean 4
    "Unit_19", {
        Slot:5, Pos:[327, 409], MovementFromSpawn:[],
        UnitData:[
            {Type:"Placement", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Upgrade", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
            {Type:"Target", Wave:15, ActionCompleted:false, Delay:3000},
        ]
    },
)

global ToggleMapValues := Map(
    "NoMovementReset", true,
    "SecondaryOCR", false,
    "WaveDebug", true,
)

global NumberValueMap := Map()

ReturnedUIObject := CreateBaseUI(Map(         
    "Main", {Title:"AVParagonic", Video:"https://www.youtube.com/watch?v=xwUe6zqHPTA", Description:"Experimental Version`nF3 : Start`nF6:Pause`nF8 : Stop`n`nMake sure to set font to times new roman in extras tab!", Version:MacroVersion, DescY:"250", MacroName:"AVParagonic", IncludeFonts:true, MultiInstancing:false},
    "Settings", [
        {Map:UnitMap, Name:"Unit Settings", Type:"UnitUI", SaveName:"UnitSettings", IsAdvanced:false},
        {Map:ToggleMapValues, Name:"Toggle Settings", Type:"Toggle", SaveName:"ToggleSettings", IsAdvanced:false},
    ],
    "SettingsFolder", {Folder:A_MyDocuments "\MacroHubFiles\SavedSettings\", FolderName:"AV_PARAGONTEST_1"}
))


CardFuncTable := [
    {Pos1:[202, 210], Pos2:[100, 260]},
    {Pos1:[414, 225], Pos2:[310, 260]},
    {Pos1:[614, 227], Pos2:[520, 260]},
]

keywordMap := Map(
    "Strong", 1,
    "Regen", 2,
    "Thrice", 3,
    "Shield", 5,
    "Revital", 6,
    "Explod", 7,
    "Fast", 10
)

global ThriceAmount := 0

CardFunction() {
    global ThriceAmount

    CardMap := Map(
        "Slot1", 9,
        "Slot2", 9,
        "Slot3", 9
    )

    SetMouseDelay 1
    loop {
        UpperBreakTime := A_TickCount

        if ThriceAmount >= 9 {
            keywordMap["Thrice"] := 6
        }

        loop {
            SendEvent "{Click, 202, 200, 0}"
            Sleep(400)

            if PixelSearch(&u, &u, 121, 214, 121, 214, 0x040404, 2) {
                break
            }

            if A_TickCount - UpperBreakTime >= 4000 {
                break 2
            }
        }

        for I, V in CardFuncTable {
            UpperIndex := A_Index
            SendEvent "{Click, " V.Pos1[1] ", " V.Pos1[2] ", 0}"
            Sleep(400)
            CardOCR1 := OCR.FromWindow("ahk_exe RobloxPlayerBeta.exe",,2,{
                X:V.Pos2[1],
                Y:V.Pos2[2],
                W:200,
                H:30
            }, 0)
    
            OutputDebug(CardOCR1.Text)
            for I2, V2 in keywordMap {
                if InStr(CardOCR1.Text, I2) {
                    CardMap["Slot" UpperIndex] := V2
                    break
                }
            }
        }
    
        LowestCard := {I:"Slot1", V:999}
    
        for I, V in CardMap {
            OutputDebug("`n" V)
            if LowestCard.V > V {
                LowestCard.I := I
                LowestCard.V := V
            }
        }
    
        OutputDebug(LowestCard.I)
        switch LowestCard.I {
            case "Slot1":
                SendEvent "{Click, 202, 325, 0}"
                Sleep(15)
                SendEvent "{Click, 202, 325, 1}"
            case "Slot2":
                SendEvent "{Click, 414, 325, 0}"
                Sleep(15)
                SendEvent "{Click, 414, 325, 1}"
            case "Slot3":
                SendEvent "{Click, 614, 325, 0}"
                Sleep(15)
                SendEvent "{Click, 614, 325, 1}"
        }

        if LowestCard.V = 3 {
            ThriceAmount++
        }
    }

    SetMouseDelay -1
}


EnableFunction() {
    global MacroEnabled

    if not MacroEnabled {
        MacroEnabled := true

        ReturnedUIObject.BaseUI.Hide()
        for _, UI in __HeldUIs["UID" ReturnedUIObject.UID] {
            try {
                UI.submit()
            }
        }
    }
}


ReturnedUIObject.BaseUI.Show()
ReturnedUIObject.BaseUI.OnEvent("Close", (*) => ExitApp())
ReturnedUIObject.EnableButton.OnEvent("Click", (*) => EnableFunction())

F3::{
    global MacroEnabled
    if not MacroEnabled {
        return
    }

    ; loop {
    ;     WaveDetection()
    ;     Sleep(1)
    ; }

    CardFunction()
    Sleep(500)
    TpToSpawn()
    Sleep(950)
    CameraticView()
    Sleep(200)

    WaveSetDetection(5)

    if EvilSearch(PixelSearchTables["AutoStart"])[1] {
        PM_ClickPos("AutoStart")
        Sleep(200)
    }


    loop {
        Sleep(500)

        EnableWaveAutomation([125], true, 1, 16, 20000, ToggleMapValues["WaveDebug"], true, {1:13000,2:13000,3:13000,4:13000})

        loop {
            if DetectEndRoundUI() {
                break
            }

            SendEvent "{Click, 416, 156, 1}"
            Sleep(100)
        }
        Sleep(1000)

        loop 5 {
            PM_ClickPos("ContinueButton", 1)
            Sleep(300)

            if not DetectEndRoundUI() {
                break
            }
        }

        if DetectEndRoundUI {
            PM_ClickPos("RetryButton", 1)
            Sleep(1000)
        }

        CardFunction()
        Sleep(500)
        TpToSpawn()
        Sleep(950)
        WaveSetDetection(5)
        Sleep(400)
        PM_ClickPos("VoteStartButton", 1)
        ResetActions()
    }
}

F8::ExitApp()
F6::Pause -1

F5::{
    ; WaveSetDetection(5)
    global ChosenDetection := 2

    loop {
        ToolTip("`nReturned: " WaveDetection(true, 0, 1230))
        Sleep(100)
    }
}
