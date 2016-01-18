PROGRAM tienda;

CONST{main}
    NCTIPO = 15; {número caracteres tipo}
    NCIDENTIFICADOR = 4; {número caracteres del identificador del componente}
    MAXPC = 25; {número de ordenadores (PC) máximos en la tienda}
    MAXCOMPONENTES = 100; {número de componentes sueltos máximo}
    MIN = 1;

TYPE{main}
    tTipo = string[NCTIPO]; {Tipo para almacenar el tipo del componente}
    tIdentificador = string[NCIDENTIFICADOR]; {Para almacenar el identificador}
    tNumComponentes = MIN..MAXCOMPONENTES; {Para almacenar el índice de componentes}
    tNumPc = MIN..MAXPC; {Tipo para almacenar el índice de ordenadores}

    tComponente = RECORD {Tipo para almacenar un producto}
  		tipo: tTipo;
  		id: tIdentificador;
  		descripcion: string;
  		precio : real;
			END;

    tPc = RECORD {Tipo para almacenar un ordenador}
  		datos, memoria, procesador, discoDuro: tComponente;
			END;

    tListaComponentes= ARRAY [tNumComponentes] OF tComponente;

    tListaPcs = ARRAY [tNumPc] OF tPc;

    tAlmacenComponentes = RECORD {Almacén de componentes}
  		listaComponentes : tListaComponentes;
  		tope: integer;
			END;

    tAlmacenPcs = RECORD {Almacén de Pcs}
  		listaPcs : tListaPcs;
  		tope: integer;
			END;

    tTienda = RECORD {Tienda}
  		almacenPcs : tAlmacenPcs;
  		almacenComponentes: tAlmacenComponentes;
  		ventasTotales: real; {Almacena el total de la ventas}
			END;

	tFicheroPcs = FILE OF tPc;
	tFicheroComponentes = FILE OF tComponente;

 VAR{main}
 	opcion : char;
 	iden : string;
	tienda : tTienda;
	fichComp : string;
	fichOrd : string;

{Ordenar LOS ORDENADORES por precio de menor a mayor }
PROCEDURE ordenar (VAR tienda: tTienda);{Por precio}
VAR
	i,j : integer;
	pctemp : tPc;
BEGIN{Ordenar}
	WITH tienda.almacenPcs DO BEGIN
		FOR i := 1 TO pred(tope) DO BEGIN
			j := succ(i);
			IF listaPcs[i].datos.precio > listaPcs[j].datos.precio THEN BEGIN{IF}
				pctemp := listaPcs[i];
				listaPcs[i] := listaPcs[j];
				listaPcs[j] := pctemp;
			END;{IF}
		END;{FOR i}
	END; {WITH}
END; {Ordenar}

{Muestra los IDs de los ordenadores}
PROCEDURE oMostrarID(tienda : tTienda);
VAR
	i : integer;
BEGIN
	WITH tienda.almacenPCs DO BEGIN
		write('IDs disponibles (');
		FOR i := 1 TO tope DO BEGIN
			IF i = tope THEN
				write(listaPCs[i].datos.id)
			ELSE
				write(listaPCs[i].datos.id, ', ');
		END;{FOR}
		write(')');
		writeln();{ESPACIO}
	END; {WITH}
END; {oMostrarID}

{Muestra los IDs de los componentes}
PROCEDURE cMostrarID(tienda : tTienda);
VAR
	i : integer;
BEGIN
	WITH tienda.almacenPCs DO BEGIN
		write('IDs disponibles (');
		FOR i := 1 TO tope DO BEGIN
			IF i = tope THEN
				write(listaPCs[i].datos.id)
			ELSE
				write(listaPCs[i].datos.id, ', ');
		END;{FOR}
		write(')');
		writeln();{ESPACIO}
	END; {WITH}
END; {cMostrarID}

{para ver si UN COMPONENTE existe o no, lo buscamos por su identificador}
FUNCTION cBuscarID(tienda: tTienda; a: string): boolean;
VAR{BuscarID componente}
	i: integer;
BEGIN{BuscarID componente}
	cBuscarID := FALSE;{al principio suponemos que no existe}
	FOR i := MIN TO MAXCOMPONENTES DO
		IF (tienda.almacenComponentes.listaComponentes[i].id = a) THEN
			cBuscarID := TRUE;{si existe, la funcion va ser verdadera}
END;{BuscarID componente}

{para ver si UN ORDENADOR existe o no, lo buscamos por su identificador}
FUNCTION oBuscarID(tienda: tTienda; a: string): boolean;
VAR{BuscarID ordenador}
	i: integer;
BEGIN{BuscarID ordenador}
	oBuscarID := FALSE;{al principio suponemos que no existe}
	FOR i := MIN TO MAXPC DO
		IF (tienda.almacenPcs.listaPcs[i].datos.id = a) THEN
			oBuscarID := TRUE;{si existe, la funcion va ser verdadera}
END;{BuscarID ordenador}

{indica la posicion DE UN COMPONENTE en el almacen}
FUNCTION cIndicar(tienda: tTienda; a: string): integer;
VAR{CIndicar}
	i,j: integer;
BEGIN{CIndicar}
	WITH tienda.almacenComponentes DO BEGIN
		FOR i := 1 TO tope DO
			IF a = listaComponentes[i].id THEN
				j := i;
		cIndicar := j;
	END; {WITH}
END;{cIndicar}

{Indica la posicion DE UN ORDENADOR en el almacen}
FUNCTION oIndicar(tienda: tTienda; a: string): integer;
VAR{oIndicar}
	i,j:integer;
BEGIN{oIndicar}
	WITH tienda.almacenPcs DO BEGIN
		FOR i := 1 TO tope DO
			IF a = listaPcs[i].datos.id THEN
				j := i;
		oIndicar := j;
	END; {WITH}
END;{oIndicar}

{Permite vender un componente de la tienda}
PROCEDURE cVender(VAR tienda: tTienda; id: string);{vender un componente}
VAR{CVender}
	k,j: integer;
