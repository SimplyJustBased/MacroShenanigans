#Requires AutoHotkey v2.0 

CoordMode "Mouse", "Screen"

TypeToFunction := Map(
    "Toggle", Create_TNTP_UI,
    "Number", Create_TNTP_UI,
    "Text", Create_TNTP_UI,
    "Position", Create_TNTP_UI,
    "Selection", CreateSelectionUI,
    "Object", CreateObjectUI
)

global __HeldUIs := Map()

global CurrentPostionLabel := ""
global FredokaOneFont := A_MyDocuments "\PS99_Macros\Storage\Fonts\F_One.ttf"
global TimesNewRomanFont := A_MyDocuments "\PS99_Macros\Storage\Fonts\T_NR.ttf"
global CB := ""

;-- Expects Map("Main", {Title:X, Video:X, Description:X, Version:X, DescY:X, MacroName:X, IncludeFonts:True}, "Settings", [{Map:X,Name:X,Type:X,SaveName:X}], "SettingsFolder:X")
CreateBaseUI(MapIndex, IsForMulti := false, UIDForcing := -1) {
    UIDigit := __HeldUIs.Count + 1

    if UIDForcing != -1 {
        UIDigit := UIDForcing
    }
    __HeldUIs["UID" UIDigit] := []
    VariablisticMap := Map()

    AdvancedSettings := Gui()
    AdvancedSettings.AddTab3("", ["Main"])
    AdvancedSettings.Opt("+AlwaysOnTop")
    AdvancedSettings.AddText("Section w240 h25 x20 y35", "Advanced Settings").SetFont("s15 w700")
    
    __HeldUIs["UID" UIDigit].InsertAt(__HeldUIs["UID" UIDigit].Length + 1, AdvancedSettings)

    DBevent(*) {
        Run "https://discord.com/invite/JrwB6jVxkR"
    }
    YTBevent(*) {
        Run MapIndex["Main"].Video
    }

    UIObject := {}
    BaseGui := Gui(,MapIndex["Main"].MacroName " | V" MapIndex["Main"].Version)
    BaseGui.Opt("+AlwaysOnTop")

    Tab3Array := ["Main", "Settings", "Extras"]
    if MapIndex["Main"].MultiInstancing and not IsForMulti {
        Tab3Array.InsertAt(3, "Multi-Instancing")
    }

    UITabs := BaseGui.AddTab3("", Tab3Array)
    BaseGui.AddText("Section w240 h25 x20 y35", MapIndex["Main"].Title).SetFont("s15 w700")
    BaseGui.AddText("w240 h20 x20 yp+25", "Version: " MapIndex["Main"].Version).SetFont("s12 w500")
    BaseGui.AddLink("w240 h20 x20 yp+20", 'Macro Made By <a href="https://www.youtube.com/channel/UCKOkQGvHO71nqQjwTiJX5Ww">A Basement</a> / <a href="https://www.roblox.com/users/128699642/profile">Oliyopi</a>').SetFont("s10 w500")
    BaseGui.AddText("w200 h" MapIndex["Main"].DescY " x20 yp+45 Wrap", MapIndex["Main"].Description).SetFont("s10 w500")

    EMB := ""
    if not IsForMulti {
        EMB := BaseGui.AddButton("w100 h30 xs y350", "Enable Macro")
        YTB := BaseGui.AddButton("w70 h30 xp+100 y350", "YT Video")
        DB := BaseGui.AddButton("w75 h30 xp+70 y350", "Discord")

        EMB.SetFont("s10")
        YTB.SetFont("s10")
        DB.SetFont("s10")
    
        DB.OnEvent("Click", DBevent)
        YTB.OnEvent("Click", YTBevent)
    }
  
    UITabs.UseTab(2)
    SettingButtonSpacing := 0
    ADVSettingButtonSpacing := 35
    BaseGui.GetClientPos(&u, &u, &UIWidth, &UIHeight)

    BaseGui.Show()
    BaseGui.Hide()

    for _, SettingObject in MapIndex["Settings"] {
        switch SettingObject.IsAdvanced {
            case true:
                ADVSettingButtonSpacing += 35
        
                NewButton := AdvancedSettings.AddButton("w160 h30 xs y" ADVSettingButtonSpacing, SettingObject.Name)
        
                if SettingObject.type = "Selection" {
                    NewUIObject := TypeToFunction[SettingObject.type](SettingObject, AdvancedSettings, {Button:NewButton, UID:UIDigit},,VariablisticMap)
                    NewButton.SetFont("s10")
        
                    SettingObject.UIObject := NewUIObject
                } else {
                    NewUIObject := TypeToFunction[SettingObject.type](SettingObject, AdvancedSettings, VariablisticMap, IsForMulti)
                    NewButton.SetFont("s10")
                    NewButton.OnEvent("Click", NewUIObject.ShowFunction)
                    __HeldUIs["UID" UIDigit].InsertAt(__HeldUIs["UID" UIDigit].Length + 1, NewUIObject.UI)
                }

            default:
                SettingButtonSpacing += 35
        
                NewButton := BaseGui.AddButton("w160 h30 x" (UIWidth/2 + 75 - BaseGui.MarginX) " y" SettingButtonSpacing, SettingObject.Name)
        
                if SettingObject.type = "Selection" {
                    NewUIObject := TypeToFunction[SettingObject.type](SettingObject, BaseGui, {Button:NewButton, UID:UIDigit},,VariablisticMap)
                    NewButton.SetFont("s10")
        
                    SettingObject.UIObject := NewUIObject
                } else {
                    NewUIObject := TypeToFunction[SettingObject.type](SettingObject, BaseGui, VariablisticMap, IsForMulti)
                    NewButton.SetFont("s10")
                    NewButton.OnEvent("Click", NewUIObject.ShowFunction)
                    __HeldUIs["UID" UIDigit].InsertAt(__HeldUIs["UID" UIDigit].Length + 1, NewUIObject.UI)
                }
        }
    }

    if ADVSettingButtonSpacing > 35 {
        ASB := BaseGui.AddButton("w160 h30 x" (UIWidth/2 + 75 - BaseGui.MarginX) " y350", "Advanced Settings")
        ASB.SetFont("s10")
        ASB.OnEvent("Click", ShowAdvancedSettings)
    }

    SNum := 3
    if MapIndex["Main"].MultiInstancing and not IsForMulti {
        SNum := 4

        RobloxArray := []
        SearchArray := [WinGetList("ahk_exe RobloxPlayerBeta.exe"), WinGetList("Roblox", "Roblox")]
        for _, RobloxianSearchArray in SearchArray {
            for _, InstanceID in RobloxianSearchArray {
                RobloxArray.InsertAt(RobloxArray.Length + 1, InstanceID)
            }
        }

        UITabs.UseTab(3)
        BaseGui.AddText("w263 h25 y35 x12 Center", "Multi-Instancing").SetFont("s15 w700")
        BaseGui.AddText("w263 h25 yp+25 x12 Center", "Detected Accounts : " RobloxArray.Length).SetFont("s13 w700")
        BaseGui.AddText("w263 h15 yp+35 x12 Center", "Roblox Web Accounts : " SearchArray[1].Length).SetFont("s10 w700")
        BaseGui.AddText("w263 h15 yp+15 x12 Center", "Roblox Microsoft Accounts : " SearchArray[2].Length).SetFont("s10 w700")

        switch {
            case RobloxArray.Length > 1:
                BaseGui.AddText("w263 h25 yp+50 x12 Center", "You are able to Multi-Instance").SetFont("s11 w700 cgreen")
                EMI := BaseGui.AddButton("w160 h30 x" (UIWidth/2 + 75 - BaseGui.MarginX) " y350", "Start Multi-Instancing")
                EMI.SetFont("s10")

                EMI.OnEvent("Click", (*) => MultiInstancing(MapIndex, RobloxArray, BaseGui, UIDigit, UIObject))
            default:
                BaseGui.AddText("w263 h25 yp+50 x12 Center", "You are unable to Multi-Instance").SetFont("s11 w700 cred")
                BaseGui.AddText("w263 h25 yp+20 x12 Center", "(Requires 2 or more accounts)").SetFont("s9 w700 cred")
        }


    }

    UITabs.UseTab(SNum)
    if MapIndex["Main"].IncludeFonts {
        BaseGui.Add("Button","x15 y30 h30 w200","Set Font To Times New Roman").OnEvent("Click", SetToTimesNewRoman)
        BaseGui.Add("Button","x15 y60 h30 w200","Reset Font to Default").OnEvent("Click", SetToFredokaOne)
        
        SetToTimesNewRoman(*) {
            try {
                StringCoolness := WinGetProcessPath("ahk_exe RobloxPlayerBeta.exe")
                FontPath := SubStr(StringCoolness, 1, (StrLen(StringCoolness) - StrLen("RobloxPlayerBeta.exe"))) "content\fonts"

                FileCopy(TimesNewRomanFont, FontPath "\FredokaOne-Regular.ttf", true)
                MsgBox("Make sure to rejoin for the fonts to change",,"4096")
            } catch as e {
                MsgBox("Font Change Failed : (" e.Message ")",,"4096")
            }
        }
        
        SetToFredokaOne(*) {  
            try {
                StringCoolness := WinGetProcessPath("ahk_exe RobloxPlayerBeta.exe")
                FontPath := SubStr(StringCoolness, 1, (StrLen(StringCoolness) - StrLen("RobloxPlayerBeta.exe"))) "content\fonts"

                FileCopy(FredokaOneFont, FontPath "\FredokaOne-Regular.ttf", true)
                MsgBox("Make sure to rejoin for the fonts to change",,"4096")
            } catch as e {
                MsgBox("Font Change Failed : (" e.Message ")",,"4096")
            }
        }
    }

    SettingsMap := Map()
    SettingsArray := []
    Path := MapIndex["SettingsFolder"].Folder "\" MapIndex["SettingsFolder"].FolderName

    if not DirExist(Path) {
        DirCreate(Path)
        DirCreate(Path "\MacroSettings")
        if not FileExist(Path "\BaseSettings.ini") {
            IniWrite("nil", Path "\BaseSettings.ini", "LLS", "LastLoaded")
        }
    }

    LLS := IniRead(Path "\BaseSettings.ini", "LLS", "LastLoaded")
    SettingNum := 0

    loop files, Path "\MacroSettings\*.ini" {
        SettingsArray.InsertAt(SettingsArray.Length + 1, A_LoopFileName)
        SettingsMap[A_LoopFileName] := SettingsArray.Length

        if LLS != "nil" {
            if LLS = A_LoopFileName {
                SettingNum := SettingsArray.Length
            }
        }
    }
    
    if SettingNum > 0 {
        LoadSetting(Path "\MacroSettings\" SettingsArray[SettingNum])
    }

    BaseGui.SetFont("s11")
    BaseGui.Add("Button","x15 y270","Save Settings").OnEvent("Click", ButtonSaveSettings)
    BaseGui.Add("Button","x15 y305","Save Settings As New File").OnEvent("Click", SaveNewSettingsShow)
    BaseGui.Add("Text", "x15 y335", "↓ Load Setting File ↓")
    SettingDD := BaseGui.Add("DropDownList", "w200 x15 y355 vLoadSetting choose" SettingNum, SettingsArray)
    SettingDD.OnEvent("Change", SettingChanged)

    SaveSettingAsNewGUI := Gui()
    SaveSettingAsNewGUI.SetFont("s11 q5 w500", "Arial")
    SaveSettingAsNewGUI.Add("Text", "", "Enter File Name`n(Duplicate Named Files Will Overwrite)`n(No Need to add .ini)")
    SaveSettingAsNewGUI.Opt("+AlwaysOnTop")
    SSWText := SaveSettingAsNewGUI.Add("Edit", "vName w200", "NewSettingFile" SettingsArray.Length + 1)
    SaveSettingAsNewGUI.Add("Button", "", "Save").OnEvent("Click", ButtonSaveNewSettings)

    SaveNewSettingsShow(*) {
        SaveSettingAsNewGUI.Show()
    }

    ButtonSaveSettings(*) {
        if SettingNum = 0 {
            SaveSettings(true)
        } else {
            SaveSettings(false)
        }
    }

    ButtonSaveNewSettings(*) {
        SaveSettings(true)
    }

    SaveSettings(NewFile) {
        FileName := SaveSettingAsNewGUI.submit().Name
        FileToSaveTo := ""
        

        if NewFile {
            IniWrite(FileName ".ini", Path "\BaseSettings.ini", "LLS", "LastLoaded")
            FileToSaveTo := Path "\MacroSettings\" FileName ".ini"
        } else {
            FileToSaveTo := Path "\MacroSettings\" LLS
            OutputDebug(LLS)
        }

        for _, SettingObject in MapIndex["Settings"] {
            switch SettingObject.Type {
                case "Position":
                    for Key, Value in SettingObject.Map {
                        IniWrite(Value[1] "|" Value[2], FileToSaveTo, SettingObject.SaveName, Key)
                    }
                case "Selection":
                    FormattedText := ""

                    for Selection, Status in SettingObject.Map {
                        if FormattedText = "" {
                            FormattedText := Selection ":" Status
                        } else {
                            FormattedText := FormattedText "|" Selection ":" Status
                        }
                    }

                    IniWrite(FormattedText, FileToSaveTo, SettingObject.SaveName, "FormatString")
                case "Object":
                    for Name, Objective in SettingObject.Map {
                        for I, V in Objective.OwnProps() {
                            if SettingObject.ObjectIgnore.Has(I) {
                                continue
                            }

                            switch Type(V) {
                                case "Array":
                                    IniWrite(V[1] "|" V[2], FileToSaveTo, SettingObject.SaveName, Name I)
                                default:
                                    IniWrite(V, FileToSaveTo, SettingObject.SaveName, Name I)
                            }
                        }
                    }
                default:
                    for Key, Value in SettingObject.Map {
                        OutputDebug("`n" Key " | " Value)
                        IniWrite(Value, FileToSaveTo, SettingObject.SaveName, Key)
                    }
            }
        }

        if NewFile {
            SettingsMap := Map()
            SettingsArray := []

            LLS := FileName ".ini"
            SettingNum := 0
        
            loop files, Path "\MacroSettings\*.ini" {
                SettingsArray.InsertAt(SettingsArray.Length + 1, A_LoopFileName)
                SettingsMap[A_LoopFileName] := SettingsArray.Length
        
                if LLS != "nil" {
                    if LLS = A_LoopFileName {
                        SettingNum := SettingsArray.Length
                    }
                }
            }

            SettingDD.Delete()
            SettingDD.add(SettingsArray)
            SettingDD.choose(SettingNum)
            SSWText.Text := "NewSettingFile" SettingsArray.Length + 1
        }
    }

    SettingChanged(*) {
        falseifiedUISumbit := BaseGui.submit(false)
        SettingNum := SettingsMap[falseifiedUISumbit.LoadSetting]

        LoadFile := Path "\MacroSettings\" falseifiedUISumbit.LoadSetting
        IniWrite(falseifiedUISumbit.LoadSetting, Path "\BaseSettings.ini", "LLS", "LastLoaded")
        LLS := falseifiedUISumbit.LoadSetting
        LoadSetting(LoadFile)
    }

    LoadSetting(LoadFile) {
        for _, SettingObject in MapIndex["Settings"] {
            switch SettingObject.Type {
                case "Selection":
                    SettingObject.Map.Clear()
                    FormattedText := IniRead(LoadFile, SettingObject.SaveName, "FormatString")

                    for _, SelectionToStatus in StrSplit(FormattedText, "|") {
                        SecondSplit := StrSplit(SelectionToStatus, ":")

                        SettingObject.Map[SecondSplit[1]] := SecondSplit[2]
                    }

                    SettingObject.UIObject.RefreshFunc()
                default:
                    for Key, Value in SettingObject.Map {
                        try {
                            switch SettingObject.type {
                                case "Position":
                                    SettingObject.Map[Key] := StrSplit(IniRead(LoadFile, SettingObject.SaveName, Key), "|")
                                    VariablisticMap[SettingObject.SaveName][Key][1].Value := SettingObject.Map[Key][1]
                                    VariablisticMap[SettingObject.SaveName][Key][2].Value := SettingObject.Map[Key][2]
                                case "Object":
                                    for I, V in Value.OwnProps() {
                                        if SettingObject.ObjectIgnore.Has(I) {
                                            continue
                                        }
    
                                        switch Type(V) {
                                            case "Array":
                                                SettingObject.Map[Key].%I% := StrSplit(IniRead(LoadFile, SettingObject.SaveName, Key I), "|")
                                                VariablisticMap[SettingObject.SaveName][Key I][1].Value := SettingObject.Map[Key].%I%[1]
                                                VariablisticMap[SettingObject.SaveName][Key I][2].Value := SettingObject.Map[Key].%I%[2]
                                            default:
                                                SettingObject.Map[Key].%I% := IniRead(LoadFile, SettingObject.SaveName, Key I)
                                                VariablisticMap[SettingObject.SaveName][Key I].Value := SettingObject.Map[Key].%I%
                                        }
                                    }
                                default:
                                    SettingObject.Map[Key] := IniRead(LoadFile, SettingObject.SaveName, Key)
                                    VariablisticMap[SettingObject.SaveName][Key].Value := SettingObject.Map[Key]
                            }
                        }
                    }
            }
        }
    }

    ShowAdvancedSettings(*) {
        AdvancedSettings.Show()
    }

    UIObject.BaseUI := BaseGui
    UIObject.EnableButton := EMB
    UIObject.UID := UIDigit
    UIObject.Instances := {Multi:false}
    return UIObject
}

SwitchCheck(Value) {
    switch Type(Value) {
        case "Map":
            return CloneMap(Value)
        case "Array":
            CleanArray := []

            for _, V in Value {
                CleanArray.InsertAt(CleanArray.Length + 1, SwitchCheck(V))
            }

            return CleanArray
        case "Object":
            CleanObject := {}

            for Key, Value in Value.OwnProps() {
                CleanObject.%Key% := SwitchCheck(Value)
            }

            return CleanObject
        default:
            return Value
    }
}

CloneMap(MapTrue) {
    FinalMap := Map()

    for Key, Value in MapTrue {
        FinalMap[Key] := SwitchCheck(Value)
    }

    return FinalMap
}

CreatePosHelper(UI, Name, PosArray, Num, I := "", Objective := false) {
    PushButton := 0
    if Objective {
        PushButton += 48
        UI.Add("Text","Section xs y" Num, Name ":")
    } else {
        UI.Add("Text","Section xs y" (Num * 25 + (40)), Name ":")
    }

    
    UI.Add("Button", "w25 h25 x" (220 - PushButton) " ys", "S").OnEvent("Click", ButtonClicked)
    Ud1 := ""
    ud2 := ""

    if Objective {
        Ud1 := UI.Add("Edit","ys w60 x" (250-PushButton),)
        UI.AddUpDown("v" Name I "XPos Range1-40000", PosArray[1])
        ud2 := UI.Add("Edit","ys w60 x" (320-PushButton),)
        UI.AddUpDown("v" Name I "YPos Range1-40000", PosArray[2])
    } else {
        Ud1 := UI.Add("Edit","ys w60 x250",)
        UI.AddUpDown("v" Name "XPos Range1-40000", PosArray[1])
        ud2 := UI.Add("Edit","ys w60 x320",)
        UI.AddUpDown("v" Name "YPos Range1-40000", PosArray[2])
    }
  
    ButtonClicked(*) {
        global CurrentPostionLabel := [UD1, UD2]
    }

    return [UD1, UD2]
}


;-- Create Toggle/Number/Text/Positioning UI
Create_TNTP_UI(_MapOBJ, BaseUI, VariablisticMap, MI := false) {
    global CB
    _Map := _MapOBJ.Map
    SettingsUI := Gui()
    
    TotalSettings := 0
    NumericalSetting := 0
    CurrentTab := 0
    TabsArray := []

    loop (Ceil(_Map.Count / 15)) {
        TabsArray.InsertAt(TabsArray.Length + 1, "Settings[" A_Index "]")
    }

    TSTabs := SettingsUI.AddTab3("", TabsArray)
    if not _MapOBJ.Type = "Position" {
        SettingsUI.AddText("w200 h20 Section", _MapOBJ.Type " Settings").SetFont("s12 w700")
    } else {
        SettingsUI.SetFont("s15 q5 w800", "Constantia")
        SettingsUI.Add("Text", "Section", "Positioning")
        SettingsUI.Add("Text"," ys+5 x270 c0x000000","X")
        SettingsUI.Add("Text"," ys+5 x340 c0x000000","Y")
        SettingsUI.SetFont("s9 q5 w500", "Arial")
    }

    if not VariablisticMap.Has(_MapOBJ.SaveName) {
        VariablisticMap[_MapOBJ.SaveName] := Map()
    }


    for Setting, SettingValue in _Map {
        TotalSettings += 1
        NumericalSetting += 1
        CurrentTab := Ceil(TotalSettings / 15)
        TSTabs.UseTab(CurrentTab)

        if NumericalSetting >= 16 {
            NumericalSetting := 1

            ;- WE LOVE COPY AND PASTING CODE
            if not _MapOBJ.Type = "Position" {
                SettingsUI.AddText("w200 h20 Section", _MapOBJ.Type " Settings").SetFont("s12 w700")
            } else {
                SettingsUI.SetFont("s15 q5 w800", "Constantia")
                SettingsUI.Add("Text", "Section", "Positioning")
                SettingsUI.Add("Text"," ys+5 x270 c0x000000","X")
                SettingsUI.Add("Text"," ys+5 x340 c0x000000","Y")
                SettingsUI.SetFont("s9 q5 w500", "Arial")
            }
        }
        S_f := "s10"

        if MI {
            if _MapOBJ.MultiInstanceIgnore.Has(Setting) {
                S_f := "s10 c900000"
            }
        }

        switch _MapOBJ.Type {
            case "Toggle":
                SettingsUI.AddText("w200 h20 xs y" (NumericalSetting * 25 + (40)), Setting ":").SetFont(S_f)
                VariablisticMap[_MapOBJ.SaveName][Setting] := SettingsUI.AddCheckbox("w20 h20 v" Setting " yp xp+240 Checked" SettingValue)
                VariablisticMap[_MapOBJ.SaveName][Setting].SetFont("s9")
            case "Number":
                SettingsUI.AddText("w150 h20 xs y" (NumericalSetting * 25 + (40)), Setting ":").SetFont(S_f)
                VariablisticMap[_MapOBJ.SaveName][Setting] := SettingsUI.AddEdit("w120 h20 yp xp+190")
                SettingsUI.AddUpDown("v" Setting " range1-10000000" Setting, SettingValue)
            case "Text":
                SettingsUI.AddText("w150 h20 xs y" (NumericalSetting * 25 + (40)), Setting ":").SetFont(S_f)
                VariablisticMap[_MapOBJ.SaveName][Setting] := SettingsUI.AddEdit("w120 h20 yp xp+190 v" Setting, SettingValue)
            case "Position":
                VariablisticMap[_MapOBJ.SaveName][Setting] := CreatePosHelper(SettingsUI, Setting, SettingValue, NumericalSetting)
        }
    }

    SubmitFunction(*) {
        SettingsUI.Hide()
        Sumbit := SettingsUI.Submit()
        ReturnedValues := ObjToMap(SettingsUI.Submit())

        switch _MapOBJ.Type {
            case "Position":
                for Key, Value in _Map {
                    _Map[Key] := [ReturnedValues[Key "XPos"], ReturnedValues[Key "YPos"]]
                }
            default:
                for Key, Value in _Map {
                    _Map[Key] := Sumbit.%Key%
                }
        }
    }

    ShowFunction(*) {
        BaseUI.GetPos(&u, &u2, &u3, &u4)
        SettingsUI.GetPos(&a, &a2, &a3, &a4)
        SettingsUI.Show("X" (u - a3) " Y" u2 "")
        
        SettingsUI.GetPos(&a, &a2, &a3, &a4)
        SettingsUI.Show("X" (u - a3) " Y" u2 "")
    }

    TSTabs.UseTab(1)
    FinalizeButton := ""

    if TotalSettings >= 15 {
        FinalizeButton := SettingsUI.AddButton("w95 h30 xs y" (15 * 25 + (70)), "Set Values")
    } else {
        FinalizeButton := SettingsUI.AddButton("w95 h30 xs y" (TotalSettings * 25 + (70)), "Set Values")
    }
    
    FinalizeButton.OnEvent("Click", SubmitFunction)
    FinalizeButton.SetFont("s10")

    return {UI:SettingsUI,ShowFunction:ShowFunction}
}

;-- Used In SelectionUI_CreateUIS
SelectionUI_CreateUIS(MapToEvilize, TypeOfButton, Name) {
    AdditiveUI := Gui()
    DestructiveUI := Gui()

    DestroyArray := []
    for Key,_ in MapToEvilize {
        DestroyArray.InsertAt(DestroyArray.Length + 1, Key)
    }

    AdditiveUI.Opt("+AlwaysOnTop")
    DestructiveUI.Opt("+AlwaysOnTop")

    AdditiveUI.AddText("w300 h20 Section", "Add To Selection | " Name).SetFont("s12 w700")
    DestructiveUI.AddText("w300 h20 Section", "Remove From Selection | " Name).SetFont("s12 w700")

    AdditiveUI.AddEdit("w150 h20 vNewInstance", "New Selection Here").SetFont("s10")
    if TypeOfButton = "toggle" {
        AdditiveUI.AddDropDownList("w80 h20 vBaseValue Choose1 r2 yp xp+160", ["true", "false"]).SetFont("s9")
    }

    DestructiveUI.AddDropDownList("w150 h20 vDestroyValue Choose1 r6", DestroyArray).SetFont("s9")
    DestroyButton := DestructiveUI.AddButton("w120 h30 xs", "Destroy Selection")
    DestroyButton.SetFont("s10")
    AddButton := AdditiveUI.AddButton("w120 h30 xs", "Add Selection")
    AddButton.SetFont("s10")

    return {
        Additive:{
            AddButton:AddButton,
            PhysicalUI:AdditiveUI
        },
        Destructive:{
            DestroyButton:DestroyButton,
            PhsyicalUI:DestructiveUI
        }
    }
}

;-- Create Selection Type UI
;-- Mainly used for allowing users to add / remove values from Maps
CreateSelectionUI(_MapOBJ, BaseUI, PreviousObject := {}, ShowUI := true, VariablisticMap := Map()) {
    global __HeldUIs
    TrueObject := PreviousObject

    _Map := _MapOBJ.Map
    SelectionUI := Gui()
    SelectionUI.AddText("w200 h20 Section", _MapOBJ.Name " Selection").SetFont("s12 w700")
    SpacelessTable := Map()

    for Setting, SettingValue in _Map {
        NewerString := ""
        for _,Text in StrSplit(Setting, " ") {
            NewerString := NewerString Text
        }

        if SpacelessTable.Has(NewerString) {
            continue
        }

        SpacelessTable[NewerString] := Setting

        SelectionUI.AddText("w150 h20 xs", Setting ":").SetFont("s10")
        SelectionUI.AddCheckbox("w20 h20 v" NewerString " yp xp+210 Checked" SettingValue).SetFont("s9")
    }

    UIObjectTable := SelectionUI_CreateUIS(_Map, "toggle", _MapOBJ.Name)
    AdditiveUI := UIObjectTable.Additive.PhysicalUI
    AdditiveButton := UIObjectTable.Additive.AddButton
    DestructiveUI := UIObjectTable.Destructive.PhsyicalUI
    DestructiveButton := UIObjectTable.Destructive.DestroyButton

    AddSelectionButton := SelectionUI.AddButton("w95 h30 xs", "Add Selection")
    RemoveSelectionButton := SelectionUI.AddButton("w125 h30 xs+100 yp", "Remove Selection")
    FinalizeButton := SelectionUI.AddButton("w95 h30 xs", "Set Values")

    ShowAddSelection(*) {
        AdditiveUI.Show()
    }
    
    ShowRemoveSelection(*) {
        DestructiveUI.Show()
    }

    RefreshUI() {
        AdditiveUI.Destroy()
        DestructiveUI.Destroy()
        SelectionUI.Destroy()

        NewUIObject := CreateSelectionUI(_MapOBJ, BaseUI, TrueObject)
        NewUIObject.UI.Show()
        TrueObject.Button.OnEvent("Click", ShowFunction, false)
    }

    LoadRefreshUI(*) {
        AdditiveUI.Destroy()
        DestructiveUI.Destroy()
        SelectionUI.Destroy()

        NewUIObject := CreateSelectionUI(_MapOBJ, BaseUI, TrueObject, false)
        TrueObject.Button.OnEvent("Click", ShowFunction, false)
    }

    SelectionAdded(*) {
        Values := AdditiveUI.Submit()
        HitValue := true 
        if Values.BaseValue = "false" {
            HitValue := false
        }

        _Map[Values.NewInstance] := HitValue

        RefreshUI()
    }

    SelectionRemoved(*) {
        Values := DestructiveUI.Submit()
        _Map.Delete(Values.DestroyValue)

        RefreshUI()
    }

    SaveSettings(*) {
        AdditiveUI.Hide()
        DestructiveUI.Hide()
        ReturnedValues := ObjToMap(SelectionUI.Submit())

        for Key, Value in ReturnedValues {
            _Map[Key] := Value
        }
    }

    ShowFunction(*) {
        BaseUI.GetPos(&u, &u2, &u3, &u4)
        SelectionUI.GetPos(&a, &a2, &a3, &a4)
        SelectionUI.Show("X" (u - a3) " Y" u2 "")
        
        SelectionUI.GetPos(&a, &a2, &a3, &a4)
        SelectionUI.Show("X" (u - a3) " Y" u2 "")
    }

    AddSelectionButton.OnEvent("Click", ShowAddSelection)
    RemoveSelectionButton.OnEvent("Click", ShowRemoveSelection)
    AdditiveButton.OnEvent("Click", SelectionAdded)
    DestructiveButton.OnEvent("Click", SelectionRemoved)
    FinalizeButton.OnEvent("Click", SaveSettings)

    TrueObject.ShowFunction := ShowFunction
    TrueObject.UI := SelectionUI
    TrueObject.Button.OnEvent("Click", ShowFunction, true)
    TrueObject.RefreshFunc := LoadRefreshUI

    UIS := [AdditiveUI, DestructiveUI, SelectionUI]
    For _, UI in UIS {
        __HeldUIs["UID" PreviousObject.UID].InsertAt(__HeldUIs["UID" PreviousObject.UID].Length + 1, UI)
    }

    return TrueObject
}

;-- yeah this is only here bcause of how i setup thm :(
CreateObjectUI(_MapOBJ, BaseUI, VariablisticMap, MI := false) {
    _Map := _MapOBJ.Map
    ObjectSettingsUI := Gui()

    NextOffset := 60
    Pg1Offset := 0
    TabsArray := []
    NumericalSetting := 0

    TotalSettings := 0

    if not VariablisticMap.Has(_MapOBJ.SaveName) {
        VariablisticMap[_MapOBJ.SaveName] := Map()
    }

    loop (Ceil(_Map.Count / _MapOBJ.ObjectsPerPage)) {
        TabsArray.InsertAt(TabsArray.Length + 1, "Settings[" A_Index "]")
    }


    OTabs := ObjectSettingsUI.AddTab3("", TabsArray)

    for _, Name in _MapOBJ.ObjectOrder {
        TotalSettings += 1
        NumericalSetting += 1 
        CurrentTab := Ceil(TotalSettings / _MapOBJ.ObjectsPerPage)
        OTabs.UseTab(CurrentTab)

        Objective := _Map[Name]

        if NumericalSetting > _MapOBJ.ObjectsPerPage or NumericalSetting = 1 {
            if NumericalSetting != 1 and Pg1Offset = 0 {
                Pg1Offset := NextOffset
            }

            NumericalSetting := 1
            NextOffset := 60
            ObjectSettingsUI.AddText("w200 h30 Section", _MapOBJ.Name).SetFont("s14 w700")
        }

        
        ObjectSettingsUI.AddText("w200 h20 xs y" NextOffset, Name).SetFont("s11 w700 underline")
        NextOffset += 30

        ; Arrange values to be in order from Array (Position) -> String (Text) -> Integer (Number) -> Boolean (Toggle)
        ObjectiveOrderArray := []
        SimplifiedObject := {A:[],B:[],C:[],D:[]}

        for I, V in Objective.OwnProps() {
            switch Type(V) {
                case "String":
                    SimplifiedObject.B.InsertAt(SimplifiedObject.B.Length + 1, I)
                case "Integer":
                    if _MapOBJ.Booleans.Has(I) {
                        SimplifiedObject.D.InsertAt(SimplifiedObject.D.Length + 1, I)
                    } else {
                        SimplifiedObject.C.InsertAt(SimplifiedObject.C.Length + 1, I)
                    }
                case "Array":
                    SimplifiedObject.A.InsertAt(SimplifiedObject.A.Length + 1, I)
            }
        }

        for _, ArrayD in SimplifiedObject.OwnProps() {
            for _, IValue in ArrayD {
                ObjectiveOrderArray.InsertAt(ObjectiveOrderArray.Length + 1, IValue)
            }
        }

        for _, IValue in ObjectiveOrderArray {
            I := IValue
            V := Objective.%IValue%

            if _MapOBJ.ObjectIgnore.Has(I) {
                continue
            }

            switch Type(V) {
                case "String":
                    ObjectSettingsUI.AddText("w150 h20 xs y" NextOffset, I ":").SetFont("s10")
                    VariablisticMap[_MapOBJ.SaveName][Name I] := ObjectSettingsUI.AddEdit("w120 h20 yp xp+190 v" I Name, V)
                    
                case "Integer":
                    if _MapOBJ.Booleans.Has(I) {
                        ObjectSettingsUI.AddText("w150 h20 xs y" NextOffset, I ":").SetFont("s10")
                        VariablisticMap[_MapOBJ.SaveName][Name I] := ObjectSettingsUI.AddCheckbox("w20 h20 v" I Name " yp xp+190 Checked" V)
                        VariablisticMap[_MapOBJ.SaveName][Name I].SetFont("s9")
                    } else {
                        ObjectSettingsUI.AddText("w150 h20 xs y" NextOffset, I ":").SetFont("s10")
                        VariablisticMap[_MapOBJ.SaveName][Name I] := ObjectSettingsUI.AddEdit("w120 h20 yp xp+190")
                        ObjectSettingsUI.AddUpDown("v" I Name " range1-2147483647", V)
                    }
                case "Array":
                    ObjectSettingsUI.SetFont("s10")
                    VariablisticMap[_MapOBJ.SaveName][Name I] := CreatePosHelper(ObjectSettingsUI, I, V, NextOffset, Name, true)
            }

            NextOffset += 30
        }

        if Pg1Offset = 0 and _ = _MapOBJ.ObjectOrder.Length {
            Pg1Offset := NextOffset
        }
    }

    OTabs.UseTab(1)
    FinalizeButton := ObjectSettingsUI.AddButton("w95 h30 xs y" Pg1Offset, "Set Values")

    ShowFunction(*) {
        BaseUI.GetPos(&u, &u2, &u3, &u4)
        ObjectSettingsUI.GetPos(&a, &a2, &a3, &a4)
        ObjectSettingsUI.Show("X" (u-a3) " Y" u2)

        ObjectSettingsUI.GetPos(&a, &a2, &a3, &a4)
        ObjectSettingsUI.Show("X" (u-a3) " Y" u2)
    }

    SubmitFunction(*) {
        ObjectSettingsUI.Hide()
        ReturnedValues := ObjToMap(ObjectSettingsUI.Submit())

        for Name, Objective in _Map {
            for I, V in Objective.OwnProps() {
                if _MapOBJ.ObjectIgnore.Has(I) {
                    continue
                }

                switch Type(V) {
                    case "Array":
                        Objective.%I% := [ReturnedValues[I Name "XPos"], ReturnedValues[I Name "YPos"]]
                        OutputDebug("`n Set Pos Value")
                    default:
                        Objective.%I% := ReturnedValues[I Name]
                        OutputDebug("`nSet Value")
                }
            }
        }
    }

    FinalizeButton.OnEvent("Click", SubmitFunction)
    FinalizeButton.SetFont("s10")

    return {UI:ObjectSettingsUI,ShowFunction:ShowFunction}
}

;-- All Multi-Instancing Related

;-- Used for MultiInstance | Setup so the buttons work
ExtendedFunction(MultiInstanceSetupUI, NSetting, ID) {
    ActivateButton := MultiInstanceSetupUI.AddButton("y" ((NSetting * 55 + (45))) " w25 h25 x81", "🔍")
    OptionDropDownList := MultiInstanceSetupUI.AddDropDownList("y" ((NSetting * 55 + (47))) " w100 h25 xp+25 choose3 R3 vOption" ID, ["Macro", "Anti-Afk", "Nothing"])

    ActivateButton.OnEvent("Click", (*) => WinActivate("ahk_id " ID))
}

;-- Used for MultiInstance | Settings so the buttons work
AnotherExtendedFunction(MultiInstanceUI, NSetting, AccountID, AccountOBJ) {
    ActivateButton := MultiInstanceUI.AddButton("y" ((NSetting * 55 + (45))) " w100 h25 x93", "Open Settings")
    ActivateButton.SetFont("s9")

    ActivateButton.OnEvent("Click", (*) => AccountOBJ.Obj.BaseUI.Show())
}

CreateAfkUI(ObtainedMap, ID, TSettings, UIDigit) {
    BaseUI := Gui(,"Anti Afk UI | " ID)
    UTabs := BaseUI.AddTab3("", ["Main"])
    BaseUI.AddText("w263 h25 y35 x12 Center", "Anti-Afk Settings").SetFont("s15 w700")
    BaseUI.AddText("w263 h25 yp+30 x12 Center", "ClickDelay").SetFont("s11 w700")
    BaseUI.AddEdit("w120 h20 yp+25 x83")
    BaseUI.AddUpDown("vClickTime range1-10000000", ObtainedMap["Afk Settings"].ClickTime)

    BaseUI.AddText("w263 h25 yp+25 x12 Center", "ClickPosition").SetFont("s11 w700")
    BaseUI.Add("Button", "w25 h25 x70 yp+25", "S").OnEvent("Click", ButtonClicked)

    Ud1 := BaseUI.Add("Edit","yp+2 w60 xp+25",)
    BaseUI.AddUpDown("vClickXPos Range1-40000", ObtainedMap["Afk Settings"].ClickPosition[1])
    ud2 := BaseUI.Add("Edit","yp w60 xp+60",)
    BaseUI.AddUpDown("vClickYPos Range1-40000", ObtainedMap["Afk Settings"].ClickPosition[2])

    ButtonClicked(*) {
        global CurrentPostionLabel := [UD1, UD2]
    }

    BaseUI.GetClientPos(&u, &u, &UIWidth, &UIHeight)
    EMI := BaseUI.AddButton("w160 h30 x" (UIWidth/2 + 75 - BaseUI.MarginX) " y350", "Set Settings")
    EMI.SetFont("s10")
    EMI.OnEvent("Click", (*) => QuickSave())

    QuickSave() {
        sb := BaseUI.Submit()
        for _1, _2 in ObtainedMap["Afk Settings"].OwnProps() {
            if _1 = "ClickDelay" {
                ObtainedMap["Afk Settings"].%_1% := sb.ClickTime
            } else {
                ObtainedMap["Afk Settings"].%_1% := [sb.ClickXPos, sb.ClickYPos]
            }
        }
    }
    
    __HeldUIs["UID" UIDigit].InsertAt(__HeldUIs["UID" UIDigit].Length + 1, BaseUI)

    return {BaseUI:BaseUI}
}

MultiInstancing(MapIndex, AccountList, BaseUI, UID, UIObject) {
    MultiInstanceSetupUI := Gui(,"Multi-Instance | Setup")
    BaseUI.Hide()

    if __HeldUIs.Has("UID" UID) {
        for _, UI in __HeldUIs["UID" UID] {
            try {
                UI.Hide()
            }
        }
    }

    TabsArray := []
    loop(Ceil(AccountList.Length / 7)) {
        TabsArray.InsertAt(TabsArray.Length + 1, "AccountList:[" A_Index "]")
    }

    NSetting := 0
    TSettings := 0

    MISTabs := MultiInstanceSetupUI.AddTab3("", TabsArray)

    MultiInstanceSetupUI.AddText("w263 h25 y35 x12 Center", "Multi-Instancing").SetFont("s15 w700")
    MultiInstanceSetupUI.AddText("w263 h25 yp+25 x12 Center", "Setup").SetFont("s12 w700")

    for Num, AccountID in AccountList {
        NSetting += 1
        TSettings += 1
        ID := AccountID

        MISTabs.UseTab(Ceil(TSettings / 7))

        if NSetting >= 8 {
            NSetting := 1

            MultiInstanceSetupUI.AddText("w263 h25 y35 x12 Center", "Multi-Instancing").SetFont("s15 w700")
            MultiInstanceSetupUI.AddText("w263 h25 yp+25 x12 Center", "Setup").SetFont("s12 w700")
        }

        MultiInstanceSetupUI.AddText("w263 h25 y" (NSetting * 55 + (25)) " x12 Center", "RobloxAccount[" Num "]").SetFont("s10 w500")
        ExtendedFunction(MultiInstanceSetupUI, NSetting, ID)
    }

    MISTabs.UseTab(1)
    FinalizeButton := MultiInstanceSetupUI.AddButton("w140 h30 x74 y" ((Min(7, TSettings)) * 55 + (80)), "Finalize Setup")
    FinalizeButton.SetFont("s10")

    Step2() {
        SubmitValues := MultiInstanceSetupUI.Submit()

        InstMap := Map()

        for _, AccountID in AccountList {
            ToDo := SubmitValues.%"Option" AccountID%
            if ToDo != "Nothing" {
                InstMap[AccountID] := ToDo
            }
        }

        CreateMultiInstanceUI(MapIndex, InstMap, UIObject, UID, BaseUI)
    }

    FinalizeButton.OnEvent("Click", (*) => Step2())
    MultiInstanceSetupUI.OnEvent("Close", (*) => BaseUI.Show())

    MultiInstanceSetupUI.Show
}

CreateUIsForMulti(ToDo, MapIndex, TSettings, RecMap, ID, UIDigit) {
    switch ToDo {
        case "Macro":
            MIndexClone := CloneMap(MapIndex)
            MIndexClone["Main"].Title := MIndexClone["Main"].Title " | [" TSettings "]" 

            SelfUIObject := CreateBaseUI(MIndexClone, true, UIDigit)
            RecMap[ID] := {Obj:SelfUIObject, Clone:MIndexClone, Action:ToDo}
        default:
            ObtainedMap := Map("Afk Settings", {ClickTime:(10 * 60 * 1000), ClickPosition:[A_ScreenWidth/2, A_ScreenHeight/2]})

            UI := CreateAfkUI(ObtainedMap, ID, TSettings, UIDigit)
            RecMap[ID] := {Map:ObtainedMap, Obj:UI, Action:ToDo}
    }
}

CreateMultiInstanceUI(MapIndex, InstMap, UIObject, UIDigit, BaseUI) {
    MultiInstanceUI := Gui(, "Multi-Instance | Settings")

    TabsArray := []
    loop(Ceil(InstMap.Count / 7)) {
        TabsArray.InsertAt(TabsArray.Length + 1, "AccountSettings:[" A_Index "]")
    }

    NSetting := 0
    TSettings := 0

    MITabs := MultiInstanceUI.AddTab3("", TabsArray)

    MultiInstanceUI.AddText("w263 h25 y35 x12 Center", "Multi-Instancing").SetFont("s15 w700")
    MultiInstanceUI.AddText("w263 h25 yp+25 x12 Center", "Settings").SetFont("s12 w700")

    RecreationMap := Map()

    for AccountID, ToDo in InstMap {
        NSetting += 1
        TSettings += 1


        CreateUIsForMulti(ToDo, MapIndex, TSettings, RecreationMap, AccountID, UIDigit)

        MITabs.UseTab(Ceil(TSettings/7))

        if NSetting >= 8 {
            NSetting := 1

            MultiInstanceUI.AddText("w263 h25 y35 x12 Center", "Multi-Instancing").SetFont("s15 w700")
            MultiInstanceUI.AddText("w263 h25 yp+25 x12 Center", "Settings").SetFont("s12 w700")
        }

        MultiInstanceUI.AddText("w263 h25 y" (NSetting * 55 + (25)) " x12 Center", "RobloxAccount[" TSettings "]").SetFont("s10 w500")
        AnotherExtendedFunction(MultiInstanceUI, NSetting, AccountID, RecreationMap[AccountID])
    }

    MITabs.UseTab(1)
    EMB := MultiInstanceUI.AddButton("w140 h30 x74 y" ((Min(7, TSettings)) * 55 + (80)), "Enable Macro")
    EMB.SetFont("s10")

    UIObject.EMB := EMB
    MultiInstanceUI.OnEvent("Close", (*) => ReturnFunction())

    ReturnFunction() {
        for _, PossibleActiveUI in __HeldUIs["UID" UIDigit] {
            try {
                PossibleActiveUI.Hide()
            }
        }

        BaseUI.Show()
    }
    SmallestFunctionEver() {
        UIObject.Instances.RecMap := RecreationMap
        UIObject.Instances.Multi := true
    }
    EMB.OnEvent("Click", (*) => SmallestFunctionEver())


    MultiInstanceUI.Show()
}

;-- Not mine, lowkey forgot where i got this from but know that i didnt make this (Did edit it a little tho)
ObjToMap(Obj, Depth:=5, IndentLevel:="") {
	if Type(Obj) = "Object"
		Obj := Obj.OwnProps()
    if Type(Obj) = "String" {
      Obj := [Obj]
    }
	for k,v in Obj
	{
		List.= IndentLevel k
		if (IsObject(v) && Depth>1)
			List.="`n" ObjToMap(v, Depth-1, IndentLevel . "    ")
		Else
			List.=":" v
		List.="/\"
	}
	
  NewMap := Map()
  SplitArray := StrSplit(List, "/\")
  for __ArrayNum, SplitText in SplitArray {
    ValueSplit := StrSplit(SplitText, ":")
    
    if InStr(SplitText, ":") {
      NewMap[ValueSplit[1]] := ValueSplit[2]
      ; OutputDebug('`n' ValueSplit[1] " : " ValueSplit[2])
    }
  }

  return NewMap
}

^LButton::{
    try {
        OutputDebug(Type(CurrentPostionLabel))
        if Type(CurrentPostionLabel) = "Array" {
            if Type(CurrentPostionLabel[2]) = "String" {
                if CurrentPostionLabel[2] = "X" {
                    MouseGetPos(&u,&u2)
                    CurrentPostionLabel[1].Text := u
                    global CurrentPostionLabel := ""
                } else {
                    MouseGetPos(&u,&u2)
                    CurrentPostionLabel[1].Text := u2
                    global CurrentPostionLabel := ""
                }
            } else {
                MouseGetPos(&u,&u2)
                CurrentPostionLabel[1].Text := u
                CurrentPostionLabel[2].Text := u2
                global CurrentPostionLabel := ""
            } 
        }
    }
}
