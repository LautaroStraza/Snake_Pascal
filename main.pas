program Plantilla; (* Nombre del programa *)
(*
    Lautaro Barba
    Programa: 
*)

uses (* Unidades/Librerias que usa el programa *)
    crt,
    Subprogramas;

const
    TITULO_PROGRAMA = 'Snake';

var
	key: char;
	arrow: boolean;
	matriz: array of array of char;
	filas, columnas: integer; (* Para definir el tamaño de la matriz *)
	f, c: integer; (* Indices para imprimir la matriz *)
	cabeza_x, cabeza_y: integer;(* Indices para moverme dentro de la matriz *)
	cola_x, cola_y: integer;(* Indices para moverme dentro de la matriz *)
	continuar: boolean;
	ultimo_movimiento: integer;

(* Inicio de procedimientos y funciones particulares del programa *)




(* Final de procedimientos y funciones particulares del programa *)

begin (* Inicio programa principal *)
	Crear_Entorno(TITULO_PROGRAMA);

	(* Inicializo variables *)
	arrow:= false;
	filas:= screenheight - 8; (* Defino la cantidad de filas según la ventana *)
        columnas:= screenwidth - 3; (*Defino la cantidad de columnas según la ventana *)
        SetLength(matriz, filas + 1, columnas); (* Defino el tamaño de la matriz *)
	continuar:= true; (* Condición para seguir jugando *)
	ultimo_movimiento:= 72;

        (* Inicializo la matriz *)
        for f:=1 to filas do
                begin
                for c:=1 to columnas do
                        begin
                        matriz[f,c]:= '.';
                        end;
                end;

	(* Edito primera fila *)
        for c:=1 to columnas do
                matriz[1,c]:= '1';

        (* Edito última fila *)
        for c:=1 to columnas do
                matriz[filas,c]:= '1';

	WriteLn('Cantidad de filas:',filas);
        WriteLn('Cantidad de columnas:',columnas);
        WriteLn();

	(* Elijo la posición inicial de la marca *)
	cabeza_x:= random(filas);
	if (cabeza_x = 1) then
		cabeza_x:= cabeza_x + 1
	else if (cabeza_x = filas) then
		cabeza_x:= cabeza_x - 2;
	cola_x:= cabeza_x - 1;
	cabeza_y:= random(columnas);
	cola_y:= cabeza_y;
	matriz[cabeza_x, cabeza_y]:= 'X';
	matriz[cola_x, cola_y]:= 'X';
	
	(* Selecciono opción *)
	repeat
		(* Imprimo la matriz y espero a que se precione una tecla *)
		for f:=1 to filas do
			begin
			for c:=1 to columnas do
				begin
				Write(matriz[f,c]);
				end;
			WriteLn();
			end;
		
		Delay(100);					(* Tiempo entre "FPS's" *)

		if (KeyPressed()) then				(* Solo leo la tecla si se apreto algo ese segundo *)
			begin
			key:= ReadKey();			(* Guardo en "key" la tecla presionada *)
			if ord(key) = 0 then				(* Los caracteres especiales comienzan con este valor *)
				begin
				key:= ReadKey();			(* Tengo que leer dos veces para saber el valor del caracter especial *)
				arrow:= ord(key) in [72, 80, 75, 77];	(* Si el valor de la tecla corresponde a una flecha lo acepto como opción *)
				if (arrow) then 	(*Condicionales para que no pueda volver para atras *)
					begin
					case ord(key) of
					72: (*arriba*)
						begin
						if (ultimo_movimiento <> 80) then
							ultimo_movimiento:= ord(key);
						end;
					80: (*abajo*)
						begin
						if (ultimo_movimiento <> 72) then
							ultimo_movimiento:= ord(key);
						end;
					75: (*izquierda*)
						begin
						if (ultimo_movimiento <> 77) then
							ultimo_movimiento:= ord(key);
						end;
					77: (*derecha*)
						begin
						if (ultimo_movimiento <> 75) then
							ultimo_movimiento:= ord(key);
						end;
					end;
					end;
				end
			else
				begin
				arrow:= false;
				end;
			end;
		
		case ultimo_movimiento of			(* Las opciones a seguir para cada flecjha *)
			72: 
				begin
				(*WriteLn('arriba');*)
				ultimo_movimiento:= 72;
				matriz[cola_x, cola_y]:= '.'; (* Limpio la posición vieja *)
				cola_x:= cabeza_x;
				cola_y:= cabeza_y;
				if (cabeza_x > 1) then
					cabeza_x:= cabeza_x - 1 ;
				if (cabeza_x = 1) then
					continuar:= false;
				matriz[cabeza_x, cabeza_y]:= 'X';	(* Marco la nueva posición *)
				end;
			80: 
				begin
				(*WriteLn('abajo');*)
				ultimo_movimiento:= 80;
				matriz[cola_x, cola_y]:= '.'; (* Limpio la posición vieja *)
				cola_x:= cabeza_x;
				cola_y:= cabeza_y;
				if (cabeza_x < filas) then
					cabeza_x:= cabeza_x + 1 ;
				if (cabeza_x = filas) then
					continuar:= false;
				matriz[cabeza_x, cabeza_y]:= 'X';	(* Marco la nueva posición *)
				end;
			75:
				begin
				(*WriteLn('izquierda');*)
				ultimo_movimiento:= 75;
				matriz[cola_x, cola_y]:= '.'; (* Limpio la posición vieja *)
				cola_x:= cabeza_x;
				cola_y:= cabeza_y;
				if (cabeza_y > 0) then
					cabeza_y:= cabeza_y - 1 ;
				if (cabeza_y = 0) then
					continuar:= false;
				matriz[cabeza_x, cabeza_y]:= 'X';	(* Marco la nueva posición *)
				end;
			77: 
				begin
				(*WriteLn('derecha');*)
				ultimo_movimiento:= 77;
				matriz[cola_x, cola_y]:= '.'; (* Limpio la posición vieja *)
				cola_x:= cabeza_x;
				cola_y:= cabeza_y;
				if (cabeza_y < columnas + 1) then
					cabeza_y:= cabeza_y + 1 ;
				if (cabeza_y = columnas + 1) then
					continuar:= false;
				matriz[cabeza_x, cabeza_y]:= 'X';	(* Marco la nueva posición *)
				end;
			end;
	until (continuar <> true); 					(* El valor de la tecla especial enter es 13, lo uso para salir *)
	ClrScr();
	WriteLn('Puntuación final: ');
	WriteLn('Enter para salir...');
	ReadLn();

(* Finalizo programa principal *)
end.
