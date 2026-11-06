-- ============================================================
-- 1. sp_registrar_veterinario
-- ============================================================
CREATE OR ALTER PROCEDURE catalogos.sp_registrar_veterinario
    @p_nombre_esp      VARCHAR(150),
    @p_descripcion_esp VARCHAR(MAX),
    @p_nombre_v        VARCHAR(100),
    @p_apellido_v      VARCHAR(100),
    @p_telefono_v      VARCHAR(20),
    @p_correo_v        VARCHAR(150)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @v_id_especialidad BIGINT;

    BEGIN TRY
        -- Validaciones
        IF LEN(TRIM(ISNULL(@p_nombre_esp, ''))) = 0
            THROW 50001, 'Error: El nombre de la especialidad no puede estar vacío.', 1;

        IF LEN(TRIM(ISNULL(@p_nombre_v, ''))) = 0 OR LEN(TRIM(ISNULL(@p_apellido_v, ''))) = 0
            THROW 50002, 'Error: El nombre y apellido del veterinario no pueden estar vacíos.', 1;

        IF EXISTS (SELECT 1 FROM catalogos.veterinario WHERE correo_v = @p_correo_v)
            THROW 50003, 'Error: El correo ya está registrado para otro veterinario.', 1;

        IF EXISTS (SELECT 1 FROM catalogos.
        veterinario WHERE telefono_v = @p_telefono_v)
            THROW 50004, 'Error: El teléfono ya está registrado para otro veterinario.', 1;

        BEGIN TRAN;

        -- Buscar especialidad existente
        SELECT @v_id_especialidad = id_especialidad
        FROM catalogos.especialidades
        WHERE nombre_esp = @p_nombre_esp;

        -- Si no existe, crearla
        IF @v_id_especialidad IS NULL
        BEGIN
            INSERT INTO especialidades (nombre_esp, descripcion_esp)
            VALUES (@p_nombre_esp, @p_descripcion_esp);

            SET @v_id_especialidad = SCOPE_IDENTITY();
        END

        -- Registrar veterinario
        INSERT INTO veterinario (id_especialidad, nombre_v, apellido_v, telefono_v, correo_v)
        VALUES (@v_id_especialidad, @p_nombre_v, @p_apellido_v, @p_telefono_v, @p_correo_v);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRAN;
        THROW;  -- relanza el error original
    END CATCH
END;
GO