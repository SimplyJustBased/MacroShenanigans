#Requires AutoHotkey v2.0 
; Functions that arent really apart of the mainscript but will help it out

ToSeconds(Time) {
    return (Time/1000)
}

SpaceOutPositions(PositionArray, ToSpaceBy, ReturnDualArray) {
    ArrayHigher := [(PositionArray[1]-ToSpaceBy), (PositionArray[2]-ToSpaceBy)]
    ArrayLower := [(PositionArray[1]+ToSpaceBy), (PositionArray[2]+ToSpaceBy)]
    BaseSpreadArray := [(PositionArray[1]-ToSpaceBy), (PositionArray[2]-ToSpaceBy), (PositionArray[1]+ToSpaceBy), (PositionArray[2]+ToSpaceBy)]
    if ReturnDualArray {
        return [ArrayHigher, ArrayLower, BaseSpreadArray]
    } else {
        return BaseSpreadArray
    }
}

CreatePositions(XArray, YArray) {
    RealArray := []
    for _, Y in YArray {
        for _, X in XArray {
            RealArray.InsertAt(RealArray.Length, [X, Y])
        }
    }
    return RealArray
}

StupidCatCheck() {
    if PixelSearch(&u,&u, PositionMap["StupidCatTL"][1], PositionMap["StupidCatTL"][2], PositionMap["StupidCatBR"][1], PositionMap["StupidCatBR"][2], 0x95AACD, 10) {
        return true
    }
    return false
}

FindMedian(TheArray) {
    XNum := 0
    YNum := 0

    for _ArrayNum, PositionArray in TheArray {
        XNum += PositionArray[1]
        YNum += PositionArray[2]
    } 

    XNum /= TheArray.Length
    YNum /= TheArray.Length
    return [XNum, YNum]
}

GetDistanceBetweenPoints(X1, Y1, X2, Y2) {
    return (((X2 - X1)**2) + ((Y2-Y1)**2 ))**(0.5)
} 

DisconnectedCheck() {
    DCBLS := SpaceOutPositions(PositionMap["DisconnectedBackgroundLeftSide"], 5, false)
    DCBRS := SpaceOutPositions(PositionMap["DisconnectedBackgroundRightSide"], 5, false)
    RCB := SpaceOutPositions(PositionMap["ReconnectButton"], 10, false)

    if PixelSearch(&A,&A, DCBLS[1], DCBLS[2], DCBLS[3], DCBLS[4], 0x393B3D, 2) {
        if PixelSearch(&A, &A, RCB[1], RCB[2], RCB[3], RCB[4], 0xFFFFFF, 0) {
            if PixelSearch(&A,&A, DCBRS[1], DCBRS[2], DCBRS[3], DCBRS[4], 0x393B3D, 2) {
                return true
            }
        }
    }
    return false
}

ObjToMap(Obj, Depth:=5, IndentLevel:="")
{
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

CloneMap(MapToClone) {
    NewMap := Map()
    for Key, Value in MapToClone {
        NewMap[Key] := Value
    }
    return NewMap
}

CloneMaps(MapArray) {
    ReturnMapArray := []
    for _MapNum, MapToClone in MapArray {
        NewMap := Map()
        for Key, Value in MapToClone {
            NewMap[Key] := Value
        }
        ReturnMapArray.InsertAt(ReturnMapArray.Length + 1, NewMap)
    }
    return ReturnMapArray
}