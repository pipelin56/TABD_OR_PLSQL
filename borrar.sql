--Borrado de los tipos
DROP TYPE Tipo_Direccion FORCE;
DROP TYPE Tipo_Proveedor FORCE;
DROP TYPE Tipo_Linea_Detalle FORCE;
DROP TYPE Tipo_Producto FORCE;
DROP TYPE Tipo_Tabla_Ref_Proveedor FORCE;
DROP TYPE Tipo_Pedido FORCE;
DROP TYPE Tipo_Tabla_Linea_Detalle FORCE;
DROP TYPE Tipo_Lista_Direccion FORCE;
DROP TYPE Tipo_Cliente FORCE;
DROP TYPE Tipo_Producto_Software FORCE;
DROP TYPE Tipo_Producto_Hardware FORCE;
--Borrado de las tablas 
DROP TABLE Tabla_Pedido CASCADE CONSTRAINTS;
DROP TABLE Tabla_Cliente CASCADE CONSTRAINTS;
DROP TABLE Tabla_Linea_Detalle CASCADE CONSTRAINTS;
DROP TABLE Tabla_Proveedor CASCADE CONSTRAINTS;
DROP TABLE Tabla_Producto CASCADE CONSTRAINTS;
DROP TABLE Tabla_Prod_Software CASCADE CONSTRAINTS;
DROP TABLE Tabla_Prod_Hardware CASCADE CONSTRAINTS;
--Borrado de las secuencias
DROP SEQUENCE codClt_seq;
DROP SEQUENCE codProv_seq;
DROP SEQUENCE codPed_seq;
DROP SEQUENCE codProd_seq;
