
/* =====================================================================
     ESTRATEGIAS DE BACKUPS
   ===================================================================== */


USE master;
GO
alter database ClinicaVeterinaria set recovery full;
GO

/* ---------------------------------------------------------------------
   1. OPERADOR PARA LOS AVISOS DE FALLOS.
   --------------------------------------------------------------------- */
IF NOT EXISTS (SELECT 1 FROM msdb.dbo.sysoperators WHERE name = N'Operador_Fallos')
    EXEC msdb.dbo.sp_add_operator @name = N'Operador_Fallos', @enabled = 1,
         @email_address = N'00091525@uca.edu.sv';
ELSE
    EXEC msdb.dbo.sp_update_operator @name = N'Operador_Fallos', @enabled = 1,
         @email_address = N'00091525@uca.edu.sv';
GO


/* ---------------------------------------------------------------------
   2. CONFIGURACION Y HORARIO DE LOGS 
   --------------------------------------------------------------------- */
USE ClinicaVeterinaria;
GO

IF OBJECT_ID('dbo.BackupConfig') IS NOT NULL DROP TABLE dbo.BackupConfig;
CREATE TABLE dbo.BackupConfig (
    Id             int           NOT NULL PRIMARY KEY CHECK (Id = 1),
    Base           sysname       NOT NULL,
    Ruta           nvarchar(260) NOT NULL,
    Sep            nchar(1)      NOT NULL,   -- separador de carpetas: \ en Windows, / en Linux/Docker
    CorreoResumen  nvarchar(256) NOT NULL,
    PerfilMail     sysname       NOT NULL
);
GO

/* RUTA DE BACKUPS  */
INSERT dbo.BackupConfig (Id, Base, Ruta, Sep, CorreoResumen, PerfilMail)
SELECT 1, N'ClinicaVeterinaria',
       CASE WHEN EXISTS (SELECT 1 FROM sys.dm_os_host_info WHERE host_platform = N'Linux')
            THEN N'/var/opt/mssql/backup' ELSE N'C:\Backups' END,
       CASE WHEN EXISTS (SELECT 1 FROM sys.dm_os_host_info WHERE host_platform = N'Linux')
            THEN N'/' ELSE N'\' END,
       N'00091525@uca.edu.sv', N'NotificacionesClinica';
GO

-- Full, Diff, Log
DECLARE @R nvarchar(260), @S nchar(1), @d nvarchar(300);
SELECT @R = Ruta, @S = Sep FROM dbo.BackupConfig;
SET @d = @R;                  EXEC master.dbo.xp_create_subdir @d;
SET @d = @R + @S + N'Full';   EXEC master.dbo.xp_create_subdir @d;
SET @d = @R + @S + N'Dif';    EXEC master.dbo.xp_create_subdir @d;
SET @d = @R + @S + N'Log';    EXEC master.dbo.xp_create_subdir @d;
GO

/* Horario de logs: Dia: 0 = lunes, 1 = martes, ... 5 = sabado, 6 = domingo. */
IF OBJECT_ID('dbo.BackupHorarioLog') IS NOT NULL DROP TABLE dbo.BackupHorarioLog;
CREATE TABLE dbo.BackupHorarioLog (
    Temporada varchar(10) NOT NULL,
    Dia       tinyint     NOT NULL,
    Hora      time(0)     NOT NULL,
    PRIMARY KEY (Temporada, Dia, Hora)
);
GO

