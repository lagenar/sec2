program sec2;

uses crt;

const
   N_ARC_SURTIDORES			     = 'surtidores.dat';
   N_ARC_PLAYEROS			     = 'playeros.dat';
   N_ARC_VTAS				     = 'ventas.dat';
   DIAS_MES				     = 31;
   NUM_ERRORES				     = 19;
   ERROR_CAPACIDAD			     = 1;
   ERROR_SURTIDOR			     = 2;
   ERROR_COMISION			     = 3;
   ERROR_PLAYERO			     = 4;
   ERROR_PRECIO				     = 5;
   ERROR_SURTIDOR_YA_EXISTE		     = 6;
   ERROR_PLAYERO_YA_EXISTE		     = 7;
   ERROR_HORA				     = 8;
   ERROR_SURTIDOR_INEXISTENTE		     = 9;
   ERROR_PLAYERO_INEXISTENTE		     = 10;
   ERROR_FACTURA			     = 11;
   ERROR_FACTURA_YA_EXISTE		     = 12;
   ERROR_CAPACIDAD_INSUFICIENTE		     = 13;
   ERROR_FACTURA_NO_EXISTE		     = 14;
   ERROR_DIA				     = 15;
   ERROR_DIA_MENOR			     = 16;
   ERROR_LITROS				     = 17;
   ERROR_NO_HAY_SURTIDORES		     = 18;
   ERROR_NO_HAY_PLAYEROS		     = 19;
   ERRORES : array[1..NUM_ERRORES] of string = 
   ('La capacidad es invalida',
    'El numero de surtidor es invalido',
    'El porcentaje de comision es invalido',
    'El numero de playero es invalido',
    'El precio del combustible es invalido',
    'El surtidor ya existe',
    'El playero ya existe',
    'La hora es invalida',
    'El surtidor no existe',
    'El playero no existe',
    'El numero de factura es invalido',
    'La factura ya existe',
    'No hay suficientes litros para realizar la venta',
    'La factura no existe',
    'El numero de dia es invalido',
    'El numero de dia debe ser mayor que el ultimo dia ingresado',
    'Los litros ingresados son invalidos',
    'No hay ningun surtidor por lo que no se puede realizar la venta',
    'No hay ningun playero por lo que no se puede realizar la venta');
   
type
   ptr_playero	      = ^nodo_playero;
   ptr_surtidor	      = ^nodo_surtidor;
   ptr_ventas	      = ^nodo_ventas;
   ptr_lista_playero  = ^nodo_lista_playero;
   tipo_vtas_acum     = record
			   dinero	   : real;
			   dia_vtas	   : integer;
			   litros_vendidos : real
			end;		   
   tipo_playero	      = record
			   numero	 : integer;
			   nombre	 : string;
			   apellido	 : string;
			   porc_comision : integer
			end;		 
   nodo_playero	      = record    
			   playero  : tipo_playero;
			   izq, der : ptr_playero
			end;	    
   tipo_combustible   = record
			   nombre : string;
			   precio : real
			end;	  
   tipo_surtidor      = record
			   numero      : integer;
			   combustible : tipo_combustible;
			   capacidad   : real
			end;	       
   nodo_surtidor      = record
			   surtidor   : tipo_surtidor;
			   sig	      : ptr_surtidor;
			   arb_ventas : ptr_ventas;
			end;	      
   tipo_hora	      = record
			   hora	  : 0..23;
			   minuto : 0..59
			end;	  
   tipo_factura	      = record
			   numero	   : integer;
			   litros_vendidos : real;
			   hora_venta	   : tipo_hora
			end;		   
   nodo_ventas	      = record
			   factura   : tipo_factura;
			   izq, der  : ptr_ventas;
			   p_playero : ptr_playero
			end;	     
   nodo_lista_playero = record
			   playero  : ptr_playero;
			   sig	    : ptr_lista_playero;
			   comision : real
			end;	    
   
procedure imprimir_error(error : integer);
begin
   writeln(ERRORES[error]);
   readln();
end; { imprimir_error }

function capacidad_valida(capacidad : real):boolean;
begin
   capacidad_valida:=capacidad > 0;
end; { capacidad_valida }

function factura_valida(factura	: integer):boolean;
begin
   factura_valida:=factura > 0;
end; { factura_valida }

function surtidor_valido(surtidor : integer):boolean;
begin
   surtidor_valido:=surtidor > 0;
end; { surtidor_valido }

function hora_valida(hora, minuto : integer):boolean;
begin
   hora_valida:=(hora >=0) and (hora < 24) and (minuto >= 0) and
   (minuto < 60);
end; { hora_valida }

function comision_valida(comision : integer):boolean;
begin
   comision_valida:=(comision > 0) and (comision < 100);
end; { comision_valida }

function playero_valido(playero : integer):boolean;
begin
   playero_valido:=playero > 0;
end; { playero_valido }

function precio_valido(precio : real):boolean;
begin
   precio_valido:=precio > 0;
end; { precio_valido }

function buscar_surtidor(lista_surt : ptr_surtidor;
			 numero	    : integer):ptr_surtidor;
begin
   if (lista_surt = nil) or (lista_surt^.surtidor.numero = numero) then
      buscar_surtidor:=lista_surt
   else
      buscar_surtidor:=buscar_surtidor(lista_surt^.sig, numero);
end; { buscar_surtidor }

function surtidor_existente(lista_surt : ptr_surtidor;
			    numero     : integer):boolean;
begin
   surtidor_existente:=buscar_surtidor(lista_surt, numero) <> nil;
end; { surtidor_existente }


