program Snake_Pascal; (* Nombre del programa *)
(*
    Lautaro Barba
    Programa: Snake para terminal hecho en pascal.
              2018
*)

uses	 (* Unidades/Librerias que usa el programa *)
    crt,
    Subprogramas;

const
    TITULO_PROGRAMA = 'Snake';

var	(* Declaración de variables y su uso *)

	key: char; 		
	arrow: boolean;
	matriz: array of array of char;
	seleccion: byte;

	(* El siguiente vector guardara la siguiente información:
		cuerpo[Nodo_serpiente, tipo_de_Nodo, pos_X, pos_Y] *)
	cuerpo: array of array [1..3] of integer;
	(* Defino un índice para leer dentro del cuerpo de la serpiente *)
	nodos: integer;
	(* De este modo puedo referirme
	a la cabeza de la serpiente como:
			cuerpo[1, 1]= -1;
	cuya posición sera:
			cuerpo[1, 2]= pos_x;
			cuerpo[1, 3]= pos_y;

	a cuaquier nodo del cuerpo de la serpiente como:
			cuerpo[nodos, 1]= 0;
	cuya posición sera:
			cuerpo[nodos, 2]= pos_x;
			cuerpo[nodos, 3]= pos_y;
	a la cola de la serpiente como:
			cuerpo[nodos, 1]= 1;
	cuya posición sera:
			cuerpo[nodos, 2]= pos_x;
			cuerpo[nodos, 3]= pos_y; *)

	filas, columnas: integer; (* Para definir el tamaño de la matriz *)
	f, c: integer; (* Indices para imprimir la matriz *)
	pos_x, pos_y: integer;(* Indices para moverme dentro de la matriz *)
	indice: integer; (* Para buscar dentro del cuerpo cual es la cola o la cabeza *)
	aux: integer; (* Para buscar dentro del cuerpo cual es la cola o la cabeza *)
	continuar: boolean;
	ultimo_movimiento: integer;
	puntos: integer;

(* Inicio de procedimientos y funciones particulares del programa *)

(* Función para mostrar menu y devolver la selección *)
function Menu(): byte;
var
    valida: boolean;
    error: boolean;
begin
    valida:= false;
    error:= false;
    repeat
        ClrScr();
        if (error) then
            begin
            WriteLn('Opcion Ingresada Incorrecta!!');
            WriteLn();
        end;
        WriteLn('Seleccione una opción:');
        WriteLn('1- Jugar');
        WriteLn('2- Score');
        WriteLn('3- Salir');
        Write('?:');
        ReadLn(Menu);

        (* En el if cambiar opción máxima si es necesario *)
        if ((Menu > 0) and (Menu < 4 (* cantidad de opciones *))) then
            valida:= true
        else
            error:= true;
    until (valida);
end;

(* Final de procedimientos y funciones particulares del programa *)