BEGIN{CVender}
	WITH tienda DO BEGIN
		k := cIndicar(tienda, id); {nos hace falta saber la posicion del componente, pero en formato INTEGER}
		ventasTotales := ventasTotales + almacenComponentes.listaComponentes[k].precio;
		FOR j := k TO almacenComponentes.tope DO
		 	 almacenComponentes.listaComponentes[j] := almacenComponentes.listaComponentes[j+1];
		almacenComponentes.tope := almacenComponentes.tope - 1;
	END; {WITH}
	writeln('Componente con el identificador ', id,' vendido.');{para confirmacion}
END;{CVender}


{Permite vender un ordenador segun su id}
PROCEDURE oVender(VAR tienda: tTienda; id: string);{vender un ordenador}
VAR{OVender UN ORDENADOR}
	k,j: integer;
BEGIN{OVender}
	k := OIndicar(tienda, id);{nos hace falta saber la posicion del componente, pero en formato INTEGER}
	tienda.ventasTotales := tienda.ventasTotales + tienda.almacenPcs.listaPcs[k].datos.precio;
	FOR j := k TO tienda.almacenPcs.tope DO
	 	 tienda.almacenPcs.listaPcs[j] := tienda.almacenPcs.listaPcs[j+1];
	tienda.almacenPcs.tope := tienda.almacenPcs.tope - 1;
	writeln('Ordenador con el identificador ', id,' vendido.');{para confirmacion}
END;{OVender}

{Robert Alexandru Dobre}
{Permite dar de alta un nuevo componente en la tienda}
PROCEDURE darAltaComp(VAR tienda : tTienda);{dar alta un componente}
VAR{DarAltaComp}
	c : char;
	componente : tComponente;
	error : boolean;
	i : integer; {Validar correcta conversion}
	j : real; {Validar correcta conversion en precio}
	str : string; {Entrada del ID}
	code : integer; {Comprobar que es correcta la entrada de datos}
BEGIN{DarAltaComp}
	writeln();
	REPEAT
		write('Elija el tipo componente <PROCESADOR, MEMORIA, DISCO DURO>: ');
		readln(componente.tipo);
		componente.tipo := lowercase(componente.tipo);
	UNTIL (componente.tipo = 'memoria') OR (componente.tipo = 'procesador') OR (componente.tipo = 'disco duro');
	IF componente.tipo = 'procesador' THEN
		c:='1'
	ELSE IF componente.tipo = 'memoria' THEN
		c:='2'
 	ELSE IF componente.tipo = 'disco duro' THEN
 		c:='3';

	writeln('El ID del componente tiene esta forma: Procesador (1xxx), Memoria (2xxx), Disco Duro (3xxx). ');
	write('Introduzca el identificador del componente <de forma xxx> : ');
	REPEAT{Primer repeat}
		REPEAT{Segundo repeat}
			readln(str);
			val(str, i, code); {Compruebo que no haya errores}
			IF (length(str) <> 3) THEN {Compruebo que tiene el tamaño correcto}
				BEGIN{IF}
					writeln(); {ESPACIO}
					writeln('El ID introducido debe ser de 3 digitos.');
					write('Introduzca el identificador del componente <de forma xxx>: ');
				END;{IF}
	    UNTIL ((length(str) = 3) AND (code = 0)); {Se cumple el tamaño exigido y no ha habido error}{segundo repeat}
		componente.id := c + str; {Añado el primero que depende del tipo y luego el siguiente que depende del usuario}
		writeln('El ID del componente es el siguiente ', c, str); {Muestro el ID actual}
		i := i + 1; {Simplemente por quitar la advertencia, no tiene utilidad}
		IF cBuscarID(tienda, componente.id) = TRUE THEN {Compruebo que el ID no esté repetido, sino se repite todo el proceso}
			write('Este ID ya existe. Introduzca otro: ');
	UNTIL cBuscarID(tienda, componente.id) = FALSE;{primer repeat}

	error := FALSE;
	REPEAT
		IF error = TRUE THEN BEGIN
			writeln(); {ESPACIO}
			writeln('ERROR: La descripcion no puede estar vacia, escriba algo por favor.');
		END; {IF}
		write('Descripcion del componente: ');
		readln(componente.descripcion);
		error := TRUE;
	UNTIL length(componente.descripcion) > 0; {No debe estar vacia}

	error := FALSE;
	REPEAT
		IF error = TRUE THEN BEGIN
			writeln(); {ESPACIO}
			writeln('ERROR: PRECIO MAL INTRODUCIDO.');
		END; {IF}
		write('Precio del componente <mayor que 0>: ');
		readln(str);
		val(str, j, code);
		componente.precio := j; {Escribo el precio}
		error := TRUE;
	UNTIL (componente.precio > 0) AND (code = 0);

	WITH tienda.almacenComponentes DO BEGIN
		tope := tope + 1;
		listaComponentes[tope] := componente;
	END;
	writeln(); {ESPACIO}
	writeln('El componente ha sido anadido al almacen.');
	writeln(); {ESPACIO}
END;{DarAltaComp}

{Robert Alexandru Dobre}
{Permite modificar un componente creado}
PROCEDURE modificar(index: integer; VAR tienda: tTienda);
	PROCEDURE menuMod(componente: tComponente);
		BEGIN{menuMod}
		writeln('DATOS ACTUALES');{Muestro los datos actuales del componente}
		writeln(componente.tipo);
		writeln(componente.id);
		writeln(componente.descripcion);
		writeln(componente.precio:0:2);

		writeln();{ESPACIO}
		writeln('MENU DE MODIFICACION');
		writeln('a- Descripcion');
		writeln('b- Precio');
		writeln('f- Terminar modificaciones');
	END;{menuMod}
VAR{modificar}
	opcion : char;
	error : boolean;
	componente : tComponente;