procedure leer_numero_surtidor(var numero : integer);
			        
begin
      write('Ingrese el numero de surtidor: ');
      readln(numero);      
end; { leer_numero_surtidor }

procedure leer_capacidad_surtidor(var capacidad	: real);   
begin
   write('Ingrese la capacidad del surtidor : ');
   readln(capacidad);
end; { leer_capacidad_surtidor }

procedure leer_tipo_combustible(var tipo : string);
begin
   write('Ingrese el tipo de combustible: ');
   readln(tipo);   
end; { leer_tipo_combustible }

procedure leer_precio_combustible(var precio : real);
begin
   write('Ingrese el precio del combustible: ');
   readln(precio);
end; { leer_precio_combustible }

procedure validar_nuevo_surtidor(    numero	      : integer;
				      list_surtidores : ptr_surtidor;
				    var error	      : integer);
begin
   error:=0;
   if not surtidor_valido(numero) then
      error:=ERROR_SURTIDOR
   else if surtidor_existente(list_surtidores, numero) then
      error:=ERROR_SURTIDOR_YA_EXISTE;
end; { validar_nuevo_surtidor }

procedure validar_capacidad_surtidor(	 capacidad : real;
				     var error	   : integer);
begin
   error:=0;
   if not capacidad_valida(capacidad) then
      error:=ERROR_CAPACIDAD;
end; { validar_capacidad_surtidor }

procedure validar_precio_combustible(	 precio	: real;
				     var error	: integer);
begin
   error:=0;
   if not precio_valido(precio) then
      error:=ERROR_PRECIO;
end; { validar_precio_combustible }

function crear_surtidor(surtidor : tipo_surtidor):ptr_surtidor;
var
   nuevo : ptr_surtidor;
   
begin
   new(nuevo);
   nuevo^.sig:=nil;
   nuevo^.surtidor:=surtidor;
   nuevo^.arb_ventas:=nil;
   crear_surtidor:=nuevo;
end; { crear_surtidor }

procedure insertar_surtidor(var list_surtidores : ptr_surtidor;
				surtidor   : tipo_surtidor);
var
   nuevo, cursor : ptr_surtidor;
begin
   nuevo:=crear_surtidor(surtidor);
   if (list_surtidores = nil) or
      (list_surtidores^.surtidor.numero > surtidor.numero) then
   begin
      nuevo^.sig:=list_surtidores;
      list_surtidores:=nuevo;
   end
   else
   begin
      cursor:=list_surtidores;
      while (cursor^.sig <> nil) and
	 (cursor^.surtidor.numero < surtidor.numero) do
	 cursor:=cursor^.sig;
      nuevo^.sig:=cursor^.sig;
      cursor^.sig:=nuevo;
   end;
end; { insertar_surtidor }

procedure agregar_surtidor(var list_surtidores : ptr_surtidor);
{}
var
   surtidor : tipo_surtidor;
   error    : integer;

begin
   clrscr();
   error:=0;
   repeat
      leer_numero_surtidor(surtidor.numero);
      validar_nuevo_surtidor(surtidor.numero, list_surtidores, error);
      if error > 0 then
	 imprimir_error(error);
   until error = 0;
   leer_tipo_combustible(surtidor.combustible.nombre);
   repeat
      leer_precio_combustible(surtidor.combustible.precio);
      validar_precio_combustible(surtidor.combustible.precio, error);
      if error > 0 then
	 imprimir_error(error);
   until error = 0;
   repeat
      leer_capacidad_surtidor(surtidor.capacidad);
      validar_capacidad_surtidor(surtidor.capacidad, error);
      if error > 0 then
	 imprimir_error(error);
   until error = 0;
   insertar_surtidor(list_surtidores, surtidor);
end; { agregar_surtidor }

function buscar_playero(arb_playeros : ptr_playero;
			numero	     : integer):ptr_playero;
begin
   if (arb_playeros = nil) or (arb_playeros^.playero.numero = numero) then
      buscar_playero:=arb_playeros
   else if numero < arb_playeros^.playero.numero then
      buscar_playero:=buscar_playero(arb_playeros^.izq, numero)
   else
      buscar_playero:=buscar_playero(arb_playeros^.der, numero);
end; { buscar_playero }

function playero_existente(arb_playeros	: ptr_playero;
			   numero	: integer):boolean;
begin
   playero_existente:=buscar_playero(arb_playeros, numero) <> nil;
end; { playero_existente }

procedure leer_numero_playero(var numero : integer);
begin
   write('Ingrese el numero de playero: ');
   readln(numero);
end; { leer_numero_playero }

procedure leer_nombre_playero(var nombre   : string;
			      var apellido : string);
begin
   write('Ingrese el nombre del playero: ');
   readln(nombre);
   write('Ingrese el apellido del playero: ');
   readln(apellido);
end; { leer_nombre_playero }

procedure leer_porcentaje_comision(var porc_com	: integer);
begin
   write('Ingrese el porcentaje de comision: ');
   readln(porc_com);
end; { leer_porcentaje_comision }

procedure validar_nuevo_playero(    numero	 : integer;
				    arb_playeros : ptr_playero;
				var error	 : integer);
begin
   error:=0;
   if not playero_valido(numero) then
      error:=ERROR_PLAYERO
   else if playero_existente(arb_playeros, numero) then
      error:=ERROR_PLAYERO_YA_EXISTE;
end; { validar_nuevo_payero }

procedure validar_porcentaje_comision(	  porc_com : integer;
				      var error	   : integer);
begin
   error:=0;
   if not comision_valida(porc_com) then
      error:=ERROR_COMISION;
