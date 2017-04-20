ASSUME CS:CODIGO, DS:DATOS, SS:PILA

;MULTIPLICACIÓN DE DOS NÚMEROS SIN LA INSTRUCCIÓN MUL (USO DE LAS SUMAS SUCESIVAS).
;TENER EN CUENTA QUE PARA QUE EL RESULTADO SEA MOSTRADO EN PANTALLA ESTE NO DEBE DE SOBREPASAR EL TOPE DE 2^16.

CODIGO SEGMENT	
	MOV AX,DATOS
	MOV DS,AX
	
ETIQ2:
	CALL LECTURATECLA	;LECTURATECLA NECESITA HACER USO DEL CONTADOR D.
	CMP D, 1H
	JNE ETIQ1
	MOV A, AX
	MOV N, 0H			;REINICIO
	CALL SALTOLINEA
	JMP ETIQ2
ETIQ1:
	CMP D, 2H
	JNE FIN
	MOV B, AX
	;MULTIPLICACIÓN (SUMAS SUCESIVAS):
	MOV AX, A
	DEC B				;SE HACE UN CICLO CON EL SEGUNDO NÚMERO QUE SE INGRESA-1.
	MOV CX, B
CICLO:
	ADD AX, A			
	LOOP CICLO
	CALL IMPRIMIR
FIN:
	MOV AH, 4CH
	INT 21H
	
			;SUBRUTINA PARA EL INGRESO POR TECLADO DE UN NÚMERO DE 3 DÍGITOS:
			LECTURATECLA PROC		;INGRESO DE NÚMEROS POR TECLADO.
				MOV AH, 9H
				LEA DX, MENSAJE 
				INT 21H
			ETQ2:
				MOV AH, 01H			;(revisar archivo LECTEC.ASM)
				INT 21H
				MOV AH, 0H			;PARA QUE QUE NO INTERFIERA EL SERVICIO 01H
				CMP AL, 0DH			;EL PROGRAMA TERMINA CUANDO SE OPRIME LA TECLA ENTER O SE HA LLEGADO AL TOPE DE DÍGITOS INGRESADOS.
				JE ETQ1
				PUSH AX
				INC N				;CUENTA LAS VECES QUE SE HA DIGITADO UN NÚMERO.
				CMP N, 3H			;SE DEFINE EL TOPE DE DÍGITOS QUE SE TIENEN QUE INGRESAR. SE HACE ESTA COMPARACIÓN EN ESTA PARTE PARA QUE CUANDO SE LLEGUE 
				JE ETQ1			;AL TOPE DE INMEDIATO IMPRIMA Y NO SE DIGITE MÁS DIGITOS POR TECLADO.
				JMP ETQ2
			ETQ1:
				CMP N, 1H			;SI N=1 ES PORQUE SE HA INGRESADO UN NÚMERO DE UN DÍGITO (0-9)
				JNE ETQ3
				POP DX
				SUB DL, 30H
				MOV AX, DX			;RESULTADO EN AX.
				INC D
				JMP SALIR
			ETQ3:
				CMP N, 2H			;SI N=2 ES PORQUE SE HA INGRESADO UN NÚMERO DE DOS DÍGITOS (10-99).
				JNE ETQ4
				POP DX			
				SUB DL, 30H			;PARA CONVERTIR DE ASCII A DECIMAL.
				MOV BX, DX
				POP DX
				SUB DL, 30H
				MOV AX, DX
				MOV CX, J
				MUL CX				;MULTIPLICA POR 10^1 Y EL RESULTADO SE GUARDA EN DX/AX
				ADD AX, BX			;CONVERSIÓN DE HEXADECIMAL A DECIMAL, E IMPRESIÓN POR PANTALLA. (revisar archivo CONV.ASM)
				INC D
				JMP SALIR
			ETQ4:
				CMP N, 3H			;SI N=3 ES PORQUE SE HAN INGRESADO UN NÚMERO DE TRES DÍGITOS (100-999).
				JNE SALIR
				POP DX			
				SUB DL, 30H			;PARA CONVERTIR DE ASCII A DECIMAL.
				MOV BX, DX			;EL PRIMER VALOR QUE SE SACA DE LA PILA SE GUARDA EN BX.
				POP DX
				SUB DL, 30H
				MOV AX, DX
				MOV CX, J
				MUL CX
				MOV M, AX			;EL SEGUNDO VALOR QUE SE SACA DE LA PILA SE GUARDA EN M.
				POP DX
				SUB DL, 30H
				MOV AX, DX
				MOV CX, K			;MULTIPLICA POR 10^2 Y EL RESULTADO SE GUARDA EN DX/AX
				MUL CX
				ADD AX, M
				ADD AX, BX			;SE HACE LA OPERACIÓN AX+BX+M.
				INC D
				JMP SALIR
			SALIR:
				RET
			LECTURATECLA ENDP	

			SALTOLINEA PROC
				MOV AH,02H 
				MOV DL,0AH 			;SALTO DE LÍNEA
				INT 21H
				MOV AH,02H 
				MOV DL,0DH 			;RETORNO DE CARRO
				INT 21H
				RET
			SALTOLINEA ENDP
			
			IMPRIMIR PROC
				MOV BX, 0AH		
			ET2:					;SE HACE LA DIVISIÓN DEL NÚMERO EN B16 QUE ESTÁ EN AX / A.
				CMP AX, 0H			;COMPRUEBA SI EL DIVISOR HA LLEGADO A CERO.
				JE ET3
				MOV DX, 0H			;SE HACE USO DE LA OPERACIÓN 1) EXPLICADA EN EL ARCHIVO DIV.ASM, PARA ESO DX DEBE RELLENARSE DE CEROS EN CADA CICLO.
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
				JE FINIMPRIMIR
				POP DX				;SE SACA DE LA PILA EL RESIDUO QUE SE INGRESO.
				ADD DL, 30H			;SE SUMA 30H AL NÚMERO QUE ESTÁ EN DL PARA HACER LA CONVERSIÓN A ASCII.
				MOV AH, 02H
				INT 21H
				DEC I
				JMP ET1
			FINIMPRIMIR:
				RET
			IMPRIMIR ENDP       
