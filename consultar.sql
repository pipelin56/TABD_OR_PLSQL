DECLARE
	v_ref_P REF 	Tipo_Producto;
	v_prod_soft		Tipo_Producto_Software;
	v_prod_hard		Tipo_Producto_Hardware;
	CURSOR c_soft IS SELECT Nombre_Producto FROM Tabla_Prod_Software;
	CURSOR c_hard IS SELECT Nombre_Producto FROM Tabla_Prod_Hardware;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Producto Software en la BD:'||CHR(10)||'------------------'||CHR(10));
	--Mostramos los Producto Software
	FOR r_ref IN c_soft LOOP
		SELECT REF(P) INTO v_ref_P FROM Tabla_Prod_Software P WHERE P.Nombre_Producto = r_ref.Nombre_Producto;
		UTL_REF.SELECT_OBJECT(v_ref_P, v_prod_soft);
		DBMS_OUTPUT.PUT_LINE(v_prod_soft.imprimirproducto()||CHR(10));
		
	END LOOP;

	--Mostramos los Producto Hardware
	DBMS_OUTPUT.PUT_LINE(CHR(10)||CHR(10)||'Producto Hardware en la BD:'||CHR(10)||'------------------'||CHR(10));
	FOR r_ref IN c_hard LOOP
		SELECT REF(P) INTO v_ref_P FROM Tabla_Prod_Hardware P WHERE P.Nombre_Producto = r_ref.Nombre_Producto;
		UTL_REF.SELECT_OBJECT(v_ref_P, v_prod_hard);
		DBMS_OUTPUT.PUT_LINE(v_prod_hard.imprimirproducto()||CHR(10));
	END LOOP;

END;
/