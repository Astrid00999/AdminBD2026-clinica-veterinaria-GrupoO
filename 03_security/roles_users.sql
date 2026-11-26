/* ============================================================
   03_security/roles_users.sql

   Requisitos:
   - Ejecutar con una cuenta sysadmin.
   - Ejecutar al final, después de:
         02_ClinicaVeterinaria/schema_and_data.sql
         02_ClinicaVeterinaria/schemas_and_transfer.sql
         05_programmability/views.sql
         03_security/audits.sql y 06_backup_restore/backup_strategy.sql
       (si estos dos aún no existen, el script avisa y se puede repetir después)
   - Escribir las contraseñas en la sección 0 SOLO al ejecutar.
       No suban el archivo con contraseñas al repositorio.
   - Las contraseñas NO deben contener palabras del nombre del login
     (la política de Windows las rechaza: error 15118).

   Orden de este script:
   0. verificación y contraseñas
   1. limpieza (permite volver a ejecutarlo desde cero)
   2. roles
   3. permisos de cada rol (matriz)
   4. inicios de sesión y rol de servidor de auditoría
   5. usuarios y pertenencia a roles
   6. pruebas de permisos
   7. consultas de evidencia
   ============================================================ */


/* ------------------------------------------------------------
0. verificación y contraseñas
   ------------------------------------------------------------ */

if @@trancount > 0 rollback transaction;
if original_login() <> suser_sname() revert;
set noexec off;
go

use master;
go

declare @clave_personal nvarchar(128) = N'Cl#Seguro2026!k7x';   -- cuentas de personas
declare @clave_servicio nvarchar(128) = N'Sv#Servicio2026!m4Q'; -- cuentas de servicio

if db_id(N'ClinicaVeterinaria') is null
begin
    raiserror(N'La base ClinicaVeterinaria no existe. Ejecuten primero 02_ClinicaVeterinaria/schema_and_data.sql.', 16, 1);
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

use ClinicaVeterinaria;
go

if object_id(N'gestion.citas', N'U') is null or object_id(N'reportes.vw_citas', N'V') is null
begin
    raiserror(N'Primero ejecuten 02_ClinicaVeterinaria/schemas_and_transfer.sql y 05_programmability/views.sql.', 16, 1);
    set noexec on;
end
go


/* ------------------------------------------------------------
1. limpieza
   ------------------------------------------------------------ */
declare @sql nvarchar(max) = N'';

select @sql += N'drop user ' + quotename(name) + N';' + nchar(10)
from sys.database_principals
where type = 'S' and name like N'usr[_]%'
  and name <> N'usr_admin';

select @sql += N'drop role ' + quotename(name) + N';' + nchar(10)
from sys.database_principals
where type = 'R' and is_fixed_role = 0 and name like N'rol[_]%'
  and name <> N'rol_admin';

exec (@sql);
go

use master;
go

-- cerrar sesiones abiertas de los logins del proyecto (error 15434)
declare @kill nvarchar(max) = N'';

select @kill += N'kill ' + cast(session_id as nvarchar(10)) + N';'
from sys.dm_exec_sessions
where login_name like N'lg[_]%'
  and login_name <> N'lg_admin'
  and session_id <> @@spid;

exec (@kill);
go

declare @sql nvarchar(max) = N'';

select @sql += N'drop login ' + quotename(name) + N';' + nchar(10)
from sys.server_principals
where type = 'S' and name like N'lg[_]%'
  and name <> N'lg_admin';

if exists (select 1 from sys.server_principals where name = N'rol_srv_respaldo' and type = 'R')
    set @sql += N'drop server role rol_srv_respaldo;' + nchar(10);
if exists (select 1 from sys.server_principals where name = N'rol_srv_auditoria' and type = 'R')
    set @sql += N'drop server role rol_srv_auditoria;' + nchar(10);

exec (@sql);
go


/* ------------------------------------------------------------
2. roles de base de datos
   ------------------------------------------------------------ */
use ClinicaVeterinaria;
go

if database_principal_id(N'rol_admin') is null
    create role rol_admin authorization dbo;  -- administración técnica (no para uso diario)

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
   ------------------------------------------------------------ */

