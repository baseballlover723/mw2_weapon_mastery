#Requires AutoHotkey v2.0
;#Include "AutoHotkey-JSON/Jxon.ahk"
;#Include native-test/Native.ahk
#Include "Gdip_All.ahk"
;#Include "screenshot.ahk"


SleepTime := 100
NewScreenTime := 400
;ScreenshotTime := 2000
;ScreenshotTime := 500
ScreenshotTime := 100

RunDir := "./runs"


x := 0
y := 0

Weapons := [
  {
    Name: "Assault Rifles",
    Guns: [
      "Chimera",
      "Lachmann-556",
      "STB 556",
      "M4",
      "M16",
      "Kastov 762",
      "Kastov-74U",
      "Kastov 545",
      "M13B",
      "Taq-56",
      "ISO Hemlock"
    ]
  }, {
    Name: "Battle Rifles",
    Guns: [
      "TAQ-V",
      "Lachmann-762",
      "SO-14",
      "FTAC Recon"
    ]
  }, {
    Name: "Sub Machine Guns",
    Guns: [
      "Lachmann Sub",
      "Bas-P",
      "MX9",
      "Vaznev-9K",
      "FSS Hurricane",
      "Minibak",
      "PDSW 528",
      "Vel 46",
      "Fennec 45"
    ]
  }, {
    Name: "Light Machine Guns",
    Guns: [
      "RAAL MG",
      "HCR 56",
      "556 Icarus",
      "RPK",
      "RAPP H",
      "Sakin MG38"
    ]
  }, {
    Name: "Shotguns",
    Guns: [
      "Lockwood 300",
      "Bryson 800",
      "Bryson 890",
      "Expedite 12",
      "KV Broadside"
    ]
  }, {
    Name: "Marksman Rifles",
    Guns: [
      "LM-S",
      "SP-R 208",
      "EBR-14",
      "SA-B 50",
      "Lockwood MK2",
      "TAQ-M",
      "Crossbow",
      "Tempus Torrent"
    ]
  }, {
    Name: "Sniper Rifles",
    Guns: [
      "LA-B 330",
      "SP-X 80",
      "MCPR-300",
      "Victus XMR",
      "Signal 50"
    ]
  }, {
    Name: "Handguns",
    Guns: [
      "X12",
      "X13 Auto",
      ".50 GS",
      "P890",
      "Basilisk"
    ]
  }, {
    Name: "Launchers",
    Guns: [
      "RPG-7",
      "Pila",
      "Jokr",
      "Strela-P"
    ]
  }, {
    Name: "Melee",
    Guns: [
      "Riot Shield",
      "Combat Knife",
      "Dual Kodachis"
    ]
  }
]

MySend(keys*) {
  for index, key in keys {
    Send key
    Sleep SleepTime
  }
}

CreateRunDir() {
  global RunDir
  if (DirExist(RunDir)) {
    DirDelete RunDir, 1
  }
  DirCreate RunDir
  DirCreate RunDir . "/flat"
}

CreateWeaponClassDir(WeaponClass) {
  global RunDir
  DirCreate RunDir . "/" . WeaponClass
}

CreateWeaponDir(WeaponClass, WeaponName) {
  global RunDir
  DirCreate RunDir . "/" . WeaponClass . "/" . WeaponName
}

GoToChallenges() {
  ; From home navagate to challenges
  MySend("{F1}", "{Right}", "{Right}", "{Right}", "{Down}")
;  Send "{F1}"
;  Sleep NewScreenTime
;  MySend("{Right}", "{Right}", "{Right}", "{Down}")

  ; Select weapon challenges from menu
  Send "{Space}"
  Sleep NewScreenTime
  Send "{Space}"
  Sleep NewScreenTime
}

