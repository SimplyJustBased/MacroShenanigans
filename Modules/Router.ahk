CoordMode "Mouse", "Screen"
CoordMode "Pixel", "Screen"
CoordMode "ToolTip", "Screen"
SetMouseDelay -1

StupidCatCheck() {
  MiniX := PositionMap["MiniX"]
  MiniXBR := PositionMap["MiniXBR"]
  MiniXTL := PositionMap["MiniXTL"]

  if not PixelSearch(&u,&u, MiniXTL[1], MiniXTL[2], MiniXBR[1], MiniXBR[2], 0xFF0B4E, 5) {
    OutputDebug("`n StupidCat has NOT Been found X VER")
    return false
  }

  if PixelSearch(&u,&u, PositionMap["StupidCatTL"][1], PositionMap["StupidCatTL"][2], PositionMap["StupidCatBR"][1], PositionMap["StupidCatBR"][2], 0x95AACD, 10) {
    OutputDebug("`n StupidCat has Been found")
    return true
  }
  OutputDebug("`n StupidCat has NOT Been found")
  return false
}

; Expecting : ZONENAME
_TP(Value) {
  ; OutputDebug("`nTP Function Value: " Value)

  Tpb := PositionMap["TPButton"]
  XBR := PositionMap["XBR"]
  XTL := PositionMap["XTL"]
  SrB := PositionMap["SearchBar"]
  TpM := PositionMap["TPUIMiddle"]
  MiniX := PositionMap["MiniX"]

  Sleep(400)
  SendEvent "{Click, " Tpb[1] ", " Tpb[2] ", 1}"
  Sleep(400)
  BreakTime := A_TickCount
  SecondaryBreakTime := A_TickCount
  loop {
      if PixelSearch(&u,&u, XTL[1], XTL[2], XBR[1], XBR[2], 0xEC0D3A, 10) {
          break
      }
      if A_TickCount - BreakTime >= 6000 {
          SendEvent "{Click, " Tpb[1] ", " Tpb[2] ", 1}"
          BreakTime := A_TickCount
      }
      if A_TickCount - SecondaryBreakTime >= 20000 {
          OutputDebug("Yikes")
          break
      }
      Sleep(100)
  }

  Sleep(300)
  SendEvent "{Click, " SrB[1] ", " SrB[2] ", 1}"
  Sleep(100)
  SendText Value

  loop 3 {
    Sleep(250)
    SendEvent "{Click, " TpM[1] ", " TpM[2] ", 1}"
  }
  Sleep(500)
}

; Expecting : NumberValueMap Variable
_W_nV(Value) {
  ; OutputDebug("`nWaitNV Function Value: " NumberValueMap[Value])

  Sleep(NumberValueMap[Value])
}

; Expecting : NUMBER (MILISECONDS)
_W(Value) {
  ; OutputDebug("`nWait Function Value: " Value)
  Sleep(Value)
}

; EXPECTING : [DELAY%KEY/TIME]
_R(Value) {
  OutputDebug("`nRoute Function Value: " Value)


  if RegExMatch(Value, "&") {
    SplitStringicals := StrSplit(SubStr(Value, 2, StrLen(Value) - 2), "&")
    RouteArray := []

    for _, S_2 in SplitStringicals {
      SecondSplitical := StrSplit(S_2, "%")

      Delay := SecondSplitical[1]
      KeyAndTime := SecondSplitical[2]

      RouteArray.InsertAt(RouteArray.Length + 1, {
        Key:(SubStr(KeyAndTime, 1, 1)), Delay:Delay, DownTime:(SubStr(KeyAndTime, 2)), KeyIsDown:false, KeyIsFinished:false
      })
    }

    StartTime := A_TickCount
    loop {
      KeysFininshed := 0

      for _, RouteObject in RouteArray {
        if RouteObject.KeyIsFinished {
          KeysFininshed += 1
          continue
        }

        if RouteObject.KeyIsDown {
          if A_TickCount - (StartTime + RouteObject.Delay + RouteObject.DownTime) >= 0 {
            SendEvent "{" RouteObject.Key " Up}"
            RouteArray[_].KeyIsFinished := true
          }
        }

        if A_TickCount - (StartTime + RouteObject.Delay) >= 0 and not RouteObject.KeyIsDown and not RouteObject.KeyIsFinished {
          SendEvent "{" RouteObject.Key " Down}"
          RouteArray[_].KeyIsDown := true
        }

      }

      if KeysFininshed >= RouteArray.Length {
        break
      }

      Sleep(1)
    }
  } else {
    StringOfEvil := StrSplit(SubStr(Value, 2, StrLen(Value) - 2), "%")

    Delay := StringOfEvil[1]
    Key := SubStr(StringOfEvil[2], 1, 1)
    Downtime := SubStr(StringOfEvil[2], 2)

    if Delay > 0 {
      Sleep(Delay)
    }

    SendEvent "{" Key " Down}"
    Sleep(Downtime)
    SendEvent "{" Key " Up}"
  }
}

ADVTextToFunctionMap := Map(
  "Tp:", _TP,
  "w_nV:", _W_nV,
  "wt:", _W,
  "r:", _R,
)

RouteUser(RouteText) {
  RouteArray := StrSplit(RouteText, "|")
  
  for _, RText in RouteArray {
    F_f := false
    for SearchFor, Function in ADVTextToFunctionMap {
      if RegExMatch(RText, "i)" SearchFor) {
        Function(SubStr(RText, StrLen(SearchFor) + 1))
        F_f := true
        break
      }
    }
    if not F_f {
      OutputDebug("Unknown Event")
    }
  }
}
