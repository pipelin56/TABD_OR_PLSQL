--Definicion--
SET SERVEROUTPUT ON
 
CREATE OR REPLACE PACKAGE insertar IS
	PROCEDURE insertarCliente(
			v_direccion			Tabla_Cliente.Direcciones_Cliente%TYPE,
	        v_dni               Tabla_Cliente.Dni_Cliente%TYPE,
	        v_nombre          	Tabla_Cliente.Nombre_Cliente%TYPE,
	        v_apellido         	Tabla_Cliente.Apellidos_Cliente%TYPE
	);

	PROCEDURE insertarProveedor(
			v_cif				Tabla_Proveedor.Cif_Proveedor%TYPE,
	        v_nombre			Tabla_Proveedor.Nombre_Proveedor%TYPE,
	        v_direccion  		Tabla_Proveedor.Direccion_Proveedor%TYPE
	); 

	PROCEDURE insertarLineaSoft(
        v_producto			Tabla_Producto.Nombre_Producto%TYPE,
        v_cantidad			Tabla_Linea_Detalle.Cantidad%TYPE,
        v_cliente			Tabla_Cliente.Dni_Cliente%TYPE,
        v_fecha				DATE
	);

	PROCEDURE insertarLineaHard(
        v_producto			Tabla_Producto.Nombre_Producto%TYPE,
        v_cantidad			Tabla_Linea_Detalle.Cantidad%TYPE,
        v_cliente			Tabla_Cliente.Dni_Cliente%TYPE,
        v_fecha				DATE
	);

	PROCEDURE insertarPedido(
        v_pedido_Por		Tabla_Cliente.Dni_Cliente%TYPE,
        v_fecha				Tabla_Pedido.Fecha_Pedido%TYPE
	);

	PROCEDURE insertarProdSoft(
		v_stock				Tabla_Producto.Stock%TYPE,
	 	v_nombre			Tabla_Producto.Nombre_Producto%TYPE,			
	 	v_precio 			Tabla_Producto.Precio_Producto%TYPE,
	 	v_licencia			Tabla_Prod_Software.Licencia%TYPE,
	 	v_cif_pvr			Tabla_Proveedor.Cif_Proveedor%TYPE
	);

	PROCEDURE insertarProveedorProducto(
		v_nombre_prod 			Tabla_Producto.Nombre_Producto%TYPE,
		v_cif_pvr				Tabla_Proveedor.Cif_Proveedor%TYPE
	);

	PROCEDURE insertarProdHard(
		v_stock				Tabla_Producto.Stock%TYPE,
		v_nombre			Tabla_Producto.Nombre_Producto%TYPE,			
		v_precio 			Tabla_Producto.Precio_Producto%TYPE,			
		v_conexion			Tabla_Prod_Hardware.Tipo_Conexion%TYPE,
		v_nombre_pvr		Tabla_Proveedor.Nombre_Proveedor%TYPE
	);

END insertar;
/

-- Implementacion --
CREATE OR REPLACE PACKAGE BODY insertar IS
 
-- Precondicion: recibe como parametros la direccion, dni, nombre y apellido de un cliente nuevo
-- Postcondicion: inserta un nuevo cliente en la tabla Tabla_cliente
PROCEDURE insertarCliente(
		v_direccion			Tabla_Cliente.Direcciones_Cliente%TYPE,
        v_dni               Tabla_Cliente.Dni_Cliente%TYPE,
        v_nombre          	Tabla_Cliente.Nombre_Cliente%TYPE,
        v_apellido         	Tabla_Cliente.Apellidos_Cliente%TYPE) IS
		
		v_dni_lower 		Tabla_Cliente.Dni_Cliente%TYPE;
		
	BEGIN
		v_dni_lower := lower(v_dni); --Por si introduce la letra en Minuscula o Mayuscula
		INSERT INTO Tabla_Cliente(Id_Cliente,Direcciones_Cliente,Dni_Cliente,Nombre_Cliente,Apellidos_Cliente) 
			VALUES  (codClt_seq.NEXTVAL,v_direccion,v_dni_lower,v_nombre,v_apellido);

		DBMS_OUTPUT.PUT_LINE('Cliente introducido');

	EXCEPTION
		WHEN DUP_VAL_ON_INDEX THEN
			DBMS_OUTPUT.PUT_LINE('El DNI introducido ya existe en la BD');
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE('Se ha producido un error a la hora de insertar Cliente');

	END insertarCliente;