end; { validar_porcentaje_comision }

function crear_playero(playero : tipo_playero):ptr_playero;
var
   nuevo : ptr_playero;
   
begin
   new(nuevo);
   nuevo^.izq:=nil;
   nuevo^.der:=nil;
   nuevo^.playero:=playero;
   crear_playero:=nuevo;
end; { crear_playero }

procedure insertar_playero(var arb_playeros  : ptr_playero;
			       nuevo_playero : ptr_playero);

begin		   
   if arb_playeros = nil then
      arb_playeros:=nuevo_playero
   else if nuevo_playero^.playero.numero < arb_playeros^.playero.numero then
      insertar_playero(arb_playeros^.izq, nuevo_playero)
   else
      insertar_playero(arb_playeros^.der, nuevo_playero);
end; { insertar_playero }

procedure agregar_playero(var arb_playeros : ptr_playero);
var
   playero : tipo_playero;
   nuevo   : ptr_playero;
   error   : integer;

begin
   clrscr();
   error:=0;
   repeat
      leer_numero_playero(playero.numero);
      validar_nuevo_playero(playero.numero, arb_playeros, error);
      if error > 0 then
	 imprimir_error(error);
   until error = 0;
   leer_nombre_playero(playero.nombre, playero.apellido);
   repeat
      leer_porcentaje_comision(playero.porc_comision);
      validar_porcentaje_comision(playero.porc_comision, error);
      if error > 0 then
	 imprimir_error(error);
   until error = 0;
   nuevo:=crear_playero(playero);
   insertar_playero(arb_playeros, nuevo);
end; { agregar_playero }

function litros_vendidos_surtidor(arb_ventas : ptr_ventas):real;
begin
   if arb_ventas = nil then
      litros_vendidos_surtidor:=0
   else if (arb_ventas^.izq = nil) and (arb_ventas^.der = nil) then
      litros_vendidos_surtidor:=arb_ventas^.factura.litros_vendidos
   else
      litros_vendidos_surtidor:=arb_ventas^.factura.litros_vendidos +
      litros_vendidos_surtidor(arb_ventas^.izq)
      + litros_vendidos_surtidor(arb_ventas^.der);
end; { litros_vendidos_surtidor }

function litros_restantes_surtidor(nodo_surt : ptr_surtidor):real;
begin
   litros_restantes_surtidor:=nodo_surt^.surtidor.capacidad -
   litros_vendidos_surtidor(nodo_surt^.arb_ventas);
end; { litros_restantes_surtidor }

procedure listar_surtidores(lista_surtidores : ptr_surtidor);
var
   surtidor  : tipo_surtidor;
   cursor    : ptr_surtidor;
   restantes : real;
	    
begin
   clrscr();
   writeln('Numero', 'Combustible':20, 'Precio':20, 'Capacidad':20,
	   'Litros restantes':25);
   cursor:=lista_surtidores;
   while cursor <> nil do
   begin
      surtidor:=cursor^.surtidor;
      restantes:=litros_restantes_surtidor(cursor);
      writeln(surtidor.numero:6, surtidor.combustible.nombre:20,
	      surtidor.combustible.precio:20:2, surtidor.capacidad:20:2,
	      restantes:25:2);
      cursor:=cursor^.sig;
   end;
   readln();
end; { listar_surtidores }

function buscar_factura_surtidor(arb_ventas : ptr_ventas;
				     num    : integer):ptr_ventas;
var
   r_izq, r_der	: ptr_ventas;
   
begin
   if (arb_ventas = nil) or (arb_ventas^.factura.numero = num) then
      buscar_factura_surtidor:=arb_ventas
   else
   begin
      r_izq:=buscar_factura_surtidor(arb_ventas^.izq, num);
      if r_izq <> nil then
	 buscar_factura_surtidor:=r_izq
      else
      begin
	 r_der:=buscar_factura_surtidor(arb_ventas^.der, num);
	 buscar_factura_surtidor:=r_der;
      end;
   end;
end; { buscar_factura_surtidor }

function buscar_factura(list_surt : ptr_surtidor;
			num	  : integer):ptr_ventas;
var
   cursor      : ptr_surtidor;
   nodo_ventas : ptr_ventas;

begin
   cursor:=list_surt;
   nodo_ventas:=nil;
   while (cursor <> nil) and (nodo_ventas = nil) do
   begin
      nodo_ventas:=buscar_factura_surtidor(cursor^.arb_ventas, num);
      cursor:=cursor^.sig;
   end;
   buscar_factura:=nodo_ventas;
end; { buscar_factura }

procedure leer_numero_factura(var factura : integer);
begin
   write('Ingrese el numero de factura: ');
   readln(factura);
end; { leer_numero_factura }

procedure leer_litros_venta(var litros : real);
begin
   write('Ingrese los litros a vender: ');
   readln(litros);
end; { leer_litros_venta }

procedure leer_hora(var hora   : integer;
		    var minuto : integer);
begin
   write('Ingrese la hora(hora minuto): ');
   readln(hora, minuto);
end; { leer_hora }

procedure validar_hora(	   hora, minuto	: integer;
		       var error	: integer);
begin
   error:=0;
   if not hora_valida(hora, minuto) then
      error:=ERROR_HORA;
end; { validar_hora }

procedure validar_numero_factura(    factura	     : integer;
				     list_surtidores : ptr_surtidor;
				 var error	     : integer);
begin
   error:=0;
   if not factura_valida(factura) then
      error:=ERROR_FACTURA
   else if buscar_factura(list_surtidores, factura) <> nil then
      error:=ERROR_FACTURA_YA_EXISTE;