DECLARE @P TABLE (Temporada varchar(10), DiaIni tinyint, DiaFin tinyint, Horas varchar(400));
INSERT @P (Temporada, DiaIni, DiaFin, Horas) VALUES
 -- ALTA: cada 30 min en horas fuertes (el lunes desde las 7:00)
 ('alta',   0, 0, '07:00,07:30,08:00,08:30,09:00,09:30,10:00,10:30,11:00,11:30,12:00,12:30,13:00,14:00,15:00,16:00,17:00,18:00,20:00'),
 ('alta',   1, 4, '07:00,08:00,09:00,10:00,10:30,11:00,11:30,12:00,12:30,13:00,14:00,15:00,16:00,17:00,18:00,20:00'),
 ('alta',   5, 5, '07:00,08:00,09:00,10:00,10:30,11:00,11:30,12:00,12:30,13:00,15:00,17:00,20:00'),
 ('alta',   6, 6, '07:00,08:00,09:00,10:00,11:00,12:00,13:00'),
 -- NORMAL: cada hora en horas fuertes
 ('normal', 0, 0, '07:00,08:00,09:00,10:00,11:00,12:00,13:00,14:00,15:00,17:00,20:00'),
 ('normal', 1, 4, '07:00,08:00,09:00,10:00,11:00,12:00,13:00,15:00,17:00,20:00'),
 ('normal', 5, 5, '07:00,08:00,09:00,10:00,11:00,12:00,13:00,15:00,20:00'),
 ('normal', 6, 6, '07:00,09:00,11:00,13:00'),
 -- BAJA: cada 2 horas
 ('baja',   0, 4, '07:00,09:00,11:00,13:00,15:00,17:00,20:00'),
 ('baja',   5, 5, '07:00,09:00,11:00,13:00,20:00'),
 ('baja',   6, 6, '07:00,11:00,13:00');

INSERT dbo.BackupHorarioLog (Temporada, Dia, Hora)
SELECT p.Temporada, d.n, CAST(LTRIM(RTRIM(s.value)) AS time(0))
FROM @P AS p
CROSS APPLY STRING_SPLIT(p.Horas, ',') AS s
JOIN (VALUES (0),(1),(2),(3),(4),(5),(6)) AS d(n) ON d.n BETWEEN p.DiaIni AND p.DiaFin;
GO


/* ---------------------------------------------------------------------
   5. PROCEDIMIENTOS
   --------------------------------------------------------------------- */

-- 5.1 Backup completo (Full)
CREATE OR ALTER PROCEDURE dbo.usp_BackupFull
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Base sysname, @Ruta nvarchar(260), @Sep nchar(1), @Archivo nvarchar(400);
    SELECT @Base = Base, @Ruta = Ruta, @Sep = Sep FROM dbo.BackupConfig;
    SET @Archivo = @Ruta + @Sep + N'Full' + @Sep + REPLACE(@Base, N' ', N'_') + N'_FULL_' + FORMAT(GETDATE(), 'yyyyMMdd_HHmm') + N'.bak';

    BACKUP DATABASE @Base TO DISK = @Archivo WITH CHECKSUM, INIT;
    RESTORE VERIFYONLY FROM DISK = @Archivo WITH CHECKSUM;
END;
GO

-- 5.2 Backup diferencial (Dif)
CREATE OR ALTER PROCEDURE dbo.usp_BackupDif
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Base sysname, @Ruta nvarchar(260), @Sep nchar(1), @Archivo nvarchar(400);
    SELECT @Base = Base, @Ruta = Ruta, @Sep = Sep FROM dbo.BackupConfig;
    SET @Archivo = @Ruta + @Sep + N'Dif' + @Sep + REPLACE(@Base, N' ', N'_') + N'_DIF_' + FORMAT(GETDATE(), 'yyyyMMdd_HHmm') + N'.bak';

    BACKUP DATABASE @Base TO DISK = @Archivo WITH DIFFERENTIAL, CHECKSUM, INIT;
    RESTORE VERIFYONLY FROM DISK = @Archivo WITH CHECKSUM;
END;
GO

-- 5.3 Backup de log.

