    
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
			'999999M','Fran','Ronaldo');

--Insertar proveedores
insertar.insertarProveedor('AA55F','Proveedor1',
			Tipo_Direccion('Espania','Jerez','Plaza Espania',1,'12200'));

insertar.insertarProveedor('ZZAA6','Proveedor2',
			Tipo_Direccion('Espania','Chiclana','Calle Cruz',5,'15555'));

--Insertar producto

insertar.insertarProdSoft(30,'Antivirus NOD32',58.5,'Software Privado','aa55f');
insertar.insertarProdSoft(30,'Office Libre',58.5,'GPL','zzaa6');
insertar.insertarProdSoft(20,'Antivirus Norton 360',40.5,'Software Privado','aa55f');
insertar.insertarProdSoft(60,'Microsoft Office 2013',68.75,'Software Privado','zzaa6');

insertar.insertarProdHard(40,'Memoria RAM 4GB Kingston',38.5,'DDR3','zzaa6');
insertar.insertarProdHard(100,'Pendrive 16GB Sandisk',18.5,'USB 3.0','aa55f');
insertar.insertarProdHard(20,'Disco Duro 1TB Verbatim',78.5,'USB 3.0','zzaa6');

--Se crea un nuevo Pedido
v_date := SYSDATE;
insertar.insertarPedido('76080802M',v_date);
--Insertar Linea Detalle. Se le pasa el DNI del cliente y la Fecha para identificar el pedido del cliente
insertar.insertarLineaSoft('Antivirus NOD32',1,'76080802M',v_date);
insertar.insertarLineaHard('Memoria RAM 4GB Kingston',5,'76080802M',v_date);

-- Nuevo Pedido. Sumamos  0.001 para que la fecha varie un poco ya que al ejecutarse el script tan rapido, 
-- las fechas que se toman sobre la variable v_date son iguales y produce un fallo.
v_date := SYSDATE + 0.001;
insertar.insertarPedido('76080802M',v_date);
insertar.insertarLineaSoft('Microsoft Office 2013',10000,'76080802M',v_date);
insertar.insertarLineaHard('Disco Duro 1TB Verbatim',5000,'76080802M',v_date);
insertar.insertarLineaHard('Pendrive 16GB Sandisk',15,'76080802M',v_date);

v_date := SYSDATE + 0.005;
insertar.insertarPedido('999999M',v_date);
insertar.insertarLineaSoft('Microsoft Office 2013',1,'999999M',v_date);
insertar.insertarLineaHard('Disco Duro 1TB Verbatim',5,'999999M',v_date);
insertar.insertarLineaHard('Pendrive 16GB Sandisk',10,'999999M',v_date);

END;
/

   