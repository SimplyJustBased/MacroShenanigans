#Requires AutoHotkey v2.0 

CoordMode "Mouse", "Window"

TypeToFunction := Map(
    "Toggle", Create_TNTP_UI,
    "Number", Create_TNTP_UI,
    "Text", Create_TNTP_UI,
    "Position", Create_TNTP_UI,
    "Selection", CreateSelectionUI,
    "Object", CreateObjectUI,
    "MM_Empower", CreateEmpoweredUI,
    "UnitUI", CreateUnitUI
)

global __HeldUIs := Map()

global CurrentPostionLabel := ""
global FredokaOneFont := A_MyDocuments "\MacroHubFiles\Storage\Fonts\F_One.ttf"
global TimesNewRomanFont := A_MyDocuments "\MacroHubFiles\Storage\Fonts\T_NR.ttf"
global CB := ""

;-- Expects Map("Main", {Title:X, Video:X, Description:X, Version:X, DescY:X, MacroName:X, IncludeFonts:True}, "Settings", [{Map:X,Name:X,Type:X,SaveName:X}], "SettingsFolder:X")
CreateBaseUI(MapIndex, IsForMulti := false, UIDForcing := -1) {
    UIDigit := __HeldUIs.Count + 1

    if UIDForcing != -1 {
        UIDigit := UIDForcing
    }

    if not __HeldUIs.Has("UID" UIDigit) {
        __HeldUIs["UID" UIDigit] := []
    }
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
        
                switch SettingObject.type {
                    case "Selection", "MM_Empower", "UnitUI":
                        NewUIObject := TypeToFunction[SettingObject.type](SettingObject, AdvancedSettings, {Button:NewButton, UID:UIDigit},,VariablisticMap)
                        NewButton.SetFont("s10")
            
                        SettingObject.UIObject := NewUIObject
                    default:
                        NewUIObject := TypeToFunction[SettingObject.type](SettingObject, AdvancedSettings, VariablisticMap, IsForMulti)
                        NewButton.SetFont("s10")
                        NewButton.OnEvent("Click", NewUIObject.ShowFunction)
                        __HeldUIs["UID" UIDigit].InsertAt(__HeldUIs["UID" UIDigit].Length + 1, NewUIObject.UI)
                }
            default:
                SettingButtonSpacing += 35
        
                NewButton := BaseGui.AddButton("w160 h30 x" (UIWidth/2 + 75 - BaseGui.MarginX) " y" SettingButtonSpacing, SettingObject.Name)
        
                switch SettingObject.type {
                    case "Selection", "MM_Empower", "UnitUI":
                        NewUIObject := TypeToFunction[SettingObject.type](SettingObject, BaseGui, {Button:NewButton, UID:UIDigit},,VariablisticMap)
                        NewButton.SetFont("s10")
            
                        SettingObject.UIObject := NewUIObject
                    default:
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
    BaseGui.Add("Text", "x15 y335", "? Load Setting File ?")
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
                case "UnitUI":
                    FormattedText := ""

                    for Name, Data in SettingObject.Map {
                        if FormattedText = "" {
                            if Data.UnitData.Length > 0 {
                                FirstFormatText := Name "," Data.Slot "," Data.Pos[1] "," Data.Pos[2] "|"
                            } else {
                                FirstFormatText := Name "," Data.Slot "," Data.Pos[1] "," Data.Pos[2] ""
                            }
                        } else {
                            if Data.UnitData.Length > 0 {
                                FirstFormatText := "!" Name "," Data.Slot "," Data.Pos[1] "," Data.Pos[2] "|"
                            } else {
                                FirstFormatText := "!" Name "," Data.Slot "," Data.Pos[1] "," Data.Pos[2]
                            }
                        }

                        for _, UnitDataObject in Data.UnitData {
                            if _ = Data.UnitData.Length {
                                if Data.MovementFromSpawn.Length > 0 {
                                    FirstFormatText := FirstFormatText UnitDataObject.Type "," UnitDataObject.Wave "," UnitDataObject.Delay "|"
                                } else {
                                    FirstFormatText := FirstFormatText UnitDataObject.Type "," UnitDataObject.Wave "," UnitDataObject.Delay
                                }
                            } else {
                                FirstFormatText := FirstFormatText UnitDataObject.Type "," UnitDataObject.Wave "," UnitDataObject.Delay "?"
                            }
                        }

                        for _, UnitMovementObject in Data.MovementFromSpawn {
                            if _ = Data.MovementFromSpawn.Length {
                                FirstFormatText := FirstFormatText UnitMovementObject.Key "," UnitMovementObject.TimeDown "," UnitMovementObject.Delay
                            } else {
                                FirstFormatText := FirstFormatText UnitMovementObject.Key "," UnitMovementObject.TimeDown "," UnitMovementObject.Delay "?"
                            }
                        }

                        FormattedText := FormattedText FirstFormatText
                    }

                    IniWrite(FormattedText, FileToSaveTo, SettingObject.SaveName, "FormatString")
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
                case "MM_Empower":
                    FormattedText := ""

                    for EnchantName, EnchantArray in SettingObject.Map {
                        for _, EnchantObject in EnchantArray {
                            
                            if FormattedText = "" {
                                FormattedText := EnchantName "|TierText:" EnchantObject.TierText  "|TierValue:" EnchantObject.TierValue "|Amount:" EnchantObject.Amount  
                            } else {
                                FormattedText := FormattedText "!" EnchantName "|TierText:" EnchantObject.TierText  "|TierValue:" EnchantObject.TierValue "|Amount:" EnchantObject.Amount  
                            }
                        }
                    }

                    IniWrite(FormattedText, FileToSaveTo, SettingObject.SaveName, "FormatString")
                case "Object":
                    for Name, Objective in SettingObject.Map {
                        for I, V in Objective.OwnProps() {
                            if SettingObject.HasOwnProp("ObjectIgnore") and SettingObject.ObjectIgnore.Has(I) {
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
                case "UnitUI":
                    FormattedText := IniRead(LoadFile, SettingObject.SaveName, "FormatString")
                    SettingObject.Map.Clear()

                    Splitical_1 := StrSplit(FormattedText, "!")

                    for _, TextFormData in Splitical_1 {
                        Splitical_2 := StrSplit(TextFormData, "|")

                        BaseData := StrSplit(Splitical_2[1], ",")
                        MovementArray := []
                        UnitDataArray := []

                        if Splitical_2.Length > 1 {
                            MassUnitData := StrSplit(Splitical_2[2], "?")
                            for _, UnitObj in MassUnitData {
                                Splitical3 := StrSplit(UnitObj, ",")
                                UnitDataArray.Push({Type:Splitical3[1], Wave:Splitical3[2], ActionCompleted:false, Delay:Splitical3[3]})
                            }
                        }

                        if Splitical_2.Length > 2 {
                            MassMovementData := StrSplit(Splitical_2[3], "?")
                            for _, MovementObj in MassMovementData {
                                Splitical3 := StrSplit(MovementObj, ",")
                                MovementArray.Push({Key:Splitical3[1], TimeDown:Splitical3[2], Delay:Splitical3[3]})
                            }
                        }

                        SettingObject.Map[BaseData[1]] := {Slot:BaseData[2], Pos:[BaseData[3], BaseData[4]], UnitData:UnitDataArray, MovementFromSpawn:MovementArray}
                    }

                    SettingObject.UIObject.RefreshFunc()
                case "Selection":
                    try {
                        FormattedText := IniRead(LoadFile, SettingObject.SaveName, "FormatString")
                        SettingObject.Map.Clear()


                        for _, SelectionToStatus in StrSplit(FormattedText, "|") {
                            SecondSplit := StrSplit(SelectionToStatus, ":")

                            SettingObject.Map[SecondSplit[1]] := SecondSplit[2]
                        }

                        SettingObject.UIObject.RefreshFunc()
                    }
                case "MM_Empower":
                    try {
                        FormattedText := IniRead(LoadFile, SettingObject.SaveName, "FormatString")
                        SettingObject.Map.Clear()

                        for _, EnchantToInformation in StrSplit(FormattedText, "!") {
                            FurtherSplit := StrSplit(EnchantToInformation, "|")
                            EnchantName := FurtherSplit[1]
                            EnchantTier := StrSplit(FurtherSplit[2], ":")[2]
                            EnchantTierValue := StrSplit(FurtherSplit[3], ":")[2]
                            EnchantAmount := StrSplit(FurtherSplit[4], ":")[2]

                            if not SettingObject.Map.Has(EnchantName) {
                                SettingObject.Map[EnchantName] := []
                            }

                            SettingObject.Map[EnchantName].InsertAt(SettingObject.Map[EnchantName].Length + 1, {
                                TierText:EnchantTier, TierValue:EnchantTierValue, Amount:EnchantAmount
                            })
                        }

                        SettingObject.UIObject.RefreshFunc()
                    }
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
                                        if SettingObject.HasOwnProp("ObjectIgnore") and SettingObject.ObjectIgnore.Has(I) {
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

    if IsForMulti {
        __HeldUIs["UID" UIDigit].InsertAt(__HeldUIs["UID" UIDigit].Length + 1, BaseGui)    
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

CreateHalfPosHelper(UI, Name, PosNum, Num, I := "", Objective := false) {
    PushButton := 0
    if Objective {
        PushButton += 48
        UI.Add("Text","Section xs y" Num, Name ":")
    } else {
        UI.Add("Text","Section xs y" (Num * 25 + (40)), Name ":")
    }

    UI.Add("Button", "w25 h25 x" (290 - PushButton) " ys", "S").OnEvent("Click", ButtonClicked)
    ud := ""

    if Objective {
        ud := UI.Add("Edit","ys w60 x" (320-PushButton),)
        UI.AddUpDown("v" Name I "Pos Range1-40000", PosNum)
    } else {
        ud := UI.Add("Edit","ys w60 x320",)
        UI.AddUpDown("v" Name "Pos Range1-40000", PosNum)
    }
  
    Character := "X"
    if InStr(Name, "_Y") {
        Character := "Y"
    }


    ButtonClicked(*) {
        global CurrentPostionLabel := [ud, Character]
    }

    return ud
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
            if _MapOBJ.HasOwnProp("MultiInstanceIgnore") and _MapOBJ.MultiInstanceIgnore.Has(Setting) {
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
SelectionUI_CreateUIS(MapToEvilize, Name, TypeOfButton := "toggle") {
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
    switch TypeOfButton {
        case "toggle":
            AdditiveUI.AddDropDownList("w80 h20 vBaseValue Choose1 r2 yp xp+160", ["true", "false"]).SetFont("s9")
        case "number":
            OutputDebug("A")
            AdditiveUI.AddEdit("w80 h20 yp xp+160")
            AdditiveUI.AddUpDown("vBaseValue range0-2147483647", 0)
        default:
            OutputDebug(TypeOfButton)
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

    TypeOfSelection := "toggle"
    if _MapOBJ.HasOwnProp("SelectionType") and _MapOBJ.SelectionType != TypeOfSelection {
        TypeOfSelection := _MapOBJ.SelectionType
    }

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
        switch TypeOfSelection {
            case "number":
                SelectionUI.AddEdit("w80 h20 yp xp+150").SetFont("s9")
                SelectionUI.AddUpDown("range0-2147483647 v" NewerString, SettingValue)
            default:
                SelectionUI.AddCheckbox("w20 h20 v" NewerString " yp xp+210 Checked" SettingValue).SetFont("s9")
        }
    }


    UIObjectTable := SelectionUI_CreateUIS(_Map, _MapOBJ.Name, TypeOfSelection)
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
        switch TypeOfSelection {
            case "number":
                _Map[Values.NewInstance] :=  Values.BaseValue
            default:
                HitValue := true 

                if Values.BaseValue = "false" {
                    HitValue := false
                }

                _Map[Values.NewInstance] := HitValue
        }
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
            _Map[SpacelessTable[Key]] := Value
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
        SimplifiedObject := {A:[],B:[],C:[],D:[],E:[]}

        for I, V in Objective.OwnProps() {
            switch Type(V) {
                case "String":
                    SimplifiedObject.C.InsertAt(SimplifiedObject.C.Length + 1, I)
                case "Integer":
                    if _MapOBJ.HasOwnProp("Booleans") and _MapOBJ.Booleans.Has(I) {
                        SimplifiedObject.E.InsertAt(SimplifiedObject.E.Length + 1, I)
                    } else if _MapOBJ.HasOwnProp("HalfPositions") and _MapOBJ.HalfPositions.Has(I) {
                        SimplifiedObject.B.InsertAt(SimplifiedObject.B.Length + 1, I)
                    } else {
                        SimplifiedObject.D.InsertAt(SimplifiedObject.D.Length + 1, I)
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

            if _MapOBJ.HasOwnProp("ObjectIgnore") and _MapOBJ.ObjectIgnore.Has(I) {
                continue
            }

            switch Type(V) {
                case "String":
                    ObjectSettingsUI.AddText("w150 h20 xs y" NextOffset, I ":").SetFont("s10")
                    VariablisticMap[_MapOBJ.SaveName][Name I] := ObjectSettingsUI.AddEdit("w120 h20 yp xp+190 v" I Name, V)
                    
                case "Integer":
                    if _MapOBJ.HasOwnProp("Booleans") and _MapOBJ.Booleans.Has(I) {
                        ObjectSettingsUI.AddText("w150 h20 xs y" NextOffset, I ":").SetFont("s10")
                        VariablisticMap[_MapOBJ.SaveName][Name I] := ObjectSettingsUI.AddCheckbox("w20 h20 v" I Name " yp xp+190 Checked" V)
                        VariablisticMap[_MapOBJ.SaveName][Name I].SetFont("s9")
                    } else if _MapOBJ.HasOwnProp("HalfPositions") and _MapOBJ.HalfPositions.Has(I) {
                        ObjectSettingsUI.SetFont("s10")
                        VariablisticMap[_MapOBJ.SaveName][Name I] := CreateHalfPosHelper(ObjectSettingsUI, I, V, NextOffset, Name, true)
                    } else {
                        ObjectSettingsUI.AddText("w150 h20 xs y" NextOffset, I ":").SetFont("s10")
                        VariablisticMap[_MapOBJ.SaveName][Name I] := ObjectSettingsUI.AddEdit("w120 h20 yp xp+190")
                        ObjectSettingsUI.AddUpDown("v" I Name " range0-2147483647", V)
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
                if _MapOBJ.HasOwnProp("ObjectIgnore") and _MapOBJ.ObjectIgnore.Has(I) {
                    continue
                }

                switch Type(V) {
                    case "Array":
                        Objective.%I% := [ReturnedValues[I Name "XPos"], ReturnedValues[I Name "YPos"]]
                        OutputDebug("`n Set Pos Value")
                    default:
                        if _MapOBJ.HasOwnProp("HalfPositions") and _MapOBJ.HalfPositions.Has(I) {
                            Objective.%I% := ReturnedValues[I Name "Pos"]
                            OutputDebug("`nSet HalfPos Value")
                        } else {
                            Objective.%I% := ReturnedValues[I Name]
                            OutputDebug("`nSet Value")
                        }
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
    ActivateButton := MultiInstanceSetupUI.AddButton("y" ((NSetting * 55 + (45))) " w25 h25 x81", "??")
    OptionDropDownList := MultiInstanceSetupUI.AddDropDownList("y" ((NSetting * 55 + (47))) " w100 h25 xp+25 choose3 R3 vOption" ID, ["Macro", "Anti-Afk", "Nothing"])

    ActivateButton.OnEvent("Click", (*) => WinActivate("ahk_id " ID))
}

;-- Used for MultiInstance | Settings so the buttons work
AnotherExtendedFunction(MultiInstanceUI, NSetting, AccountID, AccountOBJ) {
    SettingButton := MultiInstanceUI.AddButton("y" ((NSetting * 55 + (45))) " w100 h25 x83", "Open Settings")
    ActivateButton := MultiInstanceUI.AddButton("y" ((NSetting * 55 + (45))) " w25 h25 xp+100", "??")

    SettingButton.SetFont("s9")
    ActivateButton.OnEvent("Click", (*) => WinActivate("ahk_id " AccountID))
    SettingButton.OnEvent("Click", (*) => AccountOBJ.Obj.BaseUI.Show())
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
            if _1 = "ClickTime" {
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

        CreateMultiInstanceUI(MapIndex, InstMap, UIObject, UID, BaseUI, AccountList)
    }

    FinalizeButton.OnEvent("Click", (*) => Step2())
    MultiInstanceSetupUI.OnEvent("Close", (*) => BaseUI.Show())

    MultiInstanceSetupUI.Show
}

CreateUIsForMulti(ToDo, MapIndex, TSettings, RecMap, ID, UIDigit) {
    OutputDebug("`n" UIDigit)
    switch ToDo {
        case "Macro":
            MIndexClone := CloneMap(MapIndex)
            MIndexClone["Main"].Title := MIndexClone["Main"].Title " | [" TSettings "]" 

            SelfUIObject := CreateBaseUI(MIndexClone, true, UIDigit)
            RecMap[ID] := {Obj:SelfUIObject, Clone:MIndexClone, Action:ToDo}
        default:
            ObtainedMap := Map("Afk Settings", {ClickTime:(10 * 60 * 1000), ClickPosition:[410,320]})

            UI := CreateAfkUI(ObtainedMap, ID, TSettings, UIDigit)
            RecMap[ID] := {Map:ObtainedMap, Obj:UI, Action:ToDo}
    }
}

CreateMultiInstanceUI(MapIndex, InstMap, UIObject, UIDigit, BaseUI, AccountOrder) {
    MultiInstanceUI := Gui(, "Multi-Instance | Settings")
    MultiInstanceUI.Opt("+AlwaysOnTop")

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

    for _, AccountID in AccountOrder {
        if not InstMap.has(AccountID) {
            continue
        }

        ToDo := InstMap[AccountID]

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

    UIObject.EnableButton := EMB
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
    __HeldUIs["UID" UIDigit].InsertAt(__HeldUIs["UID" UIDigit].Length + 1, MultiInstanceUI)

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

;-- SPECIFIC UI TYPES
;-- Basically very very specific UI needs that can be aranged from previous functions but really have no need to be their own entire thing

;-- Yeah, we're winning.
EmpowerSelectionUI_CreateUIS(MapToEvilize, Name) {
    TierArray := ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]
    AdditiveUI := Gui()
    DestructiveUI := Gui()

    DestroyArray := []
    for Key, KeyArray in MapToEvilize {
        for _, KeyObject in KeyArray {
            DestroyArray.InsertAt(DestroyArray.Length + 1, Key "_" KeyObject.TierText)
        }
    }

    AdditiveUI.Opt("+AlwaysOnTop")
    DestructiveUI.Opt("+AlwaysOnTop")

    AdditiveUI.AddText("w380 h20 Section", "Add To Selection | " Name).SetFont("s12 w700")
    DestructiveUI.AddText("w300 h20 Section", "Remove From Selection | " Name).SetFont("s12 w700")

    AdditiveUI.AddEdit("w150 h20 vNewInstance", "New Selection Here").SetFont("s10")
    AdditiveUI.AddText("w47 h20 xp+160", "Amount:").SetFont("s10")

    AdditiveUI.AddEdit("w50 h20 yp xp+50")
    AdditiveUI.AddUpDown("vAmount Range1-10", 1)
    AdditiveUI.AddText("w27 h20 xp+60", "Tier:").SetFont("s10")

    AdditiveUI.AddDropDownList("w50 h20 r10 Choose yp xp+30 Choose1 vTier", TierArray)


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

;-- A Mix of selection UI & Object UI
;-- BaseCode Taken from SelectionUI
CreateEmpoweredUI(_MapOBJ, BaseUI, PreviousObject := {}, ShowUI := true, VariablisticMap := Map()) {
    global __HeldUIs
    TrueObject := PreviousObject
    TierArray := ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]

    _Map := _MapOBJ.Map
    ; Map Here is expected to be:
    ; Map(
    ;     "EnchantName", [{TierText:"IX", TierValue:9, Amount:1}]
    ; )


    SelectionUI := Gui()
    SelectionUI.AddText("w200 h20 Section", _MapOBJ.Name " Selection").SetFont("s12 w700")
    SpacelessTable := Map()

    for Setting, SettingArray in _Map {
        for _, SettingObject in SettingArray {
            NewerString := ""
            for _,Text in StrSplit(Setting, " ") {
                NewerString := NewerString Text
            }
            NewerString := NewerString SettingObject.TierText
    
            if SpacelessTable.Has(NewerString) {
                continue
            }
    
            SpacelessTable[NewerString] := Setting
    
            SelectionUI.AddText("w120 h20 xs", Setting " " SettingObject.TierText ":").SetFont("s10")
            SelectionUI.AddText("w47 h20 xp+125", "Amount:").SetFont("s10")

            SelectionUI.AddEdit("w50 h20 yp xp+50")
            SelectionUI.AddUpDown("v" NewerString " Range1-10", SettingObject.Amount)
        }
    }

    UIObjectTable := EmpowerSelectionUI_CreateUIS(_Map, _MapOBJ.Name)
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

        NewUIObject := CreateEmpoweredUI(_MapOBJ, BaseUI, TrueObject)
        NewUIObject.UI.Show()
        TrueObject.Button.OnEvent("Click", ShowFunction, false)
    }

    LoadRefreshUI(*) {
        AdditiveUI.Destroy()
        DestructiveUI.Destroy()
        SelectionUI.Destroy()

        NewUIObject := CreateEmpoweredUI(_MapOBJ, BaseUI, TrueObject, false)
        TrueObject.Button.OnEvent("Click", ShowFunction, false)
    }

    SelectionAdded(*) {
        Values := AdditiveUI.Submit(false)
        HitValue := true 

        EnchantName := Values.NewInstance
        EnchantTier := Values.Tier
        EnchantAmount := Values.Amount

        if not _Map.Has(EnchantName) {
            _Map[EnchantName] := []
        } else {
            for _, EchObj in _Map[EnchantName] {
                if EchObj.TierText = EnchantTier {
                    MsgBox("There is already a Enchant:Tier Combo for [" EnchantName ":" EnchantTier "]", "Error", "0x1032 0x1")
                    return
                }
            }
        }
        TempNumber := 1

        for _, Numeral in TierArray {
            if Numeral = EnchantTier {
                TempNumber := _
                break
            }
        }

        AdditiveUI.Submit(true)
        _Map[EnchantName].InsertAt(_Map[EnchantName].Length + 1, {
            TierText:EnchantTier, TierValue:TempNumber, Amount:EnchantAmount
        })

        RefreshUI()
    }

    SelectionRemoved(*) {
        Values := DestructiveUI.Submit()
        
        SplitText := StrSplit(Values.DestroyValue, "_")
        EnchantName := SplitText[1]
        EnchantTier := SplitText[2]

        for _, Obj in _Map[EnchantName] {
            if Obj.TierText = EnchantTier {
                _Map[EnchantName].RemoveAt(_)

                if _Map[EnchantName].Length = 0 {
                    _Map.Delete(EnchantName)
                }
                
                break
            }
        }

        RefreshUI()
    }

    SaveSettings(*) {
        AdditiveUI.Hide()
        DestructiveUI.Hide()
        ReturnedValues := ObjToMap(SelectionUI.Submit())

        for EnchantName, EnchantArray in _Map {
            Stringical := ""

            for Key, Value in SpacelessTable {
                if Value = EnchantName {
                    Stringical := Key
                }
            }

            for _, EnchantObject in EnchantArray {
                EnchantObject.Amount := ReturnedValues[Stringical]
            }
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

;-- Used for AV, UnitPlacement and shit idk tbf
global OpenUIID := ""
CharacteristicUI(RowNumber, UhhMap, Lv, TrueMap, OriginalUI, EvilLV, TrueObject) {
    global OpenUIID
    global CurrentPostionLabel
    NewUI := Lv.GetText(RowNumber, 4)

    if OpenUIID != "" and OpenUIID != NewUI {
        TrueMap[UhhMap[OpenUIID].Key].UI.Gui.Hide()
    }

    OpenUIID := NewUI
    UnitSelfMap := TrueMap[UhhMap[OpenUIID].Key]


    if not UnitSelfMap.HasOwnProp("UI") {
        UnitSelfMap.UI := {}
    }

    UnitSelfMap.UI.Row := RowNumber
    FinalizedUI := Gui()

    TotalLength := 0
    if UhhMap.Has(OpenUIID) and not UnitSelfMap.UI.HasOwnProp("Gui") {
        NewUIOrWhatever := Gui()
        RealObject := UnitSelfMap

        ; Title
        UpperText := NewUIOrWhatever.AddText("w200 h25 Section", "Unit Setting | " OpenUIID)
        UpperText.SetFont("s14 w700")
        TotalLength += 35

        ; Slot #
        NewUIOrWhatever.AddText("w100 h25 xs y" (TotalLength), "Slot :").SetFont("s11")
        NewUIOrWhatever.AddEdit("w60 h20 yp xp+150")
        NewUIOrWhatever.AddUpDown("vSlotNumber range1-10000000", RealObject.Slot)
        TotalLength += 25

        ; Pos
        NewUIOrWhatever.AddText("w55 h25 xs y" (TotalLength), "Position :").SetFont("s11")
        SetPosButton := NewUIOrWhatever.Add("Button", "w25 h25 xp+65 yp-2", "S")

        PosX := NewUIOrWhatever.AddEdit("yp+2 xp+25 w60")
        NewUIOrWhatever.AddUpDown("vPosX Range1-40000", RealObject.Pos[1])
        PosY := NewUIOrWhatever.AddEdit("yp xp+60 w60")
        NewUIOrWhatever.AddUpDown("vPosY Range1-40000", RealObject.Pos[2])
        SetPosButton.OnEvent("Click", (*) => CurrentPostionLabel := [PosX, PosY])
        TotalLength += 35

        ; Movement
        NewUIOrWhatever.AddText("w140 h25 Section xs y" (TotalLength), "Movement List").SetFont("s14 w700 underline")
        TestMovemntButton := NewUIOrWhatever.AddButton("w60 h25 xp+140 yp", "Test")
        TestMovemntButton.SetFont("s11 bold")
        MovementButtons := []
        
        TotalLength += 25
        NewUIOrWhatever.AddText("w55 h25 xs+5 y" (TotalLength), "#").SetFont("s11 bold")
        NewUIOrWhatever.AddText("w55 h25 xp+22 y" (TotalLength), "Key").SetFont("s11 bold")
        NewUIOrWhatever.AddText("w75 h25 xp+35 y" (TotalLength), "TimeDown").SetFont("s11 bold")
        NewUIOrWhatever.AddText("w55 h25 xp+85 y" (TotalLength), "Delay").SetFont("s11 bold")

        TotalLength += 20

        loop 5 {
            Text := NewUIOrWhatever.AddText("w20 h25 xs y" (TotalLength), "[X]")
            Text.SetFont("s11")

            ; Key Dropdown
            DropDown := NewUIOrWhatever.AddDropDownList("r4 w40 h25 xp+22 vKey" A_Index, ["W", "A", "S", "D"])

            ; TimeDown Edit
            Edit := NewUIOrWhatever.AddEdit("w60 h20 xp+50", 0)
            EditUpDown := NewUIOrWhatever.AddUpDown("h25 vTimeDown" A_Index " Range10-25000")

            ; Delay Edit
            Edit2 := NewUIOrWhatever.AddEdit("w60 h20 xp+70", 0)
            Edit2UpDown := NewUIOrWhatever.AddUpDown("h25 vDelay" A_Index " Range10-25000")

            TotalLength += 25
            MovementButtons.Push({Num:Text, DDL:DropDown, Edit1:Edit, Edit1UpDown:EditUpDown, Edit2:Edit2, Edit2UpDown:Edit2UpDown})

            DropDown.OnEvent("Change", (*) => ActionUpdated())
            Edit.OnEvent("Change", (*) => ActionUpdated())
            Edit2.OnEvent("Change", (*) => ActionUpdated())
        }
        TotalLength += 5

        AddMovementButton := NewUIOrWhatever.AddButton("xs h25 y" (TotalLength) " w40", "Add")
        RemoveMovementButton := NewUIOrWhatever.AddButton("xp+40 h25 y" (TotalLength) " w50", "Remove")

        Movement_LeftArrow := NewUIOrWhatever.AddButton("w25 xp+75 h25 yp", "<")
        Movement_PageNumber := NewUIOrWhatever.AddText("w35 xp+25 h25 yp +Center", "1/X")
        Movement_RightArrow := NewUIOrWhatever.AddButton("w25 xp+35 h25 yp", ">")

        Movement_LeftArrow.SetFont("bold s15")
        Movement_PageNumber.SetFont("bold s15")
        Movement_RightArrow.SetFont("bold s15")

        TotalLength += 35

        ; Action List
        ActionButtons := []
        NewUIOrWhatever.AddText("w200 h25 Section xs y" (TotalLength), "Action List").SetFont("s14 w700 underline")

        TotalLength += 25
        NewUIOrWhatever.AddText("w55 h25 xs+5 y" (TotalLength), "#").SetFont("s11 bold")
        NewUIOrWhatever.AddText("w55 h25 xp+50 y" (TotalLength), "Action").SetFont("s11 bold")
        NewUIOrWhatever.AddText("w75 h25 xp+92 y" (TotalLength), "Wave").SetFont("s11 bold")

        TotalLength += 20

        loop 5 {
            Text := NewUIOrWhatever.AddText("w20 h25 xs y" (TotalLength), "[X]")
            Text.SetFont("s11")

            ; Action Dropdown
            DropDown := NewUIOrWhatever.AddDropDownList("r4 w80 h25 xp+38 vAction" A_Index, ["Placement", "Upgrade", "Sell"])

            ; Wave Edit
            Edit := NewUIOrWhatever.AddEdit("w60 h20 xp+102", 0)
            UpDown := NewUIOrWhatever.AddUpDown("h25 vWave" A_Index " Range1-25000")

            TotalLength += 25

            ActionButtons.Push({Num:Text, DDL:DropDown, Edit:Edit, EditUpDown:UpDown})

            DropDown.OnEvent("Change", (*) => ActionUpdated())
            Edit.OnEvent("Change", (*) => ActionUpdated())
        }

        AddActionButton := NewUIOrWhatever.AddButton("xs h25 y" (TotalLength) " w40", "Add")
        RemoveActionButton := NewUIOrWhatever.AddButton("xp+40 h25 y" (TotalLength) " w50", "Remove")

        Action_LeftArrow := NewUIOrWhatever.AddButton("w25 xp+75 h25 yp", "<")
        Action_PageNumber := NewUIOrWhatever.AddText("w35 xp+25 h25 yp +Center", "1/X")
        Action_RightArrow := NewUIOrWhatever.AddButton("w25 xp+35 h25 yp", ">")

        TotalLength += 30
        SumbitValueButton := NewUIOrWhatever.AddButton("w120 xs h30 y" (TotalLength), "Save Values")
        ; CloneSelectionButton := NewUIOrWhatever.AddButton("w90 xp+110 h30 y" (TotalLength), "Clone Unit")

        Action_LeftArrow.SetFont("bold s15")
        Action_PageNumber.SetFont("bold s15")
        Action_RightArrow.SetFont("bold s15")
        SumbitValueButton.SetFont("s13")
        ; CloneSelectionButton.SetFont("s12")

        ; Functionality of the UI
        SumbitValueButton.OnEvent("Click", (*) => SetValue())

        for _1, ObjectArray in [ActionButtons, MovementButtons] {
            for _, UIObject in ObjectArray {
                for Name, Value in UIObject.OwnProps() {
                    Value.Visible := false
                }
            }
        }

        ActionPages := Map()
        ActionCurrentPage := 1
        MovementPages := Map()
        MovementCurrentPage := 1
        
        FixMaps() {
            for _1, __1 in [[ActionPages, UnitSelfMap.UnitData], [MovementPages, UnitSelfMap.MovementFromSpawn]] {
                for _2, Data in __1[2] {
                    if not __1[1].Has("p_" (Ceil(_2/5))) {
                        __1[1]["p_" (Ceil(_2/5))] := []
                    }

                    __1[1]["p_" (Ceil(_2/5))].Push(Data)
                }
            }
        }

        ActionMapChoose := Map("Placement", 1, "Upgrade", 2, "Sell", 3)
        MovementMapChoose := Map("W", 1, "A", 2, "S", 3, "D", 4)

        PageChanged(Type, PageMap, GuiObjectMap, CurrentPage) {
            if not PageMap.Has("p_" CurrentPage) and not PageMap.Count < 1 {
                switch Type {
                    case "Action":
                        CHP_Action("Left")
                    case "Movement":
                        CHP_Movement("Left")
                }

                OutputDebug(1)
                return
            } else if PageMap.Count < 1 {
                for _1, GuiObject in GuiObjectMap {
                    for _2, GuiControl in GuiObject.OwnProps() {
                        
                        GuiControl.Visible := false
                    }
                }

                return
            }

            for _1, DataObject in PageMap["p_" CurrentPage] {
                switch Type {
                    case "Action":
                        CorrespondingMacroObject := GuiObjectMap[_1]

                        CorrespondingMacroObject.Num.Text := "[" _1 + ((5 * CurrentPage) - 5) "]"
                        CorrespondingMacroObject.Num.Visible := true
                        CorrespondingMacroObject.DDL.Choose(ActionMapChoose[DataObject.Type])
                        CorrespondingMacroObject.DDL.Visible := true
                        CorrespondingMacroObject.Edit.Text := DataObject.Wave
                        CorrespondingMacroObject.Edit.Visible := true
                        CorrespondingMacroObject.EditUpDown.Visible := true

                        Action_PageNumber.Text := CurrentPage "/" PageMap.Count
                    case "Movement":
                        CorrespondingMacroObject := GuiObjectMap[_1]

                        CorrespondingMacroObject.Num.Text := "[" _1 + ((5 * CurrentPage) - 5) "]"
                        CorrespondingMacroObject.Num.Visible := true
                        CorrespondingMacroObject.DDL.Choose(MovementMapChoose[DataObject.Key])
                        CorrespondingMacroObject.DDL.Visible := true
                        CorrespondingMacroObject.Edit1.Text := DataObject.TimeDown
                        CorrespondingMacroObject.Edit1.Visible := true
                        CorrespondingMacroObject.Edit2.Text := DataObject.delay
                        CorrespondingMacroObject.Edit2.Visible := true

                        CorrespondingMacroObject.Edit1UpDown.Visible := true
                        CorrespondingMacroObject.Edit2UpDown.Visible := true

                        Movement_PageNumber.Text := CurrentPage "/" PageMap.Count
                }
            }

        
            if PageMap["p_" CurrentPage].Length < 5 {
                for _1, GuiObject in GuiObjectMap {
                    if _1 > PageMap["p_" CurrentPage].Length {
                        for _2, GuiControl in GuiObject.OwnProps() {
                            
                            GuiControl.Visible := false
                        }
                    }
                }
            }
        }

        ChangePage(Direction := "Right", PageMap := Map(), CurrentPage := 1) {
            if PageMap.Count <= 1 and not CurrentPage != 1 {
                return 9999
            }

            switch Direction {
                case "Right":
                    if (CurrentPage + 1) > PageMap.Count {
                        return 1
                    }
        
                    return CurrentPage += 1
                case "Left":
                    if (CurrentPage - 1) <= 0 {
                        return PageMap.Count
                    }
        
                    return CurrentPage - 1
            }
        }

        CHP_Action(Direction) {
            ActionCurrentPage := ChangePage(Direction, ActionPages, ActionCurrentPage)

            if ActionCurrentPage = 9999 {
                ActionCurrentPage := 1
                return
            }

            PageChanged("Action", ActionPages, ActionButtons, ActionCurrentPage)
        }

        CHP_Movement(Direction) {
            MovementCurrentPage := ChangePage(Direction, MovementPages, MovementCurrentPage)

            if MovementCurrentPage = 9999 {
                MovementCurrentPage := 1
                return
            }

            PageChanged("Movement", MovementPages, MovementButtons, MovementCurrentPage)
        }

        AdditionAction() {
            if UnitSelfMap.UnitData.Length >= 100 {
                MsgBox("i know you are ecstatic to add more but im going to have to limit you here.")
                return
            }

            UnitSelfMap.UnitData.Push({Type:"Upgrade", Wave:1, ActionCompleted:false})
            ActionPages.Clear()

            FixMaps()
            PageChanged("Action", ActionPages, ActionButtons, ActionCurrentPage)
        }

        AdditionMovement() {
            if UnitSelfMap.MovementFromSpawn.Length >= 100 {
                MsgBox("i know you are ecstatic to add more but im going to have to limit you here.")
                return
            }
            
            UnitSelfMap.MovementFromSpawn.Push({Key:"W", TimeDown:100, Delay:1})
            MovementPages.Clear()

            FixMaps()
            PageChanged("Movement", MovementPages, MovementButtons, MovementCurrentPage)
        }

        RemovalAction() {
            if UnitSelfMap.UnitData.Length <= 0 {
                MsgBox("What else could you possibly want removed?")
                return
            }

            UnitSelfMap.UnitData.RemoveAt(UnitSelfMap.UnitData.Length)
            ActionPages.Clear()

            FixMaps()
            PageChanged("Action", ActionPages, ActionButtons, ActionCurrentPage)
        }

        RemovalMovement() {
            if UnitSelfMap.MovementFromSpawn.Length <= 0 {
                MsgBox("What else could you possibly want removed?")
                return
            }

            UnitSelfMap.MovementFromSpawn.RemoveAt(UnitSelfMap.MovementFromSpawn.Length )
            MovementPages.Clear()

            FixMaps()
            PageChanged("Movement", MovementPages, MovementButtons, MovementCurrentPage)
        }

        ActionUpdated() {
            AbsoluteValues := NewUIOrWhatever.Submit(false)

            loop 5 {
                ActionGuiObject := ActionButtons[A_Index]
                MovementGuiObject := MovementButtons[A_Index]

                ; Saving Actions
                ; (A_Index + (5 * ActionCurrentPage) - 5)
                if UnitSelfMap.UnitData.Has(A_Index + (5 * ActionCurrentPage) - 5) {
                    UnitObject := UnitSelfMap.UnitData[A_Index + (5 * ActionCurrentPage) - 5]

                    UnitObject.Type := AbsoluteValues.%"Action" A_Index%
                    UnitObject.Wave := AbsoluteValues.%"Wave" A_Index%
                }

                if UnitSelfMap.MovementFromSpawn.Has(A_Index + (5 * MovementCurrentPage) - 5) {
                    MovementObject := UnitSelfMap.MovementFromSpawn[A_Index + (5 * MovementCurrentPage) - 5]

                    MovementObject.Key := AbsoluteValues.%"Key" A_Index%
                    MovementObject.TimeDown := AbsoluteValues.%"TimeDown" A_Index%
                    MovementObject.Delay := AbsoluteValues.%"Delay" A_Index%
                }
            }
        }

        SetValue() {
            AbsoluteValues := NewUIOrWhatever.Submit(true)

            UnitSelfMap.Slot := AbsoluteValues.SlotNumber
            UnitSelfMap.Pos := [AbsoluteValues.PosX, AbsoluteValues.PosY]

            ActionNumber := UnitSelfMap.UnitData.Length

            if ActionNumber > 1 {
                ActionNumber := ActionNumber " Actions"
            } else {
                ActionNumber := ActionNumber " Action"
            }

            LowestWave := 9999
            for _, DataObj in UnitSelfMap.UnitData {
                LowestWave := Min(LowestWave, DataObj.Wave)
            }

            Lv.Modify(UnitSelfMap.UI.Row, "Col1", AbsoluteValues.SlotNumber, ActionNumber, "Wave " LowestWave)
            EvilLV.Modify(UnitSelfMap.UI.Row, "Col1", AbsoluteValues.SlotNumber)
        }

        TestMovement() {
            try {
                WinActivate("ahk_exe RobloxPlayerBeta.exe")

                for _, MovementObject in UnitSelfMap.MovementFromSpawn {
                    Sleep(MovementObject.Delay)
                    SendEvent "{" MovementObject.Key " Down}"
                    Sleep(MovementObject.TimeDown)
                    SendEvent "{" MovementObject.Key " Up}"
                }
            } catch as E {
                MsgBox("Error : " E.Message)
            }
        }

        Action_LeftArrow.OnEvent("Click", (*) => CHP_Action("Left"))
        Action_RightArrow.OnEvent("Click", (*) => CHP_Action("Right"))
        Movement_LeftArrow.OnEvent("Click", (*) => CHP_Movement("Left"))
        Movement_RightArrow.OnEvent("Click", (*) => CHP_Movement("Right"))

        AddActionButton.OnEvent("Click", (*) => AdditionAction())
        AddMovementButton.OnEvent("Click", (*) => AdditionMovement())
        RemoveActionButton.OnEvent("Click", (*) => RemovalAction())
        RemoveMovementButton.OnEvent("Click", (*) => RemovalMovement())

        TestMovemntButton.OnEvent("Click", (*) => TestMovement())

        FixMaps()
        PageChanged("Action", ActionPages, ActionButtons, ActionCurrentPage)
        PageChanged("Movement", MovementPages, MovementButtons, MovementCurrentPage)

        __HeldUIs["UID" TrueObject.UID].Push(NewUIOrWhatever)
        
        FinalizedUI := NewUIOrWhatever
        UnitSelfMap.UI.Gui := FinalizedUI
    } else {
        FinalizedUI := UnitSelfMap.UI.Gui
    }

    OriginalUI.GetPos(&X1, &Y1, &X2, &Y2)
    FinalizedUI.Show("X" X1 + X2 " Y" Y1)

    return FinalizedUI
}

; If you cant tell this shit is getting confusing as hell
global UpwardUnitSelection := ""
global UpwardUnitSelection_2 := ""
UnitSelectionTypeUI(UhhMap) {
    AddtiveGui := Gui(,"Add UI")
    DeletiveGui := Gui()
    Clone_ive := Gui()
    AddButton := ""
    RemoveButton := ""

    SelectedID := ""
    SelectedRow := 0

    AddtiveGui.AddText("w145 h30 Section","Add Unit To UI").SetFont("bold s15")
    AddtiveGui.AddText("w30 h25 yp+30", "Slot:").SetFont("s10")
    AddtiveGui.AddEdit("Number w50 h20 xp+90 yp").SetFont("s10")
    AddtiveGui.AddUpDown("vSlotNumber")
    AddButton := AddtiveGui.AddButton("xs w70 h25","Add Unit")
    AddButton.SetFont("s11")

    DeletiveGui.AddText("w210 h30 Section","Remove Unit From UI").SetFont("bold s15")
    Unit_LV := DeletiveGui.AddListView("r15 LV0x10 Hdr ReadOnly w210", ["Slot", "id"])
    DeletiveGui.AddText("xp+215 h30 yp w130", "Selection Chosen").SetFont("s10 bold underline")
    SelectionText := DeletiveGui.AddText("xp h30 yp+15 w130", "[None]")
    SelectionText.SetFont("s10 bold")
    RemoveButton := DeletiveGui.AddButton("xp h30 yp+239 w130", "Remove Selection")
    RemoveButton.SetFont("s11")
    RemoveButton.Enabled := false

    Clone_ive.AddText("w210 h30 Section","Clone Unit From UI").SetFont("bold s15")
    Unit_LVC := Clone_ive.AddListView("r15 LV0x10 Hdr ReadOnly w210", ["Slot", "id"])
    Clone_ive.AddText("xp+215 h30 yp w130", "Selection Chosen").SetFont("s10 bold underline")
    SelectionTextC := Clone_ive.AddText("xp h30 yp+15 w130", "[None]")
    SelectionTextC.SetFont("s10 bold")
    CloneButton := Clone_ive.AddButton("xp h30 yp+239 w130", "Clone Selection")
    CloneButton.SetFont("s11")
    CloneButton.Enabled := false

    for ID, Idobj in UhhMap {
        Unit_LV.Add(, Idobj.Slot, ID)
        Unit_LVC.Add(, Idobj.Slot, ID)
    }

    MinorFunc(LV, RowNum) {
        global UpwardUnitSelection

        SelectedID := Lv.GetText(RowNum, 2)
        SelectedRow := RowNum
        UpwardUnitSelection := SelectedID

        SelectionText.Text := SelectedID
        RemoveButton.Enabled := true
    }

    MinorFunc2(Lv, RowNum) {
        global UpwardUnitSelection_2

        SelectedID := Lv.GetText(RowNum, 2)
        SelectedRow := RowNum
        UpwardUnitSelection_2 := SelectedID

        SelectionTextC.Text := SelectedID
        CloneButton.Enabled := true
    }

    Unit_LV.OnEvent("DoubleClick", MinorFunc)
    Unit_LVC.OnEvent("DoubleClick", MinorFunc2)

    return {Add:{
        GUI:AddtiveGui,
        Button:AddButton
    }, Remove:{
        GUI:DeletiveGui,
        Button:RemoveButton,
        LV:Unit_LV,
        SelectionText:SelectionText,
    }, Clone:{
        GUI:Clone_ive,
        Button:CloneButton,
        LV:Unit_LVC,
        SelectionText:SelectionTextC,
    }
}
}

global ListViewUnitNumber := 0
CreateUnitUI(_MapOBJ, BaseUI, PreviousObject := {}, ShowUI := true, VariablisticMap := Map()) {
    global __HeldUIs
    TrueObject := PreviousObject

    UnitUI := Gui()
    UhhMap := Map()

    UIMAP := Map()

    UnitMap := _MapOBJ.Map

    UnitUI.AddText("w200 h25 Section", "Unit Settings").SetFont("s14 w700")
    Unit_LV := UnitUI.AddListView("r15 LV0x10 Hdr ReadOnly w255", ["Slot", "Action #'s", "First Action Wave", "id"])

    AddSelectionButton := UnitUI.AddButton("w75 h25", "Add Selection")
    RemoveSelectionButton := UnitUI.AddButton("w95 h25 xp+75", "Remove Selection")
    CloneSelectionButton := UnitUI.AddButton("w85 h25 xp+95", "Clone Selection")

    ListViewUnitFunc() {
        global ListViewUnitNumber

        for UnitMapKey, UnitObject in UnitMap {
            EarliestWave := 999
            for _, Obj in UnitObject.UnitData {
                EarliestWave := Min(EarliestWave, Obj.Wave)
            }
    
            if not UnitObject.HasOwnProp("ID") {
                ListViewUnitNumber++
                UnitObject.ID := ListViewUnitNumber
            }

            Unit_LV.Add(, UnitObject.Slot, UnitObject.UnitData.Length " Actions", "Wave " EarliestWave, "ID:" UnitObject.ID)
            UhhMap["ID:" UnitObject.ID] := {Key:UnitMapKey, Row:ListViewUnitNumber, Slot:UnitObject.Slot}
        }
    }
    
    ListViewUnitFunc()

    ReturnedUIObjects := UnitSelectionTypeUI(UhhMap)
    Unit_LV.OnEvent("DoubleClick", (Lv, RowNumber) => UIMAP[CharacteristicUI(RowNumber, UhhMap, Lv, UnitMap, UnitUI, ReturnedUIObjects.Remove.LV, TrueObject)] := true)
    
    ShowGuiRight(TheGui) {
        UnitUI.GetPos(&x1, &x2, &x3, &x4)
        TheGui.Show("X" x1 + x3 " Y" x2)
    }

    AddSelectionButton.OnEvent("Click", (*) => ShowGuiRight(ReturnedUIObjects.Add.GUI))
    RemoveSelectionButton.OnEvent("Click", (*) => ShowGuiRight(ReturnedUIObjects.Remove.GUI))
    CloneSelectionButton.OnEvent("Click", (*) => ShowGuiRight(ReturnedUIObjects.Clone.GUI))

    ReturnedUIObjects.Add.Button.OnEvent("Click", (*) => AddSelection())
    ReturnedUIObjects.Remove.Button.OnEvent("Click", (*) => RemoveSelection())
    ReturnedUIObjects.Clone.Button.OnEvent("Click", (*) => CloneSelection())

    AddSelection() {
        global ListViewUnitNumber

        SumbitValue := ReturnedUIObjects.Add.GUI.Submit().SlotNumber

        ListViewUnitNumber++
        UnitObject := UnitMap["Unit_" (UnitMap.Count + 1)] := {Slot:SumbitValue, Pos:[0,0], UnitData:[], MovementFromSpawn:[], ID:ListViewUnitNumber}

        Unit_LV.Add(, UnitObject.Slot, UnitObject.UnitData.Length " Actions", "Wave " 999, "ID:" ListViewUnitNumber)
        ReturnedUIObjects.Remove.LV.Add(, UnitObject.Slot, "ID:" ListViewUnitNumber)
        ReturnedUIObjects.Clone.LV.Add(, UnitObject.Slot, "ID:" ListViewUnitNumber)
        UhhMap["ID:" UnitObject.ID] := {Key:"Unit_" UnitMap.Count, Row:ListViewUnitNumber, Slot:UnitObject.Slot}
    }

    RemoveSelection() {
        global OpenUIID

        ReturnedUIObjects.Remove.GUI.Submit()
        ReturnedUIObjects.Remove.Button.Enabled := false
        ReturnedUIObjects.Remove.SelectionText.Text := "[None]"

        if OpenUIID = UpwardUnitSelection {
            UnitMap[UhhMap[UpwardUnitSelection].Key].UI.Gui.Destroy()
            OpenUIID := ""
        }

        UnitMap.Delete(UhhMap[UpwardUnitSelection].Key)
        OutputDebug("`nCount:" UnitMap.Count)

        TempMap := Map()

        loop 100 {
            Unit_LV.Delete(101-A_Index)
            ReturnedUIObjects.Remove.LV.Delete(101-A_Index)
            ReturnedUIObjects.Clone.LV.Delete(101-A_Index)
        }

        UhhMap.Clear()
        ListViewUnitFunc()
        
        for Id, Idobj in UhhMap {
            ReturnedUIObjects.Clone.LV.Add(, Idobj.Slot, ID)
            ReturnedUIObjects.Remove.LV.Add(, Idobj.Slot, ID)
        }
    }

    CloneSelection() {
        global ListViewUnitNumber


        ReturnedUIObjects.Clone.GUI.Submit()
        ReturnedUIObjects.Clone.Button.Enabled := false
        ReturnedUIObjects.Clone.SelectionText.Text := "[None]"

        NewClone := SwitchCheck(UnitMap[UhhMap[UpwardUnitSelection_2].Key])
        ListViewUnitNumber++

        NewClone.ID := ListViewUnitNumber
        UnitObject := UnitMap["Unit_" (UnitMap.Count + 1)] := NewClone

        EarliestWave := 999
        for _, Obj in UnitObject.UnitData {
            EarliestWave := Min(EarliestWave, Obj.Wave)
        }

        Unit_LV.Add(, UnitObject.Slot, UnitObject.UnitData.Length " Actions", "Wave " EarliestWave, "ID:" ListViewUnitNumber)
        ReturnedUIObjects.Remove.LV.Add(, UnitObject.Slot, "ID:" ListViewUnitNumber)
        ReturnedUIObjects.Clone.LV.Add(, UnitObject.Slot, "ID:" ListViewUnitNumber)
        UhhMap["ID:" UnitObject.ID] := {Key:"Unit_" UnitMap.Count, Row:ListViewUnitNumber, Slot:UnitObject.Slot}
    }

    RefreshUI(*) {
        ReturnedUIObjects.Add.GUI.Destroy()
        ReturnedUIObjects.Remove.GUI.Destroy()
        UnitUI.Destroy()

        for UI, _ in UIMAP {
            try {
                UI.Destroy()
            }
        }

        global UpwardUnitSelection := ""
        global OpenUIID := ""
        global ListViewUnitNumber := 0

        NewUIObject := CreateUnitUI(_MapOBJ, BaseUI, TrueObject)
        NewUIObject.UI.Show()
        TrueObject.Button.OnEvent("Click", ShowFunction, false)
    }

    LoadRefreshUI(*) {
        ReturnedUIObjects.Add.GUI.Destroy()
        ReturnedUIObjects.Remove.GUI.Destroy()
        UnitUI.Destroy()

        for UI, _ in UIMAP {
            try {
                UI.Destroy()
            }
        }

        global UpwardUnitSelection := ""
        global OpenUIID := ""
        global ListViewUnitNumber := 0

        NewUIObject := CreateUnitUI(_MapOBJ, BaseUI, TrueObject)
        TrueObject.Button.OnEvent("Click", ShowFunction, false)
    }


    ShowFunction(*) {
        BaseUI.GetPos(&u, &u2, &u3, &u4)
        UnitUI.Show("X" u + u3 " Y" u2 "")
    }

    TrueObject.ShowFunction := ShowFunction
    TrueObject.UI := UnitUI
    TrueObject.Button.OnEvent("Click", ShowFunction, true)
    TrueObject.RefreshFunc := LoadRefreshUI

    UIS := [UnitUI, ReturnedUIObjects.Add.GUI, ReturnedUIObjects.Remove.GUI]
    For _, UI in UIS {
        __HeldUIs["UID" PreviousObject.UID].InsertAt(__HeldUIs["UID" PreviousObject.UID].Length + 1, UI)
    }

    return TrueObject
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
