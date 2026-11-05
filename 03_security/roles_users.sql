/* ============================================================
   03_security/roles_users.sql

   Requisitos:
     - Ejecutar con una cuenta sysadmin.
     - Ejecutar al final, después de:
         02_migration/schema_and_data.sql
         02_migration/schemas_and_transfer.sql
         05_programmability/views.sql
         03_security/audits.sql y 06_backup_restore/backup_strategy.sql
       (si estos dos aún no existen, el script avisa y se puede repetir después)
     - Escribir las contraseñas en la sección 0 SOLO al ejecutar.
       No suban el archivo con contraseñas al repositorio.

   Orden de este script:
     0. verificación y contraseñas
     1. limpieza (permite volver a ejecutarlo desde cero)
     2. roles
     3. permisos de cada rol (matriz)
     4. inicios de sesión
     5. usuarios y pertenencia a roles
     6. pruebas de permisos
     7. consultas de evidencia
   ============================================================ */


/* ------------------------------------------------------------
   0. verificación y contraseñas
   las contraseñas se guardan solo en la sesión (session_context) y
   se borran al final. mínimo 8 caracteres con mayúscula, minúscula,
   número y símbolo.
   ------------------------------------------------------------ */
use master;
go

declare @clave_personal nvarchar(128) = N'<escribir antes de ejecutar>';  -- cuentas de personas
declare @clave_servicio nvarchar(128) = N'<escribir antes de ejecutar>';  -- lg_bi y lg_backup

if db_id(N'migracion') is null
begin
    raiserror(N'La base migracion no existe. Ejecuten primero 02_migration/schema_and_data.sql.', 16, 1);
    set noexec on;
end
else if @clave_personal like N'<%' or @clave_servicio like N'<%'
begin
    raiserror(N'Escriban las dos contraseñas en la sección 0 antes de ejecutar.', 16, 1);
    set noexec on;
end
else
begin
    exec sp_set_session_context N'clave_personal', @clave_personal;
    exec sp_set_session_context N'clave_servicio', @clave_servicio;
end
go

use migracion;
go

if object_id(N'gestion.citas', N'U') is null or object_id(N'reportes.vw_citas', N'V') is null
begin
    raiserror(N'Primero ejecuten 02_migration/schemas_and_transfer.sql y 05_programmability/views.sql.', 16, 1);
    set noexec on;
end
go


/* ------------------------------------------------------------
   1. limpieza
   borra los usuarios usr_*, los roles rol_* y los logins lg_* del
   proyecto (incluidos los de versiones anteriores del script).
   ------------------------------------------------------------ */
declare @sql nvarchar(max) = N'';

select @sql += N'drop user ' + quotename(name) + N';' + nchar(10)
from sys.database_principals
where type = 'S' and name like N'usr[_]%';

select @sql += N'drop role ' + quotename(name) + N';' + nchar(10)
from sys.database_principals
where type = 'R' and is_fixed_role = 0 and name like N'rol[_]%';

exec (@sql);
go

use master;
go

declare @sql nvarchar(max) = N'';

select @sql += N'drop login ' + quotename(name) + N';' + nchar(10)
from sys.server_principals
where type = 'S' and name like N'lg[_]%';

-- rol de servidor de la versión anterior (ya no se usa)
if exists (select 1 from sys.server_principals where name = N'rol_srv_respaldo' and type = 'R')
    set @sql += N'drop server role rol_srv_respaldo;';

exec (@sql);
go


/* ------------------------------------------------------------
   2. roles de base de datos
   ------------------------------------------------------------ */
use migracion;
go

create role rol_admin       authorization dbo;  -- administración técnica (no para uso diario)
create role rol_veterinario authorization dbo;  -- atención clínica
create role rol_recepcion   authorization dbo;  -- propietarios, mascotas y agenda
create role rol_facturacion authorization dbo;  -- cobros y facturas
create role rol_bi          authorization dbo;  -- análisis: solo vistas sin datos personales
create role rol_respaldo    authorization dbo;  -- cuenta de servicio de respaldos
create role rol_auditoria   authorization dbo;  -- lectura de la auditoría
create role rol_docente     authorization dbo;  -- docente: revisa todo, no modifica nada
create role rol_estudiante  authorization dbo;  -- equipo: construye y prueba la base
go


