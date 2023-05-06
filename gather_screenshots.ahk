#Requires AutoHotkey v2.0
#Include "Gdip_All.ahk"

RunDir := "./runs"

SleepTime := 100
NewScreenTime := 400
ScreenshotTime := 100
Modes := Map("full", GetPrimaryMonitor(), "gold", "678|485|92|25", "plat", "1328|485|92|25", "poly", "680|1049|92|25", "orion", "1328|1049|92|25")
Locked := {X1: 1635, Y1: 485, X2: 1670, Y2: 500, Color: 0xe7e7e7, Variation: 2}
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
      "FTAC Recon",
      "Cronen Squall"
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
      "Signal 50",
      "FJX Imperium"
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
  ;if (DirExist(RunDir)) {
  ;  DirDelete RunDir, 1
  ;}
  DirCreate RunDir
}

CreateWeaponClassDir(WeaponClass) {
  global RunDir
  DirCreate RunDir . "/" . WeaponClass
}

CreateWeaponDir(WeaponClass, WeaponName) {
  global RunDir
  if (DirExist(RunDir . "/" . WeaponClass . "/" . WeaponName)) {
    DirDelete RunDir . "/" . WeaponClass . "/" . WeaponName, 1
  }
  DirCreate RunDir . "/" . WeaponClass . "/" . WeaponName
}

GoToChallenges() {
  ; From home navagate to challenges
  Send "{F1}"
  Sleep NewScreenTime

  MySend("{Right}", "{Right}", "{Right}", "{Down}", "{Space}")
  ; Select weapon challenges from menu
  Send "{Space}"
  Sleep NewScreenTime
}

TakeScreenshot(WeaponClassName, gun) {
  global RunDir
  CreateWeaponDir(WeaponClassName, gun)
  ; Select Weapon Mastery
  Send "{Space}"
  Sleep SleepTime
  Send "2"
  Sleep ScreenshotTime

  SaveScreenshot(WeaponClassName, gun, "full")
  SaveScreenshot(WeaponClassName, gun, "gold")
  SaveScreenshot(WeaponClassName, gun, "plat")
  SaveScreenshot(WeaponClassName, gun, "poly")
  SaveScreenshot(WeaponClassName, gun, "orion")

  Send "{Esc}"
  Sleep SleepTime
  Send "{Esc}"
  Sleep NewScreenTime
}


SaveScreenshot(WeaponClassName, gun, mode) {
  global RunDir
  global Modes
  path := RunDir . "/" . WeaponClassName . "/" . gun . "/" . mode . ".png"
  img:=Gdip_Bitmapfromscreen(Modes[mode])
  Gdip_SaveBitmapToFile(img, path)
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

CheckUnlocked() {
  outputX := 0
  outputY := 0
  return !PixelSearch(&outputX, &outputY, Locked.X1, Locked.Y1, Locked.X2, Locked.Y2, Locked.Color, Locked.Variation)
}

WeaponClass(WeaponClassName, Guns) {
  global First
  First := True
  CreateWeaponClassDir(WeaponClassName)
  for index, gun in Guns {
    NextGun()
;    if (index = 1) { ; DEBUG
;    continue ; DEBUG
;    } ; DEBUG
    if (CheckUnlocked()) {
      TakeScreenshot(WeaponClassName, gun)
    }
;    break
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

CreateRunDir()
GoToChallenges()

WeaponClasses()

MySend("{Esc}", "{Esc}", "{Esc}")

Gdip_Shutdown(ptok)
