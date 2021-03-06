ASSUME CS:CODIGO, DS:DATOS, SS:PILA

;IMPRIMIR DE FORMA INVERTIDA, EN PANTALLA, UNA CADENA DE CARACTERES INGRESADA POR TECLADO (USAR LA PILA DEL PROGRAMA)

CODIGO SEGMENT	
	MOV AX,DATOS
	MOV DS,AX
	
ET1:
	MOV AH, 01H		;LECTURA DE UN CARACTER POR TECLADO
	INT 21H
	CMP AL, 0DH 
	JE ET2 			;CUANDO SE PRESIONE LA TECLA ENTER SALTA PARA IMPRIMIR LA CADENA INVERTIDA
	PUSH AX 		;PONE EL REGISTRO AX EN LA PILA
	INC K 			;CONTADOR K PARA LLEVAR EL CONTEO DE LOS CARACTERES INGRESADOS A LA PILA.
	JMP ET1
ET2:
	CMP K, 0H		;DEJA DE IMPRIMIR CARACTERES CUANDO EL CONTADOR K HALLA LLEGADO A CERO.
	JE FIN
	POP BX			;SACA VALORES DE LA PILA Y LOS PONE EN EL REGISTRO BX
	MOV DL, BL		;SÓLO OBTIENE LA PARTE BAJA DE BX, BL, PORQUE ALLÍ ESTÁ EL CARACTER ASCII INGRESADO EN AL PREVIAMENTE
	MOV AH, 2H
	INT 21H
	DEC K
	JMP ET2
FIN:
	MOV AH,4Ch  
	INT 21h         
	
		;CONCLUSIONES:
			;SE USA LA PILA PARA ALMACENAR UNA VARIABLE DINÁMICA.
			;SE PONE EL REGISTRO AX EN LA PILA, EN LA LÍNEA 14, PORQUE EL CARACTER EN FORMATO ASCII SE GUARDA EN EL REGISTRO AL Y LA PILA SÓLO
				;ACEPTA REGISTROS DE 16 BITS.
			;SE USA UN CONTADOR K CON EL FIN DE QUE LLEVE EL CONTEO DE CUÁNTOS CARACTERES SE HAN INGRESADO A LA PILA PARA QUE CUANDO SE SAQUEN VALORES
				;SE SEPA CUÁNTOS SE DEBEN DE SACAR Y POR ENDE DE IMPRIMIR.

CODIGO ENDS

PILA SEGMENT STACK
	DW 32 DUP (0)
PILA ENDS

DATOS SEGMENT
K DB 0H
DATOS ENDS

END