TakeScreenshot(WeaponClassName, gun) {
  global RunDir
  CreateWeaponDir(WeaponClassName, gun)
  ; Select Weapon Mastery
  Send "{Space}"
;  Sleep NewScreenTime
  Sleep SleepTime
  Send "2"
  Sleep ScreenshotTime

  SaveScreenshot(WeaponClassName, gun, "full")
  SaveScreenshot(WeaponClassName, gun, "gold")
  SaveScreenshot(WeaponClassName, gun, "plat")
  SaveScreenshot(WeaponClassName, gun, "poly")
  SaveScreenshot(WeaponClassName, gun, "orion")

;  Sleep SleepTime
  Send "{Esc}"
  Sleep SleepTime
;  Sleep NewScreenTime
  Send "{Esc}"
  Sleep NewScreenTime
}

;Modes := Map("full", 1, "gold", "1300|1050|50|25", "plat", "1308|485|50|25", "poly", "650|1050|50|25", "orion", "1308|1050|50|25")
;Modes := Map("full", 1, "gold", "680|485|90|25", "plat", "1330|485|90|25", "poly", "680|1050|90|25", "orion", "1330|1050|90|25")
;Modes := Map("full", 1, "gold", "675|480|100|35", "plat", "1325|480|100|35", "poly", "675|1045|100|35", "orion", "1325|1045|100|35")
;Modes := Map("full", 1, "gold", "673|480|100|35", "plat", "1323|480|100|35", "poly", "673|1044|100|35", "orion", "1323|1044|100|35")

Modes := Map("full", 1, "gold", "678|485|90|25", "plat", "1328|485|90|25", "poly", "678|1049|90|25", "orion", "1328|1049|90|25")
;Modes := Map("full", 1, "gold", "678|485|45|25", "plat", "1328|485|45|25", "poly", "678|1049|45|25", "orion", "1328|1049|45|25")
;Modes := Map("full", 1, "gold", "678|485|40|25", "plat", "1328|485|40|25", "poly", "678|1049|40|25", "orion", "1328|1049|40|25")
;Modes := Map("full", 1, "gold", "673|485|45|25", "plat", "1323|485|45|25", "poly", "673|1049|45|25", "orion", "1323|1049|45|25")

SaveScreenshot(WeaponClassName, gun, mode) {
  global RunDir
  global Modes
  global oI
  path := RunDir . "/" . WeaponClassName . "/" . gun . "/" . mode . ".png"
  flatPath := RunDir . "/flat/" . gun . "-" . mode . ".png"
  img:=Gdip_Bitmapfromscreen(Modes[mode])
;  img:=ResConImg(img, 5)
  Gdip_SaveBitmapToFile(img, path)
;  Gdip_SaveBitmapToFile(img, flatPath)
  Gdip_DisposeImage(img)
}

NextGun()
{
  global x
  global y
  global SleepTime
  global First
  if (First) {
    First := false
    return
  }
  if (x >= 2) {
    x := 0
    y := y + 1
    ; Move to the next row 1
    MySend("{Left}", "{Left}", "{Left}", "{Down}")
  } else {
    x++
  ; Move to the right 1
    MySend("{Right}")
  }
}

WeaponClass(WeaponClassName, Guns) {
  global First
  First := True
  CreateWeaponClassDir(WeaponClassName)
  for index, gun in Guns {
    NextGun()
    if (index = 1) { ; DEBUG
    continue ; DEBUG
    } ; DEBUG
    TakeScreenshot(WeaponClassName, gun)
    break
  }
}

WeaponClasses() {
  global WeaponClassesCount
  global Weapons
  global x
  global y
  for index, WeaponObj in Weapons {
    WeaponClass(WeaponObj.Name, WeaponObj.Guns)
    Send "e"
    Sleep NewScreenTime
    x := 0
    y := 0
  }
}

WinWait "ahk_exe cod.exe"
WinActivate

ptok := Gdip_Startup()

GoToChallenges()
CreateRunDir()

WeaponClasses()

MySend("{Esc}", "{Esc}", "{Esc}")

Gdip_Shutdown(ptok)