BEGIN{Modificar}
	writeln('Modificar componente.');
	componente := tienda.almacenComponentes.listaComponentes[index];
		REPEAT
			menuMod(componente); {Muestro el menu de modificacion}
			writeln('Elija la opcion que desea modificar: ');
			readln(opcion);
			CASE opcion OF {Selecciono la opción que deseo modificar}

				'a','A': BEGIN {Cambiar descripcion}
							writeln;{ESPACIO}
							writeln('Modificar la DESCRIPCION del componente:');
							error := FALSE;
							REPEAT
								IF error = TRUE THEN
									writeln('La descripcion no puede estar vacia. Por favor escriba algo.');
								write('Escriba la nueva descripcion del componente:');
								readln(componente.descripcion);
							UNTIL length(componente.descripcion) > 0; {Descripcion no nula}
						 END;{case B}

				'b','B': BEGIN {Cambiar precio}
							writeln;{ESPACIO}
							writeln('Modificar el PRECIO de componente:');
							error := FALSE;
							REPEAT
								IF error = TRUE THEN
									writeln('El precio no es valido (precio > 0).');
								write('Escriba el nuevo precio del componente:');
								readln(componente.precio);
							UNTIL componente.precio > 0; {Precio mayor que 0}
						 END;{case C}

				'f','F': BEGIN{Finaliza modificaciones}
						 	tienda.almacenComponentes.listaComponentes[index] := componente; {Vuelvo a guardar el componente modificado a la tienda}
						 	writeln('Componente modificado con exito.');{para confirmar}
						 END;{case F}
			END{CASE}
		UNTIL (opcion = 'f') OR (opcion = 'F');

END;{Modificar}

{Muestra los ordenadores de la tienda}
PROCEDURE mostrarOrdenadores(tienda: tTienda);
VAR{MostrarOrdenadores sueltos que son contenidos en el almacen y la funcion para ordenar se llama en el CASE G}
	i: integer;
BEGIN{MostrarOrd}
	WITH tienda.almacenPcs DO BEGIN
		FOR i := 1 TO tienda.almacenPcs.tope DO BEGIN
			writeln('ORDENADOR NUMERO ', i,':');
			writeln('ID: ', listaPcs[i].datos.id);
			writeln('TIPO: ', listaPcs[i].datos.tipo);
			writeln('DESCRIPCION: ', listaPcs[i].datos.descripcion);
			writeln('PROCESADOR: ', listaPcs[i].procesador.descripcion, ' VALOR: ', listaPcs[i].procesador.precio:0:2, 'E');
			writeln('MEMORIA: ', listaPcs[i].memoria.descripcion, ' VALOR: ', listaPcs[i].memoria.precio:0:2, 'E');
			writeln('DISCO DURO: ', listaPcs[i].discoDuro.descripcion, ' VALOR: ', listaPcs[i].discoDuro.precio:0:2, 'E');
			writeln('PRECIO TOTAL: ', listaPcs[i].datos.precio:0:2,'E');
			writeln();
		 END;{FOR}
	END; {WITH}
END;{MostrarOrd}

{Muestra los componentes de la tienda}
PROCEDURE mostrarComponentes(tienda: tTienda);
VAR{MostrarComponentes sueltos que son contenidos en el almacen}
	i: integer;
BEGIN{MostrarComp}
	writeln();
	WITH tienda.almacenComponentes DO BEGIN
		FOR i := 1 TO tope DO BEGIN
			writeln('COMPONENTE NUMERO ', i,':');
			writeln('TIPO: ', listaComponentes[i].tipo);
			writeln('ID: ', listaComponentes[i].id);
			writeln('DESCRIPCION: ', listaComponentes[i].descripcion);
			writeln('PRECIO: ', listaComponentes[i].precio:0:2, 'E');
			writeln();
		 END;{FOR}
	END; {WITH}
END;{MostrarComp}

{Miguel Torrijos}
{Guardo los datos en el un archivo binario}
PROCEDURE guardarDAT(compFile: string; pcFile: string; tienda: tTienda);
VAR{guardarDAT}
	i: integer;
	fileComp: tFicheroComponentes;
	filePC: tFicheroPCs;
BEGIN{guardarDAT}
	assign(fileComp, compFile);
	assign(filePC, pcFile);

	{Guardo los datos de los componentes}
	{$I-}
	rewrite(fileComp); {Abro el archivo para escritura}
	{$I+}
	IF IORESULT = 0 THEN BEGIN
		WITH tienda.almacenComponentes DO BEGIN
			FOR i := 1 TO tope DO BEGIN
				write(fileComp, listaComponentes[i]); {Escribo el archivo}
			END; {FOR}
			writeln('Archivo ', compFile, ' guardado con exito');
		END {WITH}
		END {IF}
	ELSE
		writeln('No ha sido posible guardar el archivo ', compFile);
	close(fileComp); {Cierro el archivo}

	{Guardo los datos de los ordenadores}
    {$I-}
	rewrite(filePC); {Abro el archivo para escritura}
	{$I+}
	IF IORESULT = 0 THEN BEGIN
		WITH tienda.almacenPcs DO BEGIN
			FOR i := 1 TO tope DO BEGIN
				write(filePC, listaPCs[i]); {Escribo el archivo}
			END; {FOR}
			writeln('Archivo ', pcFile, ' guardado con exito');
		END {WITH}
		END{IF}
	ELSE
		writeln('No ha sido posible guardar el archivo ', pcFile);
	close(filePC); {Cierro el archivo}
END;

{Miguel Torrijos}
{Guardo los datos en el un archivo de texto}
PROCEDURE guardarTXT(compFile: string; pcFile: string; tienda: tTienda);
VAR{guardarTxt}
	i: integer;
	fileComp: text;
	filePC: text;
