ASSUME CS:CODIGO, DS:DATOS, SS:PILA

;IMPRIMIR EN PANTALLA CUÁNTAS VECES APARECE LA LETRA 'A' EN UNA CADENA DE CARACTERES INGRESADA POR TECLADO. 

;RESTRICCIÓN: EL TOPE MÁXIMO ES 65535 K VECES, ES DECIR, NO CONTARÁ MÁS LETRAS As DESPUÉS DEL TOPE.

CODIGO SEGMENT	
	MOV AX,DATOS
	MOV DS,AX
	
ET2:
	MOV AH, 01H	
	INT 21H			;LECTURA DE UN CARACTER POR TECLADO.
	CMP AL, 0DH	
	JE ET1			;SI SE HA DIGITADO LA TECLA ENTER SALTA A IMPRIMIR LA CANTIDAD DE As.
	CMP AL, a
	JNE ET2
	INC K			;SI SE PRESIONA LA TECLA a, EL CONTADOR K LLEVA LA CUENTA DE LAS VECES QUE SE PRESIONA.
	JMP ET2
	;CONVERSIÓN DE B16 A B10 (la explicación está en el archivo conv.asm)
ET1:				;SE NECESITA UN SALTO DE LÍNEA PARA QUE EL RESULTADO NO APAREZCA EN LA MISMA LINEA DONDE SE DIGITA LA CADENA DE CARACTERES.
	CALL SALTOLINEA
	MOV AX, K 		;EL NÚMERO EN B16 QUE SE CONVERTIRÁ EN B10 SE MUEVE A AX (cantidad de a).
	MOV BX, 0AH		
ET4:				;SE HACE LA DIVISIÓN DEL NÚMERO EN B16 QUE ESTÁ EN AX ENTRE AH.
	CMP AX, 0H		;VERIFICA SI EL DIVISOR HA LLEGADO A CERO.
	JE ET3
	MOV DX, 0H		;SE HACE USO DE LA OPERACIÓN 1): DX:AX=AX/op EXPLICADA EN EL ARCHIVO DIV.ASM, PARA ESO DX DEBE RELLENARSE DE CEROS.
	DIV BX
	PUSH DX			;SE PONE EL RESIDUO DE LA DIVISIÓN EN LA PILA.
	INC I
	JMP ET4
ET3:
	CMP I, 0H
	JE FIN
	POP DX			;SE SACA DE LA PILA EL RESIDUO QUE SE INGRESÓ.
	ADD DL, 30H		;SE SUMA 30H AL NÚMERO QUE ESTÁ EN DL PARA HACER LA CONVERSIÓN A ASCII.
	MOV AH, 02H
	INT 21H
	DEC I
	JMP ET3
FIN:
	MOV AH, 4CH
	INT 21H        
	
			;SUBRUTINA PARA EL SALTO DE LÍNEA:
				SALTOLINEA PROC
					MOV AH,02H 
					MOV DL,0AH ;SALTO DE LÍNEA
					INT 21H
					MOV AH,02H 
					MOV DL,0DH ;RETORNO DE CARRO
					INT 21H
					RET
				SALTOLINEA ENDP
CODIGO ENDS

PILA SEGMENT STACK
	DW 32 DUP (0)
PILA ENDS

DATOS SEGMENT
;SE HACE USO DE DOS CONTADORES:
K DW 0H		;CUENTA LA CANTIDAD DE VECES QUE SE HA PRESIONADO LA TECLA A.
a DB 61H
I DW 0H		;CUENTA LA CANTIDAD DE VECES QUE SE HA INGRESADO UN DATO EN LA PILA, ESTO 
			;CON EL FIN DE QUE ESA MISMA CANTIDAD SEA SACADA DE LA PILA.
DATOS ENDS

END
