--Triger para auditoría de facturas. 

CREATE TRIGGER trg_facturas_audit 
ON dbo.facturas
AFTER INSERT, UPDATE, DELETE 
AS 
BEGIN
    SET NOCOUNT ON;

    -- Auditoría para cuando se crea una factura nueva
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO facturas_auditoria (id_factura, estado_f, accion, usuario, fecha_modificacion)
        SELECT id_factura, estado_f, 'INSERT', SUSER_SNAME(), GETDATE()
        FROM inserted;
    END

    -- Auditoría para cuando se actualiza el estado de la factura (como la anulación)
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO facturas_auditoria (id_factura, estado_antiguo, estado_nuevo, accion, usuario, fecha_modificacion)
        SELECT i.id_factura, d.estado_f, i.estado_f, 'UPDATE', SUSER_SNAME(), GETDATE()
        FROM inserted i
        INNER JOIN deleted d ON i.id_factura = d.id_factura;
    END
    
    -- Auditoría para borrados físicos (en caso de que llegaran a ocurrir)
    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO facturas_auditoria (id_factura, estado_f, accion, usuario, fecha_modificacion)
        SELECT id_factura, estado_f, 'DELETE', SUSER_SNAME(), GETDATE()
        FROM deleted;
    END
END;
GO

--Trigger auditoría para tabla detalles. 


CREATE TRIGGER tgg_DetallesFactura_Auditoria 
ON dbo.detalles_factura
AFTER INSERT, UPDATE, DELETE 
AS 
BEGIN
    SET NOCOUNT ON;

    -- 1. Auditoría para INSERCIONES (Nuevos productos/servicios agregados a la factura)
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO detalles_factura_auditoria(
            id_detalle_factura, id_factura, id_cita, id_medicamento, id_tratamiento, 
            id_procedimiento, descripcion, cantidad_nueva, precio_nuevo, accion, usuario, fecha_modificacion
        )
        SELECT 
            id_detalle_factura, id_factura, id_cita, id_medicamento, id_tratamiento, 
            id_procedimiento, descripcion, cantidad_df, precio_unit, 'INSERT', SUSER_SNAME(), GETDATE()
        FROM inserted;
    END

    -- 2. Auditoría para ELIMINACIONES
    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO detalles_factura_auditoria(
            id_detalle_factura, id_factura, id_cita, id_medicamento, id_tratamiento, 
            id_procedimiento, descripcion, cantidad_antigua, precio_antiguo, accion, usuario, fecha_modificacion
        )
        SELECT 
            id_detalle_factura, id_factura, id_cita, id_medicamento, id_tratamiento, 
            id_procedimiento, descripcion, cantidad_df, precio_unit, 'DELETE', SUSER_SNAME(), GETDATE()
        FROM deleted;
    END

    -- 3. Auditoría para ACTUALIZACIONES (Si llegara a modificarse algún renglón)
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO detalles_factura_auditoria(
            id_detalle_factura, id_factura, id_cita, id_medicamento, id_tratamiento, 
            id_procedimiento, descripcion, cantidad_antigua, cantidad_nueva, precio_antiguo, precio_nuevo, accion, usuario, fecha_modificacion
        )
        SELECT 
            i.id_detalle_factura, i.id_factura, i.id_cita, i.id_medicamento, i.id_tratamiento, 
            i.id_procedimiento, i.descripcion, d.cantidad_df, i.cantidad_df, d.precio_unit, i.precio_unit, 'UPDATE', SUSER_SNAME(), GETDATE()
        FROM inserted i
        INNER JOIN deleted d ON i.id_detalle_factura = d.id_detalle_factura;
    END

END;
GO
