CurrentPassword := "DRFTCLANONTOP125"

CheckPassword(Password) {
    if Password = CurrentPassword {
        return [true, false, true, true, false] ; hi
    } else {
        return [false, false, false, false, false]
    }
} 