-- 3.1 rol_admin
grant select, insert, update, delete, view definition on schema::catalogos to rol_admin;
grant select, insert, update, delete, view definition on schema::gestion   to rol_admin;
grant select, insert, update, delete, view definition on schema::clinica   to rol_admin;
grant select, insert, update, delete, view definition on schema::finanzas  to rol_admin;
grant select, view definition on schema::reportes to rol_admin;
grant select, execute, view definition on schema::seguridad to rol_admin;

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

grant showplan, view database state to rol_admin;
alter role db_backupoperator add member rol_admin;
go

-- 3.2 rol_veterinario
grant select, insert, update on schema::clinica to rol_veterinario;

grant select on catalogos.especies       to rol_veterinario;
grant select on catalogos.razas          to rol_veterinario;
grant select on catalogos.especialidades to rol_veterinario;
grant select on catalogos.veterinario    to rol_veterinario;
grant select on catalogos.medicamentos   to rol_veterinario;

grant select on gestion.mascotas to rol_veterinario;
grant update (peso_m) on gestion.mascotas to rol_veterinario;
grant select on gestion.citas to rol_veterinario;
grant update (estado_c, motivo_c) on gestion.citas to rol_veterinario;

grant select on reportes.vw_propietarios      to rol_veterinario;
grant select on reportes.vw_mascotas          to rol_veterinario;
grant select on reportes.vw_citas             to rol_veterinario;
grant select on reportes.vw_historial_clinico to rol_veterinario;
go

-- 3.3 rol_recepcion
grant select, insert, update on schema::gestion to rol_recepcion;

grant select on catalogos.especies       to rol_recepcion;
grant select on catalogos.razas          to rol_recepcion;
grant select on catalogos.especialidades to rol_recepcion;
grant select on catalogos.veterinario    to rol_recepcion;

grant select (id_factura, id_cita, fecha_emision_f, estado_f) on finanzas.facturas to rol_recepcion;

grant select on reportes.vw_propietarios to rol_recepcion;
grant select on reportes.vw_mascotas     to rol_recepcion;
grant select on reportes.vw_citas        to rol_recepcion;
go

-- 3.4 rol_facturacion
grant select, insert, update on schema::finanzas to rol_facturacion;

grant select on catalogos.medicamentos to rol_facturacion;
grant select (id_cita, id_mascota, fecha_c, estado_c, costo_c) on gestion.citas to rol_facturacion;
grant select (id_procedimiento, nombre_p, costo_p) on clinica.procedimientos to rol_facturacion;

grant select on reportes.vw_facturacion         to rol_facturacion;
grant select on reportes.vw_detalle_facturacion to rol_facturacion;
grant select on reportes.vw_resumen_financiero  to rol_facturacion;
go

-- 3.5 rol_bi
grant select on reportes.vw_mascotas                  to rol_bi;
grant select on reportes.vw_citas                     to rol_bi;
grant select on reportes.vw_detalle_facturacion       to rol_bi;
grant select on reportes.vw_resumen_financiero        to rol_bi;
grant select on reportes.vw_productividad_veterinaria to rol_bi;
grant select on reportes.vw_indicadores_mascotas      to rol_bi;
grant select on reportes.vw_facturacion               to rol_bi;
go

-- 3.6 rol_respaldo (los procedimientos se otorgan solo si ya existen)
alter role db_backupoperator add member rol_respaldo;

declare @sql nvarchar(max) = N'';

select @sql += N'grant execute on ' + quotename(schema_name(schema_id)) + N'.' + quotename(name)
             + N' to rol_respaldo;' + nchar(10)
from sys.procedures
where schema_id = schema_id(N'dbo')
  and name in (N'usp_BackupFull', N'usp_BackupDif', N'usp_BackupLogSiToca');

if @sql = N''
    print N'Aviso: los procedimientos usp_Backup* aún no existen. Vuelvan a ejecutar este script después de 06_backup_restore/backup_strategy.sql.';
else
begin
    exec (@sql);
    print N'Permisos de ejecución sobre usp_Backup* aplicados.';
end
go

-- 3.7 rol_auditoria (el permiso de servidor va en rol_srv_auditoria, sección 4)
grant select on schema::seguridad to rol_auditoria;
go

