----------------------------------------------------------------------------------------
--PROCEDIMIENTO ALMACENADO PARA ANULAR UNA FACTURA POR EQUIVOCACIÓN. 
-----------------------------------------------------------------------------------------


USE migracion;
GO
CREATE OR ALTER PROCEDURE finanzas.sp_cancelar_factura
    @FacturaID         INT,
    @MotivoCancelacion VARCHAR(255),
    @UsuarioID         INT 
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @usuario NVARCHAR(128) =
            COALESCE(CAST(@UsuarioID AS NVARCHAR(128)), ORIGINAL_LOGIN());
        EXEC sp_set_session_context 'usuario_app', @usuario;
        EXEC sp_set_session_context 'motivo_anulacion', @MotivoCancelacion;

        UPDATE finanzas.facturas
        SET estado_f = 'Anulada'
        WHERE id_factura = @FacturaID
          AND estado_f IN ('Activa', 'Pendiente');

        IF @@ROWCOUNT = 0
            THROW 50001, 'La factura no existe o no está en estado ACTIVA.', 1;

        UPDATE med
        SET med.stock_m = med.stock_m + det.total
        FROM catalogos.medicamentos med
        JOIN (
            SELECT id_medicamento, SUM(cantidad_df) AS total
            FROM finanzas.detalles_facturas
            WHERE id_factura = @FacturaID
              AND id_medicamento IS NOT NULL
            GROUP BY id_medicamento
        ) det ON det.id_medicamento = med.id_medicamento;

        COMMIT TRANSACTION;
        PRINT 'La factura fue anulada y el inventario restaurado.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

--Ejecutar el procedimiento almacenado

EXEC finanzas.sp_cancelar_factura 4, 'Error en la asignación de medicamentos', 1;

