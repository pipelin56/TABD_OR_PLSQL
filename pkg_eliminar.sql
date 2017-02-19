--Definicion--
SET SERVEROUTPUT ON
 
CREATE OR REPLACE PACKAGE eliminar IS
	PROCEDURE eliminarCliente(
	        v_dni               Tabla_Cliente.Dni_Cliente%TYPE
	);

	PROCEDURE eliminarProveedor(
	        v_cif     Tabla_Proveedor.Cif_Proveedor%TYPE
	);

END eliminar;
/


-- Implementacion --
CREATE OR REPLACE PACKAGE BODY eliminar IS

	PROCEDURE eliminarCliente(
	    v_dni               Tabla_Cliente.Dni_Cliente%TYPE) IS
		E_NO_DNI	EXCEPTION;
		BEGIN
		
		    DELETE FROM Tabla_cliente WHERE Dni_Cliente = lower(v_dni);
		    IF SQL%NOTFOUND THEN
	  			RAISE E_NO_DNI;	  			
			END IF;

			DBMS_OUTPUT.PUT_LINE('Eliminado Cliente con DNI ' || v_dni||'.');

		EXCEPTION
			WHEN E_NO_DNI THEN
				DBMS_OUTPUT.PUT_LINE('No existe Cliente con DNI ' || v_dni||'.');
			WHEN OTHERS THEN
				DBMS_OUTPUT.PUT_LINE('Error al eliminar un Cliente.');

	END eliminarCliente;

	PROCEDURE eliminarProveedor(
    	v_cif               Tabla_Proveedor.Cif_Proveedor%TYPE) IS
		E_NO_CIF	EXCEPTION;
		BEGIN
		
		    DELETE FROM Tabla_Proveedor WHERE Cif_Proveedor = lower(v_cif);
		    IF SQL%NOTFOUND THEN
	  			RAISE E_NO_CIF;
			END IF;

			DBMS_OUTPUT.PUT_LINE('Eliminado Proveedor con CIF ' || v_cif||'.');

			EXCEPTION
				WHEN E_NO_CIF THEN
				 	DBMS_OUTPUT.PUT_LINE('No existe Proveedor con CIF ' || v_cif||'.');
				WHEN OTHERS THEN
					DBMS_OUTPUT.PUT_LINE('Error al liminar un Proveedor.');

	END eliminarProveedor;
END eliminar;
/

