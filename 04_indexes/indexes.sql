USE ClinicaVeterinaria;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- Q1: última visita completada por mascota
CREATE NONCLUSTERED INDEX IX_citas_completadas_mascota_fecha
ON gestion.citas (id_mascota ASC, fecha_c DESC, id_cita DESC)
WHERE estado_c = 'Completada';
GO

-- Q3 y Q6: LAG / LEAD por mascota ordenado por fecha
CREATE NONCLUSTERED INDEX IX_citas_mascota_fecha
ON gestion.citas (id_mascota, fecha_c, id_cita)
INCLUDE (motivo_c);
GO

-- Q4 y Q7: conteo y ventanas por veterinario
CREATE NONCLUSTERED INDEX IX_citas_veterinario_fecha
ON gestion.citas (id_veterinario, fecha_c, id_cita)
INCLUDE (id_mascota);
GO

-- Q5: conteo de recetas por medicamento
CREATE NONCLUSTERED INDEX IX_detalles_tratamientos_medicamento
ON clinica.detalles_tratamientos (id_medicamento);
GO