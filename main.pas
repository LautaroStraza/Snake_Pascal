program Snake_Pascal; (* Nombre del programa *)
(*
    Lautaro Barba
    Programa: Snake para terminal hecho en pascal.
              2018
*)

uses	 (* Unidades/Librerias que usa el programa *)
	crt,
	subprogramas;

const
	TITULO_PROGRAMA = 'Snake';

var	(* Declaración de variables y su uso *)

	key: char; 		(* Almacena la tecla presionada *)
	arrow: boolean;		(* Controla que la tecla presionada sea una flecha *)
	matriz: array of array of char;	(* Dibuja el escenario de la partida *)
	seleccion: byte;	(* Almacena la opción ingresada en el menu *)

	(* El siguiente array guarda el tipo y la posición de todos los nodos de la serpiente *)
	cuerpo: array of array [1..3] of integer;
	(* De este modo puedo leer
	cuaquier nodo del cuerpo de la serpiente como:
			cuerpo[nodo, 1]= tipo_de_nodo;
					-1: Cabeza.
					 0: Cuerpo..
					 1: Cola.
	cuya posición sera:
			cuerpo[nodo, 2]= pos_x;
			cuerpo[nodo, 3]= pos_y;	*)

	nodos: integer;		(* Almacena la cantidad maxima de partes de la serpiente *)
	filas, columnas: integer; 	(* Para definir el tamaño de la matriz *)
	f, c: integer; 	(* Indices para imprimir la matriz *)
	pos_x, pos_y: integer; (* Indices de proposito general *)
	indice: integer; (* Para buscar dentro del cuerpo cual es la cola y la cabeza *)
	aux: integer; (* Para buscar dentro del cuerpo cual es la cola y la cabeza *)
	continuar: boolean; (* Condición para continuar la partida *)
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

