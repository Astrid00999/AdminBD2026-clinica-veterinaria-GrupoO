--================================================================================
-- 1. TOTALIZAR FACTURA
--==================================================================================


CREATE OR ALTER TRIGGER finanzas.tr_acumular_total_factura
ON finanzas.detalles_facturas
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE f
    SET f.total_f = ISNULL(f.total_f, 0) + s.suma
    FROM finanzas.facturas f
    JOIN (
        SELECT id_factura, SUM(subtotal_df) AS suma
        FROM inserted
        GROUP BY id_factura
    ) s ON s.id_factura = f.id_factura;
END;
GO

-- ============================================================
-- 2. CONTROL INVENTARIO 
-- ============================================================
CREATE OR ALTER TRIGGER finanzas.tr_actualizar_inventario_farmacia
ON finanzas.detalles_facturas
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM (
            SELECT id_medicamento, SUM(cantidad_df) AS total
            FROM inserted
            WHERE id_medicamento IS NOT NULL
            GROUP BY id_medicamento
        ) s
        JOIN catalogos.medicamentos m ON m.id_medicamento = s.id_medicamento
        WHERE m.stock_m < s.total
    )
        THROW 50020, 'Error de Inventario: No hay suficiente stock para el medicamento solicitado.', 1;

    UPDATE m
    SET m.stock_m = m.stock_m - s.total
    FROM catalogos.medicamentos m
    JOIN (
        SELECT id_medicamento, SUM(cantidad_df) AS total
        FROM inserted
        WHERE id_medicamento IS NOT NULL
        GROUP BY id_medicamento
    ) s ON s.id_medicamento = m.id_medicamento;
END;
GO


