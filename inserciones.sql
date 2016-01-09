    
SET SERVEROUTPUT ON
DECLARE
	v_date 	DATE;

BEGIN
--Insertar clientes
insertar.insertarCliente(
			Tipo_Lista_Direccion(Tipo_Direccion('Espania','cadiz','Calle Brasil',1,'11010')),
			'76080802M','Manuel','Moreno');

insertar.insertarCliente(
			Tipo_Lista_Direccion(Tipo_Direccion('Francia','aaaaa','bbbb',7,'110AA')),
			'7602M','Fran','Zidane');

insertar.insertarCliente(
			Tipo_Lista_Direccion(Tipo_Direccion('Espania','aaaaa','bbbb',7,'110AA'),
						Tipo_Direccion('Espania','ccccc','bbbb',7,'110AA'),
						Tipo_Direccion('Espania','ddddd','bbbb',7,'110AA')),
			'999999M','Fran','Zidane');

--Insertar proveedores
insertar.insertarProveedor('AA55F','Proveedor1',
			Tipo_Direccion('Espania','Jerez','Plaza Espania',1,'12200'));

insertar.insertarProveedor('ZZAA6','Proveedor2',
			Tipo_Direccion('Espania','Chiclana','Calle Cruz',5,'15555'));

--Insertar producto

insertar.insertarProdSoft(30,'Antivirus NOD32',58.5,'GPL','aa55f');
insertar.insertarProdHard(40,'Memoria RAM',38.5,'DDR3','zzaa6');

--Se crea un nuevo Pedido
v_date := SYSDATE;
insertar.insertarPedido('76080802M',v_date);
--Insertar Linea Detalle. Se le pasa el DNI del cliente y la Fecha para identificar el pedido del cliente
insertar.insertarLineaSoft('Antivirus NOD32',1,'76080802M',v_date);
insertar.insertarLineaHard('Memoria RAM',5,'76080802M',v_date);


END;
/

   