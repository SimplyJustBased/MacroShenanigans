; /[V1.1.11]\
#Requires AutoHotkey v2.0 

global Macro_Hub_Version := "1.0.4"
global InformativeUI := Gui("-SysMenu -Caption +AlwaysOnTop",)

global FolderPlace := A_MyDocuments
global FolderCheck := [
    "MacroHubFiles",
    "MacroHubFiles\MacroFolders",
    "MacroHubFiles\Modules",
    "MacroHubFiles\SavedSettings",
    "MacroHubFiles\Storage",
    "MacroHubFiles\Storage\Fonts",
    "MacroHubFiles\Storage\Images",
    "MacroHubFiles\Storage\Debug",
    "MacroHubFiles\Storage\Extras"
]

global StorageDownloads := [
    {Path:"MacroHubFiles\Storage\Fonts", FileName:"F_One.ttf", Link:"https://github.com/SimplyJustBased/MacroShenanigans/raw/main/Fonts/F_One.ttf"},
    {Path:"MacroHubFiles\Storage\Fonts", FileName:"T_NR.ttf", Link:"https://github.com/SimplyJustBased/MacroShenanigans/raw/main/Fonts/T_NR.ttf"},
]

global GameObj := Map()
global LoadedGame := ""
global MacroPages := Map()
global CurrentPage := 1
global SavedPage := -1
global SavedNumber := -1
global UI_Holder := []
global DonateUI := Gui()

InformativeUI.SetFont("s15")
InfoText := InformativeUI.Add("Text","w600 Center","")


ShowInfoText(Text := "Base_text_here") {
    InfoText.Text := Text
    InfoText.Redraw()

    InformativeUI.Show()
}

HideInfoText() {
    InformativeUI.Hide()
}

GameObjAddTo(Game, MacroName := "", Status := "", Description := "No Description", Version := "V1", Color := "000000", MacroStatus := 4, RequiredModules := [], Video := "X", FileEnd := ".ahk") {
    if not GameObj.Has(Game) {
        GameObj[Game] := {Macros:[], IsContinued:true}
    }

    GameObj[Game].Macros.Push(
        {Name:MacroName, Status:Status, StatusColor:Color, MacroStatus:MacroStatus, RequiredModules:RequiredModules, Description:Description, Version:Version, SelfValues:{ObtainedValues:false}, Video:Video, FileEnd:FileEnd, Game:Game}
    )
}

GameChosen() {
    global LoadedGame
    global MacroPages
    global CurrentPage
    global SavedPage
    global SavedNumber

    ChosenGame := MacroHubGui.Submit(false).ChosenGame
    if  LoadedGame = ChosenGame {
        return
    }

    for _, Control in MacroInfoArray_1 {
        Control.Visible := false
    }
    
    MacroPages.Clear()
    LoadedGame := ChosenGame
    CurrentPage := 1
    SavedPage := -1
    SavedNumber := -1

    Game_RealObject := GameObj[ChosenGame]

    for _, Control in MacroInfoArray_2 {
        Control.Visible := true
    }

    for _1, MacroObject in Game_RealObject.Macros {
        if not MacroPages.Has("p_" (Ceil(_1/8))) {
            MacroPages["p_" Ceil(_1/8)] := []
        }

        ; OutputDebug("`nPage: " Ceil(_1/8) " | Macro: " MacroObject.Name)
        MacroPages["p_" Ceil(_1/8)].Push(MacroObject)
    }

    PageChanged()
}

; "Right" or "Left"
ChangePage(Direction := "Right") {
    global MacroPages
    global CurrentPage

    if MacroPages.Count <= 1 {
        return
    }

    switch Direction {
        case "Right":
            if (CurrentPage + 1) > MacroPages.Count {
                CurrentPage := 1
                PageChanged()
                return
            }

            CurrentPage += 1
            PageChanged()
        case "Left":
            if (CurrentPage - 1) <= 0 {
                CurrentPage := MacroPages.Count
                PageChanged()
                return
            }

            CurrentPage -= 1
            PageChanged()
    }
}

PageChanged() {
    global MacroPages
    global CurrentPage

    for _, MacroObject in MacroPages["p_" CurrentPage] {
        CorrespondingButton := MacroButtonArray[_]
        CorrespondingButton.Visible := true
        CorrespondingButton.Text := MacroObject.Name
    }

    if MacroPages["p_" CurrentPage].Length < 8 {
        for _1, Control in MacroButtonArray {
            if _1 > MacroPages["p_" CurrentPage].Length {
                Control.Visible := false
            }
        }
    }

    MacroHub_PageNumber.Text := CurrentPage "/" MacroPages.Count
}

