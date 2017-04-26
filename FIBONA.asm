ASSUME CS:CODIGO, DS:DATOS, SS:PILA

;SUCESIÓN FIBONACCI: (Realizar prueba de escritorio para observar el desarrollo del código)
 
;RESTRICCIÓN: 	*N DEBE DE SER MAYOR O IGUAL A 2.
;				*EL VALOR MÁXIMO DE N DEBE SER 23, DE LO CONTRARIO SE PASARÁ DE 2^16.				

CODIGO SEGMENT	
	MOV AX,DATOS
	MOV DS,AX
	
	MOV AX, 1				;DOS PRIMEROS VALORES INICIALES VAN A LA PILA.
	MOV BX, 1
	PUSH AX
	PUSH BX
	CALL LECTURATECLA		;INGRESO POR TECLADO DEL VALOR DE N.
	MOV CX, AX
	DEC CX					;EL CICLO LOOP DEBE DE COMENZAR EN CERO Y POR ENDE LLEGAR HASTA EL NÚMERO INGRESADO-1.
CICLO:
	MOV BP, SP				;SE HACE DIRECCIONAMIENTO INDIRECTO EN LA PILA MEDIANTE EL REGISTRO BP.
	MOV AX, [BP+2]			;RECORDAR QUE LA PILA VA HACIA DIRECCIONES BAJAS DE MEMORIA, POR ESO SE SUMA (PARA SUBIR), Y SE MUEVE DE 2 EN 2.
	MOV BX, [BP]
	ADD AX, BX
	PUSH AX
	LOOP CICLO
	POP AX					;SE SACA DE LA PILA A AX EL ÚLTIMO NÚMERO QUE SE LE INGRESÓ, ESTE ES EL RESULTADO.
	CALL IMPRIMIR
	MOV AH, 4CH
	INT 21H
	
			;SUBRUTINA PARA EL INGRESO POR TECLADO DE UN NÚMERO DE 2 DÍGITOS:
			LECTURATECLA PROC			;INGRESO DE NÚMEROS POR TECLADO.
					MOV AH, 9H
					LEA DX, MENSAJE 
					INT 21H
				ETIQ2:
					MOV AH, 01H			;(revisar archivo LECTEC.ASM)
					INT 21H
					MOV AH, 0H			;PARA QUE QUE NO INTERFIERA EL SERVICIO 01H
					CMP AL, 0DH			;EL PROGRAMA TERMINA CUANDO SE OPRIME LA TECLA ENTER O SE HA LLEGADO AL TOPE DE DÍGITOS INGRESADOS.
					JE ETIQ1
					PUSH AX
					INC N				;CUENTA LAS VECES QUE SE HA DIGITADO UN NÚMERO.
					CMP N, 2H			;SE DEFINE EL TOPE DE DÍGITOS QUE SE TIENEN QUE INGRESAR. SE HACE ESTA COMPARACIÓN EN ESTA PARTE  
					JE ETIQ1				;PARA QUE CUANDO SE LLEGUE AL TOPE DE INMEDIATO IMPRIMA Y NO SE DIGITE MÁS DIGITOS POR TECLADO.
					JMP ETIQ2
				ETIQ1:
					CMP N, 1H			;SI N=1 ES PORQUE SE HA INGRESADO UN NÚMERO DE UN DÍGITO (0-9)
					JNE ETIQ3
					POP DX
					SUB DL, 30H
					MOV AX, DX			;RESULTADO EN AX.
					JMP SALIR
				ETIQ3:
					CMP N, 2H			;SI N=2 ES PORQUE SE HA INGRESADO UN NÚMERO DE DOS DÍGITOS (10-99).
					JNE SALIR
					POP DX			
					SUB DL, 30H			;PARA CONVERTIR DE ASCII A DECIMAL.
					MOV BX, DX
					POP DX
					SUB DL, 30H
					MOV AX, DX
					MOV CX, J
					MUL CX				;MULTIPLICA POR 10^1 Y EL RESULTADO SE GUARDA EN DX/AX
					ADD AX, BX			;CONVERSIÓN DE HEXADECIMAL A DECIMAL, E IMPRESIÓN POR PANTALLA. (revisar archivo CONV.ASM)
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
					JE FIN
					POP DX				;SE SACA DE LA PILA EL RESIDUO QUE SE INGRESO.
					ADD DL, 30H			;SE SUMA 30H AL NÚMERO QUE ESTÁ EN DL PARA HACER LA CONVERSIÓN A ASCII.
					MOV AH, 02H
					INT 21H
					DEC I
					JMP ET1
				FIN:
					RET
				IMPRIMIR ENDP   
CODIGO ENDS

PILA SEGMENT STACK
	DW 32 DUP (0)
PILA ENDS

DATOS SEGMENT
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
MENSAJE DB "INGRESE N: $"
MENSAJE2 DB "EL RESULTADO ES: $"
DATOS ENDS

END