-- Precondicion: recibe el CIF, nombre y direccion de un proveedor
-- Postcondicion: inserta un nuevo proveedor en la tabla Tabla_Proveedor
	PROCEDURE insertarProveedor(
	       	v_cif				Tabla_Proveedor.Cif_Proveedor%TYPE,
        	v_nombre			Tabla_Proveedor.Nombre_Proveedor%TYPE,
        	v_direccion  		Tabla_Proveedor.Direccion_Proveedor%TYPE) IS

			v_cif_lower 		Tabla_Proveedor.Cif_Proveedor%TYPE;
			
		BEGIN
			v_cif_lower := lower(v_cif); --Por si introduce la letra en Minuscula o Mayuscula
			INSERT INTO Tabla_Proveedor(Id_Proveedor,Cif_Proveedor,Nombre_Proveedor,Direccion_Proveedor) 
				VALUES  (codProv_seq.NEXTVAL,v_cif_lower,v_nombre,v_direccion);

			DBMS_OUTPUT.PUT_LINE('Proveedor insertado');

		EXCEPTION
			WHEN DUP_VAL_ON_INDEX THEN
				DBMS_OUTPUT.PUT_LINE('El CIF introducido ya existe en la BD');
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('Error al insertar un Proveedor');

	END insertarProveedor;

-- Precondicion: recibe un nombre de producto de tipo Tipo_Producto_Software, cantidad vendida, nombre cliente que realiza pedido y la fecha y hora
-- Postcondicion: inserta dentro de la Tabla anidada Tiene_Lineas de tipo Tipo_Tabla_Linea_Detalle, la cual pertenece a un Pedido realizado 
--				  por el cliente indicado y en la fecha y hora que realizó el Pedido.
	PROCEDURE insertarLineaSoft(
	       	v_producto			Tabla_Producto.Nombre_Producto%TYPE,
        	v_cantidad			Tabla_Linea_Detalle.Cantidad%TYPE,
        	v_cliente			Tabla_Cliente.Dni_Cliente%TYPE,
        	v_fecha				DATE) IS

			v_ref_cli REF Tipo_Cliente;

		BEGIN
			SELECT REF(C) INTO v_ref_cli FROM Tabla_Cliente C WHERE C.Dni_Cliente = lower(v_cliente);
			
			INSERT INTO TABLE(SELECT L.Tiene_Lineas 
							  FROM Tabla_Pedido L 
							  WHERE L.Pedido_Por = v_ref_cli
							  		AND L.Fecha_Pedido = v_fecha)
					SELECT v_cantidad, REF(P)
					FROM Tabla_Prod_Software P WHERE P.Nombre_Producto = v_producto;

			DBMS_OUTPUT.PUT_LINE('Linea Detalle Software insertada en Pedido');

		EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('Error al inserta Linea Detalle Software en Pedido');

	END insertarLineaSoft;

-- Precondicion: recibe un nombre de producto de tipo Tipo_Producto_Hardware, cantidad vendida, nombre cliente que realiza pedido y la fecha y hora
-- Postcondicion: inserta dentro de la Tabla anidada Tiene_Lineas de tipo Tipo_Tabla_Linea_Detalle, la cual pertenece a un Pedido realizado 
--				  por el cliente indicado y en la fecha y hora que realizó el Pedido.
PROCEDURE insertarLineaHard(
	       	v_producto			Tabla_Producto.Nombre_Producto%TYPE,
        	v_cantidad			Tabla_Linea_Detalle.Cantidad%TYPE,
        	v_cliente			Tabla_Cliente.Dni_Cliente%TYPE,
        	v_fecha				DATE) IS

			v_ref_cli REF Tipo_Cliente;
		BEGIN
			SELECT REF(C) INTO v_ref_cli FROM Tabla_Cliente C WHERE C.Dni_Cliente = lower(v_cliente);
			
			INSERT INTO TABLE(SELECT L.Tiene_Lineas 
							  FROM Tabla_Pedido L 
							  WHERE L.Pedido_Por = v_ref_cli
							  		AND L.Fecha_Pedido = v_fecha)
					SELECT v_cantidad, REF(P)
					FROM Tabla_Prod_Hardware P WHERE P.Nombre_Producto = v_producto;

			DBMS_OUTPUT.PUT_LINE('Linea Detalle Hardware insertada en Pedido');

		EXCEPTION
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('Error al inserta Linea Detalle Hardware en Pedido');

	END insertarLineaHard;

