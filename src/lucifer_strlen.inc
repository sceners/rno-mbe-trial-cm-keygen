;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
; push	str
; call  _strlen
;
; oblicza dlugosc stringa
;
; na wejsciu:
; str - wskaznik do stringa
;
; na wyjsciu:
; eax - dlugosc stringa
;
; modyfikowane rejestry:
; brak
;
; Lucifer
;컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴asmpak�

_strlen proc	uses esi ebx, str_:dword
	mov	esi,str_		; SI =	string pointer
	xor	ebx,ebx			; init counter to 0
s1_loop:
	lodsb				; load char
	test	al,al			; loop while char not zero
	jz	sl_done
	inc	ebx			; increment length counter
	jmp	s1_loop
sl_done:
	mov	eax,ebx
	ret				; return length
_strlen  endp