--Tablas de auditoría. 

DROP TABLE IF EXISTS finanzas.factura_auditoria
DROP TABLE IF EXISTS finanzas.detalles_facturas_auditoria

CREATE TABLE finanzas.facturas_auditoria (

id_auditoria int identity(1,1) not null primary key, 
id_factura int not null, 
estado_f  varchar(30) not null, 
estado_antiguo varchar(30) not null, 
estado_nuevo varchar(30) not null, 
accion varchar(30) not null, 
usuario nvarchar(128) not null, 
fecha_modificiacion datetime2 default sysdatetime()

)
--Ni siquiera los roles de administrados pueden realizar un update o delete sobre esta tabla. 

WITH (LEDGER = ON (APPEND_ONLY = ON));
GO

CREATE TABLE finanzas.detalles_factura_auditoria (
    id_auditoria        INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_detalle_factura  INT            NOT NULL,
    id_factura          INT            NULL,
    id_cita             INT            NULL,
    id_medicamento      INT            NULL,
    id_tratamiento      INT            NULL,
    id_procedimiento    INT            NULL,
    descripcion         VARCHAR(255)   NULL,
    cantidad_antigua    INT            NULL,
    cantidad_nueva      INT            NULL,
    precio_antiguo      DECIMAL(10,2)  NULL,
    precio_nuevo        DECIMAL(10,2)  NULL,
    accion              VARCHAR(10)    NOT NULL,
    usuario             NVARCHAR(128)  NOT NULL,
    fecha_modificacion  DATETIME2      NOT NULL DEFAULT SYSDATETIME()
)WITH (LEDGER = ON (APPEND_ONLY = ON));
GO