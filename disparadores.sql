CREATE OR REPLACE TRIGGER productoSinStockSoft
BEFORE INSERT OR UPDATE ON Tabla_Prod_Software
FOR EACH ROW
DECLARE
    error_insertar EXCEPTION;
    error_actualizar EXCEPTION;
BEGIN

    IF :NEW.stock <= 0 THEN
        IF INSERTING THEN	
    			RAISE error_insertar ;
        ELSIF UPDATING('stock') THEN
                RAISE error_actualizar ;
        END if;
    END IF;

EXCEPTION
    WHEN error_insertar THEN
         DBMS_OUTPUT.PUT_LINE('No puede insertar un nuevo producto Software con stock 0 o negativo.');
        RAISE_APPLICATION_ERROR(-20008,'Error al insertar');

    WHEN error_actualizar THEN
        DBMS_OUTPUT.PUT_LINE('No puede actualizar un nuevo producto Software con stock 0 o negativo.');
        RAISE_APPLICATION_ERROR(-20009,'Error al actualizar');

END productoSinStockSoft;
/

CREATE OR REPLACE TRIGGER productoSinStockHard
BEFORE INSERT OR UPDATE ON Tabla_Prod_Hardware
FOR EACH ROW
DECLARE
        error_insertar EXCEPTION;
    error_actualizar EXCEPTION;
BEGIN

    IF :NEW.stock <= 0 THEN
        IF INSERTING THEN   
                RAISE error_insertar ;
        ELSIF UPDATING('stock') THEN
                RAISE error_actualizar ;
        END if;
    END IF;

EXCEPTION
    WHEN error_insertar THEN
        DBMS_OUTPUT.PUT_LINE('No puede insertar un nuevo producto Hardware con stock 0 o negativo.');
        RAISE_APPLICATION_ERROR(-20008,'Error al insertar');
    WHEN error_actualizar THEN
        DBMS_OUTPUT.PUT_LINE('No puede actualizar un nuevo producto Hardware con stock 0 o negativo.');
        RAISE_APPLICATION_ERROR(-20009,'Error al actualizar');
END productoSinStockHard;
/

