/* ============================================================
   03_security/roles_users.sql
   Creación de logins, roles personalizados y asignación de permisos
   Proyecto: Clínica Veterinaria · Grupo O
   Responsable: Angel Monterrosa

   Requisitos:
     - Ejecutar con una cuenta sysadmin.
     - La base debe existir (02_migration/schema_and_data.sql).
     - Si la base se renombra (por ejemplo a clinica_veterinaria),
       reemplacen "migracion" en todo el archivo (Ctrl + H).

   Orden de este script (sección 2.4 de la guía):
     0. verificación de la base
     1. limpieza (permite volver a ejecutarlo desde cero)
     2. roles
     3. permisos de cada rol (matriz 2.3)
     4. inicios de sesión
     5. usuarios y pertenencia a roles
     6. pruebas de permisos (sección 2.5)
     7. consultas de evidencia

   Nota: los permisos sobre dbo.auditoria_log y dbo.sp_respaldo se
   aplican solo si esos objetos ya existen. Ejecuten este script
   después de 03_security/audits.sql y 06_backup_restore/backup_strategy.sql,
   o vuelvan a ejecutarlo al final.
   ============================================================ */


/* ------------------------------------------------------------
   0. verificación de la base
   ------------------------------------------------------------ */
use master;
go

if db_id(N'migracion') is null
begin
    raiserror(N'La base migracion no existe. Ejecuten primero 02_migration/schema_and_data.sql.', 16, 1);
    set noexec on;
end
go


/* ------------------------------------------------------------
   1. limpieza
   ------------------------------------------------------------ */
use migracion;
go

drop user if exists usr_admin;
drop user if exists usr_veterinario1;
drop user if exists usr_veterinario2;
drop user if exists usr_recepcion;
drop user if exists usr_facturacion;
drop user if exists usr_bi;
drop user if exists usr_backup;

drop role if exists rol_admin;
drop role if exists rol_veterinario;
drop role if exists rol_recepcion;
drop role if exists rol_facturacion;
drop role if exists rol_bi;
drop role if exists rol_respaldo;
go

use master;
go

if suser_id(N'lg_admin')         is not null drop login lg_admin;
if suser_id(N'lg_veterinario1')  is not null drop login lg_veterinario1;
if suser_id(N'lg_veterinario2')  is not null drop login lg_veterinario2;
if suser_id(N'lg_recepcion')     is not null drop login lg_recepcion;
if suser_id(N'lg_facturacion')   is not null drop login lg_facturacion;
if suser_id(N'lg_bi')            is not null drop login lg_bi;
if suser_id(N'lg_backup')        is not null drop login lg_backup;

if exists (select 1 from sys.server_principals where name = N'rol_srv_respaldo' and type = 'R')
    drop server role rol_srv_respaldo;
go


/* ------------------------------------------------------------
   2. roles de base de datos
   ------------------------------------------------------------ */
use migracion;
go

create role rol_admin;        -- administrador de la base (operación y mantenimiento)
create role rol_veterinario;  -- médico veterinario
create role rol_recepcion;    -- recepción: clientes, mascotas y agenda
create role rol_facturacion;  -- caja: facturas y sus detalles
create role rol_bi;           -- analista de datos / power bi (solo lectura)
create role rol_respaldo;     -- cuenta de servicio para respaldos automáticos
go


/* ------------------------------------------------------------
   3. permisos de cada rol
   C = insert, R = select, U = update, D = delete
   cada bloque corresponde a una fila de la matriz 2.3
   ------------------------------------------------------------ */

-- 3.1 rol_admin: crud sobre todo el esquema dbo
grant select, insert, update, delete, execute on schema::dbo to rol_admin;
grant view definition on schema::dbo to rol_admin;

-- mantenimiento de índices y estadísticas (alter por tabla, no sobre el esquema:
-- así puede reorganizar o reconstruir índices pero no borrar ni crear tablas)
grant alter on dbo.especies              to rol_admin;
grant alter on dbo.razas                 to rol_admin;
grant alter on dbo.especialidades        to rol_admin;
grant alter on dbo.veterinario           to rol_admin;
grant alter on dbo.propietarios          to rol_admin;
grant alter on dbo.mascotas              to rol_admin;
grant alter on dbo.citas                 to rol_admin;
grant alter on dbo.diagnosticos          to rol_admin;
grant alter on dbo.tratamiento           to rol_admin;
grant alter on dbo.detalles_tratamientos to rol_admin;
grant alter on dbo.procedimientos        to rol_admin;
grant alter on dbo.medicamentos          to rol_admin;
grant alter on dbo.facturas              to rol_admin;
grant alter on dbo.detalles_facturas     to rol_admin;

