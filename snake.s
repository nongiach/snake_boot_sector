; kernel.s
[BITS 16]
[ORG 0]


mov ax, 0x100
mov ds, ax
mov es, ax

mov ax, 0x8000
mov ss, ax
mov sp, 0xf000

jmp start

msg  db	'<-----------Snake----------->', 0
msg1 db '  GAME OVER', 0

dir equ 0
speed equ 0x99FF

x equ 1
y equ 2
_x equ 3
_y equ 4

lx equ 5
ly equ 6

%include "function.s"

gere_key	:
left:	cmp ax, 4B00h
	jne right
	mov byte [dir], 0
	jmp _gerekey
right:	cmp ax, 4D00h
	jne up
	mov byte [dir], 1
	jmp _gerekey
up:	cmp ax, 4800h
	jne down
	mov byte [dir], 2
	jmp _gerekey
down:	cmp ax, 5000h
	jne n
	mov byte [dir], 3
	jmp _gerekey
n:	cmp ax, 'n'
	jne _gerekey
	mov si, 0
_gerekey:
	ret

move: ; dir dl, x al, y, bh
m_left:	cmp dl, 0
	jne m_right
	dec al
	jmp _move
m_right:cmp dl, 1
	jne m_up
	inc al
	jmp _move
m_up:	cmp dl, 2
	jne m_down
	dec ah
	jmp _move
m_down:	cmp dl, 3
	jne _move
	inc ah
	jmp _move
_move:
	ret

aff_snake:
	mov dl, byte [x] ; aff '0'
	mov dh, byte [y]
	call putcurs
	call getchar
	push ax

	mov al, 'O'
	mov bl, 1
	call putchar
	
	mov dl, byte [lx] ; aff '#'
	mov dh, byte [ly]
	call putcurs
	mov al, byte [dir]
	add al, 23h
	mov bl, 1
	call putchar
	mov al, byte [x]
	mov byte [lx], al
	mov al, byte [y]
	mov byte [ly], al

	pop ax
	cmp al, '@'
	je add_item
	cmp al, ' '
	jne game_over


	mov dl, byte [_x] ; aff ' '
	mov dh, byte [_y]
	call putcurs
	
	call getchar
	mov dl, al

	mov al, ' '
	mov bl, 1
	call putchar

	sub dl, 23h
	mov al, byte [_x]
	mov ah, byte [_y]
	call move
	mov byte [_x], al
	mov byte [_y], ah

_aff_snake:
	ret

add_item:
	mov si, 16
add_item_:
	mov dx, [speed]
	add dx, 3
	mov [speed], dx
	call random
	mov dh, ah
	push dx
	call random
	pop dx
	mov dl, ah
	call putcurs
	mov al, '@'
	mov bl, 0xA
	call putchar
	cmp si, 0
	dec si
	jne add_item_
	ret
	
start:
	mov ax, cs
	mov ds, ax
	mov es, ax

	;mov ah, 1
	;mov ch, 1
	;mov cl, 1     sensed disable vursor
	;int 10h
	mov dx, 0
init:   ; clear screen
	call putcurs
	mov al, ' '
	mov ah, 9
	mov bh, 0
	mov cx, 0xFF
	int 10h
	inc dh
	cmp dh, 0xFF
	jne init

	
	mov dl, 26
	mov dh, 2
	call putcurs
	
	;mov si, msg
	;call print
	
	mov byte [x], 5
	mov byte [y], 5
	mov byte [lx], 4
	mov byte [ly], 5
	mov byte [_x], 4
	mov byte [_y], 5
	mov byte [dir], 1
	call add_item

boucle:
	call aff_snake
	call getkey_
	call gere_key

	mov dl, byte [dir]
	mov al, byte [x]
	mov ah, byte [y]
	call move
	mov byte [x], al
	mov byte [y], ah

	mov cx, 1
	mov dx, [speed]
	call sleep
	mov dl, 3
	mov dh, 3
	call putcurs
	mov ax, [speed]
;	call putnbr
	jmp boucle

game_over:
	mov dl, 30
	mov dh, 11
	call putcurs
	mov si, msg1
	call print
	call getkey
	cmp al, ' '
	je start
	jmp game_over