/* ------------------------------------------------------------
   3. permisos de cada rol
   regla: permisos sobre objetos concretos (tablas, columnas, vistas).
   los permisos sobre un esquema completo solo se usan cuando el rol
   es dueño de todo ese módulo, y se justifica en cada caso.
   ------------------------------------------------------------ */

-- 3.1 rol_admin: administra los datos de todos los módulos
-- (esquema completo: su función es dar soporte a cualquier módulo)
grant select, insert, update, delete, view definition on schema::catalogos to rol_admin;
grant select, insert, update, delete, view definition on schema::gestion   to rol_admin;
grant select, insert, update, delete, view definition on schema::clinica   to rol_admin;
grant select, insert, update, delete, view definition on schema::finanzas  to rol_admin;
grant select, view definition on schema::reportes to rol_admin;
grant select, execute, view definition on schema::seguridad to rol_admin;

-- mantenimiento de índices y estadísticas: alter tabla por tabla, no sobre el
-- esquema, para que no pueda crear ni eliminar tablas
grant alter on catalogos.especies             to rol_admin;
grant alter on catalogos.razas                to rol_admin;
grant alter on catalogos.especialidades       to rol_admin;
grant alter on catalogos.veterinario          to rol_admin;
grant alter on catalogos.medicamentos         to rol_admin;
grant alter on gestion.propietarios           to rol_admin;
grant alter on gestion.mascotas               to rol_admin;
grant alter on gestion.citas                  to rol_admin;
grant alter on clinica.diagnosticos           to rol_admin;
grant alter on clinica.tratamiento            to rol_admin;
grant alter on clinica.detalles_tratamientos  to rol_admin;
grant alter on clinica.procedimientos         to rol_admin;
grant alter on finanzas.facturas              to rol_admin;
grant alter on finanzas.detalles_facturas     to rol_admin;

-- planes de ejecución, fragmentación y query store; respaldos manuales
grant showplan, view database state to rol_admin;
alter role db_backupoperator add member rol_admin;
go

-- 3.2 rol_veterinario: registra la información clínica
-- (esquema completo de clinica: todo el módulo es su responsabilidad)
grant select, insert, update on schema::clinica to rol_veterinario;

grant select on catalogos.especies       to rol_veterinario;
grant select on catalogos.razas          to rol_veterinario;
grant select on catalogos.especialidades to rol_veterinario;
grant select on catalogos.veterinario    to rol_veterinario;
grant select on catalogos.medicamentos   to rol_veterinario;

-- mascotas y citas: lectura, y solo actualiza los campos de la atención
grant select on gestion.mascotas to rol_veterinario;
grant update (peso_m) on gestion.mascotas to rol_veterinario;
grant select on gestion.citas to rol_veterinario;
grant update (estado_c, motivo_c) on gestion.citas to rol_veterinario;

-- propietarios solo a través de la vista (contacto, sin dui ni dirección)
grant select on reportes.vw_propietarios      to rol_veterinario;
grant select on reportes.vw_mascotas          to rol_veterinario;
grant select on reportes.vw_citas             to rol_veterinario;
grant select on reportes.vw_historial_clinico to rol_veterinario;
go

-- 3.3 rol_recepcion: gestiona clientes, mascotas y agenda
-- (esquema completo de gestion: todo el módulo es su responsabilidad; sin delete)
grant select, insert, update on schema::gestion to rol_recepcion;

grant select on catalogos.especies       to rol_recepcion;
grant select on catalogos.razas          to rol_recepcion;
grant select on catalogos.especialidades to rol_recepcion;
grant select on catalogos.veterinario    to rol_recepcion;