BEGIN{guardarTxt}

	{Guardo los datos de los componentes}
	assign(fileComp, compFile);
	{$I-}
	rewrite(fileComp); {Abro el archivo para escritura}
	{$I+}
	IF IORESULT = 0 THEN BEGIN
		WITH tienda.almacenComponentes DO BEGIN
			FOR i := 1 TO tienda.almacenComponentes.tope DO BEGIN
				writeln(fileComp,listaComponentes[i].id); {Escribo el identificador}
				writeln(fileComp,listaComponentes[i].tipo); {Escribo el tipo}
				writeln(fileComp,listaComponentes[i].descripcion); {Escribo la descripcion}
				writeln(fileComp,listaComponentes[i].precio); {Escribo el precio}
				writeln(fileComp, ''); {ESPACIO}
			END; {FOR}
			writeln('Archivo ', compFile, ' guardado con exito');
		END {WITH}
		END {IF}
	ELSE
		writeln('No ha sido posible guardar el archivo');
	close(fileComp); {Cierro el archivo}

	{Guardo los datos de los ordenadores}
	assign(filePC, pcFile);
    {$I-}
	rewrite(filePC); {Abro el archivo para escritura}
	{$I+}
	IF IORESULT = 0 THEN BEGIN
		WITH tienda.almacenPcs DO BEGIN
			FOR i := 1 TO tope DO BEGIN
				writeln(filePC, listaPCs[i].datos.id); {Escribo el id del ordenador}
				writeln(filePC, listaPCs[i].datos.tipo); {Escribo el tipo del ordenador}
				writeln(filePC, listaPCs[i].datos.descripcion); {Escribo la descripcion del ordenador}
				writeln(filePC, listaPCs[i].datos.precio); {Escribo el precio del ordenador}
				{-----------------------------------------}
				writeln(filePC, listaPCs[i].memoria.id); {Escribo el id de la memoria}
				writeln(filePC, listaPCs[i].memoria.tipo); {Escribo el tipo de memoria}
				writeln(filePC, listaPCs[i].memoria.descripcion); {Escribo la descripcion de la memoria}
				writeln(filePC, listaPCs[i].memoria.precio); {Escribo el precio de la memoria}
				{-----------------------------------------}
				writeln(filePC, listaPCs[i].procesador.id); {Escribo el id del procesador}
				writeln(filePC, listaPCs[i].procesador.tipo); {Escribo el tipo de procesador}
				writeln(filePC, listaPCs[i].procesador.descripcion); {Escribo la descripcion del procesador}
				writeln(filePC, listaPCs[i].procesador.precio); {Escribo el precio del procesador}
				{-----------------------------------------}
				writeln(filePC, listaPCs[i].discoDuro.id); {Escribo el id del disco duro}
				writeln(filePC, listaPCs[i].discoDuro.tipo); {Escribo el tipo de disco duro}
				writeln(filePC, listaPCs[i].discoDuro.descripcion); {Escribo la descripcion del disco duro}
				writeln(filePC, listaPCs[i].discoDuro.precio); {Escribo el precio del disco duro}
				writeln(filePC, ''); {ESPACIO}
			END; {FOR}
			writeln('Archivo ', pcFile, ' guardado con exito');
		END; {WITH}
		END {BEGIN}
	ELSE
		writeln('No has sido posible guardar el archivo');
	close(filePC); {Cierro el archivo}
END;{guardarTxt}

{Miguel Torrijos}
{Cargo los archivos en la tienda reemplazando los valores existentes}
PROCEDURE cargarTXT(compFile: string; pcFile: string; VAR tienda: tTienda);
VAR{cargarTxt}
	fileComp: textfile;
	filePC: textfile;
BEGIN{cargarTxt}
	tienda.ventasTotales := 0; {Inicializo de nuevo las ventas}

	{Recupero los datos almacenados en el archivo TXT de los componentes}
	assign(fileComp, compFile);
	{$I-} {Deshabilito los errores}
	reset(fileComp); {Abro el archivo en modo lectura}
	{$I+}
	IF IORESULT = 0 THEN BEGIN {no ha habido errores}
		WITH tienda.almacenComponentes DO BEGIN {WITH}
			tope := 0;
			WHILE NOT EOF(fileComp) OR (tope >= MAXCOMPONENTES) DO BEGIN
				tope := tope + 1; {Añado un elemento al almacen}
				readln(fileComp, listaComponentes[tope].id); {Lee una linea y se le pasa al correspondiente registro}
				readln(fileComp, listaComponentes[tope].tipo);
				readln(fileComp, listaComponentes[tope].descripcion);
				readln(fileComp, listaComponentes[tope].precio);
				readln(fileComp);{Lee la linea vacia que separa los componentes}
			END;{WHILE}
			writeln('Archivo ', compFile, ' cargado con exito');
		END;{WITH}
		END{IF}
	ELSE
		writeln('No ha sido posible encontrar el archivo ', compFile);
	close(fileComp);

	{Recupero los datos almacenados en el archivo TXT de los ordenadores}
	assign(filePC, pcFile);
	{$I-} {Deshabilito los errores}
	reset(filePC); {Abro el archivo en modo lectura}
	{$I+}
	IF IORESULT = 0 THEN BEGIN{no ha habido errores}
		WITH tienda.almacenPcs DO BEGIN {WITH}
			tope := 0;
			WHILE NOT EOF(filePC) OR (tope >= MAXPC) DO BEGIN {WHILE}
				tope := tope + 1; {Amplio el almacén}
				readln(filePC, listaPCs[tope].datos.id); {Lee una linea y se le pasa al correspondiente registro}
				readln(filePC, listaPCs[tope].datos.tipo);
				readln(filePC, listaPCs[tope].datos.descripcion);
				readln(filePC, listaPCs[tope].datos.precio);

				readln(filePC, listaPCs[tope].memoria.id);
				readln(filePC, listaPCs[tope].memoria.tipo);
				readln(filePC, listaPCs[tope].memoria.descripcion);
				readln(filePC, listaPCs[tope].memoria.precio);

				readln(filePC, listaPCs[tope].procesador.id);
				readln(filePC, listaPCs[tope].procesador.tipo);
				readln(filePC, listaPCs[tope].procesador.descripcion);
				readln(filePC, listaPCs[tope].procesador.precio);

				readln(filePC, listaPCs[tope].discoDuro.id);
				readln(filePC, listaPCs[tope].discoDuro.tipo);
				readln(filePC, listaPCs[tope].discoDuro.descripcion);
				readln(filePC, listaPCs[tope].discoDuro.precio);
				readln(filePC);{Lee la linea vacia que separa los ordenadores}
			END;{WHILE}
			writeln('Archivo ', pcFile, ' cargado con exito');
		END; {WITH}
		END{IF}
	ELSE{IF}
		writeln('No ha sido posible encontrar el archivo ', pcFile);
	close(filePC);
END;{cargarTxt}

{Miguel Torrijos}
{Cargo los datos de los archivos binarios y reemplazo los actuales registros}
PROCEDURE cargarDAT(compFile: string; pcFile: string; VAR tienda: tTienda);
VAR{cargarDat}
	fileComp : tFicheroComponentes;
	filePC : tFicheroPCs;
