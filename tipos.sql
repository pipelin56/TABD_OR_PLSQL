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
	Cif_Proveedor			NUMBER(9),    
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

--Creacion del tipo que es una tabla de referencias a un Tipo_Proveedor
CREATE TYPE Tipo_Tabla_Ref_Proveedor AS TABLE OF REF Tipo_Proveedor;
/
--Creacion de los tipos
CREATE OR REPLACE TYPE Tipo_Producto AS OBJECT(
	Id_Producto			NUMBER(5),			
	Stock				NUMBER(3),
	Nombre_Producto		VARCHAR2(20),
	Precio_Producto		NUMBER(6,2),
	Proveido_Por		Tipo_Tabla_Ref_Proveedor,
	FINAL MEMBER FUNCTION StockProducto RETURN NUMBER, 
	MEMBER FUNCTION ImprimirProducto RETURN VARCHAR2 
) NOT FINAL;
/
CREATE OR REPLACE TYPE Tipo_Producto_Software UNDER Tipo_Producto(
	Licencia		VARCHAR2(15)
	--OVERRIDING MEMBER FUNCTION ImprimirProducto RETURN VARCHAR2
);
/
CREATE OR REPLACE TYPE Tipo_Producto_Hardware UNDER Tipo_Producto(
	Tipo_Conexion		VARCHAR2(15),
	OVERRIDING MEMBER FUNCTION ImprimirProducto RETURN VARCHAR2
);
/