end; { validar_numero_factura }

procedure validar_nodo_surtidor_venta(	  nodo_surtidor	: ptr_surtidor;
				      var error		: integer);
begin
   error:=0;
   if nodo_surtidor = nil then
      error:=ERROR_SURTIDOR_INEXISTENTE;
end; { validar_nodo_surtidor_venta }

procedure validar_nodo_playero_venta(	 nodo_playero : ptr_playero;
				     var error	      : integer);
begin
   error:=0;
   if nodo_playero = nil then
      error:=ERROR_PLAYERO_INEXISTENTE;
end; { validar_nodo_playero_venta }

function capacidad_suficiente(nodo_surt	: ptr_surtidor;
			      a_vender	: real):boolean;
begin
   capacidad_suficiente:=(litros_restantes_surtidor(nodo_surt)-a_vender) >= 0;
end; { capacidad_suficiente }

procedure validar_litros_venta(	   litros	 : real;
				   nodo_surtidor : ptr_surtidor;
			       var error	 : integer);
begin
   error:=0;
   if not capacidad_valida(litros) then
      error:=ERROR_LITROS
   else if not capacidad_suficiente(nodo_surtidor, litros) then
      error:=ERROR_CAPACIDAD_INSUFICIENTE;
end; { validar_litros_venta }

procedure validar_numero_surtidor(    surtidor : integer;
				  var error    : integer);
begin
   error:=0;
   if not surtidor_valido(surtidor) then
      error:=ERROR_SURTIDOR;
end; { validar_numero_surtidor }

procedure validar_numero_playero(    playero : integer;
				 var error   : integer);
begin
   error:=0;
   if not playero_valido(playero) then
      error:=ERROR_PLAYERO;
end; { validar_numero_playero }

procedure insertar_venta(var arb_ventas	: ptr_ventas;
			     nueva	: ptr_ventas);
begin
   if arb_ventas = nil then 
      arb_ventas:=nueva
   else if nueva^.factura.litros_vendidos <=
      arb_ventas^.factura.litros_vendidos then
      insertar_venta(arb_ventas^.izq, nueva)
   else
      insertar_venta(arb_ventas^.der, nueva);
end; { insertar_venta }

function crear_nodo_venta(factura      : tipo_factura;
			  nodo_playero : ptr_playero):ptr_ventas;
var
   nueva : ptr_ventas;
   
begin
   new(nueva);
   nueva^.izq:=nil;
   nueva^.der:=nil;
   nueva^.p_playero:=nodo_playero;
   nueva^.factura:=factura;
   crear_nodo_venta:=nueva;
end; { crear_nodo_venta }

function calcular_monto_venta(nodo_surt	: ptr_surtidor;
			      litros	: real):real;
begin
   calcular_monto_venta:=nodo_surt^.surtidor.combustible.precio * litros;
end; { calcular_monto_venta }

function desea_reintentar():boolean;
var
   c : char;
   
begin
   repeat
      write('quiere volver a intentar? s/n ');
      readln(c);
   until (c='n') or (c='s');
   if c='n' then
      desea_reintentar:=false
   else
      desea_reintentar:=true;
end; { desea_reintentar }

procedure realizar_venta(list_surtidores : ptr_surtidor;
			 arb_playeros	 : ptr_playero);
var
   nodo_playero	       : ptr_playero;
   nodo_surt	       : ptr_surtidor;
   nsurtidor, nplayero : integer;
   hora, minuto	       : integer;
   factura	       : tipo_factura;
   monto_venta	       : real;
   error	       : integer;
   nodo_venta	       : ptr_ventas;

begin
   clrscr();
   error:=0;
   if list_surtidores = nil then
   begin
      error:=ERROR_NO_HAY_SURTIDORES;
      imprimir_error(error);
   end
   else if arb_playeros = nil then
   begin
      error:=ERROR_NO_HAY_PLAYEROS;
      imprimir_error(error);
   end
   else
   begin
      repeat
	 leer_numero_surtidor(nsurtidor);
	 validar_numero_surtidor(nsurtidor, error);
	 if error = 0 then begin
	    nodo_surt:=buscar_surtidor(list_surtidores, nsurtidor);
	    validar_nodo_surtidor_venta(nodo_surt, error);
	 end;
	 if error > 0 then
	    imprimir_error(error);
      until (error = 0) or not (desea_reintentar());
      if error = 0 then
	 repeat
	    leer_numero_playero(nplayero);
	    validar_numero_playero(nplayero, error);
	    if error = 0 then begin
	       nodo_playero:=buscar_playero(arb_playeros, nplayero);
	       validar_nodo_playero_venta(nodo_playero, error);
	    end;
	    if error > 0 then
	       imprimir_error(error);
	 until (error = 0) or not (desea_reintentar());
				   
      if error = 0 then
	 repeat
	    leer_numero_factura(factura.numero);
	    validar_numero_factura(factura.numero, nodo_surt, error);
	    if error > 0 then
	       imprimir_error(error);
	 until (error = 0) or not (desea_reintentar());
      if error = 0 then
	 repeat
	    leer_litros_venta(factura.litros_vendidos);
	    validar_litros_venta(factura.litros_vendidos, nodo_surt, error);
	    if error > 0 then
	       imprimir_error(error);
	 until (error = 0) or not (desea_reintentar());
      if error = 0 then
	 repeat
	    leer_hora(hora, minuto);
	    validar_hora(hora, minuto, error);
	    if error > 0 then
	       imprimir_error(error)
	    else begin
	       factura.hora_venta.hora:=hora;
	       factura.hora_venta.minuto:=minuto;
	    end;
	 until (error = 0) or not (desea_reintentar());
      if error = 0 then {todo valido podemos realizar la venta}
      begin
	 nodo_venta:=crear_nodo_venta(factura, nodo_playero);
	 insertar_venta(nodo_surt^.arb_ventas, nodo_venta);
	 monto_venta:=calcular_monto_venta(nodo_surt, factura.litros_vendidos);
	 write('El monto de la venta es: ', monto_venta:0:2);
	 readln();
      end;
   end;
