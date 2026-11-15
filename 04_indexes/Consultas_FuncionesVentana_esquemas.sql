-- =====================================================================
-- Clínica veterinaria · Consultas con funciones ventana
-- Ejecutar cada consulta por separado, con el plan real activado
-- (Ctrl+M). Los valores del WHERE (5, 100, 1234, 1000, 10) son de ejemplo.
-- Los índices de cada consulta están en indexes.sql
-- =====================================================================

SET STATISTICS IO, TIME ON;
GO

-- ---------------------------------------------------------------------
-- CONSULTA 1: las 3 citas más recientes de cada mes de un veterinario
-- Ventana: row_number() particionada por año y mes
-- ---------------------------------------------------------------------
with citas_mes as (
    select c.id_cita,
           c.fecha_c,
           c.motivo_c,
           c.estado_c,
           row_number() over (partition by year(c.fecha_c), month(c.fecha_c)
                              order by c.fecha_c desc, c.id_cita desc) as rn
    from gestion.citas c
    where c.id_veterinario = 5
)
select year(fecha_c) as anio, month(fecha_c) as mes,
       fecha_c, motivo_c, estado_c, rn
from citas_mes
where rn <= 3
order by anio desc, mes desc, rn;


-- ---------------------------------------------------------------------
-- CONSULTA 2: las 2 citas más recientes de cada mascota de un propietario
-- Ventana: row_number() particionada por mascota
-- ---------------------------------------------------------------------
with citas_mascota as (
    select m.id_mascota,
           m.nombre_m,
           c.id_cita,
           c.fecha_c,
           c.motivo_c,
           row_number() over (partition by m.id_mascota
                              order by c.fecha_c desc, c.id_cita desc) as rn
    from gestion.mascotas m
    join gestion.citas c on c.id_mascota = m.id_mascota
    where m.id_propietario = 100
)
select id_mascota, nombre_m, fecha_c, motivo_c, rn
from citas_mascota
where rn <= 2
order by id_mascota, rn;


-- ---------------------------------------------------------------------
-- CONSULTA 3: procedimientos de un diagnóstico, con número de orden
--             y costo acumulado
-- Ventanas: row_number() y sum() over con acumulado
-- ---------------------------------------------------------------------
select p.id_procedimiento, p.nombre_p, p.costo_p,
       row_number() over (order by p.id_procedimiento)             as n,
       sum(p.costo_p) over (order by p.id_procedimiento
                            rows unbounded preceding)              as costo_acumulado
from clinica.procedimientos p
where p.id_diagnostico = 1234;


-- ---------------------------------------------------------------------
-- CONSULTA 4: los 2 procedimientos más caros de cada diagnóstico de una cita
-- Ventana: row_number() particionada por diagnóstico
-- ---------------------------------------------------------------------
with procs as (
    select d.id_diagnostico,
           d.descripcion_d,
           p.nombre_p,
           p.costo_p,
           row_number() over (partition by d.id_diagnostico
                              order by p.costo_p desc, p.id_procedimiento) as rn
    from clinica.diagnosticos d
    join clinica.procedimientos p on p.id_diagnostico = d.id_diagnostico
    where d.id_cita = 1000
)
select id_diagnostico, descripcion_d, nombre_p, costo_p, rn
from procs
where rn <= 2
order by id_diagnostico, rn;


-- ---------------------------------------------------------------------
-- CONSULTA 5: las 3 mascotas más pesadas de cada tamaño dentro de una raza
-- Ventana: row_number() particionada por tamaño
-- ---------------------------------------------------------------------
with ranking as (
    select m.id_mascota, m.nombre_m, m.tamanio_m, m.peso_m,
           row_number() over (partition by m.tamanio_m
                              order by m.peso_m desc, m.id_mascota) as rn
    from gestion.mascotas m
    where m.id_raza = 10
)
select tamanio_m, rn, id_mascota, nombre_m, peso_m
from ranking
where rn <= 3
order by tamanio_m, rn;
