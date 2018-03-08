; boot loader
%define BASE	0x100	; 0x0100:0x0 = 0x1000
%define KSIZE	2	; nbr de secteurs de 512 octets a charger

[BITS 16]
[ORG 0]

jmp	07C0h:start

msg  db	'Chargement du snake', 0
bootdrv db 0

%include "function.s"

start:
	mov ax, cs
	mov ds, ax
	mov es, ax
	
	mov ax, 0x8000
	mov ss, ax
	mov sp, 0xf000

	; recuperation de l'unite de boot
	mov [bootdrv], dl

	mov si, msg
	call print

	; dump le  dans la ram
	mov ax, 0
	mov dl, [bootdrv]
	int 13h ; init le disk

	push es
	mov ax, BASE
	mov es, ax
	mov bx, 0

	mov ah, 2
	mov al, KSIZE
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, [bootdrv]
	int 13h
	pop es

	; saut vers le dump
	jmp word BASE:0

times 510-($-$$) db 0	; fill the file with 0
dw 0AA55h		; End of the file with AA55