GoodTimeDiff(IsoTime) {
    Reformatted := ""

    Split1 := StrSplit(IsoTime, "T")
    Split2 := StrSplit(Split1[1], "-")
    Reformatted := Split2[1] Split2[2] Split2[3]

    Split3 := StrSplit(Split1[2], "Z")
    Split4 := StrSplit(Split3[1], ":")
    Reformatted := Reformatted Split4[1] Split4[2] Split4[3]

    if DateDiff(A_NowUTC, Reformatted, "Days") > 0 {
        return {Time:DateDiff(A_NowUTC, Reformatted, "Days"), Word:"Day(s)"}
    } else if DateDiff(A_NowUTC, Reformatted, "Hours") > 0 {
        return {Time:DateDiff(A_NowUTC, Reformatted, "Hours"), Word:"Hour(s)"}
    } else if DateDiff(A_NowUTC, Reformatted, "Minutes") > 0 {
        return {Time:DateDiff(A_NowUTC, Reformatted, "Minutes"), Word:"Minute(s)"}
    }

    return {Time:"A Couple", Word:"Seconds"}
}

BindMacroInformation(MacroObj) {
    MLArray := MacroObj.SelfValues.ModuleLinks := []
    MacroObj.SelfValues.MacroLink := "https://raw.githubusercontent.com/SimplyJustBased/MacroShenanigans/main/Macros/" MacroObj.Name MacroObj.FileEnd

    for _, ModuleName in MacroObj.RequiredModules {
        MLArray.Push({Link:"https://raw.githubusercontent.com/SimplyJustBased/MacroShenanigans/main/Modules/" ModuleName ".ahk", Name:ModuleName})
    }

    try {
        APILink := "https://api.github.com/repos/SimplyJustBased/MacroShenanigans/commits?path=Macros/" MacroObj.Name MacroObj.FileEnd "&page=1&per_page=25"
        APIDownload := ComObject("WinHttp.WinHttpRequest.5.1")
        APIDownload.Open("GET", APILink, true)
        APIDownload.Send()
        APIDownload.WaitForResponse()
        
        ReturnedJsonText := APIDownload.ResponseText
        MacroObj.SelfValues.MainMapInformation := Jxon_Load(&ReturnedJsonText)
        TimeRecollection := GoodTimeDiff(MacroObj.SelfValues.MainMapInformation[1]["commit"]["author"]["date"])
        MacroObj.SelfValues.LastUpdated := TimeRecollection.Time " " TimeRecollection.Word " Ago"
        CLArray := MacroObj.SelfValues.ChangeLogsArray := []
    
        loop {
            if MacroObj.SelfValues.MainMapInformation.Has(A_Index) {
                CLArray.Push({Time:GoodTimeDiff(MacroObj.SelfValues.MainMapInformation[A_Index]["commit"]["author"]["date"]), Change:MacroObj.SelfValues.MainMapInformation[A_Index]["commit"]["message"]})
            } else {
                break
            }
        }
    } catch as E {
        MacroObj.SelfValues.LastUpdated := "[Failed]"
    }
}

MacroButtonClicked(ButtonNumber) {
    global CurrentPage 
    global SavedPage
    global SavedNumber

    if SavedPage = CurrentPage and SavedNumber = ButtonNumber {
        return
    }

    SavedPage := CurrentPage
    SavedNumber := ButtonNumber

    MacroObject := GameObj[LoadedGame].Macros[((CurrentPage * 8)-8) + ButtonNumber]
    
    MacroHub_MacroName.Text := MacroObject.Name
    MacroHub_MacroVersion.Text := MacroObject.Version
    MacroHub_MacroDescription.Text := MacroObject.Description
    MacroHub_MacroStatus.Text := MacroObject.Status
    MacroHub_MacroStatus.SetFont("s11 c" MacroObject.StatusColor, "Tahoma")
    
    if MacroObject.SelfValues.ObtainedValues {
        MacroHub_MacroLastUpdated.Text := MacroObject.SelfValues.LastUpdated
        MacroHub_MacroChangeLog.Enabled := true
    } else {
        MacroHub_MacroLastUpdated.Text := "[Getting Last Update Time]"
        MacroHub_MacroChangeLog.Enabled := false
    }

    switch MacroObject.MacroStatus {
        case 1:
            MacroHub_RunMacro.Enabled := true
            MacroHub_RunMacro.Text := "Run Macro"
        case 2:
            MacroHub_RunMacro.Enabled := false
            MacroHub_RunMacro.Text := "Macro Disabled"
    }

    for _, Control in MacroInfoArray_1 {
        Control.Visible := true
    }

    if not MacroObject.SelfValues.ObtainedValues {
        BindMacroInformation(MacroObject)

        if SavedPage = CurrentPage and SavedNumber = ButtonNumber {
            MacroHub_MacroLastUpdated.Text := MacroObject.SelfValues.LastUpdated
            
            if not MacroObject.SelfValues.LastUpdated = "[Failed]" {
                MacroHub_MacroChangeLog.Enabled := true
            }
        }

        MacroObject.SelfValues.ObtainedValues := true
    }
}