begin	(* Inicio programa principal *)
	Crear_Entorno(TITULO_PROGRAMA);

	(* Inicializo variables *)
	filas:= screenheight - 8; (* Defino la cantidad de filas según la ventana *)
        columnas:= screenwidth - 3; (*Defino la cantidad de columnas según la ventana *)
        SetLength(matriz, filas + 1, columnas); (* Defino el tamaño de la matriz *)
	(* Defino la cantidad de nodos máximos de la serpiente, que dependerá del tamaño de la matriz *)
	nodos:= filas * columnas; 
	(* Inicializo el cuerpo de Snake *)
        SetLength(cuerpo, nodos); (* Defino el tamaño de la matriz *)

	(* Muestro menu principal *)
	repeat
        seleccion:= Menu();
        case (seleccion) of
            1:
		begin (*Comienzo una nueva partida *)
		
		(* Inicializo variables *)
		arrow:= false;
		continuar:= true;
		puntos:= 0;
		ultimo_movimiento:= 72; (* Comienza el juego moviendose hacia arriba *)

		(* Inicializo la serpiente *)
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


		(* Edito primera fila de la matriz *)
		for c:=1 to columnas do
			matriz[1,c]:= '1';

		(* Edito última fila de la matriz *)
		for c:=1 to columnas do
			matriz[filas,c]:= '1';

		(* Selecciono la posición inicial de la cabeza en el centro de la pantalla *)
		pos_x:= filas div 2;
		pos_y:= columnas div 2;

		cuerpo[1,1]:= -1; (* Nodo cabeza de serpiente *)
		cuerpo[1,2]:= pos_x;
		cuerpo[1,3]:= pos_y;

		cuerpo[2,1]:= 1; (* Nodo cabeza de serpiente *)
		cuerpo[2,2]:= pos_x;
		cuerpo[2,3]:= pos_y - 1 ;

		(* Dibujo los dos nodos iniciales de la serpiente en la matriz *)
		matriz[cuerpo[1,2], cuerpo[1,3]]:= 'X';
		matriz[cuerpo[2,2], cuerpo[2,3]]:= 'X';

		(* Imprimo la matriz completa una vez *)
		for f:=1 to filas do
			begin
			for c:=1 to columnas do
				begin
				Write(matriz[f,c]);
				end;
			WriteLn();
			end;


		repeat

		(* Imprimo los cambios de la matriz y espero que se precione una tecla *)
		for f:=1 to filas do
			begin
			for c:=1 to columnas do
				begin
				if (matriz[f,c] <> ' ') then
					begin
					gotoxy(c,f);
					Write(matriz[f,c]);
					end;
				end;
			gotoxy(1,filas+1);
			end;

		(* Sumo puntos cada vuelta *)
		puntos:= puntos + 1;
		write('Puntaje: ',puntos);

		(* Agrego comida aleatoriamente *)
		pos_x:= random(columnas-1)+1;
		pos_y:= random(filas-1)+1;

		(* La primera condición evalua si hay espacio
			y la segunda es una manera de controlar el tiempo *)
		if (matriz[pos_y, pos_x] = ' ') and (puntos mod 50 = 0) then
			matriz[pos_y, pos_x]:= 'o';

		Delay(100);	(* Tiempo entre vueltas / Tiempo entre "FPS's" *)

		if (KeyPressed()) then				(* Solo leo la tecla si se apreto en ese momento *)
			begin
			key:= ReadKey();			(* Guardo en "key" la tecla presionada *)
			if ord(key) = 0 then				(* Los caracteres especiales comienzan con este valor *)
				begin
				key:= ReadKey();			(* Tengo que leer dos veces para saber el valor del caracter especial *)
				arrow:= ord(key) in [72, 80, 75, 77];	(* Si el valor de la tecla corresponde a una flecha lo acepto como opción *)
				if (arrow) then 	(*Condicionales para que no moverse hacia atras *)
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

			(* Las opciones a seguir para cada flecha presionada *)
			case ultimo_movimiento of
				72:
					begin (* Arriba *)
					ultimo_movimiento:= 72;
					(* Busco el nodo de la cola para borrarlo y asignar la cola en la posición del nodo anterior *)
					for indice:= nodos downto 2 do
						begin
						if (cuerpo[indice,1] = 1) then (* Nodo de la cola *)
							begin
							if (matriz[cuerpo[1,2]-1, cuerpo[1,3]] = 'o') then (* Dejo que crezca si el punto sobre la cabeza era comida *)
									begin
									matriz[cuerpo[indice,2], cuerpo[indice,3]]:= ' '; (* Limpio la posición vieja *)
									gotoxy(cuerpo[indice,3], cuerpo[indice,2]);
									Write(matriz[cuerpo[indice,2], cuerpo[indice,3]]);
									gotoxy(1,filas+1);
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
									gotoxy(cuerpo[indice,3], cuerpo[indice,2]);
									Write(matriz[cuerpo[indice,2], cuerpo[indice,3]]);
									gotoxy(1,filas+1);
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
							if (cuerpo[indice,2] > 1) then (* Controlo que esté dentro del espacio disponible *)
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
					(* Busco el nodo de la cola para borrarlo y asignar la cola en la posición del nodo anterior *)
					for indice:= nodos downto 2 do
						begin
						if (cuerpo[indice,1] = 1) then (* Nodo de la cola *)
							begin
							if (matriz[cuerpo[1,2]+1, cuerpo[1,3]] = 'o') then (* Dejo que crezca si el punto debajo de la cabeza era comida *)
									begin
									matriz[cuerpo[indice,2], cuerpo[indice,3]]:= ' '; (* Limpio la posición vieja *)
									gotoxy(cuerpo[indice,3], cuerpo[indice,2]);
									Write(matriz[cuerpo[indice,2], cuerpo[indice,3]]);
									gotoxy(1,filas+1);
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
									gotoxy(cuerpo[indice,3], cuerpo[indice,2]);
									Write(matriz[cuerpo[indice,2], cuerpo[indice,3]]);
									gotoxy(1,filas+1);
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
							if (cuerpo[indice,2] < filas) then (* Controlo que esté dentro del espacio disponible *)
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
					(* Busco el nodo de la cola para borrarlo y asignar la cola en la posición del nodo anterior *)
					for indice:= nodos downto 2 do
						begin
						if (cuerpo[indice,1] = 1) then (* Nodo de la cola *)
							begin
							if (matriz[cuerpo[1,2], cuerpo[1,3]-1] = 'o') then (* Dejo que crezca si el punto a la izquierda de la cabeza era comida *)
									begin
									matriz[cuerpo[indice,2], cuerpo[indice,3]]:= ' '; (* Limpio la posición vieja *)
									gotoxy(cuerpo[indice,3], cuerpo[indice,2]);
									Write(matriz[cuerpo[indice,2], cuerpo[indice,3]]);
									gotoxy(1,filas+1);
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
									gotoxy(cuerpo[indice,3], cuerpo[indice,2]);
									Write(matriz[cuerpo[indice,2], cuerpo[indice,3]]);
									gotoxy(1,filas+1);
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
							if (cuerpo[indice,3] > 0) then (* Controlo que esté dentro del espacio disponible *)
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
					(* Busco el nodo de la cola para borrarlo y asignar la cola en la posición del nodo anterior *)
					for indice:= nodos downto 2 do
						begin
						if (cuerpo[indice,1] = 1) then (* Nodo de la cola *)
							begin
							if (matriz[cuerpo[1,2], cuerpo[1,3]+1] = 'o') then (* Dejo que crezca si el punto a la derecha de la cabeza era comida *)
									begin
									matriz[cuerpo[indice,2], cuerpo[indice,3]]:= ' '; (* Limpio la posición vieja *)
									gotoxy(cuerpo[indice,3], cuerpo[indice,2]);
									Write(matriz[cuerpo[indice,2], cuerpo[indice,3]]);
									gotoxy(1,filas+1);
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
									gotoxy(cuerpo[indice,3], cuerpo[indice,2]);
									Write(matriz[cuerpo[indice,2], cuerpo[indice,3]]);
									gotoxy(1,filas+1);
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
							if (cuerpo[indice,3] < columnas + 1) then (* Controlo que esté dentro del espacio disponible *)
								cuerpo[indice,3]:= cuerpo[indice,3] + 1 ;
							if (cuerpo[indice,3] = columnas +1) then
								continuar:= false;
							matriz[cuerpo[indice,2], cuerpo[indice,3]]:= 'X'; (* Marco la nueva posicón *)
							end;
						end;
					end;
				end;
		until (continuar <> true); 		(* Condición continuar/terminar la partida *)
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
