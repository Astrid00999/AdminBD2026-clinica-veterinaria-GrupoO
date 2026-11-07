-- ==========================================================
-- Configuración de Database Mail para Mailpit (Entorno Local)
-- ==========================================================

-- 1. Crear el Perfil de Correo por defecto si no existe
IF NOT EXISTS (SELECT * FROM msdb.dbo.sysmail_profile WHERE name = 'NotificacionesClinica')
BEGIN
    EXEC msdb.dbo.sysmail_add_profile_sp
        @profile_name = 'NotificacionesClinica',
        @description = 'Perfil para alertas y notificaciones del sistema';
END
GO

-- 2. Crear la Cuenta SMTP con el parámetro de descripción corregido
IF NOT EXISTS (SELECT * FROM msdb.dbo.sysmail_account WHERE name = 'DB_Administrador')
BEGIN
    EXEC msdb.dbo.sysmail_add_account_sp
        @account_name = 'DB_Administrador',
        @email_address = '00091525@uca.edu.sv',
        @display_name = 'Administrador del servidor',
        @mailserver_name = 'mailpit',
        @port = 1025,
        @enable_ssl = 0,
        @description = 'Mail account for admin emails', -- Corregido: de @account_description a @description
        @username = NULL, 
        @password = NULL;
END
GO

-- 3. Asociar la cuenta al perfil
IF NOT EXISTS (
    SELECT * FROM msdb.dbo.sysmail_profileaccount pa
    JOIN msdb.dbo.sysmail_profile p ON pa.profile_id = p.profile_id
    JOIN msdb.dbo.sysmail_account a ON pa.account_id = a.account_id
    WHERE p.name = 'NotificacionesClinica' AND a.name = 'DB_Administrador'
)
BEGIN
    EXEC msdb.dbo.sysmail_add_profileaccount_sp
        @profile_name = 'NotificacionesClinica',
        @account_name = 'DB_Administrador',
        @sequence_number = 1;
END
GO