BEGIN{cargarDat}
	tienda.ventasTotales := 0; {Limpio las ventas almacenadas}

	{Recupero los datos almacenados en el archivo DAT de los componentes}
	assign(fileComp, compFile);
	{$I-} {Deshabilito los errores}
	reset(fileComp); {Abro el archivo en modo lectura}
	{$I+}
	IF IORESULT = 0 THEN BEGIN {no ha habido errores}
		WITH tienda.almacenComponentes DO BEGIN
			tope := 0;
			WHILE (tope <= MAXCOMPONENTES) AND NOT EOF(fileComp) DO BEGIN{WHILE}
					tope := tope + 1; {Añado un elemento}
					read(fileComp, listaComponentes[tope]); {Lee una linea y se le pasa al correspondiente registro}
			END;{WHILE}
			writeln('Archivo ', compFile, ' cargado con exito');
		END {WITH}
		END{IF}
	ELSE
		writeln('No ha sido posible encontrar el archivo ', compFile);
	close(fileComp);

	{Recupero los datos almacenados en el archivo DAT de los  ordenadores}
	assign(filePC, pcFile);
	{$I-} {Deshabilito los errores}
	reset(filePC); {Abro el archivo en modo lectura}
	{$I+}
	IF IORESULT = 0 THEN BEGIN {no ha habido errores}
		WITH tienda.almacenPcs DO BEGIN
			tope := 0;
			WHILE (tope <= MAXPC) AND NOT EOF(filePC) DO BEGIN{WHILE}
				tope := tope + 1; {Añado un elemento}
				read(filePC, listaPCs[tope]); {Lee una linea y se le pasa al correspondiente registro}
			END;{WHILE}
			writeln('Archivo ', pcFile, ' cargado con exito');
		END {WITH}
		END{IF}
	ELSE
		writeln('No ha sido posible encontrar el archivo ', pcFile);
	close(filePC);
END;{cargarDat}

{Miguel Torrijos}
{Le paso el tipo de componente y muestro todos los que hay,}
{y devuelvo el indice del componente que el usuario ha elegido}
FUNCTION elegirComponente(tipoComp: string; tienda: tTienda): integer;
TYPE{elegirComponente}
	tArray = ARRAY [1..MAXCOMPONENTES] OF integer;
VAR{elegirComponente}
	confirm: char;
	num: integer;
	error: boolean;
	i: integer;
	j: integer;
	listaComp: tArray;
	code: integer; {Validacion de entrada}
	str: string; {Validacion de entrada}
BEGIN{elegirComponente}
	{Realizo la busqueda de los componentes deseados}
	WITH tienda.almacenComponentes DO BEGIN
		j := 0;
		FOR i := 1 TO tope DO BEGIN
			IF listaComponentes[i].tipo = lowercase(tipoComp) THEN {Si el tipo es de esas caracteristicas muestro todos los que hay}
				BEGIN
					j := j + 1;
					listaComp[j] := i; {Guardo el indice de los elementos que contienen el tipo buscado}
					{Muestro los datos de los componentes del tipo buscado}
					writeln('Componente de tipo (', tipoComp, ') numero ', j);
					writeln(listaComponentes[i].id);
					writeln(listaComponentes[i].tipo);
					writeln(listaComponentes[i].descripcion);
					writeln(listaComponentes[i].precio:0:2, 'E');
					writeln(); {ESPACIO}
				END; {IF}
		END; {FOR}

		REPEAT
			error := FALSE;
			REPEAT
				IF error = TRUE THEN
					writeln('ERROR. NUMERO FUERA DEL INTERVARLO');
				write('Introduzca el numero del componente que desea emplear (1 - ', j,'): ');
				readln(str);
				val(str, num, code); {Compruebo la entrada correcta de los datos}
				error := TRUE;
			UNTIL ((num > 0) AND (num <= j)) AND (code = 0); {Esta comprendido en el rango, y se ha metido un numero correctamente}
			{Pregunto al usuario si esa es su opcion deseada}
			writeln('Si esta de acuerdo con su eleccion pulse S, de lo contrario cualquier letra');
			readln(confirm);
			IF (confirm = lowercase('s')) THEN
					elegirComponente := listaComp[num]; {Le paso el indice deseado}
		UNTIL (confirm = lowercase('s'));
	END; {WITH}
END; {elegirComponente}

FUNCTION componenteDiferente(tienda: tTienda): boolean;{para ver si en el ordenador tenemos al menos un componente de cada tipo}
VAR{componenteDiferente}
	i: integer;
	count: integer;
	b1, b2, b3: boolean; {procesador, memoria, disco duro}
BEGIN{componenteDiferente}
	i:= 0;
	count:= 0;
	b1:= FALSE;
	b2:= FALSE;
	b3:= FALSE;
	WITH tienda.almacenComponentes DO BEGIN
		REPEAT
			i := i + 1;
			IF ((lowercase(listaComponentes[i].tipo) = 'procesador') AND (b1 = FALSE)) THEN BEGIN
				count := count + 1;
				b1 := TRUE; {Desactivo el IF}
			  END; {IF primero}
			IF ((lowercase(listaComponentes[i].tipo) = 'memoria') AND (b2 = FALSE)) THEN BEGIN
				count := count + 1;
				b2 := TRUE; {Desactivo el IF}
			  END; {IF segundo}
			IF ((lowercase(listaComponentes[i].tipo) = 'disco duro') AND (b3 = FALSE)) THEN BEGIN
				count := count + 1;
				b2 := TRUE; {Desactivo el IF}
			  END; {IF tercero}
		 UNTIL (count = 3) OR (i = tope);
	END; {WITH}
	IF count = 3 THEN
		componenteDiferente := TRUE {Hay al menos un componente de cada clase}
	 ELSE
		componenteDiferente := FALSE; {No hay un componente de cada clase}
END; {ComponenteDiferente}

{Configuro un nuevo ordenador}
{Miguel Torrijos}
PROCEDURE configurarPC(VAR tienda: tTienda);
VAR{configurarPC}
	index: integer; {Le paso el indice del componente almacenado}
	precioFinal: real; {Precio final del ordenador}
	pc: tPC; {Ordenador que se va a configurar}
	error: boolean; {Variable para controlar el error}
	siNO: boolean; {Confirmacion de los componentes}
	confirm: char; {Confirmacion de los componentes}
	cancelar: char; {Cancelar el proceso de configuración y revertir cambios}
	code:  integer; {Verificacion correcta de numeros en el ID}
	str: string; {Entrada del ID para validacion}
	i: integer; {Variable para convertir a integer}
