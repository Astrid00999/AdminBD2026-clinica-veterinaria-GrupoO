--============================================================================
-- TRIGGER PARA TABLAS CRITICAS detalles_tratamientos
--===========================================================================
CREATE OR ALTER TRIGGER clinica.tr_auditoria_detalles_tratamientos
ON clinica.detalles_tratamientos
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH cambios AS (
        SELECT
            COALESCE(i.id_tratamiento, d.id_tratamiento)               AS id_tratamiento,
            COALESCE(i.id_detalle_tratamiento, d.id_detalle_tratamiento) AS id_detalle,
            CASE WHEN d.id_tratamiento IS NULL THEN 'INSERT'
                 WHEN i.id_tratamiento IS NULL THEN 'DELETE'
                 ELSE 'UPDATE' END AS accion,
            v.campo, v.antiguo, v.nuevo
        FROM inserted i
        FULL OUTER JOIN deleted d
            ON  d.id_tratamiento        = i.id_tratamiento
            AND d.id_detalle_tratamiento = i.id_detalle_tratamiento
        CROSS APPLY (VALUES
            ('id_medicamento',   CAST(d.id_medicamento   AS VARCHAR(255)), CAST(i.id_medicamento   AS VARCHAR(255))),
            ('dosis_dt',         d.dosis_dt,                               i.dosis_dt),
            ('frecuencia_dt',    d.frecuencia_dt,                          i.frecuencia_dt),
            ('duracion_dias_dt', CAST(d.duracion_dias_dt AS VARCHAR(255)), CAST(i.duracion_dias_dt AS VARCHAR(255)))
        ) v(campo, antiguo, nuevo)
    )
    INSERT INTO seguridad.historial_clinico_auditoria
        (tabla_afectada, id_registro, id_mascota, campo, valor_antiguo, valor_nuevo, accion, usuario)
    SELECT
        'detalles_tratamientos',
        CONCAT(c.id_tratamiento, '-', c.id_detalle),
        ci.id_mascota,
        c.campo, c.antiguo, c.nuevo, c.accion,
        SUSER_SNAME()
    FROM cambios c
    LEFT JOIN clinica.tratamiento t   ON t.id_tratamiento = c.id_tratamiento
    LEFT JOIN clinica.diagnosticos dg ON dg.id_diagnostico = t.id_diagnostico
    LEFT JOIN gestion.citas ci        ON ci.id_cita = dg.id_cita
    WHERE c.accion <> 'UPDATE'
       OR ISNULL(c.antiguo, '') <> ISNULL(c.nuevo, '');
END;
GO


--====================================================================================
-- TRIGGER PARA TABLA DE AUDITORIA DE DIAGNOSTICOS
--====================================================================================
CREATE OR ALTER TRIGGER clinica.tr_auditoria_diagnosticos
ON clinica.diagnosticos
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH cambios AS (
        SELECT
            COALESCE(i.id_diagnostico, d.id_diagnostico) AS id_diagnostico,
            COALESCE(i.id_cita, d.id_cita)               AS id_cita,
            CASE WHEN d.id_diagnostico IS NULL THEN 'INSERT'
                 WHEN i.id_diagnostico IS NULL THEN 'DELETE'
                 ELSE 'UPDATE' END AS accion,
            v.campo, v.antiguo, v.nuevo
        FROM inserted i
        FULL OUTER JOIN deleted d ON d.id_diagnostico = i.id_diagnostico
        CROSS APPLY (VALUES
            ('descripcion_d',   d.descripcion_d,   i.descripcion_d),
            ('observaciones_d', d.observaciones_d, i.observaciones_d)
        ) v(campo, antiguo, nuevo)
    )
    INSERT INTO seguridad.historial_clinico_auditoria
        (tabla_afectada, id_registro, id_mascota, campo, valor_antiguo, valor_nuevo, accion, usuario)
    SELECT
        'diagnosticos', CAST(c.id_diagnostico AS VARCHAR(50)), ci.id_mascota,
        c.campo, c.antiguo, c.nuevo, c.accion, SUSER_SNAME()
    FROM cambios c
    LEFT JOIN gestion.citas ci ON ci.id_cita = c.id_cita
    WHERE c.accion <> 'UPDATE'
       OR ISNULL(c.antiguo, '') <> ISNULL(c.nuevo, '');
END;
GO