RunMacroButtonClicked() {
    global SavedPage
    global SavedNumber

    MacroObject := GameObj[LoadedGame].Macros[SavedPage * SavedNumber]

    if not MacroObject.SelfValues.MacroLink {
        MsgBox(
            "Error[12] | No Macro Link Set",
            "Error",
            "0x30"
        )
        return
    }

    MacroRaw := ""
    try {
        MacroDownload := ComObject("WinHttp.WinHttpRequest.5.1")
        MacroDownload.Open("GET", MacroObject.SelfValues.MacroLink, true)
        MacroDownload.Send()
        MacroDownload.WaitForResponse()

        MacroRaw := MacroDownload.ResponseText
    } catch as E {
        MsgBox(
            "Error[10] | Failure Downloading Raw Macro Text | " E.Message,
            "Error",
            "0x30"
        )
    }

    MacroFilePath := MacroObject.SelfValues.FilePath := FolderPlace "\MacroHubFiles\MacroFolders\" MacroObject.Game "\" MacroObject.Name MacroObject.FileEnd

    if FileExist(MacroFilePath) {
        DifferenceCheckObj := VersionCheck(MacroFilePath, MacroRaw)

        if DifferenceCheckObj.R {
            switch MsgBox(
                "There is a difference inbetween macro versions.`nYour Version: " DifferenceCheckObj.Main "`nGitHub Version: " DifferenceCheckObj.Secondary "`nWould you like to update your version?",
                "Macro Update", 
                "0x1032 0x4"
            ) {
                case "Yes":
                    FileDelete(MacroFilePath)
                    FileAppend(MacroRaw, MacroFilePath, "UTF-8-RAW")
    
                    RunMacro(MacroObject)
                default:
                    RunMacro(MacroObject)
            }

            return
        }

        RunMacro(MacroObject)
    } else {
        switch MsgBox("It seems you currently don't have this macro (" MacroObject.Name ") installed, would you like to install it?", "Macro Installation", "0x1032 0x4") {
            case "Yes":
                FileAppend(MacroRaw, MacroFilePath, "UTF-8-RAW")
                
                switch MsgBox("Macro has been installed, would you like to run it?", "Macro Installation", "0x1040 0x4") {
                    case "Yes":
                        RunMacro(MacroObject)
                }
        }
    }
}