end; { realizar_venta }

function buscar_mayor_nodo_ventas(arb_ventas : ptr_ventas):ptr_ventas;
begin
   if (arb_ventas = nil) or (arb_ventas^.der = nil) then
      buscar_mayor_nodo_ventas:=arb_ventas
   else
      buscar_mayor_nodo_ventas:=buscar_mayor_nodo_ventas(arb_ventas^.der);
end; { buscar_mayor_nodo_ventas }

procedure eliminar_mayor_nodo_ventas(var arb_ventas : ptr_ventas);
var
   tmp : ptr_ventas;
   
begin
   if arb_ventas <> nil then
   begin
      if arb_ventas^.der = nil then
      begin
	 tmp:=arb_ventas;
	 arb_ventas:=arb_ventas^.izq;
	 dispose(tmp);
      end
      else
	 eliminar_mayor_nodo_ventas(arb_ventas^.der);
   end;
end; { eliminar_mayor_nodo_ventas }

procedure eliminar_nodo_ventas(var nodo_ventas : ptr_ventas);
var
   tmp : ptr_ventas;

begin
   if nodo_ventas <> nil then
   begin
      if (nodo_ventas^.izq <> nil) and (nodo_ventas^.der <> nil) then
      begin
	 tmp:=buscar_mayor_nodo_ventas(nodo_ventas^.izq);
	 nodo_ventas^.factura:=tmp^.factura;
	 nodo_ventas^.p_playero:=tmp^.p_playero;
	 eliminar_mayor_nodo_ventas(nodo_ventas^.izq);
      end
      else if nodo_ventas^.izq <> nil then
      begin
	 tmp:=nodo_ventas;
	 nodo_ventas:=nodo_ventas^.izq;
	 dispose(tmp);
      end
      else
      begin
	 tmp:=nodo_ventas;
	 nodo_ventas:=nodo_ventas^.der;
	 dispose(nodo_ventas);
      end;
   end;
end; { eliminar_nodo_ventas }

procedure eliminar_factura_surtidor(var arb_ventas : ptr_ventas;
					num	   : integer;
				    var encontrado : boolean);
begin
   if arb_ventas = nil then
      encontrado:=false
   else if arb_ventas^.factura.numero = num then
   begin
      encontrado:=true;
      eliminar_nodo_ventas(arb_ventas);
   end
   else
   begin
      eliminar_factura_surtidor(arb_ventas^.izq, num, encontrado);
      if not encontrado then
	 eliminar_factura_surtidor(arb_ventas^.der, num, encontrado);
   end;
end; { eliminar_factura_surtidor }

procedure eliminar_factura(    list_surt : ptr_surtidor;
			   nfactura	 : integer;
			   var error	 : integer);
var
   cursor     : ptr_surtidor;
   encontrado : boolean;
	   
begin
   error:=0;
   encontrado:=false;
   cursor:=list_surt;
   while (cursor <> nil) and (encontrado = false) do
   begin
      eliminar_factura_surtidor(cursor^.arb_ventas, nfactura, encontrado);
      cursor:=cursor^.sig;
   end;
   if not encontrado then
      error:=ERROR_FACTURA_NO_EXISTE
end; { eliminar_factura }

procedure validar_numero_factura_cancelar(    nfact : integer;
					  var error : integer);
begin
   error:=0;
   if not factura_valida(nfact) then
      error:=ERROR_FACTURA;
end; { validar_numero_factura_cancelar }

procedure cancelar_factura(list_surtidores : ptr_surtidor);
var
   numero_factura, error : integer;

begin
   error:=0;
   clrscr();
   leer_numero_factura(numero_factura);
   validar_numero_factura_cancelar(numero_factura, error);
   if error > 0 then
      imprimir_error(error)
   else
   begin
      eliminar_factura(list_surtidores, numero_factura, error);
      if error > 0 then
	 imprimir_error(error);
   end;
end; { cancelar_factura }

function calcular_comision(nodo_playero	 : ptr_playero;
			   nodo_surtidor : ptr_surtidor;
			   nodo_ventas	 : ptr_ventas):real;
begin
   calcular_comision:=nodo_surtidor^.surtidor.combustible.precio*
   nodo_ventas^.factura.litros_vendidos * (nodo_playero^.playero.porc_comision
					   / 100.0);
end; { calcular_comision }

function comision_playero_surtidor(arb_ventas : ptr_ventas;
				   playero    : ptr_playero;
				   surtidor   : ptr_surtidor):real;
var
   comision : real;

begin
   comision:=0;
   if arb_ventas <> nil then
   begin
      if arb_ventas^.p_playero = playero then
	 comision:=calcular_comision(playero, surtidor, arb_ventas);
      comision:=comision+comision_playero_surtidor(arb_ventas^.izq,
						   playero, surtidor);
      comision:=comision+comision_playero_surtidor(arb_ventas^.der,
						   playero, surtidor);
   end;
   comision_playero_surtidor:=comision;