BEGIN{configurarPC}
{1}	IF tienda.almacenPcs.tope < MAXPC THEN
		BEGIN{Verifico que haya espacio en el almacen}
		 IF componenteDiferente(tienda) = TRUE THEN BEGIN {Verificar que exista al menos un componente de cada clase}
			WITH pc DO BEGIN
				WITH tienda.almacenComponentes DO BEGIN
					precioFinal := 10; {Inicializo con la mano de obra pagada}
					writeln('******** CONFIGURAR UN NUEVO ORDENADOR ********');
					writeln('Instrucciones.');
					writeln('1- Seleccionar un procesador.');
					writeln('2- Seleccionar una memoria.');
					writeln('3- Seleccionar un disco duro.');
					writeln('4- Elegir un identificador unico.');
					writeln('5- Dar una descripcion del ordenador.');
					writeln('NOTA: si no desea continuar con la configuracion del PC pulse Q/q cuando se le solicite.');
					writeln(); {ESPACIO}
						{--------------------------------------------------------------}{PROCESADOR}
					REPEAT
						writeln('Pulse ENTER para continuar o Q para cancelar.');
						readln(cancelar);
					UNTIL (cancelar = chr(13)) OR (cancelar = 'q') OR (cancelar = 'Q'); {ENTER o Q}
					datos.descripcion := '';
					IF cancelar = chr(13) THEN BEGIN {Se ha pulsado ENTER}{IF primero}
						{Elijo un procesador}
						writeln('Seleccione un procesador para el ordenador');
						{Selecciono el procesador}
						index := elegirComponente('PROCESADOR', tienda); {Añado un procesador al ordenador}
						{Le paso el componente al ordenador y lo quito del almacen}
						procesador := listaComponentes[index]; {Se lo paso}
						datos.descripcion := 'Procesador: ' + listaComponentes[index].descripcion;{añadimos la descripcion del procesador a la descripcion del ordenador}
						precioFinal := precioFinal + listaComponentes[index].precio; {Sumo el precio}
						listaComponentes[index] := listaComponentes[tope]; {Lo quito}
						tope := tope - 1; {Reduzco el almacen}
						{--------------------------------------------------------------}{MEMORIA}
						REPEAT
							writeln('Pulse ENTER para continuar o Q para cancelar.');
							readln(cancelar);
						UNTIL (cancelar = chr(13)) OR (cancelar = 'q') OR (cancelar = 'Q'); {ENTER o Q}

						IF cancelar = chr(13) THEN BEGIN {Se ha pulsado ENTER} {IF segundo}
							{Elijo una memoria}
							writeln('Seleccione una memoria para el ordenador');
							{Selecciono la memoria}
							index := elegirComponente('MEMORIA', tienda); {Añado una memoria al ordenador}
							{Le paso el componente al ordenador y lo quito del almacen}
							memoria := listaComponentes[index]; {Lo añado al ordenador}
							datos.descripcion := datos.descripcion + ', Memoria: ' + listaComponentes[index].descripcion;
							precioFinal := precioFinal + listaComponentes[index].precio; {Sumo el precio}
							listaComponentes[index] := listaComponentes[tope]; {Lo quito}
							tope := tope - 1; {Reduzco el almacen}
						{--------------------------------------------------------------}{DISCO DURO}
							REPEAT
								writeln('Pulse ENTER para continuar o Q para cancelar.');
								readln(cancelar);
							UNTIL (cancelar = chr(13)) OR (cancelar = 'q') OR (cancelar = 'Q'); {ENTER o Q}

							IF cancelar = chr(13) THEN BEGIN {Se ha pulsado ENTER} {IF tercero}
								{Elijo un disco duro}
								writeln('Seleccione un disco duro para el ordenador');
								{Selecciono el disco duro}
								index := elegirComponente('DISCO DURO', tienda); {Añado un disco duro al ordenador}
								{Le paso el componente al ordenador y lo quito del almacen}
								discoDuro := listaComponentes[index]; {Se lo paso}
								precioFinal := precioFinal + listaComponentes[index].precio; {Sumo el precio}
								datos.descripcion := datos.descripcion + ', Disco Duro: ' + listaComponentes[index].descripcion;
								listaComponentes[index] := listaComponentes[tope]; {Lo quito}
								tope := tope - 1; {Reduzco el almacen}
						{--------------------------------------------------------------}{TIPO}
								error := FALSE;
								REPEAT
									IF error = TRUE THEN
										writeln('Seleccione el tipo de ordenador correctamente.');
									write('Seleccione el tipo de ordenador <PORTATIL, SOBREMESA, ALL IN ONE, SURFACE>: ');
									readln(datos.tipo);
									error := TRUE;
								UNTIL (lowercase(datos.tipo) = 'portatil') OR (lowercase(datos.tipo) = 'sobremesa') OR (lowercase(datos.tipo) = 'all in one') OR (lowercase(datos.tipo) = 'surface');
						{--------------------------------------------------------------}{IDENTIFICADOR DEL ORDENADOR}
								REPEAT
									writeln('Pulse ENTER para continuar o Q para cancelar.');
									readln(cancelar);
								UNTIL (cancelar = chr(13)) OR (cancelar = 'q') OR (cancelar = 'Q'); {ENTER o Q}

								IF cancelar = chr(13) THEN BEGIN {Se ha pulsado ENTER} {IF cuarto}
									error := FALSE;
								{a}	REPEAT
										error := FALSE;
									{b}	REPEAT
											IF error = TRUE THEN {Se produce cuando el identificador esta duplicado o no es correcto}
												writeln('El ID ya existe o está mal escrito.');
											write('Introduzca el identificador del ordenador (0001 - 0025): ');
				    						readln(str); {Introduzco el ID}
											error := TRUE;
											val(str, i, code);
									{b} UNTIL code = 0; {No hay errores}
										datos.id := str;
								{a} UNTIL (oBuscarID(tienda, datos.id) = FALSE) AND ((i >= 1) AND (i <= 25)) AND (length(datos.id) = NCIDENTIFICADOR); {Se repite hasta que se cumplan todas las condiciones}
									writeln('El ID del ordenador es ', str); {Muestro el ID por pantalla}{Usamos i simplemente para quitar la advertencia}
						{--------------------------------------------------------------}{DESCRIPCION DEL ORDENADOR}
									REPEAT
										writeln('Pulse ENTER para continuar o Q para cancelar.');
										readln(cancelar);
									UNTIL (cancelar = chr(13)) OR (cancelar = 'q') OR (cancelar = 'Q'); {ENTER o Q}

									IF cancelar = chr(13) THEN BEGIN {Se ha pulsado ENTER} {IF quinto}
										siNO := FALSE; {Inicializo la comprobacion}
									 {-}REPEAT
											IF (siNO = TRUE) AND (length(datos.descripcion) = 0) THEN {Verifico que no hay algun eror}
												write('La descripcion no puede estar vacia. Por favor escriba algo.');
											writeln(); {ESPACIO}
											writeln('Escriba la descripcion del ordenador: ');
											readln(datos.descripcion);
											{Compruebo que el usuario este de acuerdo con la descripcion}
											writeln('Si esta conforme con la descripcion pulse S, de lo contrario cualquier otra tecla.');
											readln(confirm);
											IF (confirm = 'S') OR (confirm = 's') THEN
												siNO := TRUE
											ELSE
												siNO := FALSE;
									 {-}UNTIL (siNO = TRUE) AND (length(datos.descripcion) > 0); {Se repita hasta que se cumplan todas las condiciones}

										datos.precio := precioFinal; {Le pongo el precio total con la mano de obra y los componentes}

										{Cuando el ordenador ha sido configurado complemente lo añado al almacen}
										WITH tienda.almacenPcs DO BEGIN
											tope := tope + 1; {Amplio el almacen}
											listaPcs[tope] := pc; {Guardo el ordenador}
										END; {WITH}
										writeln('Configuracion realizada con exito. El ordenador ha sido anadido al almacen.');
										END {IF quinto}
										{---------------------------------------------------------------------}
										{REVIERTE TODA LA CONFIGURACION DEVOLVIENDO LOS COMPONENTES AL ALMACEN}
										{---------------------------------------------------------------------}
									ELSE BEGIN {ELSE quinto}
											writeln('Configuracion cancelada. Se revertiran todos los cambios.');
											tope := tope + 1; {Amplio el almacen}
											listaComponentes[tope] := procesador; {Devuelvo el componente al almacen}
											tope := tope + 1;
											listaComponentes[tope] := memoria;
											tope := tope + 1;
											listaComponentes[tope] := discoDuro;
										END {ELSE quinto}
									END {IF cuarto}
								ELSE BEGIN {ELSE cuarto}
										writeln('Configuracion cancelada. Se revertiran todos los cambios.');
										tope := tope + 1; {Amplio el almacen}
										listaComponentes[tope] := procesador; {Devuelvo el componente al almacen}
										tope := tope + 1;
										listaComponentes[tope] := memoria;
										tope := tope + 1;
										listaComponentes[tope] := discoDuro;
									END {ELSE cuarto}
								END {IF tercero}
							ELSE BEGIN {ELSE tercero}
									writeln('Configuracion cancelada. Se revertiran todos los cambios.');
									tope := tope + 1; {Amplio el almacen}
									listaComponentes[tope] := procesador; {Devuelvo el componente al almacen}
									tope := tope + 1;
									listaComponentes[tope] := memoria;
								END {ELSE tercero}
							END {IF segundo}
						ELSE BEGIN {ELSE segundo}
								writeln('Configuracion cancelada. Se revertiran todos los cambios.');
								tope := tope + 1; {Amplio el almacen}
								listaComponentes[tope] := procesador; {Devuelvo el componente al almacen}
							END {ELSE segundo}
						END {IF primer}
					ELSE {ELSE primer}
						writeln('Configuracion cancelada. Se revertiran todos los cambios.');
				END; {WITH almacenComponentes}
			END; {WITH pc}
		END {IF secundario}
		ELSE
			writeln('No hay suficientes componentes para configurar un ordenador Por favor anade alguno al almacen.');
  {1} END {IF primario}
{1}ELSE
	writeln('No hay espacio suficiente en el almacen');
