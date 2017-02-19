--Definicion--
SET SERVEROUTPUT ON
 
CREATE OR REPLACE PACKAGE actualizar IS
	PROCEDURE actualizarCliente(
	        v_direccion			Tabla_Cliente.Direcciones_Cliente%TYPE,
	        v_dni               Tabla_Cliente.Dni_Cliente%TYPE,
	        v_dni_nuevo         Tabla_Cliente.Dni_Cliente%TYPE,
	        v_nombre          	Tabla_Cliente.Nombre_Cliente%TYPE,
	        v_apellido         	Tabla_Cliente.Apellidos_Cliente%TYPE
	);

	PROCEDURE actualizarProveedor(
	        v_cif				Tabla_Proveedor.Cif_Proveedor%TYPE,
	        v_cif_nuevo			Tabla_Proveedor.Cif_Proveedor%TYPE,
        	v_nombre			Tabla_Proveedor.Nombre_Proveedor%TYPE,
        	v_direccion  		Tabla_Proveedor.Direccion_Proveedor%TYPE
	);

	PROCEDURE actualizarProdSoft(
			v_stock				Tabla_Producto.Stock%TYPE,
	 		v_nombre			Tabla_Producto.Nombre_Producto%TYPE,
	 		v_nombre_nuevo		Tabla_Producto.Nombre_Producto%TYPE,			
	 		v_precio 			Tabla_Producto.Precio_Producto%TYPE,
	 		v_licencia			Tabla_Prod_Software.Licencia%TYPE,
	 		v_cif_pvr			Tabla_Proveedor.Cif_Proveedor%TYPE
	);

	PROCEDURE actualizarProdHard(
			v_stock				Tabla_Producto.Stock%TYPE,
			v_nombre			Tabla_Producto.Nombre_Producto%TYPE,
			v_nombre_nuevo		Tabla_Producto.Nombre_Producto%TYPE,			
			v_precio 			Tabla_Producto.Precio_Producto%TYPE,			
			v_conexion			Tabla_Prod_Hardware.Tipo_Conexion%TYPE,
			v_nombre_pvr		Tabla_Proveedor.Nombre_Proveedor%TYPE
	);

END actualizar;
/