end; { comision_playero_surtidor }

function comision_playero(list_surtidores : ptr_surtidor;
			  playero	  : ptr_playero):real;
var
   cursor   : ptr_surtidor;
   comision : real;

begin
   comision:=0;
   cursor:=list_surtidores;
   while (cursor <> nil) do
   begin
      comision:=comision+comision_playero_surtidor(cursor^.arb_ventas,
						   playero,
						   cursor);
      cursor:=cursor^.sig;
   end;
   comision_playero:=comision;
end; { comision_playero }

procedure leer_datos_calc_comision_playero(var nplayero : integer);
begin
   clrscr();
   write('Ingrese el numero de playero: ');
   readln(nplayero);
end; { leer_datos_calc_comision_playero }

procedure validar_datos_calc_comision_playero(	  nplayero : integer;
					      var error	   : integer);
begin
   error:=0;
   if not playero_valido(nplayero) then
      error:=ERROR_PLAYERO;
end; { validar_datos_cal_comision_playero }

procedure calcular_comision_playero(list_surtidores : ptr_surtidor;
				    arb_playeros    : ptr_playero);
var
   playero	   : ptr_playero;
   nplayero, error : integer;
   comision	   : real;

begin
   error:=0;
   leer_datos_calc_comision_playero(nplayero);
   validar_datos_calc_comision_playero(nplayero, error);
   if error > 0 then
      imprimir_error(error)
   else
   begin
      playero:=buscar_playero(arb_playeros, nplayero);
      if playero = nil then
      begin
	 error:=ERROR_PLAYERO_INEXISTENTE;
	 imprimir_error(error)
      end
      else
      begin
	 comision:=comision_playero(list_surtidores, playero);
	 writeln('La comision del playero es: ', comision:1:2);
	 readln();
      end;
   end;
end; { calcular_comision_playero }

function crear_nodo_lista_playero(playero  : ptr_playero;
				  comision : real):ptr_lista_playero;
var
   nuevo : ptr_lista_playero;

begin
   new(nuevo);
   nuevo^.playero:=playero;
   nuevo^.comision:=comision;
   nuevo^.sig:=nil;
   crear_nodo_lista_playero:=nuevo;
end; { crear_nodo_lista_playero }

procedure insertar_lista_playero(var lista    : ptr_lista_playero;
				     playero  : ptr_playero;
				     comision : real);
var
   nuevo  : ptr_lista_playero;
   cursor : ptr_lista_playero;
   
begin
   nuevo:=crear_nodo_lista_playero(playero, comision);
   if (lista = nil) or (lista^.comision > comision) then
   begin
      nuevo^.sig:=lista;
      lista:=nuevo;
   end
   else
   begin
      cursor:=lista;
      while (cursor^.sig <> nil) and (cursor^.sig^.comision < comision) do
	 cursor:=cursor^.sig;
      nuevo^.sig:=cursor^.sig;
      cursor^.sig:=nuevo;
   end;
end; { insertar_lista_playero }

procedure crear_lista_playeros(var lista_playeros : ptr_lista_playero;
				  list_surt	  : ptr_surtidor;
				  arb_playeros	  : ptr_playero);
var
   comision : real;

begin
   if arb_playeros <> nil then
   begin
      comision:=comision_playero(list_surt, arb_playeros);
      insertar_lista_playero(lista_playeros, arb_playeros, comision);
      crear_lista_playeros(lista_playeros, list_surt, arb_playeros^.izq);
      crear_lista_playeros(lista_playeros, list_surt, arb_playeros^.der);
   end;
   
end; { crear_lista_playeros }

procedure eliminar_lista_playeros(var lista_playeros : ptr_lista_playero);
var
   tmp : ptr_lista_playero;
   
begin
   while lista_playeros <> nil do
   begin
      tmp:=lista_playeros;
      lista_playeros:=lista_playeros^.sig;
      dispose(tmp);
   end;
end; { eliminar_lista_playeros }

procedure listar_playeros_comision(list_surt	: ptr_surtidor;
				   arb_playeros	: ptr_playero);
var
   lista_playeros, cursor : ptr_lista_playero;
   playero		  : tipo_playero;
   comision		  : real;

begin
   clrscr();
   lista_playeros:=nil;
   crear_lista_playeros(lista_playeros, list_surt, arb_playeros);
   writeln('Numero','Apellido y Nombre':30,'Porcentaje comision':30,'Comision':25);
   cursor:=lista_playeros;
   while cursor <> nil do
   begin
      playero:=cursor^.playero^.playero;
      comision:=cursor^.comision;
      writeln(playero.numero:6,playero.apellido+', '+playero.nombre:30,
	      playero.porc_comision:30, comision:25:2);
      cursor:=cursor^.sig;
   end;
   eliminar_lista_playeros(lista_playeros);
   readln();
end; { listar_playeros_comision }

procedure abrir_arc_playeros(var arch	: file of tipo_playero;
				 nombre	: string);
begin
   assign(arch, nombre);
   {$I-}
   reset(arch);
   {$I+}
   if ioresult <> 0 then
      rewrite(arch);
end; { abrir_arc_playeros }

procedure abrir_arc_surtidores(var arch	  : file of tipo_surtidor;
				   nombre : string);
begin
   assign(arch, nombre);
   {$I-}
   reset(arch);
   {$I+}
   if ioresult <> 0 then
      rewrite(arch);
end; { abrir_arc_surtidores }

procedure abrir_arc_ventas_acum(var arch   : file of tipo_vtas_acum;
				    nombre : string);
