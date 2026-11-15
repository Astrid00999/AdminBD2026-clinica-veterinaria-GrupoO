CREATE OR ALTER TRIGGER clinica.tr_auditoria_diagnosticos
ON clinica.diagnosticos
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH cambios AS (
        SELECT
            COALESCE(i.id_diagnostico, d.id_diagnostico) AS id_diagnostico,
            COALESCE(i.id_cita, d.id_cita) AS id_cita,

            CASE
                WHEN d.id_diagnostico IS NULL THEN 'INSERT'
                WHEN i.id_diagnostico IS NULL THEN 'DELETE'
                ELSE 'UPDATE'
            END AS accion,

            v.campo,
            v.antiguo,
            v.nuevo

        FROM inserted i
        FULL OUTER JOIN deleted d
            ON d.id_diagnostico = i.id_diagnostico

        CROSS APPLY (VALUES
            (
                'id_cita',
                CAST(d.id_cita AS VARCHAR(255)),
                CAST(i.id_cita AS VARCHAR(255))
            ),
            (
                'fecha_d',
                CONVERT(VARCHAR(255), d.fecha_d, 23),
                CONVERT(VARCHAR(255), i.fecha_d, 23)
            )
        ) v(campo, antiguo, nuevo)
    )

    INSERT INTO seguridad.historial_clinico_auditoria
    (
        tabla_afectada,
        id_registro,
        id_mascota,
        campo,
        valor_antiguo,
        valor_nuevo,
        accion,
        usuario
    )
    SELECT
        'diagnosticos',
        CAST(c.id_diagnostico AS VARCHAR(50)),
        ci.id_mascota,
        c.campo,
        c.antiguo,
        c.nuevo,
        c.accion,
        SUSER_SNAME()
    FROM cambios c
    LEFT JOIN gestion.citas ci
        ON ci.id_cita = c.id_cita
    WHERE c.accion <> 'UPDATE'
       OR ISNULL(c.antiguo, '') <> ISNULL(c.nuevo, '');
END;
GO