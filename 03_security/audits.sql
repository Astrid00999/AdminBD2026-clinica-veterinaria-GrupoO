/* ============================================================
   AUDITORIAS

   ============================================================ */

   use master
   go 

create server audit Auditoria_Seguridad_ClinicaVet
to file (
    filepath = '/audit/',     
    maxsize = 20 MB,
    max_rollover_files = 50,
    reserve_disk_space = off
)
with (queue_delay = 1000, on_failure = continue);
go

create server audit Auditoria_Datos_ClinicaVet
to file (
    filepath = '/audit/',     
    maxsize = 50 MB,
    max_rollover_files = 40,
    reserve_disk_space = off
)
with (queue_delay = 1000, on_failure = continue);
go

alter server audit Auditoria_Seguridad_ClinicaVet with (state = on);
alter server audit Auditoria_Datos_ClinicaVet     with (state = on);
go


/* ------------------------------------------------------------
   2. Especificación a nivel de servidor
   ------------------------------------------------------------ */
create server audit specification AuditoriaServidor_Seguridad
for server audit Auditoria_Seguridad_ClinicaVet
    add (failed_login_group),                 
    add (login_change_password_group),        
    add (server_principal_change_group),      
    add (server_role_member_change_group),    
    add (server_permission_change_group),     
    add (database_change_group),              
    add (backup_restore_group),              
    add (audit_change_group)                  
with (state = on);
go


/* ------------------------------------------------------------
   3. Especificaciones a nivel de base de datos
   ------------------------------------------------------------ */
use ClinicaVeterinaria;
go

create database audit specification AuditoriaDB_Seguridad
for server audit Auditoria_Seguridad_ClinicaVet
    add (schema_object_change_group),             
    add (database_principal_change_group),        
    add (database_role_member_change_group),      
    add (database_permission_change_group),       
    add (schema_object_permission_change_group)  
with (state = on);
go


create database audit specification AuditoriaDB_Datos
for server audit Auditoria_Datos_ClinicaVet


    add (select, insert, update, delete on schema::finanzas by public),

   
    add (select, insert, update, delete on gestion.propietarios by public),
    add (insert, update, delete        on gestion.mascotas      by public),
    add (insert, update, delete        on gestion.citas         by public),

    add (select, insert, update, delete on clinica.diagnosticos          by public),
    add (insert, update, delete         on clinica.tratamiento           by public),
    add (insert, update, delete         on clinica.detalles_tratamientos by public),
    add (insert, update, delete         on clinica.procedimientos        by public),

    add (insert, update, delete on schema::catalogos by public)
with (state = on);
go




/* ------------------------------------------------------------
   4. Vista de consulta de la bitácora
   ------------------------------------------------------------ */
create or alter view seguridad.vw_bitacora_auditoria
as
select
    event_time,
    action_id,
    succeeded,
    server_principal_name  as login_usuario,
    database_principal_name as usuario_bd,
    database_name,
    schema_name,
    object_name,
    statement,
    client_ip,
    application_name,
    host_name
from sys.fn_get_audit_file('/var/opt/mssql/audit/*.sqlaudit', default, default);
-- Windows: 'D:\Audit\*.sqlaudit'
go


/* ------------------------------------------------------------
   5. Verificación
   ------------------------------------------------------------ */


select name, is_state_enabled from sys.server_audits
where name like N'Auditoria[_]%';

select name, is_state_enabled from sys.server_audit_specifications;
select name, is_state_enabled from sys.database_audit_specifications;


select
    s.name as especificacion,
    d.audit_action_name,
    class_desc,
    case d.class_desc
        when N'SCHEMA'        then schema_name(d.major_id)
        when N'OBJECT_OR_COLUMN' then object_schema_name(d.major_id) + N'.' + object_name(d.major_id)
    end as objetivo,
    user_name(d.audited_principal_id) as principal
from sys.database_audit_specifications as s
join sys.database_audit_specification_details as d
  on d.database_specification_id = s.database_specification_id
where s.name = N'AuditoriaDB_Datos'
order by objetivo, d.audit_action_name;


