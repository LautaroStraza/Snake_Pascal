unit Subprogramas; (* Nombre de la Unidad/Libreria *)

interface (* Encabezados de los subprogramas *)
	procedure Enmarcar_Pantalla ();
	procedure Enmarcar_Titulo (const titulo: string);
	procedure Crear_Ventana();
	procedure Crear_Entorno(const titulo: string);

implementation (* Desarrollo de los subprogramas *)
uses (* Unidades/Librerias que usan los subprogramas *)
	crt,
	strings;

(* Procedimiento que recibe un título como string
	 y lo enmarca en el centro de la ventana *)
procedure Enmarcar_Titulo (const titulo: string);
(* Para este procedimiento es necesario usar la unidad strings *)
var
	puntero_titulo: ^char;
	longitud: integer;
	indice: integer;
	ancho_ventana: integer;
	espacio_blanco: integer;
begin   
	(* Guardo la longitud del título *)
	puntero_titulo:= Addr(titulo[1]);
	longitud:= StrLen(puntero_titulo);

	(* Guardo la longitud de la ventana *)
	ancho_ventana:= screenwidth; (* Reviso el ancho de la ventana actual *)
	espacio_blanco:= (ancho_ventana div 2) - (longitud div 2);

	gotoxy(1,2); (* Posiciono el cursor al comienzo del primer renglón *)
  
	(* Dibujo el marco de arriba *)
	Write('|');
	for indice:= 1 to (espacio_blanco - 1) do
		Write(' ');
	for indice := 1 to (longitud + 4) do
		Write('-');
	WriteLn();
    
	(* Inserto el título con marcos laterales *)
	Write('|');
	for indice:= 1 to (espacio_blanco - 1) do
		Write(' ');
	WriteLn('| ', titulo,' |');

	(* Dibujo el marco de abajo *)
	write('|');
	for indice:= 1 to (espacio_blanco - 1) do
		Write(' ');
	for indice := 1 to (longitud + 4) do
		Write('-');
	WriteLn();

	(* Dibujo el segundo marco de abajo *)
	for indice:= 1 to ancho_ventana do
		Write('#');
	WriteLn();
end;

(* Procedimiento que enmarca la pantalla del programa *)
procedure Enmarcar_Pantalla ();
var 
    aux, altura, ancho: integer;
begin
	altura:= screenheight; (* Reviso la altura de la ventana actual *)
	ancho:= screenwidth; (* Reviso el ancho de la ventana actual *)
	
	ClrScr();
	gotoxy(1,1); (* Dibujo el marco de arriba *)
	for aux:= 1 to ancho do
		Write('#');

	for aux:= 2 to altura-1 do (* Dibujo el marco de la izquierda *)
		begin
		gotoxy(1,aux);
		Write('|');
		end;

	for aux:= 2 to altura-1 do (* Dibujo el marco de la derecha *)
		begin
		gotoxy(ancho,aux);
		Write('|');
		end;

	gotoxy(1,altura-1); (* Dibujo el marco de abajo *)
	for aux:= 1 to ancho do
		Write('#');

	gotoxy(2,2); (* Posiciono el cursor al comienzo del primer renglón *)
end;

(* Procedimiento para crear la ventana de trabajo *)
procedure Crear_Ventana ();
var
	altura, ancho: integer;
begin
	altura:= screenheight; (* Reviso la altura de la ventana actual *)
	ancho:= screenwidth; (* Reviso el ancho de la ventana actual *)
	Window(2,6,ancho -1,altura-2); (* Inicia en las coordenadas (2,6) para no pisar el marco *)
	gotoxy(1,1); (* Posiciono el cursor al comienzo del primer renglón *)
end;

(* Procedimiento para limpiar la pantalla y mostrar el nombre del programa *)
procedure Crear_Entorno(const titulo: string);
begin
    Enmarcar_Pantalla();
    Enmarcar_Titulo(titulo);
    Crear_Ventana();
end;


initialization	(* Instrucciones que se ejecutaran al cargar la unidad *) 
begin
	ClrScr();
end;
 
finalization	(* Instrucciones que se ejecutaran al finalizar el programa *)
begin
	(* Destruyo la ventana interna construida para el programa *)
	Window(1,1,screenwidth,screenheight);
	gotoxy(screenwidth,screenheight-1);
	WriteLn();
	WriteLn('Dews!');
	ClrScr();
end;
 
end.
