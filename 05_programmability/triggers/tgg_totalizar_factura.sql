CREATE OR ALTER TRIGGER finanzas.tr_acumular_total_factura
ON finanzas.detalles_facturas
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE f
    SET f.total_f = f.total_f + s.suma
    FROM finanzas.facturas f
    JOIN (
        SELECT id_factura, SUM(subtotal_df) AS suma
        FROM inserted
        GROUP BY id_factura
    ) s ON s.id_factura = f.id_factura;
END;
GO

-- ============================================================
-- 4. Control de inventario de medicamentos
-- ============================================================
CREATE OR ALTER TRIGGER finanzas.tr_actualizar_inventario_farmacia
ON finanzas.detalles_facturas
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Total solicitado por medicamento (puede haber varios renglones del mismo)
    ;WITH solicitado AS (
        SELECT id_medicamento, SUM(cantidad_df) AS total
        FROM inserted
        WHERE id_medicamento IS NOT NULL
        GROUP BY id_medicamento
    )
    -- Validar existencia
    SELECT 1
    FROM solicitado s
    JOIN catalogos.medicamentos m ON m.id_medicamento = s.id_medicamento
    WHERE m.stock_m < s.total;

    IF @@ROWCOUNT > 0
    BEGIN
        ;THROW 50020, 'Error de Inventario: No hay suficiente stock para el medicamento solicitado.', 1;
    END

    -- Descontar stock
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