/* ============================================================
   05_programmability/views.sql

   Requisitos:
     - Ejecutar después de 02_ClinicaVeterinaria/schemas_and_transfer.sql
       (las tablas ya deben estar en catalogos, gestion, clinica y finanzas).

   Criterios de diseño:
     - cada vista responde a una necesidad concreta de un perfil.
     - solo se exponen las columnas necesarias.
     - solo vw_propietarios tiene datos de contacto; ninguna vista
       expone dui ni dirección.
     - una fila por llave: las relaciones 1:n (tratamientos,
       procedimientos, detalles) se resumen con outer apply para no
       duplicar filas.
     - las columnas text se convierten a varchar(max), que es el tipo
       actual y el que lee bien power bi.
     - no se usa schemabinding, para no bloquear cambios de tipo en
       las tablas (por ejemplo, pasar text a varchar(max)).

   Vistas:
     1. vw_propietarios              recepción: clientes y contacto
     2. vw_mascotas                  mascotas con especie y raza
     3. vw_citas                     agenda y estado de citas
     4. vw_historial_clinico         consulta clínica por diagnóstico
     5. vw_facturacion               facturas con su cita y cliente
     6. vw_detalle_facturacion       conceptos facturados
     7. vw_resumen_financiero        resumen mensual para análisis
     8. vw_productividad_veterinaria indicadores por veterinario
     9. vw_indicadores_mascotas      indicadores sin datos personales (bi)
   ============================================================ */


/* ------------------------------------------------------------
   0. verificación
   ------------------------------------------------------------ */
use master;
go

if db_id(N'ClinicaVeterinaria') is null
begin
    raiserror(N'La base ClinicaVeterinaria no existe.', 16, 1);
    set noexec on;
end
go

use ClinicaVeterinaria;
go

if schema_id(N'reportes') is null or object_id(N'gestion.citas', N'U') is null
begin
    raiserror(N'Primero ejecuten 02_ClinicaVeterinaria/schemas_and_transfer.sql.', 16, 1);
    set noexec on;
end
go


/* ------------------------------------------------------------
   1. vw_propietarios
   consumidor: recepción. una fila por propietario con sus datos de
   contacto y cuántas mascotas tiene. no incluye dui ni dirección.
   ------------------------------------------------------------ */
create or alter view reportes.vw_propietarios
as
select
    p.id_propietario,
    p.nombre_p,
    p.apellido_p,
    p.genero_p,
    p.telefono_p,
    p.telefono_secundario_p,
    p.correo_p,
    count(m.id_mascota) as total_mascotas
from gestion.propietarios as p
left join gestion.mascotas as m on m.id_propietario = p.id_propietario
group by p.id_propietario, p.nombre_p, p.apellido_p, p.genero_p,
         p.telefono_p, p.telefono_secundario_p, p.correo_p;
go


/* ------------------------------------------------------------
   2. vw_mascotas
   consumidores: recepción, veterinario, bi. una fila por mascota con
   su especie y raza. del propietario solo se deja el id.
   ------------------------------------------------------------ */
create or alter view reportes.vw_mascotas
as
select
    m.id_mascota,
    m.nombre_m as mascota,
    e.nombre_e as especie,
    r.nombre_r as raza,
    m.sexo_m,
    m.fecha_nacimiento,
    datediff(month, m.fecha_nacimiento, cast(getdate() as date)) / 12 as edad_anios,
    m.peso_m,
    m.tamanio_m,
    m.id_propietario
from gestion.mascotas as m
join catalogos.razas as r on r.id_raza = m.id_raza
join catalogos.especies as e on e.id_especie = r.id_especie;
go


/* ------------------------------------------------------------
   3. vw_citas
   consumidores: recepción, veterinario, bi. una fila por cita con la
   mascota, el veterinario y su especialidad. sin datos del propietario.
   ------------------------------------------------------------ */
create or alter view reportes.vw_citas
as
select
    c.id_cita,
    c.fecha_c,
    cast(c.fecha_c as date) as fecha,
    cast(c.fecha_c as time(0)) as hora,
    c.estado_c,
    cast(c.motivo_c as varchar(max)) as motivo,
    c.costo_c,
    c.id_mascota,
    m.nombre_m as mascota,
    e.nombre_e as especie,
    c.id_veterinario,
    v.nombre_v + ' ' + v.apellido_v as veterinario,
    es.nombre_esp as especialidad
from gestion.citas as c
join gestion.mascotas as m on m.id_mascota = c.id_mascota
join catalogos.razas as r on r.id_raza = m.id_raza
join catalogos.especies as e on e.id_especie = r.id_especie
join catalogos.veterinario as v on v.id_veterinario = c.id_veterinario
join catalogos.especialidades as es on es.id_especialidad = v.id_especialidad;
go


/* ------------------------------------------------------------
   4. vw_historial_clinico
   consumidor: veterinario. una fila por diagnóstico (cada cita tiene
   como máximo uno). los tratamientos, medicamentos y procedimientos
   se resumen para no repetir el diagnóstico.
   ------------------------------------------------------------ */
