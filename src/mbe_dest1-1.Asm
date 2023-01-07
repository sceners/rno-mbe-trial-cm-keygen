.586p                   
.model flat, stdcall
option casemap :none

include		d:\masm32\include\windows.inc
include		d:\masm32\include\kernel32.inc
include		d:\masm32\include\user32.inc
include     d:\masm32\include\gdi32.inc
includelib	d:\masm32\lib\kernel32.lib
includelib	d:\masm32\lib\user32.lib
includelib	d:\masm32\lib\gdi32.lib

include		bigshit.inc
includelib	bigshit.lib
include		marcus_sha256.inc
include		lucifer_strlen.inc

DlgProc     proto :dword,:dword,:dword,:dword

.data
IDD_MAINDIALOG  equ 100
IDC_NAME		equ 108
IDC_SERIAL		equ 102
IDC_ABOUT       equ 106
IDC_RENNO       equ 107
IDC_GENERATE    equ 105
ID_ICON         equ 200
;---------------------------------------------------------------------------------------------------------
; CONFIGURATION
CurrentDate		TEXTEQU	<"24.08.2004">
Author			TEXTEQU	<"renno//htb">
;--
CrackMeName		TEXTEQU <"MBE (TRIAL) DestroyME v1 - Level 3">
Protection		TEXTEQU <"SHA-256, RSA-512">
;--
MinNameLen		EQU	2
MaxNameLen		EQU	128
;---------------------------------------------------------------------------------------------------------
.data?
_name			db MaxNameLen dup(?)
_hash			db 256 dup(?)
hInstance		dd ?
hIcon			dd ?
MB              MSGBOXPARAMS <?>
.data
_serial			db 256 dup(0)
nSize           dd 10h
_computer_name  dd 21h dup(0), 0FFFFFh
_computer_name_hash db 24h dup(0)
;---------------------------------------------------------------------------------------------------------
szCaption		db  CrackMeName,' *KEYGEN*',0
szCapAbout		db 'About',0
szTxTAbout		db 'Program: '
				db  09h,09h,CrackMeName,0dh,0ah
				db 'Release date: '
				db  09h,CurrentDate,0dh,0ah
				db 'Protection: '
				db  09h,Protection,0dh,0ah
				db 0dh,0ah
				db 'Done by ',Author,0
_enter_name		db 'Enter name!',0

D				db '7AD62F3784B3A99E863FD954E62B670B1C9AB01D54E5BC3B0FE79A14FCFC'
				db 'F1CE6459C7DEBC145ACB4B4B78C8AA2DB244E1B74F031BF93E66D9E1B8F3'
				db '3B2B7D4D',0
N				db '92A3A357B7A4B508360C1353D12A46D826EF9F31A72049B7D7FBFAF772BC'
				db '4809DD3EAF840E9E7C5B0D90F45A4166C1F21C7AC278843ED45420F7F6A5'
				db 'D5E4B5C9',0
A				db '3F4C7722E831E5EFC0B09D20DF41F708EF2E12E1B62D859945D6977D5BC1'
				db '0179A92A06A038A8E26A4FCFF82D29D5963E92BBEAB4373C9B9699732B1A'
				db 'EACEC356',0
;---------------------------------------------------------------------------------------------------------
.code
start:
        xor     eax,eax
    	invoke  GetModuleHandle, NULL
   		mov     hInstance, eax
   		invoke  DialogBoxParam,eax,IDD_MAINDIALOG,0,addr DlgProc,0
        invoke  ExitProcess,eax
 ret
;---------------------------------------------------------------------------------------------------------
MakeBold proc id:dword,hwnd:dword
	local mlf:LOGFONT
	local myfont:HFONT
    local temp:dword
                
	invoke SendDlgItemMessageA, hwnd, id, WM_GETFONT, 0, 0
	mov temp, eax
	invoke GetObjectA,temp,SIZEOF mlf, addr mlf
	.if eax != 0
		mov mlf.lfWeight,FW_BOLD
		invoke CreateFontIndirectA,addr mlf
		mov temp, eax
		invoke SendDlgItemMessageA,hwnd,id, WM_SETFONT, temp, 1
	.endif
	ret