-- facturas: solo el estado, para informar al cliente si ya pagó
grant select (id_factura, id_cita, fecha_emision_f, estado_f) on finanzas.facturas to rol_recepcion;

grant select on reportes.vw_propietarios to rol_recepcion;
grant select on reportes.vw_mascotas     to rol_recepcion;
grant select on reportes.vw_citas        to rol_recepcion;
go

-- 3.4 rol_facturacion: crea y actualiza facturas (sin delete: se anulan)
-- (esquema completo de finanzas: todo el módulo es su responsabilidad)
grant select, insert, update on schema::finanzas to rol_facturacion;

-- solo los datos necesarios para cobrar
grant select on catalogos.medicamentos to rol_facturacion;
grant select (id_cita, id_mascota, fecha_c, estado_c, costo_c) on gestion.citas to rol_facturacion;
grant select (id_procedimiento, nombre_p, costo_p) on clinica.procedimientos to rol_facturacion;

grant select on reportes.vw_facturacion         to rol_facturacion;
grant select on reportes.vw_detalle_facturacion to rol_facturacion;
grant select on reportes.vw_resumen_financiero  to rol_facturacion;
go

-- 3.5 rol_bi: solo vistas sin datos personales, ninguna tabla base
grant select on reportes.vw_mascotas                  to rol_bi;
grant select on reportes.vw_citas                     to rol_bi;
grant select on reportes.vw_detalle_facturacion       to rol_bi;
grant select on reportes.vw_resumen_financiero        to rol_bi;
grant select on reportes.vw_productividad_veterinaria to rol_bi;
grant select on reportes.vw_indicadores_mascotas      to rol_bi;
go

-- 3.6 rol_respaldo: solo respaldar (no lee ni modifica datos)
alter role db_backupoperator add member rol_respaldo;
go

-- 3.7 rol_auditoria: solo lectura del esquema seguridad
grant select on schema::seguridad to rol_auditoria;
go

-- 3.8 rol_docente: lectura de todo para revisar el proyecto, sin escribir
-- (esquemas completos: su función es evaluar todos los módulos)
grant select, view definition on schema::catalogos to rol_docente;
grant select, view definition on schema::gestion   to rol_docente;
grant select, view definition on schema::clinica   to rol_docente;
grant select, view definition on schema::finanzas  to rol_docente;
grant select, view definition on schema::reportes  to rol_docente;
grant showplan, view database state to rol_docente;
go

-- 3.9 rol_estudiante: construir y probar (tablas, índices, vistas, procedimientos)
-- sin administrar usuarios, roles ni permisos, y sin tocar el esquema seguridad
grant select, insert, update, delete, execute, alter, view definition on schema::catalogos to rol_estudiante;
grant select, insert, update, delete, execute, alter, view definition on schema::gestion   to rol_estudiante;
grant select, insert, update, delete, execute, alter, view definition on schema::clinica   to rol_estudiante;
grant select, insert, update, delete, execute, alter, view definition on schema::finanzas  to rol_estudiante;
grant select, execute, alter, view definition on schema::reportes to rol_estudiante;
grant select, view definition on schema::seguridad to rol_estudiante;
grant create table, create view, create procedure, create function to rol_estudiante;
grant showplan, view database state to rol_estudiante;
go

-- 3.10 objetos de otros scripts (se aplican solo si ya existen)
declare @aud nvarchar(200) =
    case when object_id(N'seguridad.auditoria_log', N'U') is not null then N'seguridad.auditoria_log'
         when object_id(N'dbo.auditoria_log', N'U') is not null       then N'dbo.auditoria_log' end;

declare @proc nvarchar(200) =
    case when object_id(N'seguridad.sp_respaldo', N'P') is not null then N'seguridad.sp_respaldo'
         when object_id(N'dbo.sp_respaldo', N'P') is not null       then N'dbo.sp_respaldo' end;