-- Precondicion: recibe el DNI del cliente que realiza el pedido y la fecha y hora en la que lo realiza
-- Postcondicion: inserta en la tabla Tabla_Pedido un nuevo pedido realizado por el Cliente C a la fecha y hora X.
	PROCEDURE insertarPedido(
        	v_pedido_Por		Tabla_Cliente.Dni_Cliente%TYPE,
        	v_fecha				Tabla_Pedido.Fecha_Pedido%TYPE) IS

			v_ref_cli	REF Tipo_Cliente;
		BEGIN
			SELECT REF(C) INTO v_ref_cli FROM Tabla_Cliente C WHERE C.Dni_Cliente = lower(v_pedido_Por);
			
			INSERT INTO Tabla_Pedido(Id_Pedido, Fecha_Pedido, Pedido_Por,  Tiene_Lineas)
				VALUES  (codPed_Seq.NEXTVAL, v_fecha, v_ref_cli, Tipo_Tabla_Linea_Detalle());

			DBMS_OUTPUT.PUT_LINE('Pedido insertado');

		 EXCEPTION
		 	WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('Error al insertar un Pedido');

	END insertarPedido;

-- Precondicion: Recibe el stock, nombre , el precio, licencia de un Producto Software y el CIF de su Proveedor.
-- Postcondicion: Inserta en la tabla Tabla_Prod_Software un nuevo Producto Software.
	PROCEDURE insertarProdSoft(
		v_stock				Tabla_Producto.Stock%TYPE,
	 	v_nombre			Tabla_Producto.Nombre_Producto%TYPE,			
	 	v_precio 			Tabla_Producto.Precio_Producto%TYPE,
	 	v_licencia			Tabla_Prod_Software.Licencia%TYPE,
	 	v_cif_pvr			Tabla_Proveedor.Cif_Proveedor%TYPE
	 	) IS

		BEGIN
			INSERT INTO Tabla_Prod_Software(Id_Producto,Stock,Nombre_Producto,Precio_Producto,Licencia,Proveido_Por)
			VALUES (codProd_seq.NEXTVAL,v_stock,v_nombre,v_precio,v_licencia,Tipo_Tabla_Ref_Proveedor());

			DBMS_OUTPUT.PUT_LINE('Producto Software insertado');
			insertarProveedorProducto(v_nombre,v_cif_pvr);

			EXCEPTION
				WHEN OTHERS THEN
					ROLLBACK;
					DBMS_OUTPUT.PUT_LINE('Error al insertar un Producto Software');

	END insertarProdSoft;

-- Precondicion: Recibe el stock, nombre , el precio, tipo de conexion de un Producto Hardware y el CIF de su Proveedor.
-- Postcondicion: Inserta en la tabla Tabla_Prod_Software un nuevo Producto Hardware.
PROCEDURE insertarProdHard(
			v_stock				Tabla_Producto.Stock%TYPE,
			v_nombre			Tabla_Producto.Nombre_Producto%TYPE,			
			v_precio 			Tabla_Producto.Precio_Producto%TYPE,
			v_conexion			Tabla_Prod_Hardware.Tipo_Conexion%TYPE,
			v_nombre_pvr		Tabla_Proveedor.Nombre_Proveedor%TYPE
			) IS
		BEGIN
			INSERT INTO Tabla_Prod_Hardware(Id_Producto,Stock,Nombre_Producto,Precio_Producto,Tipo_Conexion, Proveido_Por)
			VALUES(codProd_seq.NEXTVAL,v_stock,v_nombre,v_precio,v_conexion,Tipo_Tabla_Ref_Proveedor());

			DBMS_OUTPUT.PUT_LINE('Producto Hardware insertado');

			EXCEPTION
				WHEN OTHERS THEN
					ROLLBACK;
					DBMS_OUTPUT.PUT_LINE('Error al insertar un Prodcuto Hardware');
	END insertarProdHard;

-- Precondicion: recibe el nombre de un Producto y el CIF de un su Proveedor
-- Postcondicion: inserta en la tabla Proveido_Por de tipo Tipo_Tabla_Ref_Proveedor de un Producto X, una referencia del proveedor
--				  del producto con el nombre pasado por paramentro.
	PROCEDURE insertarProveedorProducto(
		v_nombre_prod 			Tabla_Producto.Nombre_Producto%TYPE,
		v_cif_pvr				Tabla_Proveedor.Cif_Proveedor%TYPE
		) IS

		BEGIN
			INSERT INTO TABLE(
					SELECT S.Proveido_Por FROM Tabla_Prod_Software S	
					WHERE S.Nombre_Producto = v_nombre_prod)
			SELECT REF(P) FROM Tabla_Proveedor P WHERE P.Cif_Proveedor = v_cif_pvr;
			
			DBMS_OUTPUT.PUT_LINE('Proveedor insertado en producto');

			EXCEPTION
				WHEN OTHERS THEN
					ROLLBACK;
					DBMS_OUTPUT.PUT_LINE('Error al insertar un Proveedor a Prodcuto');
	END insertarProveedorProducto;

END insertar;
/
