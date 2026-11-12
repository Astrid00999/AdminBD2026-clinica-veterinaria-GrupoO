-- Indexes.sql, se aplican sobre las funciones ventana creadas

-- LIMPIEZA
drop index if exists ix_citas_vet_fecha            on gestion.citas;
drop index if exists ix_citas_mascota_fecha        on gestion.citas;
drop index if exists ix_mascotas_propietario       on gestion.mascotas;
drop index if exists ix_proc_diagnostico           on clinica.procedimientos;
drop index if exists ix_proc_diag_costo            on clinica.procedimientos;
drop index if exists ix_mascotas_raza_tamanio_peso on gestion.mascotas;


-- APLICA A: CONSULTA 1 (citas más recientes por mes de un veterinario)
-- Filtro por id_veterinario y orden de la ventana por fecha_c / id_cita.

create nonclustered index ix_citas_vet_fecha
on gestion.citas (id_veterinario, fecha_c desc, id_cita desc)
include (motivo_c, estado_c);
GO

-- APLICA A: CONSULTA 2 (últimas 2 citas por mascota de un propietario)
-- Requiere los DOS índices:
--   * mascotas: seek por propietario
--   * citas: seek por mascota, ya ordenado como la ventana (sin Sort)

create nonclustered index ix_mascotas_propietario
on gestion.mascotas (id_propietario)
include (nombre_m);
GO

create nonclustered index ix_citas_mascota_fecha
on gestion.citas (id_mascota, fecha_c desc, id_cita desc)
include (motivo_c);
GO

-- APLICA A: CONSULTA 3 (procedimientos de un diagnóstico, con acumulado)
-- Cambio esperado: Clustered Index Scan de procedimientos -> Index Seek,

create nonclustered index ix_proc_diagnostico
on clinica.procedimientos (id_diagnostico)
include (nombre_p, costo_p);
GO

-- APLICA A: CONSULTA 4 (2 procedimientos más caros por diagnóstico)
-- El índice coincide con el partition by / order by de la ventana.

create nonclustered index ix_proc_diag_costo
on clinica.procedimientos (id_diagnostico, costo_p desc, id_procedimiento)
include (nombre_p);
GO

-- APLICA A: CONSULTA 5 (3 mascotas más pesadas por tamaño en una raza)
-- Cubre el filtro (id_raza) y el partition by / order by de la ventana.

create nonclustered index ix_mascotas_raza_tamanio_peso
on gestion.mascotas (id_raza, tamanio_m, peso_m desc, id_mascota)
include (nombre_m);