-- planes de ejecución, dmv de fragmentación y query store (sección 3)
grant showplan to rol_admin;
grant view database state to rol_admin;

-- respaldos manuales con dbo.sp_respaldo (sección 5.6)
alter role db_backupoperator add member rol_admin;
go

-- 3.2 catálogos: lectura para todos los roles de aplicación
grant select on dbo.especies       to rol_veterinario, rol_recepcion, rol_facturacion, rol_bi;
grant select on dbo.razas          to rol_veterinario, rol_recepcion, rol_facturacion, rol_bi;
grant select on dbo.especialidades to rol_veterinario, rol_recepcion, rol_facturacion, rol_bi;
grant select on dbo.veterinario    to rol_veterinario, rol_recepcion, rol_facturacion, rol_bi;
grant select on dbo.medicamentos   to rol_veterinario, rol_recepcion, rol_facturacion, rol_bi;
go

-- 3.3 propietarios
grant select, insert, update on dbo.propietarios to rol_recepcion;
grant select on dbo.propietarios to rol_veterinario, rol_facturacion, rol_bi;

-- bi no ve datos de identificación ni de contacto
deny select (dui_p, telefono_p, telefono_secundario_p, correo_p, direccion_p) on dbo.propietarios to rol_bi;
go

-- 3.4 mascotas
grant select, insert, update on dbo.mascotas to rol_recepcion;
grant select on dbo.mascotas to rol_veterinario, rol_facturacion, rol_bi;

-- el veterinario solo actualiza el peso (lo toma en cada consulta)
grant update (peso_m) on dbo.mascotas to rol_veterinario;
go

-- 3.5 citas
grant select, insert, update on dbo.citas to rol_recepcion;
grant select on dbo.citas to rol_veterinario, rol_facturacion, rol_bi;

-- el veterinario solo cambia el estado y el motivo; fecha, mascota y costo son de recepción
grant update (estado_c, motivo_c) on dbo.citas to rol_veterinario;
go

-- 3.6 información clínica: el veterinario la registra, los demás la consultan
grant select, insert, update on dbo.diagnosticos          to rol_veterinario;
grant select, insert, update on dbo.tratamiento           to rol_veterinario;
grant select, insert, update on dbo.detalles_tratamientos to rol_veterinario;
grant select, insert, update on dbo.procedimientos        to rol_veterinario;

grant select on dbo.diagnosticos          to rol_recepcion, rol_facturacion, rol_bi;
grant select on dbo.tratamiento           to rol_recepcion, rol_facturacion, rol_bi;
grant select on dbo.detalles_tratamientos to rol_recepcion, rol_facturacion, rol_bi;
grant select on dbo.procedimientos        to rol_recepcion, rol_facturacion, rol_bi;
go

-- 3.7 facturación: caja crea y actualiza, nadie más escribe
-- sin delete: una factura se anula (estado_f), no se borra
grant select, insert, update on dbo.facturas          to rol_facturacion;
grant select, insert, update on dbo.detalles_facturas to rol_facturacion;

grant select on dbo.facturas          to rol_veterinario, rol_recepcion, rol_bi;
grant select on dbo.detalles_facturas to rol_veterinario, rol_recepcion, rol_bi;
go

-- 3.8 rol_respaldo: solo puede respaldar, no lee ni modifica datos
alter role db_backupoperator add member rol_respaldo;
go

