;====================================================================
;                         CR's AHK Script                          
;                      CapsLock Enhancement                           
;--------------------------------------------------------------------
;Summary:                                                             
;--------------------------------------------------------------------
;CapsLock + uiojkl             | Cursor Mover                      
;CaspLock + qwp                | Windows & Tab Controller            
;CaspLock + ertsdfgh           | Self Defined Programs                 
;CapsLock + zxcvay             | Editor                             
;         + bnm,./             | Editor(del)                       
;         + Enter Backspace \  | Editor (line)                     
;CapsLock + Esc ; F5           | Suspend,Esc,Reload 
;CapsLock + []'                | Key Mapping                      
;CapsLock + Direction          | Mouse Move                              
;CapsLock + PgUp/PgDn          | Mouse Click                         
;CaspLock + 1234567890-=       | Shifter as Shift    
;--------------------------------------------------------------------
;Use it whatever and wherever U like. Hope it help                 
;====================================================================

#NoEnv
#SingleInstance force
Process Priority,,High
ListLines Off
SetBatchLines, -1
SendMode Input
SetWorkingDir %A_ScriptDir%
SetStoreCapslockMode, Off

;launch as administrator 
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run *RunAs "%A_ScriptFullPath%" /restart
        else
            Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
    }
    ExitApp
}

;icon
if FileExist("kk.ico") {
    Menu, Tray, Icon, kk.ico
} else {
    Menu, Tray, Icon,,, 1  
}


CapsLock::
    KeyWait, CapsLock 
    if (A_TimeSinceThisHotkey < 300) { 
        currentState := GetKeyState("CapsLock", "T") 
        SetCapsLockState, % !currentState 
    }
return

Alt::return
;Esc:suspend F5:reload 
CapsLock & Esc::
Suspend, Permit
Func_Suspend()
Return
CapsLock & F5::Func_reload()

;--------------------------------------------------------------------
CapsLock & `::Send +``
CapsLock & 1::Send +1
CapsLock & 2::Send +2
CapsLock & 3::Send +3
CapsLock & 4::Send +4
CapsLock & 5::Send +5
CapsLock & 6::Send +6
CapsLock & 7::Send +7
CapsLock & 8::Send +8
CapsLock & 9::
    if GetKeyState("Alt", "P")
        Func_doubleykh()  
    else
        Send +9
return
CapsLock & 0::
    if GetKeyState("Alt", "P")
        Func_doubleykh()  
    else
        Send +0
return

CapsLock & -::Send +{-}
CapsLock & =::Send +{=} 

;--------------------------------------------------------------------
CapsLock & q:: Send !{F4} 
CapsLock & w::Send ^w  
CapsLock & e::Send #^!e
CapsLock & r::Send !r
CapsLock & t::Send ^t
CapsLock & y::Send ^y
CapsLock & u::Func_nav("Home")
CapsLock & i::Func_nav("Up")	
CapsLock & o::Func_nav("End")
CapsLock & p::Func_winPin() 
CapsLock & [::Func_doublehkh()
;    if GetKeyState("Alt", "P")
;        Send {PgUp}
;    else
;        Func_doublezkh()
;return
CapsLock & ]::Func_doublezkh()
;    if GetKeyState("Alt", "P")
;        Send {PgDn}
;    else
;        Send {{}{}}
;return

;--------------------------------------------------------------------
CapsLock & a::Send ^a 
CapsLock & s::Send ^s 
CapsLock & d::Send !d
CapsLock & f::Send ^f
CapsLock & g::Send #^g
CapsLock & h::Send ^h
CapsLock & j::Func_nav("Left")
CapsLock & k::Func_nav("Down")
CapsLock & l::Func_nav("Right")
CapsLock & `;::Send {Esc}

CapsLock & '::
    if GetKeyState("Alt", "P")
        Func_doubledyh() ;Send "" 
    else
        Func_doublesyh() ;Send ''  
return


;--------------------------------------------------------------------
CapsLock & z::Send ^z
CapsLock & x::Send ^x
CapsLock & c::Send ^c
CapsLock & v::Send ^v
CapsLock & b::Send +{Home}{BS}
CapsLock & n::Send ^{BS}
CapsLock & m::Send {BS}
CapsLock & ,::Send {Del}
CapsLock & .::Send ^{Del}
CapsLock & /::Send +{End}{BS}

