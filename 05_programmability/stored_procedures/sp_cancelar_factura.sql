USE migracion;
GO

CREATE PROCEDURE sp_cancelar_factura 
@FacturaID int, 
@MotivoCancelacion varchar(255),
@UsuarioID int 

AS
BEGIN

SET NOCOUNT ON; 
SET XACT_ABORT ON;

BEGIN TRY 
BEGIN TRANSACTION; 

        DECLARE @usuario NVARCHAR(128) = CAST(@UsuarioID AS NVARCHAR(128));
        EXEC sp_set_session_context 'usuario_app', @usuario;
        EXEC sp_set_session_context 'motivo_anulacion', @MotivoCancelacion;

		 UPDATE dbo.facturas
        SET estado_f = 'ANULADA'
        WHERE id_factura = @FacturaID
          AND estado_f = 'ACTIVA';

            IF @@ROWCOUNT = 0
            THROW 50001, 'La factura no existe o no está en estado ACTIVA.', 1;



IF NOT EXISTS(SELECT 1 FROM facturas where id_factura = @FacturaID AND estado_f = 'ACTIVA')
BEGIN
	RAISERROR('La factura no existe, ya se encuentra anulada o no está en estado activo.', 16, 1);
	ROLLBACK TRANSACTION;
	RETURN;
END

UPDATE facturas 
SET estado_f = 'ANULADA'
WHERE id_factura = @FacturaID;

UPDATE med
SET med.stock_m = med.stock_m + det.cantidad_df
FROM dbo.medicamentos med
INNER JOIN detalles_factura det ON med.id_medicamento = det.id_medicamento
WHERE det.id_factura = @FacturaID;

COMMIT TRANSACTION;
PRINT 'La factura ha sido anulada exitosamente y el inventario fue restaurado.';

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
	ROLLBACK TRANSACTION;

THROW;
END CATCH
END;
GO