;TakeScreenshot()
;NextGun()
;
;TakeScreenshot()
;NextGun()
;
;TakeScreenshot()
;NextGun()

;/*  ResConImg
; *    By kon
; *    Updated November 2, 2015
; *    http://ahkscript.org/boards/viewtopic.php?f=6&t=2505&p=13640#p13640
; *
; *  Resize and convert images. png, bmp, jpg, tiff, or gif.
; *
; *  Requires Gdip.ahk in your Lib folder or #Included. Gdip.ahk is available at:
; *      http://www.autohotkey.com/board/topic/29449-gdi-standard-library-145-by-tic/
; *
; *  ResConImg( OriginalFile             ;- Path of the file to convert
; *           , NewWidth                 ;- Pixels (Blank = Original Width)
; *           , NewHeight                ;- Pixels (Blank = Original Height)
; *           , NewName                  ;- New file name (Blank = "Resized_" . OriginalFileName)
; *           , NewExt                   ;- New file extension can be png, bmp, jpg, tiff, or gif (Blank = Original extension)
; *           , NewDir                   ;- New directory (Blank = Original directory)
; *           , PreserveAspectRatio      ;- True/false (Blank = true)
; *           , BitDepth)                ;- 24/32 only applicable to bmp file extension (Blank = 24)
; */
;ResConImg(OriginalFile, NewWidth:="", NewHeight:="", NewName:="", NewExt:="", NewDir:="", PreserveAspectRatio:=true, BitDepth:=24) {
;    SplitPath, OriginalFile, SplitFileName, SplitDir, SplitExtension, SplitNameNoExt, SplitDrive
;    pBitmapFile := Gdip_CreateBitmapFromFile(OriginalFile)                  ; Get the bitmap of the original file
;    Width := Gdip_GetImageWidth(pBitmapFile)                                ; Original width
;    Height := Gdip_GetImageHeight(pBitmapFile)                              ; Original height
;    NewWidth := NewWidth ? NewWidth : Width
;    NewHeight := NewHeight ? NewHeight : Height
;    NewExt := NewExt ? NewExt : SplitExtension
;    if SubStr(NewExt, 1, 1) != "."                                          ; Add the "." to the extension if required
;        NewExt := "." NewExt
;    NewPath := ((NewDir != "") ? NewDir : SplitDir)                         ; NewPath := Directory
;            . "\" ((NewName != "") ? NewName : "Resized_" SplitNameNoExt)       ; \File name
;            . NewExt                                                            ; .Extension
;    if (PreserveAspectRatio) {                                              ; Recalcultate NewWidth/NewHeight if required
;        if ((r1 := Width / NewWidth) > (r2 := Height / NewHeight))          ; NewWidth/NewHeight will be treated as max width/height
;            NewHeight := Height / r1
;        else
;            NewWidth := Width / r2
;    }
;    pBitmap := Gdip_CreateBitmap(NewWidth, NewHeight                        ; Create a new bitmap
;    , (SubStr(NewExt, -2) = "bmp" && BitDepth = 24) ? 0x21808 : 0x26200A)   ; .bmp files use a bit depth of 24 by default
;    G := Gdip_GraphicsFromImage(pBitmap)                                    ; Get a pointer to the graphics of the bitmap
;    Gdip_SetSmoothingMode(G, 4)                                             ; Quality settings
;    Gdip_SetInterpolationMode(G, 7)
;    Gdip_DrawImage(G, pBitmapFile, 0, 0, NewWidth, NewHeight)               ; Draw the original image onto the new bitmap
;    Gdip_DisposeImage(pBitmapFile)                                          ; Delete the bitmap of the original image
;    Gdip_SaveBitmapToFile(pBitmap, NewPath)                                 ; Save the new bitmap to file
;    Gdip_DisposeImage(pBitmap)                                              ; Delete the new bitmap
;    Gdip_DeleteGraphics(G)                                                  ; The graphics may now be deleted
;}
