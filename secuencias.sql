--Cracion de secuencia para clave primaria de la tabla Cliente
CREATE SEQUENCE codClt_seq
INCREMENT BY 1
START WITH 1
MAXVALUE 99999
NOCACHE
NOCYCLE;

--Cracion de secuencia para clave primaria de la tabla Proveedor
CREATE SEQUENCE codProv_seq
INCREMENT BY 1
START WITH 1
MAXVALUE 999
NOCACHE
NOCYCLE;

--Cracion de secuencia para clave primaria de la tabla Pedido
CREATE SEQUENCE codPed_seq
INCREMENT BY 1
START WITH 1
MAXVALUE 9999999
NOCACHE
NOCYCLE;

--Cracion de secuencia para clave primaria de la tabla Producto
CREATE SEQUENCE codProd_seq
INCREMENT BY 1
START WITH 1
MAXVALUE 99999
NOCACHE
NOCYCLE;