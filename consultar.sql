DECLARE
	v_ref_P REF 	Tipo_Producto;
	v_ref_clt REF 	Tipo_Cliente;
	v_ref_pvr REF 	Tipo_Proveedor;

 	v_prod_soft		Tipo_Producto_Software;
	v_prod_hard		Tipo_Producto_Hardware;
	v_clt 			Tipo_Cliente;
	v_dir			Tipo_Direccion;
	v_pvr 			Tipo_Proveedor;

	CURSOR c_soft IS SELECT Nombre_Producto FROM Tabla_Prod_Software;
	CURSOR c_hard IS SELECT Nombre_Producto FROM Tabla_Prod_Hardware;
	CURSOR c_clt IS SELECT Dni_Cliente FROM Tabla_Cliente;
	CURSOR c_pvr IS SELECT Cif_Proveedor FROM Tabla_Proveedor;
	
BEGIN
	DBMS_OUTPUT.PUT_LINE('Proveedores en la BD:'||CHR(10)||'---------------------'||CHR(10));
	FOR r_pvr IN c_pvr LOOP
		SELECT REF(P) INTO v_ref_pvr FROM Tabla_Proveedor P WHERE P.Cif_Proveedor = r_pvr.Cif_Proveedor;
		UTL_REF.SELECT_OBJECT(v_ref_pvr, v_pvr);
		DBMS_OUTPUT.PUT_LINE('Nombre: '|| v_pvr.Nombre_Proveedor|| 
		  					 '  CIF: ' || v_pvr.Cif_Proveedor );

		--Mostremos la direccion del proveedor
		
		DBMS_OUTPUT.PUT_LINE('Dicreccion: ' || v_pvr.Direccion_Proveedor.Calle || ', '
				                  || v_pvr.Direccion_Proveedor.Numero|| ', '||
				                     v_pvr.Direccion_Proveedor.CP ||', '||
				                     v_pvr.Direccion_Proveedor.Ciudad||', '||
				                     v_pvr.Direccion_Proveedor.Pais);
		
		DBMS_OUTPUT.PUT_LINE(CHR(10));
	END LOOP;

	DBMS_OUTPUT.PUT_LINE(CHR(10)||'Productos Software en la BD:'||CHR(10)||'------------------'||CHR(10));
	--Mostramos los Producto Software
	FOR r_ref IN c_soft LOOP
		SELECT REF(P) INTO v_ref_P FROM Tabla_Prod_Software P WHERE P.Nombre_Producto = r_ref.Nombre_Producto;
		UTL_REF.SELECT_OBJECT(v_ref_P, v_prod_soft);
		DBMS_OUTPUT.PUT_LINE(v_prod_soft.imprimirproducto()||CHR(10));
		
	END LOOP;

	--Mostramos los Producto Hardware
	DBMS_OUTPUT.PUT_LINE(CHR(10)||CHR(10)||'Productos Hardware en la BD:'||CHR(10)||'------------------'||CHR(10));
	FOR r_ref IN c_hard LOOP
		SELECT REF(P) INTO v_ref_P FROM Tabla_Prod_Hardware P WHERE P.Nombre_Producto = r_ref.Nombre_Producto;
		UTL_REF.SELECT_OBJECT(v_ref_P, v_prod_hard);
		DBMS_OUTPUT.PUT_LINE(v_prod_hard.imprimirproducto()||CHR(10));
	END LOOP;

	DBMS_OUTPUT.PUT_LINE('Clientes en la BD:'||CHR(10)||'------------------'||CHR(10));
	FOR r_clt IN c_clt LOOP
		SELECT REF(C) into v_ref_clt FROM Tabla_Cliente C WHERE C.Dni_Cliente = r_clt.Dni_Cliente;
		UTL_REF.SELECT_OBJECT(v_ref_clt, v_clt);
		DBMS_OUTPUT.PUT_LINE('Nombre: '||v_clt.Nombre_Cliente||' '||
			                 v_clt.Apellidos_Cliente||CHR(10)||
			                 'DNI: '||upper(v_clt.Dni_Cliente));

		--Mostremos las direcciones de usuario
		FOR v_indice IN 1 .. v_clt.Direcciones_Cliente.COUNT LOOP
			DBMS_OUTPUT.PUT_LINE('Dicreccion '||v_indice|| ': ' || v_clt.Direcciones_Cliente(v_indice).Calle || ', '
				                  || v_clt.Direcciones_Cliente(v_indice).Numero|| ', '||
				                     v_clt.Direcciones_Cliente(v_indice).CP ||', '||
				                     v_clt.Direcciones_Cliente(v_indice).Ciudad||', '||
				                     v_clt.Direcciones_Cliente(v_indice).Pais);
		END LOOP;
		DBMS_OUTPUT.PUT_LINE(CHR(10));

		--Mostremos los pedidos que tenga un cliente, en caso de que tenga.
		DECLARE
			CURSOR c_ped IS SELECT Fecha_Pedido, Pedido_Por, Tiene_Lineas FROM Tabla_Pedido WHERE Pedido_Por = v_ref_clt;
			NO_HAY_PEDIDO EXCEPTION;
			var_num		NUMBER DEFAULT 0;
			var_prod 	Tipo_Producto;
			var_ref_ped	REF Tipo_Pedido;
			var_ped 	Tipo_Pedido;
		BEGIN

			FOR r_ped IN c_ped LOOP
				var_num := var_num + 1;
				DBMS_OUTPUT.PUT_LINE(CHR(9)||'Pedido '||var_num||'.'||CHR(9)||'   Fecha: '||TO_CHAR(r_ped.Fecha_Pedido,'MM-DD-YYYY HH24:MI:SS')||
									CHR(10)||CHR(9)||'--------------------------------------');
				SELECT REF(P) INTO var_ref_ped FROM Tabla_Pedido P 
						WHERE P.Fecha_Pedido = r_ped.Fecha_Pedido
							AND P.Pedido_Por = r_ped.Pedido_Por;

				UTL_REF.SELECT_OBJECT(var_ref_ped, var_ped);

				FOR v_indice IN 1 .. r_ped.Tiene_Lineas.COUNT LOOP
							UTL_REF.SELECT_OBJECT(r_ped.Tiene_Lineas(v_indice).Tiene_Producto,var_prod);
							DBMS_OUTPUT.PUT_LINE(CHR(9)||'  * '||r_ped.Tiene_Lineas(v_indice).Cantidad||
								',  '||var_prod.Nombre_Producto);
				END LOOP;
				DBMS_OUTPUT.PUT_LINE(CHR(9)||'--------------------------------------'||
									CHR(10)||CHR(9)||'Total Venta: '||var_ped.calcularTotalPedido()|| ' EUROS'||CHR(10));
				
				
			END LOOP;
			IF var_num = 0 THEN 
					RAISE NO_HAY_PEDIDO;
			END IF;
		
			DBMS_OUTPUT.PUT_LINE(CHR(10));
			EXCEPTION
				WHEN NO_HAY_PEDIDO THEN	DBMS_OUTPUT.PUT_LINE(CHR(9)||'Usuario sin pedidos.'||CHR(10)||CHR(10));
		END;

	END LOOP;
END;
/