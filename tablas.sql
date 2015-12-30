--Creacion de la tabla Cliente
CREATE TABLE Tabla_Cliente OF Tipo_Cliente(
	CONSTRAINT PK_Tabla_Cliente PRIMARY KEY(Id_Cliente),
	Direcciones_Cliente NOT NULL,
	Dni_Cliente NOT NULL UNIQUE,
	Nombre_Cliente NOT NULL,
	Apellidos_Cliente NOT NULL
);

CREATE TABLE Tabla_Proveedor OF Tipo_Proveedor(
	CONSTRAINT PK_Tabla_Proveedor PRIMARY KEY(Id_Proveedor),
	Nombre_Proveedor NOT NULL,
	Direccion_Proveedor NOT NULL
);

--Creacion de la tabla Tabla_Linea_Detalle
CREATE TABLE Tabla_Linea_Detalle OF Tipo_Linea_Detalle(
	Tiene_Producto NOT NULL,
	Cantidad NOT NULL
);

CREATE TABLE Tabla_Pedido OF Tipo_Pedido(
	CONSTRAINT PK_Tabla_Pedido PRIMARY KEY(Id_Pedido),
	Pedido_Por NOT NULL,
	Precio_Total NOT NULL,
	Fecha_Pedido NOT NULL
)
NESTED TABLE Tiene_Lineas STORE AS ListaLineaDeDetalle;

CREATE TABLE Tabla_Producto OF Tipo_Producto(
	CONSTRAINT PK_Tabla_Producto PRIMARY KEY(Id_Producto),
	Stock NOT NULL,
	Nombre_Producto NOT NULL,
	Precio_Producto NOT NULL
)
NESTED TABLE Proveido_Por STORE AS ProductoProveedor;