CODIGO ENDS

PILA SEGMENT STACK
	DW 32 DUP (0)
PILA ENDS

DATOS SEGMENT
A DW 0H				;GUARDA EL RESULTADO DEL PRIMER NÚMERO INGRESADO.
B DW 0H				;GUARDA EL RESULTADO DEL SEGUNDO NÚMERO INGRESADO.
;VARIABLES PARA LA UNIÓN DE LOS NÚMEROS.
J DW 10
K DW 100
P DW 1000
;CONTADORES:
N DB 0H				;CUENTA LAS VECES QUE SE HA INGRESADO UN NÚMERO.
I DB 0H				;CONTADOR DE LA SUBRUTINA PARA IMPRIMIR EL RESULTADO EN DECIMAL.
D DW 0H				;D ES EL CONTADOR QUE LLEVA LA CUENTA DE LAS VECES QUE SE HAN INGRESADO LOS NÚMEROS PARA SER SUMADOS. EN ESTE CASO EL VALOR 
						;MÁXIMO DE D ES 2 YA QUE SE DEBEN DE SUMAR DOS NÚMEROS. SU USO SE IMPLEMENTA EN LA ETIQUETA FIN1.
;VARIABLES DONDE SE ALMACENAN RESULTADOS:
M DW 0H				;SE ALMACENA EL VALOR MULTIPLICADO POR 10.
O DW 0H				;SE ALMACENA EL VALOR MULTIPLICADO POR 100.
MENSAJE DB "INGRESE UN NUMERO: $"
MENSAJE2 DB "LA MULTIPLICACION ES: $"
DATOS ENDS

END
