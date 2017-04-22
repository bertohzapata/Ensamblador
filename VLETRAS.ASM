;Ingresa Caracteres por Teclado y al dar ENTER, devuelve la frase alrevés

ASSUME CS:CODIGO, DS:DATOS, SS:PILA

CODIGO SEGMENT	
        MOV AX,DATOS
		MOV DS,AX
		
		MOV CX, 100 ;CX va relacionado con el  LOOP la cantidad de veces que se repite el bucle. En este caso puede ser 100 o más 
		MOV	BX, 0 ;Va a ser el puntero. Se inicia en cero. 
	
		;Ingresa por Teclado
bucle: 	MOV AH,01H
		INT 21H
			
		MOV Array[BX],AX ;El Valor AX se Guarda en Array[BX]
		INC BX ;Suma 1 en BX 
		
		CMP AL,0DH ;Si es igual a un ENTER que vaya a la Etiqueta Imprimir
			JE Imprimir
			JMP bucle
			
Imprimir:		
		MOV DX,Array[BX] ;Mueves los Valores del Arreglo a DX 
        MOV AH,02H ;Función para Imprimir el Caracter
        INT 21H
		
		CMP BX,0 ;Si el Arreglo llega a su Posición 0 se debe terminar el Ciclo
			JE E1
			JMP E2
		
E2:		DEC BX ;Decrementa Bx para Imprimir Los Valores o Caracteres Alrevés 
	
		LOOP Imprimir	
		
E1:		MOV AH,4Ch  
        INT 21h         
CODIGO ENDS

PILA SEGMENT STACK
        DW 32 DUP (0)
		 
PILA ENDS

DATOS SEGMENT

	Array DW 100 DUP(?) ;Arreglo de 5  El DUP es un Duplicador de Cadenas
	
	;100 Sería el Tamaño del Arreglo, pero con DUP se duplica, seria 200 espacios en el Vector
	
DATOS ENDS

END
