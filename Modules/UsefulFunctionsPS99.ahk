/**
 * @param TableInfo [NameFromPosMap, Color, Variation, ID, Re-Name]
 * 
 * ID | 1 = Has TL/BR values | 2 = No TL\BR Values
 */
____PSCreationMap := [
    ["TpButtonCheck", 0xEC0D3A, 15, 1],
    ["TpButton", 0xEC0D3A, 5, 1],
    ["SearchField", 0x1E1E1E, 3, 1],
    ["StupidCat", 0x95AACD, 10, 1],
    ["MiniX", 0xFF0B4E, 5, 1],
    ["X", 0xEC0D3A, 10, 1],
    ["Empower_EnchantSelection", 0x000000, 2, 1],
    ["AutoFarm", 0xFF1055, 20, 1],
    ["AutoHatch", 0xFF1055, 20, 1],
    ["Daycare_OkayButton", 0x7FF60E, 5, 1],
    ["Empower_OkayButton", 0x7EF50D, 3, 1],
    ["Empower_OkayButton", 0xACAFC5, 3, 1, "Evil_Empower_OkayButton"],
    ["Daycare_EnrollButton", 0x61E0FE, 5, 1],
    ["DaycareGP_EnrollButton", 0x61E0FE, 5, 1],

    ["DisconnectBG_LS", 0x393B3D, 3, 2],
    ["DisconnectBG_RS", 0x393B3D, 3, 2],
    ["ReconnectButton", 0xFFFFFF, 3, 2],
    ["AutoHatch_InternalCheck", 0xFF145C, 5, 2],
    ["AutoHatch_InternalChargedCheck", 0xFF145C, 5, 2],
    ["AutoHatch_InternalGoldenCheck", 0xFF145C, 5, 2],
    ["LB_Star", 0xCE9440, 35, 2],
    ["LB_Diamond", 0x4C93B7, 35, 2],
]

/**
 * Closes all UI off of players screen
 * 
 * Added : V1 | Modified : V1
 */
Clean_UI() {
    SetPixelSearchLoop("X", 10000, 2, PM_GetPos("X"),,,10,)
    SetPixelSearchLoop("MiniX", 10000, 2, PM_GetPos("MiniX"),,,10,)
}


/**
 * Checks if the StupidCat is on screen
 * 
 * Added : V1 | Modified : V1
 */
StupidCatCheck() {
    if EvilSearch(PixelSearchTables["MiniX"])[1] and EvilSearch(PixelSearchTables["StupidCat"])[1] {
        return true
    }
    
    return false
}

LeaderBoardThingy() {
    Arg1 := EvilSearch(PixelSearchTables["LB_Star"])
    Arg2 := EvilSearch(PixelSearchTables["LB_Diamond"])

    OutputDebug(Arg1[1] " : " Arg2[1] "`n")

    if Arg1[1] and Arg2[1] {
        SendEvent "{Tab Down}{Tab Up}"
    }
}

;-- Main
for _, CreationArray in ____PSCreationMap {
    ____CreatePSInstance(CreationArray)
}

