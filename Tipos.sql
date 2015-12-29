--Declaracion adelantada de tipos
CREATE TYPE Tipo_Pedido;
/
CREATE TYPE Tipo_Linea_Detalle;
/

CREATE TYPE Tipo_Producto;
/
CREATE TYPE Tipo_Proveedor;
/
CREATE TYPE Tipo_Tabla_Ref_Proveedor AS TABLE OF REF Tipo_Proveedor;
/
CREATE TYPE Tipo_Direccion;
/
CREATE OR REPLACE TYPE Tipo_Direccion AS OBJECT(
	Pais			VARCHAR2(30),
	Ciudad			VARCHAR2(30),
	Calle			VARCHAR2(20),
	Numero			NUMBER(3),
	CP				VARCHAR2(10)
);
/
--Declaracion adelantada del tipo Tipo_Lista_Direccion
CREATE TYPE Tipo_Lista_Direccion AS VARRAY(5) OF Tipo_Direccion;
/
CREATE TYPE Tipo_Cliente;
/
CREATE OR REPLACE TYPE	Tipo_Cliente AS OBJECT(
	Id_Cliente				NUMBER(5),		--Realizar con secuencia
	Dni_Cliente				VARCHAR2(9),
	Nombre_Cliente			VARCHAR2(15),
	Apellidos_Cliente		VARCHAR2(30),
	Direcciones_cliente		Tipo_Lista_Direccion
);
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
	Pedido_Por		REF		Tipo_Cliente,
	Tiene_Lineas			Tipo_Tabla_Linea_Detalle,
	MEMBER FUNCTION calcularTotalPedido RETURN NUMBER
);
/
--Creacion de los tipos
CREATE OR REPLACE TYPE Tipo_Producto AS OBJECT(
	Stock				NUMBER(3),
	Id_Producto			NUMBER(3),
	Nombre_Producto		VARCHAR2(15),
	Precio 				NUMBER(6,2),
	Proveido_Por		Tipo_Tabla_Ref_Proveedor,
	FINAL MEMBER FUNCTION StockProducto RETURN NUMBER, 
	MEMBER FUNCTION ImprimirProducto RETURN VARCHAR2 
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
	OVERRIDING MEMBER FUNCTION ImprimirProducto RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE Tipo_Producto_Hardware UNDER Tipo_Producto(
	Tipo_Conexion		VARCHAR2(15),
	OVERRIDING MEMBER FUNCTION ImprimirProducto RETURN VARCHAR2
);
/
CREATE TABLE Tabla_Linea_Detalle OF Tipo_Linea_Detalle(
	TieneProducto NOT NULL
);

CREATE TABLE Tabla_Pedido OF Tipo_Pedido(
	CONSTRAINT PK_Tabla_Pedido PRIMARY KEY(Id_Pedido),
	Pedido_Por NOT NULL
)
NESTED TABLE Tiene_Lineas STORE AS ListaLineaDeDetalle;

CREATE TABLE Tabla_Cliente OF Tipo_Cliente(
	CONSTRAINT PK_Tabla_Cliente PRIMARY KEY(Id_Cliente)
);

CREATE TABLE Tabla_Proveedor OF Tipo_Proveedor(
	CONSTRAINT PK_Tabla_Proveedor PRIMARY KEY(Id_Proveedor)
);

CREATE TABLE Tabla_Producto OF Tipo_Producto(
	CONSTRAINT PK_Tabla_Producto PRIMARY KEY(Id_Producto)
)
NESTED TABLE Proveido_Por STORE AS ProductoProveedor;