CREATE OR ALTER PROCEDURE dbo.usp_BackupLogSiToca
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Base sysname, @Ruta nvarchar(260), @Sep nchar(1), @Archivo nvarchar(400);
    SELECT @Base = Base, @Ruta = Ruta, @Sep = Sep FROM dbo.BackupConfig;

    DECLARE @ahora datetime = GETDATE();
    DECLARE @mes int = MONTH(@ahora);
    DECLARE @temp varchar(10) =
        CASE WHEN @mes IN (6, 7, 8, 12) THEN 'alta'
             WHEN @mes IN (2, 4)        THEN 'baja'
             ELSE 'normal' END;
    DECLARE @dia tinyint = DATEDIFF(day, '19000101', @ahora) % 7;   -- 0 = lunes ... 6 = domingo
    DECLARE @hora time(0) =
        CAST(DATEADD(minute, (DATEDIFF(minute, '19000101', @ahora) / 30) * 30, '19000101') AS time(0));

    IF NOT EXISTS (SELECT 1 FROM dbo.BackupHorarioLog
                   WHERE Temporada = @temp AND Dia = @dia AND Hora = @hora)
        RETURN;   -- no toca log a esta hora

    SET @Archivo = @Ruta + @Sep + N'Log' + @Sep + REPLACE(@Base, N' ', N'_') + N'_LOG_' + FORMAT(@ahora, 'yyyyMMdd_HHmm') + N'.trn';
    BACKUP LOG @Base TO DISK = @Archivo WITH CHECKSUM, INIT;
END;
GO

-- 5.4 Limpieza de backups viejos
--     Full 28 dias (4 semanas), Dif 14 dias, Log 7 dias.

CREATE OR ALTER PROCEDURE dbo.usp_BackupLimpieza
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Base sysname, @Ruta nvarchar(260), @Sep nchar(1);
    SELECT @Base = Base, @Ruta = Ruta, @Sep = Sep FROM dbo.BackupConfig;

    IF NOT EXISTS (SELECT 1 FROM msdb.dbo.backupset
                   WHERE database_name = @Base AND type = 'D'
                     AND backup_finish_date >= DATEADD(day, -8, GETDATE()))
    BEGIN
        RAISERROR('No hay un backup completo reciente. No se borro nada.', 16, 1);
        RETURN;
    END;

    DECLARE @cFull datetime = DATEADD(day, -28, GETDATE());
    DECLARE @cDif  datetime = DATEADD(day, -14, GETDATE());
    DECLARE @cLog  datetime = DATEADD(day,  -7, GETDATE());
    DECLARE @cHist datetime = DATEADD(day, -60, GETDATE());
    DECLARE @pFull nvarchar(300) = @Ruta + @Sep + N'Full';
    DECLARE @pDif  nvarchar(300) = @Ruta + @Sep + N'Dif';
    DECLARE @pLog  nvarchar(300) = @Ruta + @Sep + N'Log';

    EXEC master.dbo.xp_delete_file 0, @pFull, N'bak', @cFull, 0;
    EXEC master.dbo.xp_delete_file 0, @pDif,  N'bak', @cDif,  0;
    EXEC master.dbo.xp_delete_file 0, @pLog,  N'trn', @cLog,  0;
    EXEC msdb.dbo.sp_delete_backuphistory @oldest_date = @cHist;
END;
GO

-- 5.5 Revision diaria: manda un correo con el resumen.

