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
    "UnitWaveUI", CreateWaveUnitUI,
    "UnitActionUI", CreateActionUnitUI
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
    AdvancedSettings.Opt("")
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
    BaseGui.Opt("")

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
                    case "Selection", "MM_Empower", "UnitWaveUI", "UnitActionUI":
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
                    case "Selection", "MM_Empower", "UnitWaveUI", "UnitActionUI":
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
                case "UnitActionUI":
                    UnitMap := SettingObject.Map["UnitMap"]
                    UnitActionArray := SettingObject.Map["UnitActionArray"]
                    UnitEventArray := SettingObject.Map["UnitEventArray"]

                    FormattedText_1 := ""
                    FormattedText_2 := ""
                    FormattedText_3 := ""

                    FormattedTextArray_1 := []
                    for UnitName, UnitData in UnitMap {
                        Slot := UnitData.Slot
                        PosX := UnitData.Pos[1]
                        PosY := UnitData.Pos[2]
                        MovementFromSpawnArray := UnitData.MovementFromSpawn

                        MovementText := ""
                        for _, MovementObject in MovementFromSpawnArray {
                            if _ = MovementFromSpawnArray.Length {
                                MovementText := MovementText MovementObject.Key "?" MovementObject.Timedown "?" MovementObject.Delay
                            } else {
                                MovementText MovementObject.Key "?" MovementObject.Timedown "?" MovementObject.Delay ","
                            }
                        }

                        if MovementText = "" {
                            MovementText := "nil"
                        }

                        FormattedTextArray_1.Push(UnitName "|" Slot "|" PosX "." PosY "|" MovementText)
                    }

                    FormattedTextArray_2 := []
                    for _1, UnitObject in UnitActionArray {

                        Unit := UnitObject.Unit
                        Action := UnitObject.Action

                        FormattedTextArray_2.Push(Unit "|" Action)
                    }

                    FormattedTextArray_3 := []
                    for _2, UnitObject in UnitEventArray {
                        Unit := UnitObject.Unit
                        Action := UnitObject.Action
                        AfterAction := UnitObject.AfterAction
                        IsLooped := UnitObject.IsLooped
                        LoopDelay := UnitObject.LoopDelay

                        FormattedTextArray_3.Push(Unit "|" Action "|" AfterAction "|" IsLooped "|" LoopDelay)
                    }

                    for _, Text in FormattedTextArray_1 {
                        if _ = FormattedTextArray_1.Length {
                            FormattedText_1 := FormattedText_1 Text
                        } else {
                            FormattedText_1 := FormattedText_1 Text "!"
                        }
                    }

                    for _, Text in FormattedTextArray_2 {
                        if _ = FormattedTextArray_2.Length {
                            FormattedText_2 := FormattedText_2 Text
                        } else {
                            FormattedText_2 := FormattedText_2 Text "!"
                        }
                    }

                    for _, Text in FormattedTextArray_3 {
                        if _ = FormattedTextArray_3.Length {
                            FormattedText_3 := FormattedText_3 Text
                        } else {
                            FormattedText_3 := FormattedText_3 Text "!"
                        }
                    }

                    IniWrite(FormattedText_1, FileToSaveTo, SettingObject.SaveName, "FormatString_Unit")
                    IniWrite(FormattedText_2, FileToSaveTo, SettingObject.SaveName, "FormatString_Action")
                    IniWrite(FormattedText_3, FileToSaveTo, SettingObject.SaveName, "FormatString_Event")
                case "UnitWaveUI":
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
                case "UnitActionUI":
                    FormattedText1 := IniRead(LoadFile, SettingObject.SaveName, "FormatString_Unit")
                    FormattedText2 := IniRead(LoadFile, SettingObject.SaveName, "FormatString_Action")
                    FormattedText3 := IniRead(LoadFile, SettingObject.SaveName, "FormatString_Event")

                    UnitMap := SettingObject.Map["UnitMap"]
                    UnitActionArray := SettingObject.Map["UnitActionArray"]
                    UnitEventArray := SettingObject.Map["UnitEventArray"]

                    UnitMap.Clear()
                    Upperspltical1 := StrSplit(FormattedText1, "!")
                    for _, UnitString in Upperspltical1 {
                        LowerSplitical1 := StrSplit(UnitString, "|")

                        UnitName := LowerSplitical1[1]
                        UnitSlot := LowerSplitical1[2]
                        UnitPosition := StrSplit(LowerSplitical1[3], ".")
                        UnitMovementData := LowerSplitical1[4]

                        DataObject := {Slot:UnitSlot, Pos:[UnitPosition[1], UnitPosition[2]], MovementFromSpawn:[], UnitData:[], IsPlaced:false}

                        if not UnitMovementData = "nil" {
                            LowerSplitical2 := StrSplit(UnitMovementData, ",")

                            for _, MovementString in LowerSplitical2 {
                                LowerSplitical3 := StrSplit(MovementString, "?")

                                DataObject.MovementFromSpawn.Push({Key:LowerSplitical3[1], TimeDown:LowerSplitical3[2], Delay:LowerSplitical3[3]})
                            }
                        }

                        UnitMap[UnitName] := DataObject
                    }

                    
                    Upperspltical2 := StrSplit(FormattedText2, "!")
                    loop UnitActionArray.Length {
                        UnitActionArray.RemoveAt(1)
                    }

                    for _, ActionString in Upperspltical2 {
                        LowerSplitical1 := StrSplit(ActionString, "|")

                        UnitActionArray.Push({Unit:LowerSplitical1[1], Action:LowerSplitical1[2], ActionCompleted:false})
                    }

                    Upperspltical3 := StrSplit(FormattedText3, "!")
                    loop UnitEventArray.Length {
                        UnitEventArray.RemoveAt(1)
                    }

                    for _, EventString in Upperspltical3 {
                        LowerSplitical1 := StrSplit(EventString, "|")

                        UnitEventArray.Push({Unit:LowerSplitical1[1], Action:LowerSplitical1[2], AfterAction:LowerSplitical1[3], IsLooped:LowerSplitical1[4], LoopDelay:LowerSplitical1[5], LastDelay:0})
                    }

                    SettingObject.UIObject.RefreshFunc()
                case "UnitWaveUI":
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
                                if Splitical3.Length > 2 {
                                    UnitDataArray.Push({Type:Splitical3[1], Wave:Splitical3[2], ActionCompleted:false, Delay:Splitical3[3]})
                                } else {
                                    UnitDataArray.Push({Type:Splitical3[1], Wave:Splitical3[2], ActionCompleted:false, Delay:0})
                                }
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

        
        ObjectSettingsUI.AddText("w200 h20 xs y" NextOffset, Name).SetFont("s13 w700 underline")
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
                            Objective.%I% := ObjectSettingsUI.Submit().%I Name%
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
global OpenUI := ""
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
        NewUIOrWhatever.AddText("w55 h25 xp+30 y" (TotalLength), "Action").SetFont("s11 bold")
        NewUIOrWhatever.AddText("w75 h25 xp+69 y" (TotalLength), "Wave").SetFont("s11 bold")
        NewUIOrWhatever.AddText("w42 h25 xp+55 y" (TotalLength), "Delay").SetFont("s11 bold")

        TotalLength += 20

        loop 5 {
            Text := NewUIOrWhatever.AddText("w20 h25 xs y" (TotalLength), "[X]")
            Text.SetFont("s11")

            ; Action Dropdown
            DropDown := NewUIOrWhatever.AddDropDownList("r5 w75 h25 xp+22 vAction" A_Index, ["Placement", "Upgrade", "Sell", "Ability", "Target"])

            ; Wave Edit
            Edit := NewUIOrWhatever.AddEdit("w40 h20 xp+82", 0)
            UpDown := NewUIOrWhatever.AddUpDown("h25 vWave" A_Index " Range1-25000")

            ; Delay Edit
            DelayEdit := NewUIOrWhatever.AddEdit("w60 h20 xp+47", 0)
            DelayUpDown := NewUIOrWhatever.AddUpDown("h25 vActionDelay" A_Index " Range1-9999999")

            TotalLength += 25

            ActionButtons.Push({Num:Text, DDL:DropDown, Edit:Edit, EditUpDown:UpDown, DelayEdit:DelayEdit, DelayUpDown:DelayUpDown})

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

        ActionMapChoose := Map("Placement", 1, "Upgrade", 2, "Sell", 3, "Ability", 4, "Target", 5)
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
                        CorrespondingMacroObject.DelayEdit.Visible := true
                        CorrespondingMacroObject.DelayUpDown.Visible := true

                        if not DataObject.HasOwnProp("Delay") {
                            DataObject.Delay := 0
                        }

                        CorrespondingMacroObject.DelayEdit.Text := DataObject.Delay
                        
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
CreateWaveUnitUI(_MapOBJ, BaseUI, PreviousObject := {}, ShowUI := true, VariablisticMap := Map()) {
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

        NewUIObject := CreateWaveUnitUI(_MapOBJ, BaseUI, TrueObject)
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

        NewUIObject := CreateWaveUnitUI(_MapOBJ, BaseUI, TrueObject)
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

;-- AV, New placement system
RevampCharacteristicUI(Lv, RN, Maps, UhhMap, TrueObject, RedoFunc, OriginalUI) {
    global OpenUIID
    global CurrentPostionLabel
    global OpenUI

    if RN == 0 {
        return
    }

    UnitMap := Maps[1]
    UnitActionArray := Maps[2]
    UnitEventArray := Maps[3]


    SelfKey := Lv.GetText(RN, 1)

    if OpenUIID != "" and OpenUIID != SelfKey {
        UnitMap[OpenUIID].UI.Gui.Hide()
    }

    OpenUIID := SelfKey
    UnitSelfMap := UnitMap[SelfKey]


    if not UnitSelfMap.HasOwnProp("UI") {
        UnitSelfMap.UI := {}
    }

    FinalizedUI := Gui()

    TotalLength := 0
    if UhhMap.Has("ID:" UnitSelfMap.ID) and not UnitSelfMap.UI.HasOwnProp("Gui") {
        NewUIOrWhatever := Gui()
        RealObject := UnitSelfMap

        ; Title
        UpperText := NewUIOrWhatever.AddText("w250 h25 Section", "Unit Settings | " OpenUIID)
        UpperText.SetFont("s12 w700")
        TotalLength += 35

        ; Name
        NewUIOrWhatever.AddText("w100 h25 xs y" (TotalLength), "Name :").SetFont("s11")
        NewUIOrWhatever.AddEdit("w100 h20 yp xp+110 vName", SelfKey)
        TotalLength += 25

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

        TotalLength += 30
        SumbitValueButton := NewUIOrWhatever.AddButton("w120 xs h30 y" (TotalLength), "Save Values")
        ; CloneSelectionButton := NewUIOrWhatever.AddButton("w90 xp+110 h30 y" (TotalLength), "Clone Unit")

        SumbitValueButton.SetFont("s13")
        ; CloneSelectionButton.SetFont("s12")

        ; Functionality of the UI
        SumbitValueButton.OnEvent("Click", (*) => SetValue())


        Movement_LeftArrow.SetFont("bold s15")
        Movement_PageNumber.SetFont("bold s15")
        Movement_RightArrow.SetFont("bold s15")
        MovementPages := Map()
        MovementCurrentPage := 1
        
        FixMaps() {
            for _1, __1 in [[MovementPages, UnitSelfMap.MovementFromSpawn]] {
                for _2, Data in __1[2] {
                    if not __1[1].Has("p_" (Ceil(_2/5))) {
                        __1[1]["p_" (Ceil(_2/5))] := []
                    }

                    __1[1]["p_" (Ceil(_2/5))].Push(Data)
                }
            }
        }

        MovementMapChoose := Map("W", 1, "A", 2, "S", 3, "D", 4)

        PageChanged(Type, PageMap, GuiObjectMap, CurrentPage) {
            if not PageMap.Has("p_" CurrentPage) and not PageMap.Count < 1 {
                switch Type {
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

        CHP_Movement(Direction) {
            MovementCurrentPage := ChangePage(Direction, MovementPages, MovementCurrentPage)

            if MovementCurrentPage = 9999 {
                MovementCurrentPage := 1
                return
            }

            PageChanged("Movement", MovementPages, MovementButtons, MovementCurrentPage)
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
                MovementGuiObject := MovementButtons[A_Index]

                if UnitSelfMap.MovementFromSpawn.Has(A_Index + (5 * MovementCurrentPage) - 5) {
                    MovementObject := UnitSelfMap.MovementFromSpawn[A_Index + (5 * MovementCurrentPage) - 5]

                    MovementObject.Key := AbsoluteValues.%"Key" A_Index%
                    MovementObject.TimeDown := AbsoluteValues.%"TimeDown" A_Index%
                    MovementObject.Delay := AbsoluteValues.%"Delay" A_Index%
                }
            }
        }

        SetValue() {
            AbsoluteValues := NewUIOrWhatever.Submit(false)

            UnitSelfMap.Slot := AbsoluteValues.SlotNumber
            UnitSelfMap.Pos := [AbsoluteValues.PosX, AbsoluteValues.PosY]

            if AbsoluteValues.Name != SelfKey {
                if UnitMap.Has(AbsoluteValues.Name) {
                    MsgBox("Already existing name for: " AbsoluteValues.Name)
                    return
                }

                Cloned := SwitchCheck(UnitSelfMap)

                UnitMap.Delete(SelfKey)
                UnitMap[AbsoluteValues.Name] := Cloned
                OpenUIID := AbsoluteValues.Name

                for _, V1 in [UnitActionArray, UnitEventArray] {
                    for _, V2 in V1 {
                        if V2.Unit = SelfKey {
                            V2.Unit := AbsoluteValues.Name
                        }
                    }
                }

                SelfKey := AbsoluteValues.Name
                NewUIOrWhatever.Hide
            }

            RedoFunc()
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

        Movement_LeftArrow.OnEvent("Click", (*) => CHP_Movement("Left"))
        Movement_RightArrow.OnEvent("Click", (*) => CHP_Movement("Right"))

        AddMovementButton.OnEvent("Click", (*) => AdditionMovement())
        RemoveMovementButton.OnEvent("Click", (*) => RemovalMovement())

        TestMovemntButton.OnEvent("Click", (*) => TestMovement())

        FixMaps()
        PageChanged("Movement", MovementPages, MovementButtons, MovementCurrentPage)

        __HeldUIs["UID" TrueObject.UID].Push(NewUIOrWhatever)
        
        FinalizedUI := NewUIOrWhatever
        UnitSelfMap.UI.Gui := FinalizedUI
    } else {
        FinalizedUI := UnitSelfMap.UI.Gui
    }

    OriginalUI.GetPos(&X1, &Y1, &X2, &Y2)
    FinalizedUI.Show("X" X1 + X2 " Y" Y1)
    OpenUI := FinalizedUI

    return FinalizedUI
}

global _UnitMap_ListViewNumber := 0
global _UnitActionArray_ListViewNumber := 0
global _UnitEventArray_ListViewNumber := 0

global UpwardSelections := [["", ""], ["", ""], ["", ""]] 
global __t_2 := []
global __t_3 := []
global __t_4 := []

OutsideFunction(_1, _2, ListViewObjects, UI, Names, BaseStuff, UiComplex) {
    _ListView := UI.AddListView("r15 LV0x10 Hdr ReadOnly w215", ListViewObjects[_1])
    UI.AddText("xp+220 h30 yp w130", "Selection Chosen").SetFont("s10 bold underline")
    SelectionText := UI.AddText("xp h30 yp+15 w130", "[None]")
    SelectionText.SetFont("s10 bold")
    ConfirmButton := UI.AddButton("xp h30 yp+239 w130", StrReplace(Names[_2], " [X]", " ") "Selection")
    ConfirmButton.SetFont("s11")
    ConfirmButton.Enabled := false

    ; OutputDebug(_ListView.Count)
    switch _1 {
        case 3:
            _ListView.ModifyCol(1,80)
            _ListView.ModifyCol(2,70)
            _ListView.ModifyCol(3,60)
            _ListView.ModifyCol(4,0)
        default:
            _ListView.ModifyCol(1,105)
            _ListView.ModifyCol(2,105)
            _ListView.ModifyCol(3,0)
    }

    for _3, DataObj in BaseStuff[_1] {
        switch _1 {
            case 1:
                _ListView.Add(, _3, DataObj.Slot, DataObj.ID)
            case 2:
                _ListView.Add(, DataObj.Unit, DataObj.Action, DataObj.ID)
            case 3:
                _ListView.Add(, DataObj.Unit, DataObj.Action, DataObj.IsLooped, DataObj.ID)
        }
    }

    if _2 == 2 {
        __t_2.Push(_ListView)
    }

    if _1 == 3 {
        __t_3.Push(_ListView)
    } else if _1 == 2 {
        __t_4.Push(_ListView)
    }

    UiComplex[_2].ListView := _ListView
    UiComplex[_2].ConfirmButton := ConfirmButton
    UiComplex[_2].SelectionText := SelectionText

    MinorFunctionOne(Lv, RowNum) {
        if RowNum = 0 {
            return
        }

        TypeOfListView := 2
        IdRow := 3
        ParentMap := 1

        ; TypeOfListView = [1 = Remove, 2 = Clone]
        ; IDRow = [3 = Id found on row 3, 4 = Id found on Row 4]
        ; ParentMap = [1 = UnitMap, 2 = UnitActionArray, 3 = UnitEventArray]

        for _5, PotentialLVArray in [__t_2, __t_3, __t_4] {
            for _6, PotentialLV in PotentialLVArray {
                if PotentialLV = Lv {
                    switch _5 {
                        case 1:
                            TypeOfListView := 1
                        case 2:
                            IdRow := 4
                            ParentMap := 3
                        case 3:
                            ParentMap := 2
                    }
                }
            }
        }
        
        OutputDebug("`n" TypeOfListView ":" IdRow ":" ParentMap)
        SelectedID := Lv.GetText(RowNum, IdRow)
        UpwardSelections[ParentMap][TypeOfListView] := SelectedID

        SelectionText.Text := Lv.GetText(RowNum, 1)
        ConfirmButton.Enabled := true
    }

    _ListView.OnEvent("DoubleClick", MinorFunctionOne)

}

Create_ADD_REMOVE_CLONE_ActionUIS(UM_UM, UM_UAA, UM_UEA, BaseStuff) {
    Names := ["Add [X]", "Remove [X]", "Clone [X]"]
    UITypes := ["Unit", "Unit Action", "Unit Event"]
    ListViewObjects := [["Unit", "Slot"],["Unit", "Action"],["Unit", "Action", "IsLooped"]]

    MajorComplex := []

    for _1, UhhMap_Specific in [UM_UM, UM_UAA, UM_UEA] {
        AddUI := Gui(,"Additive UI")
        RemoveUI := Gui(,"Removical UI")
        CloneUI := Gui(,"Clonitive UI")

        UiComplex := [
            {GUI:AddUI}, {GUI:RemoveUI}, {GUI:CloneUI}
        ]
        ListViewObjects[_1].Push("ID")

        for _2, UI in [AddUI, RemoveUI, CloneUI] {
            UI.AddText("w195 h30 Section", StrReplace(Names[_2], "[X]", UITypes[_1])).SetFont("bold s15 underline")

            if _2 != 1 {
                OutsideFunction(_1, _2, ListViewObjects, UI, Names, BaseStuff, UiComplex)
            }
        }

        switch _1 {
            case 1: ; Unit Map

                ; Additive UI
                ; Name
                AddUI.AddText("w45 h25 xs yp+30", "Name:").SetFont("s12")
                UiComplex[1].UnitName := AddUI.AddEdit("w75 h20 xp+90 yp vName", "Unit_" (UhhMap_Specific.Count + 1))

                ; Slot
                AddUI.AddText("w45 h25 xs yp+30", "Slot:").SetFont("s12")
                AddUI.AddEdit("Number w75 h20 xp+90 yp", 1)
                AddUI.AddUpDown("vSlotNumber")
            case 2: ; Unit Action
                ; Unit [Name]
                UnitArray := []
                for ID, IdObj in UM_UM {
                    UnitArray.Push(IdObj.Key)
                } 

                AddUI.AddText("w45 h25 xs yp+30", "Unit:").SetFont("s12")
                UiComplex[1].UnitDDL := AddUI.AddDDL("w95 h25 xp+90 yp vUnit r5", UnitArray)

                ; Action
                AddUI.AddText("w50 h25 xs yp+30", "Action:").SetFont("s12")
                UiComplex[1].ActionDDL := AddUI.AddDDL("w95 h25 xp+90 yp vAction r5", ["Placement", "Upgrade"])

                ; AddUI.Show()
            case 3: ; Unit Event
                ; Unit [Name]
                UnitArray := []
                for ID, IdObj in UM_UM {
                    UnitArray.Push(IdObj.Key)
                } 

                AddUI.AddText("w45 h25 xs yp+30", "Unit:").SetFont("s11")
                UiComplex[1].UnitDDL := AddUI.AddDDL("w95 h25 xp+90 yp vUnit r5", UnitArray)

                ; Action
                AddUI.AddText("w50 h25 xs yp+30", "Action:").SetFont("s11")
                AddUI.AddDDL("w95 h25 xp+90 yp vAction r5", ["Sell", "Target", "Ability"])

                ; AfterAction
                AddUI.AddText("w75 h25 xs yp+30", "AfterAction:").SetFont("s11")
                AddUI.AddEdit("Number w95 h20 xp+90 yp", 1)
                AddUI.AddUpDown("vAfterAction")

                ; IsLooped
                AddUI.AddText("w60 h25 xs yp+30", "IsLooped:").SetFont("s11")
                IsLoopedDDL := AddUI.AddDDL("w95 h25 xp+90 yp VIsLooped r5 choose2", ["True", "False"])

                ; LoopDelay
                AddUI.AddText("w75 h25 xs yp+30", "LoopDelay:").SetFont("s11")
                LoopDelayEdit := AddUI.AddEdit("Number w95 h20 xp+90 yp", 1)
                AddUI.AddUpDown("vLoopDelay")

                EnableLoopCheck() {
                    if IsLoopedDDL.Value = 1 {
                        LoopDelayEdit.Enabled := true
                        return
                    }
                    
                    LoopDelayEdit.Enabled := false
                }
                EnableLoopCheck()

                IsLoopedDDL.OnEvent("Change", (*) => EnableLoopCheck())
        }

        AddButtonSizes := [70, 110, 110]
        AddButton := AddUI.AddButton("xs yp+35 w" AddButtonSizes[_1] " h25","Add " UITypes[_1])
        AddButton.SetFont("s11")
        
        UiComplex[1].ConfirmButton := AddButton
        MajorComplex.Push(UiComplex)
    }

    return MajorComplex
}

OutsideFunction_2(NumberID, MainUIs, ButtonObject, SettingMaps, RedoFunc) {
    ButtonObject.AddButton.OnEvent("Click", (*) => MainUIs[NumberID][1].Gui.Show())
    ButtonObject.RemoveButton.OnEvent("Click", (*) => MainUIs[NumberID][2].Gui.Show())
    ButtonObject.CloneButton.OnEvent("Click", (*) => MainUIs[NumberID][3].Gui.Show())

    MainUIs[NumberID][1].ConfirmButton.OnEvent("Click", (*) => _ActionAdditive(NumberID, MainUIs[NumberID][1].Gui, SettingMaps, RedoFunc))
    MainUIs[NumberID][2].ConfirmButton.OnEvent("Click", (*) => _ActionRemovical(NumberID, MainUIs[NumberID][1].Gui, SettingMaps, RedoFunc))
    MainUIs[NumberID][3].ConfirmButton.OnEvent("Click", (*) => _ActionClonical(NumberID, MainUIs[NumberID][1].Gui, SettingMaps, RedoFunc))
}

_ActionAdditive(NumberID := 1, UI := Gui(), SettingMaps := [], RedoFunc := 1) {
    FinalizedValues := UI.Submit(false)

    _UnitMap := SettingMaps[1]
    _UnitActionArray := SettingMaps[2]
    _UnitEventArray := SettingMaps[3]

    switch NumberID {
        case 1:
            SlotNumber := FinalizedValues.SlotNumber
            UnitName := FinalizedValues.Name

            if _UnitMap.Has(UnitName) {
                MsgBox("Unit With Name Already Exists")
                return
            }

            if UnitName = "" {
                return
            }

            _UnitMap[UnitName] := {Slot:SlotNumber, Pos:[1,1], MovementFromSpawn:[], UnitData:[], IsPlaced:false}
        case 2:
            ChosenUnit := FinalizedValues.Unit
            Action := FinalizedValues.Action

            if ChosenUnit = "" or Action = "" {
                return
            }

            _UnitActionArray.Push({Unit:ChosenUnit, Action:Action, ActionCompleted:false})
        case 3:
            ChosenUnit := FinalizedValues.Unit
            Action := FinalizedValues.Action
            AfterAction := FinalizedValues.AfterAction
            IsLooped := FinalizedValues.IsLooped
            LoopDelay := FinalizedValues.LoopDelay

            for _, Val in [ChosenUnit, Action, AfterAction, IsLooped, LoopDelay] {
                if Val = "" {
                    return
                }
            }
            
            _UnitEventArray.Push({Unit:ChosenUnit, AfterAction:AfterAction, Action:Action, IsLooped:(Map("True", true, "False", false)[IsLooped]), LoopDelay:LoopDelay, LastDelay:0})
    }

    UI.Hide()
    RedoFunc()
}

_ActionRemovical(NumberID := 1, UI := Gui(), SettingMaps := [], RedoFunc := 1) {
    global OpenUIID
    RemovicalID := UpwardSelections[NumberID][1]
    ChosenMap := SettingMaps[NumberID]

    for I, V in ChosenMap {
        if V.ID = RemovicalID {
            if V.HasOwnProp("UI") {
                if I = OpenUIID {
                    OpenUIID := ""
                }
                V.UI.GUI.Destroy()
            }

            if NumberID = 1 {
                ChosenMap.Delete(I)
                break
            }

            ChosenMap.RemoveAt(I)
            break
        }
    }

    RedoFunc()
}

_ActionClonical(NumberID := 1, UI := Gui(), SettingMaps := [], RedoFunc := 1) {
    ClonicalID := UpwardSelections[NumberID][2]
    ChosenMap := SettingMaps[NumberID]

    for I, V in ChosenMap {
        if V.ID = ClonicalID {
            Cloned := SwitchCheck(V)

            if NumberID = 1 {
                ChosenMap["Unit_" ChosenMap.Count + 1] := Cloned
                break
            }

            ChosenMap.Push(Cloned)
            break
        }
    }

    RedoFunc()
}

CreateActionUnitUI(_MapOBJFalse, BaseUI, PreviousObject := {}, ShowUI := true, VariablisticMap := Map()) {
    global __HeldUIs
    TrueObject := PreviousObject

    UnitUI := Gui()
    UhhMap_UM := Map()
    UhhMap_UAA := Map()
    UhhMap_UEA := Map()

    UIARRAY := []

    _MapOBJ := _MapOBJFalse.Map

    _UnitMap := _MapOBJ["UnitMap"]
    _UnitActionArray := _MapObj["UnitActionArray"]
    _UnitEventArray := _MapObj["UnitEventArray"]

    __Buttons := [{}, {}, {}]

    UnitUI.AddText("w200 h25 Section", "Unit Settings").SetFont("s14 w700")
    Unit_Map_LV := UnitUI.AddListView("r15 LV0x10 Hdr ReadOnly ys+50 xs w115", ["Unit", "Slot", "ID"])
    Unit_Action_LV := UnitUI.AddListView("r15 LV0x10 Hdr ReadOnly w175 yp xp+125", ["Unit", "Action", "ID"])
    Unit_Event_LV := UnitUI.AddListView("r15 LV0x10 Hdr ReadOnly w215 yp xp+185", ["Unit", "Action", "IsLooped", "ID"])

    UnitUI.AddText("w200 h25 xs ys+25", "Units").SetFont("s12 w700 underline")
    UnitUI.AddText("w200 h25 xs+125 ys+25", "Unit Actions").SetFont("s12 w700 underline")
    UnitUI.AddText("w200 h25 xp+185 ys+25", "Unit Events").SetFont("s12 w700 underline")


    for _, UI in [Unit_Map_LV, Unit_Action_LV, Unit_Event_LV] {
        UI.GetPos(&XPos, &YPos, &Width, &Height)

        HeightPosition := (YPos + Height + 2)

        AddButton := UnitUI.AddButton("w25 h25 x" (XPos) " y" HeightPosition, "+")
        RemoveButton := UnitUI.AddButton("w25 h25 x" (XPos + 25) " y" HeightPosition, "-")
        CloneButton := UnitUI.AddButton("w25 h25 x" (XPos + 50) " y" HeightPosition, "C")

        AddButton.SetFont("s12", "Tahoma")
        RemoveButton.SetFont("s12", "Tahoma")
        CloneButton.SetFont("s12", "Tahoma")

        __Buttons[_].AddButton := AddButton
        __Buttons[_].RemoveButton := RemoveButton
        __Buttons[_].CloneButton := CloneButton
    }

    UnitMap_ListViewFunc() {
        global _UnitMap_ListViewNumber

        for UnitMapKey, UnitObject in _UnitMap {
            if not UnitObject.HasOwnProp("ID") {
                _UnitMap_ListViewNumber++
                UnitObject.ID := _UnitMap_ListViewNumber
            }

            Unit_Map_LV.Add(, UnitMapKey, UnitObject.Slot, "ID:" UnitObject.ID)
            UhhMap_UM["ID:" UnitObject.ID] := {Key:UnitMapKey, Row:_UnitMap_ListViewNumber, Slot:UnitObject.Slot}
        }
    }

    UnitActionArray_ListViewFunc() {
        global _UnitActionArray_ListViewNumber

        for _, UnitObject in _UnitActionArray {
            if not UnitObject.HasOwnProp("ID") {
                _UnitActionArray_ListViewNumber++
                UnitObject.ID := _UnitActionArray_ListViewNumber
            }

            Unit_Action_LV.Add(, UnitObject.Unit, UnitObject.Action, "ID:" UnitObject.ID)
            UhhMap_UAA["ID:" UnitObject.ID] := {Key:_, Row:_UnitActionArray_ListViewNumber}
        }
    }

    UnitEventArray_ListViewFunc() {
        TempInfo := ["False", "True"]

        global _UnitEventArray_ListViewNumber

        for _, UnitObject in _UnitEventArray {
            if not UnitObject.HasOwnProp("ID") {
                _UnitEventArray_ListViewNumber++
                UnitObject.ID := _UnitEventArray_ListViewNumber
            }

            Unit_Event_LV.Add(, UnitObject.Unit, UnitObject.Action, TempInfo[UnitObject.IsLooped + 1], "ID:" UnitObject.ID)
            UhhMap_UEA["ID:" UnitObject.ID] := {Key:_, Row:_UnitEventArray_ListViewNumber}
        }
    }
    
    UnitMap_ListViewFunc()
    UnitActionArray_ListViewFunc()
    UnitEventArray_ListViewFunc()

    Unit_Map_LV.ModifyCol(1,80)
    Unit_Map_LV.ModifyCol(2,"Center 30")
    Unit_Map_LV.ModifyCol(3,"0")
    Unit_Action_LV.ModifyCol(1,80)
    Unit_Action_LV.ModifyCol(2,70)
    Unit_Action_LV.ModifyCol(3,0)
    Unit_Event_LV.ModifyCol(1,80)
    Unit_Event_LV.ModifyCol(2,70)
    Unit_Event_LV.ModifyCol(3,60)
    Unit_Event_LV.ModifyCol(4,0)

    ShowGuiRight(TheGui) {
        UnitUI.GetPos(&x1, &x2, &x3, &x4)
        TheGui.Show("X" x1 + x3 " Y" x2)
    }

    ; [
    ;     [{Additive}, {Removal}, {Clone}],
    ;     [{Additive}, {Removal}, {Clone}],
    ;     [{Additive}, {Removal}, {Clone}],
    ; ] EACH HAS .ConfirmButton & .GUI
    MainUIs := Create_ADD_REMOVE_CLONE_ActionUIS(UhhMap_UM, UhhMap_UAA, UhhMap_UEA, [_UnitMap, _UnitActionArray, _UnitEventArray])

    for _2, ButtonObject in __Buttons {
        OutsideFunction_2(_2, MainUIs, ButtonObject, [_UnitMap, _UnitActionArray, _UnitEventArray], RedoLists)
    }

    RdClean(*) {
        global OpenUI
        global OpenUIID

        try {
            if OpenUI != "" {
                OpenUI.Hide()
                OpenUIID := ""
                OpenUI := ""
            }
        }

        RedoLists()
    }

    RedoLists() {
        for _, ListView in [Unit_Map_LV, Unit_Action_LV, Unit_Event_LV] {
            loop 250 {
                ListView.Delete(251-A_Index)
            }
        }

        UnitMap_ListViewFunc()
        UnitActionArray_ListViewFunc()
        UnitEventArray_ListViewFunc()

        UpdatedUnitArray := []
        for ID, IdObj in _UnitMap {
            UpdatedUnitArray.Push(ID)
        }

        for _, DDL in [MainUIs[2][1].UnitDDL, MainUIs[3][1].UnitDDL] {
            DDL.Delete()
            DDL.Add(UpdatedUnitArray)
        }

        MainUIs[1][1].UnitName.Text := "Unit_" UpdatedUnitArray.Length + 1

        for _5, ObjectArray in MainUIs {
            ListViewRemoval := ObjectArray[2].ListView
            ListViewClone := ObjectArray[3].ListView

            ObjectArray[2].SelectionText.Text := "[None]"
            ObjectArray[3].SelectionText.Text := "[None]"
            ObjectArray[2].ConfirmButton.Enabled := false
            ObjectArray[3].ConfirmButton.Enabled := false

            for _, ListView in [ListViewRemoval, ListViewClone] {
                loop 250 {
                    ListView.Delete(251-A_Index)
                }
            }

            for _3, DataObj in [_UnitMap, _UnitActionArray, _UnitEventArray][_5] {
                switch _5 {
                    case 1:
                        ListViewClone.Add(, _3, DataObj.Slot, DataObj.ID)
                        ListViewRemoval.Add(, _3, DataObj.Slot, DataObj.ID)
                    case 2:
                        ListViewClone.Add(, DataObj.Unit, DataObj.Action, DataObj.ID)
                        ListViewRemoval.Add(, DataObj.Unit, DataObj.Action, DataObj.ID)
                    case 3:
                        ; OutputDebug(DataObj.IsLooped)
                        ListViewClone.Add(, DataObj.Unit, DataObj.Action, DataObj.IsLooped, DataObj.ID)
                        ListViewRemoval.Add(, DataObj.Unit, DataObj.Action, DataObj.IsLooped, DataObj.ID)
                }
            }
        }
    }

    Unit_Map_LV.OnEvent("DoubleClick", (Lv, RowNumber) => UIARRAY.Push(RevampCharacteristicUI(Lv, RowNumber, [_UnitMap, _UnitActionArray, _UnitEventArray], UhhMap_UM, TrueObject, RedoLists, UnitUI)))

    ShowFunction(*) {
        UnitUI.Show()
    }

    TrueObject.ShowFunction := ShowFunction
    TrueObject.UI := UnitUI
    TrueObject.Button.OnEvent("Click", ShowFunction, true)
    TrueObject.RefreshFunc := RdClean

    UIs := [UnitUI]

    for _, _Array in MainUIs {
        for _2, Obj in _Array {
            UIs.Push(Obj.GUI)
        }
    }

    for _, UI in UIs {
        __HeldUIs["UID" PreviousObject.UID].Push(UI)
    }

    return TrueObject
}

global EasyUI_Debug_Items := Map()
global EasyUI_Debug_Items_Order := []
global EasyUI_CurrentWindowInformation := ["",false,[0,0], false]
global DebugEnabled := false
global __DebugGUI := ""

CreateDebugGui() {
    global __DebugGUI

    __DebugGUI := Gui("-SysMenu -Caption -Border +Disabled","EASY_UI_DEBUG_WINDOW")
    TextUI := __DebugGUI.AddText("x20 y5 h20 w400 Center", "EasyUI Debug Window | F5 To Close")
    TextUI.SetFont("s12")
    __DebugGUI.BackColor := "0xffffff"
}

AttachToWindow_MovementFunction() {
    global __DebugGUI

    try {
        if not WinExist("ahk_id " EasyUI_CurrentWindowInformation[1]) {
            Sleep(200)
            return
        }
    
        if WinGetMinMax("ahk_id " EasyUI_CurrentWindowInformation[1]) = -1  or not DebugEnabled {
            Sleep(100)
    
            if not EasyUI_CurrentWindowInformation[4] {
                __DebugGUI.Hide()
                EasyUI_CurrentWindowInformation[4] := true
            }
    
            return
        }
    
        global EasyUI_CurrentWindowInformation
    
        WinGetClientPos(&W_ClientPosX, &W_ClientPosY, &W_ClientSizeX, &W_ClientSizeY, "ahk_id " EasyUI_CurrentWindowInformation[1])
        WinGetPos(&W_PosX, &W_PosY, &W_SizeX, &W_SizeY, "ahk_id " EasyUI_CurrentWindowInformation[1])
        __DebugGUI.GetPos(&G_PosX, &G_PosY, &G_SizeX, &G_SizeY)
    
        PlacementArray := [W_PosX + W_ClientSizeX, W_PosY]
        for _Num, OffetAmount in EasyUI_CurrentWindowInformation[3] {
            if _Num <= 2 {
                PlacementArray[_Num] += OffetAmount
            }
        }
    
        __DebugGUI.Show("X" PlacementArray[1] " Y" PlacementArray[2] " H" W_SizeY - 9 " W" 435 " NoActivate")
        EasyUI_CurrentWindowInformation[4] := false
    }
}

AttachToWindow(WinId, OffsetArray := []) {
    global EasyUI_CurrentWindowInformation
    global __DebugGUI

    if not WinExist("ahk_id " WinId) {
        return
    }

    if not EasyUI_CurrentWindowInformation[1] = WinId {
        __DebugGUI.Opt("+Owner" WinId)
        EasyUI_CurrentWindowInformation[1] := WinId
    }

    tempArray := [0,0]
    if OffsetArray.Length <= 2 {
        for _Num, OffsetAmount in OffsetArray {
            if _Num <= 2 {
                tempArray[_Num] += OffsetAmount
            }
        }
    }

    EasyUI_CurrentWindowInformation[3] := tempArray

    if not EasyUI_CurrentWindowInformation[2] {
        EasyUI_CurrentWindowInformation[2] := true

        SetTimer(AttachToWindow_MovementFunction, 1)
    }
}

global _DebugItemTypeMap := Map(
    "Text", CreateDebugItem_Text
)

/**
 * {Name:"", Type:"", Data:""}\
 */
CreateDebugItems(Items := []) {
    global EasyUI_Debug_Items_Order
    global EasyUI_Debug_Items
    global __DebugGUI

    XArray := [10, 115, 220, 325]
    YArray := [30, 135, 240, 345, 450, 555]
    PreviouslyExistingItems := EasyUI_Debug_Items_Order.Length

    for _ItemArrayNum, ItemObject in Items {
        Sleep(100)
        ExistingItems := _ItemArrayNum + PreviouslyExistingItems

        Base_X_Number := XArray[ExistingItems - (4 * Max((Ceil(ExistingItems/4) - 1), 0))]
        Base_Y_Number := YArray[Ceil(ExistingItems/4)]

        OutputDebug(Base_Y_Number)
        if _DebugItemTypeMap.Has(ItemObject.Type) {
            GuiObjectArray := _DebugItemTypeMap[ItemObject.Type]([Base_X_Number, Base_Y_Number], ItemObject.Data)

            EasyUI_Debug_Items[ItemObject.Name] := GuiObjectArray
            EasyUI_Debug_Items_Order.Push(ItemObject.Name)
        }
    }
}

CreateDebugItem_Text(Offset := [], Data := {}) {
    global __DebugGUI
    TextArray := []

    Border := __DebugGUI.AddGroupBox("w104 h110 X" Offset[1]-2  " Y" Offset[2]-8)

    loop Data.Amount {
        Height := Floor(100/Data.Amount)

        NewText := __DebugGUI.AddText("w100 h" Height " X" Offset[1] " Y" Offset[2] + (Height * (A_Index - 1)), "")
        OutputDebug(Offset[2])

        if Data.HasOwnProp("" A_Index) {
            TextData := Data.%A_Index%
            NewText.Text := TextData.Text
            NewText.SetFont(TextData.Font)
            NewText.Opt(TextData.Opt)
        }

        TextArray.Push(NewText)
    }

    return TextArray
}

DebugBasicInfo() {
    AutohotkeyVersion := {
        Name:"ahk_Version", 
        Type:"Text", 
        Data:{
            Amount:6,
            3:{Opt:"Center", Font:"s11", Text:"AHK Version"},
            4:{Opt:"Center", Font:"s12", Text:"v" A_AhkVersion},
        }
    }

    ResolutionInfo := {
        Name:"res_info", 
        Type:"Text", 
        Data:{
            Amount:6,
            3:{Opt:"Center", Font:"s11", Text:"Resolution"},
            4:{Opt:"Center", Font:"s12", Text:A_ScreenWidth "x" A_ScreenHeight},
        }
    }
    
    DPIInfo := {
        Name:"dpi_info", 
        Type:"Text", 
        Data:{
            Amount:5,
            2:{Opt:"Center", Font:"s13", Text:"DPI"},
            3:{Opt:"Center", Font:"s12", Text:A_ScreenDPI},
            4:{Opt:"Center", Font:"s11", Text:"(" (A_ScreenDPI / 96) * 100 "%)"},
        }
    }
    
    RobloxWindow := {
        Name:"rblx_win", 
        Type:"Text", 
        Data:{
            Amount:5,
            1:{Opt:"", Font:"s11", Text:"Roblox Window:"},
            2:{Opt:"", Font:"s11", Text:"Pos[X]:"},
            3:{Opt:"", Font:"s11", Text:"Pos[Y]:"},
            4:{Opt:"", Font:"s11", Text:"Size[X]:"},
            5:{Opt:"", Font:"s11", Text:"Size[Y]:"},
        }
    }
    

    CreateDebugItems([AutohotkeyVersion, ResolutionInfo, DPIInfo, RobloxWindow])
    BasicDebugLoop() {
        global EasyUI_Debug_Items

        Roblox_Window_Gui_Array := EasyUI_Debug_Items["rblx_win"]
        DPI_Gui_Array := EasyUI_Debug_Items["dpi_info"]
        Resoultion_Gui_Array := EasyUI_Debug_Items["res_info"]

        try {
            if WinExist("ahk_exe RobloxPlayerBeta.exe") {
                WinGetPos(&X, &Y, &W, &H, "ahk_exe RobloxPlayerBeta.exe")
    
                Roblox_Window_Gui_Array[2].Text := "Pos[X]: " X
                Roblox_Window_Gui_Array[3].Text := "Pos[Y]: " Y
                Roblox_Window_Gui_Array[4].Text := "Size[X]: " W
                Roblox_Window_Gui_Array[5].Text := "Size[Y]: " H
            }
        }

        Resoultion_Gui_Array[4].Text := A_ScreenWidth "x" A_ScreenHeight
        DPI_Gui_Array[3].Text := A_ScreenDPI
        DPI_Gui_Array[4].Text := "(" (A_ScreenDPI / 96) * 100 "%)"
    }

    SetTimer(BasicDebugLoop, 100)
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