-- 3.8 rol_docente
grant select, view definition on schema::catalogos to rol_docente;
grant select, view definition on schema::gestion   to rol_docente;
grant select, view definition on schema::clinica   to rol_docente;
grant select, view definition on schema::finanzas  to rol_docente;
grant select, view definition on schema::reportes  to rol_docente;
grant showplan, view database state to rol_docente;
go

-- 3.9 rol_estudiante
grant select, insert, update, delete, execute, alter, view definition on schema::catalogos to rol_estudiante;
grant select, insert, update, delete, execute, alter, view definition on schema::gestion   to rol_estudiante;
grant select, insert, update, delete, execute, alter, view definition on schema::clinica   to rol_estudiante;
grant select, insert, update, delete, execute, alter, view definition on schema::finanzas  to rol_estudiante;
grant select, execute, alter, view definition on schema::reportes  to rol_estudiante;
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
4. inicios de sesión y rol de servidor de auditoría
   cada login se crea por separado con try/catch: si uno falla,
   se imprime el error exacto y el script se detiene al final
   de esta sección en vez de fallar en cascada.
   check_expiration = off solo en cuentas de servicio.
   ------------------------------------------------------------ */
use master;
go

declare @p nvarchar(128) = cast(session_context(N'clave_personal') as nvarchar(128));
declare @s nvarchar(128) = cast(session_context(N'clave_servicio') as nvarchar(128));

declare @logins table (id int identity(1, 1), nombre sysname, servicio bit);
insert into @logins (nombre, servicio) values
    (N'lg_admin', 0),
    (N'lg_veterinario1', 0),
    (N'lg_veterinario2', 0),
    (N'lg_recepcion', 0),
    (N'lg_facturacion', 0),
    (N'lg_docente', 0),
    (N'lg_estudiante', 0),
    (N'lg_bi', 1),
    (N'lg_auditoria', 1),
    (N'lg_backup', 1);

declare @i int = 1,
        @n int = (select count(*) from @logins),
        @nombre sysname,
        @serv bit,
        @sql nvarchar(max);