CapsLock & BackSpace::Send {End}+{Home}{BS}  
CapsLock & \::Send {Home}{Enter}{Up}  
CapsLock & Enter::Send {End}{Enter}  
CapsLock & Space::Send {Enter} 

;--------------------------------------------------------------------
; mouse click
CapsLock & PgUp:: Click,Left                                                     
CapsLock & PgDn:: Click,Right 
; mouse curosr move
CapsLock & Left::
MouseMove, -15, 0, 0, R                                               
return  
CapsLock & Down::                                                       
MouseMove, 0, 15, 0, R                                                
return                                                               
CapsLock & Up::                                                       
MouseMove, 0, -15, 0, R                                                  
return                                                               
CapsLock & Right::                                                       
MouseMove, 15, 0, 0, R                                              
return 

;--------------------------------------------------------------------
;cursor mover, with Ctrl & Alt
Func_nav(act){
if GetKeyState("control", "P")
{                        
    if GetKeyState("Alt", "P") ;almost impossible 4 ctrl+shift+char
        Send, ^+{%act%}        
    else                      
        Send, ^{%act%}		
    return                    
}                          
else     
{                             
    if GetKeyState("Alt", "P")
        Send, +{%act%}         
    else				 
        Send, {%act%}        
    return                    
}    
return     
}

;Windows Pin
Func_winPin(){
    _id:=WinExist("A")
    WinSet, AlwaysOnTop
    return    
}

;Ditto 
Func_ditto(sn) {
    Send !`` 
    if (sn != "")
        Sleep, 100
        Send !%sn% 
return
}
; enclose function
Func_doubleChar(char1,char2:=""){
    if(char2=="")
    {
        char2:=char1
    }
    charLen:=StrLen(char2)
    selText:=getSelText()
    ClipboardOld:=ClipboardAll
    if(selText)
    {
        Clipboard:=char1 . selText . char2
        SendInput, +{insert}
    }
    else
    {
        Clipboard:=char1 . char2
        SendInput, +{insert}{left %charLen%}
    }
    Sleep, 100
    Clipboard:=ClipboardOld
    Return
}

; enclosed in <> () [] {} '' ""
Func_doublejkh(){
    Func_doubleChar("<",">")
    return
}
Func_doubleykh(){
    Func_doubleChar("(",")")
    return
}
Func_doublezkh(){
    Func_doubleChar("[","]")
    return
}
Func_doublehkh(){
    Func_doubleChar("{","}")
    return
}
Func_doubledyh(){
    Func_doubleChar("'","'")
    return
}
Func_doublesyh(){
    Func_doubleChar("""")
    return
}

;selected text
getSelText()
{
    ClipboardOld:=ClipboardAll
    Clipboard:=""
    SendInput, ^{insert}
    ClipWait, 0.1
    if(!ErrorLevel)
    {
        selText:=Clipboard
        Clipboard:=ClipboardOld
        StringRight, lastChar, selText, 1
        if(Asc(lastChar)!=10)
        {
            return selText
        }
    }
    Clipboard:=ClipboardOld
    return
}

;Suspend
Func_Suspend(){
    if (A_IsSuspended)
    {
        Suspend, Off
        SetCapsLockState, AlwaysOff
        Menu, Tray, Icon, kk.ico, , 1
        ToolTip, AHK 已恢复
    }
    else
    {
        SetCapsLockState, Off
        Menu, Tray, Icon, k0.ico, , 1
        Suspend, On
        ToolTip, AHK 已暂停
    }
    SetTimer, RemoveToolTip, 1500  ; 2秒后移除提示
return
}
RemoveToolTip:
    ToolTip
return

;Reload
Func_reload(){
    MsgBox, , , Reload, 0.5
    Reload
    return
}

;Do nothing
Func_nothing(){
    return
}

;--------------------------------------------------------------------
;PrtSC唤起FSCapture
PrintScreen::Send #^!p

;Win+B only in Chrome 
#IfWinActive ahk_exe chrome.exe
LWin & b::
    KeyWait, b
    Send ^v
    Sleep, 100 
    Send !``
    Sleep 100
    Send !1
    Sleep 100    
return
#IfWinActive