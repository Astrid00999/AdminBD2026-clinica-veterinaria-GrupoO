-- ============================================================
-- 2. sp_agregar_medicamento
-- ============================================================
CREATE OR ALTER PROCEDURE sp_agregar_medicamento
    @p_nombre_m       VARCHAR(150),
    @p_presentacion_m VARCHAR(100),
    @p_laboratorio_m  VARCHAR(150),
    @p_precio_m       DECIMAL(10,2),
    @p_cantidad       INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @v_id_medicamento BIGINT;

    BEGIN TRY
        IF @p_cantidad <= 0
            THROW 50010, 'Error: La cantidad debe ser mayor a 0.', 1;

        IF @p_precio_m < 0
            THROW 50011, 'Error: El precio no puede ser negativo.', 1;

        BEGIN TRAN;

        SELECT @v_id_medicamento = id_medicamento
        FROM catalogo.medicamentos
        WHERE nombre_m = @p_nombre_m
          AND presentacion_m = @p_presentacion_m;

        IF @v_id_medicamento IS NULL
        BEGIN
            INSERT INTO medicamentos (nombre_m, presentacion_m, laboratorio_m, precio_m, stock_m)
            VALUES (@p_nombre_m, @p_presentacion_m, @p_laboratorio_m, @p_precio_m, @p_cantidad);
        END
        ELSE
        BEGIN
            UPDATE medicamentos
            SET stock_m  = stock_m + @p_cantidad,
                precio_m = @p_precio_m
            WHERE id_medicamento = @v_id_medicamento;
        END

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO