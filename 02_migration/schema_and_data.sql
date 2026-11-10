/* ============================================================
   02_migration/schema_and_data.sql

   Crea la base ClinicaVeterinaria (tablas, llaves e índices) y la llena con:
     1. datos base escritos a mano (catálogos y casos de ejemplo)
     2. carga masiva que sigue el plan de consultas de la clínica:
        consultas por mes, día y hora, y enfermedades por mes
     3. verificación contra el documento

   Ejecutar con una cuenta sysadmin, antes de
   02_migration/schemas_and_transfer.sql.
   ============================================================ */
USE [master]
GO
IF DB_ID(N'ClinicaVeterinaria') IS NOT NULL
BEGIN
    ALTER DATABASE [ClinicaVeterinaria] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [ClinicaVeterinaria];
END
GO
/****** Objeto: Database [ClinicaVeterinaria] Fecha de script: 31/10/2026 16:31:23 ******/
CREATE DATABASE [ClinicaVeterinaria]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ClinicaVeterinaria', FILENAME = N'/var/opt/mssql/data/ClinicaVeterinaria.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'ClinicaVeterinaria_log', FILENAME = N'/var/opt/mssql/data/ClinicaVeterinaria_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [ClinicaVeterinaria] SET COMPATIBILITY_LEVEL = 170
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ClinicaVeterinaria].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ClinicaVeterinaria] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET ARITHABORT OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ClinicaVeterinaria] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ClinicaVeterinaria] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ClinicaVeterinaria] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ClinicaVeterinaria] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ClinicaVeterinaria] SET  MULTI_USER 
GO
ALTER DATABASE [ClinicaVeterinaria] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ClinicaVeterinaria] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ClinicaVeterinaria] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ClinicaVeterinaria] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ClinicaVeterinaria] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [ClinicaVeterinaria] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'ClinicaVeterinaria', N'ON'
GO
ALTER DATABASE [ClinicaVeterinaria] SET QUERY_STORE = ON
GO
ALTER DATABASE [ClinicaVeterinaria] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [ClinicaVeterinaria]
GO
/****** Objeto: Table [dbo].[citas] Fecha de script: 31/10/2026 16:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[citas](
	[id_cita] [bigint] IDENTITY(1,1) NOT NULL,
	[id_mascota] [bigint] NOT NULL,
	[id_veterinario] [bigint] NOT NULL,
	[fecha_c] [datetime] NOT NULL,
	[motivo_c] [varchar](100) NULL,	
    [estado_c] [varchar](20) NOT NULL,
	[costo_c] [numeric](10, 2) NULL,
 CONSTRAINT [citas_pkey] PRIMARY KEY CLUSTERED 
(
	[id_cita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[detalles_facturas] Fecha de script: 31/10/2026 16:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[detalles_facturas](
	[id_detalle_factura] [bigint] NOT NULL,
	[id_factura] [bigint] NOT NULL,
	[id_cita] [bigint] NULL,
	[id_medicamento] [bigint] NULL,
	[id_tratamiento] [bigint] NULL,
	[id_procedimiento] [bigint] NULL,
	[descripcion_df] [text] NOT NULL,
	[cantidad_df] [bigint] NOT NULL,
	[precio_unit_df] [numeric](10, 2) NOT NULL,
	[subtotal_df]  AS (CAST([cantidad_df] * [precio_unit_df] AS numeric(10, 2))) PERSISTED,
 CONSTRAINT [detalles_facturas_pkey] PRIMARY KEY CLUSTERED 
(
	[id_factura] ASC,
	[id_detalle_factura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[detalles_tratamientos] Fecha de script: 31/10/2026 16:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[detalles_tratamientos](
	[id_detalle_tratamiento] [bigint] NOT NULL,
	[id_tratamiento] [bigint] NOT NULL,
	[id_medicamento] [bigint] NOT NULL,
	[dosis_dt] [varchar](100) NULL,
	[frecuencia_dt] [varchar](100) NULL,
	[duracion_dias_dt] [int] NULL,
 CONSTRAINT [detalles_tratamientos_pkey] PRIMARY KEY CLUSTERED 
(
	[id_tratamiento] ASC,
	[id_detalle_tratamiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[diagnosticos] Fecha de script: 31/10/2026 16:31:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[diagnosticos](
	[id_diagnostico] [bigint] IDENTITY(1,1) NOT NULL,
	[id_cita] [bigint] NOT NULL,
	[descripcion_d] [text] NOT NULL,
	[observaciones_d] [text] NULL,
	[fecha_d] [date] NULL,
 CONSTRAINT [diagnosticos_pkey] PRIMARY KEY CLUSTERED 
(
	[id_diagnostico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[especialidades] Fecha de script: 31/10/2026 16:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[especialidades](
	[id_especialidad] [bigint] IDENTITY(1,1) NOT NULL,
	[nombre_esp] [varchar](150) NOT NULL,
	[descripcion_esp] [text] NULL,
 CONSTRAINT [especialidades_pkey] PRIMARY KEY CLUSTERED 
(
	[id_especialidad] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[especies] Fecha de script: 31/10/2026 16:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[especies](
	[id_especie] [bigint] IDENTITY(1,1) NOT NULL,
	[nombre_e] [varchar](100) NOT NULL,
	[descripcion_e] [text] NOT NULL,
 CONSTRAINT [especies_pkey] PRIMARY KEY CLUSTERED 
(
	[id_especie] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[facturas] Fecha de script: 31/10/2026 16:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[facturas](
	[id_factura] [bigint] IDENTITY(1,1) NOT NULL,
	[id_cita] [bigint] NULL,
	[fecha_emision_f] [date] NOT NULL,
	[estado_f] [varchar](50) NULL,
	[total_f] [numeric](10, 2) NULL,
 CONSTRAINT [facturas_pkey] PRIMARY KEY CLUSTERED 
(
	[id_factura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[mascotas] Fecha de script: 31/10/2026 16:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mascotas](
	[id_mascota] [bigint] IDENTITY(1,1) NOT NULL,
	[id_propietario] [bigint] NOT NULL,
	[id_raza] [bigint] NOT NULL,
	[nombre_m] [varchar](100) NOT NULL,
	[fecha_nacimiento] [date] NULL,
	[sexo_m] [varchar](10) NULL,
	[peso_m] [numeric](6, 2) NULL,
	[tamanio_m] [varchar](50) NULL,
 CONSTRAINT [mascotas_pkey] PRIMARY KEY CLUSTERED 
(
	[id_mascota] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[medicamentos] Fecha de script: 31/10/2026 16:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[medicamentos](
	[id_medicamento] [bigint] IDENTITY(1,1) NOT NULL,
	[nombre_m] [varchar](150) NOT NULL,
	[presentacion_m] [varchar](100) NULL,
	[laboratorio_m] [varchar](150) NULL,
	[precio_m] [numeric](10, 2) NOT NULL,
	[stock_m] [int] NOT NULL,
 CONSTRAINT [medicamentos_pkey] PRIMARY KEY CLUSTERED 
(
	[id_medicamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[procedimientos] Fecha de script: 31/10/2026 16:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[procedimientos](
	[id_procedimiento] [bigint] IDENTITY(1,1) NOT NULL,
	[id_diagnostico] [bigint] NOT NULL,
	[nombre_p] [varchar](100) NULL,
	[descripcion_p] [text] NULL,
	[costo_p] [numeric](10, 2) NULL,
 CONSTRAINT [procedimientos_pkey] PRIMARY KEY CLUSTERED 
(
	[id_procedimiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[propietarios] Fecha de script: 31/10/2026 16:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[propietarios](
	[id_propietario] [bigint] IDENTITY(1,1) NOT NULL,
	[dui_p] [varchar](20) NOT NULL,
	[nombre_p] [varchar](100) NOT NULL,
	[apellido_p] [varchar](100) NOT NULL,
	[genero_p] [varchar](10) NULL,
	[telefono_p] [varchar](20) NOT NULL,
	[telefono_secundario_p] [varchar](20) NOT NULL,
	[correo_p] [varchar](150) NULL,
	[direccion_p] [text] NULL,
 CONSTRAINT [propietarios_pkey] PRIMARY KEY CLUSTERED 
(
	[id_propietario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[razas] Fecha de script: 31/10/2026 16:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[razas](
	[id_raza] [bigint] IDENTITY(1,1) NOT NULL,
	[id_especie] [bigint] NOT NULL,
	[nombre_r] [varchar](100) NOT NULL,
 CONSTRAINT [razas_pkey] PRIMARY KEY CLUSTERED 
(
	[id_raza] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[tratamiento] Fecha de script: 31/10/2026 16:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tratamiento](
	[id_tratamiento] [bigint] IDENTITY(1,1) NOT NULL,
	[id_diagnostico] [bigint] NOT NULL,
	[fecha_inicio] [date] NULL,
	[fecha_fin] [date] NULL,
	[descripcion_t] [text] NULL,
	[indicaciones_t] [text] NULL,
 CONSTRAINT [tratamiento_pkey] PRIMARY KEY CLUSTERED 
(
	[id_tratamiento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[veterinario] Fecha de script: 31/10/2026 16:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[veterinario](
	[id_veterinario] [bigint] IDENTITY(1,1) NOT NULL,
	[id_especialidad] [bigint] NOT NULL,
	[nombre_v] [varchar](100) NOT NULL,
	[apellido_v] [varchar](100) NOT NULL,
	[telefono_v] [varchar](20) NULL,
	[correo_v] [varchar](150) NULL,
 CONSTRAINT [veterinario_pkey] PRIMARY KEY CLUSTERED 
(
	[id_veterinario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Index [uq_medicamento_por_tratamiento] Fecha de script: 31/10/2026 16:31:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [uq_medicamento_por_tratamiento] ON [dbo].[detalles_tratamientos]
(
	[id_tratamiento] ASC,
	[id_medicamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Objeto: Index [diagnosticos_id_cita_key] Fecha de script: 31/10/2026 16:31:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [diagnosticos_id_cita_key] ON [dbo].[diagnosticos]
(
	[id_cita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [uq_especialidad_nombre] Fecha de script: 31/10/2026 16:31:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [uq_especialidad_nombre] ON [dbo].[especialidades]
(
	[nombre_esp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [uq_especie_nombre] Fecha de script: 31/10/2026 16:31:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [uq_especie_nombre] ON [dbo].[especies]
(
	[nombre_e] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
/****** Objeto: Index [facturas_id_cita_key] Fecha de script: 31/10/2026 16:31:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [facturas_id_cita_key] ON [dbo].[facturas]
(
	[id_cita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [uq_medicamento_nombre_presentacion] Fecha de script: 31/10/2026 16:31:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [uq_medicamento_nombre_presentacion] ON [dbo].[medicamentos]
(
	[nombre_m] ASC,
	[presentacion_m] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [propietarios_correo_p_key] Fecha de script: 31/10/2026 16:31:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [propietarios_correo_p_key] ON [dbo].[propietarios]
(
	[correo_p] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [propietarios_dui_p_key] Fecha de script: 31/10/2026 16:31:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [propietarios_dui_p_key] ON [dbo].[propietarios]
(
	[dui_p] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [propietarios_telefono_p_key] Fecha de script: 31/10/2026 16:31:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [propietarios_telefono_p_key] ON [dbo].[propietarios]
(
	[telefono_p] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [uq_raza_por_especie] Fecha de script: 31/10/2026 16:31:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [uq_raza_por_especie] ON [dbo].[razas]
(
	[id_especie] ASC,
	[nombre_r] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [veterinario_correo_v_key] Fecha de script: 31/10/2026 16:31:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [veterinario_correo_v_key] ON [dbo].[veterinario]
(
	[correo_v] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Objeto: Index [veterinario_telefono_v_key] Fecha de script: 31/10/2026 16:31:25 ******/
