--=========================================================================
--TRIGGERS TABLAS DE FACTURACIÓN. 
--=========================================================================

DROP TRIGGER IF EXISTS finanzas.trg_facturas_audit;
GO

DROP TRIGGER IF EXISTS finanzas.tgg_DetallesFactura_Auditoria;
GO


CREATE TRIGGER finanzas.trg_facturas_audit 
ON finanzas.facturas
AFTER INSERT, UPDATE, DELETE 
AS 
BEGIN
    SET NOCOUNT ON;

    -- Auditoría para INSERCIÓN
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO seguridad.facturas_auditoria (id_factura, estado_f, accion, usuario, fecha_modificacion)
        SELECT id_factura, estado_f, 'INSERT', SUSER_SNAME(), GETDATE()
        FROM inserted;
    END

    -- Auditoría para ACTUALIZACIÓN
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO seguridad.facturas_auditoria (id_factura, estado_antiguo, estado_nuevo, accion, usuario, fecha_modificacion)
        SELECT i.id_factura, d.estado_f, i.estado_f, 'UPDATE', SUSER_SNAME(), GETDATE()
        FROM inserted i
        INNER JOIN deleted d ON i.id_factura = d.id_factura;
    END
    
    -- Auditoría para ELIMINACIÓN
    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO seguridad.facturas_auditoria (id_factura, estado_f, accion, usuario, fecha_modificacion)
        SELECT id_factura, estado_f, 'DELETE', SUSER_SNAME(), GETDATE()
        FROM deleted;
    END
END;
GO

--==============================================================================
-- 3. Crear Trigger para la tabla DETALLES_FACTURAS
--==============================================================================
CREATE TRIGGER finanzas.tgg_DetallesFactura_Auditoria 
ON finanzas.detalles_facturas
AFTER INSERT, UPDATE, DELETE 
AS 
BEGIN
    SET NOCOUNT ON;

    -- 1. Auditoría para INSERCIONES
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO seguridad.detalles_factura_auditoria(
            id_detalle_factura, id_factura, id_cita, id_medicamento, id_tratamiento, 
            id_procedimiento, descripcion, cantidad_nueva, precio_nuevo, accion, usuario, fecha_modificacion
        )
        SELECT 
            id_detalle_factura, id_factura, id_cita, id_medicamento, id_tratamiento, 
            id_procedimiento, descripcion_df, cantidad_df, precio_unit_df, 'INSERT', SUSER_SNAME(), GETDATE()
        FROM inserted;
    END

    -- 2. Auditoría para ELIMINACIONES
    IF EXISTS (SELECT * FROM deleted) AND NOT EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO seguridad.detalles_factura_auditoria(
            id_detalle_factura, id_factura, id_cita, id_medicamento, id_tratamiento, 
            id_procedimiento, descripcion, cantidad_antigua, precio_antiguo, accion, usuario, fecha_modificacion
        )
        SELECT 
            id_detalle_factura, id_factura, id_cita, id_medicamento, id_tratamiento, 
            id_procedimiento, descripcion_df, cantidad_df, precio_unit_df, 'DELETE', SUSER_SNAME(), GETDATE()
        FROM deleted;
    END

    -- 3. Auditoría para ACTUALIZACIONES
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO seguridad.detalles_factura_auditoria(
            id_detalle_factura, id_factura, id_cita, id_medicamento, id_tratamiento, 
            id_procedimiento, descripcion, cantidad_antigua, cantidad_nueva, precio_antiguo, precio_nuevo, accion, usuario, fecha_modificacion
        )
        SELECT 
            i.id_detalle_factura, i.id_factura, i.id_cita, i.id_medicamento, i.id_tratamiento, 
            i.id_procedimiento, i.descripcion_df, d.cantidad_df, i.cantidad_df, d.precio_unit_df, i.precio_unit_df, 'UPDATE', SUSER_SNAME(), GETDATE()
        FROM inserted i
        INNER JOIN deleted d ON i.id_detalle_factura = d.id_detalle_factura;
    END
END;
GO