if @aud is not null
begin
    -- solo lectura para quien la revisa; nadie la modifica (los triggers sí
    -- pueden escribir porque pertenecen al mismo dueño: encadenamiento de propiedad)
    exec (N'grant select on ' + @aud + N' to rol_admin, rol_auditoria, rol_estudiante;
            deny insert, update, delete, alter on ' + @aud + N' to rol_admin, rol_auditoria, rol_docente, rol_estudiante;
            deny select, insert, update, delete on ' + @aud + N' to rol_veterinario, rol_recepcion, rol_facturacion, rol_bi, rol_respaldo;');
    print N'Permisos de ' + @aud + N' aplicados.';
end
else
    print N'Aviso: la tabla auditoria_log aún no existe. Vuelvan a ejecutar este script después de 03_security/audits.sql.';

if @proc is not null
begin
    exec (N'grant execute on ' + @proc + N' to rol_respaldo, rol_admin;');
    print N'Permiso de ejecución sobre ' + @proc + N' aplicado.';
end
else
    print N'Aviso: el procedimiento sp_respaldo aún no existe. Vuelvan a ejecutar este script después de 06_backup_restore/backup_strategy.sql.';
go


/* ------------------------------------------------------------
   4. inicios de sesión
   las contraseñas vienen de la sección 0. check_expiration = off solo
   en las cuentas de servicio: si su contraseña vence se detienen el
   dashboard y los respaldos automáticos.
   lg_estudiante es compartida por el equipo (decisión del grupo; ver
   limitaciones en el informe).
   ------------------------------------------------------------ */
use master;
go

declare @p nvarchar(128) = cast(session_context(N'clave_personal') as nvarchar(128));
declare @s nvarchar(128) = cast(session_context(N'clave_servicio') as nvarchar(128));
declare @sql nvarchar(max) = N'';

select @sql += N'create login ' + quotename(nombre)
             + N' with password = ' + quotename(case when servicio = 1 then @s else @p end, '''')
             + N', check_policy = on, check_expiration = ' + case when servicio = 1 then N'off' else N'on' end
             + N';' + nchar(10)
from (values
    (N'lg_admin', 0),
    (N'lg_veterinario1', 0),
    (N'lg_veterinario2', 0),
    (N'lg_recepcion', 0),
    (N'lg_facturacion', 0),
    (N'lg_docente', 0),
    (N'lg_estudiante', 0),
    (N'lg_bi', 1),
    (N'lg_backup', 1)
) as l(nombre, servicio);

exec (@sql);
go

-- recomendación: deshabilitar sa cuando exista otra cuenta sysadmin.
-- alter login sa disable;
-- go


/* ------------------------------------------------------------
   5. usuarios y pertenencia a roles
   ------------------------------------------------------------ */
use migracion;
go

create user usr_admin        for login lg_admin;
create user usr_veterinario1 for login lg_veterinario1;
create user usr_veterinario2 for login lg_veterinario2;
create user usr_recepcion    for login lg_recepcion;
create user usr_facturacion  for login lg_facturacion;
create user usr_bi           for login lg_bi;
create user usr_backup       for login lg_backup;
create user usr_docente      for login lg_docente;
create user usr_estudiante   for login lg_estudiante;
go

alter role rol_admin       add member usr_admin;
alter role rol_veterinario add member usr_veterinario1;
alter role rol_veterinario add member usr_veterinario2;
alter role rol_recepcion   add member usr_recepcion;
alter role rol_facturacion add member usr_facturacion;
alter role rol_bi          add member usr_bi;
alter role rol_respaldo    add member usr_backup;
alter role rol_docente     add member usr_docente;
alter role rol_auditoria   add member usr_docente;   -- el docente también revisa la auditoría
alter role rol_estudiante  add member usr_estudiante;
go


/* ------------------------------------------------------------
   6. pruebas de permisos
   cada prueba se ejecuta como el usuario indicado y se revierte con
   rollback, así no cambia ningún dato. errores que cuentan como
   denegado: 229 (tabla o vista), 230 (columna), 262 (crear objetos)
   y 15247 (seguridad).
   ------------------------------------------------------------ */
set nocount on;

declare @pruebas table (
    id         int identity(1, 1),
    rol        sysname,
    usuario    sysname,
    operacion  nvarchar(100),
    sentencia  nvarchar(max),
    esperado   nvarchar(20)
);

insert into @pruebas (rol, usuario, operacion, sentencia, esperado) values
-- recepción
(N'rol_recepcion', N'usr_recepcion', N'insert en gestion.citas',
 N'insert into gestion.citas (id_mascota, id_veterinario, fecha_c, motivo_c, estado_c) values (1, 1, getdate(), ''prueba de permisos'', ''Programada'');', N'permitido'),
(N'rol_recepcion', N'usr_recepcion', N'delete en gestion.citas',
 N'delete from gestion.citas where id_cita = 1;', N'denegado'),
(N'rol_recepcion', N'usr_recepcion', N'select en reportes.vw_citas',
 N'declare @n int; select @n = count(*) from reportes.vw_citas;', N'permitido'),
(N'rol_recepcion', N'usr_recepcion', N'select de estado_f en finanzas.facturas',
 N'declare @x varchar(50); select top 1 @x = estado_f from finanzas.facturas;', N'permitido'),
(N'rol_recepcion', N'usr_recepcion', N'select de total_f en finanzas.facturas',
 N'declare @x numeric(10, 2); select top 1 @x = total_f from finanzas.facturas;', N'denegado'),
(N'rol_recepcion', N'usr_recepcion', N'select en clinica.diagnosticos',
 N'declare @n int; select @n = count(*) from clinica.diagnosticos;', N'denegado'),
-- veterinario
(N'rol_veterinario', N'usr_veterinario1', N'update en clinica.diagnosticos',
 N'update clinica.diagnosticos set fecha_d = fecha_d where id_diagnostico = 1;', N'permitido'),
(N'rol_veterinario', N'usr_veterinario1', N'select en reportes.vw_historial_clinico',
 N'declare @n int; select @n = count(*) from reportes.vw_historial_clinico;', N'permitido'),
(N'rol_veterinario', N'usr_veterinario1', N'update de estado_c en gestion.citas',
 N'update gestion.citas set estado_c = estado_c where id_cita = 1;', N'permitido'),
(N'rol_veterinario', N'usr_veterinario1', N'update de costo_c en gestion.citas',
 N'update gestion.citas set costo_c = costo_c where id_cita = 1;', N'denegado'),
(N'rol_veterinario', N'usr_veterinario1', N'update de peso_m en gestion.mascotas',
 N'update gestion.mascotas set peso_m = peso_m where id_mascota = 1;', N'permitido'),
(N'rol_veterinario', N'usr_veterinario1', N'insert en finanzas.facturas',
 N'insert into finanzas.facturas (id_cita, fecha_emision_f) values (11, getdate());', N'denegado'),
(N'rol_veterinario', N'usr_veterinario1', N'select en finanzas.facturas',
 N'declare @n int; select @n = count(*) from finanzas.facturas;', N'denegado'),
(N'rol_veterinario', N'usr_veterinario1', N'select de dui_p en gestion.propietarios',
 N'declare @x varchar(20); select top 1 @x = dui_p from gestion.propietarios;', N'denegado'),
(N'rol_veterinario', N'usr_veterinario2', N'select en clinica.diagnosticos (segundo usuario)',
 N'declare @n int; select @n = count(*) from clinica.diagnosticos;', N'permitido'),
-- facturación
(N'rol_facturacion', N'usr_facturacion', N'insert en finanzas.facturas',
 N'insert into finanzas.facturas (id_cita, fecha_emision_f, estado_f, total_f) values (11, getdate(), ''Pendiente'', 0);', N'permitido'),
(N'rol_facturacion', N'usr_facturacion', N'delete en finanzas.facturas',
 N'delete from finanzas.facturas where id_factura = 1;', N'denegado'),
(N'rol_facturacion', N'usr_facturacion', N'select en reportes.vw_facturacion',
 N'declare @n int; select @n = count(*) from reportes.vw_facturacion;', N'permitido'),
(N'rol_facturacion', N'usr_facturacion', N'select de costo_c en gestion.citas',
 N'declare @x numeric(10, 2); select top 1 @x = costo_c from gestion.citas;', N'permitido'),
(N'rol_facturacion', N'usr_facturacion', N'select de motivo_c en gestion.citas',
 N'declare @x varchar(max); select top 1 @x = cast(motivo_c as varchar(max)) from gestion.citas;', N'denegado'),
(N'rol_facturacion', N'usr_facturacion', N'update en clinica.diagnosticos',
 N'update clinica.diagnosticos set fecha_d = fecha_d where id_diagnostico = 1;', N'denegado'),
-- bi
(N'rol_bi', N'usr_bi', N'select en reportes.vw_resumen_financiero',
 N'declare @n int; select @n = count(*) from reportes.vw_resumen_financiero;', N'permitido'),
(N'rol_bi', N'usr_bi', N'select en reportes.vw_indicadores_mascotas',
 N'declare @n int; select @n = count(*) from reportes.vw_indicadores_mascotas;', N'permitido'),
(N'rol_bi', N'usr_bi', N'select en reportes.vw_propietarios',
 N'declare @n int; select @n = count(*) from reportes.vw_propietarios;', N'denegado'),
(N'rol_bi', N'usr_bi', N'select en gestion.propietarios (tabla base)',
 N'declare @n int; select @n = count(*) from gestion.propietarios;', N'denegado'),
(N'rol_bi', N'usr_bi', N'update en gestion.citas',
 N'update gestion.citas set estado_c = estado_c where id_cita = 1;', N'denegado'),
-- respaldo
(N'rol_respaldo', N'usr_backup', N'select en gestion.citas',
 N'declare @n int; select @n = count(*) from gestion.citas;', N'denegado'),
-- admin
(N'rol_admin', N'usr_admin', N'delete en finanzas.detalles_facturas',
 N'delete from finanzas.detalles_facturas where 1 = 0;', N'permitido'),
(N'rol_admin', N'usr_admin', N'select en reportes.vw_productividad_veterinaria',
 N'declare @n int; select @n = count(*) from reportes.vw_productividad_veterinaria;', N'permitido'),
-- docente
(N'rol_docente', N'usr_docente', N'select en finanzas.facturas',
 N'declare @n int; select @n = count(*) from finanzas.facturas;', N'permitido'),
(N'rol_docente', N'usr_docente', N'update en gestion.citas',
 N'update gestion.citas set estado_c = estado_c where id_cita = 1;', N'denegado'),
(N'rol_docente', N'usr_docente', N'create table',
 N'create table gestion.prueba_permisos (id int);', N'denegado'),
-- estudiante
(N'rol_estudiante', N'usr_estudiante', N'create table',
 N'create table gestion.prueba_permisos (id int);', N'permitido'),
(N'rol_estudiante', N'usr_estudiante', N'update en gestion.citas',
 N'update gestion.citas set estado_c = estado_c where id_cita = 1;', N'permitido'),
(N'rol_estudiante', N'usr_estudiante', N'create role (seguridad)',
 N'create role rol_prueba;', N'denegado');

-- pruebas sobre la auditoría (solo si la tabla ya existe)
declare @aud nvarchar(200) =
    case when object_id(N'seguridad.auditoria_log', N'U') is not null then N'seguridad.auditoria_log'
         when object_id(N'dbo.auditoria_log', N'U') is not null       then N'dbo.auditoria_log' end;

if @aud is not null
    insert into @pruebas (rol, usuario, operacion, sentencia, esperado) values
    (N'rol_admin', N'usr_admin', N'select en auditoria_log',
     N'declare @n int; select @n = count(*) from ' + @aud + N';', N'permitido'),
    (N'rol_admin', N'usr_admin', N'delete en auditoria_log',
     N'delete from ' + @aud + N' where 1 = 0;', N'denegado'),
    (N'rol_recepcion', N'usr_recepcion', N'select en auditoria_log',
     N'declare @n int; select @n = count(*) from ' + @aud + N';', N'denegado'),
    (N'rol_auditoria', N'usr_docente', N'select en auditoria_log',
     N'declare @n int; select @n = count(*) from ' + @aud + N';', N'permitido'),
    (N'rol_estudiante', N'usr_estudiante', N'delete en auditoria_log',
     N'delete from ' + @aud + N' where 1 = 0;', N'denegado');

declare @resultados table (
    id         int,
    rol        sysname,
    usuario    sysname,
    operacion  nvarchar(100),
    esperado   nvarchar(20),
    obtenido   nvarchar(300)
);

declare @id int = 1,
        @total int,
        @usuario sysname,
        @sentencia nvarchar(max),
        @obtenido nvarchar(300);

select @total = count(*) from @pruebas;

while @id <= @total
begin
    select @usuario = usuario, @sentencia = sentencia from @pruebas where id = @id;

    begin transaction;
    begin try
        execute as user = @usuario;
        exec sp_executesql @sentencia;
        revert;
        set @obtenido = N'permitido';
    end try
    begin catch
        if user_name() = @usuario revert;
        set @obtenido = case
                            when error_number() in (229, 230, 262, 15247) then N'denegado'
                            else N'error ' + cast(error_number() as nvarchar(10)) + N': ' + error_message()
                        end;
    end catch;
    if @@trancount > 0 rollback transaction;

    insert into @resultados (id, rol, usuario, operacion, esperado, obtenido)
    select id, rol, usuario, operacion, esperado, @obtenido from @pruebas where id = @id;

    set @id += 1;
end

select id, rol, usuario, operacion, esperado, obtenido,
       case when esperado = obtenido then N'OK' else N'REVISAR' end as estado
from @resultados
order by id;
go


/* ------------------------------------------------------------
   7. consultas de evidencia
   ------------------------------------------------------------ */

-- 7.1 usuarios y roles a los que pertenecen
select r.name as rol, m.name as miembro, m.type_desc as tipo
from sys.database_role_members as rm
join sys.database_principals as r on r.principal_id = rm.role_principal_id
join sys.database_principals as m on m.principal_id = rm.member_principal_id
where r.name like N'rol[_]%' or r.name = N'db_backupoperator'
order by rol, miembro;

-- 7.2 permisos de cada rol (deben coincidir con la matriz del informe)
select pr.name as rol,
       case p.class
            when 0 then N'(base de datos)'
            when 3 then N'esquema ' + schema_name(p.major_id)
            else object_schema_name(p.major_id) + N'.' + object_name(p.major_id)
       end as objeto,
       c.name as columna,
       p.state_desc as estado,
       p.permission_name as permiso
from sys.database_permissions as p
join sys.database_principals as pr on pr.principal_id = p.grantee_principal_id
left join sys.columns as c on p.class = 1 and c.object_id = p.major_id and c.column_id = p.minor_id
where pr.name like N'rol[_]%'
order by rol, objeto, columna, estado, permiso;

-- 7.3 inicios de sesión y política de contraseñas
select name as login, is_policy_checked, is_expiration_checked, is_disabled, create_date
from sys.sql_logins
where name like N'lg[_]%'
order by name;

-- 7.4 ningún login del proyecto pertenece a roles de servidor (debe salir vacío)
select r.name as rol_servidor, m.name as miembro
from sys.server_role_members as srm
join sys.server_principals as r on r.principal_id = srm.role_principal_id
join sys.server_principals as m on m.principal_id = srm.member_principal_id
where m.name like N'lg[_]%';
go

-- borrar las contraseñas de la sesión
exec sp_set_session_context N'clave_personal', null;
exec sp_set_session_context N'clave_servicio', null;
go

set noexec off;
go
