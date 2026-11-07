--============================================================================
--FUNCIÓN QUE RETORNA LA EDAD
--=============================================================================

CREATE OR ALTER FUNCTION gestion.fn_get_edad (@f_fecha_nacimiento DATE)
RETURNS INT
AS
BEGIN
    DECLARE @c_edad INT;

    SET @c_edad = DATEDIFF(YEAR, @f_fecha_nacimiento, GETDATE())
                  - CASE
                        WHEN DATEADD(YEAR,
                                     DATEDIFF(YEAR, @f_fecha_nacimiento, GETDATE()),
                                     @f_fecha_nacimiento) > CAST(GETDATE() AS DATE)
                        THEN 1 ELSE 0
                    END;

    RETURN ISNULL(@c_edad, 0);
END;
GO

SELECT nombre_m, fecha_nacimiento, gestion.fn_get_edad(fecha_nacimiento) AS edad
FROM gestion.mascotas;