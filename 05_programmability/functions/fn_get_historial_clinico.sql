CREATE OR ALTER FUNCTION fn_get_historial_medico (@id INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        m.nombre_m                          AS nombre_ma,
        gestion.fn_get_edad(m.fecha_nacimiento) AS edad,
        m.peso_m                            AS peso,
        c.fecha_c                           AS fecha_cita,
        v.nombre_v                          AS veterinario,
        d.descripcion_d                     AS diagnostico,
        t.descripcion_t                     AS tratamiento,
        STRING_AGG(me.nombre_m + ' (' + dt.dosis_dt + ')', ', ')
                                            AS medicamentos_recetados
    FROM gestion.mascotas m
    JOIN gestion.citas c                  ON c.id_mascota      = m.id_mascota
    JOIN catalogos.veterinario v            ON v.id_veterinario  = c.id_veterinario
    JOIN clinica.diagnosticos d           ON d.id_cita         = c.id_cita
    JOIN clinica.tratamiento t            ON t.id_diagnostico  = d.id_diagnostico
    JOIN clinica.detalles_tratamientos dt ON dt.id_tratamiento = t.id_tratamiento
    JOIN catalogos.medicamentos me          ON me.id_medicamento = dt.id_medicamento
    WHERE m.id_mascota = @id
    GROUP BY
        m.nombre_m,
        m.fecha_nacimiento,
        m.peso_m,
        c.fecha_c,
        v.nombre_v,
        d.descripcion_d,
        t.descripcion_t
);
GO

SELECT * FROM dbo.fn_get_historial_medico(3);