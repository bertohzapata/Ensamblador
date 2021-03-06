ASSUME CS:CODIGO, DS:DATOS, SS:PILA

;SOLUCIÓN A LA SUMATORIA (2^(n-1))*(2^n -1)

;RESTRICCIÓN: EL NÚMERO MÁXIMO DE n DEBE DE SER 8 (=32640) PARA PODER SER MOSTRADO EN PANTALLA. 

CODIGO SEGMENT	
	MOV AX,DATOS
	MOV DS,AX
	
	CALL LECTURATECLA
;SE REALIZA EL TÉRMINO DE LA IZQUIERDA DE LA MULTIPLICACIÓN: (2^(n-1)):
	MOV AX, 1
	MOV BX, 2
	MOV CX, n
	DEC CX
CICLO1:
	MUL BX
	LOOP CICLO1
ETIQ1:
	MOV M, AX			;M CONTENDRÁ EL VALOR DE 2^(n-1).
;SE REALIZA EL TÉRMINO DE LA DERECHA DE LA MULTIPLICACIÓN: (2^n -1):
	MOV AX, 1
	MOV CX, n
CICLO2:
	MUL BX
	LOOP CICLO2			;2^n
	DEC AX				;2^n-1
	MOV BX, M
	MUL BX				;SE MULTIPLICAN AMBOS TÉRMINOS.
	CALL IMPRIMIR
	MOV AH, 4CH
	INT 21H

		LECTURATECLA PROC
			MOV AH, 09H					;MUESTRA PRIMER MENSAJE.
			LEA DX, MENSAJE
			INT 21H
			MOV AH, 01H					;LECTURA DEL NÚMERO INGRESADO POR TECLADO.
			INT 21H						;TENER EN CUENTA QUE EL SERVICIO 01H AFECTA A TODO EL REGISTRO AX, 
			SUB AX, 130H					;POR ESO SE LE RESTA 100H Y EL 30H  ES POR LA CONVERSIÓN DE ASCII A DECIMAL.
			MOV DX, AX
				; TAMBIÉN PUEDE HACERSE ESTE PROCEDIMIENTO:
				; MOV AH, 0H
				; MOV DL, AL
				; SUB DL, 30H
			MOV n, DX					;EL NÚMERO INGRESADO PASA A LA VARIABLE n.
			RET
		LECTURATECLA ENDP
		
		IMPRIMIR PROC
			MOV BX, 0AH		
		ET2:					;SE HACE LA DIVISIÓN DEL NÚMERO EN B16 QUE ESTÁ EN AX / A.
			CMP AX, 0H			;COMPRUEBA SI EL DIVISOR HA LLEGADO A CERO.
			JE ET3
			MOV DX, 0H			;SE HACE USO DE LA OPERACIÓN 1) EXPLICADA EN EL ARCHIVO DIV.ASM, PARA ESO DX DEBE RELLENARSE DE CEROS.
			DIV BX
			PUSH DX				;SE PONE EL RESIDUO DE LA DIVISIÓN EN LA PILA.
			INC I
			JMP ET2
		ET3:
			CALL SALTOLINEA		
			MOV AH, 09H
			LEA DX, MENSAJE2	;MENSAJE DE SALIDA
			INT 21H
		ET1:
			CMP I, 0H
			JE FINIMRIMIR
			POP DX				;SE SACA DE LA PILA EL RESIDUO QUE SE INGRESO.
			ADD DL, 30H			;SE SUMA 30H AL NÚMERO QUE ESTÁ EN DL PARA HACER LA CONVERSIÓN A ASCII.
			MOV AH, 02H
			INT 21H
			DEC I
			JMP ET1
		FINIMRIMIR:
			RET
		IMPRIMIR ENDP
		
		SALTOLINEA PROC
				MOV AH,02H 
				MOV DL,0AH 		;SALTO DE LÍNEA
				INT 21H
				MOV AH,02H 
				MOV DL,0DH 		;RETORNO DE CARRO
				INT 21H
				RET
			SALTOLINEA ENDP
		
CODIGO ENDS

PILA SEGMENT STACK
	DW 32 DUP (0)
PILA ENDS

DATOS SEGMENT
n DW 0H 
M DW 0H
I DW 0H
MENSAJE DB "INGRESE VALOR DE n: $"
MENSAJE2 DB "EL VALOR DE S ES: $"
DATOS ENDS

END