CREATE UNIQUE NONCLUSTERED INDEX [veterinario_telefono_v_key] ON [dbo].[veterinario]
(
	[telefono_v] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 99, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
ALTER TABLE [dbo].[citas] ADD  DEFAULT ('Programada') FOR [estado_c]
GO
ALTER TABLE [dbo].[detalles_facturas] ADD  DEFAULT ((1)) FOR [cantidad_df]
GO
ALTER TABLE [dbo].[detalles_facturas] ADD  DEFAULT ((0)) FOR [precio_unit_df]
GO
ALTER TABLE [dbo].[facturas] ADD  DEFAULT ('Pendiente') FOR [estado_f]
GO
ALTER TABLE [dbo].[facturas] ADD  DEFAULT ((0)) FOR [total_f]
GO
ALTER TABLE [dbo].[medicamentos] ADD  DEFAULT ((0)) FOR [precio_m]
GO
ALTER TABLE [dbo].[medicamentos] ADD  DEFAULT ((0)) FOR [stock_m]
GO
ALTER TABLE [dbo].[citas]  WITH CHECK ADD  CONSTRAINT [fk_citas_mascota] FOREIGN KEY([id_mascota])
REFERENCES [dbo].[mascotas] ([id_mascota])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[citas] CHECK CONSTRAINT [fk_citas_mascota]
GO
ALTER TABLE [dbo].[citas]  WITH CHECK ADD  CONSTRAINT [fk_citas_veterinario] FOREIGN KEY([id_veterinario])
REFERENCES [dbo].[veterinario] ([id_veterinario])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[citas] CHECK CONSTRAINT [fk_citas_veterinario]
GO
ALTER TABLE [dbo].[detalles_facturas]  WITH CHECK ADD  CONSTRAINT [fk_df_cita] FOREIGN KEY([id_cita])
REFERENCES [dbo].[citas] ([id_cita])
GO
ALTER TABLE [dbo].[detalles_facturas] CHECK CONSTRAINT [fk_df_cita]
GO
ALTER TABLE [dbo].[detalles_facturas]  WITH CHECK ADD  CONSTRAINT [fk_df_factura] FOREIGN KEY([id_factura])
REFERENCES [dbo].[facturas] ([id_factura])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[detalles_facturas] CHECK CONSTRAINT [fk_df_factura]
GO
ALTER TABLE [dbo].[detalles_facturas]  WITH CHECK ADD  CONSTRAINT [fk_df_medicamento] FOREIGN KEY([id_medicamento])
REFERENCES [dbo].[medicamentos] ([id_medicamento])
ON UPDATE CASCADE
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[detalles_facturas] CHECK CONSTRAINT [fk_df_medicamento]
GO
ALTER TABLE [dbo].[detalles_facturas]  WITH CHECK ADD  CONSTRAINT [fk_df_procedimiento] FOREIGN KEY([id_procedimiento])
REFERENCES [dbo].[procedimientos] ([id_procedimiento])
GO
ALTER TABLE [dbo].[detalles_facturas] CHECK CONSTRAINT [fk_df_procedimiento]
GO
ALTER TABLE [dbo].[detalles_facturas]  WITH CHECK ADD  CONSTRAINT [fk_df_tratamiento] FOREIGN KEY([id_tratamiento])
REFERENCES [dbo].[tratamiento] ([id_tratamiento])
GO
ALTER TABLE [dbo].[detalles_facturas] CHECK CONSTRAINT [fk_df_tratamiento]
GO
ALTER TABLE [dbo].[detalles_tratamientos]  WITH CHECK ADD  CONSTRAINT [fk_dt_medicamento] FOREIGN KEY([id_medicamento])
REFERENCES [dbo].[medicamentos] ([id_medicamento])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[detalles_tratamientos] CHECK CONSTRAINT [fk_dt_medicamento]
GO
ALTER TABLE [dbo].[detalles_tratamientos]  WITH CHECK ADD  CONSTRAINT [fk_dt_tratamiento] FOREIGN KEY([id_tratamiento])
REFERENCES [dbo].[tratamiento] ([id_tratamiento])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[detalles_tratamientos] CHECK CONSTRAINT [fk_dt_tratamiento]
GO
ALTER TABLE [dbo].[diagnosticos]  WITH CHECK ADD  CONSTRAINT [fk_diagnosticos_cita] FOREIGN KEY([id_cita])
REFERENCES [dbo].[citas] ([id_cita])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[diagnosticos] CHECK CONSTRAINT [fk_diagnosticos_cita]
GO
ALTER TABLE [dbo].[facturas]  WITH CHECK ADD  CONSTRAINT [fk_facturas_cita] FOREIGN KEY([id_cita])
REFERENCES [dbo].[citas] ([id_cita])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[facturas] CHECK CONSTRAINT [fk_facturas_cita]
GO
ALTER TABLE [dbo].[mascotas]  WITH CHECK ADD  CONSTRAINT [fk_mascotas_propietario] FOREIGN KEY([id_propietario])
REFERENCES [dbo].[propietarios] ([id_propietario])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[mascotas] CHECK CONSTRAINT [fk_mascotas_propietario]
GO
ALTER TABLE [dbo].[mascotas]  WITH CHECK ADD  CONSTRAINT [fk_mascotas_raza] FOREIGN KEY([id_raza])
REFERENCES [dbo].[razas] ([id_raza])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[mascotas] CHECK CONSTRAINT [fk_mascotas_raza]
GO
ALTER TABLE [dbo].[procedimientos]  WITH CHECK ADD  CONSTRAINT [fk_procedimientos_diagnostico] FOREIGN KEY([id_diagnostico])
REFERENCES [dbo].[diagnosticos] ([id_diagnostico])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[procedimientos] CHECK CONSTRAINT [fk_procedimientos_diagnostico]
GO
ALTER TABLE [dbo].[razas]  WITH CHECK ADD  CONSTRAINT [fk_razas_especie] FOREIGN KEY([id_especie])
REFERENCES [dbo].[especies] ([id_especie])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[razas] CHECK CONSTRAINT [fk_razas_especie]
GO
ALTER TABLE [dbo].[tratamiento]  WITH CHECK ADD  CONSTRAINT [fk_tratamiento_diagnostico] FOREIGN KEY([id_diagnostico])
REFERENCES [dbo].[diagnosticos] ([id_diagnostico])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[tratamiento] CHECK CONSTRAINT [fk_tratamiento_diagnostico]
GO
ALTER TABLE [dbo].[veterinario]  WITH CHECK ADD  CONSTRAINT [fk_veterinario_especialidad] FOREIGN KEY([id_especialidad])
REFERENCES [dbo].[especialidades] ([id_especialidad])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[veterinario] CHECK CONSTRAINT [fk_veterinario_especialidad]
GO

 