create or alter view reportes.vw_historial_clinico
as
select
    d.id_diagnostico,
    c.id_cita,
    c.fecha_c,
    d.fecha_d,
    m.id_mascota,
    m.nombre_m as mascota,
    e.nombre_e as especie,
    r.nombre_r as raza,
    v.nombre_v + ' ' + v.apellido_v as veterinario,
    cast(d.descripcion_d as varchar(max)) as diagnostico,
    cast(d.observaciones_d as varchar(max)) as observaciones,
    t.total_tratamientos,
    t.medicamentos,
    pr.total_procedimientos
from clinica.diagnosticos as d
join gestion.citas as c on c.id_cita = d.id_cita
join gestion.mascotas as m on m.id_mascota = c.id_mascota
join catalogos.razas as r on r.id_raza = m.id_raza
join catalogos.especies as e on e.id_especie = r.id_especie
join catalogos.veterinario as v on v.id_veterinario = c.id_veterinario
outer apply (
    select
        count(distinct tr.id_tratamiento) as total_tratamientos,
        string_agg(me.nombre_m, ', ') as medicamentos
    from clinica.tratamiento as tr
    left join clinica.detalles_tratamientos as dt on dt.id_tratamiento = tr.id_tratamiento
    left join catalogos.medicamentos as me on me.id_medicamento = dt.id_medicamento
    where tr.id_diagnostico = d.id_diagnostico
) as t
outer apply (
    select count(*) as total_procedimientos
    from clinica.procedimientos as p
    where p.id_diagnostico = d.id_diagnostico
) as pr;
go


/* ------------------------------------------------------------
   5. vw_facturacion
   consumidor: facturación. una fila por factura con su cita, la
   mascota y el nombre del propietario (dato mínimo para cobrar).
   total_calculado suma los detalles para detectar totales
   que no cuadran con total_f.
   ------------------------------------------------------------ */
create or alter view reportes.vw_facturacion
as
select
    f.id_factura,
    f.fecha_emision_f,
    f.estado_f,
    f.total_f,
    d.lineas,
    d.total_calculado,
    f.id_cita,
    c.fecha_c,
    m.id_mascota,
    m.nombre_m as mascota,
    p.id_propietario,
    p.nombre_p + ' ' + p.apellido_p as propietario
from finanzas.facturas as f
left join gestion.citas as c on c.id_cita = f.id_cita
left join gestion.mascotas as m on m.id_mascota = c.id_mascota
left join gestion.propietarios as p on p.id_propietario = m.id_propietario
outer apply (
    select count(*) as lineas, sum(df.subtotal_df) as total_calculado
    from finanzas.detalles_facturas as df
    where df.id_factura = f.id_factura
) as d;
go


/* ------------------------------------------------------------
   6. vw_detalle_facturacion
   consumidores: facturación, bi. una fila por renglón de factura con
   el tipo de concepto cobrado. sin datos del propietario.
   ------------------------------------------------------------ */
create or alter view reportes.vw_detalle_facturacion
as
select
    df.id_factura,
    df.id_detalle_factura,
    f.fecha_emision_f,
    f.estado_f,
    case
        when df.id_medicamento is not null   then 'Medicamento'
        when df.id_procedimiento is not null then 'Procedimiento'
        when df.id_tratamiento is not null   then 'Tratamiento'
        when df.id_cita is not null          then 'Atención'
        else 'Otro'
    end as tipo_concepto,
    cast(df.descripcion_df as varchar(max)) as descripcion,
    me.nombre_m as medicamento,
    me.presentacion_m,
    df.cantidad_df,
    df.precio_unit_df,
    df.subtotal_df
from finanzas.detalles_facturas as df
join finanzas.facturas as f on f.id_factura = df.id_factura
left join catalogos.medicamentos as me on me.id_medicamento = df.id_medicamento;
go


/* ------------------------------------------------------------
   7. vw_resumen_financiero
   consumidores: facturación, bi. una fila por mes con lo facturado,
   lo cobrado y lo pendiente.
   ------------------------------------------------------------ */
create or alter view reportes.vw_resumen_financiero
as
select
    year(f.fecha_emision_f) as anio,
    month(f.fecha_emision_f) as mes,
    count(*) as total_facturas,
    sum(case when f.estado_f = 'Pagada' then 1 else 0 end) as facturas_pagadas,
    sum(case when f.estado_f = 'Pendiente' then 1 else 0 end) as facturas_pendientes,
    sum(f.total_f) as monto_facturado,
    sum(case when f.estado_f = 'Pagada' then f.total_f else 0 end) as monto_cobrado,
    sum(case when f.estado_f = 'Pendiente' then f.total_f else 0 end) as monto_pendiente,
    cast(avg(f.total_f) as numeric(10, 2)) as ticket_promedio
from finanzas.facturas as f
group by year(f.fecha_emision_f), month(f.fecha_emision_f);
go


