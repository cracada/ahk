;====================================================================
;                         CR's AHK Script                          
;                      CapsLock Enhancement                           
;--------------------------------------------------------------------
;Summary:                                                             
;--------------------------------------------------------------------
;CapsLock + uiojkl             | Cursor Mover                      
;CaspLock + qwtpd              | Windows & Tab Controller            
;CaspLock + erg                | Self Defined Programs                 
;CapsLock + ; Esc F5           | Esc Suspend,Reload 
;CapsLock + []'                | Key Mapping                      
;CapsLock + Direction          | Mouse Move                              
;CapsLock + PgUp/PgDn          | Mouse Click                         
;CaspLock + 1234567890-=       | Shifter as Shift                   
;CapsLock + zxcvay sfh bnm,./  | Editor                             
;         + Enter Backspace \  |                              
;--------------------------------------------------------------------
;Use it whatever and wherever you like. Hope it help                 
;====================================================================


#SingleInstance force
SetWorkingDir %A_ScriptDir%

; If the script is not elevated, relaunch as administrator and kill current instance:
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

;icon set
if FileExist("kk.ico") {
    Menu, Tray, Icon, kk.ico
} else {
    Menu, Tray, Icon,,, 1  
}

#NoEnv
Process Priority,,High
SetStoreCapslockMode, Off
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
CapsLock & `::SendInput +``
CapsLock & 1::SendInput +1
CapsLock & 2::SendInput +2
CapsLock & 3::SendInput +3
CapsLock & 4::SendInput +4
CapsLock & 5::SendInput +5
CapsLock & 6::SendInput +6
CapsLock & 7::SendInput +7
CapsLock & 8::SendInput +8
;CapsLock & 9::SendInput +9
CapsLock & 9::
    if GetKeyState("Alt", "P")
        Func_doubleykh() ;SendInput () 
    else
        SendInput +9
return
;CapsLock & 0::SendInput +0
CapsLock & 0::
    if GetKeyState("Alt", "P")
        Func_doubleykh() ;SendInput () 
    else
        SendInput +0
return

CapsLock & -::SendInput +{-}
CapsLock & =::SendInput +{=} 

;--------------------------------------------------------------------
CapsLock & q:: SendInput !{F4} 
CapsLock & w::SendInput ^w  
CapsLock & e::SendInput #^!e
CapsLock & r::SendInput !r
CapsLock & t::SendInput ^t
CapsLock & y::SendInput ^y
CapsLock & u::Func_nav("Home")
CapsLock & i::Func_nav("Up")	
CapsLock & o::Func_nav("End")
CapsLock & p::Func_winPin() 
CapsLock & [::Func_doublehkh()
;    if GetKeyState("Alt", "P")
;        SendInput {PgUp}
;    else
;        Func_doublezkh()
;return
CapsLock & ]::Func_doublezkh()
;    if GetKeyState("Alt", "P")
;        SendInput {PgDn}
;    else
;        SendInput {{}{}}
;return

;--------------------------------------------------------------------
CapsLock & a::SendInput ^a 
CapsLock & s::SendInput ^s 
CapsLock & d::SendInput !d
CapsLock & f::SendInput ^f
CapsLock & g::SendInput #^g
CapsLock & h::SendInput ^h
CapsLock & j::Func_nav("Left")
CapsLock & k::Func_nav("Down")
CapsLock & l::Func_nav("Right")
CapsLock & `;::SendInput {Esc}
/* 
CapsLock & `;::
    if GetKeyState("Alt", "P")
        SendInput {-} 
    else
        SendInput {=}  
return
*/

CapsLock & '::
    if GetKeyState("Alt", "P")
        Func_doublesyh() ;SendInput "" 
    else
        Func_doubledyh() ;SendInput ''  
return

;--------------------------------------------------------------------
CapsLock & z::SendInput ^z
CapsLock & x::SendInput ^x
CapsLock & c::SendInput ^c
CapsLock & v::SendInput ^v
CapsLock & b::SendInput +{Home}{BS}
CapsLock & n::SendInput ^{BS}
CapsLock & m::SendInput {BS}
CapsLock & ,::SendInput {Del}
CapsLock & .::SendInput ^{Del}
CapsLock & /::SendInput +{End}{BS}

CapsLock & BackSpace::SendInput {End}+{Home}{BS}  
CapsLock & \::SendInput {Home}{Enter}{Up}  
CapsLock & Enter::SendInput {End}{Enter}  

;CapsLock & RShift::SendInput {Esc}
CapsLock & Space::SendInput {Enter} 

;--------------------------------------------------------------------
; 鼠标单击
CapsLock & PgUp:: Click,Left                                                     
CapsLock & PgDn:: Click,Right 
; 光标移动
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
;PrtSC唤起FSCapture截图
PrintScreen::SendInput #^!p

;Ctrl+B only in Chrome
#IfWinActive ahk_exe chrome.exe
Ctrl & b::
    KeyWait, b
    Func_ditto(1)
return
#IfWinActive

;--------------------------------------------------------------------
;cursor mover
Func_nav(act){
if GetKeyState("control", "P")
{                        
    if GetKeyState("Alt", "P") ;almost impossible ctrl+shift+
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
    SendInput !`` 
    if (sn != "")
        Sleep, 100
        SendInput !%sn% 
return
}
; 选择的内容用括号括起来
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

;尖括号/圆括号、中括号、花括号、单引号、双引号
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
    MsgBox, , , reload, 0.5
    Reload
    return
}

;Do nothing
Func_nothing(){
    return
}