END; {configurarPC}

{Muestra el menu del programa}
{Yamil Fernando Torrez Garcia}
PROCEDURE mostrarMenu;
BEGIN{MostrarMenu}
	writeln('**************** MENU ****************');
	writeln('A - Dar alta un componente.');
	writeln('B - Configurar un ordenador.');
	writeln('C - Modificar un componente.');
	writeln('D - Vender un componente.');
	writeln('E - Vender un ordenador.');
	writeln('F - Mostrar las ventas actuales.');
	writeln('G - Mostrar todos los ordenadores, ordenados por precio de menor a mayor.');
	writeln('H - Mostrar todos los componentes sueltos.');
	writeln('I - Guardar datos en ficheros binarios.');
	writeln('J - Guardar datos en ficheros de texto.');
	writeln('K - Cargar datos de ficheros binarios.');
	writeln('L - Cargar datos de ficheros de texto.');
	writeln('M - Finalizar.');
	writeln('Elija una opcion:');
END;{MostrarMenu}

BEGIN{Main}
	writeln('***** URJC Tienda de ordenadores *****');
	tienda.almacenComponentes.tope := 0; {Almacen vacio}
	tienda.almacenPcs.tope := 0; {Almacen vacio}
	tienda.ventasTotales := 0;{Ventas vacias}
	REPEAT
		REPEAT
			mostrarMenu();
			writeln();
			readln(opcion);
			IF (((opcion < 'a') OR (opcion > 'm')) AND ((opcion < 'A') OR (opcion > 'M'))) THEN BEGIN
				writeln('Opcion incorrecta!');
				writeln();
			END;{IF}
	 	UNTIL (((opcion <= 'M') AND (opcion >= 'A')) OR ((opcion <= 'm') AND (opcion >= 'a')));{segundo repeat}

		CASE opcion OF

			'A','a':
				BEGIN {case A} {Dar alta un componente.}
					writeln('CREAR COMPONENTE');
					IF (tienda.almacenComponentes.tope = MAXCOMPONENTES) THEN
						writeln('El almacen de componentes esta lleno.')
					ELSE
						darAltaComp(tienda);
					writeln(); {ESPACIO}
			END;{case A}

			'B','b':
				BEGIN {case B} {Configurar un ordenador.}
					writeln('CONFIGURAR UN ORDENADOR');
					IF (tienda.almacenComponentes.tope <> 0) THEN
						configurarPC(tienda)
				 	ELSE
				 		writeln('No hay componentes sueltos para configurar el ordenador.');
					writeln();
				END;{case B}

			'C','c':
				BEGIN {case C} {Modificar un componente.}
					writeln('MODIFICAR UN COMPONENTE DEL ALMACEN');
					IF (tienda.almacenComponentes.tope <> 0) THEN BEGIN
						cMostrarID(tienda); {Muestro los IDs de los componentes}
						REPEAT
							writeln('Introduzca el identificador a buscar (4 digitos)');
							writeln('AYUDA: procesador (1xxx), memoria(2xxx), disco duro (3xxx)');
							readln(iden);
						UNTIL length(iden) = NCIDENTIFICADOR; {Identificador valido}
						IF cBuscarID(tienda, iden) = TRUE THEN
							modificar(cIndicar(tienda, iden), tienda);
						END {IF primero}
					ELSE
						writeln('No hay componentes para modificar.');
					writeln(); {ESPACIO}
				END;{case C}

			'D','d':
				BEGIN {case D} {Vender un componente.}
					writeln('VENDER UN COMPONENTE DEL ALMACEN');
					IF (tienda.almacenComponentes.tope <> 0 ) THEN
				 		BEGIN
				 			cMostrarID(tienda);{Muestro los IDs de los componentes}
							REPEAT
								write('Introduzca el ID del componente que deseas vender <4 digitos> : ');
								writeln('AYUDA: procesador (1xxx), memoria(2xxx), disco duro (3xxx)');
								readln(iden);
								IF cBuscarID(tienda, iden) = FALSE THEN
									writeln('El ID introducido no es valido.');
			  				UNTIL (cBuscarID(tienda, iden) = TRUE) AND (length(iden) <= 4);
							cVender(tienda, iden);
						END{IF}
			  		ELSE
			  			writeln('No hay componentes sueltos disponibles en el almacen para ser vendidos.');
					writeln(); {ESPACIO}
				END;{case D}

			'E','e':
				BEGIN {case E} {Vender un ordenador.}
					writeln('VENDER UN ORDENADOR DEL ALMACEN');
					IF (tienda.almacenPcs.tope <> 0 ) THEN
						BEGIN
							oMostrarID(tienda);
							REPEAT
								write('Introduzca el ID del ordenador al que deseas vender: ');
								readln(iden);
								IF oBuscarID(tienda,iden) = FALSE THEN
									writeln('El ordenador con este ID no existe.');
					  		UNTIL oBuscarID(tienda,iden) = TRUE ;
							oVender(tienda, iden);
						END{IF}
			 		ELSE
			 			writeln('No hay ordenadores disponibles en el almacen para ser vendidos.');
					writeln();
				END;{case E}

			'F','f':
				BEGIN {case F} {Mostrar las ventas actuales.}
					writeln('VENTAS DE LA TIENDA'); {ESPACIO}
					writeln('Las ventas actuales son de: ', tienda.ventasTotales:0:2, ' E.');
					writeln(); {ESPACIO}
				END;{case F}

			'G','g':
				BEGIN {case G} {Mostrar todos los ordenadores, ordenados por precio de menor a mayor.}
					writeln('ORDENADORES DEL ALMACEN');
					writeln();{ESPACIO}
					IF (tienda.almacenPcs.tope <> 0) THEN
						BEGIN
							ordenar(tienda);{se ordenan por precio}
							mostrarOrdenadores(tienda);{se mostran}
						END{IF}
			  		ELSE writeln('No hay ordenadores en la tienda.');
					writeln(); {ESPACIO}
				END;{case G}

			'H','h':
				BEGIN {case H} {Mostrar todos los componentes sueltos.}
					writeln('COMPONENTES SUELTOS DEL ALMACEN');
					writeln();{ESPACIO}
					IF (tienda.almacenComponentes.tope <> 0) THEN
						mostrarComponentes(tienda)
					ELSE writeln('No hay componentes en el almacen.');
						writeln(); {ESPACIO}
				END;{case H}

			'I','i':
				BEGIN {case I} {Guardar datos en ficheros binarios.}
					writeln('GUARDAR DATOS DESDE FICHEROS BINARIOS (DAT)');
					fichComp := 'componentes.dat';
					fichOrd := 'ordenadores.dat';
					guardarDAT(fichComp, fichOrd, tienda);
					writeln(); {ESPACIO}
				END;{case I}

			'J','j':
				BEGIN {case J} {Guardar datos en ficheros de texto.}
					writeln('GUARDAR DATOS DESDE FICHEROS DE TEXTO (TXT)');
					fichComp := 'componentes.txt';
					fichOrd := 'ordenadores.txt';
					guardarTXT(fichComp, fichOrd, tienda);
					writeln(); {ESPACIO}
				END;{case F}

			'K','k':
				BEGIN {case K} {Cargar datos de ficheros binarios.}
					writeln('CARGAR DATOS DESDE FICHEROS BINARIOS (DAT)');
					fichComp := 'componentes.dat';
					fichOrd := 'ordenadores.dat';
					cargarDAT(fichComp, fichOrd, tienda);
					writeln(); {ESPACIO}
				END;{case K}

			'L','l':
				BEGIN {case L} {Cargar datos de ficheros de texto.}
					writeln('CARGAR DATOS DESDE FICHEROS DE TEXTO (TXT)');
					fichComp := 'componentes.txt';
					fichOrd := 'ordenadores.txt';
					cargarTXT(fichComp, fichOrd, tienda);
					writeln(); {ESPACIO}
				END;{case L}

			'M','m':
				BEGIN
					writeln('FINALIZAR PROGRAMA');
					writeln('Finalizar. Pulsa "Intro" para salir.');
				END;{case M}

		END;{CASE}
	UNTIL (opcion = 'M') OR (opcion = 'm');{primer repeat}
readln();
END.