MakeBold endp
;---------------------------------------------------------------------------------------------------------
CalculateSerial proc    hwnd    :HWND
local 	big_n: dword
local 	big_d: dword
local 	big_a: dword
local 	big_m: dword

        pushad
        invoke	GetDlgItemText, hwnd, IDC_NAME, addr _name, MaxNameLen
		.if eax >= MinNameLen
		
			push offset _hash
            push eax
          	push offset _name
 			call _SHA256
 			
			push    offset nSize    ; nSize
			push    offset _computer_name ; lpBuffer
			call    GetComputerNameA
			push    offset _computer_name ; char *
			call    _strlen
			push    offset _computer_name_hash
			push    eax
			push    offset _computer_name
			call    _SHA256

 			
			mov     edi, offset _hash
			mov     eax, '*EBM'
			mov     [edi], eax
			push    32
			pop     ecx
			add     edi, ecx
			mov     esi, offset _computer_name_hash
			rep movsb

			invoke	bs_create, 0
			mov		big_n,eax
			invoke	bs_create, 0
			mov		big_d,eax
			invoke	bs_create, 0
			mov		big_a,eax
			invoke	bs_create, 0
			mov		big_m,eax
			
			invoke	bs_str2big, addr N, big_n
			invoke	bs_str2big, addr D, big_d
			invoke	bs_str2big, addr A, big_a
			
			invoke	bs_byte2big, 64, addr _hash, big_m
			
			invoke	bs_sub, big_m, big_a, big_m
			
			invoke	bs_powmod, big_m, big_d, big_n, big_m
			invoke	bs_big2str, big_m, addr _serial

			
			invoke 	SetDlgItemTextA, hwnd, IDC_SERIAL, addr _serial
		 .else
			invoke  SetDlgItemTextA, hwnd, IDC_SERIAL, addr _enter_name
        .endif
        popad
        ret
CalculateSerial endp
;---------------------------------------------------------------------------------------------------------
DlgProc     proc    hwnd:dword,msg:dword,wparam:dword,lparam:dword
    .if     msg==WM_INITDIALOG
        invoke  LoadIcon, hInstance, ID_ICON    
        mov     hIcon, eax
        invoke  SendMessage, hwnd, WM_SETICON, NULL, hIcon      
        invoke  SendMessageA, hwnd, WM_SETTEXT, 0, addr szCaption
        invoke  SendDlgItemMessageA, hwnd, IDC_NAME, EM_LIMITTEXT, MaxNameLen-1,0
        ;--------
        invoke  MakeBold, IDC_NAME, hwnd
        invoke  MakeBold, IDC_SERIAL, hwnd
        invoke  MakeBold, IDC_RENNO, hwnd
        ;--------
        push	IDC_NAME
        push	hwnd
        call	GetDlgItem
        push	eax
        call	SetFocus
        ret
    .elseif msg==WM_LBUTTONDOWN
                call    ReleaseCapture
                invoke  SendMessage, [hwnd], WM_NCLBUTTONDOWN, HTCAPTION, 0
    .elseif msg==WM_CLOSE
        invoke  EndDialog,hwnd,0
        ret
    .elseif msg==WM_COMMAND
        mov     eax,wparam
        .if     ax==IDC_ABOUT
                mov MB.cbSize, sizeof MB
                mov MB.hwndOwner, NULL
                push  hInstance
                pop MB.hInstance
                mov MB.lpszText, offset szTxTAbout
                mov MB.lpszCaption, offset szCapAbout
                mov MB.dwStyle, MB_USERICON 
                mov MB.lpszIcon, ID_ICON
                mov MB.lpfnMsgBoxCallback, NULL
                invoke MessageBoxIndirect,addr MB
               .endif
        .if     ax==IDC_GENERATE
                invoke CalculateSerial,hwnd
        .endif
        .else
                        xor     eax,eax
    .endif
    ret
DlgProc     endp
;---------------------------------------------------------------------------------------------------------
end start