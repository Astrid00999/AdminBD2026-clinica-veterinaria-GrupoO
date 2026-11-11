-- =========================================================================
-- PLAN DE RESTAURACIÓN Y RECUPERACIÓN ANTE DESASTRES
-- Base de datos: ClinicaVeterinaria
-- =========================================================================

USE master;
GO

-- 1. Aislar la base de datos para cortar conexiones activas y evitar bloqueos
IF EXISTS (SELECT [name] FROM sys.databases WHERE [name] = N'ClinicaVeterinaria')
BEGIN
    ALTER DATABASE [ClinicaVeterinaria] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
END
GO

-- 2. RESTAURAR EL RESPALDO COMPLETO (FULL)

RESTORE DATABASE [ClinicaVeterinaria]
FROM DISK = N'C:\Backups\Full\ClinicaVeterinaria_FULL.bak' 
WITH 
    REPLACE,
    NORECOVERY;
GO

-- 3. RESTAURAR EL RESPALDO DIFERENCIAL (DIFF) MÁS RECIENTE

RESTORE DATABASE [ClinicaVeterinaria]
FROM DISK = N'C:\Backups\Dif\ClinicaVeterinaria_DIF.bak' 
WITH 
    NORECOVERY;
GO

-- 4. RESTAURAR LOS LOGS DE TRANSACCIONES (.trn) EN ORDEN CRONOLÓGICO
-- Aplicar cada archivo de log generado después del diferencial. 
RESTORE LOG [ClinicaVeterinaria]
FROM DISK = N'C:\Backups\Log\ClinicaVeterinaria_LOG.trn' -- <--- Primer archivo .trn
WITH 
    NORECOVERY;
GO

-- si hay mas archivos log se ejecuta la misma sentencia con norecovery

-- 5. EL ÚLTIMO PASO: ABRIR LA BASE DE DATOS
-- El último archivo de log (o el diferencial/full si no se usa logs) se aplica con RECOVERY 
-- para poner la base de datos en línea y lista para operar.
RESTORE LOG [ClinicaVeterinaria]
FROM DISK = N'C:\Backups\Log\ClinicaVeterinaria_LOG.trn' -- <--- El archivo .trn más reciente
WITH 
    RECOVERY;
GO

-- 6. Devolver la base de datos a acceso multiusuario estándar
ALTER DATABASE [ClinicaVeterinaria] SET MULTI_USER;
GO