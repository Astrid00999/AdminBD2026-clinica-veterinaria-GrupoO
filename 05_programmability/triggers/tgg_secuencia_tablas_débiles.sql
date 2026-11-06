============================================================
-- 1. Secuencia de DETALLES_FACTURAS (entidad débil)
-- ============================================================
CREATE OR ALTER TRIGGER finanzas.tr_antes_insertar_detalle_factura
ON finanzas.detalles_facturas
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- AJUSTA la lista de columnas a las de tu tabla real
    -- (si subtotal_df es columna calculada, NO la incluyas)
    INSERT INTO finanzas.detalles_facturas
        (id_factura, id_detalle_factura, id_medicamento, cantidad_df /*, precio..., etc. */)
    SELECT
        i.id_factura,
        ISNULL(m.max_id, 0)
            + ROW_NUMBER() OVER (PARTITION BY i.id_factura ORDER BY (SELECT NULL)),
        i.id_medicamento,
        i.cantidad_df
        /*, i.precio..., etc. */
    FROM inserted i
    LEFT JOIN (
        SELECT id_factura, MAX(id_detalle_factura) AS max_id
        FROM finanzas.detalles_facturas
        GROUP BY id_factura
    ) m ON m.id_factura = i.id_factura;
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

    -- AJUSTA la lista de columnas a las de tu tabla real
    INSERT INTO clinica.detalles_tratamientos
        (id_tratamiento, id_detalle_tratamiento /*, demás columnas */)
    SELECT
        i.id_tratamiento,
        ISNULL(m.max_id, 0)
            + ROW_NUMBER() OVER (PARTITION BY i.id_tratamiento ORDER BY (SELECT NULL))
        /*, i.demás_columnas */
    FROM inserted i
    LEFT JOIN (
        SELECT id_tratamiento, MAX(id_detalle_tratamiento) AS max_id
        FROM clinica.detalles_tratamientos
        GROUP BY id_tratamiento
    ) m ON m.id_tratamiento = i.id_tratamiento;
END;
GO