/* ------------------------------------------------------------
   8. vw_productividad_veterinaria
   consumidores: administración, bi. una fila por veterinario con sus
   citas por estado, diagnósticos y mascotas atendidas. como cada cita
   tiene como máximo un diagnóstico, el join no duplica citas.
   ------------------------------------------------------------ */
create or alter view reportes.vw_productividad_veterinaria
as
select
    v.id_veterinario,
    v.nombre_v + ' ' + v.apellido_v as veterinario,
    es.nombre_esp as especialidad,
    count(c.id_cita) as total_citas,
    sum(case when c.estado_c = 'Completada' then 1 else 0 end) as citas_completadas,
    sum(case when c.estado_c = 'Cancelada'  then 1 else 0 end) as citas_canceladas,
    sum(case when c.estado_c = 'Programada' then 1 else 0 end) as citas_programadas,
    count(d.id_diagnostico) as diagnosticos_emitidos,
    count(distinct c.id_mascota) as mascotas_atendidas,
    min(c.fecha_c) as primera_cita,
    max(c.fecha_c) as ultima_cita
from catalogos.veterinario as v
join catalogos.especialidades as es on es.id_especialidad = v.id_especialidad
left join gestion.citas as c on c.id_veterinario = v.id_veterinario
left join clinica.diagnosticos as d on d.id_cita = c.id_cita
group by v.id_veterinario, v.nombre_v, v.apellido_v, es.nombre_esp;
go


/* ------------------------------------------------------------
   9. vw_indicadores_mascotas
   consumidor: bi. una fila por especie y raza, solo con datos
   agregados: no identifica a ninguna mascota ni propietario.
   ------------------------------------------------------------ */
create or alter view reportes.vw_indicadores_mascotas
as
select
    e.nombre_e as especie,
    r.nombre_r as raza,
    count(*) as total_mascotas,
    sum(case when m.sexo_m = 'Macho'  then 1 else 0 end) as machos,
    sum(case when m.sexo_m = 'Hembra' then 1 else 0 end) as hembras,
    cast(avg(m.peso_m) as numeric(6, 2)) as peso_promedio,
    cast(avg(datediff(month, m.fecha_nacimiento, cast(getdate() as date)) / 12.0) as numeric(5, 1)) as edad_promedio_anios
from gestion.mascotas as m
join catalogos.razas as r on r.id_raza = m.id_raza
join catalogos.especies as e on e.id_especie = r.id_especie
group by e.nombre_e, r.nombre_r;
go


/* ------------------------------------------------------------
   10. verificación
   ------------------------------------------------------------ */

-- 10.1 vistas creadas (deben salir 9)
select s.name as esquema, v.name as vista, v.create_date, v.modify_date
from sys.views as v
join sys.schemas as s on s.schema_id = v.schema_id
where s.name = N'reportes'
order by v.name;

-- 10.2 sin filas duplicadas ni perdidas
-- filas = llaves distintas = filas esperadas según la tabla base
select
    vista, filas, llaves, esperadas,
    case when filas = llaves and filas = esperadas then N'OK' else N'REVISAR' end as estado
from (
    select N'vw_propietarios' as vista, count(*) as filas, count(distinct id_propietario) as llaves,
           (select count(*) from gestion.propietarios) as esperadas
    from reportes.vw_propietarios
    union all
    select N'vw_mascotas', count(*), count(distinct id_mascota),
           (select count(*) from gestion.mascotas)
    from reportes.vw_mascotas
    union all
    select N'vw_citas', count(*), count(distinct id_cita),
           (select count(*) from gestion.citas)
    from reportes.vw_citas
    union all
    select N'vw_historial_clinico', count(*), count(distinct id_diagnostico),
           (select count(*) from clinica.diagnosticos)
    from reportes.vw_historial_clinico
    union all
    select N'vw_facturacion', count(*), count(distinct id_factura),
           (select count(*) from finanzas.facturas)
    from reportes.vw_facturacion
    union all
    select N'vw_detalle_facturacion', count(*), count(distinct concat(id_factura, '-', id_detalle_factura)),
           (select count(*) from finanzas.detalles_facturas)
    from reportes.vw_detalle_facturacion
    union all
    select N'vw_resumen_financiero', count(*), count(distinct concat(anio, '-', mes)),
           (select count(*) from (select distinct year(fecha_emision_f) as a, month(fecha_emision_f) as m
                                  from finanzas.facturas) as x)
    from reportes.vw_resumen_financiero
    union all
    select N'vw_productividad_veterinaria', count(*), count(distinct id_veterinario),
           (select count(*) from catalogos.veterinario)
    from reportes.vw_productividad_veterinaria
    union all
    select N'vw_indicadores_mascotas', count(*), count(distinct concat(especie, '|', raza)),
           (select count(distinct m.id_raza) from gestion.mascotas as m)
    from reportes.vw_indicadores_mascotas
) as v;
go

set noexec off;
go
