--============================================================
-- 1. Secuencia de DETALLES_FACTURAS (entidad débil)
-- ============================================================
CREATE OR ALTER TRIGGER finanzas.tr_antes_insertar_detalle_factura
ON finanzas.detalles_facturas
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
        
    INSERT INTO finanzas.detalles_facturas
        (id_factura, id_detalle_factura, id_cita, id_medicamento, id_tratamiento,
         id_procedimiento, descripcion_df, cantidad_df, precio_unit_df)
    SELECT
        i.id_factura,
        ISNULL(m.max_id, 0)
            + ROW_NUMBER() OVER (PARTITION BY i.id_factura ORDER BY (SELECT NULL)),
        i.id_cita,
        i.id_medicamento,
        i.id_tratamiento,
        i.id_procedimiento,
        i.descripcion_df,
        i.cantidad_df,
        CASE
            WHEN ISNULL(i.precio_unit_df, 0) = 0 AND i.id_medicamento IS NOT NULL
                THEN med.precio_m
            ELSE i.precio_unit_df
        END
    FROM inserted i
    LEFT JOIN (
        SELECT id_factura, MAX(id_detalle_factura) AS max_id
        FROM finanzas.detalles_facturas
        GROUP BY id_factura
    ) m ON m.id_factura = i.id_factura
    LEFT JOIN catalogos.medicamentos med ON med.id_medicamento = i.id_medicamento


END;
GO


-- ============================================================
-- 2. Secuencia de DETALLES_TRATAMIENTOS
-- ============================================================
CREATE OR ALTER TRIGGER clinica.tr_antes_insertar_detalle_tratamiento
ON clinica.detalles_tratamientos
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO clinica.detalles_tratamientos
        (id_tratamiento, id_detalle_tratamiento, id_medicamento,
         dosis_dt, frecuencia_dt, duracion_dias_dt)
    SELECT
        i.id_tratamiento,
        ISNULL(m.max_id, 0)
            + ROW_NUMBER() OVER (PARTITION BY i.id_tratamiento ORDER BY (SELECT NULL)),
        i.id_medicamento,
        i.dosis_dt,
        i.frecuencia_dt,
        i.duracion_dias_dt
    FROM inserted i
    LEFT JOIN (
        SELECT id_tratamiento, MAX(id_detalle_tratamiento) AS max_id
        FROM clinica.detalles_tratamientos
        GROUP BY id_tratamiento
    ) m ON m.id_tratamiento = i.id_tratamiento;
END;
GO