begin (* Inicio programa principal *)
	Crear_Entorno(TITULO_PROGRAMA);

	(* Inicializo variables *)
	arrow:= false;
	filas:= screenheight - 8; (* Defino la cantidad de filas según la ventana *)
        columnas:= screenwidth - 3; (*Defino la cantidad de columnas según la ventana *)
        SetLength(matriz, filas + 1, columnas); (* Defino el tamaño de la matriz *)
	continuar:= true; (* Condición para seguir jugando *)
	ultimo_movimiento:= 72; (* Comienza el juego moviendose hacia arriba *)
	puntos:= 0;

	nodos:= filas * columnas; (* Defino la cantidad de nodos máximos de la serpiente, que dependerá del tamaño de la matriz *)
	(* Inicializo el cuerpo de Snake *)
        SetLength(cuerpo, nodos); (* Defino el tamaño de la matriz *)
	for f:=1 to nodos do
		begin
		cuerpo[f, 1]:= 0;
		cuerpo[f, 2]:= 0;
		cuerpo[f, 3]:= 0;
		end;


        (* Inicializo la matriz *)
        for f:=1 to filas do
                begin
                for c:=1 to columnas do
                        begin
                        matriz[f,c]:= ' ';
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

	(* Elijo la posición inicial de la cabeza en el centro de la pantalla*)
	pos_x:= filas div 2;
	pos_y:= columnas div 2;

	cuerpo[1,1]:= -1; (* Nodo cabeza de serpiente *)
	cuerpo[1,2]:= pos_x;
	cuerpo[1,3]:= pos_y;

	cuerpo[2,1]:= 1; (* Nodo cabeza de serpiente *)
	cuerpo[2,2]:= pos_x;
	cuerpo[2,3]:= pos_y - 1 ;

	matriz[cuerpo[1,2], cuerpo[1,3]]:= 'X';
	matriz[cuerpo[2,2], cuerpo[2,3]]:= 'X';

	(* Muestro menu con opciones *)
	repeat
        seleccion:= Menu();
        case (seleccion) of
            1:
		begin
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

			puntos:= puntos + 1;

			(* Agrego comida aleatoriamente *)
			pos_x:= random(columnas-1)+1;
			pos_y:= random(filas-1)+1;
			if (matriz[pos_y, pos_x] = ' ') and (puntos mod 50 = 0) then
				matriz[pos_y, pos_x]:= 'o';

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
					begin (* Arriba *)
					ultimo_movimiento:= 72;
					(* Busco el nodo cola para borrarlo y asignar la cola en la posición del nodo anterior *)
					for indice:= nodos downto 2 do
						begin
						if (cuerpo[indice,1] = 1) then (* Nodo de la cola *)
							begin
							if (matriz[cuerpo[1,2]-1, cuerpo[1,3]] = 'o') then (* Dejo que crezca si el punto sobre la cabeza era comida *)
									begin
									matriz[cuerpo[indice,2], cuerpo[indice,3]]:= ' '; (* Limpio la posición vieja *)
									cuerpo[indice,1]:= 0; (* La cola se vuelve un nodo común *)
									cuerpo[indice+1,1]:= 1; (* Se agrega un nodo y se convierte en la nueva cola *)
									for aux:=indice+1 downto 2 do
										begin
										cuerpo[aux,2]:= cuerpo[aux-1,2];
										cuerpo[aux,3]:= cuerpo[aux-1,3];
										end;
									end
								else
									begin
									matriz[cuerpo[indice,2], cuerpo[indice,3]]:= ' '; (* Limpio la posición vieja *)
									for aux:=indice downto 2 do
										begin
										cuerpo[aux,2]:= cuerpo[aux-1,2];
										cuerpo[aux,3]:= cuerpo[aux-1,3];
										end;
									end;
							end;
						if (matriz[cuerpo[1,2]-1, cuerpo[1,3]] = 'X') then (* Para perder la partida si se pisa a si mismo *)
								continuar:= false;
						end;
					(* Busco el nodo cabeza para asignarle una nueva posición *)
					for indice:= 1 to nodos do
						begin
						if (cuerpo[indice,1] = -1) then (* Nodo de la cabeza *)
							begin

							if (cuerpo[indice,2] > 1) then
								cuerpo[indice,2]:= cuerpo[indice,2] - 1 ;
							if (cuerpo[indice,2] = 1) then
								continuar:= false;
							matriz[cuerpo[indice,2], cuerpo[indice,3]]:= 'X'; (* Marco la nueva posicón *)
							end;
						end;
					end;
				80:
					begin (* Abajo *)
					ultimo_movimiento:= 80;
					(* Busco el nodo cola para borrarlo y asignar la cola en la posición del nodo anterior *)
					for indice:= nodos downto 2 do
						begin
						if (cuerpo[indice,1] = 1) then (* Nodo de la cola *)
							begin
							if (matriz[cuerpo[1,2]+1, cuerpo[1,3]] = 'o') then (* Dejo que crezca si el punto debajo de la cabeza era comida *)
									begin
									matriz[cuerpo[indice,2], cuerpo[indice,3]]:= ' '; (* Limpio la posición vieja *)
									cuerpo[indice,1]:= 0; (* La cola se vuelve un nodo común *)
									cuerpo[indice+1,1]:= 1; (* Se agrega un nodo y se convierte en la nueva cola *)
									for aux:=indice+1 downto 2 do
										begin
										cuerpo[aux,2]:= cuerpo[aux-1,2];
										cuerpo[aux,3]:= cuerpo[aux-1,3];
										end;
									end
								else
									begin
									matriz[cuerpo[indice,2], cuerpo[indice,3]]:= ' '; (* Limpio la posición vieja *)
									for aux:=indice downto 2 do
										begin
										cuerpo[aux,2]:= cuerpo[aux-1,2];
										cuerpo[aux,3]:= cuerpo[aux-1,3];
										end;
									end;
							end;
						if (matriz[cuerpo[1,2]+1, cuerpo[1,3]] = 'X') then (* Para perder la partida si se pisa a si mismo *)
								continuar:= false;
						end;
					(* Busco el nodo cabeza para asignarle una nueva posición *)
					for indice:= 1 to nodos do
						begin
						if (cuerpo[indice,1] = -1) then (* Nodo de la cabeza *)
							begin

							if (cuerpo[indice,2] < filas) then
								cuerpo[indice,2]:= cuerpo[indice,2] + 1 ;
							if (cuerpo[indice,2] = filas) then
								continuar:= false;
							matriz[cuerpo[indice,2], cuerpo[indice,3]]:= 'X'; (* Marco la nueva posicón *)
							end;
						end;
					end;
				75:
					begin (* Izquierda *)
					ultimo_movimiento:= 75;
					(* Busco el nodo cola para borrarlo y asignar la cola en la posición del nodo anterior *)
					for indice:= nodos downto 2 do
						begin
						if (cuerpo[indice,1] = 1) then (* Nodo de la cola *)
							begin
							if (matriz[cuerpo[1,2], cuerpo[1,3]-1] = 'o') then (* Dejo que crezca si el punto a la izquierda de la cabeza era comida *)
									begin
									matriz[cuerpo[indice,2], cuerpo[indice,3]]:= ' '; (* Limpio la posición vieja *)
									cuerpo[indice,1]:= 0; (* La cola se vuelve un nodo común *)
									cuerpo[indice+1,1]:= 1; (* Se agrega un nodo y se convierte en la nueva cola *)
									for aux:=indice+1 downto 2 do
										begin
										cuerpo[aux,2]:= cuerpo[aux-1,2];
										cuerpo[aux,3]:= cuerpo[aux-1,3];
										end;
									end
								else
									begin
									matriz[cuerpo[indice,2], cuerpo[indice,3]]:= ' '; (* Limpio la posición vieja *)
									for aux:=indice downto 2 do
										begin
										cuerpo[aux,2]:= cuerpo[aux-1,2];
										cuerpo[aux,3]:= cuerpo[aux-1,3];
										end;
									end;
							end;
						if (matriz[cuerpo[1,2], cuerpo[1,3]-1] = 'X') then (* Para perder la partida si se pisa a si mismo *)
								continuar:= false;
						end;
					(* Busco el nodo cabeza para asignarle una nueva posición *)
					for indice:= 1 to nodos do
						begin
						if (cuerpo[indice,1] = -1) then (* Nodo de la cabeza *)
							begin

							if (cuerpo[indice,3] > 0) then
								cuerpo[indice,3]:= cuerpo[indice,3] - 1 ;
							if (cuerpo[indice,3] = 0) then
								continuar:= false;
							matriz[cuerpo[indice,2], cuerpo[indice,3]]:= 'X'; (* Marco la nueva posicón *)
							end;
						end;
					end;
				77:
					begin (* Derecha *)
					ultimo_movimiento:= 77;
					(* Busco el nodo cola para borrarlo y asignar la cola en la posición del nodo anterior *)
					for indice:= nodos downto 2 do
						begin
						if (cuerpo[indice,1] = 1) then (* Nodo de la cola *)
							begin
							if (matriz[cuerpo[1,2], cuerpo[1,3]+1] = 'o') then (* Dejo que crezca si el punto a la derecha de la cabeza era comida *)
									begin
									matriz[cuerpo[indice,2], cuerpo[indice,3]]:= ' '; (* Limpio la posición vieja *)
									cuerpo[indice,1]:= 0; (* La cola se vuelve un nodo común *)
									cuerpo[indice+1,1]:= 1; (* Se agrega un nodo y se convierte en la nueva cola *)
									for aux:=indice+1 downto 2 do
										begin
										cuerpo[aux,2]:= cuerpo[aux-1,2];
										cuerpo[aux,3]:= cuerpo[aux-1,3];
										end;
									end
								else
									begin
									matriz[cuerpo[indice,2], cuerpo[indice,3]]:= ' '; (* Limpio la posición vieja *)
									for aux:=indice downto 2 do
										begin
										cuerpo[aux,2]:= cuerpo[aux-1,2];
										cuerpo[aux,3]:= cuerpo[aux-1,3];
										end;
									end;
							end;
						if (matriz[cuerpo[1,2], cuerpo[1,3]+1] = 'X') then (* Para perder la partida si se pisa a si mismo *)
								continuar:= false;
						end;
					(* Busco el nodo cabeza para asignarle una nueva posición *)
					for indice:= 1 to nodos do
						begin
						if (cuerpo[indice,1] = -1) then (* Nodo de la cabeza *)
							begin

							if (cuerpo[indice,3] < columnas + 1) then
								cuerpo[indice,3]:= cuerpo[indice,3] + 1 ;
							if (cuerpo[indice,3] = columnas +1) then
								continuar:= false;
							matriz[cuerpo[indice,2], cuerpo[indice,3]]:= 'X'; (* Marco la nueva posicón *)
							end;
						end;
					end;
				end;
		until (continuar <> true); 					(* Condición continuar termina la partida *)
		ClrScr();
		WriteLn('Puntuación final: ', puntos);
		WriteLn('Enter para salir...');
		ReadLn();
		end;
	2:
		begin
		ClrScr();
		WriteLn('Aca debería mostrar la tabla de puntuaciones');
		WriteLn('     hecha usando un archivo de texto');
		WriteLn('Enter para salir...');
		ReadLn();
		end;
	end;
	until(seleccion = 3 (* opcion salida menu *));
	ClrScr();
	WriteLn('Dews!');

(* Finalizo programa principal *)
end.