CREATE OR ALTER PROCEDURE dbo.usp_BackupRevision
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Base sysname, @Correo nvarchar(256), @Perfil sysname;
    SELECT @Base = Base, @Correo = CorreoResumen, @Perfil = PerfilMail FROM dbo.BackupConfig;

    DECLARE @uFull datetime, @uDif datetime, @uLog datetime;
    SELECT @uFull = MAX(CASE WHEN type = 'D' THEN backup_finish_date END),
           @uDif  = MAX(CASE WHEN type = 'I' THEN backup_finish_date END),
           @uLog  = MAX(CASE WHEN type = 'L' THEN backup_finish_date END)
    FROM msdb.dbo.backupset
    WHERE database_name = @Base;

    DECLARE @nl nvarchar(2) = CHAR(13) + CHAR(10);
    DECLARE @prob nvarchar(max) = N'';

    IF @uFull IS NULL OR @uFull < DATEADD(day, -8, GETDATE())
        SET @prob += N'- Falta un backup completo reciente (maximo 8 dias).' + @nl;
    IF @uDif IS NULL OR @uDif < DATEADD(hour, -36, GETDATE())
        SET @prob += N'- Falta el diferencial de anoche.' + @nl;
    IF @uLog IS NULL OR @uLog < DATEADD(hour, -3, GETDATE())
        SET @prob += N'- No hay un backup de log en las ultimas 3 horas.' + @nl;
    IF (SELECT recovery_model_desc FROM sys.databases WHERE name = @Base) <> 'FULL'
        SET @prob += N'- La base no esta en modelo de recuperacion FULL.' + @nl;

    DECLARE @asunto nvarchar(200) =
        CASE WHEN @prob = N'' THEN N'OK - Backups de ' ELSE N'REVISAR - Backups de ' END + @Base;
    DECLARE @cuerpo nvarchar(max) =
        N'Ultimo completo:    ' + ISNULL(CONVERT(nvarchar(16), @uFull, 120), N'NINGUNO') + @nl +
        N'Ultimo diferencial: ' + ISNULL(CONVERT(nvarchar(16), @uDif,  120), N'NINGUNO') + @nl +
        N'Ultimo log:         ' + ISNULL(CONVERT(nvarchar(16), @uLog,  120), N'NINGUNO') + @nl + @nl +
        CASE WHEN @prob = N'' THEN N'Todo en orden.' ELSE N'Problemas:' + @nl + @prob END;

    EXEC msdb.dbo.sp_send_dbmail
         @profile_name = @Perfil, @recipients = @Correo,
         @subject = @asunto, @body = @cuerpo;
END;
GO


/* ---------------------------------------------------------------------
   6. JOBS DE SQL SERVER AGENT

   --------------------------------------------------------------------- */
USE msdb;
GO

-- 6.1 Full: domingo 02:00
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'Backup_Full') EXEC msdb.dbo.sp_delete_job @job_name = N'Backup_Full';
EXEC msdb.dbo.sp_add_job @job_name = N'Backup_Full', @enabled = 1,
     @notify_level_email = 2, @notify_email_operator_name = N'Operador_Fallos',
     @description = N'Backup completo semanal';
EXEC msdb.dbo.sp_add_jobstep @job_name = N'Backup_Full', @step_name = N'Backup completo',
     @subsystem = N'TSQL', @database_name = N'ClinicaVeterinaria',
     @command = N'EXEC dbo.usp_BackupFull;', @on_success_action = 1, @on_fail_action = 2;
EXEC msdb.dbo.sp_add_jobschedule @job_name = N'Backup_Full', @name = N'Domingo 02:00',
     @freq_type = 8, @freq_interval = 1, @freq_recurrence_factor = 1, @active_start_time = 20000;
EXEC msdb.dbo.sp_add_jobserver @job_name = N'Backup_Full', @server_name = N'(LOCAL)';
GO

-- 6.2 Dif: todos los dias 23:00
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'Backup_Dif') EXEC msdb.dbo.sp_delete_job @job_name = N'Backup_Dif';
EXEC msdb.dbo.sp_add_job @job_name = N'Backup_Dif', @enabled = 1,
     @notify_level_email = 2, @notify_email_operator_name = N'Operador_Fallos',
     @description = N'Backup diferencial diario';
EXEC msdb.dbo.sp_add_jobstep @job_name = N'Backup_Dif', @step_name = N'Backup diferencial',
     @subsystem = N'TSQL', @database_name = N'ClinicaVeterinaria',
     @command = N'EXEC dbo.usp_BackupDif;', @on_success_action = 1, @on_fail_action = 2;
