ASSUME CS:CODIGO, DS:DATOS, SS:PILA

;DADO UN VECTOR DE 10 (O MÁS) ELEMENTOS DE 8 BITS CADA UNO DETERMINE QUÉ ELEMENTO ES EL MÁXIMO DE LA LISTA E IMPRIMIR EL RESULTADO EN HEXADECIMAL:
;(La lógica de este programa está en el cuaderno)

;NOTA: 	UN VECTOR EN ENSAMBLADOR SE PUEDE HACER DE DOS FORMAS: COMO LA QUE SE HIZO EN ESTE CÓDIGO O COMO 
;		LA QUE SE HACE EN EL CÓDIGO ALMVEC.ASM

CODIGO SEGMENT	
	MOV AX,DATOS
	MOV DS,AX
	
	MOV BX, 0
	MOV CX, 9				;EL CICLO FOR SERÍA: TAMAÑO DEL VECTOR-1.
	MOV DL, VECTOR[BX]		;EL RESULTADO O NÚMERO MAYOR DEL VECTOR SE ALMACENA EN LA PARTE BAJA DE DX.
CICLO:
	CMP DL, VECTOR[BX+1]
	JAE ETIQ1				;EL MAYOR O IGUAL ES PARA QUE SE PUEDA INCLUIR LAS REPETICIONES DEL NÚMERO MAYOR SIN AFECTAR EL RESULTADO.
	MOV DL, VECTOR[BX+1]
ETIQ1:
	INC BX
	LOOP CICLO
	MOV H, DL				;LA VARIABLE H TOMA EL VALOR DE DL (DONDE ESTÁ ALMACENADO EL RESULTADO).
	CALL TRANSFORMAR
	MOV AH, 4CH
	INT 21H     
			
			;PREVIAMENTE EL VALOR A CONVERTIR DEBE DE ESTAR ALMENADO EN LA VARIABLE H:
			;NO SE TOMA TODO EL CÓDIGO DE IMPRIMIR_HEXADECIMAL PORQUE EN ESTE CASO SON NÚMEROS DE 8 BITS, POR ESO, EN VEZ DE DX SE USA DL Y
				;LAS DEFINICIONES DE LAS VARIABLES D Y E SON EN DB.
			TRANSFORMAR PROC
				MOV AH, 09H
				LEA DX, MENSAJE
				INT 21H
				MOV DL, H			
				AND DL, D
				ROR DL, 4
				CALL IMPRIMIR_HEXADECIMAL
				MOV DL, H			
				AND DL, E
				;ROR DX, 0			;LA ROTACIÓN DE BITS A LA DERECHA VA DECREMENTANDO DE 4 EN 4.
				CALL IMPRIMIR_HEXADECIMAL
				RET
			TRANSFORMAR ENDP
	
			;SUBRUTINA QUE IMPRIME UN NÚMERO EN HEXADECIMAL 
			IMPRIMIR_HEXADECIMAL PROC		
				CMP DL, 09H
				JG IMP1
				ADD DL, 30H			;EN EL CASO QUE SE DEBA IMPRIMIR UN DÍGITO ENTRE 0 Y 9.
				JMP IMP2
			IMP1:
				ADD DL, 37H			;EN EL CASO QUE SE DEBA IMPRIMIR UN DÍGITO ENTRE A Y F.
			IMP2:
				MOV AH, 2H
				INT 21H
				RET
			IMPRIMIR_HEXADECIMAL ENDP
CODIGO ENDS

PILA SEGMENT STACK
	DW 32 DUP (0)
PILA ENDS

DATOS SEGMENT
;VECTOR DE TAMAÑO 10:
VECTOR DB 15H,2,3,9,5,9,7,61H,61H,9
H DB 0H							;EN H SE ALMACENARÁ EL NÚMERO A MOSTRAR POR PANTALLA.
D DB 000F0H
E DB 0000FH
MENSAJE DB "EL RESULTADO ES: $"
DATOS ENDS

END
