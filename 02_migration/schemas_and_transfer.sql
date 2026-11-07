/* ============================================================
   02_ClinicaVeterinaria/schemas_and_transfer.sql

   Requisitos:
     - Ejecutar con una cuenta sysadmin.
     - Ejecutar después de 02_ClinicaVeterinaria/schema_and_data.sql
       y antes de los demás scripts (vistas, índices, auditoría, roles).

   Orden de este script:
     0. verificación de la base
     1. respaldo previo (fase 0)
     2. creación de esquemas (fase 1)
     3. transferencia de tablas (fase 2)
     4. verificación

   Importante: alter schema ... transfer elimina los permisos que
   tenía cada tabla. Después de este script hay que volver a ejecutar
   03_security/roles_users.sql (actualizado con los nombres nuevos).
   ============================================================ */


/* ------------------------------------------------------------
   0. verificación de la base
   ------------------------------------------------------------ */
use master;
go

if db_id(N'migracion') is null
begin
    raiserror(N'La base migracion no existe. Ejecuten primero 02_ClinicaVeterinaria/schema_and_data.sql.', 16, 1);
    set noexec on;
end
go

use migracion;
go



--Esquemas 

if schema_id(N'catalogos') is null exec (N'create schema catalogos authorization dbo;');  -- datos de referencia
if schema_id(N'gestion')   is null exec (N'create schema gestion authorization dbo;');    -- clientes, mascotas y agenda
if schema_id(N'clinica')   is null exec (N'create schema clinica authorization dbo;');    -- atención médica
if schema_id(N'finanzas')  is null exec (N'create schema finanzas authorization dbo;');   -- facturación
if schema_id(N'reportes')  is null exec (N'create schema reportes authorization dbo;');   -- vistas de consulta
if schema_id(N'seguridad') is null exec (N'create schema seguridad authorization dbo;');  -- auditoría y objetos de apoyo
go


/* ------------------------------------------------------------
 Transferencia
   ------------------------------------------------------------ */

-- catálogos
if object_id(N'dbo.especies', N'U')       is not null alter schema catalogos transfer dbo.especies;
if object_id(N'dbo.razas', N'U')          is not null alter schema catalogos transfer dbo.razas;
if object_id(N'dbo.especialidades', N'U') is not null alter schema catalogos transfer dbo.especialidades;
if object_id(N'dbo.veterinario', N'U')    is not null alter schema catalogos transfer dbo.veterinario;
if object_id(N'dbo.medicamentos', N'U')   is not null alter schema catalogos transfer dbo.medicamentos;

-- gestión
if object_id(N'dbo.propietarios', N'U')   is not null alter schema gestion transfer dbo.propietarios;
if object_id(N'dbo.mascotas', N'U')       is not null alter schema gestion transfer dbo.mascotas;
if object_id(N'dbo.citas', N'U')          is not null alter schema gestion transfer dbo.citas;

-- clínica
if object_id(N'dbo.diagnosticos', N'U')          is not null alter schema clinica transfer dbo.diagnosticos;
if object_id(N'dbo.tratamiento', N'U')           is not null alter schema clinica transfer dbo.tratamiento;
if object_id(N'dbo.detalles_tratamientos', N'U') is not null alter schema clinica transfer dbo.detalles_tratamientos;
if object_id(N'dbo.procedimientos', N'U')        is not null alter schema clinica transfer dbo.procedimientos;

-- finanzas
if object_id(N'dbo.facturas', N'U')          is not null alter schema finanzas transfer dbo.facturas;
if object_id(N'dbo.detalles_facturas', N'U') is not null alter schema finanzas transfer dbo.detalles_facturas;
go





/* ------------------------------------------------------------
   4. verificación
   ------------------------------------------------------------ */

-- 4.1 esquemas y su propietario (deben salir 6, todos de dbo)
select name as esquema, user_name(principal_id) as propietario
from sys.schemas
where name in (N'catalogos', N'gestion', N'clinica', N'finanzas', N'reportes', N'seguridad')
order by name;

-- 4.2 tablas por esquema (deben salir 14, ninguna en dbo)
select s.name as esquema, t.name as tabla,
       (select sum(p.rows) from sys.partitions p
        where p.object_id = t.object_id and p.index_id in (0, 1)) as filas
from sys.tables as t
join sys.schemas as s on s.schema_id = t.schema_id
order by s.name, t.name;

-- 4.3 resumen: llaves foráneas (17) y tablas que quedaron en dbo (0)
select
    (select count(*) from sys.foreign_keys) as llaves_foraneas,
    (select count(*) from sys.tables where schema_id = schema_id(N'dbo') and is_ms_shipped = 0) as tablas_en_dbo;

-- 4.4 las relaciones siguen funcionando entre esquemas
select top 5
    c.id_cita,
    c.fecha_c,
    m.nombre_m as mascota,
    v.nombre_v + ' ' + v.apellido_v as veterinario,
    f.id_factura,
    f.total_f
from gestion.citas as c
join gestion.mascotas as m on m.id_mascota = c.id_mascota
join catalogos.veterinario as v on v.id_veterinario = c.id_veterinario
join finanzas.facturas as f on f.id_cita = c.id_cita
order by c.id_cita;
go

set noexec off;
go
