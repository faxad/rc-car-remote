include irvine16.inc

.data

message db "RC car control",0
	
.code

main PROC
	
		mov ax,@data
		mov ds,ax
		mov es,ax
		mov cx,1	
		push cx						; stores value of cx in stack
			
	stop:	
		mov ah,0
		mov ax,0600h				; service for creating a block which can have text in it
		mov bh,(red shl 4) OR blue	; red = color of the block and blue = color of the text
		mov cx,050AH				; '050A' 0A  horizontal value and 05 vertical value
		mov dx,0940H				; same as above
		int 10h						

		mov ah,2					; for text allignment of title bar
		mov dx,0720H				; sets the position of the screen 
		mov bh,0					; 
		int 10h
		mov dx,offset message		; offset of the array which contains the string
		call writestring			; writes string stored in the array

		; LEFT BUTTON
		mov ah,0					
		mov ax,0600h				; service for creating a block which can have text in it 
		mov bh,(blue shl 4) OR red  ; blue = color of the block and red = color of the text
		mov cx,0e10H				; sets the position of the block
		mov dx,0f13H				; sets the position of the block
		int 10h	

		; BACK BUTTON
		mov ah,0
		mov ax,0600h				; service for creating a block which can have text in it 
		mov bh,(blue shl 4) OR red	; blue = color of the block and red = color of the text
		mov cx,0e15H				; sets the position of the block
		mov dx,0f33H				; sets the position of the block
		int 10h	

		;RIGHT BUTTON
		mov ah,0
		mov ax,0600h				; service for creating a block which can have text in it 
		mov bh,(blue shl 4) OR red	; blue = color of the block and red = color of the text
		mov cx,0e35H				; sets the position of the block
		mov dx,0f38H				; sets the position of the block
		int 10h	

		; FWD BUTTON		
		mov ah,0
		mov ax,0600h				; service for creating a block which can have text in it 
		mov bh,(blue shl 4) OR red	; blue = color of the block and red = color of the text
		mov cx,0b21H				; sets the position of the block
		mov dx,0d26H				; sets the position of the block
		int 10h	


		mov ebx,12000				; sets the delay 
		pop cx						; restores the value of cx

		mov ah,01h					; service for taking the input
		int 21h						


		cmp al,'8'					; if key pressed is 8
		je forward					; transfer control to forward
		cmp al,'6'					; if key pressed is 6
		je right_forward			; transfer control to right forward
		cmp al,'4'					; if key pressed is 4
		je  left_forward			; transfer control to left forward
		cmp al,'5'					; if key pressed is 5
		je reverse					; transfer control to reverse
		jmp l5						; transfer control to l5 which will stop the car
		

	forward:
	
		pushad						; push all registers into stack
		mov ah,0
		mov ax,0600h				; service for creating a block which can have text in it 
		mov bh,(red shl 4) OR red	; red = color of the block and red = color of the text
		mov cx,0b21H				; sets the position of the block
		mov dx,0d26H				; sets the position of the block
		int 10h	
		popad						; pop all registers from the stack
		
		mov ax,1					; sets the bit ON which will move the car
		mov dx,378h					; 378 is the address of the LPT port
		out dx,ax					; transfer the the bytes stored in ax to the port 378
		dec ebx						; decrement the counter for delay
		cmp ebx,0					; if the value of counter is 0 thn
		jg forward					; if value is greater than 0 than move forward
		jmp l5						; else jump to stop
		
	reverse:

		pushad						; push all registers into stack
		mov ah,0
		mov ax,0600h				; service for creating a block which can have text in it 
		mov bh,(red shl 4) OR red	; red = color of the block and red = color of the text
		mov cx,0e15H				; sets the position of the block
		mov dx,0f33H				; sets the position of the block
		int 10h	
		popad						; pop all registers from the stack
		
		mov ax,00000100b			; sets the bit ON which will move the car
		mov dx,378h					; 378 is the address of the LPT port
		out dx,ax					; transfer the the bytes stored in ax to the port 378
		dec ebx						; decrement the counter for delay
		cmp ebx,0					; if the value of counter is 0 thn
		jg reverse					; if value is greater than 0 than move REVERSE
		jmp l5						; else jump to stop

	left_forward:

		pushad						; push all registers into stack
		mov ah,0
		mov ax,0600h				; service for creating a block which can have text in it 
		mov bh,(red shl 4) OR red	; red = color of the block and red = color of the text
		mov cx,0e10H				; sets the position of the block
		mov dx,0f13H				; sets the position of the block
		int 10h
		popad						; pop all registers from the stack
					
		mov ax,00000011b			; sets the bit ON which will move the car
		mov dx,378h					; 378 is the address of the LPT port
		out dx,ax					; transfer the the bytes stored in ax to the port 378
		dec ebx						; decrement the counter for delay
		cmp ebx,0					; if the value of counter is 0 thn
		jg  left_forward			; if value is greater than 0 than move left forward
		jmp l5						; else jump to stop
	
	right_forward:

		pushad						; push all registers into stack
		mov ah,0
		mov ax,0600h				; service for creating a block which can have text in it 
		mov bh,(red shl 4) OR red	; red = color of the block and red = color of the text
		mov cx,0e35H				; sets the position of the block
		mov dx,0f38H				; sets the position of the block
		int 10h	
		popad						; pop all registers from the stack

		mov ax,00001001b			; sets the bit ON which will move the car
		mov dx,378h					; 378 is the address of the LPT port
		out dx,ax					; transfer the the bytes stored in ax to the port 378
		dec ebx						; decrement the counter for delay
		cmp ebx,0					; if the value of counter is 0 thn		
		jg right_forward			; if value is greater than 0 than move left right forward
		jmp l5						; else jump to stop

	L5:
		mov ax,0					; sets the bit ON which will move the car
		mov dx,378h					; 378 is the address of the LPT port
		out dx,ax					; transfer the the bytes stored in ax to the port 378

		mov ebx,12000				; again set the counter for delay
		jmp stop					; loop back to jump
		
		exit


main ENDP
END main