-- Implementacion --
CREATE OR REPLACE PACKAGE BODY actualizar IS

	PROCEDURE actualizarCliente(
	    	v_direccion			Tabla_Cliente.Direcciones_Cliente%TYPE,
	        v_dni               Tabla_Cliente.Dni_Cliente%TYPE,
	        v_dni_nuevo         Tabla_Cliente.Dni_Cliente%TYPE,
	        v_nombre          	Tabla_Cliente.Nombre_Cliente%TYPE,
	        v_apellido         	Tabla_Cliente.Apellidos_Cliente%TYPE) IS
			
			E_NO_DNI	EXCEPTION;
		BEGIN

		    UPDATE Tabla_cliente SET Direcciones_Cliente=v_direccion, Dni_Cliente=lower(v_dni_nuevo),
		    		 				 Nombre_Cliente=lower(v_nombre), Apellidos_Cliente=lower(v_apellido) 
		    		 				 Where Dni_Cliente=lower(v_dni);

		    IF SQL%NOTFOUND THEN
		    	RAISE E_NO_DNI;	  			
			END IF;

			DBMS_OUTPUT.PUT_LINE('Datos del cliente actualizados.');
		EXCEPTION
			WHEN E_NO_DNI THEN
				DBMS_OUTPUT.PUT_LINE('Error al actualizar Cliente. No existe el DNI '||v_dni||'.');
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('Error al actualizar un Cliente.');

	END actualizarCliente;

	PROCEDURE actualizarProveedor(
	    	v_cif				Tabla_Proveedor.Cif_Proveedor%TYPE,
	        v_cif_nuevo			Tabla_Proveedor.Cif_Proveedor%TYPE,
        	v_nombre			Tabla_Proveedor.Nombre_Proveedor%TYPE,
        	v_direccion  		Tabla_Proveedor.Direccion_Proveedor%TYPE) IS
			E_NO_CIF	EXCEPTION;
		BEGIN

		    UPDATE Tabla_Proveedor SET Cif_Proveedor=lower(v_cif_nuevo),
		    		 				 Nombre_Proveedor=lower(v_nombre), Direccion_Proveedor=v_direccion
		    		 				 Where Cif_Proveedor=lower(v_cif);

		    IF SQL%NOTFOUND THEN
		    	RAISE E_NO_CIF;
			END IF;
			DBMS_OUTPUT.PUT_LINE('Datos del Proveedor actualizados.');

		EXCEPTION
			WHEN E_NO_CIF THEN
				DBMS_OUTPUT.PUT_LINE('Error al actualizar Proveedor. No existe el CIF '||v_cif||'.');
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('Error al actualizar un Proveedor.');

	END actualizarProveedor;


	PROCEDURE actualizarProdSoft(
	    	v_stock				Tabla_Producto.Stock%TYPE,
	 		v_nombre			Tabla_Producto.Nombre_Producto%TYPE,
	 		v_nombre_nuevo		Tabla_Producto.Nombre_Producto%TYPE,			
	 		v_precio 			Tabla_Producto.Precio_Producto%TYPE,
	 		v_licencia			Tabla_Prod_Software.Licencia%TYPE,
	 		v_cif_pvr			Tabla_Proveedor.Cif_Proveedor%TYPE) IS
			E_NO_PROD	EXCEPTION;
		BEGIN

		    UPDATE Tabla_Prod_Software SET Stock=v_stock, Nombre_Producto=lower(v_nombre_nuevo),
		    		 				 Precio_Producto=v_precio, Licencia=lower(v_licencia),
		    		 				 Proveido_Por=Tipo_Tabla_Ref_Proveedor() 
		    		 				 Where Nombre_Producto=lower(v_nombre);

		    IF SQL%NOTFOUND THEN
	  			RAISE E_NO_PROD;
			END IF;
			DBMS_OUTPUT.PUT_LINE('Datos del Producto Software actualizados.');
		
		EXCEPTION
			WHEN E_NO_PROD THEN
				DBMS_OUTPUT.PUT_LINE('Error al actualizar Producto Software. No existe '||v_nombre||'.');
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('Error al actualizar un Producto Software.');

	END actualizarProdSoft;

	PROCEDURE actualizarProdHard(
	    	v_stock				Tabla_Producto.Stock%TYPE,
			v_nombre			Tabla_Producto.Nombre_Producto%TYPE,
			v_nombre_nuevo		Tabla_Producto.Nombre_Producto%TYPE,			
			v_precio 			Tabla_Producto.Precio_Producto%TYPE,			
			v_conexion			Tabla_Prod_Hardware.Tipo_Conexion%TYPE,
			v_nombre_pvr		Tabla_Proveedor.Nombre_Proveedor%TYPE) IS
			E_NO_PROD	EXCEPTION;
		BEGIN
		    UPDATE Tabla_Prod_Hardware SET Stock=v_stock, Nombre_Producto=lower(v_nombre_nuevo),
		    		 				 Precio_Producto=v_precio, Tipo_Conexion=lower(v_conexion),
		    		 				 Proveido_Por=Tipo_Tabla_Ref_Proveedor() 
		    		 				 Where Nombre_Producto=lower(v_nombre);

		    IF SQL%NOTFOUND THEN
		  		RAISE E_NO_PROD;
			END IF;
			DBMS_OUTPUT.PUT_LINE('Datos del Producto Hardware actualizados.');

		EXCEPTION
			WHEN E_NO_PROD THEN 
				DBMS_OUTPUT.PUT_LINE('Error al actualizar Producto Hardware. No existe '||v_nombre||'.');
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('Error al actualizar Producto Hardware.');

	END actualizarProdHard;
END actualizar;
/








