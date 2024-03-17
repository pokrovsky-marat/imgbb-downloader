/* Clipboard to image file ---------------------------------------
This script saves a clipboard image to a file
By mikeyww on 17 January 2023 • For AutoHotkey version 1.1.36.02
https://www.autohotkey.com/boards/viewtopic.php?p=502328#p502328
------------------------------------------------------------------
*/
#Requires AutoHotkey v1.1.33
filePath := A_ScriptDir "\test.jpg" ; Adjust as needed
; ----------------------------------------------------

#Include %A_ScriptDir%\Gdip_all.ahk
Global clipType
SplitPath filePath,, dir, ext, fnBare
old := dir "\" fnBare "-OLD" "." ext
FileRecycle % old
FileMove % filePath, % old
OnClipboardChange("clipChanged")

^`::
  Send,{PrintScreen}
  Sleep, 100
  SoundBeep 400, 200
  If (clipType = "" || clipType = NONTEXT := 2) {
    FileRecycle % filePath
    clipboardToImageFile(filePath)
    If FileExist(filePath)
    {
      ; SoundBeep 400, 200
      ; Run, node "C:\ahk\CustomLightShot\imgbb.js" 
      RunWait, node "C:\ahk\CustomLightShot\imgbb.js" %filePath% , , Hide
      SoundBeep 400, 200
    }
    Else MsgBox 48, Error, File not found.`n`n%filePath%
    } Else MsgBox 48, Error, Clipboard does not contain an image.
Return

clipboardToImageFile(filePath) {
  pToken := Gdip_Startup()
  pBitmap := Gdip_CreateBitmapFromClipboard() ; Clipboard -> bitmap
  Gdip_SaveBitmapToFile(pBitmap, filePath) ; Bitmap    -> file
  Gdip_DisposeImage(pBitmap), Gdip_Shutdown(pToken)
}

clipChanged(type) {
  clipType := type
}