EXEC msdb.dbo.sp_add_jobschedule @job_name = N'Backup_Dif', @name = N'Diario 23:00',
     @freq_type = 4, @freq_interval = 1, @active_start_time = 230000;
EXEC msdb.dbo.sp_add_jobserver @job_name = N'Backup_Dif', @server_name = N'(LOCAL)';
GO

-- 6.3 Log: cada 30 min de 07:00 a 20:00 (el procedimiento decide si toca)
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'Backup_Log') EXEC msdb.dbo.sp_delete_job @job_name = N'Backup_Log';
EXEC msdb.dbo.sp_add_job @job_name = N'Backup_Log', @enabled = 1,
     @notify_level_email = 2, @notify_email_operator_name = N'Operador_Fallos',
     @description = N'Backup de log segun temporada, dia y hora';
EXEC msdb.dbo.sp_add_jobstep @job_name = N'Backup_Log', @step_name = N'Backup de log si toca',
     @subsystem = N'TSQL', @database_name = N'ClinicaVeterinaria',
     @command = N'EXEC dbo.usp_BackupLogSiToca;', @on_success_action = 1, @on_fail_action = 2;
EXEC msdb.dbo.sp_add_jobschedule @job_name = N'Backup_Log', @name = N'Cada 30 min 07:00-20:00',
     @freq_type = 4, @freq_interval = 1, @freq_subday_type = 4, @freq_subday_interval = 30,
     @active_start_time = 70000, @active_end_time = 200000;
EXEC msdb.dbo.sp_add_jobserver @job_name = N'Backup_Log', @server_name = N'(LOCAL)';
GO

-- 6.4 Limpieza: domingo 04:00
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'Backup_Limpieza') EXEC msdb.dbo.sp_delete_job @job_name = N'Backup_Limpieza';
EXEC msdb.dbo.sp_add_job @job_name = N'Backup_Limpieza', @enabled = 1,
     @notify_level_email = 2, @notify_email_operator_name = N'Operador_Fallos',
     @description = N'Elimina backups viejos';
EXEC msdb.dbo.sp_add_jobstep @job_name = N'Backup_Limpieza', @step_name = N'Limpieza',
     @subsystem = N'TSQL', @database_name = N'ClinicaVeterinaria',
     @command = N'EXEC dbo.usp_BackupLimpieza;', @on_success_action = 1, @on_fail_action = 2;
EXEC msdb.dbo.sp_add_jobschedule @job_name = N'Backup_Limpieza', @name = N'Domingo 04:00',
     @freq_type = 8, @freq_interval = 1, @freq_recurrence_factor = 1, @active_start_time = 40000;
EXEC msdb.dbo.sp_add_jobserver @job_name = N'Backup_Limpieza', @server_name = N'(LOCAL)';
GO

-- 6.5 Revision diaria: todos los dias 08:00 (resumen al correo)
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = N'Backup_Revision') EXEC msdb.dbo.sp_delete_job @job_name = N'Backup_Revision';
EXEC msdb.dbo.sp_add_job @job_name = N'Backup_Revision', @enabled = 1,
     @notify_level_email = 2, @notify_email_operator_name = N'Operador_Fallos',
     @description = N'Correo diario con el resumen de backups';
EXEC msdb.dbo.sp_add_jobstep @job_name = N'Backup_Revision', @step_name = N'Revision',
     @subsystem = N'TSQL', @database_name = N'ClinicaVeterinaria',
     @command = N'EXEC dbo.usp_BackupRevision;', @on_success_action = 1, @on_fail_action = 2;
EXEC msdb.dbo.sp_add_jobschedule @job_name = N'Backup_Revision', @name = N'Diario 08:00',
     @freq_type = 4, @freq_interval = 1, @active_start_time = 80000;
EXEC msdb.dbo.sp_add_jobserver @job_name = N'Backup_Revision', @server_name = N'(LOCAL)';
GO

