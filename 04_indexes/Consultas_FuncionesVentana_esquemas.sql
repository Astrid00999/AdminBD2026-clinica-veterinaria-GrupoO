set statistics io on;
set statistics time on;
-- =========================================================================
-- Consultas analíticas avanzadas utilizando Funciones Ventana
-- ESQUEMAS: catalogos, gestion, clinica, finanzas
-- =========================================================================

USE [ClinicaVeterinaria];
GO

-- -------------------------------------------------------------------------
-- Consulta 1: Última visita completada de cada mascota (ROW_NUMBER)
-- Esquema: gestion.citas, gestion.mascotas
-- -------------------------------------------------------------------------
USE ClinicaVeterinaria;

WITH visitas AS (
    SELECT
        c.id_mascota,
        c.id_cita,
        c.fecha_c,
        ROW_NUMBER() OVER (
            PARTITION BY c.id_mascota
            ORDER BY c.fecha_c DESC, c.id_cita DESC
        ) AS rn
    FROM gestion.citas c
    WHERE c.estado_c = 'Completada'
)
SELECT
    m.id_mascota,
    m.nombre_m AS Mascota,
    v.fecha_c  AS UltimaVisita
FROM visitas v
JOIN gestion.mascotas m ON m.id_mascota = v.id_mascota
WHERE v.rn = 1
ORDER BY v.fecha_c DESC;

-- -------------------------------------------------------------------------
-- Consulta 2: Cálculo financiero acumulado por propietario (SUM OVER con Frame)
-- Esquema: finanzas.facturas, gestion.citas, gestion.mascotas, gestion.propietarios
-- -------------------------------------------------------------------------
SELECT 
    p.nombre_p + ' ' + p.apellido_p AS Propietario,
    f.id_factura AS IDFactura,
    f.fecha_emision_f AS FechaEmision,
    f.total_f AS TotalFactura,
    SUM(f.total_f) OVER (
        PARTITION BY m.id_propietario 
        ORDER BY f.fecha_emision_f, f.id_factura
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS GastoAcumuladoCliente
FROM finanzas.facturas f
JOIN gestion.citas c ON f.id_cita = c.id_cita
JOIN gestion.mascotas m ON c.id_mascota = m.id_mascota
JOIN gestion.propietarios p ON m.id_propietario = p.id_propietario;


-- -------------------------------------------------------------------------
-- Consulta 3: Navegación retrospectiva del historial médico (LAG)
-- Esquema: gestion.citas, gestion.mascotas
-- -------------------------------------------------------------------------
SELECT 
    m.nombre_m AS Mascota,
    c.fecha_c AS FechaCitaActual,
    c.motivo_c AS MotivoActual,
    LAG(c.fecha_c, 1) OVER (
        PARTITION BY c.id_mascota 
        ORDER BY c.fecha_c ASC
    ) AS FechaCitaAnterior,
    LAG(c.motivo_c, 1) OVER (
        PARTITION BY c.id_mascota 
        ORDER BY c.fecha_c ASC
    ) AS MotivoCitaAnterior
FROM gestion.citas c
JOIN gestion.mascotas m ON c.id_mascota = m.id_mascota;


-- -------------------------------------------------------------------------
-- Consulta 4: Ranking de productividad de veterinarios (DENSE_RANK)
-- Esquema: catalogos.veterinario, gestion.citas
-- -------------------------------------------------------------------------
SELECT 
    v.id_veterinario,
    v.nombre_v + ' ' + v.apellido_v AS Veterinario,
    COUNT(c.id_cita) AS TotalCitasAtendidas,
    DENSE_RANK() OVER (ORDER BY COUNT(c.id_cita) DESC) AS RankingVeterinario
FROM catalogos.veterinario v
LEFT JOIN gestion.citas c ON v.id_veterinario = c.id_veterinario
GROUP BY v.id_veterinario, v.nombre_v, v.apellido_v;


-- -------------------------------------------------------------------------
-- Consulta 5: Análisis estadístico de inventario y prescripción (DENSE_RANK)
-- Esquema: catalogos.medicamentos, clinica.detalles_tratamientos
-- -------------------------------------------------------------------------
SELECT 
    m.nombre_m AS Medicamento,
    m.presentacion_m AS Presentacion,
    m.laboratorio_m AS Laboratorio,
    COUNT(dt.id_medicamento) AS VecesRecetado,
    DENSE_RANK() OVER (ORDER BY COUNT(dt.id_medicamento) DESC) AS RankingUso
FROM catalogos.medicamentos m
JOIN clinica.detalles_tratamientos dt ON m.id_medicamento = dt.id_medicamento
GROUP BY m.id_medicamento, m.nombre_m, m.presentacion_m, m.laboratorio_m;


-- -------------------------------------------------------------------------
-- Consulta 6: Navegación prospectiva o proyección de citas futuras (LEAD)
-- Esquema: gestion.citas, gestion.mascotas
-- -------------------------------------------------------------------------
SELECT 
    m.nombre_m AS Mascota,
    c.fecha_c AS FechaCitaActual,
    c.motivo_c AS MotivoActual,
    LEAD(c.fecha_c, 1) OVER (
        PARTITION BY c.id_mascota 
        ORDER BY c.fecha_c ASC
    ) AS FechaSiguienteCita,
    LEAD(c.motivo_c, 1) OVER (
        PARTITION BY c.id_mascota 
        ORDER BY c.fecha_c ASC
    ) AS MotivoSiguienteCita
FROM gestion.citas c
JOIN gestion.mascotas m ON c.id_mascota = m.id_mascota;


-- -------------------------------------------------------------------------
-- Consulta 7: Extracción de extremos analíticos iniciales y finales (FIRST_VALUE y LAST_VALUE)
-- Esquema: gestion.citas, catalogos.veterinario, gestion.mascotas
-- -------------------------------------------------------------------------
SELECT 
    v.nombre_v + ' ' + v.apellido_v AS Veterinario,
    m.nombre_m AS MascotaAtendidaActual,
    c.fecha_c AS FechaCita,
    FIRST_VALUE(m.nombre_m) OVER (
        PARTITION BY c.id_veterinario 
        ORDER BY c.fecha_c ASC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS PrimeraMascotaAtendida,
    LAST_VALUE(m.nombre_m) OVER (
        PARTITION BY c.id_veterinario 
        ORDER BY c.fecha_c ASC
        ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS UltimaMascotaAtendida
FROM gestion.citas c
JOIN catalogos.veterinario v ON c.id_veterinario = v.id_veterinario
JOIN gestion.mascotas m ON c.id_mascota = m.id_mascota;