while @i <= @n
begin
    select @nombre = nombre, @serv = servicio from @logins where id = @i;

    if not exists (select 1 from sys.server_principals where name = @nombre)
    begin
        begin try
            set @sql = N'create login ' + quotename(@nombre)
                     + N' with password = ' + quotename(case when @serv = 1 then @s else @p end, '''')
                     + N', check_policy = on, check_expiration = ' + case when @serv = 1 then N'off' else N'on' end + N';';
            exec (@sql);
            print N'Login creado: ' + @nombre;
        end try
        begin catch
            print N'ERROR creando ' + @nombre + N' (' + cast(error_number() as nvarchar(10)) + N'): ' + error_message();
        end catch
    end

    set @i += 1;
end

-- si falta algún login, detener el script aquí
declare @faltan nvarchar(max) = N'';
select @faltan += nombre + N' ' from @logins l
where not exists (select 1 from sys.server_principals sp where sp.name = l.nombre);

if @faltan <> N''
begin
    raiserror(N'No se crearon estos logins: %s. Revisen el mensaje ERROR de arriba (normalmente la contraseña no cumple la política).', 16, 1, @faltan);
    set noexec on;
end
go

-- lg_admin como administrador del servidor (alternativa a usar sa)
if is_srvrolemember(N'sysadmin', N'lg_admin') is null or is_srvrolemember(N'sysadmin', N'lg_admin') = 0
    alter server role [sysadmin] add member [lg_admin];
go

/* sa: este script no la habilita. Cuando comprueben que lg_admin entra bien,
   y desde una sesión que NO sea sa, pueden deshabilitarla:
   alter login [sa] disable;
*/

-- rol de servidor para auditoría (VIEW SERVER SECURITY AUDIT: SQL Server 2022+)
if cast(serverproperty(N'ProductMajorVersion') as int) >= 16
begin
    if not exists (select 1 from sys.server_principals where name = N'rol_srv_auditoria' and type = 'R')
        create server role rol_srv_auditoria;

    exec (N'grant view server security audit to rol_srv_auditoria;');

    if not exists (
        select 1
        from sys.server_role_members srm
        join sys.server_principals r on r.principal_id = srm.role_principal_id
        join sys.server_principals m on m.principal_id = srm.member_principal_id
        where r.name = N'rol_srv_auditoria' and m.name = N'lg_auditoria')
        alter server role rol_srv_auditoria add member lg_auditoria;

    print N'rol_srv_auditoria creado con VIEW SERVER SECURITY AUDIT.';
end
else
    print N'Aviso: VIEW SERVER SECURITY AUDIT requiere SQL Server 2022 o superior. Se omite el rol de servidor.';
go


/* ------------------------------------------------------------
5. usuarios y pertenencia a roles
   se crea cada usuario solo si no existe y se agrega a su rol.
   ------------------------------------------------------------ */
use ClinicaVeterinaria;
go

declare @m table (id int identity(1,1), usuario sysname, login sysname, rol sysname);
insert into @m (usuario, login, rol) values
    (N'usr_admin',        N'lg_admin',        N'rol_admin'),
    (N'usr_veterinario1', N'lg_veterinario1', N'rol_veterinario'),
    (N'usr_veterinario2', N'lg_veterinario2', N'rol_veterinario'),
    (N'usr_recepcion',    N'lg_recepcion',    N'rol_recepcion'),
    (N'usr_facturacion',  N'lg_facturacion',  N'rol_facturacion'),
    (N'usr_bi',           N'lg_bi',           N'rol_bi'),
    (N'usr_backup',       N'lg_backup',       N'rol_respaldo'),
    (N'usr_docente',      N'lg_docente',      N'rol_docente'),
    (N'usr_estudiante',   N'lg_estudiante',   N'rol_estudiante'),
    (N'usr_auditoria',    N'lg_auditoria',    N'rol_auditoria');

declare @i int = 1, @n int = (select count(*) from @m),
        @u sysname, @l sysname, @r sysname, @sql nvarchar(max);

while @i <= @n
begin
    select @u = usuario, @l = login, @r = rol from @m where id = @i;

    begin try
        if database_principal_id(@u) is null
        begin
            set @sql = N'create user ' + quotename(@u) + N' for login ' + quotename(@l) + N';';
            exec (@sql);
        end

        set @sql = N'alter role ' + quotename(@r) + N' add member ' + quotename(@u) + N';';
        exec (@sql);

        print N'OK: ' + @u + N' -> ' + @r;
    end try
    begin catch
        print N'ERROR con ' + @u + N' (' + cast(error_number() as nvarchar(10)) + N'): ' + error_message();
    end catch

    set @i += 1;
end
go
/* ------------------------------------------------------------
6. pruebas de permisos
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
    (N'rol_auditoria', N'usr_auditoria', N'select en auditoria_log',
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

    if database_principal_id(@usuario) is null
        set @obtenido = N'error: el usuario ' + @usuario + N' no existe (revisar secciones 4 y 5)';
    else
    begin
        begin transaction;
        begin try
            execute as user = @usuario;
            exec sp_executesql @sentencia;
            revert;
            set @obtenido = N'permitido';
        end try
        begin catch
            set @obtenido = case
                                when error_number() in (229, 230, 262, 15247) then N'denegado'
                                else N'error ' + cast(error_number() as nvarchar(10)) + N': ' + error_message()
                            end;
            if xact_state() <> 0 rollback transaction;
            if user_name() = @usuario revert;
        end catch;
        if @@trancount > 0 rollback transaction;
    end

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

-- 7.2 permisos de cada rol
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

-- 7.4 roles de servidor de los logins del proyecto
select r.name as rol_servidor, m.name as miembro
from sys.server_role_members as srm
join sys.server_principals as r on r.principal_id = srm.role_principal_id
join sys.server_principals as m on m.principal_id = srm.member_principal_id
where m.name like N'lg[_]%';

-- 7.5 permisos de nivel servidor del rol de auditoría
select pr.name as rol_servidor, pe.permission_name as permiso, pe.state_desc as estado
from sys.server_permissions as pe
join sys.server_principals as pr on pr.principal_id = pe.grantee_principal_id
where pr.name = N'rol_srv_auditoria';
go

-- borrar las contraseñas de la sesión
exec sp_set_session_context N'clave_personal', null;
exec sp_set_session_context N'clave_servicio', null;
go

set noexec off;
go
