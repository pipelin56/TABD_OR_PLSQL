--Creacion del tipo Tipo_Direccion
CREATE OR REPLACE TYPE Tipo_Direccion AS OBJECT(
	Pais			VARCHAR2(30),
	Ciudad			VARCHAR2(30),
	Calle			VARCHAR2(20),
	Numero			NUMBER(3),
	CP				VARCHAR2(10)
);
/
--Declaracion del tipo Tipo_Lista_Direccion que sera un VARRAY de 5 posiciones
CREATE TYPE Tipo_Lista_Direccion AS VARRAY(5) OF Tipo_Direccion;
/

--Creacion del tipo Tipo_Cliente
CREATE OR REPLACE TYPE	Tipo_Cliente AS OBJECT(
	Id_Cliente				NUMBER(5),		
	Dni_Cliente				VARCHAR2(9),
	Nombre_Cliente			VARCHAR2(15),
	Apellidos_Cliente		VARCHAR2(30),
	Direcciones_Cliente		Tipo_Lista_Direccion
);
/

--Creacion del tipo Tipo_Proveedor
CREATE OR REPLACE TYPE Tipo_Proveedor AS OBJECT(
	Id_Proveedor			NUMBER(3),  
	Cif_Proveedor			VARCHAR2(9),    
	Nombre_Proveedor		VARCHAR2(30),
	Direccion_Proveedor		Tipo_Direccion
);
/

--Declaracion de Tipo_Producto adelantada por que Tipo_Linea_Detalle lo requiere para su creacion
CREATE TYPE Tipo_Producto;
/
--Creacion del tipo Tipo_Linea_Detalle
CREATE OR REPLACE TYPE Tipo_Linea_Detalle AS OBJECT(
	Cantidad				NUMBER(3),
	Tiene_Producto	REF 	Tipo_Producto
);
/

--Creacion del tipo que es una tabla de referencias a un Tipo_Proveedor
CREATE TYPE Tipo_Tabla_Ref_Proveedor AS TABLE OF REF Tipo_Proveedor;
/
--Creacion de los tipos
CREATE OR REPLACE TYPE Tipo_Producto AS OBJECT(
	Id_Producto			NUMBER(5),			
	Stock				NUMBER(3),
	Nombre_Producto		VARCHAR2(30),
	Precio_Producto		NUMBER(6,2),
	Proveido_Por		Tipo_Tabla_Ref_Proveedor,
	FINAL MEMBER FUNCTION StockProducto RETURN NUMBER, 
	MEMBER FUNCTION ImprimirProducto RETURN VARCHAR2 
) NOT FINAL;
/
--Creacion del cuerpo del tipos Producto con las funciones
CREATE OR REPLACE TYPE BODY Tipo_Producto AS 
    FINAL MEMBER FUNCTION StockProducto RETURN NUMBER IS
		BEGIN
			RETURN Stock;
		END;

	MEMBER FUNCTION ImprimirProducto RETURN VARCHAR2 IS
		BEGIN
			RETURN 'Nombre: '||Nombre_Producto||CHR(10)||'Precio: '||Precio_Producto||CHR(10)||'Stock: '||Stock;
		END;
END;
/
--Creacion del subtipo Software
CREATE OR REPLACE TYPE Tipo_Producto_Software UNDER Tipo_Producto(
	Licencia		VARCHAR2(20),
	OVERRIDING MEMBER FUNCTION ImprimirProducto RETURN VARCHAR2
);
/
--Creacion del cuerpo del subtipo Software con su funcion
CREATE OR REPLACE TYPE BODY Tipo_Producto_Software AS 
	OVERRIDING MEMBER FUNCTION ImprimirProducto RETURN VARCHAR2 IS
		BEGIN
			RETURN (SELF AS Tipo_Producto).ImprimirProducto || CHR(10)|| 'Licencia: ' || Licencia;
		END;
END;
/
--Creacion del subtipo Hardaware
CREATE OR REPLACE TYPE Tipo_Producto_Hardware UNDER Tipo_Producto(
	Tipo_Conexion		VARCHAR2(20),
	OVERRIDING MEMBER FUNCTION ImprimirProducto RETURN VARCHAR2
);
/
--Creacion del cuerpo del subtipo Hardware con su funcione
CREATE OR REPLACE TYPE BODY Tipo_Producto_Hardware AS 
    OVERRIDING MEMBER FUNCTION ImprimirProducto RETURN VARCHAR2 IS
		BEGIN
			RETURN (SELF AS Tipo_Producto).ImprimirProducto || CHR(10)|| 'Tipo de conexion: ' || Tipo_Conexion;
		END;
END;
/

--Creacion del tipo que sera una tabla de Tipo_Linea_Detalle
CREATE TYPE Tipo_Tabla_Linea_Detalle AS TABLE OF Tipo_Linea_Detalle;
/
--Creacion del tipo Tipo_Pedido
CREATE OR REPLACE TYPE Tipo_Pedido AS OBJECT(
	Id_Pedido				NUMBER(7),		
	Precio_Total			NUMBER(6,2),
	Fecha_Pedido			DATE,
	Pedido_Por		REF		Tipo_Cliente,
	Tiene_Lineas			Tipo_Tabla_Linea_Detalle,
	MEMBER FUNCTION calcularTotalPedido RETURN NUMBER
);
/
--Creacion del cuerpo del tipo Pedido con su funcion
CREATE OR REPLACE TYPE BODY Tipo_Pedido AS
	MEMBER FUNCTION calcularTotalPedido RETURN NUMBER IS
		var_indice		NUMBER DEFAULT 0; --Variable para recorrer la coleccion
		var_total		NUMBER DEFAULT 0; --Variable para el cumulo
		var_ref_prod	REF Tipo_Producto; --Variable auxiliar para la referencia de los producto
		var_producto	Tipo_Producto; --Variable auxiliar para acceder a un objeto Producto
		BEGIN
			FOR var_indice in 1 .. Tiene_Lineas.COUNT LOOP
				--Acontinuacion obtenemos la referencia del producto que tiene cada Linea de detalle.
				var_ref_prod := Tiene_Lineas(var_indice).Tiene_Producto; 
				UTL_REF.SELECT_OBJECT(var_ref_prod,var_producto);  --Obtenemos el objeto.
				var_total := var_total + var_producto.Precio_Producto * Tiene_Lineas(var_indice).Cantidad;
			END LOOP;
			RETURN var_total;
		END;
END;
/