begin
   assign(arch, nombre);
   {$I-}
   reset(arch);
   {$I-}
   if ioresult <> 0 then
      rewrite(arch);
end; { abrir_arc_ventas_acum }

procedure cargar_arbol_playeros(var arch     : file of tipo_playero;
				var    arbol : ptr_playero);
var
   playero   : tipo_playero;
   p_playero : ptr_playero;

begin
   while not eof(arch) do
   begin
      read(arch, playero);
      p_playero:=crear_playero(playero);
      insertar_playero(arbol, p_playero);
   end;
end; { cargar_arbol_playeros }

procedure cargar_lista_surtidores(var arch	      : file of tipo_surtidor;
				  var list_surtidores : ptr_surtidor);
var
   surtidor : tipo_surtidor;
      
begin
   while not eof(arch) do
   begin
      read(arch, surtidor);
      insertar_surtidor(list_surtidores, surtidor);
   end;
end; { cargar_lista_surtidores }

procedure cargar_estructuras(var arb_playeros	: ptr_playero;
			     var lis_surtidores	: ptr_surtidor;
			     var arch_p		: file of tipo_playero;
			     var arch_s		: file of tipo_surtidor);
begin
   cargar_arbol_playeros(arch_p, arb_playeros);
   cargar_lista_surtidores(arch_s, lis_surtidores);
end; { cargar_estructuras }


procedure guardar_vtas_acumuladas(var arch : file of tipo_vtas_acum;
				      vtas : tipo_vtas_acum);
begin
   seek(arch, FileSize(arch));
   write(arch, vtas);
end; { guardar_vtas_acumuladas }

procedure guardar_playeros(var arch	    : file of tipo_playero;
			       arb_playeros : ptr_playero);
begin
   if arb_playeros <> nil then
   begin
      write(arch, arb_playeros^.playero);
      guardar_playeros(arch, arb_playeros^.izq);
      guardar_playeros(arch, arb_playeros^.der);
   end;
end; { guardar_playeros }

procedure insertar_surtidor_por_capacidad(    surtidor	      : tipo_surtidor;
					  var list_surtidores : ptr_surtidor);
var
   cursor, nodo_surt : ptr_surtidor;
   
begin
   nodo_surt:=crear_surtidor(surtidor);
   if (list_surtidores = nil) or (nodo_surt^.surtidor.capacidad < list_surtidores^.surtidor.capacidad) then
   begin
      nodo_surt^.sig:=list_surtidores;
      list_surtidores:=nodo_surt;
   end
   else
   begin
      cursor:=list_surtidores^.sig;
      while (cursor^.sig <> nil) and (nodo_surt^.surtidor.capacidad > cursor^.sig^.surtidor.capacidad) do
	 cursor:=cursor^.sig;
      nodo_surt^.sig:=cursor^.sig;
      cursor^.sig:=nodo_surt;
   end;
end; { insertar_surtidor_por_capacidad }

procedure crear_lista_surt_por_capacidad(    list_origen  : ptr_surtidor;
					 var list_destino : ptr_surtidor);
begin
   list_destino:=nil;
   while (list_origen <> nil) do
   begin
      insertar_surtidor_por_capacidad(list_origen^.surtidor, list_destino);
      list_origen:=list_origen^.sig;
   end;
end; { crear_lista_surt_por_capacidad }

procedure eliminar_lista_surtidores(var list_surtidores	: ptr_surtidor);
var
   cursor : ptr_surtidor;
   
begin 
   while list_surtidores <> nil do
   begin
      cursor:=list_surtidores;
      list_surtidores:=list_surtidores^.sig;
      dispose(cursor);
   end;
end; { eliminar_lista_surtidores }

procedure guardar_surtidores(var arch : file of tipo_surtidor;
				 lis  : ptr_surtidor);
var
   list_surt_capacidad : ptr_surtidor;
   
begin
   list_surt_capacidad:=nil;
   crear_lista_surt_por_capacidad(lis, list_surt_capacidad);
   if lis <> nil then
   begin
      write(arch, lis^.surtidor);
      guardar_surtidores(arch, lis^.sig);
   end;
   eliminar_lista_surtidores(list_surt_capacidad);
end; { guardar_surtidores }

procedure guardar_datos(var arch_p	   : file of tipo_playero;
			var arch_s	   : file of tipo_surtidor;
			var arch_v	   : file of tipo_vtas_acum;
			    arb_playeros   : ptr_playero;
			    lis_surtidores : ptr_surtidor;
			    vtas_acum	   : tipo_vtas_acum);
begin
   rewrite(arch_p);
   rewrite(arch_s);
   guardar_playeros(arch_p, arb_playeros);
   guardar_surtidores(arch_s, lis_surtidores);
   guardar_vtas_acumuladas(arch_v, vtas_acum);
   close(arch_p);
   close(arch_s);
   close(arch_v);
end; { guardar_datos }


procedure mostrar_ventas_dia(vtas : tipo_vtas_acum);
begin
   clrscr();
   writeln('Ventas del dia ', vtas.dia_vtas);
   writeln('Litros vendidos ', vtas.litros_vendidos:0:2);
   writeln('Dinero recibido ', vtas.dinero:0:2);
   readln();
end; { mostrar_ventas_dia }      

procedure calcular_vtas_acumuladas(    lis_surtidores : ptr_surtidor;
				   var vtas	      : tipo_vtas_acum);
var
   cursor : ptr_surtidor;
   litros : real;
   