-- 3.9 objetos creados por otros scripts (se aplican solo si ya existen)
if object_id(N'dbo.auditoria_log', N'U') is not null
begin
    -- exec para que el script no falle si la tabla todavía no existe
    exec (N'deny insert, update, delete, alter on dbo.auditoria_log to rol_admin;
            deny select, insert, update, delete on dbo.auditoria_log
                to rol_veterinario, rol_recepcion, rol_facturacion, rol_bi, rol_respaldo;');
    print N'Permisos de dbo.auditoria_log aplicados.';
end
else
    print N'Aviso: dbo.auditoria_log aún no existe. Ejecuten de nuevo este script después de 03_security/audits.sql.';

if object_id(N'dbo.sp_respaldo', N'P') is not null
begin
    exec (N'grant execute on dbo.sp_respaldo to rol_respaldo;');
    print N'Permiso de ejecución sobre dbo.sp_respaldo aplicado.';
end
else
    print N'Aviso: dbo.sp_respaldo aún no existe. Ejecuten de nuevo este script después de 06_backup_restore/backup_strategy.sql.';
go


/* ------------------------------------------------------------
   4. inicios de sesión
   contraseñas de laboratorio: cámbienlas antes de cualquier uso real
   check_expiration = off solo en cuentas de servicio (power bi y respaldos),
   porque si la contraseña vence se detienen la actualización y los respaldos
   ------------------------------------------------------------ */
use master;
go

create login lg_admin        with password = N'Adm1n#Clinica2026', check_policy = on, check_expiration = on;
create login lg_veterinario1 with password = N'Vet1#Clinica2026',  check_policy = on, check_expiration = on;
create login lg_veterinario2 with password = N'Vet2#Clinica2026',  check_policy = on, check_expiration = on;
create login lg_recepcion    with password = N'Recep#Clinica2026', check_policy = on, check_expiration = on;
create login lg_facturacion  with password = N'Factu#Clinica2026', check_policy = on, check_expiration = on;
create login lg_bi           with password = N'Bi#Reportes2026',   check_policy = on, check_expiration = off;
create login lg_backup       with password = N'Resp#Clinica2026',  check_policy = on, check_expiration = off;
go

-- restore verifyonly (usado por dbo.sp_respaldo) exige permiso create database a nivel de servidor
create server role rol_srv_respaldo;
grant create any database to rol_srv_respaldo;
alter server role rol_srv_respaldo add member lg_admin;
alter server role rol_srv_respaldo add member lg_backup;
go

-- recomendación de la guía: deshabilitar sa.
-- háganlo solo cuando ya tengan otra cuenta sysadmin, o se quedan sin acceso.
-- alter login sa disable;
-- go


/* ------------------------------------------------------------
   5. usuarios y pertenencia a roles
   cada persona tiene su propio login: así la auditoría sabe quién hizo cada cambio
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
go

alter role rol_admin       add member usr_admin;
alter role rol_veterinario add member usr_veterinario1;
alter role rol_veterinario add member usr_veterinario2;
alter role rol_recepcion   add member usr_recepcion;
alter role rol_facturacion add member usr_facturacion;
alter role rol_bi          add member usr_bi;
alter role rol_respaldo    add member usr_backup;
go


/* ------------------------------------------------------------
   6. pruebas de permisos (sección 2.5)
   cada prueba se ejecuta como el usuario indicado y se revierte con rollback,
   así no cambia ningún dato. el error 229 (tabla) o 230 (columna) = denegado.
   el resultado final es una tabla para capturar como evidencia.
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
(N'rol_recepcion', N'usr_recepcion', N'insert en citas',
 N'insert into dbo.citas (id_mascota, id_veterinario, fecha_c, motivo_c, estado_c) values (1, 1, getdate(), ''prueba de permisos'', ''Programada'');',
 N'permitido'),
(N'rol_recepcion', N'usr_recepcion', N'delete en citas',
 N'delete from dbo.citas where id_cita = 1;', N'denegado'),
(N'rol_recepcion', N'usr_recepcion', N'update en diagnosticos',
 N'update dbo.diagnosticos set fecha_d = fecha_d where id_diagnostico = 1;', N'denegado'),
-- veterinario
(N'rol_veterinario', N'usr_veterinario1', N'update en diagnosticos',
 N'update dbo.diagnosticos set fecha_d = fecha_d where id_diagnostico = 1;', N'permitido'),
(N'rol_veterinario', N'usr_veterinario1', N'update de estado_c en citas',
 N'update dbo.citas set estado_c = estado_c where id_cita = 1;', N'permitido'),
(N'rol_veterinario', N'usr_veterinario1', N'update de costo_c en citas',
 N'update dbo.citas set costo_c = costo_c where id_cita = 1;', N'denegado'),
(N'rol_veterinario', N'usr_veterinario1', N'update de peso_m en mascotas',
 N'update dbo.mascotas set peso_m = peso_m where id_mascota = 1;', N'permitido'),
(N'rol_veterinario', N'usr_veterinario1', N'insert en facturas',
 N'insert into dbo.facturas (id_cita, fecha_emision_f) values (11, getdate());', N'denegado'),
(N'rol_veterinario', N'usr_veterinario2', N'select en diagnosticos (segundo usuario)',
 N'declare @n int; select @n = count(*) from dbo.diagnosticos;', N'permitido'),
-- facturación
(N'rol_facturacion', N'usr_facturacion', N'insert en facturas',
 N'insert into dbo.facturas (id_cita, fecha_emision_f, estado_f, total_f) values (11, getdate(), ''Pendiente'', 0);',
 N'permitido'),
(N'rol_facturacion', N'usr_facturacion', N'delete en facturas',
 N'delete from dbo.facturas where id_factura = 1;', N'denegado'),
(N'rol_facturacion', N'usr_facturacion', N'update en diagnosticos',
 N'update dbo.diagnosticos set fecha_d = fecha_d where id_diagnostico = 1;', N'denegado'),
-- bi
(N'rol_bi', N'usr_bi', N'select en facturas',
 N'declare @n int; select @n = count(*) from dbo.facturas;', N'permitido'),
(N'rol_bi', N'usr_bi', N'select de nombre_p en propietarios',
 N'declare @x varchar(100); select top 1 @x = nombre_p from dbo.propietarios;', N'permitido'),
(N'rol_bi', N'usr_bi', N'select de dui_p en propietarios',
 N'declare @x varchar(20); select top 1 @x = dui_p from dbo.propietarios;', N'denegado'),
(N'rol_bi', N'usr_bi', N'update en citas',
 N'update dbo.citas set estado_c = estado_c where id_cita = 1;', N'denegado'),
-- respaldo
(N'rol_respaldo', N'usr_backup', N'select en citas',
 N'declare @n int; select @n = count(*) from dbo.citas;', N'denegado'),
-- admin
(N'rol_admin', N'usr_admin', N'delete en detalles_facturas',
 N'delete from dbo.detalles_facturas where 1 = 0;', N'permitido');

-- pruebas sobre la tabla de auditoría (solo si ya existe)
if object_id(N'dbo.auditoria_log', N'U') is not null
    insert into @pruebas (rol, usuario, operacion, sentencia, esperado) values
    (N'rol_admin', N'usr_admin', N'select en auditoria_log',
     N'declare @n int; select @n = count(*) from dbo.auditoria_log;', N'permitido'),
    (N'rol_admin', N'usr_admin', N'delete en auditoria_log',
     N'delete from dbo.auditoria_log where 1 = 0;', N'denegado'),
    (N'rol_recepcion', N'usr_recepcion', N'select en auditoria_log',
     N'declare @n int; select @n = count(*) from dbo.auditoria_log;', N'denegado');

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
                            when error_number() in (229, 230) then N'denegado'
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
from sys.database_role_members rm
join sys.database_principals r on r.principal_id = rm.role_principal_id
join sys.database_principals m on m.principal_id = rm.member_principal_id
where r.name like N'rol[_]%' or r.name = N'db_backupoperator'
order by rol, miembro;

-- 7.2 permisos de cada rol (debe coincidir con la matriz 2.3)
select pr.name as rol,
       case p.class
            when 0 then N'(base de datos)'
            when 3 then N'esquema ' + schema_name(p.major_id)
            else object_name(p.major_id)
       end as objeto,
       c.name as columna,
       p.state_desc as estado,
       p.permission_name as permiso
from sys.database_permissions p
join sys.database_principals pr on pr.principal_id = p.grantee_principal_id
left join sys.columns c on p.class = 1 and c.object_id = p.major_id and c.column_id = p.minor_id
where pr.name like N'rol[_]%'
order by rol, objeto, columna, estado, permiso;

-- 7.3 inicios de sesión y política de contraseñas
select name as login, is_policy_checked, is_expiration_checked, is_disabled, create_date
from sys.sql_logins
where name like N'lg[_]%'
order by name;

-- 7.4 miembros del rol de servidor para respaldos
select r.name as rol_servidor, m.name as miembro
from sys.server_role_members rm
join sys.server_principals r on r.principal_id = rm.role_principal_id
join sys.server_principals m on m.principal_id = rm.member_principal_id
where r.name = N'rol_srv_respaldo';
go

set noexec off;
go
