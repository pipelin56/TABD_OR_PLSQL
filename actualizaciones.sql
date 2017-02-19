SET SERVEROUTPUT ON
DECLARE

BEGIN 
	
actualizar.actualizarCliente(
			Tipo_Lista_Direccion(Tipo_Direccion('Francia','aaaaa','bbbb',7,'110AA')),
			'7602M','OTRAAAA','Francisco','Zidane');

actualizar.actualizarProveedor('ZZAA6','OTROCIF','Proveedor100',
			Tipo_Direccion('Francia','Jerez','Plaza Espania',1,'12200'));

actualizar.actualizarProdSoft(30,'Office Libre','Microsoft word',8.5,'Software Publico','zzaa6');

actualizar.actualizarProdHard(100,'Disco Duro 1TB Verbatim','Disco 1GB',8.5,'USB 1.0','aa55f');

END;
/