begin
   cursor:=lis_surtidores;
   vtas.litros_vendidos:=0;
   vtas.dinero:=0;
   while cursor <> nil do
   begin
      litros:=litros_vendidos_surtidor(cursor^.arb_ventas);
      vtas.litros_vendidos:=vtas.litros_vendidos+litros;
      vtas.dinero:=vtas.dinero+litros*cursor^.surtidor.combustible.precio;
      cursor:=cursor^.sig;
   end;
end; { calcular_vtas_acumuladas }

procedure inicializar_estructuras(var list_surtidores : ptr_surtidor;
				  var arb_playeros    : ptr_playero);
begin
   list_surtidores:=nil;
   arb_playeros:=nil;
end; { inicializar_estructuras }

function ultimo_dia_vtas_acum(var arch : file of tipo_vtas_acum):integer;
var
   vtas	: tipo_vtas_acum;
begin
   if eof(arch) then
      ultimo_dia_vtas_acum:=0
   else
   begin
      seek(arch, filesize(arch)-1);
      read(arch, vtas);
      ultimo_dia_vtas_acum:=vtas.dia_vtas;
   end;
end; { ultimo_dia_vtas_acum }

function dia_valido(dia	: integer):boolean;
begin
   dia_valido:=(dia >= 1) and (dia <= DIAS_MES);
end; { dia_valido }

procedure validar_datos_dia(	dia, ultimodia : integer;
			    var error	       : integer);
begin
   error:=0;
   if not dia_valido(dia) then
      error:=ERROR_DIA
   else if dia <= ultimodia then
      error:=ERROR_DIA_MENOR;
end; { validar_datos_dia }

procedure salir(    lis_surtidores : ptr_surtidor;
		var vtas_acum	   : tipo_vtas_acum);
begin
   calcular_vtas_acumuladas(lis_surtidores, vtas_acum);
   mostrar_ventas_dia(vtas_acum);
end; { salir }

procedure menu(var lis_surtidores : ptr_surtidor;
	       var arb_playeros	  : ptr_playero;
	       var vtas_acum	  : tipo_vtas_acum);

var	   
   opcion : char;

begin
   repeat
      clrscr();
      writeln('SEC II');
      writeln('1. Agregar surtidor y tanque');
      writeln('2. Agregar playero');
      writeln('3. Listar surtidores');
      writeln('4. Realizar venta');
      writeln('5. Cancelar una factura');
      writeln('6. Calcular comision de un playero');
      writeln('7. Listar playeros ordenados por comision cobrada');
      writeln('8. Mostrar ventas acumuladas del dia y Salir');
      write('Ingrese una opcion: ');
      readln(opcion);
      if opcion = '1' then
	 agregar_surtidor(lis_surtidores)
      else if opcion = '2' then
	 agregar_playero(arb_playeros)
      else if opcion = '3' then
	 listar_surtidores(lis_surtidores)
      else if opcion = '4' then
	 realizar_venta(lis_surtidores, arb_playeros)
      else if opcion = '5' then
	 cancelar_factura(lis_surtidores)
      else if opcion = '6' then
	 calcular_comision_playero(lis_surtidores, arb_playeros)
      else if opcion = '7' then
	 listar_playeros_comision(lis_surtidores, arb_playeros)
      else if opcion = '8' then
	 salir(lis_surtidores, vtas_acum)
      else
      begin
	 writeln('Opcion invalida');
	 readln();
      end
   until opcion = '8';
end; { menu }

procedure leer_dia(var dia	 : integer;
		       ultimodia : integer);
var
   error : integer;
   
begin
   repeat
      error:=0;
      clrscr();
      write('Ingrese el dia: ');
      readln(dia);
      validar_datos_dia(dia, ultimodia, error);
      if error > 0 then
	 imprimir_error(error)
      until error = 0;
end; { leer_dia }

procedure abrir_archivos(var arc_surt : file of tipo_surtidor;
			 var arc_play : file of tipo_playero;
			 var arc_vtas : file of tipo_vtas_acum);
begin
   abrir_arc_surtidores(arc_surt, N_ARC_SURTIDORES);
   abrir_arc_playeros(arc_play, N_ARC_PLAYEROS);
   abrir_arc_ventas_acum(arc_vtas, N_ARC_VTAS);
end; { abrir_archivos }


var		    
   lista_surtidores : ptr_surtidor;
   arb_playeros	    : ptr_playero;
   vtas_acum	    : tipo_vtas_acum;
   arc_vtas_acum    : file of tipo_vtas_acum;
   arc_playeros	    : file of tipo_playero;
   arc_surtidores   : file of tipo_surtidor;
   ultimo_dia	    : integer;
   
begin
   inicializar_estructuras(lista_surtidores, arb_playeros);
   abrir_archivos(arc_surtidores, arc_playeros, arc_vtas_acum); 
   cargar_estructuras(arb_playeros, lista_surtidores, arc_playeros, arc_surtidores);
   
   ultimo_dia:=ultimo_dia_vtas_acum(arc_vtas_acum); {ultimo dia en el que se realizo una venta
						    se asume que los dias son ingresados en orden
						    cronologico}
   if ultimo_dia = DIAS_MES then {si se llego al ultimo dia del mes, comienza de nuevo}
   begin
      rewrite(arc_vtas_acum);
      ultimo_dia:=0;
   end;
   leer_dia(vtas_acum.dia_vtas, ultimo_dia);
   vtas_acum.dinero:=0;
   vtas_acum.litros_vendidos:=0;

   menu(lista_surtidores, arb_playeros, vtas_acum);
   guardar_datos(arc_playeros, arc_surtidores, arc_vtas_acum, arb_playeros,
		 lista_surtidores, vtas_acum);
end.
