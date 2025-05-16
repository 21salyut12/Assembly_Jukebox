.org 3000h

	ld hl, LOGIN_CNT
	ld (hl), 000h

START_UP:					; If key "9" is pressed run program as admin
	ld ix, DISP_START		; If key "8" is pressed run program as user
	call SCAN
	cp 09h
	jp z, LOGIN
	
	cp 08h
	jp z, DISP_MENU
	
ON_NEXT:
	ld ix, JUKEBOX_MENU
	call SCAN
	cp 04h
	jp DISP_NEXT_SONG

OFF_NEXT:
	ld ix, DISP_OFF_NEXT
	call SCAN
	cp 04h
	jp DISP_PREV_SONG
	
ADM_SWITCH:
	ld ix , OFF_ON_TEXT
	call SCAN 
	cp 13h		 			; If key "F1" is pressed function next remains on
	jp z, ON_NEXT
	cp 1Fh          		; If key "F5" is pressed turn off function next
	jp z, OFF_NEXT	

DISP_START: 				; Turns on all 7 segment displays
	.db 0FFh
	.db 0FFh
	.db 0FFh
	.db 0FFh
	.db 0FFh
	.db 0FFh
	
LOGIN:						; Confirming that the program will be run as admin
    ld ix, DISP_ADM
    call SCAN
    cp 00h
    jp MSGIN_INIT
	
DISP_ADM: 					; Displays the message "Admin"
    .db 023h
    .db 020h
    .db 023h
    .db 023h
    .db 0B3h
    .db 03fh
	
MSGIN_INIT:
	ld hl, MSGIN_DISP_BLOCK
	ld (hl), 000h
	inc hl
	ld (hl), 000h
	inc hl
	ld (hl), 000h
	inc hl
	ld (hl), 0aeh
	inc hl
	ld (hl), 03fh
	inc hl
	ld (hl), 01fh
	
	jp PASSIN_START
	
PASSIN_START:
	ld hl, PASSIN_USR_PASS
	ld (hl), 000h
	inc hl
	ld (hl), 000h
	inc hl
	ld (hl), 000h

PASSIN_MSG_CHAR1:	
	ld ix, MSGIN_DISP_BLOCK
	call PASSIN_SCAN
	
PASSIN_SAVE_CHAR1:
	ld hl, PASSIN_USR_PASS
	ld (hl), a
	
PASSIN_DISP_CHAR1:
	ld iy, MSGIN_DISP_BLOCK
	ld b, 0
	ld c, 2
	add iy, bc
	ld (iy), 002h ;-
	
PASSIN_MSG_CHAR2:	
	ld ix, MSGIN_DISP_BLOCK
	call PASSIN_SCAN
	
PASSIN_SAVE_CHAR2:
	ld hl, PASSIN_USR_PASS
	inc hl
	ld (hl), a
	
PASSIN_DISP_CHAR2:
	ld iy, MSGIN_DISP_BLOCK
	ld b, 0
	ld c, 1
	add iy, bc
	ld (iy), 002h ;-
	
PASSIN_MSG_CHAR3:	
	ld ix, MSGIN_DISP_BLOCK
	call PASSIN_SCAN
	
PASSIN_SAVE_CHAR3:
	ld hl, PASSIN_USR_PASS
	inc hl
	inc hl
	ld (hl), a
	
PASSIN_DISP_CHAR3:
	ld iy, MSGIN_DISP_BLOCK
	ld (iy), 002h ;-

PASSIN_DISP_FINAL:
	ld ix, MSGIN_DISP_BLOCK
	call PASSIN_SCAN

	jp PASSCHECK_START

PASSCHECK_PRESET_PASS:			; Admin password (123)
	.db 001h
	.db 002h
	.db 003h

PASSCHECK_START:
	ld hl, PASSCHECK_PRESET_PASS
	ld de, PASSIN_USR_PASS
	ld a, (de)
	cp (hl)
	jr nz, PASSCHECK_FINAL_NE
	inc hl
	inc de
	ld a, (de)
	cp (hl)
	jr nz, PASSCHECK_FINAL_NE
	inc hl
	inc de
	ld a, (de)
	cp (hl)
	jr nz, PASSCHECK_FINAL_NE
	jr PASSCHECK_FINAL_E

PASSCHECK_FINAL_NE:
	ld hl, LOGIN_CNT
	ld a ,(hl)
	inc a
	ld (hl), a
	cp 3
	jr z, ADM_USR_SELECT
	jp MSGIN_INIT
	
