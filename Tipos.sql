CREATE TYPE Tipo_Pedido;
/
CREATE TYPE Tipo_Linea_Detalle;
/
CREATE TYPE Tipo_Cliente;
/
CREATE TYPE Tipo_Direccion;
/
CREATE TYPE Tipo_Producto;
/
CREATE TYPE Tipo_Proveedor;
/
CREATE TYPE Tipo_Tabla_Ref_Proveedor AS TABLE OF REF Tipo_Proveedor;
/

CREATE OR REPLACE TYPE Tipo_Linea_Detalle AS OBJECT(
	Cantidad				NUMBER(3),
	TieneProducto	REF 	Tipo_Producto
);
/
CREATE TYPE Tipo_Tabla_Linea_Detalle AS TABLE OF Tipo_Linea_Detalle;
/
CREATE OR REPLACE TYPE Tipo_Pedido AS OBJECT(
	Id_Pedido				NUMBER(5),		--Realizar con una secuencia
	Precio_Total			NUMBER(6,2),
	Fecha_Pedido			DATE,
	PedidoPor		REF		Tipo_Cliente,
	TieneLineas				Tipo_Tabla_Linea_Detalle,
	MEMBER FUNCTION calcularTotalPedido RETURN NUMBER
);
/
CREATE OR REPLACE TYPE Tipo_Direccion AS OBJECT(
	Pais			VARCHAR2(30),
	Ciudad			VARCHAR2(30),
	Calle			VARCHAR2(20),
	Numero			NUMBER(3),
	CP				VARCHAR2(10)
);
/
CREATE TYPE Tipo_Lista_Direccion AS VARRAY(5) OF Tipo_Direccion;
/
CREATE OR REPLACE TYPE	Tipo_Cliente AS OBJECT(
	Id_Cliente				NUMBER(5),		--Realizar con secuencia
	Dni_Cliente				VARCHAR2(9),
	Nombre_Cliente			VARCHAR2(15),
	Apellidos_Cliente		VARCHAR2(30),
	Direcciones_cliente		Tipo_Lista_Direccion
);
/
CREATE OR REPLACE TYPE Tipo_Producto AS OBJECT(
	Stock				NUMBER(3),
	Id_Producto			NUMBER(3),
	Nombre_Producto		VARCHAR2(15),
	Precio 				NUMBER(6,2),
	ProveidoPor			Tipo_Tabla_Ref_Proveedor,
	FINAL MEMBER FUNCTION Stock_Producto RETURN NUMBER, 
	MEMBER FUNCTION Imprimir_Producto RETURN VARCHAR2 
) NOT FINAL;
/

CREATE OR REPLACE TYPE Tipo_Proveedor AS OBJECT(
	Id_Proveedor			NUMBER(3),
	Nombre_Proveedor		VARCHAR2(30),
	Direccion_Proveedor		Tipo_Direccion
);
/

CREATE OR REPLACE TYPE Tipo_Producto_Software UNDER Tipo_Producto(
	Licencia		VARCHAR2(15),
	OVERRIDING MEMBER FUNCTION Imprimir_Producto RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE Tipo_Producto_Hardware UNDER Tipo_Producto(
	Tipo_Conexion		VARCHAR2(15),
	OVERRIDING MEMBER FUNCTION Imprimir_Producto RETURN VARCHAR2
);
/