RunMacro(MacroObject) {
    global UI_Holder

    try {
        for _, UI in UI_Holder {
            UI.Hide()
        }
    }

    ShowInfoText("Checking / Downloading Modules | If this gets stuck, Hit F8")

    try {
        for _, ModuleObject in MacroObject.SelfValues.ModuleLinks {
            ModuleDownload := ComObject("WinHttp.WinHttpRequest.5.1")
            ModuleDownload.Open("GET", ModuleObject.Link, true)
            ModuleDownload.Send()
            ModuleDownload.WaitForResponse()

            if FileExist(FolderPlace "\MacroHubFiles\Modules\" ModuleObject.Name ".ahk") {
                FileDelete(FolderPlace "\MacroHubFiles\Modules\" ModuleObject.Name ".ahk")
            }

            FileAppend(ModuleDownload.ResponseText, (FolderPlace "\MacroHubFiles\Modules\" ModuleObject.Name ".ahk"))
        }
    } catch as E {
        MsgBox(
            "Error[11] | Failure Downloading Raw Module Text | " E.Message,
            "Error",
            "0x30"
        )

        HideInfoText()
        MacroHubGui.Show()
    }

    HideInfoText()
    Run(MacroObject.SelfValues.FilePath)
    ExitApp()
}

VersionCheck(FileMain, ResponseText) {
    FileText := FileRead(FileMain)
    MainFileVersionTag := StrSplit(StrSplit(FileText, "]\")[1], "/[")[2]
    SecondaryFileVersionTag := StrSplit(StrSplit(ResponseText, "]\")[1], "/[")[2]

    if MainFileVersionTag = SecondaryFileVersionTag {
        return {R:false, Main:MainFileVersionTag, Secondary:SecondaryFileVersionTag}
    } else {
        return {R:true, Main:MainFileVersionTag, Secondary:SecondaryFileVersionTag}
    }
}

OpenChangelogsButtonClicked() {
    global CurrentPage 
    global SavedPage
    global SavedNumber
    global UI_Holder

    ChangeLogPages := Map()

    CurrentChangeLogPage := 1

    La := ""
    Ra := ""
    Pn := ""

    MacroObject := GameObj[LoadedGame].Macros[((SavedPage * 8)-8) + SavedNumber]

    for _1, ChangeObject in MacroObject.SelfValues.ChangeLogsArray {
        if not ChangeLogPages.Has("p_" (Ceil(_1/5))) {
            ChangeLogPages["p_" Ceil(_1/5)] := []
        }

        ChangeLogPages["p_" Ceil(_1/5)].Push(ChangeObject)
    }

    ChangeLogUI := ""

    if not MacroObject.SelfValues.HasOwnProp("ChangelogUI") {
        ChangeLogUI := Gui("")
        ChangeLogUI.BackColor := "ffffff"
        ChangeLogUI.AddText("w250 h35 x0 y8 +Center", "Change Logs").SetFont("s16 bold underline q4", "Tahoma")
        AbsoluteY := 35
        UnknownArray1 := []
    
        loop Min(MacroObject.SelfValues.ChangeLogsArray.Length, 5) {
            D1 := ChangeLogUI.AddText("w230 h25 x10 y" (8 + AbsoluteY), "[Change Date]")
            D1.SetFont("s14 bold underline q4", "Tahoma")
            AbsoluteY += 30
    
            D2 := ChangeLogUI.AddText("w230 h65 x10 Wrap y" (8 + AbsoluteY), "[Change Description]")
            D2.SetFont("s10")
            AbsoluteY += 70
    
            UnknownArray1.Push({Title:D1, Description:D2})
            
            D1.Visible := false
            D2.Visible := false
        }
    
        PageChanged_ChangeLogs() {
            for _, ChangeObject in ChangeLogPages["p_" CurrentChangeLogPage] {
                CorrespondingChangeLogObject := UnknownArray1[_]
                CorrespondingChangeLogObject.Title.Visible := true
                CorrespondingChangeLogObject.Title.Text := ChangeObject.Time.Time " " ChangeObject.Time.Word " Ago"
                CorrespondingChangeLogObject.Description.Visible := true
                CorrespondingChangeLogObject.Description.Text := ChangeObject.Change
            }
        
            if ChangeLogPages["p_" CurrentChangeLogPage].Length < Min(MacroObject.SelfValues.ChangeLogsArray.Length, 5) {
                for _1, ChangeLogObject in UnknownArray1 {
                    if _1 > ChangeLogPages["p_" CurrentChangeLogPage].Length {
                        ChangeLogObject.Title.Visible := false
                        ChangeLogObject.Description.Visible := false
                    }
                }
            }
    
            if MacroObject.SelfValues.ChangeLogsArray.Length > 5 {
                Pn.Text := CurrentChangeLogPage "/" ChangeLogPages.Count
            }
        }
    
        ChangePage_ChangeLogs(Direction := "Right") {
            if ChangeLogPages.Count <= 1 {
                return
            }
        
            switch Direction {
                case "Right":
                    if (CurrentChangeLogPage + 1) > ChangeLogPages.Count {
                        CurrentChangeLogPage := 1
                        PageChanged_ChangeLogs()
                        return
                    }
        
                    CurrentChangeLogPage += 1
                    PageChanged_ChangeLogs()
                case "Left":
                    if (CurrentChangeLogPage - 1) <= 0 {
                        CurrentChangeLogPage := ChangeLogPages.Count
                        PageChanged_ChangeLogs()
                        return
                    }
        
                    CurrentChangeLogPage -= 1
                    PageChanged_ChangeLogs()
            }
        }
    
        if MacroObject.SelfValues.ChangeLogsArray.Length > 5 {
            La := ChangeLogUI.AddButton("w25 x80 h25 y" (AbsoluteY + 8), "<")
            Ra := ChangeLogUI.AddButton("w25 x155 h25 y" (AbsoluteY + 8), ">")
            Pn := ChangeLogUI.AddText("w35 x112.5 h25 +Center y" (AbsoluteY + 8), "1/X")
    
            Ra.SetFont("bold s15")
            La.SetFont("bold s15")
            Pn.SetFont("bold s15")
    
            La.OnEvent("Click", (*) => ChangePage_ChangeLogs("Left"))
            Ra.OnEvent("Click", (*) => ChangePage_ChangeLogs("Right"))
        }
    
        PageChanged_ChangeLogs()
        MacroObject.SelfValues.ChangelogUI := ChangeLogUI
        UI_Holder.Push(ChangeLogUI)
    } else {
        ChangeLogUI := MacroObject.SelfValues.ChangelogUI
    }

    MacroHubGui.GetPos(&X1, &Y1, &X2, &Y2)
    ChangeLogUI.Show("X" X1 + X2 " Y" Y1)

}

OpenVideoButtonClicked() {
    global SavedPage
    global SavedNumber

    MacroObject := GameObj[LoadedGame].Macros[SavedPage * SavedNumber]

    if MacroObject.Video != "X" {
        Run("https://www.youtube.com/watch?v=" MacroObject.Video)
    }
}

Jxon_Load(&src, args*) {
	key := "", is_key := false
	stack := [ tree := [] ]
	next := '"{[01234567890-tfn'
	pos := 0
	
	while ( (ch := SubStr(src, ++pos, 1)) != "" ) {
		if InStr(" `t`n`r", ch)
			continue
		if !InStr(next, ch, true) {
			testArr := StrSplit(SubStr(src, 1, pos), "`n")
			
			ln := testArr.Length
			col := pos - InStr(src, "`n",, -(StrLen(src)-pos+1))

			msg := Format("{}: line {} col {} (char {})"
			,   (next == "")      ? ["Extra data", ch := SubStr(src, pos)][1]
			  : (next == "'")     ? "Unterminated string starting at"
			  : (next == "\")     ? "Invalid \escape"
			  : (next == ":")     ? "Expecting ':' delimiter"
			  : (next == '"')     ? "Expecting object key enclosed in double quotes"
			  : (next == '"}')    ? "Expecting object key enclosed in double quotes or object closing '}'"
			  : (next == ",}")    ? "Expecting ',' delimiter or object closing '}'"
			  : (next == ",]")    ? "Expecting ',' delimiter or array closing ']'"
			  : [ "Expecting JSON value(string, number, [true, false, null], object or array)"
			    , ch := SubStr(src, pos, (SubStr(src, pos)~="[\]\},\s]|$")-1) ][1]
			, ln, col, pos)

			throw Error(msg, -1, ch)
		}
		
		obj := stack[1]
        is_array := (obj is Array)
		
		if i := InStr("{[", ch) { ; start new object / map?
			val := (i = 1) ? Map() : Array()	; ahk v2
			
			is_array ? obj.Push(val) : obj[key] := val
			stack.InsertAt(1,val)
			
			next := '"' ((is_key := (ch == "{")) ? "}" : "{[]0123456789-tfn")
		} else if InStr("}]", ch) {
			stack.RemoveAt(1)
            next := (stack[1]==tree) ? "" : (stack[1] is Array) ? ",]" : ",}"
		} else if InStr(",:", ch) {
			is_key := (!is_array && ch == ",")
			next := is_key ? '"' : '"{[0123456789-tfn'
		} else { ; string | number | true | false | null
			if (ch == '"') { ; string
				i := pos
				while i := InStr(src, '"',, i+1) {
					val := StrReplace(SubStr(src, pos+1, i-pos-1), "\\", "\u005C")
					if (SubStr(val, -1) != "\")
						break
				}
				if !i ? (pos--, next := "'") : 0
					continue

				pos := i ; update pos

				val := StrReplace(val, "\/", "/")
				val := StrReplace(val, '\"', '"')
				, val := StrReplace(val, "\b", "`b")
				, val := StrReplace(val, "\f", "`f")
				, val := StrReplace(val, "\n", "`n")
				, val := StrReplace(val, "\r", "`r")
				, val := StrReplace(val, "\t", "`t")

				i := 0
				while i := InStr(val, "\",, i+1) {
					if (SubStr(val, i+1, 1) != "u") ? (pos -= StrLen(SubStr(val, i)), next := "\") : 0
						continue 2

					xxxx := Abs("0x" . SubStr(val, i+2, 4)) ; \uXXXX - JSON unicode escape sequence
					if (xxxx < 0x100)
						val := SubStr(val, 1, i-1) . Chr(xxxx) . SubStr(val, i+6)
				}
				
				if is_key {
					key := val, next := ":"
					continue
				}
			} else { ; number | true | false | null
				val := SubStr(src, pos, i := RegExMatch(src, "[\]\},\s]|$",, pos)-pos)
				
                if IsInteger(val)
                    val += 0
                else if IsFloat(val)
                    val += 0
                else if (val == "true" || val == "false")
                    val := (val == "true")
                else if (val == "null")
                    val := ""
                else if is_key {
                    pos--, next := "#"
                    continue
                }
				
				pos += i-1
			}
			
			is_array ? obj.Push(val) : obj[key] := val
			next := obj == tree ? "" : is_array ? ",]" : ",}"
		}
	}
	
	return tree[1]
}

CreateDonateUI() {
    global DonateUI 
    
    DonateUI.Add("Text", "Section w400 Center h30", "Donation Section").SetFont("s15 q5 w700")
    DonateUI.Add("Text", "xs yp+50 Wrap w400 h200", "(Please note that you dont have to donate, but it is very much appreciated)`n`nYou can send some via paypal with the button below`n(If you donate via paypal make sure to input your discord username so i can give you a role ❤️)").SetFont("s11 w700")

    OpenPaypalButton := DonateUI.Add("Button", " w140 h30 x140 y300", "Donate Via Paypal")
    OpenPaypalButton.SetFont("s11")
    OpenPaypalButton.OnEvent("Click", (*) => run("https://paypal.me/JeneneT"))
}

RandFunc_1(Num, Control) {
    Control.OnEvent("Click", (*) => MacroButtonClicked(Num))
}

; 009df2

GameObjAddTo("Pet Simulator 99", "DiceMerchantMacro", "Event | Discontinued", "No Description Provided", "V1", "430043", 2, ["EasyUI", "BasePositionsPS99", "UsefulFunctions", "UsefulFunctionsPS99"], "SZYsG4P2VWs")
GameObjAddTo("Pet Simulator 99", "MultiMacroV4", "Unstable | Unmaintained", "A all around afk grind macro with many features!", "V4", "ff4400", 1, ["EasyUI", "BasePositionsPS99", "UsefulFunctions", "UsefulFunctionsPS99"], "zju4zs9QQNc")
GameObjAddTo("Pet Simulator 99", "EventMultiMacroV4", "Disabled", "A MultiMacroV4 Port for the EventWorld.", "V1?", "black", 2, ["EasyUI", "BasePositionsPS99", "UsefulFunctions", "UsefulFunctionsPS99"], "KLkE6DMxtss")
GameObjAddTo("Pet Simulator 99", "TreeHouseMacroV2", "Unstable | Unmaintained", "A Macro for automating usage of secret keys in the Secret TreeHouse Zone!", "V2", "ff4400", 1, ["EasyUI", "BasePositionsPS99", "_JXON", "Router", "UWBOCRLib"], "9hHHg_fG36Q")
GameObjAddTo("Anime Vanguards", "AVIgrosMacro", "Stable", "A Macro for automating the farming of Secret unit Igros", "V1", "green", 1, ["EasyUI", "BasePositionsAV", "UsefulFunctions", "UsefulFunctionsAV", "UWBOCRLib"], "xwUe6zqHPTA")
; GameObjAddTo("Anime Vanguards", "AVIgrosEventMacro", "Broken", "A Macro for automating the limited time Igros boss event.", "V1", "red", 2, ["EasyUI", "BasePositionsAV", "UsefulFunctions", "UsefulFunctionsAV", "UWBOCRLib"], "23_S_cJxkDI")
GameObjAddTo("Anime Vanguards", "RengokuMacro", "Stable", "A Macro for automating Act 4.", "V1", "green", 1, ["EasyUI", "BasePositionsAV", "UsefulFunctions", "UsefulFunctionsAV", "UWBOCRLib"], "xwUe6zqHPTA")
GameObjAddTo("Anime Vanguards", "AVParagonic", "Broken", "A Macro for automating Paragons.", "V1", "red", 2, ["EasyUI", "BasePositionsAV", "UsefulFunctions", "UsefulFunctionsAV", "UWBOCRLib"], "xwUe6zqHPTA")
GameObjAddTo("Anime Vanguards", "AVInfSquared", "Stable", "A Macro For Farming fingers in Shibuya Infinite.", "V1", "green", 1, ["EasyUI", "BasePositionsAV", "UsefulFunctions", "UsefulFunctionsAV", "UWBOCRLib"], "xwUe6zqHPTA")
GameObjAddTo("Anime Vanguards", "AVShibuyaLegend", "Experimental", "A Macro For Farming Shibuya Legend Stages.", "V1", "007f90", 1, ["EasyUI", "BasePositionsAV", "UsefulFunctions", "UsefulFunctionsAV", "UWBOCRLib"], "xwUe6zqHPTA")


GameArray := []
For GameName, _ in GameObj {
    GameArray.Push(GameName)
}

MacroHubGui := Gui(,"Macro Hub | Version: " Macro_Hub_Version)
MacroHubGui.BackColor := "ffffff"

; Creating the Gui Objects
; Title
MacroHub_Title := MacroHubGui.AddText("w400 h35 x0 y8 +Center", "Macro Hub")
MacroHub_Version := MacroHubGui.AddText("w400 h25 x0 y43 +Center", "V" Macro_Hub_Version)

; Macro-Choosing
MacroHub_MacroGroupBox := MacroHubGui.AddGroupBox("w160 x10 y130 h300 +Center", "Macros")
MacroHub_GameTitle := MacroHubGui.AddText("w160 h22 x10 y68 +Center", "Game")

MacroHub_ChosenGame := MacroHubGui.AddDropDownList("w160 h20 x10 y93 +Center r10 vChosenGame", GameArray)

MacroHub_MacroLeftArrow := MacroHubGui.AddButton("w25 x40 h25 y402", "<")
MacroHub_MacroRightArrow := MacroHubGui.AddButton("w25 x115 h25 y402", ">")
MacroHub_PageNumber := MacroHubGui.AddText("w35 x72.5 h25 y402 +Center", "1/5")


MacroButtonArray := []
loop 8 {
    if A_Index = 1 {
        MacroButtonArray.Push(MacroHubGui.AddButton("w150 x15 h25 y150", "DiceMerchantMacro"))
        continue
    }
    MacroButtonArray.Push(MacroHubGui.AddButton("w150 x15 h25 yp+32", "DiceMerchantMacro"))
}

; Macro Info
MacroHub_MacroTitle := MacroHubGui.AddText("w110 h22 x230 y68 +Center", "Macro Info")
MacroHub_MacroInfoGroupBox := MacroHubGui.AddGroupBox("w210 x180 y88 h342 +Center")
MacroHub_MacroName := MacroHubGui.AddText("w200 h22 x185 y100 +Center", "[Macro Name]")
MacroHub_MacroVersion := MacroHubGui.AddText("w200 h20 x185 y119 +Center", "[Macro Version]")
MacroHub_MacroDescription := MacroHubGui.AddText("w200 h70 x185 y150 +Center", "[Macro Description]")

MacroHub_MacroStatusTitle := MacroHubGui.AddText("w200 h22 x185 y225 +Center", "Status")
MacroHub_MacroStatus := MacroHubGui.AddText("w200 h22 x185 y245 +Center", "[Macro Status]")

MacroHub_MacroLastUpdatedTitle := MacroHubGui.AddText("w200 h22 x185 y275 +Center", "Last Updated")
MacroHub_MacroLastUpdated := MacroHubGui.AddText("w200 h22 x185 y295 +Center", "[Macro Last Updated]")

MacroHub_RunMacro :=  MacroHubGui.AddButton("w200 h25 x185 y346 +Center", "Run Macro")
MacroHub_MacroVideo :=  MacroHubGui.AddButton("w200 h25 x185 y373 +Center", "Youtube Video")
MacroHub_MacroChangeLog :=  MacroHubGui.AddButton("w200 h25 x185 y400 +Center", "Change logs")

MacroInfoArray_1 := [
    MacroHub_MacroName, MacroHub_MacroVersion, MacroHub_MacroDescription, MacroHub_MacroStatusTitle, MacroHub_MacroStatus, 
    MacroHub_MacroLastUpdatedTitle, MacroHub_MacroLastUpdated, MacroHub_RunMacro, MacroHub_MacroVideo, MacroHub_MacroChangeLog
]

MacroInfoArray_2 := [
    MacroHub_MacroLeftArrow, MacroHub_MacroRightArrow, MacroHub_PageNumber
]

; Extras
MacroHub_DiscordButton := MacroHubGui.AddButton("w120 h30 x10 y435 +Center", "Discord Server")
MacroHub_YoutubeButton := MacroHubGui.AddButton("w130 h30 x130 y435 +Center", "Youtube Channel")
MacroHub_DonateButton := MacroHubGui.AddButton("w70 h30 x320 y435 +Center", "Donate")


; Setting Fonts to Objects
MacroHub_Title.SetFont("s23 Bold underline q4", "Tahoma")
MacroHub_GameTitle.SetFont("s14 Bold underline q4", "Tahoma")
MacroHub_Version.SetFont("s13 Bold q4", "Tahoma")
MacroHub_ChosenGame.SetFont("s10 Bold q4", "Tahoma")
MacroHub_MacroTitle.SetFont("s14 Bold underline q4", "Tahoma")
MacroHub_MacroGroupBox.SetFont("s12", "")
MacroHub_MacroName.SetFont("s13 q4 Bold", "Tahoma")
MacroHub_MacroVersion.SetFont("s11", "Tahoma")
MacroHub_MacroLastUpdatedTitle.SetFont("s13 underline", "Tahoma")
MacroHub_MacroLastUpdated.SetFont("s11", "Tahoma")
MacroHub_MacroDescription.SetFont("s11", "Tahoma")
MacroHub_MacroStatus.SetFont("s11", "Tahoma")
MacroHub_MacroStatusTitle.SetFont("s13 underline", "Tahoma")
MacroHub_RunMacro.SetFont("s12")
MacroHub_MacroVideo.SetFont("s12")
MacroHub_MacroChangeLog.SetFont("s12")
MacroHub_MacroLeftArrow.SetFont("bold s15")
MacroHub_MacroRightArrow.SetFont("bold s15")
MacroHub_PageNumber.SetFont("bold s15")
MacroHub_DiscordButton.SetFont("bold s10")
MacroHub_YoutubeButton.SetFont("bold s10")
MacroHub_DonateButton.SetFont("bold s11")

for _, Button in MacroButtonArray {
    Button.SetFont("s11", "Tahoma")
}

; Binding Events
MacroHub_ChosenGame.OnEvent("Change", (*) => GameChosen())
MacroHub_MacroLeftArrow.OnEvent("Click", (*) => ChangePage("Left"))
MacroHub_MacroRightArrow.OnEvent("Click", (*) => ChangePage("Right"))
MacroHub_MacroVideo.OnEvent("Click", (*) => OpenVideoButtonClicked())
MacroHub_MacroChangeLog.OnEvent("Click", (*) => OpenChangelogsButtonClicked())
MacroHub_RunMacro.OnEvent("Click", (*) => RunMacroButtonClicked())
MacroHubGui.OnEvent("Close", (*) => ExitApp())
MacroHub_DiscordButton.OnEvent("Click", (*) => Run("https://discord.com/invite/JrwB6jVxkR"))
MacroHub_YoutubeButton.OnEvent("Click", (*) => Run("https://www.youtube.com/channel/UCKOkQGvHO71nqQjwTiJX5Ww"))
MacroHub_DonateButton.OnEvent("Click", (*) => DonateUI.Show())

; Main
for _1, ControlArray in [MacroInfoArray_1, MacroButtonArray, MacroInfoArray_2] {
    for _2, Control in ControlArray {
        Control.Visible := false

        if _1 = 2 {
            RandFunc_1(_2, Control)
        }
    }
}

UI_Holder.Push(MacroHubGui)

ShowInfoText("Checking MacroHub Version | If this gets stuck, Hit F8")
whr := ComObject("WinHttp.WinHttpRequest.5.1")
whr.Open("GET", "https://raw.githubusercontent.com/SimplyJustBased/MacroShenanigans/main/MacroHub.ahk", true)
whr.Send()
whr.WaitForResponse()
DifferenceInMHVersion := VersionCheck(A_ScriptFullPath, whr.ResponseText)

if DifferenceInMHVersion.R {
    HideInfoText()

    Path := A_ScriptFullPath
    FileDelete(Path)
    FileAppend(whr.ResponseText, Path, "UTF-8-RAW")
    Run(Path)
    ExitApp()
}

ShowInfoText("Checking Folders | If this gets stuck, Hit F8")
for _, Folder in FolderCheck {
    if not DirExist(FolderPlace "\" Folder) {
        DirCreate(FolderPlace "\" Folder)
    }
}

for Game, _2 in GameObj {
    if not DirExist(FolderPlace "\MacroHubFiles\MacroFolders\" Game) {
        DirCreate(FolderPlace "\MacroHubFiles\MacroFolders\" Game)
    }
}

ShowInfoText("Checking Macro Storage | If this gets stuck, Hit F8")
for _1, DownloadObject in StorageDownloads {
    Download(DownloadObject.Link, FolderPlace "\" DownloadObject.Path "\" DownloadObject.FileName)
}


HideInfoText()
CreateDonateUI()
MacroHubGui.Show("w400 h470")

F8::ExitApp