PASSCHECK_FINAL_E:
	jp ADM_SWITCH
	
PASSIN_SCAN  .equ 05feh   

ADM_USR_SELECT:			
	ld ix, TEST_PASS_DISP_COUNTER
	call MSGIN_SCAN
	jr z, JUKEBOX_MENU

DISP_MENU:					; Load in index ix the display of the jukebox menu
	ld ix, JUKEBOX_MENU 	; If key "1" is pressed display 1st song in the playlist
	call SCAN
	cp 01h
	jp nz, SONG_1
	
JUKEBOX_MENU: 				; Displays the jukebox menu 
	.db 0B8h				; ] next song
    .db 035h				; || pause the current song
	.db 08Dh				; [ previous song
	.db 000h
	.db 085h
	.db 01Fh

SONG_1: 					; Displays 1st song
	.db 005h
	.db 000h
	.db 0BEh
	.db 023h
	.db 0A3h
	.db 0AEh
	
SONG_2: 					; Displays 2nd song
	.db 09Bh
	.db 000h
	.db 0BEh
	.db 023h
	.db 0A3h
	.db 0AEh
	
SONG_3:                 	; Displays 3rd song
	.db 0BAh
	.db 000h
	.db 0BEh
	.db 023h
	.db 0A3h
	.db 0AEh
	
SONG_4:                 	; Displays 4th song
	.db 036h
	.db 000h
	.db 0BEh
	.db 023h
	.db 0A3h
	.db 0AEh

SONG_5:                 	; Displays 5th song
	.db 0AEh
	.db 000h
	.db 0BEh
	.db 023h
	.db 0A3h
	.db 0AEh
	
PAUSE_DISPLAY: 				; Displays "PAUSE"
	.db 000h
	.db 08Fh
	.db 0AEh
	.db 0B5h
	.db 03Fh
	.db 01Fh
	
OFF_ON_TEXT:				; Displays "OFF", "ON"
		
	.db 00Fh
	.db 00Fh
	.db 0BDh
	.db 000h
	.db 03Dh
	.db 0BDh
	
DISP_OFF_NEXT: 				; Displays the jukebox menu 
	.db 000h				; ] next song
    .db 035h				; || pause the current song
	.db 08Dh				; [ previous song
	.db 000h
	.db 085h
	.db 01Fh
	
DISP_PAUSE:	
	ld ix, PAUSE_DISPLAY    ; Load in index ix  the display values of PAUSE_DISPLAY
	call SCAN           	; If key "2" is pressed display the "PAUSE" message
	cp 02h
	jp z, DISP_PAUSE
	
DISP_NEXT_SONG:				; Load in index ix the display values of each song		
	ld ix, SONG_1			; If key "4" is pressed display the next song		
	call SCAN
	cp 04h
	jp nz, SONG_2

	ld ix, SONG_2
	call SCAN
	cp 04h
	jp nz, SONG_3

	ld ix, SONG_3
	call SCAN
	cp 04h
	jp nz, SONG_4
	
	ld ix, SONG_4
	call SCAN
	cp 04h
	jp nz, SONG_5
	
DISP_PREV_SONG:	
	ld ix, SONG_5		; Load in index ix the display values of each song
	call SCAN			; If key "3" is pressed display the previous song
	cp 03h 
	jp nz, SONG_4

	ld ix, SONG_4
	call SCAN
	cp 03h
	jp nz, SONG_3
	
	ld ix, SONG_3
	call SCAN
	cp 03h
	jp nz, SONG_2

	ld ix, SONG_2
	call SCAN
	cp 03h
	jp nz, SONG_1
	
	ld ix, SONG_1
	call SCAN
	cp 03h
	jp DISP_PREV_SONG
	
SCAN .equ 05feh

TEST_PASS_DISP_COUNTER: ; Displays the message "Error" if the password is not guessed in 3 tries 
	.db 000h
	.db 003h
	.db 0A3h
	.db 003h
	.db 003h
	.db 08Fh

MSGIN_SCAN  .equ 05feh 
   
SCAN1 .equ 0624h

.org 1800h
MSGIN_DISP_BLOCK: 
	.db 000h
	.db 000h
	.db 000h
	.db 0aeh 			; "S"
	.db 03fh			; "A"
	.db 01fh 			; "P"

PASSIN_USR_PASS:
	.ds 3

LOGIN_CNT:
	.ds 1

.end
    rst 38h