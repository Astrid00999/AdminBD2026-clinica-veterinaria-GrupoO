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
/* ============================================================
   CARGA DE DATOS BASE
   El orden respeta las llaves foráneas. Los insert usan ids
   numéricos fijos, por eso solo deben correr sobre tablas vacías
   (el script siempre recrea la base antes).
   ============================================================ */
use [ClinicaVeterinaria]
go
-- ============================================================
-- 1° insert: especies (17)
-- Caprino, Ave de corral, Primate, Marsupial y Arácnido no tienen
-- mascotas: se eliminarán después.
-- ============================================================
insert into especies (nombre_e, descripcion_e)
values ('Canino', 'Mamífero doméstico de la familia Canidae, comúnmente conocido como perro.'),
       ('Felino', 'Mamífero de la familia Felidae, incluye gatos domésticos y felinos salvajes.'),
       ('Ave', 'Animal vertebrado de sangre caliente con plumas, pico y alas.'),
       ('Conejo', 'Mamífero herbívoro de orejas largas, comúnmente criado como mascota.'),
       ('Reptil', 'Animal vertebrado de sangre fría con escamas, incluye lagartijas y serpientes.'),
       ('Pez', 'Animal acuático de sangre fría con aletas y branquias.'),
       ('Roedor', 'Mamífero caracterizado por sus incisivos prominentes, incluye hámster y cobaya.'),
       ('Hurón', 'Mamífero carnívoro domesticado de la familia Mustelidae.'),
       ('Anfibio', 'Animal vertebrado que puede vivir en agua y tierra, como ranas y salamandras.'),
       ('Équido', 'Mamífero ungulado de la familia Equidae, incluye caballos, burros y ponis.'),
       ('Porcino', 'Mamífero omnívoro doméstico de la familia Suidae, comúnmente conocido como cerdo.'),
       ('Ovino', 'Mamífero rumiante de la familia Bovidae, comúnmente conocido como oveja.'),
       ('Caprino', 'Mamífero rumiante doméstico de la familia Bovidae, comúnmente conocido como cabra.'),
       ('Ave de corral', 'Aves criadas principalmente para la producción de huevos y carne.'),
       ('Primate', 'Orden de mamíferos que incluye monos y simios, de alta inteligencia.'),
       ('Marsupial', 'Mamífero que da a luz crías inmaduras y las desarrolla en una bolsa ventral.'),
       ('Arácnido', 'Artrópodo de ocho patas, incluye arañas y escorpiones.');
go

-- ============================================================
-- 2° insert: razas (70)
-- 5 por especie común y 3 por especie menos común; al final se agregan
-- las razas más vistas en El Salvador (mestizos y razas pequeñas).
-- ============================================================
-- Canino (5 razas)
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Canino'), 'Labrador Retriever'),
       ((select id_especie from especies where nombre_e = 'Canino'), 'Pastor Alemán'),
       ((select id_especie from especies where nombre_e = 'Canino'), 'Chihuahua'),
       ((select id_especie from especies where nombre_e = 'Canino'), 'Golden Retriever'),
       ((select id_especie from especies where nombre_e = 'Canino'), 'Bulldog Francés');
go

-- Felino (5 razas)
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Felino'), 'Siamés'),
       ((select id_especie from especies where nombre_e = 'Felino'), 'Persa'),
       ((select id_especie from especies where nombre_e = 'Felino'), 'Bengalí'),
       ((select id_especie from especies where nombre_e = 'Felino'), 'Maine Coon'),
       ((select id_especie from especies where nombre_e = 'Felino'), 'Angora');
go

-- Ave (5 razas)
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Ave'), 'Loro'),
       ((select id_especie from especies where nombre_e = 'Ave'), 'Canario'),
       ((select id_especie from especies where nombre_e = 'Ave'), 'Cacatúa'),
       ((select id_especie from especies where nombre_e = 'Ave'), 'Periquito'),
       ((select id_especie from especies where nombre_e = 'Ave'), 'Agapornis');
go

-- Roedor (5 razas)
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Roedor'), 'Hámster Sirio'),
       ((select id_especie from especies where nombre_e = 'Roedor'), 'Cobaya'),
       ((select id_especie from especies where nombre_e = 'Roedor'), 'Chinchilla'),
       ((select id_especie from especies where nombre_e = 'Roedor'), 'Rata Fancy'),
       ((select id_especie from especies where nombre_e = 'Roedor'), 'Jerbo');
go

-- Conejo (5 razas)
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Conejo'), 'Holandés'),
       ((select id_especie from especies where nombre_e = 'Conejo'), 'Angora'),
       ((select id_especie from especies where nombre_e = 'Conejo'), 'Rex'),
       ((select id_especie from especies where nombre_e = 'Conejo'), 'Lionhead'),
       ((select id_especie from especies where nombre_e = 'Conejo'), 'Mini Lop');
go

-- Reptil (3 razas)
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Reptil'), 'Dragón Barbudo'),
       ((select id_especie from especies where nombre_e = 'Reptil'), 'Gecko Leopardo'),
       ((select id_especie from especies where nombre_e = 'Reptil'), 'Iguana Verde');
go

-- Pez (3 razas)
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Pez'), 'Betta'),
       ((select id_especie from especies where nombre_e = 'Pez'), 'Goldfish'),
       ((select id_especie from especies where nombre_e = 'Pez'), 'Guppy');
go

-- Hurón (3 razas)
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Hurón'), 'Hurón Estándar'),
       ((select id_especie from especies where nombre_e = 'Hurón'), 'Hurón Angora'),
       ((select id_especie from especies where nombre_e = 'Hurón'), 'Hurón Albino');
go

-- Anfibio (3 razas)
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Anfibio'), 'Axolotl'),
       ((select id_especie from especies where nombre_e = 'Anfibio'), 'Rana Africana'),
       ((select id_especie from especies where nombre_e = 'Anfibio'), 'Salamandra Tigre');
go

-- Équido (3 razas)
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Équido'), 'Caballo Árabe'),
       ((select id_especie from especies where nombre_e = 'Équido'), 'Poni Shetland'),
       ((select id_especie from especies where nombre_e = 'Équido'), 'Burro Andaluz');
go

-- Porcino (3 razas)
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Porcino'), 'Cerdo Vietnamita'),
       ((select id_especie from especies where nombre_e = 'Porcino'), 'Duroc'),
       ((select id_especie from especies where nombre_e = 'Porcino'), 'Landrace');
go

-- Ovino (3 razas)
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Ovino'), 'Merino'),
       ((select id_especie from especies where nombre_e = 'Ovino'), 'Suffolk'),
       ((select id_especie from especies where nombre_e = 'Ovino'), 'Dorper');
go

-- Caprino (3 razas) - se eliminará después
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Caprino'), 'Boer'),
       ((select id_especie from especies where nombre_e = 'Caprino'), 'Nubia'),
       ((select id_especie from especies where nombre_e = 'Caprino'), 'Saanen');
go

-- Ave de corral (3 razas) - se eliminará después
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Ave de corral'), 'Gallina Leghorn'),
       ((select id_especie from especies where nombre_e = 'Ave de corral'), 'Pato Pekín'),
       ((select id_especie from especies where nombre_e = 'Ave de corral'), 'Pavo Real');
go

-- Primate (3 razas) - se eliminará después
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Primate'), 'Tití Común'),
       ((select id_especie from especies where nombre_e = 'Primate'), 'Mono Ardilla'),
       ((select id_especie from especies where nombre_e = 'Primate'), 'Lémur');
go

-- Marsupial (3 razas) - se eliminará después
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Marsupial'), 'Zarigüeya'),
       ((select id_especie from especies where nombre_e = 'Marsupial'), 'Canguro Enano'),
       ((select id_especie from especies where nombre_e = 'Marsupial'), 'Petauro del Azúcar');
go

-- Arácnido (3 razas) - se eliminará después
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Arácnido'), 'Tarántula Rosa'),
       ((select id_especie from especies where nombre_e = 'Arácnido'), 'Escorpión Emperador'),
       ((select id_especie from especies where nombre_e = 'Arácnido'), 'Tarántula Patas Rojas');
go

-- razas más comunes en la clínica
insert into razas (id_especie, nombre_r)
values ((select id_especie from especies where nombre_e = 'Canino'), 'Mestizo'),
       ((select id_especie from especies where nombre_e = 'Canino'), 'Schnauzer Miniatura'),
       ((select id_especie from especies where nombre_e = 'Canino'), 'Shih Tzu'),
       ((select id_especie from especies where nombre_e = 'Canino'), 'Poodle'),
       ((select id_especie from especies where nombre_e = 'Canino'), 'Husky Siberiano'),
       ((select id_especie from especies where nombre_e = 'Canino'), 'Pitbull'),
       ((select id_especie from especies where nombre_e = 'Canino'), 'Beagle'),
       ((select id_especie from especies where nombre_e = 'Felino'), 'Doméstico de Pelo Corto'),
       ((select id_especie from especies where nombre_e = 'Felino'), 'Doméstico de Pelo Largo');
go

-- ============================================================
-- 3° insert: propietarios (20)
-- ============================================================
insert into propietarios (dui_p, nombre_p, apellido_p, genero_p, telefono_p, telefono_secundario_p, correo_p,
                          direccion_p)
values ('01234567-8', 'Adriana', 'Mejía', 'F', '7123-4567', '2234-5678', 'adriana.mejia@gmail.com',
        'Colonia Escalón, San Salvador'),
       ('02345678-9', 'Susan', 'Castillo', 'F', '7234-5678', '2345-6789', 'susan.castillo@gmail.com',
        'Reparto Los Héroes, San Salvador'),
       ('03456789-0', 'Francisco', 'Navarrete', 'M', '7345-6789', '2456-7890', 'francisco.navarrete@gmail.com',
        'Colonia San Benito, San Salvador'),
       ('04567890-1', 'Daniel', 'Echegoyen', 'M', '7456-7890', '2567-8901', 'daniel.echegoyen@gmail.com',
        'Urbanización Madre Selva, Antiguo Cuscatlán'),
       ('05678901-2', 'Luis', 'Rodríguez', 'M', '7567-8901', '2678-9012', 'luis.rodriguez@gmail.com',
        'Colonia Miramonte, San Salvador'),
       ('06789012-3', 'Laura', 'Pérez', 'F', '7678-9012', '2789-0123', 'laura.perez@gmail.com',
        'Residencial Santa Elena, Antiguo Cuscatlán'),
       ('07890123-4', 'Roberto', 'Flores', 'M', '7789-0123', '2890-1234', 'roberto.flores@hotmail.com',
        'Colonia Jardines de Guadalupe, San Salvador'),
       ('08901234-5', 'Sofía', 'Chávez', 'F', '7890-1234', '2901-2345', 'sofia.chavez@gmail.com',
        'Colonia Maquilishuat, San Salvador'),
       ('09012345-6', 'Diego', 'Ramírez', 'M', '7901-2345', '2012-3456', 'diego.ramirez@gmail.com',
        'Urbanización California, Santa Tecla'),
       ('00123456-7', 'Valentina', 'Cruz', 'F', '7012-3456', '2123-4567', 'valentina.cruz@yahoo.com',
        'Colonia América, San Salvador'),
       ('11234567-8', 'Miguel', 'Castillo', 'M', '7523-4567', '2334-5678', 'miguel.castillo@gmail.com',
        'Reparto Shafick, San Salvador'),
       ('12345678-9', 'Isabella', 'Morales', 'F', '7634-5678', '2445-6789', 'isabella.morales@gmail.com',
        'Colonia Universitaria, San Salvador'),
       ('13456789-0', 'Andrés', 'Jiménez', 'M', '7745-6789', '2556-7890', 'andres.jimenez@hotmail.com',
        'Residencial Las Colinas, Santa Tecla'),
       ('14567890-1', 'Camila', 'Torres', 'F', '7856-7890', '2667-8901', 'camila.torres@gmail.com',
        'Colonia Lomas de San Francisco, Antiguo Cuscatlán'),
       ('15678901-2', 'Fernando', 'Aguilar', 'M', '7967-8901', '2778-9012', 'fernando.aguilar@gmail.com',
        'Colonia Centroamérica, San Salvador'),
       ('16789012-3', 'Valeria', 'Vásquez', 'F', '7078-9012', '2889-0123', 'valeria.vasquez@yahoo.com',
        'Urbanización Siena, Antiguo Cuscatlán'),
       ('17890123-4', 'Ricardo', 'Mendoza', 'M', '7189-0123', '2990-1234', 'ricardo.mendoza@gmail.com',
        'Colonia La Sultana, Antiguo Cuscatlán'),
       ('18901234-5', 'Gabriela', 'Rivas', 'F', '7290-1234', '2101-2345', 'gabriela.rivas@gmail.com',
        'Reparto Cucumacayán, San Salvador'),
       ('19012345-6', 'Alejandro', 'Molina', 'M', '7391-2345', '2212-3456', 'alejandro.molina@hotmail.com',
        'Colonia Médica, San Salvador'),
       ('10123456-7', 'Daniela', 'Ortiz', 'F', '7492-3456', '2323-4567', 'daniela.ortiz@gmail.com',
        'Colonia Escalón, San Salvador');
go

-- ============================================================
-- 4° insert: mascotas (71)
-- 2 por cada raza común y 1 por cada raza menos común
-- ============================================================
insert into mascotas (id_propietario, id_raza, nombre_m, fecha_nacimiento, sexo_m, peso_m, tamanio_m)
values (1, 1, 'Max', '2021-03-15', 'Macho', 30.50, 'Grande'),
       (2, 1, 'Luna', '2020-07-22', 'Hembra', 28.00, 'Grande'),
       (3, 2, 'Rex', '2019-11-10', 'Macho', 35.00, 'Grande'),
       (4, 2, 'Nala', '2022-01-05', 'Hembra', 29.50, 'Grande'),
       (5, 3, 'Tiny', '2023-05-18', 'Macho', 2.10, 'Pequeño'),
       (6, 3, 'Bella', '2022-09-30', 'Hembra', 1.80, 'Pequeño'),
       (7, 4, 'Buddy', '2021-06-12', 'Macho', 32.00, 'Grande'),
       (8, 4, 'Daisy', '2020-12-01', 'Hembra', 27.50, 'Grande'),
       (9, 5, 'Gordo', '2022-04-20', 'Macho', 12.00, 'Mediano'),
       (10, 5, 'Coco', '2023-02-14', 'Hembra', 10.50, 'Mediano'),
       (11, 6, 'Milo', '2021-08-03', 'Macho', 4.50, 'Mediano'),
       (12, 6, 'Nube', '2022-11-25', 'Hembra', 3.80, 'Mediano'),
       (13, 7, 'Pelusa', '2020-03-17', 'Hembra', 4.20, 'Mediano'),
       (14, 7, 'Simon', '2019-07-09', 'Macho', 5.00, 'Mediano'),
       (15, 8, 'Tigre', '2022-06-01', 'Macho', 5.50, 'Mediano'),
       (16, 8, 'Mia', '2023-01-19', 'Hembra', 4.00, 'Mediano'),
       (17, 9, 'Gigante', '2020-09-14', 'Macho', 8.50, 'Grande'),
       (18, 9, 'Reina', '2021-12-30', 'Hembra', 6.50, 'Grande'),
       (19, 10, 'Blanca', '2022-03-08', 'Hembra', 3.50, 'Mediano'),
       (20, 10, 'Fluffy', '2021-10-22', 'Macho', 4.00, 'Mediano'),
       (1, 11, 'Paco', '2018-05-11', 'Macho', 0.40, 'Pequeño'),
       (2, 11, 'Verde', '2019-08-23', 'Hembra', 0.30, 'Pequeño'),
       (3, 12, 'Sol', '2022-02-14', 'Macho', 0.02, 'Pequeño'),
       (4, 12, 'Pio', '2023-04-01', 'Hembra', 0.02, 'Pequeño'),
       (5, 13, 'Nieve', '2020-11-05', 'Hembra', 0.35, 'Pequeño'),
       (6, 13, 'Rocky', '2019-03-28', 'Macho', 0.40, 'Pequeño'),
       (7, 14, 'Azul', '2023-06-10', 'Macho', 0.03, 'Pequeño'),
       (8, 14, 'Verdecito', '2022-08-15', 'Hembra', 0.03, 'Pequeño'),
       (9, 15, 'Amor', '2022-01-30', 'Hembra', 0.05, 'Pequeño'),
       (10, 15, 'Pico', '2021-07-17', 'Macho', 0.05, 'Pequeño'),
       (11, 16, 'Bolita', '2023-03-12', 'Macho', 0.15, 'Pequeño'),
       (12, 16, 'Canela', '2022-10-05', 'Hembra', 0.13, 'Pequeño'),
       (13, 17, 'Manchas', '2021-05-20', 'Macho', 1.10, 'Pequeño'),
       (14, 17, 'Trebol', '2022-07-14', 'Hembra', 0.90, 'Pequeño'),
       (15, 18, 'Gris', '2020-04-08', 'Macho', 0.60, 'Pequeño'),
       (16, 18, 'Suave', '2021-09-19', 'Hembra', 0.50, 'Pequeño'),
       (17, 19, 'Raton', '2023-01-25', 'Macho', 0.35, 'Pequeño'),
       (18, 19, 'Noche', '2022-06-30', 'Hembra', 0.28, 'Pequeño'),
       (19, 20, 'Salto', '2023-05-03', 'Macho', 0.08, 'Pequeño'),
       (20, 20, 'Arena', '2022-11-11', 'Hembra', 0.07, 'Pequeño'),
       (1, 21, 'Dutch', '2021-02-18', 'Macho', 2.00, 'Pequeño'),
       (2, 21, 'Mochi', '2022-04-27', 'Hembra', 1.80, 'Pequeño'),
       (3, 22, 'Algodon', '2020-08-09', 'Macho', 3.50, 'Mediano'),
       (4, 22, 'Lana', '2021-11-14', 'Hembra', 3.20, 'Mediano'),
       (5, 23, 'Terciopelo', '2022-07-21', 'Macho', 4.00, 'Mediano'),
       (6, 23, 'Suavecito', '2023-03-05', 'Hembra', 3.50, 'Mediano'),
       (7, 24, 'Melena', '2022-09-16', 'Macho', 1.80, 'Pequeño'),
       (8, 24, 'Leona', '2021-04-02', 'Hembra', 1.60, 'Pequeño'),
       (9, 25, 'Orejon', '2023-02-28', 'Macho', 2.20, 'Pequeño'),
       (10, 25, 'Floppy', '2022-06-13', 'Hembra', 2.00, 'Pequeño'),
       (11, 26, 'Spike', '2021-01-15', 'Macho', 0.45, 'Mediano'),
       (12, 27, 'Spot', '2022-03-22', 'Hembra', 0.07, 'Pequeño'),
       (13, 28, 'Verde', '2020-06-30', 'Macho', 3.50, 'Grande'),
       (14, 29, 'Escarlata', '2023-01-10', 'Macho', 0.01, 'Pequeño'),
       (15, 30, 'Naranja', '2022-05-18', 'Hembra', 0.05, 'Pequeño'),
       (16, 31, 'Colores', '2023-04-05', 'Macho', 0.01, 'Pequeño'),
       (17, 32, 'Bandido', '2021-09-07', 'Macho', 1.20, 'Pequeño'),
       (18, 33, 'Pelin', '2022-12-19', 'Hembra', 0.90, 'Pequeño'),
       (19, 34, 'Blanco', '2023-02-01', 'Macho', 1.00, 'Pequeño'),
       (20, 35, 'Axo', '2022-08-14', 'Macho', 0.30, 'Pequeño'),
       (1, 36, 'Croac', '2021-11-28', 'Hembra', 0.08, 'Pequeño'),
       (2, 37, 'Tigresa', '2020-07-03', 'Hembra', 0.12, 'Pequeño'),
       (3, 38, 'Trueno', '2018-03-25', 'Macho', 450, 'Grande'),
       (4, 39, 'Pony', '2019-10-11', 'Hembra', 180, 'Mediano'),
       (5, 40, 'Burrito', '2017-06-16', 'Macho', 200, 'Mediano'),
       (6, 41, 'Chanchito', '2021-04-14', 'Macho', 45, 'Mediano'),
       (7, 42, 'Rosado', '2020-01-22', 'Hembra', 120, 'Grande'),
       (8, 43, 'Oink', '2019-08-30', 'Macho', 150, 'Grande'),
       (9, 44, 'Lana', '2020-11-17', 'Hembra', 55, 'Mediano'),
       (10, 45, 'Negrita', '2021-03-04', 'Hembra', 70, 'Mediano'),
       (11, 46, 'Borrego', '2022-07-09', 'Macho', 65, 'Mediano');
go

-- ============================================================
-- 5° insert: especialidades (20)
-- ============================================================
insert into especialidades (nombre_esp, descripcion_esp)
values ('Medicina General Veterinaria', 'Atención médica integral para animales domésticos.'),
       ('Cirugía Veterinaria', 'Procedimientos quirúrgicos preventivos y correctivos.'),
       ('Dermatología Veterinaria', 'Diagnóstico y tratamiento de enfermedades de la piel.'),
       ('Odontología Veterinaria', 'Prevención y tratamiento de enfermedades dentales.'),
       ('Cardiología Veterinaria', 'Diagnóstico y tratamiento de enfermedades cardiovasculares.'),
       ('Neurología Veterinaria', 'Atención de trastornos del sistema nervioso.'),
       ('Oftalmología Veterinaria', 'Diagnóstico y tratamiento de enfermedades oculares.'),
       ('Oncología Veterinaria', 'Diagnóstico y tratamiento del cáncer en animales.'),
       ('Traumatología Veterinaria', 'Tratamiento de fracturas y lesiones musculoesqueléticas.'),
       ('Ortopedia Veterinaria', 'Corrección y tratamiento de problemas óseos y articulares.'),
       ('Medicina Interna Veterinaria', 'Diagnóstico y tratamiento de enfermedades complejas.'),
       ('Nutrición Veterinaria', 'Planes alimenticios y control nutricional.'),
       ('Etología Veterinaria', 'Estudio y tratamiento de problemas de comportamiento animal.'),
       ('Anestesiología Veterinaria', 'Administración y monitoreo de anestesia.'),
       ('Medicina Preventiva', 'Vacunación, desparasitación y control sanitario.'),
       ('Reproducción Animal', 'Manejo reproductivo y fertilidad animal.'),
       ('Medicina de Animales Exóticos', 'Atención de reptiles, aves y pequeños mamíferos.'),
       ('Urgencias Veterinarias', 'Atención de emergencias médicas y quirúrgicas.'),
       ('Diagnóstico por Imágenes', 'Radiografías, ecografías y otros estudios diagnósticos.'),
       ('Fisioterapia y Rehabilitación', 'Recuperación funcional tras lesiones o cirugías.');
go

-- ============================================================
-- 6° insert: veterinario (40)
-- 2 veterinarios por especialidad; trabajan en turnos rotativos
-- ============================================================
insert into veterinario (id_especialidad, nombre_v, apellido_v, telefono_v, correo_v)
values ((select id_especialidad from especialidades where nombre_esp = 'Medicina General Veterinaria'), 'Carlos', 'Martínez', '7000-0001', 'carlos.martinez@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Medicina General Veterinaria'), 'Laura', 'Torres', '7000-0002', 'laura.torres@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Cirugía Veterinaria'), 'Ana', 'López', '7000-0003', 'ana.lopez@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Cirugía Veterinaria'), 'Javier', 'Castillo', '7000-0004', 'javier.castillo@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Dermatología Veterinaria'), 'Jorge', 'Ramírez', '7000-0005', 'jorge.ramirez@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Dermatología Veterinaria'), 'Daniela', 'Romero', '7000-0006', 'daniela.romero@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Odontología Veterinaria'), 'Sofía', 'Castro', '7000-0007', 'sofia.castro@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Odontología Veterinaria'), 'Andrés', 'Flores', '7000-0008', 'andres.flores@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Cardiología Veterinaria'), 'Ricardo', 'Mendoza', '7000-0009', 'ricardo.mendoza@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Cardiología Veterinaria'), 'Patricia', 'Vega', '7000-0010', 'patricia.vega@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Neurología Veterinaria'), 'Miguel', 'Herrera', '7000-0011', 'miguel.herrera@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Neurología Veterinaria'), 'Valeria', 'Reyes', '7000-0012', 'valeria.reyes@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Oftalmología Veterinaria'), 'Diego', 'Silva', '7000-0013', 'diego.silva@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Oftalmología Veterinaria'), 'María', 'Campos', '7000-0014', 'maria.campos@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Oncología Veterinaria'), 'Fernando', 'Vega', '7000-0015', 'fernando.vega@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Oncología Veterinaria'), 'Gabriela', 'Morales', '7000-0016', 'gabriela.morales@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Traumatología Veterinaria'), 'Eduardo', 'Cruz', '7000-0017', 'eduardo.cruz@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Traumatología Veterinaria'), 'Andrea', 'Navarro', '7000-0018', 'andrea.navarro@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Ortopedia Veterinaria'), 'Luis', 'Pérez', '7000-0019', 'luis.perez@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Ortopedia Veterinaria'), 'Karen', 'Rivas', '7000-0020', 'karen.rivas@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Medicina Interna Veterinaria'), 'Óscar', 'Ruiz', '7000-0021', 'oscar.ruiz@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Medicina Interna Veterinaria'), 'Lucía', 'Benítez', '7000-0022', 'lucia.benitez@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Nutrición Veterinaria'), 'Roberto', 'Aguilar', '7000-0023', 'roberto.aguilar@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Nutrición Veterinaria'), 'Paula', 'Gómez', '7000-0024', 'paula.gomez@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Etología Veterinaria'), 'Tomás', 'Molina', '7000-0025', 'tomas.molina@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Etología Veterinaria'), 'Camila', 'Ortiz', '7000-0026', 'camila.ortiz@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Anestesiología Veterinaria'), 'Raúl', 'Fuentes', '7000-0027', 'raul.fuentes@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Anestesiología Veterinaria'), 'Natalia', 'Arias', '7000-0028', 'natalia.arias@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Medicina Preventiva'), 'Héctor', 'Salazar', '7000-0029', 'hector.salazar@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Medicina Preventiva'), 'Elena', 'Mejía', '7000-0030', 'elena.mejia@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Reproducción Animal'), 'Samuel', 'Castillo', '7000-0031', 'samuel.castillo@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Reproducción Animal'), 'Verónica', 'Lara', '7000-0032', 'veronica.lara@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Medicina de Animales Exóticos'), 'Esteban', 'Santos', '7000-0033', 'esteban.santos@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Medicina de Animales Exóticos'), 'Tatiana', 'Rojas', '7000-0034', 'tatiana.rojas@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Urgencias Veterinarias'), 'Iván', 'Peña', '7000-0035', 'ivan.pena@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Urgencias Veterinarias'), 'Mónica', 'Vargas', '7000-0036', 'monica.vargas@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Diagnóstico por Imágenes'), 'Roberto', 'León', '7000-0037', 'roberto.leon@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Diagnóstico por Imágenes'), 'Melissa', 'Pineda', '7000-0038', 'melissa.pineda@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Fisioterapia y Rehabilitación'), 'Cristian', 'Durán', '7000-0039', 'cristian.duran@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Fisioterapia y Rehabilitación'), 'Alejandra', 'Escobar', '7000-0040', 'alejandra.escobar@veterinaria.com');
go

-- ============================================================
-- 7° insert: citas (70)
-- Horario: lunes a sábado 7:00-20:00, domingo 7:00-13:00.
-- Fecha de corte de los datos: sábado 31/10/2026.
--   Completada: antes del corte | En curso: internados el día del corte
--   Cancelada: no se atendieron | Programada: después del corte
-- ============================================================
insert into citas (id_mascota, id_veterinario, fecha_c, motivo_c, estado_c, costo_c)
values (1, 5, '2025-01-10T09:00:00', 'Sacude la cabeza y le huelen las orejas', 'Completada', 30.00),
       (2, 29, '2025-01-15T10:30:00', 'Vacunación anual', 'Completada', 15.00),
       (3, 23, '2025-01-20T14:00:00', 'Control de peso', 'Completada', 25.00),
       (4, 1, '2025-01-25T11:00:00', 'Vómito y diarrea', 'Completada', 20.00),
       (5, 2, '2025-02-01T09:30:00', 'Chequeo general', 'Completada', 20.00),
       (6, 6, '2025-02-05T15:00:00', 'Se rasca mucho la espalda y la cola', 'Completada', 30.00),
       (7, 19, '2025-02-10T10:00:00', 'Cojea de las patas traseras', 'Completada', 35.00),
       (8, 1, '2025-02-15T13:30:00', 'Chequeo general', 'Completada', 20.00),
       (9, 2, '2025-02-20T08:00:00', 'Tos seca como si se atorara', 'Completada', 20.00),
       (10, 24, '2025-02-25T16:00:00', 'Control de peso', 'Completada', 20.00),
       (11, 29, '2025-03-02T09:00:00', 'Vacunación anual', 'Completada', 15.00),
       (12, 13, '2025-03-06T11:00:00', 'Ojo rojo con lagañas', 'Completada', 30.00),
       (13, 14, '2025-03-10T14:00:00', 'No abre un ojo', 'Completada', 30.00),
       (14, 17, '2025-03-15T10:30:00', 'No apoya la pata después de un accidente', 'Completada', 40.00),
       (15, 30, '2025-03-20T15:30:00', 'Desparasitación', 'Completada', 15.00),
       (16, 9, '2025-03-25T09:15:00', 'Evaluación cardiológica', 'Completada', 45.00),
       (17, 2, '2025-04-01T13:00:00', 'Chequeo general', 'Completada', 20.00),
       (18, 23, '2025-04-05T11:45:00', 'Control de peso', 'Completada', 20.00),
       (19, 5, '2025-04-10T10:00:00', 'Mal olor en la piel y picazón', 'Completada', 30.00),
       (20, 29, '2025-04-15T16:30:00', 'Desparasitación', 'Completada', 15.00),
       (21, 33, '2025-04-20T09:00:00', 'Control de rutina', 'Completada', 25.00),
       (22, 34, '2025-04-25T14:30:00', 'Se arranca las plumas', 'Completada', 30.00),
       (23, 33, '2025-05-01T10:15:00', 'Control de rutina', 'Completada', 25.00),
       (24, 34, '2025-05-05T15:00:00', 'Heces mal formadas y plumas erizadas', 'Completada', 30.00),
       (25, 33, '2025-05-10T09:45:00', 'Tiene el pico muy largo', 'Completada', 30.00),
       (26, 34, '2025-05-15T11:30:00', 'Respira con la cola y está esponjado', 'Completada', 30.00),
       (27, 33, '2025-05-20T13:00:00', 'Control de rutina', 'Completada', 25.00),
       (28, 34, '2025-05-26T16:00:00', 'Control de peso', 'Completada', 25.00),
       (29, 33, '2025-06-02T08:30:00', 'Control de rutina', 'Completada', 25.00),
       (30, 34, '2025-06-05T14:00:00', 'Control de rutina', 'Completada', 25.00),
       (31, 33, '2025-06-10T10:00:00', 'Tiene la cola mojada y diarrea', 'Completada', 30.00),
       (32, 34, '2025-06-16T15:30:00', 'Control de peso', 'Completada', 25.00),
       (33, 33, '2025-06-20T09:15:00', 'Se rasca hasta lastimarse', 'Completada', 30.00),
       (34, 34, '2025-06-25T11:45:00', 'No puede comer', 'Completada', 30.00),
       (35, 33, '2025-06-28T14:30:00', 'Control de rutina', 'Completada', 25.00),
       (36, 34, '2026-10-30T09:00:00', 'Hospitalización por estasis gastrointestinal', 'En curso', 30.00),
       (37, 33, '2026-10-30T11:00:00', 'Recuperación postoperatoria (extirpación de tumor)', 'En curso', 30.00),
       (38, 34, '2026-10-31T08:00:00', 'Monitoreo por dificultad respiratoria', 'En curso', 30.00),
       (39, 33, '2026-10-31T10:00:00', 'Observación por traumatismo', 'En curso', 30.00),
       (40, 34, '2026-10-31T12:00:00', 'Monitoreo clínico', 'En curso', 30.00),
       (41, 33, '2025-07-10T09:00:00', 'Control de rutina (cancelada por el propietario)', 'Cancelada', 0.00),
       (42, 34, '2025-08-15T11:00:00', 'Control de rutina (cancelada por emergencia del propietario)', 'Cancelada', 0.00),
       (43, 33, '2025-09-05T14:00:00', 'Limado dental (reprogramación solicitada)', 'Cancelada', 0.00),
       (44, 34, '2025-10-20T10:30:00', 'Control de peso (el propietario no se presentó)', 'Cancelada', 0.00),
       (45, 33, '2025-11-12T15:00:00', 'Control de rutina (cancelada por la clínica)', 'Cancelada', 0.00),
       (46, 34, '2026-11-04T09:00:00', 'Control de rutina', 'Programada', 25.00),
       (47, 33, '2026-11-10T14:00:00', 'Limado dental programado', 'Programada', 30.00),
       (48, 34, '2026-11-13T10:30:00', 'Control de peso', 'Programada', 25.00),
       (49, 33, '2026-11-18T16:00:00', 'Control de seguimiento', 'Programada', 25.00),
       (50, 34, '2026-11-25T11:00:00', 'Control de rutina', 'Programada', 25.00),
       (3, 1, '2026-06-18T09:00:00', 'Tos con flema', 'Completada', 20.00),
       (17, 2, '2026-06-19T10:30:00', 'Estornuda y tiene lagañas', 'Completada', 20.00),
       (42, 33, '2026-06-20T11:00:00', 'Estornuda y tiene moco', 'Completada', 30.00),
       (8, 5, '2026-06-18T14:00:00', 'Se rasca mucho la espalda y la cola', 'Completada', 30.00),
       (29, 34, '2026-06-19T15:30:00', 'Se arranca las plumas', 'Completada', 30.00),
       (50, 33, '2026-06-20T09:45:00', 'Costras dentro de las orejas', 'Completada', 30.00),
       (11, 29, '2026-06-18T08:00:00', 'Vacunación anual', 'Completada', 15.00),
       (23, 34, '2026-06-19T13:00:00', 'Control de rutina', 'Completada', 25.00),
       (36, 33, '2026-06-20T16:00:00', 'No come y no hace popó', 'Completada', 30.00),
       (44, 34, '2026-06-21T10:00:00', 'Diarrea y bajó de peso', 'Completada', 30.00),
       (5, 2, '2026-01-08T09:00:00', 'Chequeo general', 'Completada', 20.00),
       (14, 30, '2026-02-15T10:30:00', 'Vacunación anual', 'Completada', 15.00),
       (22, 33, '2026-03-22T11:00:00', 'Control de peso', 'Completada', 25.00),
       (31, 34, '2026-04-10T11:15:00', 'Diarrea', 'Completada', 30.00),
       (40, 33, '2026-05-18T15:00:00', 'Picazón en la nariz', 'Completada', 30.00),
       (18, 3, '2026-07-06T08:30:00', 'Retiro de puntos de esterilización', 'Completada', 15.00),
       (27, 34, '2026-08-12T13:45:00', 'Control postoperatorio', 'Completada', 25.00),
       (35, 33, '2026-09-25T16:00:00', 'Control de rutina', 'Completada', 25.00),
       (45, 34, '2026-10-14T09:20:00', 'Estornuda y tiene moco', 'Completada', 30.00),
       (50, 33, '2026-10-28T10:40:00', 'Control de peso', 'Completada', 25.00);
go

-- ============================================================
-- 8° insert: diagnosticos (55)
-- Uno por cada cita completada de los datos base.
-- Las enfermedades del documento usan el mismo nombre del documento;
-- los controles sin enfermedad empiezan con "Paciente sano:".
-- ============================================================
insert into diagnosticos (id_cita, descripcion_d, observaciones_d, fecha_d)
values (1, 'Otitis', 'Otitis externa bilateral con secreción de mal olor; bacilos en citología.', '2025-01-10'),
       (2, 'Paciente sano: vacunación anual', 'Sin hallazgos clínicos anormales; se aplican vacuna polivalente y antirrábica.', '2025-01-15'),
       (3, 'Obesidad', 'Obesidad grado I; se recomienda estrictamente cambio a dieta metabólica.', '2025-01-20'),
       (4, 'Gastroenteritis y parásitos intestinales', 'Gastroenteritis bacteriana con deshidratación leve del 5%.', '2025-01-25'),
       (5, 'Paciente sano: chequeo de rutina', 'Mascota activa con buena condición corporal.', '2025-02-01'),
       (6, 'Dermatitis alérgica', 'Dermatitis alérgica por picadura de pulga (DAPP): lesiones alopécicas en la zona lumbosacra.', '2025-02-05'),
       (7, 'Displasia de cadera', 'Dolor al extender la cadera; subluxación coxofemoral leve en radiografía.', '2025-02-10'),
       (8, 'Paciente sano: chequeo de rutina', 'Linfonodos normales, mucosas rosadas; sarro leve.', '2025-02-15'),
       (9, 'Moquillo y problemas respiratorios', 'Traqueobronquitis infecciosa (tos de las perreras): tos seca en accesos, sin fiebre.', '2025-02-20'),
       (10, 'Paciente sano: control de peso', 'Monitoreo del porcentaje de grasa corporal; peso estable.', '2025-02-25'),
       (11, 'Paciente sano: vacunación anual', 'Paciente apto; refuerzo de vacuna triple felina y antirrábica.', '2025-03-02'),
       (12, 'Conjuntivitis', 'Conjuntivitis bacteriana severa con secreción purulenta en ojo izquierdo.', '2025-03-06'),
       (13, 'Úlcera corneal', 'Úlcera corneal superficial en ojo derecho por rascado.', '2025-03-10'),
       (14, 'Heridas y traumas', 'Fractura de fémur izquierdo por atropellamiento; se realiza osteosíntesis.', '2025-03-15'),
       (15, 'Paciente sano: desparasitación', 'Examen físico normal; desparasitación interna y externa de rutina.', '2025-03-20'),
       (16, 'Cardiomiopatía hipertrófica', 'Soplo cardíaco grado II/VI; cardiomiopatía hipertrófica en fase inicial.', '2025-03-25'),
       (17, 'Paciente sano: chequeo de rutina', 'Revisión periódica sin alteraciones aparentes en sistemas.', '2025-04-01'),
       (18, 'Paciente sano: control de peso', 'Control de peso semestral con evolución favorable.', '2025-04-05'),
       (19, 'Dermatitis alérgica', 'Dermatitis por Malassezia secundaria a alergia en pliegues.', '2025-04-10'),
       (20, 'Paciente sano: desparasitación', 'Desparasitación cuatrimestral; tratamiento preventivo antiparasitario.', '2025-04-15'),
       (51, 'Moquillo y problemas respiratorios', 'Bronquitis aguda: tos productiva persistente con sibilancias leves.', '2026-06-18'),
       (52, 'Moquillo y problemas respiratorios', 'Calicivirus felino: estornudos, secreción nasal serosa y úlceras linguales leves.', '2026-06-19'),
       (53, 'Moquillo y problemas respiratorios', 'Rinitis por Pasteurella: secreción nasal blanca y estornudos.', '2026-06-20'),
       (54, 'Dermatitis alérgica', 'DAPP: lesiones eritematosas en región inguinal y base de la cola.', '2026-06-18'),
       (55, 'Picaje', 'Se arranca plumas del pecho; dieta basada solo en semillas.', '2026-06-19'),
       (56, 'Sarna y pioderma', 'Sarna por Psoroptes cuniculi: costras en pabellones auriculares.', '2026-06-20'),
       (57, 'Paciente sano: vacunación anual', 'Sin hallazgos clínicos anormales previos a la inmunización.', '2026-06-18'),
       (58, 'Paciente sano: control de rutina', 'Ave alerta, plumaje en buen estado; se recortan uñas.', '2026-06-19'),
       (59, 'Gastroenteritis y parásitos intestinales', 'Estasis gastrointestinal: anorexia y heces escasas.', '2026-06-20'),
       (60, 'Gastroenteritis y parásitos intestinales', 'Coccidiosis intestinal: ooquistes de Eimeria en coprológico.', '2026-06-21'),
       (61, 'Paciente sano: chequeo de rutina', 'Mascota en buen estado general; controles preventivos cada 6 meses.', '2026-01-08'),
       (62, 'Paciente sano: vacunación anual', 'Esquema de vacunación completado.', '2026-02-15'),
       (63, 'Obesidad', 'Sobrepeso por dieta alta en semillas de girasol.', '2026-03-22'),
       (64, 'Gastroenteritis y parásitos intestinales', 'Gastroenteritis leve; heces blandas sin sangre.', '2026-04-10'),
       (65, 'Dermatitis alérgica', 'Dermatitis nasal por contacto con el sustrato de la jaula.', '2026-05-18'),
       (66, 'Paciente sano: control postquirúrgico', 'Control de esterilización: herida cicatrizada sin complicaciones.', '2026-07-06'),
       (67, 'Paciente sano: control postquirúrgico', 'Cicatrización adecuada tras extirpación de lipoma.', '2026-08-12'),
       (68, 'Paciente sano: control de rutina', 'Sin hallazgos clínicos importantes; dientes normales.', '2026-09-25'),
       (69, 'Moquillo y problemas respiratorios', 'Rinitis por Pasteurella: estornudos y secreción nasal.', '2026-10-14'),
       (70, 'Paciente sano: control de peso', 'Estado nutricional aceptable; se ajusta la cantidad de pellets.', '2026-10-28'),
       (21, 'Paciente sano: control de rutina', 'Ave alerta y plumaje en buen estado.', '2025-04-20'),
       (22, 'Picaje', 'Se arranca plumas de alas y pecho; estrés por cambio de casa.', '2025-04-25'),
       (23, 'Paciente sano: control de rutina', 'Ave alerta y con peso estable.', '2025-05-01'),
       (24, 'Gastroenteritis y parásitos intestinales', 'Huevos de áscaris en coprológico.', '2025-05-05'),
       (25, 'Sobrecrecimiento de pico', 'Pico largo que le dificulta comer; se lima.', '2025-05-10'),
       (26, 'Moquillo y problemas respiratorios', 'Infección respiratoria: secreción nasal y respiración con movimiento de cola.', '2025-05-15'),
       (27, 'Paciente sano: control de rutina', 'Ave alerta; se recortan uñas.', '2025-05-20'),
       (28, 'Paciente sano: control de peso', 'Peso estable; dieta con pellets y verduras.', '2025-05-26'),
       (29, 'Paciente sano: control de rutina', 'Buen plumaje y peso estable.', '2025-06-02'),
       (30, 'Paciente sano: control de rutina', 'Sin hallazgos anormales.', '2025-06-05'),
       (31, 'Gastroenteritis y parásitos intestinales', 'Enteritis proliferativa (cola mojada): diarrea acuosa.', '2025-06-10'),
       (32, 'Paciente sano: control de peso', 'Peso adecuado para su edad.', '2025-06-16'),
       (33, 'Sarna y pioderma', 'Sarna por ácaros (Trixacarus caviae): prurito y alopecia en dorso.', '2025-06-20'),
       (34, 'Maloclusión dental', 'Sobrecrecimiento de premolares que le impide comer.', '2025-06-25'),
       (35, 'Paciente sano: control de rutina', 'Buena condición corporal y dientes normales.', '2025-06-28');
go

-- ============================================================
-- 9° insert: procedimientos (42)
-- ============================================================
insert into procedimientos (id_diagnostico, nombre_p, descripcion_p, costo_p)
values (1, 'Citología ótica', 'Toma de muestra del conducto auditivo y tinción.', 12.00),
       (1, 'Limpieza ótica profunda', 'Lavado clínico del conducto auditivo externo.', 15.00),
       (2, 'Revisión física pre-vacunación', 'Exploración de ganglios y temperatura.', 10.00),
       (3, 'Evaluación nutricional', 'Cálculo de condición corporal y plan alimenticio.', 20.00),
       (4, 'Fluidoterapia ambulatoria', 'Administración de solución Hartmann intravenosa.', 25.00),
       (4, 'Coprológico por flotación', 'Examen de descarte de parásitos gastrointestinales.', 10.00),
       (5, 'Hemograma completo de control', 'Evaluación de rutina de células sanguíneas.', 15.00),
       (6, 'Raspado de piel superficial', 'Toma de muestra para descarte de ectoparásitos.', 10.00),
       (7, 'Radiografía digital', 'Proyección ventrodorsal de cadera.', 40.00),
       (8, 'Limpieza dental preventiva básica', 'Eliminación manual de placa dental incipiente.', 20.00),
       (9, 'Radiografía de tórax', 'Dos proyecciones para descartar neumonía.', 30.00),
       (10, 'Evaluación nutricional', 'Medición de condición corporal y ajuste de ración.', 20.00),
       (11, 'Revisión física pre-vacunación', 'Exploración de ganglios, temperatura y mucosas.', 10.00),
       (12, 'Limpieza ocular con suero', 'Lavado antiséptico de sacos conjuntivales.', 8.00),
       (13, 'Prueba de fluoresceína', 'Tinción ocular para evaluar extensión de úlcera.', 8.00),
       (14, 'Radiografía digital', 'Dos proyecciones ortogonales de fémur izquierdo.', 40.00),
       (14, 'Cirugía ortopédica - Osteosíntesis', 'Fijación de fémur mediante placa y tornillos.', 350.00),
       (15, 'Coprológico por flotación', 'Examen de control de parásitos gastrointestinales.', 10.00),
       (16, 'Ecocardiograma Doppler', 'Evaluación dimensional y flujo de cámaras cardíacas.', 65.00),
       (17, 'Examen general de orina', 'Toma de muestra y lectura de sedimento.', 12.00),
       (18, 'Medición de glucosa en sangre', 'Monitoreo rápido con glucómetro portátil.', 6.00),
       (19, 'Citología de piel', 'Tinción e identificación microscópica de levaduras.', 12.00),
       (20, 'Aplicación de spot-on clínico', 'Colocación profesional de antiparasitario.', 5.00),
       (21, 'Radiografía de tórax', 'Dos proyecciones para evaluación de campo pulmonar.', 30.00),
       (22, 'Prueba rápida Triple Felina', 'Descarte de leucemia, SIDA y panleucopenia en felino con cuadro respiratorio.', 35.00),
       (23, 'Auscultación cardiopulmonar ampliada', 'Evaluación de ruidos pulmonares con estetoscopio digital.', 12.00),
       (24, 'Raspado de piel superficial', 'Toma de muestra para identificación de ectoparásitos.', 10.00),
       (25, 'Citología de piel', 'Revisión de piel y plumas para descartar ácaros.', 12.00),
       (26, 'Raspado de piel superficial', 'Toma de muestra del pabellón auricular.', 10.00),
       (27, 'Revisión física pre-vacunación', 'Exploración de ganglios, temperatura y mucosas.', 10.00),
       (28, 'Corte de uñas y pico', 'Recorte y limado de uñas.', 8.00),
       (29, 'Radiografía digital', 'Proyección abdominal para evaluar gas intestinal.', 40.00),
       (30, 'Coprológico por flotación', 'Examen de heces para coccidias.', 10.00),
       (31, 'Hemograma completo', 'Evaluación de rutina de células sanguíneas.', 15.00),
       (32, 'Revisión física pre-vacunación', 'Exploración de ganglios, temperatura y mucosas.', 10.00),
       (33, 'Evaluación nutricional', 'Análisis del peso corporal y elaboración de un plan alimenticio.', 20.00),
       (34, 'Coprológico por flotación', 'Examen de heces para descarte de parásitos.', 10.00),
       (35, 'Citología de piel', 'Tinción de muestra de la lesión nasal.', 12.00),
       (36, 'Retiro de suturas', 'Extracción de puntos de la herida quirúrgica y limpieza de la zona.', 15.00),
       (37, 'Retiro de suturas', 'Extracción de puntos y limpieza de la zona.', 15.00),
       (39, 'Nebulización', 'Terapia respiratoria para facilitar la eliminación de secreciones.', 20.00),
       (40, 'Evaluación nutricional', 'Seguimiento del plan alimenticio y evaluación del estado corporal.', 20.00);
go

-- ============================================================
-- 10° insert: tratamiento (45)
-- ============================================================
insert into tratamiento (id_diagnostico, fecha_inicio, fecha_fin, descripcion_t, indicaciones_t)
values (1, '2025-01-10', '2025-01-20', 'Tratamiento ótico tópico', 'Limpiar el oído antes de cada aplicación; no usar hisopos.'),
       (2, '2025-01-15', '2025-01-15', 'Esquema de vacunación anual', 'Reportar decaimiento o fiebre; refuerzo en un año.'),
       (3, '2025-01-20', '2025-04-20', 'Plan de reducción de peso', 'Pesar la ración exacta indicada; nada de premios.'),
       (4, '2025-01-25', '2025-01-30', 'Soporte digestivo y dieta blanda', 'Dieta blanda en porciones pequeñas por 5 días.'),
       (5, '2025-02-01', '2025-02-02', 'Plan preventivo', 'Repetir desparasitación cada 3 meses.'),
       (6, '2025-02-05', '2025-03-07', 'Control de pulgas y del prurito', 'Tratar a todas las mascotas de la casa y fumigar el ambiente.'),
       (7, '2025-02-10', '2025-02-24', 'Manejo del dolor y control de peso', 'Ejercicio suave; evitar escaleras.'),
       (8, '2025-02-15', '2025-03-17', 'Higiene dental preventiva', 'Cepillado dental diario.'),
       (9, '2025-02-20', '2025-03-02', 'Tratamiento de traqueobronquitis', 'Reposo; usar pechera; aislar de otros perros 7 días.'),
       (10, '2025-02-25', '2025-03-27', 'Plan de alimentación', 'Mantener la ración y pesar cada mes.'),
       (11, '2025-03-02', '2025-03-02', 'Esquema de vacunación anual', 'Evitar baños por 3 días; refuerzo en un año.'),
       (12, '2025-03-06', '2025-03-13', 'Tratamiento oftálmico', 'Aplicar la pomada rigurosamente en los horarios indicados.'),
       (13, '2025-03-10', '2025-03-20', 'Tratamiento de úlcera corneal', 'Uso obligatorio de collar isabelino las 24 horas.'),
       (14, '2025-03-15', '2025-04-26', 'Manejo postoperatorio de fractura', 'Reposo absoluto en jaula o espacio pequeño.'),
       (15, '2025-03-20', '2025-04-19', 'Desparasitación preventiva', 'Repetir la desparasitación interna cada 3 meses.'),
       (16, '2025-03-25', '2025-09-21', 'Tratamiento cardíaco de mantenimiento', 'Evitar emociones fuertes y ejercicio extremo.'),
       (17, '2025-04-01', '2025-04-02', 'Plan preventivo', 'Aumentar el consumo de agua colocando más fuentes.'),
       (18, '2025-04-05', '2025-05-05', 'Plan de alimentación', 'Mantener horarios fijos para la alimentación.'),
       (19, '2025-04-10', '2025-04-24', 'Tratamiento antifúngico tópico', 'Baños terapéuticos dejando actuar el champú 10 minutos.'),
       (20, '2025-04-15', '2025-05-15', 'Desparasitación preventiva', 'Verificar la eliminación de parásitos en el arenero.'),
       (21, '2026-06-18', '2026-06-28', 'Tratamiento de bronquitis', 'Evitar exposición a humo, polvo y ambientes fríos.'),
       (22, '2026-06-19', '2026-06-29', 'Tratamiento de soporte respiratorio felino', 'Mantener en ambiente cálido y limpiar secreción nasal.'),
       (23, '2026-06-20', '2026-07-04', 'Antibioterapia', 'Mantener la jaula limpia y sin corrientes de aire.'),
       (24, '2026-06-18', '2026-07-18', 'Control de pulgas y del prurito', 'Aplicar antipulgas y evitar contacto con pulgas del entorno.'),
       (25, '2026-06-19', '2026-08-18', 'Enriquecimiento ambiental y cambio de dieta', 'Dieta con pellets, frutas y verduras; más juguetes.'),
       (26, '2026-06-20', '2026-07-18', 'Tratamiento acaricida', 'Cambiar la cama de la jaula y desinfectarla.'),
       (27, '2026-06-18', '2026-06-18', 'Esquema de vacunación anual', 'Reportar decaimiento, fiebre o vómito.'),
       (28, '2026-06-19', '2026-07-19', 'Plan preventivo', 'Mantener dieta variada y luz natural.'),
       (29, '2026-06-20', '2026-06-27', 'Estimulación digestiva y analgesia', 'Ofrecer heno fresco; alimentación asistida si no come.'),
       (30, '2026-06-21', '2026-06-30', 'Tratamiento anticoccidial', 'Limpiar la jaula a diario.'),
       (31, '2026-01-08', '2026-02-07', 'Plan preventivo', 'Mantener una alimentación balanceada y control en seis meses.'),
       (32, '2026-02-15', '2026-02-15', 'Esquema de vacunación anual', 'Vigilar posibles reacciones durante 24 horas.'),
       (33, '2026-03-22', '2026-05-21', 'Plan de reducción de peso', 'Disminuir semillas y aumentar pellets y verduras.'),
       (34, '2026-04-10', '2026-04-17', 'Antibioterapia y soporte', 'Mantener la jaula limpia y seca.'),
       (35, '2026-05-18', '2026-05-28', 'Cambio de sustrato y tratamiento tópico', 'Usar papel sin tinta como sustrato.'),
       (36, '2026-07-06', '2026-07-06', 'Control postquirúrgico', 'Continuar con controles de rutina.'),
       (37, '2026-08-12', '2026-08-12', 'Control postquirúrgico', 'Mantener la zona limpia.'),
       (38, '2026-09-25', '2026-10-25', 'Plan preventivo', 'Baños de arena dos veces por semana.'),
       (39, '2026-10-14', '2026-10-28', 'Antibioterapia', 'Completar el antibiótico y evitar el frío.'),
       (40, '2026-10-28', '2026-11-27', 'Plan de alimentación', 'Heno a libre demanda y menos pellets.'),
       (44, '2025-05-05', '2025-05-19', 'Desparasitación', 'Lavar comederos y bebederos a diario.'),
       (46, '2025-05-15', '2025-05-25', 'Antibioterapia y calor', 'Mantener en ambiente cálido y sin corrientes de aire.'),
       (51, '2025-06-10', '2025-06-17', 'Antibioterapia y soporte', 'Mantener la jaula limpia y seca.'),
       (53, '2025-06-20', '2025-07-20', 'Tratamiento acaricida', 'Cambiar la cama de la jaula y desinfectarla.'),
       (54, '2025-06-25', '2025-06-28', 'Analgesia', 'Heno y ramas para roer a libre demanda.');
go

-- ============================================================
-- 11° insert: medicamentos (67)
-- 1-30: catálogo original | 31 en adelante: vacunas y medicamentos que
-- piden las enfermedades del documento
-- ============================================================
insert into medicamentos (nombre_m, presentacion_m, laboratorio_m, precio_m, stock_m)
values ('Epiotic Complete', 'Solución limpiadora ótica 125ml', 'Virbac', 18.50, 25),
       ('Synulox Tablets', 'Blíster 10 tabletas 250mg', 'Zoetis', 14.25, 40),
       ('Metonil Jarabe', 'Frasco 30ml', 'Calox', 8.00, 30),
       ('Bravecto Perros', 'Tableta masticable 20-40kg', 'MSD', 38.00, 15),
       ('Simparica Trio', 'Tableta masticable 5-10kg', 'Zoetis', 22.00, 20),
       ('Doxitabs', 'Blíster 10 tabletas 100mg', 'Veterina', 9.50, 50),
       ('Tobramicina Gotas', 'Frasco gotero oftálmico 5ml', 'Calox', 7.50, 25),
       ('Meloxicam Solución', 'Frasco gotas 10ml 0.5%', 'Drag Pharma', 11.20, 35),
       ('Enrofloxacina', 'Blíster 10 tabletas 150mg', 'Calox', 12.00, 45),
       ('Fortekor 5mg', 'Caja 28 tabletas', 'Elanco', 29.50, 12),
       ('Malaseb Champú', 'Frasco 250ml', 'Dechra', 24.00, 18),
       ('Drontal Plus', 'Tableta individual', 'Elanco', 4.50, 100),
       ('NexGard Spectra', 'Tableta masticable 2-3.5kg', 'Boehringer', 19.75, 22),
       ('Clindamicina', 'Caja 16 cápsulas 150mg', 'Drag Pharma', 13.10, 30),
       ('Ketosteril Vet', 'Caja 100 tabletas', 'Fresenius', 55.00, 8),
       ('Prednisolona 5mg', 'Blíster 10 tabletas', 'Calox', 4.20, 60),
       ('Cranberry Urinary', 'Frasco 60 tabletas masticables', 'Nutri-Vet', 21.50, 14),
       ('Tramadol Gotas', 'Frasco gotero 20ml', 'Drag Pharma', 13.40, 28),
       ('Amoxicilina + AC', 'Frasco suspensión 60ml', 'Zoetis', 16.50, 35),
       ('Canisulta', 'Ungüento dérmico 15g', 'Veterina', 9.00, 40),
       ('Cerenia', 'Caja 4 tabletas 24mg', 'Zoetis', 27.50, 18),
       ('Apoquel', 'Caja 20 tabletas 16mg', 'Zoetis', 48.00, 12),
       ('Aureomicina Oftálmica', 'Tubo 3.5g', 'Zoetis', 11.50, 25),
       ('Baytril', 'Blíster 10 tabletas 50mg', 'Elanco', 18.75, 30),
       ('Omeprazol Vet', 'Caja 14 cápsulas 20mg', 'Calox', 9.80, 40),
       ('Lactato de Ringer', 'Bolsa 500ml', 'Baxter', 6.50, 60),
       ('Atopica', 'Caja 15 cápsulas 50mg', 'Elanco', 62.00, 10),
       ('Rimadyl', 'Blíster 14 tabletas 50mg', 'Zoetis', 26.00, 22),
       ('Metronidazol Vet', 'Caja 20 tabletas 250mg', 'Drag Pharma', 14.50, 35),
       ('Mupirocina Ungüento', 'Tubo 15g', 'Calox', 8.90, 28),
       ('Vanguard Plus 5/L4', 'Vial 1 dosis', 'Zoetis', 18.00, 150),
       ('Nobivac Rabies', 'Vial 1 dosis', 'MSD', 9.00, 200),
       ('Felocell 3', 'Vial 1 dosis', 'Zoetis', 17.00, 80),
       ('Itrafungol', 'Solución oral 52ml 10mg/ml', 'Elanco', 45.00, 15),
       ('Itraconazol 100mg', 'Caja 15 cápsulas', 'Drag Pharma', 21.00, 30),
       ('Cefalexina 500mg', 'Caja 20 cápsulas', 'Calox', 11.00, 60),
       ('Ivermectina 1%', 'Frasco inyectable 50ml', 'Boehringer', 16.00, 20),
       ('Revolution Plus Gatos', 'Pipeta 2.5-5kg', 'Zoetis', 19.00, 40),
       ('Frontline Plus', 'Pipeta perro 10-20kg', 'Boehringer', 14.50, 50),
       ('Capstar', 'Caja 6 tabletas 11.4mg', 'Elanco', 15.00, 30),
       ('Negasunt', 'Polvo cicatrizante 20g', 'Elanco', 6.50, 40),
       ('Imizol', 'Frasco inyectable 10ml', 'MSD', 28.00, 10),
       ('Otomax', 'Suspensión ótica 15g', 'MSD', 19.50, 25),
       ('Panacur 10%', 'Suspensión oral 100ml', 'MSD', 14.00, 30),
       ('Drontal Gatos', 'Tableta individual', 'Elanco', 4.25, 80),
       ('FortiFlora', 'Caja 30 sobres', 'Purina', 24.00, 20),
       ('Ceftriaxona 1g', 'Vial inyectable', 'Calox', 3.50, 100),
       ('Metoclopramida 5mg/ml', 'Frasco inyectable 20ml', 'Calox', 3.50, 30),
       ('Dexametasona 2mg/ml', 'Frasco inyectable 10ml', 'Calox', 5.00, 40),
       ('Clorhexidina 2%', 'Solución antiséptica 250ml', 'Calox', 4.75, 50),
       ('Bromhexina Jarabe', 'Frasco 120ml', 'Calox', 6.00, 40),
       ('Viralys', 'Gel oral 150g', 'Virbac', 18.00, 15),
       ('Hemolitan Gold', 'Frasco 60ml', 'Vetnil', 12.00, 25),
       ('Metamizol 50%', 'Frasco inyectable 20ml', 'Calox', 4.50, 40),
       ('Vetmedin 5mg', 'Caja 50 cápsulas', 'Boehringer', 52.00, 8),
       ('Furosemida 40mg', 'Caja 20 tabletas', 'Calox', 3.80, 50),
       ('Fenobarbital 100mg', 'Caja 30 tabletas', 'Drag Pharma', 7.50, 20),
       ('Atenolol 25mg', 'Caja 30 tabletas', 'Calox', 4.00, 20),
       ('Baycox 2.5%', 'Frasco 100ml', 'Elanco', 21.00, 10),
       ('Critical Care', 'Bolsa 141g', 'Oxbow', 16.00, 12),
       ('Repti Calcium con D3', 'Frasco 85g', 'Zoo Med', 9.00, 20),
       ('Gluconato de Calcio 10%', 'Frasco inyectable 100ml', 'Calox', 6.00, 15),
       ('Sulfadiazina de Plata 1%', 'Tubo 30g', 'Drag Pharma', 5.50, 30),
       ('Trazodona 50mg', 'Caja 30 tabletas', 'Drag Pharma', 6.00, 20),
       ('Caninsulin', 'Vial 10ml 40 UI/ml', 'MSD', 48.00, 5),
       ('Carbón Activado', 'Frasco 100g polvo', 'Calox', 5.00, 20),
       ('Azul de Metileno 1%', 'Frasco 30ml', 'API', 4.00, 15);
go

-- ============================================================
-- 12° insert: detalles_tratamientos
-- id_detalle_tratamiento es el número de renglón dentro de cada tratamiento
-- ============================================================
insert into detalles_tratamientos (id_detalle_tratamiento, id_tratamiento, id_medicamento, dosis_dt, frecuencia_dt,
                                   duracion_dias_dt)
values (1, 1, 1, 'Llenar el conducto y masajear la base de la oreja', 'Cada 24 horas', 10),  -- Epiotic Complete
       (2, 1, 43, '4 gotas por oído afectado', 'Cada 12 horas', 7),  -- Otomax
       (1, 2, 31, '1 ml subcutánea', 'Dosis única', 1),  -- Vanguard Plus 5/L4
       (2, 2, 32, '1 ml subcutánea', 'Dosis única', 1),  -- Nobivac Rabies
       (1, 4, 29, '15 mg/kg vía oral', 'Cada 12 horas', 5),  -- Metronidazol Vet
       (2, 4, 25, '1 mg/kg vía oral', 'Cada 24 horas', 5),  -- Omeprazol Vet
       (1, 5, 12, '1 tableta por cada 10 kg', 'Dosis única', 1),  -- Drontal Plus
       (1, 6, 13, '1 tableta masticable', 'Cada 30 días', 30),  -- NexGard Spectra
       (2, 6, 16, '0.5 mg/kg vía oral', 'Cada 24 horas', 7),  -- Prednisolona 5mg
       (1, 7, 28, '2 mg/kg vía oral', 'Cada 12 horas', 14),  -- Rimadyl
       (1, 9, 6, '5 mg/kg vía oral', 'Cada 12 horas', 10),  -- Doxitabs
       (2, 9, 51, '1 ml por cada 5 kg vía oral', 'Cada 12 horas', 7),  -- Bromhexina Jarabe
       (1, 11, 33, '1 ml subcutánea', 'Dosis única', 1),  -- Felocell 3
       (2, 11, 32, '1 ml subcutánea', 'Dosis única', 1),  -- Nobivac Rabies
       (1, 12, 23, 'Aplicar en ojo izquierdo', 'Cada 8 horas', 7),  -- Aureomicina Oftálmica
       (1, 13, 7, '1 gota en ojo derecho', 'Cada 6 horas', 10),  -- Tobramicina Gotas
       (1, 14, 14, '11 mg/kg vía oral', 'Cada 12 horas', 10),  -- Clindamicina
       (2, 14, 8, '0.05 mg/kg vía oral', 'Cada 24 horas', 4),  -- Meloxicam Solución
       (3, 14, 18, '2 mg/kg vía oral', 'Cada 12 horas', 7),  -- Tramadol Gotas
       (1, 15, 45, '1 tableta por cada 4 kg', 'Dosis única', 1),  -- Drontal Gatos
       (2, 15, 38, '1 pipeta en la nuca', 'Cada 30 días', 30),  -- Revolution Plus Gatos
       (1, 16, 58, '6.25 mg por gato vía oral', 'Cada 24 horas', 180),  -- Atenolol 25mg
       (1, 17, 45, '1 tableta por cada 4 kg', 'Dosis única', 1),  -- Drontal Gatos
       (1, 19, 11, 'Baño completo', 'Dos veces por semana', 14),  -- Malaseb Champú
       (1, 20, 38, '1 pipeta en la nuca', 'Cada 30 días', 30),  -- Revolution Plus Gatos
       (2, 20, 45, '1 tableta por cada 4 kg', 'Dosis única', 1),  -- Drontal Gatos
       (1, 21, 6, '5 mg/kg vía oral', 'Cada 12 horas', 10),  -- Doxitabs
       (2, 21, 51, '1 ml por cada 5 kg vía oral', 'Cada 12 horas', 7),  -- Bromhexina Jarabe
       (1, 22, 6, '10 mg/kg vía oral', 'Cada 24 horas', 10),  -- Doxitabs
       (2, 22, 8, '0.05 mg/kg vía oral', 'Cada 24 horas', 3),  -- Meloxicam Solución
       (1, 23, 24, '10 mg/kg vía oral', 'Cada 24 horas', 14),  -- Baytril
       (2, 23, 8, '0.5 mg/kg vía oral', 'Cada 24 horas', 5),  -- Meloxicam Solución
       (1, 24, 13, '1 tableta masticable', 'Cada 30 días', 30),  -- NexGard Spectra
       (2, 24, 16, '0.5 mg/kg vía oral', 'Cada 24 horas', 7),  -- Prednisolona 5mg
       (1, 26, 37, '0.4 mg/kg subcutánea', 'Cada 14 días (3 aplicaciones)', 28),  -- Ivermectina 1%
       (2, 26, 8, '0.5 mg/kg vía oral', 'Cada 24 horas', 5),  -- Meloxicam Solución
       (1, 27, 33, '1 ml subcutánea', 'Dosis única', 1),  -- Felocell 3
       (2, 27, 32, '1 ml subcutánea', 'Dosis única', 1),  -- Nobivac Rabies
       (1, 29, 48, '0.5 mg/kg subcutánea', 'Cada 8 horas', 3),  -- Metoclopramida 5mg/ml
       (2, 29, 8, '0.5 mg/kg vía oral', 'Cada 24 horas', 5),  -- Meloxicam Solución
       (3, 29, 60, 'Alimentación asistida con jeringa', 'Cuatro veces al día', 7),  -- Critical Care
       (1, 30, 59, '5 mg/kg vía oral', 'Cada 24 horas por 2 días, repetir a los 7 días', 9),  -- Baycox 2.5%
       (2, 30, 60, 'Alimentación asistida con jeringa', 'Cuatro veces al día', 7),  -- Critical Care
       (1, 31, 12, '1 tableta por cada 10 kg', 'Dosis única', 1),  -- Drontal Plus
       (2, 31, 13, '1 tableta masticable', 'Cada 30 días', 30),  -- NexGard Spectra
       (1, 32, 33, '1 ml subcutánea', 'Dosis única', 1),  -- Felocell 3
       (2, 32, 32, '1 ml subcutánea', 'Dosis única', 1),  -- Nobivac Rabies
       (1, 34, 24, '10 mg/kg vía oral', 'Cada 24 horas', 7),  -- Baytril
       (2, 34, 60, 'Alimentación asistida con jeringa', 'Cuatro veces al día', 7),  -- Critical Care
       (1, 35, 30, 'Capa fina sobre la lesión', 'Cada 12 horas', 10),  -- Mupirocina Ungüento
       (1, 39, 24, '10 mg/kg vía oral', 'Cada 24 horas', 14),  -- Baytril
       (2, 39, 8, '0.5 mg/kg vía oral', 'Cada 24 horas', 5),  -- Meloxicam Solución
       (1, 41, 44, '20 mg/kg vía oral', 'Dosis única, repetir a los 14 días', 14),  -- Panacur 10%
       (1, 42, 24, '15 mg/kg vía oral', 'Cada 12 horas', 10),  -- Baytril
       (1, 43, 24, '10 mg/kg vía oral', 'Cada 24 horas', 7),  -- Baytril
       (2, 43, 60, 'Alimentación asistida con jeringa', 'Cuatro veces al día', 7),  -- Critical Care
       (1, 44, 37, '0.4 mg/kg subcutánea', 'Cada 10 días (3 aplicaciones)', 30),  -- Ivermectina 1%
       (1, 45, 8, '0.5 mg/kg vía oral', 'Cada 24 horas', 3);  -- Meloxicam Solución
go

-- ============================================================
-- 13° insert: facturas (30)
-- total_f = suma de sus renglones
-- ============================================================
insert into facturas (id_cita, fecha_emision_f, estado_f, total_f)
values (1, '2025-01-10', 'Pagada', 95.00),
       (2, '2025-01-15', 'Pagada', 52.00),
       (3, '2025-01-20', 'Pagada', 45.00),
       (4, '2025-01-25', 'Pagada', 79.30),
       (5, '2025-02-01', 'Pagada', 39.50),
       (6, '2025-02-05', 'Pagada', 63.95),
       (7, '2025-02-10', 'Pagada', 101.00),
       (8, '2025-02-15', 'Pagada', 40.00),
       (9, '2025-02-20', 'Pagada', 65.50),
       (10, '2025-02-25', 'Pagada', 40.00),
       (12, '2025-03-06', 'Pagada', 49.50),
       (13, '2025-03-10', 'Pagada', 45.50),
       (14, '2025-03-15', 'Pagada', 467.70),
       (16, '2025-03-25', 'Pagada', 114.00),
       (19, '2025-04-10', 'Pagada', 66.00),
       (24, '2025-05-05', 'Pagada', 44.00),
       (26, '2025-05-15', 'Pagada', 48.75),
       (31, '2025-06-10', 'Pagada', 64.75),
       (34, '2025-06-25', 'Pagada', 41.20),
       (35, '2025-06-28', 'Pagada', 25.00),
       (61, '2026-01-08', 'Pagada', 59.25),
       (62, '2026-02-15', 'Pagada', 51.00),
       (63, '2026-03-22', 'Pagada', 45.00),
       (64, '2026-04-10', 'Pagada', 74.75),
       (65, '2026-05-18', 'Pagada', 50.90),
       (66, '2026-07-06', 'Pagada', 30.00),
       (67, '2026-08-12', 'Pagada', 40.00),
       (68, '2026-09-25', 'Pagada', 25.00),
       (69, '2026-10-14', 'Pagada', 79.95),
       (70, '2026-10-28', 'Pendiente', 45.00);
go

-- ============================================================
-- 14° insert: detalles_facturas
-- id_detalle_factura es el número de renglón dentro de cada factura:
-- consulta, procedimientos y medicamentos del tratamiento
-- ============================================================
insert into detalles_facturas (id_detalle_factura, id_factura, id_cita, id_medicamento, id_tratamiento,
                               id_procedimiento, descripcion_df, cantidad_df, precio_unit_df)
values (1, 1, 1, null, null, null, 'Costo de atención - Sacude la cabeza y le huelen las orejas', 1, 30.00),
       (2, 1, null, null, null, 1, 'Procedimiento clínico: Citología ótica', 1, 12.00),
       (3, 1, null, null, null, 2, 'Procedimiento clínico: Limpieza ótica profunda', 1, 15.00),
       (4, 1, null, 1, 1, null, 'Medicamento: Epiotic Complete (Solución limpiadora ótica 125ml)', 1, 18.50),
       (5, 1, null, 43, 1, null, 'Medicamento: Otomax (Suspensión ótica 15g)', 1, 19.50),
       (1, 2, 2, null, null, null, 'Costo de atención - Vacunación anual', 1, 15.00),
       (2, 2, null, null, null, 3, 'Procedimiento clínico: Revisión física pre-vacunación', 1, 10.00),
       (3, 2, null, 31, 2, null, 'Medicamento: Vanguard Plus 5/L4 (Vial 1 dosis)', 1, 18.00),
       (4, 2, null, 32, 2, null, 'Medicamento: Nobivac Rabies (Vial 1 dosis)', 1, 9.00),
       (1, 3, 3, null, null, null, 'Costo de atención - Control de peso', 1, 25.00),
       (2, 3, null, null, null, 4, 'Procedimiento clínico: Evaluación nutricional', 1, 20.00),
       (1, 4, 4, null, null, null, 'Costo de atención - Vómito y diarrea', 1, 20.00),
       (2, 4, null, null, null, 5, 'Procedimiento clínico: Fluidoterapia ambulatoria', 1, 25.00),
       (3, 4, null, null, null, 6, 'Procedimiento clínico: Coprológico por flotación', 1, 10.00),
       (4, 4, null, 29, 4, null, 'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
       (5, 4, null, 25, 4, null, 'Medicamento: Omeprazol Vet (Caja 14 cápsulas 20mg)', 1, 9.80),
       (1, 5, 5, null, null, null, 'Costo de atención - Chequeo general', 1, 20.00),
       (2, 5, null, null, null, 7, 'Procedimiento clínico: Hemograma completo de control', 1, 15.00),
       (3, 5, null, 12, 5, null, 'Medicamento: Drontal Plus (Tableta individual)', 1, 4.50),
       (1, 6, 6, null, null, null, 'Costo de atención - Se rasca mucho la espalda y la cola', 1, 30.00),
       (2, 6, null, null, null, 8, 'Procedimiento clínico: Raspado de piel superficial', 1, 10.00),
       (3, 6, null, 13, 6, null, 'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
       (4, 6, null, 16, 6, null, 'Medicamento: Prednisolona 5mg (Blíster 10 tabletas)', 1, 4.20),
       (1, 7, 7, null, null, null, 'Costo de atención - Cojea de las patas traseras', 1, 35.00),
       (2, 7, null, null, null, 9, 'Procedimiento clínico: Radiografía digital', 1, 40.00),
       (3, 7, null, 28, 7, null, 'Medicamento: Rimadyl (Blíster 14 tabletas 50mg)', 1, 26.00),
       (1, 8, 8, null, null, null, 'Costo de atención - Chequeo general', 1, 20.00),
       (2, 8, null, null, null, 10, 'Procedimiento clínico: Limpieza dental preventiva básica', 1, 20.00),
       (1, 9, 9, null, null, null, 'Costo de atención - Tos seca como si se atorara', 1, 20.00),
       (2, 9, null, null, null, 11, 'Procedimiento clínico: Radiografía de tórax', 1, 30.00),
       (3, 9, null, 6, 9, null, 'Medicamento: Doxitabs (Blíster 10 tabletas 100mg)', 1, 9.50),
       (4, 9, null, 51, 9, null, 'Medicamento: Bromhexina Jarabe (Frasco 120ml)', 1, 6.00),
       (1, 10, 10, null, null, null, 'Costo de atención - Control de peso', 1, 20.00),
       (2, 10, null, null, null, 12, 'Procedimiento clínico: Evaluación nutricional', 1, 20.00),
       (1, 11, 12, null, null, null, 'Costo de atención - Ojo rojo con lagañas', 1, 30.00),
       (2, 11, null, null, null, 14, 'Procedimiento clínico: Limpieza ocular con suero', 1, 8.00),
       (3, 11, null, 23, 12, null, 'Medicamento: Aureomicina Oftálmica (Tubo 3.5g)', 1, 11.50),
       (1, 12, 13, null, null, null, 'Costo de atención - No abre un ojo', 1, 30.00),
       (2, 12, null, null, null, 15, 'Procedimiento clínico: Prueba de fluoresceína', 1, 8.00),
       (3, 12, null, 7, 13, null, 'Medicamento: Tobramicina Gotas (Frasco gotero oftálmico 5ml)', 1, 7.50),
       (1, 13, 14, null, null, null, 'Costo de atención - No apoya la pata después de un accidente', 1, 40.00),
       (2, 13, null, null, null, 16, 'Procedimiento clínico: Radiografía digital', 1, 40.00),
       (3, 13, null, null, null, 17, 'Procedimiento clínico: Cirugía ortopédica - Osteosíntesis', 1, 350.00),
       (4, 13, null, 14, 14, null, 'Medicamento: Clindamicina (Caja 16 cápsulas 150mg)', 1, 13.10),
       (5, 13, null, 8, 14, null, 'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 1, 11.20),
       (6, 13, null, 18, 14, null, 'Medicamento: Tramadol Gotas (Frasco gotero 20ml)', 1, 13.40),
       (1, 14, 16, null, null, null, 'Costo de atención - Evaluación cardiológica', 1, 45.00),
       (2, 14, null, null, null, 19, 'Procedimiento clínico: Ecocardiograma Doppler', 1, 65.00),
       (3, 14, null, 58, 16, null, 'Medicamento: Atenolol 25mg (Caja 30 tabletas)', 1, 4.00),
       (1, 15, 19, null, null, null, 'Costo de atención - Mal olor en la piel y picazón', 1, 30.00),
       (2, 15, null, null, null, 22, 'Procedimiento clínico: Citología de piel', 1, 12.00),
       (3, 15, null, 11, 19, null, 'Medicamento: Malaseb Champú (Frasco 250ml)', 1, 24.00),
       (1, 16, 24, null, null, null, 'Costo de atención - Heces mal formadas y plumas erizadas', 1, 30.00),
       (2, 16, null, 44, 41, null, 'Medicamento: Panacur 10% (Suspensión oral 100ml)', 1, 14.00),
       (1, 17, 26, null, null, null, 'Costo de atención - Respira con la cola y está esponjado', 1, 30.00),
       (2, 17, null, 24, 42, null, 'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 1, 18.75),
       (1, 18, 31, null, null, null, 'Costo de atención - Tiene la cola mojada y diarrea', 1, 30.00),
       (2, 18, null, 24, 43, null, 'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 1, 18.75),
       (3, 18, null, 60, 43, null, 'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
       (1, 19, 34, null, null, null, 'Costo de atención - No puede comer', 1, 30.00),
       (2, 19, null, 8, 45, null, 'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 1, 11.20),
       (1, 20, 35, null, null, null, 'Costo de atención - Control de rutina', 1, 25.00),
       (1, 21, 61, null, null, null, 'Costo de atención - Chequeo general', 1, 20.00),
       (2, 21, null, null, null, 34, 'Procedimiento clínico: Hemograma completo', 1, 15.00),
       (3, 21, null, 12, 31, null, 'Medicamento: Drontal Plus (Tableta individual)', 1, 4.50),
       (4, 21, null, 13, 31, null, 'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
       (1, 22, 62, null, null, null, 'Costo de atención - Vacunación anual', 1, 15.00),
       (2, 22, null, null, null, 35, 'Procedimiento clínico: Revisión física pre-vacunación', 1, 10.00),
       (3, 22, null, 33, 32, null, 'Medicamento: Felocell 3 (Vial 1 dosis)', 1, 17.00),
       (4, 22, null, 32, 32, null, 'Medicamento: Nobivac Rabies (Vial 1 dosis)', 1, 9.00),
       (1, 23, 63, null, null, null, 'Costo de atención - Control de peso', 1, 25.00),
       (2, 23, null, null, null, 36, 'Procedimiento clínico: Evaluación nutricional', 1, 20.00),
       (1, 24, 64, null, null, null, 'Costo de atención - Diarrea', 1, 30.00),
       (2, 24, null, null, null, 37, 'Procedimiento clínico: Coprológico por flotación', 1, 10.00),
       (3, 24, null, 24, 34, null, 'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 1, 18.75),
       (4, 24, null, 60, 34, null, 'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
       (1, 25, 65, null, null, null, 'Costo de atención - Picazón en la nariz', 1, 30.00),
       (2, 25, null, null, null, 38, 'Procedimiento clínico: Citología de piel', 1, 12.00),
       (3, 25, null, 30, 35, null, 'Medicamento: Mupirocina Ungüento (Tubo 15g)', 1, 8.90),
       (1, 26, 66, null, null, null, 'Costo de atención - Retiro de puntos de esterilización', 1, 15.00),
       (2, 26, null, null, null, 39, 'Procedimiento clínico: Retiro de suturas', 1, 15.00),
       (1, 27, 67, null, null, null, 'Costo de atención - Control postoperatorio', 1, 25.00),
       (2, 27, null, null, null, 40, 'Procedimiento clínico: Retiro de suturas', 1, 15.00),
       (1, 28, 68, null, null, null, 'Costo de atención - Control de rutina', 1, 25.00),
       (1, 29, 69, null, null, null, 'Costo de atención - Estornuda y tiene moco', 1, 30.00),
       (2, 29, null, null, null, 41, 'Procedimiento clínico: Nebulización', 1, 20.00),
       (3, 29, null, 24, 39, null, 'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 1, 18.75),
       (4, 29, null, 8, 39, null, 'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 1, 11.20),
       (1, 30, 70, null, null, null, 'Costo de atención - Control de peso', 1, 25.00),
       (2, 30, null, null, null, 42, 'Procedimiento clínico: Evaluación nutricional', 1, 20.00);
go


/* ============================================================
   CARGA MASIVA (datos sintéticos deterministas)
   Sigue el documento "Plan de backups y consultas de la clínica":

   - Año de operación 2 (nov-2025 a oct-2026): 25,000 consultas
     atendidas, igual que el documento por mes (sección 3), por día
     y hora de cada temporada (secciones 4 a 6) y por enfermedad de
     cada mes (sección 8.4).
   - Año de operación 1 (nov-2024 a oct-2025): el mismo patrón con
     8% menos consultas (la clínica crece de un año a otro).
   - Fecha de corte: sábado 31/10/2026. Después solo hay citas
     programadas (noviembre 2026).
   - Horario: lunes a sábado 7:00-20:00; domingo 7:00-13:00.
   - Las citas completadas de los datos base cuentan dentro de los
     totales; aquí se genera el resto.
   - Sin rand(): mismas filas en cada instalación.
     Si no se quiere el volumen, borrar esta sección.
   ============================================================ */
use [ClinicaVeterinaria]
go
set nocount on
go

/* ------------------------------------------------------------
   0. tablas auxiliares
   ------------------------------------------------------------ */
-- números 1..100000
select top (100000) cast(row_number() over (order by (select null)) as int) as n
into #n
from (values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) a(x)
cross join (values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) b(x)
cross join (values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) c(x)
cross join (values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) d(x)
cross join (values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9)) e(x);

-- años de operación (pct = porcentaje de las consultas del documento)
create table #anio (anio_op int, inicio date, fin date, pct int);
insert into #anio (anio_op, inicio, fin, pct)
values (1, '2024-11-01', '2025-10-31', 92),
       (2, '2025-11-01', '2026-10-31', 100);
go

/* ------------------------------------------------------------
   1. datos del documento
   ------------------------------------------------------------ */
-- 1.1 consultas por mes y temporada (sección 3)
create table #mes (mes int, temporada varchar(10), consultas int);
insert into #mes (mes, temporada, consultas)
values ( 1, 'normal',  1673),  -- Enero
       ( 2, 'baja',    1280),  -- Febrero
       ( 3, 'normal',  1772),  -- Marzo
       ( 4, 'baja',    1476),  -- Abril
       ( 5, 'normal',  2165),  -- Mayo
       ( 6, 'alta',    2658),  -- Junio
       ( 7, 'alta',    2559),  -- Julio
       ( 8, 'alta',    2362),  -- Agosto
       ( 9, 'normal',  2067),  -- Septiembre
       (10, 'normal',  2165),  -- Octubre
       (11, 'normal',  1870),  -- Noviembre
       (12, 'alta',    2953);  -- Diciembre

-- 1.2 consultas por hora y día de cada temporada (secciones 4, 5 y 6)
--     cada fila es la hora de inicio de la franja; domingo cierra a las 13:00
create table #franja_doc (temporada varchar(10), hora int, lun int, mar int, mie int, jue int, vie int, sab int, dom int);
insert into #franja_doc (temporada, hora, lun, mar, mie, jue, vie, sab, dom)
values ('alta',    7,  63,  51,  47,  47,  51,  63,  50),
       ('alta',    8, 147, 118, 111, 111, 118, 126, 101),
       ('alta',    9, 211, 168, 158, 158, 168, 177, 139),
       ('alta',   10, 253, 202, 190, 190, 202, 202, 152),
       ('alta',   11, 274, 219, 205, 205, 219, 215, 114),
       ('alta',   12, 232, 185, 174, 174, 185, 177,  76),
       ('alta',   13, 126, 101,  95,  95, 101, 101,   0),
       ('alta',   14, 126, 101,  95,  95, 101,  51,   0),
       ('alta',   15, 190, 152, 142, 142, 152,  51,   0),
       ('alta',   16, 190, 152, 142, 142, 152,  38,   0),
       ('alta',   17, 147, 118, 111, 111, 118,  25,   0),
       ('alta',   18,  84,  67,  63,  63,  67,  25,   0),
       ('alta',   19,  63,  51,  47,  47,  51,  13,   0),
       ('normal',  7,  70,  56,  53,  53,  56,  70,  56),
       ('normal',  8, 164, 131, 123, 123, 131, 141, 112),
       ('normal',  9, 234, 187, 176, 176, 187, 197, 155),
       ('normal', 10, 281, 225, 211, 211, 225, 225, 169),
       ('normal', 11, 304, 244, 228, 228, 244, 239, 127),
       ('normal', 12, 258, 206, 193, 193, 206, 197,  84),
       ('normal', 13, 141, 113, 106, 106, 113, 112,   0),
       ('normal', 14, 140, 112, 105, 105, 112,  56,   0),
       ('normal', 15, 211, 169, 158, 158, 169,  56,   0),
       ('normal', 16, 211, 169, 158, 158, 169,  42,   0),
       ('normal', 17, 164, 131, 123, 123, 131,  28,   0),
       ('normal', 18,  94,  75,  70,  70,  75,  28,   0),
       ('normal', 19,  70,  56,  53,  53,  56,  14,   0),
       ('baja',    7,  16,  13,  12,  12,  13,  17,  13),
       ('baja',    8,  39,  31,  29,  29,  31,  33,  26),
       ('baja',    9,  55,  44,  41,  41,  44,  46,  36),
       ('baja',   10,  66,  53,  50,  50,  53,  53,  40),
       ('baja',   11,  72,  57,  54,  54,  57,  56,  30),
       ('baja',   12,  61,  49,  46,  45,  49,  46,  20),
       ('baja',   13,  33,  26,  25,  25,  26,  27,   0),
       ('baja',   14,  33,  26,  25,  25,  26,  13,   0),
       ('baja',   15,  50,  40,  37,  37,  40,  13,   0),
       ('baja',   16,  50,  40,  37,  37,  40,  10,   0),
       ('baja',   17,  38,  31,  29,  29,  31,   7,   0),
       ('baja',   18,  22,  18,  17,  17,  18,   7,   0),
       ('baja',   19,  16,  13,  12,  12,  13,   3,   0);

-- una fila por temporada, día (1 = lunes ... 7 = domingo) y hora
select f.temporada, d.dia, f.hora,
       case d.dia when 1 then f.lun when 2 then f.mar when 3 then f.mie when 4 then f.jue
                  when 5 then f.vie when 6 then f.sab else f.dom end as cantidad
into #franja
from #franja_doc f
cross join (values (1), (2), (3), (4), (5), (6), (7)) d(dia);

-- 1.3 enfermedades del documento (sección 8)
--     el nombre de 1 a 12 es el que se guarda en diagnosticos.descripcion_d
create table #categoria (id_categoria int, nombre varchar(60));
insert into #categoria (id_categoria, nombre)
values ( 1, 'Dermatofitosis (tiña)'),
       ( 2, 'Dermatitis alérgica'),
       ( 3, 'Sarna y pioderma'),
       ( 4, 'Pulgas y garrapatas'),
       ( 5, 'Ehrlichiosis y hemoparásitos'),
       ( 6, 'Parvovirus'),
       ( 7, 'Gastroenteritis y parásitos intestinales'),
       ( 8, 'Otitis'),
       ( 9, 'Moquillo y problemas respiratorios'),
       (10, 'Heridas y traumas'),
       (11, 'Golpe de calor'),
       (12, 'Miasis (gusano barrenador)'),
       (13, 'Vacunación y controles'),
       (14, 'Otros');

-- 1.4 casos estimados por enfermedad y mes (sección 8.4)
create table #casos_doc (mes int, dermatofitosis int, dermatitis int, sarna int, pulgas int, ehrlichiosis int,
                         parvovirus int, gastroenteritis int, otitis int, moquillo int, heridas int,
                         golpe_calor int, miasis int, vacunacion int, otros int);
insert into #casos_doc (mes, dermatofitosis, dermatitis, sarna, pulgas, ehrlichiosis, parvovirus, gastroenteritis,
                        otitis, moquillo, heridas, golpe_calor, miasis, vacunacion, otros)
values ( 1,  75,  62,  25,  86,  87,  86, 129,  62, 129,  64,  36,  14, 514, 304),
       ( 2,  57,  48,  19,  55,  57,  66,  98,  48,  76,  49,  41,   8, 426, 232),
       ( 3,  88,  73,  29,  88,  90,  88, 132,  73,  73,  73, 110,  15, 528, 312),
       ( 4,  72,  60,  24,  84,  84,  81, 108,  60,  54,  78, 105,  15, 396, 255),
       ( 5, 140, 117,  47, 233, 163, 128, 171, 117,  70,  78,  58,  47, 466, 330),
       ( 6, 210, 175,  70, 350, 245, 144, 227, 164,  87,  87,  22,  87, 419, 371),
       ( 7, 202, 169,  68, 337, 236, 139, 219, 158,  84,  84,  17,  84, 404, 358),
       ( 8, 176, 147,  59, 298, 219, 129, 204, 147,  78,  78,  16,  78, 400, 333),
       ( 9, 161, 134,  53, 241, 199, 120, 188, 126,  67,  67,  10,  74, 342, 285),
       (10, 170, 141,  56, 240, 210, 127, 198, 132,  78,  71,  11,  71, 360, 300),
       (11, 108,  90,  36, 144, 151, 108, 144,  90, 100,  72,  18,  29, 475, 305),
       (12, 139, 116,  46, 185, 162, 156, 277, 115, 185, 324,  35,  29, 693, 491);

select c.mes, k.id_categoria,
       case k.id_categoria when 1 then c.dermatofitosis when 2 then c.dermatitis when 3 then c.sarna
                           when 4 then c.pulgas when 5 then c.ehrlichiosis when 6 then c.parvovirus
                           when 7 then c.gastroenteritis when 8 then c.otitis when 9 then c.moquillo
                           when 10 then c.heridas when 11 then c.golpe_calor when 12 then c.miasis
                           when 13 then c.vacunacion else c.otros end as casos
into #casos
from #casos_doc c
cross join #categoria k;
go

/* ------------------------------------------------------------
   2. catálogo clínico
   Cada diagnóstico indica la especie, el motivo con que llega la
   mascota, la especialidad que la atiende, los procedimientos y el
   tratamiento con sus medicamentos.
     peso     = frecuencia dentro de su enfermedad
     peso_dic = frecuencia en diciembre (pólvora)
     edad     = 'cria': cachorro o gatito nuevo | 'senior': 8 años o más
     proc2    = se hace en pct_proc2 % de los casos
   ------------------------------------------------------------ */
create table #dx (
    id_dx int, id_categoria int, especie varchar(30), sexo varchar(10), edad varchar(10),
    peso decimal(6, 2), peso_dic decimal(6, 2), descripcion varchar(100),
    observaciones varchar(300),
    motivo varchar(100), especialidad varchar(150), costo decimal(10, 2), proc1 varchar(20), proc2 varchar(20),
    pct_proc2 int,
    tratamiento varchar(100),
    indicaciones varchar(200), dias int);
insert into #dx
values (  1,  1, 'Canino', null, null, 55, 55, 'Dermatofitosis (tiña)',
         'Lesiones circulares sin pelo con descamación en cabeza y patas; lámpara de Wood positiva (Microsporum canis).',
         'Zonas sin pelo y costras en la piel', 'Dermatología Veterinaria', 30, 'WOOD', 'TRICOGRAMA', 50,
         'Tratamiento antifúngico oral y tópico',
         'Bañar dos veces por semana; lavar camas y aspirar la casa. Es contagiosa para personas: usar guantes.', 42),
       (  2,  1, 'Canino', null, null, 15, 15, 'Dermatofitosis (tiña)',
         'Costras en hocico y patas delanteras; cultivo positivo a Microsporum gypseum (contagio desde la tierra).',
         'Costras en la nariz y las patas', 'Dermatología Veterinaria', 30, 'CULTIVO', 'TRICOGRAMA', 50,
         'Tratamiento antifúngico oral y tópico',
         'Bañar dos veces por semana; lavar camas y aspirar la casa. Es contagiosa para personas: usar guantes.', 42),
       (  3,  1, 'Felino', null, null, 26, 26, 'Dermatofitosis (tiña)',
         'Alopecia en cabeza, orejas y patas; lámpara de Wood positiva (Microsporum canis).',
         'Se le cae el pelo en la cabeza y las orejas', 'Dermatología Veterinaria', 30, 'WOOD', 'CULTIVO', 40,
         'Tratamiento antifúngico oral y tópico',
         'Tratar a todos los gatos de la casa; aspirar a diario y lavar camas con cloro. Es contagiosa para personas.', 42),
       (  4,  1, 'Conejo', null, null, 2, 2, 'Dermatofitosis (tiña)',
         'Descamación y alopecia alrededor de ojos y orejas; cultivo positivo a Trichophyton mentagrophytes.',
         'Se le cae el pelo alrededor de los ojos', 'Medicina de Animales Exóticos', 30, 'CULTIVO', null, 0,
         'Tratamiento antifúngico',
         'Desinfectar la jaula; usar guantes al manipularlo.', 28),
       (  5,  1, 'Roedor', null, null, 2, 2, 'Dermatofitosis (tiña)',
         'Alopecia y costras en cara y dorso; cultivo positivo a Trichophyton mentagrophytes.',
         'Se le cae el pelo de la cara', 'Medicina de Animales Exóticos', 30, 'CULTIVO', null, 0,
         'Tratamiento antifúngico',
         'Desinfectar la jaula; usar guantes al manipularlo.', 28),
       (  6,  2, 'Canino', null, null, 38, 38, 'Dermatitis alérgica',
         'Dermatitis alérgica por picadura de pulga (DAPP): prurito y pápulas en zona lumbar y base de la cola.',
         'Se rasca mucho la espalda y la cola', 'Dermatología Veterinaria', 30, 'CITO_PIEL', null, 0,
         'Control de pulgas y del prurito',
         'Tratar a todas las mascotas de la casa y fumigar patio y paredes; lavar camas con agua caliente.', 30),
       (  7,  2, 'Canino', null, null, 25, 25, 'Dermatitis alérgica',
         'Dermatitis atópica: prurito en patas, axilas y cara con brotes en temporada de lluvias.',
         'Se lame las patas y tiene la piel roja', 'Dermatología Veterinaria', 30, 'CITO_PIEL', null, 0,
         'Control del prurito atópico',
         'Baño medicado cada semana; secar bien las patas después de pasear en pasto húmedo.', 30),
       (  8,  2, 'Canino', null, null, 10, 10, 'Dermatitis alérgica',
         'Dermatitis alérgica alimentaria: prurito todo el año con otitis recurrente; se indica dieta de eliminación.',
         'Picazón todo el año y orejas rojas', 'Dermatología Veterinaria', 30, 'CITO_PIEL', null, 0,
         'Dieta de eliminación y control del prurito',
         'Dar solo alimento hipoalergénico por 8 semanas; ningún premio ni comida casera.', 56),
       (  9,  2, 'Canino', null, null, 7, 7, 'Dermatitis alérgica',
         'Dermatitis por Malassezia secundaria a alergia: piel grasa con olor rancio en pliegues; levaduras en citología.',
         'Mal olor en la piel y picazón', 'Dermatología Veterinaria', 30, 'CITO_PIEL', null, 0,
         'Tratamiento antifúngico y control de la alergia',
         'Bañar dos veces por semana dejando actuar el champú 10 minutos.', 21),
       ( 10,  2, 'Canino', null, null, 5, 5, 'Dermatitis alérgica',
         'Reacción alérgica aguda (angioedema) por picadura de insecto; sin dificultad respiratoria.',
         'Se le hinchó la cara', 'Urgencias Veterinarias', 40, null, null, 0,
         'Manejo de reacción alérgica aguda',
         'Vigilar la respiración durante 12 horas; volver si empeora la hinchazón.', 3),
       ( 11,  2, 'Felino', null, null, 15, 15, 'Dermatitis alérgica',
         'Dermatitis miliar felina por alergia a la picadura de pulga.',
         'Tiene costritas en el cuello y se rasca', 'Dermatología Veterinaria', 30, 'CITO_PIEL', null, 0,
         'Control de pulgas y del prurito',
         'Tratar a todas las mascotas de la casa y fumigar patio y paredes; lavar camas con agua caliente.', 30),
       ( 12,  3, 'Canino', null, null, 32, 32, 'Sarna y pioderma',
         'Sarna sarcóptica: costras y prurito intenso en bordes de orejas y codos; raspado positivo a Sarcoptes scabiei.',
         'Picazón intensa y costras en las orejas', 'Dermatología Veterinaria', 30, 'RASPADO', null, 0,
         'Tratamiento acaricida',
         'Tratar a los demás perros de la casa y lavar camas con agua caliente. Puede picar a personas.', 30),
       ( 13,  3, 'Canino', null, null, 22, 22, 'Sarna y pioderma',
         'Sarna demodécica: alopecia en cara y patas delanteras; raspado profundo con abundantes Demodex.',
         'Se le cae el pelo alrededor de los ojos', 'Dermatología Veterinaria', 30, 'RASPADO', 'TRICOGRAMA', 50,
         'Tratamiento acaricida prolongado',
         'Raspados de control cada mes hasta tener dos resultados negativos.', 90),
       ( 14,  3, 'Canino', null, null, 32, 32, 'Sarna y pioderma',
         'Pioderma superficial: pápulas y pústulas en abdomen; citología con cocos y neutrófilos.',
         'Granitos con pus en la panza', 'Dermatología Veterinaria', 30, 'CITO_PIEL', null, 0,
         'Antibioterapia y baños antisépticos',
         'Completar el antibiótico aunque mejore; baño dos veces por semana.', 21),
       ( 15,  3, 'Felino', null, null, 5, 5, 'Sarna y pioderma',
         'Sarna notoédrica: costras grisáceas en cabeza y orejas con prurito intenso.',
         'Costras en la cara y se rasca mucho', 'Dermatología Veterinaria', 30, 'RASPADO', null, 0,
         'Tratamiento acaricida',
         'Tratar a todos los gatos de la casa.', 30),
       ( 16,  3, 'Conejo', null, null, 4, 4, 'Sarna y pioderma',
         'Sarna por Psoroptes cuniculi: costras gruesas dentro del pabellón auricular.',
         'Costras dentro de las orejas', 'Medicina de Animales Exóticos', 30, 'RASPADO', null, 0,
         'Tratamiento acaricida',
         'Cambiar la cama de la jaula y desinfectarla.', 28),
       ( 17,  3, 'Roedor', null, null, 4, 4, 'Sarna y pioderma',
         'Sarna por ácaros: prurito intenso y alopecia en dorso; raspado positivo.',
         'Se rasca hasta lastimarse', 'Medicina de Animales Exóticos', 30, 'RASPADO', null, 0,
         'Tratamiento acaricida',
         'Cambiar la cama de la jaula y desinfectarla.', 30),
       ( 18,  3, 'Porcino', null, null, 1, 1, 'Sarna y pioderma',
         'Sarna sarcóptica porcina: costras en orejas y cuello.',
         'Se rasca contra las paredes', 'Medicina General Veterinaria', 30, 'RASPADO', null, 0,
         'Tratamiento acaricida',
         'Limpiar y desinfectar el corral.', 14),
       ( 19,  4, 'Canino', null, null, 40, 40, 'Pulgas y garrapatas',
         'Garrapatas (Rhipicephalus sanguineus) en orejas, cuello y entre los dedos; sin fiebre.',
         'Tiene garrapatas', 'Medicina General Veterinaria', 20, 'RET_GARRAPATAS', 'HEMOGRAMA', 30,
         'Control de garrapatas',
         'Tratar a todas las mascotas de la casa y fumigar patio y paredes; lavar camas con agua caliente.', 1),
       ( 20,  4, 'Canino', null, null, 22, 22, 'Pulgas y garrapatas',
         'Pulgas y garrapatas en dorso, cuello y orejas; prurito moderado.',
         'Tiene pulgas y garrapatas', 'Medicina General Veterinaria', 20, 'RET_GARRAPATAS', null, 0,
         'Control de ectoparásitos y parásitos internos',
         'Tratar a todas las mascotas de la casa y fumigar patio y paredes; lavar camas con agua caliente.', 30),
       ( 21,  4, 'Canino', null, null, 16, 16, 'Pulgas y garrapatas',
         'Pulgas (Ctenocephalides felis) y excremento de pulga en dorso.',
         'Tiene pulgas', 'Medicina Preventiva', 20, null, null, 0,
         'Control de pulgas y desparasitación',
         'Las pulgas transmiten tenia: se desparasita también por dentro. Lavar camas.', 30),
       ( 22,  4, 'Felino', null, null, 22, 22, 'Pulgas y garrapatas',
         'Pulgas abundantes con dermatitis leve en cuello.',
         'Tiene pulgas', 'Medicina General Veterinaria', 20, null, null, 0,
         'Control de pulgas y desparasitación',
         'Las pulgas transmiten tenia: se desparasita también por dentro. Lavar camas.', 30),
       ( 23,  5, 'Canino', null, null, 52, 52, 'Ehrlichiosis y hemoparásitos',
         'Ehrlichia canis positivo en prueba 4Dx; fiebre, decaimiento y plaquetas bajas.',
         'Fiebre, decaído y no quiere comer', 'Medicina Interna Veterinaria', 35, 'SNAP_4DX', 'HEMOGRAMA', 100,
         'Tratamiento antibiótico prolongado',
         'Completar los 28 días aunque mejore; hemograma de control a los 14 días; control estricto de garrapatas.', 28),
       ( 24,  5, 'Canino', null, null, 18, 18, 'Ehrlichiosis y hemoparásitos',
         'Anaplasma platys: trombocitopenia con mórulas en plaquetas en el frotis.',
         'Le salen moretones y está decaído', 'Medicina Interna Veterinaria', 35, 'FROTIS', 'SNAP_4DX', 100,
         'Tratamiento antibiótico',
         'Completar el antibiótico; control de plaquetas en 2 semanas; control de garrapatas.', 21),
       ( 25,  5, 'Canino', null, null, 12, 12, 'Ehrlichiosis y hemoparásitos',
         'Babesiosis: anemia, mucosas pálidas y orina oscura; Babesia en frotis sanguíneo.',
         'Encías pálidas y orina oscura', 'Medicina Interna Veterinaria', 35, 'FROTIS', 'HEMOGRAMA', 100,
         'Tratamiento antiparasitario sanguíneo',
         'Segunda dosis a los 14 días; reposo y control de garrapatas.', 30),
       ( 26,  5, 'Canino', null, null, 13, 13, 'Ehrlichiosis y hemoparásitos',
         'Ehrlichiosis crónica: pancitopenia y sangrado nasal; requiere controles hematológicos.',
         'Le sangra la nariz', 'Medicina Interna Veterinaria', 35, 'HEMOGRAMA', 'PERFIL', 100,
         'Antibioterapia y soporte hematológico',
         'Completar los 28 días; hemograma cada 2 semanas; evitar golpes.', 28),
       ( 27,  5, 'Felino', null, null, 5, 5, 'Ehrlichiosis y hemoparásitos',
         'Hemoplasmosis felina (Mycoplasma haemofelis): anemia y fiebre; hemoplasmas en frotis.',
         'Está débil y con encías pálidas', 'Medicina Interna Veterinaria', 35, 'FROTIS', 'HEMOGRAMA', 100,
         'Tratamiento antibiótico',
         'Dar la tableta seguida de agua o comida húmeda.', 21),
       ( 28,  6, 'Canino', null, 'cria', 86, 86, 'Parvovirus',
         'Parvovirus canino: vómito, diarrea con sangre y deshidratación del 8%; prueba rápida positiva. Cachorro sin esquema de vacunas completo.',
         'Vómito y diarrea con sangre', 'Urgencias Veterinarias', 40, 'SNAP_PARVO', 'HOSP', 100,
         'Hospitalización y tratamiento de soporte',
         'Aislamiento estricto; desinfectar la casa con cloro; reiniciar la comida en porciones pequeñas; completar vacunas al recuperarse.', 7),
       ( 29,  6, 'Felino', null, 'cria', 14, 14, 'Parvovirus',
         'Panleucopenia felina (parvovirus felino): vómito, diarrea y leucopenia severa; gatito sin vacunar.',
         'Vómito, diarrea y no come', 'Urgencias Veterinarias', 40, 'SNAP_PARVO', 'HOSP', 100,
         'Hospitalización y tratamiento de soporte',
         'Aislamiento estricto; desinfectar con cloro; no traer gatos nuevos a la casa por 6 meses.', 7),
       ( 30,  7, 'Canino', null, null, 26, 26, 'Gastroenteritis y parásitos intestinales',
         'Gastroenteritis aguda: vómito y diarrea de 48 horas, deshidratación leve; coprológico negativo.',
         'Vómito y diarrea', 'Medicina General Veterinaria', 20, 'COPRO', 'FLUIDO', 30,
         'Soporte digestivo y dieta blanda',
         'Dieta blanda (arroz con pollo sin piel) en porciones pequeñas por 5 días; agua fresca siempre.', 7),
       ( 31,  7, 'Canino', null, null, 16, 16, 'Gastroenteritis y parásitos intestinales',
         'Huevos de Ancylostoma y Toxocara en coprológico; bajo peso.',
         'Diarrea y está flaco', 'Medicina General Veterinaria', 20, 'COPRO', null, 0,
         'Desparasitación terapéutica',
         'Repetir la dosis a los 15 días; recoger las heces del patio a diario.', 15),
       ( 32,  7, 'Canino', null, null, 10, 10, 'Gastroenteritis y parásitos intestinales',
         'Giardiasis: diarrea pastosa intermitente; quistes de Giardia en coprológico.',
         'Diarrea que va y viene', 'Medicina Interna Veterinaria', 35, 'COPRO', null, 0,
         'Tratamiento antiprotozoario',
         'Bañar al final del tratamiento y desinfectar el área donde duerme.', 7),
       ( 33,  7, 'Canino', null, null, 7, 7, 'Gastroenteritis y parásitos intestinales',
         'Gastroenteritis por comida en mal estado o basura; abdomen sensible a la palpación.',
         'Vomitó después de comer basura', 'Medicina General Veterinaria', 20, null, null, 0,
         'Soporte digestivo',
         'Ayuno de 12 horas y luego dieta blanda.', 5),
       ( 34,  7, 'Felino', null, null, 13, 13, 'Gastroenteritis y parásitos intestinales',
         'Gastroenteritis aguda felina: vómito y heces blandas; hidratación conservada.',
         'Vomita y tiene diarrea', 'Medicina General Veterinaria', 20, 'COPRO', null, 0,
         'Soporte digestivo',
         'Dieta gastrointestinal en porciones pequeñas.', 7),
       ( 35,  7, 'Felino', null, null, 9, 9, 'Gastroenteritis y parásitos intestinales',
         'Toxocara cati en coprológico; abdomen abultado.',
         'Panza hinchada y diarrea', 'Medicina General Veterinaria', 20, 'COPRO', null, 0,
         'Desparasitación terapéutica',
         'Repetir la dosis a los 15 días; limpiar el arenero a diario.', 15),
       ( 36,  7, 'Conejo', null, null, 4, 4, 'Gastroenteritis y parásitos intestinales',
         'Coccidiosis intestinal: diarrea y pérdida de peso; ooquistes de Eimeria en coprológico.',
         'Diarrea y bajó de peso', 'Medicina de Animales Exóticos', 30, 'COPRO', null, 0,
         'Tratamiento anticoccidial y alimentación asistida',
         'Limpiar la jaula a diario; heno de buena calidad a libre demanda.', 9),
       ( 37,  7, 'Conejo', null, null, 4, 4, 'Gastroenteritis y parásitos intestinales',
         'Estasis gastrointestinal: sin heces por 24 horas y dolor abdominal.',
         'No come y no hace popó', 'Medicina de Animales Exóticos', 30, 'RX', null, 0,
         'Estimulación digestiva y analgesia',
         'Ofrecer heno fresco y agua; alimentación asistida si no come.', 7),
       ( 38,  7, 'Roedor', null, null, 4, 4, 'Gastroenteritis y parásitos intestinales',
         'Estasis gastrointestinal: anorexia y heces escasas.',
         'No come y no hace popó', 'Medicina de Animales Exóticos', 30, null, null, 0,
         'Estimulación digestiva y analgesia',
         'Ofrecer heno fresco y agua; alimentación asistida si no come.', 7),
       ( 39,  7, 'Roedor', null, null, 2, 2, 'Gastroenteritis y parásitos intestinales',
         'Enteritis proliferativa (cola mojada): diarrea acuosa y zona perianal húmeda.',
         'Tiene la cola mojada y diarrea', 'Medicina de Animales Exóticos', 30, null, null, 0,
         'Antibioterapia y soporte',
         'Mantener la jaula limpia y seca; volver si deja de comer.', 7),
       ( 40,  7, 'Ave', null, null, 2, 2, 'Gastroenteritis y parásitos intestinales',
         'Huevos de áscaris en coprológico; plumas erizadas.',
         'Heces mal formadas y plumas erizadas', 'Medicina de Animales Exóticos', 30, 'COPRO', null, 0,
         'Desparasitación',
         'Lavar comederos y bebederos a diario.', 14),
       ( 41,  7, 'Reptil', null, null, 1.5, 1.5, 'Gastroenteritis y parásitos intestinales',
         'Oxiuros en coprológico; heces con mal olor.',
         'No come y las heces huelen mal', 'Medicina de Animales Exóticos', 30, 'COPRO', null, 0,
         'Desparasitación',
         'Limpiar el terrario y cambiar el sustrato.', 17),
       ( 42,  7, 'Hurón', null, null, 1, 1, 'Gastroenteritis y parásitos intestinales',
         'Gastroenteritis en hurón: diarrea verdosa y decaimiento.',
         'Diarrea verde', 'Medicina de Animales Exóticos', 30, 'COPRO', null, 0,
         'Soporte digestivo',
         'Dieta blanda para hurón y agua fresca.', 7),
       ( 43,  7, 'Ovino', null, null, 0.5, 0.5, 'Gastroenteritis y parásitos intestinales',
         'Parásitos gastrointestinales (estrongílidos) con anemia leve.',
         'Diarrea y pérdida de peso', 'Medicina General Veterinaria', 25, 'COPRO', null, 0,
         'Desparasitación',
         'Rotar potreros y desparasitar al resto del rebaño.', 1),
       ( 44,  7, 'Porcino', null, null, 0.5, 0.5, 'Gastroenteritis y parásitos intestinales',
         'Áscaris en coprológico; bajo peso.',
         'Diarrea y no engorda', 'Medicina General Veterinaria', 25, 'COPRO', null, 0,
         'Desparasitación',
         'Limpiar el corral a diario.', 1),
       ( 45,  7, 'Équido', null, null, 0.5, 0.5, 'Gastroenteritis y parásitos intestinales',
         'Parásitos gastrointestinales; pelo opaco y pérdida de peso.',
         'Está flaco y con el pelo opaco', 'Medicina General Veterinaria', 30, 'COPRO', null, 0,
         'Desparasitación',
         'Retirar el estiércol del potrero cada semana.', 1),
       ( 46,  8, 'Canino', null, null, 44, 44, 'Otitis',
         'Otitis externa bacteriana: secreción purulenta y mal olor; bacilos en citología.',
         'Sacude la cabeza y le huelen las orejas', 'Dermatología Veterinaria', 30, 'CITO_OTICA', 'LIMP_OTICA', 100,
         'Tratamiento ótico tópico',
         'Limpiar el oído antes de cada aplicación; no usar hisopos; evitar que entre agua.', 10),
       ( 47,  8, 'Canino', null, null, 24, 24, 'Otitis',
         'Otitis externa por Malassezia: cerumen café abundante; levaduras en citología.',
         'Se rasca las orejas y tienen cerumen café', 'Medicina General Veterinaria', 20, 'CITO_OTICA', 'LIMP_OTICA', 100,
         'Tratamiento ótico tópico',
         'Limpiar el oído antes de cada aplicación; secar bien las orejas después del baño.', 10),
       ( 48,  8, 'Canino', null, null, 8, 8, 'Otitis',
         'Otohematoma secundario a otitis: pabellón auricular inflamado por sacudidas de cabeza.',
         'Se le hinchó la oreja', 'Cirugía Veterinaria', 35, 'DRENAJE', 'CITO_OTICA', 100,
         'Drenaje y tratamiento de la otitis',
         'Usar collar isabelino; retiro de puntos en 14 días.', 14),
       ( 49,  8, 'Felino', null, null, 16, 16, 'Otitis',
         'Otitis por ácaros (Otodectes cynotis): cerumen oscuro tipo borra de café; ácaros al otoscopio.',
         'Cerumen negro y se rasca las orejas', 'Medicina General Veterinaria', 20, 'LIMP_OTICA', null, 0,
         'Tratamiento acaricida ótico',
         'Tratar a todos los gatos y perros de la casa.', 30),
       ( 50,  8, 'Conejo', null, null, 4, 4, 'Otitis',
         'Otitis externa en conejo de orejas caídas: acúmulo de cerumen y dolor.',
         'Inclina la cabeza y se rasca la oreja', 'Medicina de Animales Exóticos', 30, 'LIMP_OTICA', null, 0,
         'Antibioterapia y analgesia',
         'Mantener la jaula limpia y seca; volver si deja de comer.', 10),
       ( 51,  8, 'Canino', null, null, 4, 4, 'Otitis',
         'Otitis externa por cuerpo extraño (espiga de pasto); se retira en consulta.',
         'Sacude la cabeza de repente', 'Medicina General Veterinaria', 20, 'LIMP_OTICA', null, 0,
         'Tratamiento ótico tópico',
         'Revisar las orejas después de pasear en monte.', 7),
       ( 52,  9, 'Canino', null, 'cria', 22, 22, 'Moquillo y problemas respiratorios',
         'Moquillo canino: fiebre, secreción ocular y nasal purulenta y tos; prueba rápida positiva. Sin vacunas.',
         'Fiebre, tos y lagañas', 'Medicina Interna Veterinaria', 35, 'SNAP_MOQ', 'RX_TORAX', 50,
         'Tratamiento de soporte para moquillo',
         'Aislar de otros perros; limpiar secreciones; volver de inmediato si hay temblores o convulsiones.', 14),
       ( 53,  9, 'Canino', null, null, 26, 26, 'Moquillo y problemas respiratorios',
         'Traqueobronquitis infecciosa (tos de las perreras): tos seca en accesos que termina en arcada; sin fiebre.',
         'Tos seca como si se atorara', 'Medicina General Veterinaria', 20, null, 'NEBULIZ', 30,
         'Tratamiento de traqueobronquitis',
         'Reposo; usar pechera en lugar de collar; aislar de otros perros 7 días.', 10),
       ( 54,  9, 'Canino', null, null, 10, 10, 'Moquillo y problemas respiratorios',
         'Bronquitis aguda: tos productiva y sibilancias leves a la auscultación.',
         'Tos con flema', 'Medicina General Veterinaria', 20, 'RX_TORAX', 'NEBULIZ', 50,
         'Tratamiento de bronquitis',
         'Evitar humo, polvo y cambios bruscos de temperatura.', 10),
       ( 55,  9, 'Canino', null, null, 5, 5, 'Moquillo y problemas respiratorios',
         'Neumonía bacteriana: fiebre, dificultad respiratoria y patrón alveolar en radiografía.',
         'Respira con dificultad', 'Medicina Interna Veterinaria', 35, 'RX_TORAX', 'HEMOGRAMA', 100,
         'Antibioterapia combinada',
         'Reposo absoluto; radiografía de control en 10 días.', 14),
       ( 56,  9, 'Felino', null, null, 15, 15, 'Moquillo y problemas respiratorios',
         'Rinotraqueítis viral felina (herpesvirus): estornudos, conjuntivitis y secreción nasal.',
         'Estornuda y tiene lagañas', 'Medicina General Veterinaria', 20, null, 'NEBULIZ', 30,
         'Tratamiento antiviral de soporte',
         'Limpiar ojos y nariz con suero; ofrecer comida tibia y de olor fuerte.', 21),
       ( 57,  9, 'Felino', null, null, 10, 10, 'Moquillo y problemas respiratorios',
         'Calicivirus felino: úlceras en la lengua, estornudos y fiebre.',
         'No come y babea', 'Medicina General Veterinaria', 20, null, null, 0,
         'Tratamiento de soporte',
         'Ofrecer comida húmeda tibia; volver si deja de comer 24 horas.', 10),
       ( 58,  9, 'Conejo', null, null, 4, 4, 'Moquillo y problemas respiratorios',
         'Rinitis por Pasteurella: secreción nasal blanca y estornudos.',
         'Estornuda y tiene moco', 'Medicina de Animales Exóticos', 30, null, null, 0,
         'Antibioterapia',
         'Mantener la jaula limpia y seca; volver si deja de comer.', 14),
       ( 59,  9, 'Roedor', null, null, 4, 4, 'Moquillo y problemas respiratorios',
         'Micoplasmosis respiratoria: estornudos, ruidos al respirar y secreción rojiza en los ojos.',
         'Hace ruido al respirar', 'Medicina de Animales Exóticos', 30, null, null, 0,
         'Antibioterapia combinada',
         'Cambiar el sustrato por uno sin polvo; limpiar la jaula a diario.', 14),
       ( 60,  9, 'Ave', null, null, 4, 4, 'Moquillo y problemas respiratorios',
         'Infección respiratoria: respiración con movimiento de cola, secreción nasal y plumas erizadas.',
         'Respira con la cola y está esponjado', 'Medicina de Animales Exóticos', 30, 'NEBULIZ', null, 0,
         'Antibioterapia y calor',
         'Mantener en ambiente cálido (25 a 28 °C) y sin corrientes de aire.', 10),
       ( 61, 10, 'Canino', null, null, 30, 22, 'Heridas y traumas',
         'Heridas por mordedura en cuello y pata delantera tras pelea con otro perro.',
         'Herida por pelea', 'Urgencias Veterinarias', 40, 'CURACION', 'SUTURA', 50,
         'Manejo de herida y antibioterapia',
         'Limpiar la herida dos veces al día; collar isabelino; volver si hay pus o mal olor.', 10),
       ( 62, 10, 'Canino', null, null, 14, 8, 'Heridas y traumas',
         'Corte en almohadilla plantar por vidrio.',
         'Se cortó una pata', 'Urgencias Veterinarias', 40, 'SUTURA', 'CURACION', 100,
         'Manejo de herida',
         'Mantener el vendaje seco y cambiarlo cada 48 horas.', 7),
       ( 63, 10, 'Canino', null, null, 13, 8, 'Heridas y traumas',
         'Atropellamiento: escoriaciones múltiples y dolor de cadera; radiografía sin fracturas.',
         'Lo atropelló un carro', 'Urgencias Veterinarias', 40, 'RX', 'CURACION', 100,
         'Analgesia y reposo',
         'Reposo en espacio reducido por 2 semanas.', 7),
       ( 64, 10, 'Canino', null, null, 6, 4, 'Heridas y traumas',
         'Fractura de fémur por atropellamiento; se realiza osteosíntesis.',
         'No apoya la pata después de un accidente', 'Traumatología Veterinaria', 40, 'RX', 'OSTEOSINTESIS', 100,
         'Manejo postoperatorio de fractura',
         'Reposo estricto en jaula por 6 semanas; radiografía de control al mes.', 42),
       ( 65, 10, 'Canino', null, null, 0, 26, 'Heridas y traumas',
         'Quemaduras de segundo grado en hocico y patas por cohete de pólvora.',
         'Se quemó con pólvora', 'Urgencias Veterinarias', 40, 'CURACION', null, 0,
         'Manejo de quemaduras',
         'Curar a diario; no aplicar remedios caseros; collar isabelino.', 10),
       ( 66, 10, 'Canino', null, null, 0, 14, 'Heridas y traumas',
         'Laceraciones y golpes al huir asustado por la pólvora.',
         'Se escapó asustado por la pólvora y se lastimó', 'Urgencias Veterinarias', 40, 'CURACION', 'RX', 40,
         'Manejo de heridas',
         'Reposo; mantenerlo dentro de la casa mientras haya pólvora.', 5),
       ( 67, 10, 'Felino', null, null, 14, 8, 'Heridas y traumas',
         'Absceso por mordedura de otro gato en la base de la cola.',
         'Tiene una bola con pus', 'Urgencias Veterinarias', 40, 'CURACION', null, 0,
         'Drenaje y antibioterapia',
         'Limpiar la herida dos veces al día; no dejarlo salir hasta que cierre.', 7),
       ( 68, 10, 'Felino', null, null, 6, 4, 'Heridas y traumas',
         'Caída desde altura: sangrado nasal leve y dolor torácico; radiografía sin fracturas.',
         'Se cayó del segundo piso', 'Urgencias Veterinarias', 40, 'RX', null, 0,
         'Analgesia y observación',
         'Reposo; poner mallas en ventanas y balcones.', 5),
       ( 69, 10, 'Felino', null, null, 3, 2, 'Heridas y traumas',
         'Fractura de fémur por atropellamiento; se realiza osteosíntesis.',
         'No apoya la pata después de un accidente', 'Traumatología Veterinaria', 40, 'RX', 'OSTEOSINTESIS', 100,
         'Manejo postoperatorio de fractura',
         'Reposo estricto en jaula por 6 semanas; radiografía de control al mes.', 42),
       ( 70, 10, 'Ave', null, null, 3, 2, 'Heridas y traumas',
         'Fractura de ala por golpe contra una ventana.',
         'Tiene el ala caída', 'Medicina de Animales Exóticos', 30, 'RX', 'VENDAJE', 100,
         'Inmovilización y analgesia',
         'Mantener en jaula pequeña sin perchas altas por 3 semanas.', 21),
       ( 71, 10, 'Conejo', null, null, 2, 1, 'Heridas y traumas',
         'Heridas por mordedura de perro en el dorso.',
         'Lo mordió un perro', 'Medicina de Animales Exóticos', 30, 'CURACION', null, 0,
         'Manejo de herida y antibioterapia',
         'Mantener la jaula limpia y seca; volver si deja de comer.', 7),
       ( 72, 10, 'Roedor', null, null, 1, 1, 'Heridas y traumas',
         'Herida en la cola por atrapamiento en la jaula.',
         'Se lastimó la cola', 'Medicina de Animales Exóticos', 30, 'CURACION', null, 0,
         'Manejo de herida',
         'Mantener la jaula limpia y seca; volver si deja de comer.', 5),
       ( 73, 10, 'Équido', null, null, 1, 0.5, 'Heridas y traumas',
         'Herida por alambre de púas en pata delantera.',
         'Se cortó con alambre', 'Medicina General Veterinaria', 30, 'SUTURA', 'CURACION', 100,
         'Manejo de herida',
         'Curar a diario y aplicar el polvo para evitar gusanos.', 10),
       ( 74, 11, 'Canino', null, null, 78, 78, 'Golpe de calor',
         'Temperatura de 41.5 °C, jadeo intenso y mucosas congestionadas tras estar al sol o en un carro cerrado.',
         'Jadea mucho y se desmayó por el calor', 'Urgencias Veterinarias', 40, 'ENFRIAMIENTO', 'FLUIDO', 100,
         'Enfriamiento y soporte',
         'No pasear entre 10:00 y 16:00; sombra y agua fresca siempre; nunca dejarlo en un carro cerrado.', 5),
       ( 75, 11, 'Felino', null, null, 7, 7, 'Golpe de calor',
         'Temperatura de 41 °C y jadeo tras quedar encerrado en un cuarto caliente.',
         'Respira con la boca abierta', 'Urgencias Veterinarias', 40, 'ENFRIAMIENTO', 'FLUIDO', 100,
         'Enfriamiento y soporte',
         'Mantener cuartos ventilados y agua fresca siempre.', 1),
       ( 76, 11, 'Conejo', null, null, 9, 9, 'Golpe de calor',
         'Jadeo, orejas calientes y decaimiento; temperatura de 41 °C.',
         'Está tirado y con las orejas calientes', 'Medicina de Animales Exóticos', 30, 'ENFRIAMIENTO', null, 0,
         'Enfriamiento y soporte',
         'Jaula a la sombra; botella de agua congelada envuelta en tela en los días de calor.', 1),
       ( 77, 11, 'Roedor', null, null, 4, 4, 'Golpe de calor',
         'Jadeo y decaimiento por calor; temperatura elevada.',
         'Está tirado y respira rápido', 'Medicina de Animales Exóticos', 30, 'ENFRIAMIENTO', null, 0,
         'Enfriamiento y soporte',
         'Jaula a la sombra y en un lugar fresco.', 1),
       ( 78, 11, 'Ave', null, null, 2, 2, 'Golpe de calor',
         'Jadeo con el pico abierto y alas separadas del cuerpo.',
         'Respira con el pico abierto', 'Medicina de Animales Exóticos', 30, 'ENFRIAMIENTO', null, 0,
         'Enfriamiento y soporte',
         'Jaula a la sombra y con agua fresca siempre.', 1),
       ( 79, 12, 'Canino', null, null, 80, 80, 'Miasis (gusano barrenador)',
         'Larvas de Cochliomyia hominivorax en herida del cuello con destrucción de tejido; caso notificado al MAG.',
         'Tiene gusanos en una herida', 'Urgencias Veterinarias', 40, 'LARVAS', 'CURACION', 100,
         'Eliminación de larvas y manejo de herida',
         'Curar a diario y aplicar el polvo; mantenerlo lejos de moscas; revisar otras heridas.', 7),
       ( 80, 12, 'Felino', null, null, 10, 10, 'Miasis (gusano barrenador)',
         'Larvas en herida de la cola con mal olor; caso notificado al MAG.',
         'Tiene gusanos en una herida', 'Urgencias Veterinarias', 40, 'LARVAS', 'CURACION', 100,
         'Eliminación de larvas y manejo de herida',
         'Curar a diario; mantenerlo dentro de la casa hasta que cierre la herida.', 7),
       ( 81, 12, 'Conejo', null, null, 2, 2, 'Miasis (gusano barrenador)',
         'Larvas en zona perineal sucia (miasis perianal).',
         'Tiene gusanos cerca de la cola', 'Medicina de Animales Exóticos', 30, 'LARVAS', null, 0,
         'Eliminación de larvas y manejo de herida',
         'Limpiar la jaula a diario y revisar la zona de la cola.', 7),
       ( 82, 12, 'Ovino', null, null, 3, 3, 'Miasis (gusano barrenador)',
         'Larvas de gusano barrenador en el ombligo; caso notificado al MAG.',
         'Tiene gusanos en una herida', 'Medicina General Veterinaria', 30, 'LARVAS', null, 0,
         'Eliminación de larvas',
         'Revisar a diario a los demás animales.', 7),
       ( 83, 12, 'Porcino', null, null, 2, 2, 'Miasis (gusano barrenador)',
         'Larvas de gusano barrenador en herida de la piel; caso notificado al MAG.',
         'Tiene gusanos en una herida', 'Medicina General Veterinaria', 30, 'LARVAS', null, 0,
         'Eliminación de larvas',
         'Revisar a diario a los demás animales.', 7),
       ( 84, 12, 'Équido', null, null, 3, 3, 'Miasis (gusano barrenador)',
         'Larvas de gusano barrenador en herida de la pata; caso notificado al MAG.',
         'Tiene gusanos en una herida', 'Medicina General Veterinaria', 30, 'LARVAS', null, 0,
         'Eliminación de larvas',
         'Revisar a diario a los demás animales.', 7),
       ( 85, 13, 'Canino', null, null, 26, 26, 'Paciente sano: vacunación anual',
         'Examen físico normal; se aplican vacuna polivalente y antirrábica.',
         'Vacunación anual', 'Medicina Preventiva', 15, null, null, 0,
         'Esquema de vacunación anual',
         'Puede estar decaído 24 horas; no bañarlo en 3 días; refuerzo en un año.', 0),
       ( 86, 13, 'Canino', null, 'cria', 9, 9, 'Paciente sano: inicio de vacunación',
         'Cachorro sano; primera dosis de vacuna polivalente y desparasitación.',
         'Primeras vacunas del cachorro', 'Medicina Preventiva', 15, null, null, 0,
         'Inicio de esquema de vacunación',
         'Segunda dosis en 3 semanas; no sacarlo a la calle hasta completar el esquema.', 3),
       ( 87, 13, 'Felino', null, null, 12, 12, 'Paciente sano: vacunación anual',
         'Examen físico normal; se aplican vacuna triple felina y antirrábica.',
         'Vacunación anual', 'Medicina Preventiva', 15, null, null, 0,
         'Esquema de vacunación anual',
         'Puede estar decaído 24 horas; refuerzo en un año.', 0),
       ( 88, 13, 'Felino', null, 'cria', 4, 4, 'Paciente sano: inicio de vacunación',
         'Gatito sano; primera dosis de triple felina y desparasitación.',
         'Primeras vacunas del gatito', 'Medicina Preventiva', 15, null, null, 0,
         'Inicio de esquema de vacunación',
         'Segunda dosis en 3 semanas.', 3),
       ( 89, 13, 'Canino', null, null, 12, 12, 'Paciente sano: desparasitación',
         'Examen físico normal; desparasitación interna y externa de rutina.',
         'Desparasitación', 'Medicina Preventiva', 15, null, null, 0,
         'Desparasitación preventiva',
         'Repetir la desparasitación interna cada 3 meses.', 30),
       ( 90, 13, 'Felino', null, null, 5, 5, 'Paciente sano: desparasitación',
         'Examen físico normal; desparasitación interna y externa de rutina.',
         'Desparasitación', 'Medicina Preventiva', 15, null, null, 0,
         'Desparasitación preventiva',
         'Repetir la desparasitación interna cada 3 meses.', 30),
       ( 91, 13, 'Canino', null, null, 10, 10, 'Paciente sano: chequeo de rutina',
         'Condición corporal 5/9, mucosas rosadas y linfonodos normales.',
         'Chequeo general', 'Medicina General Veterinaria', 20, null, null, 0,
         null,
         null, null),
       ( 92, 13, 'Felino', null, null, 5, 5, 'Paciente sano: chequeo de rutina',
         'Condición corporal 5/9, mucosas rosadas y linfonodos normales.',
         'Chequeo general', 'Medicina General Veterinaria', 20, null, null, 0,
         null,
         null, null),
       ( 93, 13, 'Canino', null, 'senior', 4, 4, 'Paciente sano: chequeo geriátrico',
         'Hemograma y perfil bioquímico dentro de rangos normales para la edad.',
         'Chequeo de perro mayor', 'Medicina General Veterinaria', 25, 'HEMOGRAMA', 'PERFIL', 100,
         null,
         null, null),
       ( 94, 13, 'Felino', null, 'senior', 2, 2, 'Paciente sano: chequeo geriátrico',
         'Hemograma y perfil bioquímico dentro de rangos normales para la edad.',
         'Chequeo de gato mayor', 'Medicina General Veterinaria', 25, 'HEMOGRAMA', 'PERFIL', 100,
         null,
         null, null),
       ( 95, 13, 'Canino', 'Hembra', null, 2.5, 2.5, 'Paciente sano: control postquirúrgico',
         'Control de esterilización: herida limpia y cicatrizada; se retiran puntos.',
         'Retiro de puntos de esterilización', 'Cirugía Veterinaria', 15, 'RET_SUTURA', null, 0,
         null,
         null, null),
       ( 96, 13, 'Felino', 'Hembra', null, 2.5, 2.5, 'Paciente sano: control postquirúrgico',
         'Control de esterilización: herida limpia y cicatrizada; se retiran puntos.',
         'Retiro de puntos de esterilización', 'Cirugía Veterinaria', 15, 'RET_SUTURA', null, 0,
         null,
         null, null),
       ( 97, 13, 'Canino', null, null, 2.5, 2.5, 'Paciente sano: control de peso',
         'Peso dentro del rango ideal; se ajusta la ración diaria.',
         'Control de peso', 'Nutrición Veterinaria', 20, 'EVAL_NUTRI', null, 0,
         null,
         null, null),
       ( 98, 13, 'Canino', null, null, 1, 1, 'Paciente sano: control de rehabilitación',
         'Buena evolución tras cirugía ortopédica; apoya la pata sin dolor.',
         'Terapia de rehabilitación', 'Fisioterapia y Rehabilitación', 25, 'FISIO', null, 0,
         null,
         null, null),
       ( 99, 13, 'Ave', null, null, 3, 3, 'Paciente sano: control de rutina',
         'Ave alerta, plumaje en buen estado y peso estable; se recortan uñas.',
         'Control de rutina', 'Medicina de Animales Exóticos', 25, 'CORTE_UNAS', null, 0,
         null,
         null, null),
       (100, 13, 'Roedor', null, null, 2.5, 2.5, 'Paciente sano: control de rutina',
         'Buena condición corporal; incisivos y heces normales.',
         'Control de rutina', 'Medicina de Animales Exóticos', 25, null, null, 0,
         null,
         null, null),
       (101, 13, 'Conejo', null, null, 2.5, 2.5, 'Paciente sano: control de rutina',
         'Buena condición corporal; dientes y heces normales.',
         'Control de rutina', 'Medicina de Animales Exóticos', 25, null, null, 0,
         null,
         null, null),
       (102, 13, 'Reptil', null, null, 1, 1, 'Paciente sano: control de rutina',
         'Buen peso; se revisan temperatura del terrario y luz UVB.',
         'Control de rutina', 'Medicina de Animales Exóticos', 25, null, null, 0,
         null,
         null, null),
       (103, 13, 'Hurón', null, null, 1, 1, 'Paciente sano: control de rutina',
         'Buena condición corporal; pelaje y dientes normales.',
         'Control de rutina', 'Medicina de Animales Exóticos', 25, null, null, 0,
         null,
         null, null),
       (104, 13, 'Pez', null, null, 0.4, 0.4, 'Paciente sano: control de rutina',
         'Sin lesiones visibles; se revisa la calidad del agua.',
         'Control de rutina', 'Medicina de Animales Exóticos', 25, null, null, 0,
         null,
         null, null),
       (105, 13, 'Anfibio', null, null, 0.4, 0.4, 'Paciente sano: control de rutina',
         'Piel hidratada y sin lesiones; se revisa la calidad del agua.',
         'Control de rutina', 'Medicina de Animales Exóticos', 25, null, null, 0,
         null,
         null, null),
       (106, 13, 'Équido', null, null, 0.6, 0.6, 'Paciente sano: desparasitación',
         'Examen físico normal; desparasitación de rutina.',
         'Desparasitación', 'Medicina General Veterinaria', 25, null, null, 0,
         'Desparasitación preventiva',
         'Repetir cada 4 meses.', 1),
       (107, 13, 'Porcino', null, null, 0.3, 0.3, 'Paciente sano: desparasitación',
         'Examen físico normal; desparasitación de rutina.',
         'Desparasitación', 'Medicina General Veterinaria', 25, null, null, 0,
         'Desparasitación preventiva',
         'Repetir cada 4 meses.', 1),
       (108, 13, 'Ovino', null, null, 0.3, 0.3, 'Paciente sano: desparasitación',
         'Examen físico normal; desparasitación de rutina.',
         'Desparasitación', 'Medicina General Veterinaria', 25, null, null, 0,
         'Desparasitación preventiva',
         'Repetir cada 4 meses.', 1),
       (109, 14, 'Canino', null, null, 1.5, 1.5, 'Enfermedad periodontal',
         'Sarro grado III, gingivitis y mal aliento; se realiza profilaxis.',
         'Mal aliento y sarro', 'Odontología Veterinaria', 30, 'PROFILAXIS', 'EXT_DENTAL', 40,
         'Antibioterapia y analgesia dental',
         'Cepillado dental diario; alimento seco.', 7),
       (110, 14, 'Felino', null, null, 1, 1, 'Enfermedad periodontal',
         'Sarro y gingivitis con dolor al masticar; se realiza profilaxis.',
         'Mal aliento y no quiere comer croquetas', 'Odontología Veterinaria', 30, 'PROFILAXIS', 'EXT_DENTAL', 50,
         'Antibioterapia y analgesia dental',
         'Alimento húmedo por 5 días.', 7),
       (111, 14, 'Canino', null, null, 1.5, 1.5, 'Conjuntivitis',
         'Conjuntivitis bacteriana: secreción mucopurulenta; fluoresceína negativa.',
         'Ojo rojo con lagañas', 'Oftalmología Veterinaria', 30, 'FLUORESCEINA', 'LIMP_OCULAR', 100,
         'Tratamiento oftálmico',
         'Limpiar el ojo con suero antes de cada aplicación.', 7),
       (112, 14, 'Felino', null, null, 1, 1, 'Conjuntivitis',
         'Conjuntivitis felina con secreción purulenta.',
         'Ojo rojo con lagañas', 'Oftalmología Veterinaria', 30, 'LIMP_OCULAR', null, 0,
         'Tratamiento oftálmico',
         'Limpiar el ojo con suero antes de cada aplicación.', 7),
       (113, 14, 'Canino', null, null, 1, 1, 'Úlcera corneal',
         'Úlcera corneal superficial teñida con fluoresceína; ojo lloroso y cerrado.',
         'No abre un ojo', 'Oftalmología Veterinaria', 30, 'FLUORESCEINA', null, 0,
         'Tratamiento de úlcera corneal',
         'Collar isabelino las 24 horas hasta el control.', 10),
       (114, 14, 'Felino', null, null, 1, 1, 'Úlcera corneal',
         'Úlcera corneal superficial teñida con fluoresceína; ojo lloroso y cerrado.',
         'No abre un ojo', 'Oftalmología Veterinaria', 30, 'FLUORESCEINA', null, 0,
         'Tratamiento de úlcera corneal',
         'Collar isabelino las 24 horas hasta el control.', 10),
       (115, 14, 'Canino', null, 'senior', 1.5, 1.5, 'Cataratas',
         'Opacidad del cristalino en ambos ojos; se refiere para valoración quirúrgica.',
         'Ve borroso y choca con las cosas', 'Oftalmología Veterinaria', 30, null, null, 0,
         null,
         null, null),
       (116, 14, 'Canino', null, null, 2, 2, 'Displasia de cadera',
         'Dolor al extender la cadera; subluxación coxofemoral en radiografía.',
         'Cojea de las patas traseras', 'Ortopedia Veterinaria', 35, 'RX', null, 0,
         'Manejo del dolor y control de peso',
         'Ejercicio suave; evitar escaleras; mantener el peso ideal.', 14),
       (117, 14, 'Canino', null, 'senior', 2, 2, 'Osteoartritis',
         'Rigidez al levantarse y crepitación en rodillas.',
         'Le cuesta levantarse', 'Ortopedia Veterinaria', 35, 'RX', null, 0,
         'Manejo del dolor articular',
         'Caminatas cortas y cama acolchada.', 30),
       (118, 14, 'Canino', null, null, 2, 2, 'Ruptura de ligamento cruzado',
         'Cojera aguda de pata trasera; prueba de cajón positiva.',
         'Dejó de apoyar una pata trasera', 'Traumatología Veterinaria', 40, 'RX', null, 0,
         'Analgesia previa a cirugía',
         'Reposo estricto hasta la cirugía.', 10),
       (119, 14, 'Canino', null, 'senior', 2, 2, 'Enfermedad valvular mitral',
         'Soplo sistólico grado III/VI y corazón agrandado en radiografía.',
         'Tose de noche y se cansa rápido', 'Cardiología Veterinaria', 45, 'ECOCARDIO', 'RX_TORAX', 100,
         'Tratamiento cardíaco de mantenimiento',
         'Evitar ejercicio intenso; contar las respiraciones en reposo a diario.', 30),
       (120, 14, 'Felino', null, null, 1.5, 1.5, 'Cardiomiopatía hipertrófica',
         'Soplo grado II/VI y engrosamiento del ventrículo izquierdo en ecocardiograma.',
         'Evaluación cardiológica', 'Cardiología Veterinaria', 45, 'ECOCARDIO', null, 0,
         'Tratamiento cardíaco de mantenimiento',
         'Evitar estrés; control con ecocardiograma en 6 meses.', 30),
       (121, 14, 'Felino', null, 'senior', 1.5, 1.5, 'Enfermedad renal crónica',
         'Toma mucha agua y orina mucho; creatinina elevada (IRIS estadio 2).',
         'Toma mucha agua y está flaco', 'Medicina Interna Veterinaria', 35, 'PERFIL', 'ORINA', 100,
         'Manejo de enfermedad renal',
         'Dieta renal; agua fresca siempre; control de sangre en 3 meses.', 30),
       (122, 14, 'Canino', null, 'senior', 1, 1, 'Enfermedad renal crónica',
         'Poliuria, polidipsia y creatinina elevada.',
         'Toma mucha agua y orina mucho', 'Medicina Interna Veterinaria', 35, 'PERFIL', 'ORINA', 100,
         'Manejo de enfermedad renal',
         'Dieta renal; agua fresca siempre; control de sangre en 3 meses.', 30),
       (123, 14, 'Felino', null, null, 1.5, 1.5, 'Cistitis',
         'Cistitis idiopática felina: sangre en la orina y esfuerzo al orinar; urianálisis sin bacterias.',
         'Va mucho al arenero y orina con sangre', 'Medicina Interna Veterinaria', 35, 'ORINA', null, 0,
         'Manejo de cistitis',
         'Aumentar el consumo de agua; reducir el estrés; mantener areneros limpios.', 30),
       (124, 14, 'Canino', 'Hembra', null, 1, 1, 'Cistitis',
         'Cistitis bacteriana: orina frecuente y bacterias en el urianálisis.',
         'Orina muy seguido', 'Medicina General Veterinaria', 20, 'ORINA', null, 0,
         'Antibioterapia urinaria',
         'Sacarla a orinar con frecuencia; agua fresca siempre.', 10),
       (125, 14, 'Felino', 'Macho', null, 1, 1, 'Obstrucción uretral',
         'Gato macho sin poder orinar por 24 horas; vejiga distendida.',
         'No puede orinar', 'Urgencias Veterinarias', 40, 'SONDAJE', 'HOSP', 100,
         'Desobstrucción y soporte',
         'Dieta urinaria de por vida; volver de inmediato si vuelve a hacer esfuerzo.', 5),
       (126, 14, 'Canino', 'Hembra', null, 1.5, 1.5, 'Piometra',
         'Flujo vaginal purulento, fiebre y útero distendido en ecografía; se realiza ovariohisterectomía.',
         'Tiene flujo con mal olor y no come', 'Reproducción Animal', 35, 'ECO_ABD', 'OVH', 100,
         'Manejo postquirúrgico',
         'Collar isabelino; retiro de puntos en 10 días.', 10),
       (127, 14, 'Canino', 'Hembra', 'senior', 1.5, 1.5, 'Tumor mamario',
         'Nódulo de 2 cm en cadena mamaria; citología sugestiva de neoplasia.',
         'Le salió una bolita en las mamas', 'Oncología Veterinaria', 40, 'PAF', 'MASTECTOMIA', 50,
         'Manejo del dolor',
         'Revisar la herida a diario si se operó; control en 15 días.', 7),
       (128, 14, 'Canino', null, null, 2, 2, 'Lipoma',
         'Masa blanda debajo de la piel en el costado; citología compatible con lipoma.',
         'Tiene una bola debajo de la piel', 'Oncología Veterinaria', 40, 'PAF', null, 0,
         null,
         null, null),
       (129, 14, 'Canino', null, null, 1.5, 1.5, 'Epilepsia idiopática',
         'Convulsiones generalizadas recurrentes; examen neurológico normal entre crisis.',
         'Tuvo una convulsión', 'Neurología Veterinaria', 40, 'PERFIL', null, 0,
         'Control de convulsiones',
         'Dar el medicamento siempre a la misma hora; anotar fecha y duración de cada crisis.', 30),
       (130, 14, 'Canino', null, null, 1.5, 1.5, 'Obesidad',
         'Condición corporal 8/9; se indica plan de reducción de peso.',
         'Está muy gordo', 'Nutrición Veterinaria', 25, 'EVAL_NUTRI', null, 0,
         'Plan de reducción de peso',
         'Pesar la ración; nada de premios ni comida casera; caminar 30 minutos al día.', 90),
       (131, 14, 'Felino', null, null, 1, 1, 'Obesidad',
         'Condición corporal 8/9; se indica plan de reducción de peso.',
         'Está muy gordo', 'Nutrición Veterinaria', 25, 'EVAL_NUTRI', null, 0,
         'Plan de reducción de peso',
         'Pesar la ración y repartirla en varias tomas; juego diario.', 90),
       (132, 14, 'Canino', null, 'senior', 1.5, 1.5, 'Diabetes mellitus',
         'Glucosa en ayuno de 380 mg/dl con poliuria y polidipsia.',
         'Toma mucha agua y bajó de peso', 'Medicina Interna Veterinaria', 35, 'GLUCOSA', 'PERFIL', 100,
         'Control de diabetes con insulina',
         'Aplicar la insulina después de comer, cada 12 horas; curva de glucosa en 7 días.', 30),
       (133, 14, 'Canino', null, null, 1, 6, 'Fobia a ruidos',
         'Temblor, jadeo y ganas de esconderse con cohetes y tormentas.',
         'Le tiene miedo a la pólvora', 'Etología Veterinaria', 35, null, null, 0,
         'Manejo de la ansiedad',
         'Lugar seguro y sin ventanas; dar el medicamento 2 horas antes de la pólvora.', 7),
       (134, 14, 'Canino', null, null, 1.5, 1.5, 'Ansiedad por separación',
         'Destrozos y ladridos cuando se queda solo.',
         'Rompe todo cuando se queda solo', 'Etología Veterinaria', 35, null, null, 0,
         'Modificación de conducta',
         'Salidas cortas para acostumbrarlo; juguetes rellenables; no castigarlo.', 30),
       (135, 14, 'Canino', null, null, 0.5, 4, 'Intoxicación alimentaria',
         'Ingesta de chocolate o comida de fiesta; vómito e inquietud.',
         'Comió chocolate', 'Urgencias Veterinarias', 40, 'INDUCCION', null, 0,
         'Descontaminación y soporte',
         'Guardar dulces y comida de fiesta fuera de su alcance.', 1),
       (136, 14, 'Canino', null, null, 1, 1, 'Leptospirosis',
         'Fiebre, vómito y orina oscura; prueba rápida positiva. Zoonosis: se orienta a la familia.',
         'Fiebre y orina oscura', 'Medicina Interna Veterinaria', 35, 'HEMOGRAMA', 'PERFIL', 100,
         'Antibioterapia y soporte',
         'Usar guantes al limpiar la orina; completar el antibiótico.', 14),
       (137, 14, 'Ave', null, null, 2, 2, 'Picaje',
         'Se arranca plumas del pecho; asociado a estrés y dieta solo de semillas.',
         'Se arranca las plumas', 'Medicina de Animales Exóticos', 30, null, null, 0,
         'Enriquecimiento ambiental y cambio de dieta',
         'Dieta con pellets, frutas y verduras; juguetes y más tiempo fuera de la jaula.', 60),
       (138, 14, 'Ave', 'Hembra', null, 1.5, 1.5, 'Retención de huevo',
         'Hembra con esfuerzo abdominal y huevo palpable.',
         'Hace fuerza y está esponjada', 'Medicina de Animales Exóticos', 30, 'RX', null, 0,
         'Suplementación de calcio y calor',
         'Mantener en ambiente cálido; volver si no pone el huevo en 24 horas.', 2),
       (139, 14, 'Ave', null, null, 1.5, 1.5, 'Sobrecrecimiento de pico',
         'Pico y uñas largos que le dificultan comer.',
         'Tiene el pico muy largo', 'Medicina de Animales Exóticos', 30, 'CORTE_UNAS', null, 0,
         null,
         null, null),
       (140, 14, 'Ave', null, null, 1, 1, 'Psitacosis',
         'Diarrea verde y secreción ocular; PCR positiva a Chlamydia psittaci. Zoonosis: se orienta al propietario.',
         'Diarrea verde y ojos llorosos', 'Medicina de Animales Exóticos', 30, null, null, 0,
         'Antibioterapia prolongada',
         'Aislar de otras aves; lavar la jaula con desinfectante; usar mascarilla al limpiar.', 45),
       (141, 14, 'Conejo', null, null, 1.5, 1.5, 'Maloclusión dental',
         'Incisivos sobrecrecidos que le impiden comer; se liman.',
         'No puede comer', 'Medicina de Animales Exóticos', 30, 'LIMADO', null, 0,
         'Analgesia',
         'Heno a libre demanda para desgastar los dientes.', 3),
       (142, 14, 'Roedor', null, null, 1, 1, 'Maloclusión dental',
         'Dientes sobrecrecidos que le impiden comer; se liman.',
         'No puede comer', 'Medicina de Animales Exóticos', 30, 'LIMADO', null, 0,
         'Analgesia',
         'Heno y ramas para roer a libre demanda.', 3),
       (143, 14, 'Roedor', 'Hembra', null, 1, 1, 'Tumor mamario',
         'Masa debajo de la piel en la zona mamaria (frecuente en ratas).',
         'Le salió una bola en la panza', 'Medicina de Animales Exóticos', 30, 'PAF', null, 0,
         null,
         null, null),
       (144, 14, 'Reptil', null, null, 2, 2, 'Enfermedad metabólica ósea',
         'Mandíbula blanda y patas deformes por falta de calcio y luz UVB.',
         'Camina raro y no come', 'Medicina de Animales Exóticos', 30, 'RX', null, 0,
         'Suplementación de calcio y corrección del terrario',
         'Lámpara UVB 12 horas al día; calcio sobre cada comida.', 60),
       (145, 14, 'Reptil', null, null, 1, 1, 'Retención de muda',
         'Restos de piel vieja en dedos y cola.',
         'No ha mudado bien', 'Medicina de Animales Exóticos', 30, null, null, 0,
         'Baños tibios y humedad',
         'Baños tibios de 15 minutos y caja húmeda en el terrario.', 7),
       (146, 14, 'Pez', null, null, 1, 1, 'Ictioftiriasis (punto blanco)',
         'Puntos blancos en aletas y cuerpo; se indica tratamiento en el acuario.',
         'Tiene puntitos blancos', 'Medicina de Animales Exóticos', 25, null, null, 0,
         'Tratamiento en el acuario',
         'Subir la temperatura del agua poco a poco y retirar el carbón del filtro.', 7),
       (147, 14, 'Pez', null, null, 0.5, 0.5, 'Podredumbre de aletas',
         'Aletas deshilachadas con bordes blancos; agua con amoníaco alto.',
         'Se le están deshaciendo las aletas', 'Medicina de Animales Exóticos', 25, null, null, 0,
         'Tratamiento en el acuario',
         'Cambios parciales de agua cada 3 días.', 5),
       (148, 14, 'Hurón', null, null, 1, 1, 'Enfermedad adrenal',
         'Pérdida de pelo simétrica en cola y dorso.',
         'Se le cae el pelo de la cola', 'Medicina de Animales Exóticos', 30, 'ECO_ABD', null, 0,
         null,
         null, null),
       (149, 14, 'Anfibio', null, null, 1, 1, 'Infección cutánea por hongos',
         'Piel engrosada con descamación excesiva.',
         'Tiene la piel blanca y se descama', 'Medicina de Animales Exóticos', 30, null, null, 0,
         'Baños antifúngicos',
         'Cambiar el agua y limpiar el acuario.', 7),
       (150, 14, 'Équido', null, null, 1, 1, 'Cólico leve',
         'Dolor abdominal leve que responde al analgésico.',
         'Se revuelca y no come', 'Medicina General Veterinaria', 35, null, null, 0,
         'Analgesia y observación',
         'Retirar la comida 12 horas y caminarlo; volver si regresa el dolor.', 1);
go

-- medicamentos de cada tratamiento (cantidad = unidades que se cobran)
create table #dx_med (id_dx int, orden int, medicamento varchar(150), dosis varchar(100), frecuencia varchar(100),
                      dias int, cantidad int);
insert into #dx_med (id_dx, orden, medicamento, dosis, frecuencia, dias, cantidad)
values (  1, 1, 'Itraconazol 100mg', '5 mg/kg vía oral', 'Cada 24 horas', 42, 3),
       (  1, 2, 'Malaseb Champú', 'Baño completo, dejar actuar 10 minutos', 'Dos veces por semana', 42, 1),
       (  2, 1, 'Itraconazol 100mg', '5 mg/kg vía oral', 'Cada 24 horas', 42, 3),
       (  2, 2, 'Malaseb Champú', 'Baño completo, dejar actuar 10 minutos', 'Dos veces por semana', 42, 1),
       (  3, 1, 'Itrafungol', '5 mg/kg vía oral', 'Cada 24 horas, una semana sí y una no', 42, 1),
       (  3, 2, 'Malaseb Champú', 'Baño completo, dejar actuar 10 minutos', 'Dos veces por semana', 42, 1),
       (  4, 1, 'Itrafungol', '5 mg/kg vía oral', 'Cada 24 horas', 28, 1),
       (  5, 1, 'Itrafungol', '5 mg/kg vía oral', 'Cada 24 horas', 28, 1),
       (  6, 1, 'NexGard Spectra', '1 tableta masticable según peso', 'Cada 30 días', 30, 1),
       (  6, 2, 'Prednisolona 5mg', '0.5 mg/kg vía oral', 'Cada 24 horas', 7, 1),
       (  7, 1, 'Apoquel', '0.5 mg/kg vía oral', 'Cada 12 horas por 14 días, luego cada 24 horas', 30, 2),
       (  7, 2, 'Malaseb Champú', 'Baño completo, dejar actuar 10 minutos', 'Una vez por semana', 30, 1),
       (  8, 1, 'Prednisolona 5mg', '0.5 mg/kg vía oral', 'Cada 24 horas', 10, 1),
       (  9, 1, 'Malaseb Champú', 'Baño completo, dejar actuar 10 minutos', 'Dos veces por semana', 21, 1),
       (  9, 2, 'Itraconazol 100mg', '5 mg/kg vía oral', 'Cada 24 horas', 21, 2),
       ( 10, 1, 'Dexametasona 2mg/ml', '0.1 mg/kg intramuscular', 'Dosis única', 1, 1),
       ( 10, 2, 'Prednisolona 5mg', '0.5 mg/kg vía oral', 'Cada 24 horas', 3, 1),
       ( 11, 1, 'Revolution Plus Gatos', '1 pipeta en la nuca', 'Cada 30 días', 30, 1),
       ( 11, 2, 'Prednisolona 5mg', '1 mg/kg vía oral', 'Cada 24 horas', 7, 1),
       ( 12, 1, 'Bravecto Perros', '1 tableta masticable según peso', 'Dosis única', 1, 1),
       ( 12, 2, 'Prednisolona 5mg', '0.5 mg/kg vía oral', 'Cada 24 horas', 5, 1),
       ( 13, 1, 'NexGard Spectra', '1 tableta masticable según peso', 'Cada 30 días', 90, 3),
       ( 13, 2, 'Malaseb Champú', 'Baño completo, dejar actuar 10 minutos', 'Una vez por semana', 30, 1),
       ( 14, 1, 'Cefalexina 500mg', '25 mg/kg vía oral', 'Cada 12 horas', 21, 2),
       ( 14, 2, 'Malaseb Champú', 'Baño completo, dejar actuar 10 minutos', 'Dos veces por semana', 21, 1),
       ( 15, 1, 'Revolution Plus Gatos', '1 pipeta en la nuca', 'Dosis única, repetir a los 30 días', 30, 2),
       ( 16, 1, 'Ivermectina 1%', '0.4 mg/kg subcutánea', 'Cada 14 días (3 aplicaciones)', 28, 1),
       ( 16, 2, 'Meloxicam Solución', '0.5 mg/kg vía oral', 'Cada 24 horas', 5, 1),
       ( 17, 1, 'Ivermectina 1%', '0.4 mg/kg subcutánea', 'Cada 10 días (3 aplicaciones)', 30, 1),
       ( 18, 1, 'Ivermectina 1%', '0.3 mg/kg subcutánea', 'Dosis única, repetir a los 14 días', 14, 1),
       ( 19, 1, 'Bravecto Perros', '1 tableta masticable según peso', 'Dosis única (protege 12 semanas)', 1, 1),
       ( 20, 1, 'Simparica Trio', '1 tableta masticable según peso', 'Cada 30 días', 30, 1),
       ( 21, 1, 'Frontline Plus', '1 pipeta según peso', 'Cada 30 días', 30, 1),
       ( 21, 2, 'Drontal Plus', '1 tableta por cada 10 kg', 'Dosis única', 1, 1),
       ( 22, 1, 'Revolution Plus Gatos', '1 pipeta en la nuca', 'Cada 30 días', 30, 1),
       ( 22, 2, 'Drontal Gatos', '1 tableta por cada 4 kg', 'Dosis única', 1, 1),
       ( 23, 1, 'Doxitabs', '10 mg/kg vía oral', 'Cada 24 horas', 28, 3),
       ( 23, 2, 'Hemolitan Gold', '1 ml por cada 10 kg vía oral', 'Cada 24 horas', 30, 1),
       ( 23, 3, 'Bravecto Perros', '1 tableta masticable según peso', 'Dosis única (protege 12 semanas)', 1, 1),
       ( 24, 1, 'Doxitabs', '10 mg/kg vía oral', 'Cada 24 horas', 21, 2),
       ( 24, 2, 'Bravecto Perros', '1 tableta masticable según peso', 'Dosis única (protege 12 semanas)', 1, 1),
       ( 25, 1, 'Imizol', '6.6 mg/kg subcutánea', 'Dos dosis separadas por 14 días', 14, 1),
       ( 25, 2, 'Hemolitan Gold', '1 ml por cada 10 kg vía oral', 'Cada 24 horas', 30, 1),
       ( 25, 3, 'Bravecto Perros', '1 tableta masticable según peso', 'Dosis única (protege 12 semanas)', 1, 1),
       ( 26, 1, 'Doxitabs', '10 mg/kg vía oral', 'Cada 24 horas', 28, 3),
       ( 26, 2, 'Prednisolona 5mg', '1 mg/kg vía oral', 'Cada 24 horas', 10, 2),
       ( 26, 3, 'Hemolitan Gold', '1 ml por cada 10 kg vía oral', 'Cada 24 horas', 30, 1),
       ( 27, 1, 'Doxitabs', '10 mg/kg vía oral', 'Cada 24 horas', 21, 1),
       ( 27, 2, 'Prednisolona 5mg', '1 mg/kg vía oral', 'Cada 24 horas', 7, 1),
       ( 28, 1, 'Lactato de Ringer', 'Según déficit de hidratación, vía intravenosa', 'Infusión continua', 3, 4),
       ( 28, 2, 'Ceftriaxona 1g', '25 mg/kg intravenosa', 'Cada 12 horas', 5, 2),
       ( 28, 3, 'Metoclopramida 5mg/ml', '0.5 mg/kg subcutánea', 'Cada 8 horas', 3, 1),
       ( 28, 4, 'Omeprazol Vet', '1 mg/kg vía oral', 'Cada 24 horas', 7, 1),
       ( 29, 1, 'Lactato de Ringer', 'Según déficit de hidratación, vía intravenosa', 'Infusión continua', 3, 4),
       ( 29, 2, 'Ceftriaxona 1g', '25 mg/kg intravenosa', 'Cada 12 horas', 5, 2),
       ( 29, 3, 'Metoclopramida 5mg/ml', '0.5 mg/kg subcutánea', 'Cada 8 horas', 3, 1),
       ( 30, 1, 'Metronidazol Vet', '15 mg/kg vía oral', 'Cada 12 horas', 5, 1),
       ( 30, 2, 'Omeprazol Vet', '1 mg/kg vía oral', 'Cada 24 horas', 5, 1),
       ( 30, 3, 'FortiFlora', '1 sobre sobre la comida', 'Cada 24 horas', 7, 1),
       ( 31, 1, 'Drontal Plus', '1 tableta por cada 10 kg', 'Dosis única, repetir a los 15 días', 15, 2),
       ( 32, 1, 'Panacur 10%', '50 mg/kg vía oral', 'Cada 24 horas', 5, 1),
       ( 32, 2, 'Metronidazol Vet', '15 mg/kg vía oral', 'Cada 12 horas', 7, 1),
       ( 33, 1, 'Cerenia', '2 mg/kg vía oral', 'Cada 24 horas', 3, 1),
       ( 33, 2, 'Omeprazol Vet', '1 mg/kg vía oral', 'Cada 24 horas', 5, 1),
       ( 34, 1, 'Metronidazol Vet', '10 mg/kg vía oral', 'Cada 12 horas', 5, 1),
       ( 34, 2, 'FortiFlora', '1 sobre sobre la comida', 'Cada 24 horas', 7, 1),
       ( 35, 1, 'Drontal Gatos', '1 tableta por cada 4 kg', 'Dosis única, repetir a los 15 días', 15, 2),
       ( 36, 1, 'Baycox 2.5%', '5 mg/kg vía oral', 'Cada 24 horas por 2 días, repetir a los 7 días', 9, 1),
       ( 36, 2, 'Critical Care', 'Alimentación asistida con jeringa', 'Cuatro veces al día', 7, 1),
       ( 37, 1, 'Metoclopramida 5mg/ml', '0.5 mg/kg subcutánea', 'Cada 8 horas', 3, 1),
       ( 37, 2, 'Meloxicam Solución', '0.5 mg/kg vía oral', 'Cada 24 horas', 5, 1),
       ( 37, 3, 'Critical Care', 'Alimentación asistida con jeringa', 'Cuatro veces al día', 7, 1),
       ( 38, 1, 'Metoclopramida 5mg/ml', '0.5 mg/kg subcutánea', 'Cada 8 horas', 3, 1),
       ( 38, 2, 'Meloxicam Solución', '0.5 mg/kg vía oral', 'Cada 24 horas', 5, 1),
       ( 38, 3, 'Critical Care', 'Alimentación asistida con jeringa', 'Cuatro veces al día', 7, 1),
       ( 39, 1, 'Baytril', '10 mg/kg vía oral', 'Cada 24 horas', 7, 1),
       ( 39, 2, 'Critical Care', 'Alimentación asistida con jeringa', 'Cuatro veces al día', 7, 1),
       ( 40, 1, 'Panacur 10%', '20 mg/kg vía oral', 'Dosis única, repetir a los 14 días', 14, 1),
       ( 41, 1, 'Panacur 10%', '50 mg/kg vía oral', 'Cada 24 horas por 3 días, repetir a las 2 semanas', 17, 1),
       ( 42, 1, 'Metronidazol Vet', '15 mg/kg vía oral', 'Cada 12 horas', 7, 1),
       ( 42, 2, 'Omeprazol Vet', '1 mg/kg vía oral', 'Cada 24 horas', 7, 1),
       ( 43, 1, 'Ivermectina 1%', '0.2 mg/kg subcutánea', 'Dosis única', 1, 1),
       ( 44, 1, 'Ivermectina 1%', '0.3 mg/kg subcutánea', 'Dosis única', 1, 1),
       ( 45, 1, 'Ivermectina 1%', '0.2 mg/kg vía oral', 'Dosis única', 1, 1),
       ( 46, 1, 'Epiotic Complete', 'Llenar el conducto y masajear la base de la oreja', 'Cada 24 horas', 10, 1),
       ( 46, 2, 'Otomax', '4 gotas en el oído afectado', 'Cada 12 horas', 7, 1),
       ( 47, 1, 'Epiotic Complete', 'Llenar el conducto y masajear la base de la oreja', 'Cada 24 horas', 10, 1),
       ( 47, 2, 'Otomax', '4 gotas en el oído afectado', 'Cada 12 horas', 7, 1),
       ( 48, 1, 'Otomax', '4 gotas en el oído afectado', 'Cada 12 horas', 10, 1),
       ( 48, 2, 'Prednisolona 5mg', '0.5 mg/kg vía oral', 'Cada 24 horas', 10, 1),
       ( 49, 1, 'Revolution Plus Gatos', '1 pipeta en la nuca', 'Dosis única, repetir a los 30 días', 30, 2),
       ( 49, 2, 'Epiotic Complete', 'Limpieza del oído', 'Cada 48 horas', 10, 1),
       ( 50, 1, 'Baytril', '10 mg/kg vía oral', 'Cada 24 horas', 10, 1),
       ( 50, 2, 'Meloxicam Solución', '0.5 mg/kg vía oral', 'Cada 24 horas', 5, 1),
       ( 51, 1, 'Otomax', '4 gotas en el oído afectado', 'Cada 12 horas', 7, 1),
       ( 52, 1, 'Doxitabs', '10 mg/kg vía oral', 'Cada 24 horas', 14, 2),
       ( 52, 2, 'Bromhexina Jarabe', '1 ml por cada 5 kg vía oral', 'Cada 12 horas', 10, 1),
       ( 52, 3, 'Metamizol 50%', '25 mg/kg subcutánea', 'Cada 12 horas si hay fiebre', 3, 1),
       ( 53, 1, 'Doxitabs', '5 mg/kg vía oral', 'Cada 12 horas', 10, 1),
       ( 53, 2, 'Bromhexina Jarabe', '1 ml por cada 5 kg vía oral', 'Cada 12 horas', 7, 1),
       ( 54, 1, 'Doxitabs', '5 mg/kg vía oral', 'Cada 12 horas', 10, 1),
       ( 54, 2, 'Bromhexina Jarabe', '1 ml por cada 5 kg vía oral', 'Cada 12 horas', 7, 1),
       ( 55, 1, 'Synulox Tablets', '12.5 mg/kg vía oral', 'Cada 12 horas', 14, 2),
       ( 55, 2, 'Enrofloxacina', '5 mg/kg vía oral', 'Cada 24 horas', 14, 1),
       ( 55, 3, 'Bromhexina Jarabe', '1 ml por cada 5 kg vía oral', 'Cada 12 horas', 10, 1),
       ( 56, 1, 'Viralys', '1 dosis de gel vía oral', 'Cada 12 horas', 21, 1),
       ( 56, 2, 'Aureomicina Oftálmica', 'Aplicar en ambos ojos', 'Cada 8 horas', 7, 1),
       ( 57, 1, 'Doxitabs', '10 mg/kg vía oral', 'Cada 24 horas', 10, 1),
       ( 57, 2, 'Meloxicam Solución', '0.05 mg/kg vía oral', 'Cada 24 horas', 3, 1),
       ( 58, 1, 'Baytril', '10 mg/kg vía oral', 'Cada 24 horas', 14, 1),
       ( 58, 2, 'Meloxicam Solución', '0.5 mg/kg vía oral', 'Cada 24 horas', 5, 1),
       ( 59, 1, 'Baytril', '10 mg/kg vía oral', 'Cada 24 horas', 14, 1),
       ( 59, 2, 'Doxitabs', '5 mg/kg vía oral', 'Cada 12 horas', 14, 1),
       ( 60, 1, 'Baytril', '15 mg/kg vía oral', 'Cada 12 horas', 10, 1),
       ( 61, 1, 'Synulox Tablets', '12.5 mg/kg vía oral', 'Cada 12 horas', 10, 2),
       ( 61, 2, 'Rimadyl', '2 mg/kg vía oral', 'Cada 12 horas', 5, 1),
       ( 61, 3, 'Clorhexidina 2%', 'Lavar la herida', 'Cada 12 horas', 10, 1),
       ( 62, 1, 'Cefalexina 500mg', '22 mg/kg vía oral', 'Cada 12 horas', 7, 1),
       ( 62, 2, 'Meloxicam Solución', '0.1 mg/kg vía oral', 'Cada 24 horas', 5, 1),
       ( 63, 1, 'Tramadol Gotas', '3 mg/kg vía oral', 'Cada 8 horas', 5, 1),
       ( 63, 2, 'Rimadyl', '2 mg/kg vía oral', 'Cada 12 horas', 7, 1),
       ( 64, 1, 'Tramadol Gotas', '3 mg/kg vía oral', 'Cada 8 horas', 7, 1),
       ( 64, 2, 'Cefalexina 500mg', '22 mg/kg vía oral', 'Cada 12 horas', 10, 1),
       ( 64, 3, 'Rimadyl', '2 mg/kg vía oral', 'Cada 12 horas', 10, 1),
       ( 65, 1, 'Sulfadiazina de Plata 1%', 'Aplicar una capa fina', 'Cada 12 horas', 10, 1),
       ( 65, 2, 'Tramadol Gotas', '3 mg/kg vía oral', 'Cada 8 horas', 5, 1),
       ( 65, 3, 'Cefalexina 500mg', '22 mg/kg vía oral', 'Cada 12 horas', 7, 1),
       ( 66, 1, 'Rimadyl', '2 mg/kg vía oral', 'Cada 12 horas', 5, 1),
       ( 66, 2, 'Clorhexidina 2%', 'Lavar las heridas', 'Cada 12 horas', 7, 1),
       ( 67, 1, 'Amoxicilina + AC', '12.5 mg/kg vía oral', 'Cada 12 horas', 7, 1),
       ( 67, 2, 'Meloxicam Solución', '0.05 mg/kg vía oral', 'Cada 24 horas', 3, 1),
       ( 68, 1, 'Meloxicam Solución', '0.05 mg/kg vía oral', 'Cada 24 horas', 3, 1),
       ( 68, 2, 'Tramadol Gotas', '2 mg/kg vía oral', 'Cada 12 horas', 5, 1),
       ( 69, 1, 'Clindamicina', '11 mg/kg vía oral', 'Cada 12 horas', 10, 1),
       ( 69, 2, 'Meloxicam Solución', '0.05 mg/kg vía oral', 'Cada 24 horas', 4, 1),
       ( 69, 3, 'Tramadol Gotas', '2 mg/kg vía oral', 'Cada 12 horas', 7, 1),
       ( 70, 1, 'Meloxicam Solución', '1 mg/kg vía oral', 'Cada 24 horas', 7, 1),
       ( 71, 1, 'Baytril', '10 mg/kg vía oral', 'Cada 24 horas', 7, 1),
       ( 71, 2, 'Meloxicam Solución', '0.5 mg/kg vía oral', 'Cada 24 horas', 5, 1),
       ( 72, 1, 'Meloxicam Solución', '0.5 mg/kg vía oral', 'Cada 24 horas', 5, 1),
       ( 73, 1, 'Clorhexidina 2%', 'Lavar la herida', 'Cada 24 horas', 10, 1),
       ( 73, 2, 'Negasunt', 'Aplicar sobre la herida', 'Cada 24 horas', 10, 1),
       ( 74, 1, 'Lactato de Ringer', 'Vía intravenosa según déficit', 'Infusión continua', 1, 2),
       ( 74, 2, 'Omeprazol Vet', '1 mg/kg vía oral', 'Cada 24 horas', 5, 1),
       ( 75, 1, 'Lactato de Ringer', 'Vía intravenosa según déficit', 'Infusión continua', 1, 1),
       ( 76, 1, 'Lactato de Ringer', 'Vía subcutánea', 'Cada 12 horas', 1, 1),
       ( 77, 1, 'Lactato de Ringer', 'Vía subcutánea', 'Cada 12 horas', 1, 1),
       ( 79, 1, 'Ivermectina 1%', '0.2 mg/kg subcutánea', 'Dosis única', 1, 1),
       ( 79, 2, 'Negasunt', 'Aplicar sobre la herida', 'Cada 24 horas', 7, 1),
       ( 79, 3, 'Synulox Tablets', '12.5 mg/kg vía oral', 'Cada 12 horas', 7, 1),
       ( 80, 1, 'Capstar', '1 tableta vía oral', 'Dosis única', 1, 1),
       ( 80, 2, 'Clorhexidina 2%', 'Lavar la herida', 'Cada 12 horas', 7, 1),
       ( 80, 3, 'Amoxicilina + AC', '12.5 mg/kg vía oral', 'Cada 12 horas', 7, 1),
       ( 81, 1, 'Baytril', '10 mg/kg vía oral', 'Cada 24 horas', 7, 1),
       ( 81, 2, 'Meloxicam Solución', '0.5 mg/kg vía oral', 'Cada 24 horas', 5, 1),
       ( 82, 1, 'Ivermectina 1%', '0.2 mg/kg subcutánea', 'Dosis única', 1, 1),
       ( 82, 2, 'Negasunt', 'Aplicar sobre la herida', 'Cada 24 horas', 7, 1),
       ( 83, 1, 'Ivermectina 1%', '0.3 mg/kg subcutánea', 'Dosis única', 1, 1),
       ( 83, 2, 'Negasunt', 'Aplicar sobre la herida', 'Cada 24 horas', 7, 1),
       ( 84, 1, 'Ivermectina 1%', '0.2 mg/kg subcutánea', 'Dosis única', 1, 1),
       ( 84, 2, 'Negasunt', 'Aplicar sobre la herida', 'Cada 24 horas', 7, 1),
       ( 85, 1, 'Vanguard Plus 5/L4', '1 ml subcutánea', 'Dosis única', 1, 1),
       ( 85, 2, 'Nobivac Rabies', '1 ml subcutánea', 'Dosis única', 1, 1),
       ( 86, 1, 'Vanguard Plus 5/L4', '1 ml subcutánea', 'Dosis única', 1, 1),
       ( 86, 2, 'Panacur 10%', '50 mg/kg vía oral', 'Cada 24 horas', 3, 1),
       ( 87, 1, 'Felocell 3', '1 ml subcutánea', 'Dosis única', 1, 1),
       ( 87, 2, 'Nobivac Rabies', '1 ml subcutánea', 'Dosis única', 1, 1),
       ( 88, 1, 'Felocell 3', '1 ml subcutánea', 'Dosis única', 1, 1),
       ( 88, 2, 'Panacur 10%', '50 mg/kg vía oral', 'Cada 24 horas', 3, 1),
       ( 89, 1, 'Drontal Plus', '1 tableta por cada 10 kg', 'Dosis única', 1, 1),
       ( 89, 2, 'NexGard Spectra', '1 tableta masticable según peso', 'Cada 30 días', 30, 1),
       ( 90, 1, 'Drontal Gatos', '1 tableta por cada 4 kg', 'Dosis única', 1, 1),
       ( 90, 2, 'Revolution Plus Gatos', '1 pipeta en la nuca', 'Cada 30 días', 30, 1),
       (106, 1, 'Ivermectina 1%', '0.2 mg/kg vía oral', 'Dosis única', 1, 1),
       (107, 1, 'Ivermectina 1%', '0.3 mg/kg subcutánea', 'Dosis única', 1, 1),
       (108, 1, 'Ivermectina 1%', '0.2 mg/kg subcutánea', 'Dosis única', 1, 1),
       (109, 1, 'Clindamicina', '11 mg/kg vía oral', 'Cada 24 horas', 7, 1),
       (109, 2, 'Meloxicam Solución', '0.1 mg/kg vía oral', 'Cada 24 horas', 3, 1),
       (110, 1, 'Clindamicina', '11 mg/kg vía oral', 'Cada 24 horas', 7, 1),
       (110, 2, 'Meloxicam Solución', '0.05 mg/kg vía oral', 'Cada 24 horas', 3, 1),
       (111, 1, 'Tobramicina Gotas', '1 gota en el ojo afectado', 'Cada 8 horas', 7, 1),
       (112, 1, 'Aureomicina Oftálmica', 'Aplicar en el ojo afectado', 'Cada 8 horas', 7, 1),
       (113, 1, 'Tobramicina Gotas', '1 gota en el ojo afectado', 'Cada 6 horas', 10, 1),
       (114, 1, 'Tobramicina Gotas', '1 gota en el ojo afectado', 'Cada 6 horas', 10, 1),
       (116, 1, 'Rimadyl', '2 mg/kg vía oral', 'Cada 12 horas', 14, 2),
       (117, 1, 'Rimadyl', '2 mg/kg vía oral', 'Cada 12 horas', 30, 2),
       (118, 1, 'Rimadyl', '2 mg/kg vía oral', 'Cada 12 horas', 10, 1),
       (118, 2, 'Tramadol Gotas', '3 mg/kg vía oral', 'Cada 8 horas', 7, 1),
       (119, 1, 'Vetmedin 5mg', '0.25 mg/kg vía oral', 'Cada 12 horas', 30, 1),
       (119, 2, 'Furosemida 40mg', '2 mg/kg vía oral', 'Cada 12 horas', 30, 2),
       (120, 1, 'Atenolol 25mg', '6.25 mg por gato vía oral', 'Cada 24 horas', 30, 1),
       (121, 1, 'Fortekor 5mg', '0.5 mg/kg vía oral', 'Cada 24 horas', 30, 1),
       (121, 2, 'Ketosteril Vet', '1 tableta por cada 5 kg', 'Cada 24 horas', 30, 1),
       (122, 1, 'Fortekor 5mg', '0.5 mg/kg vía oral', 'Cada 24 horas', 30, 1),
       (122, 2, 'Ketosteril Vet', '1 tableta por cada 5 kg', 'Cada 24 horas', 30, 1),
       (123, 1, 'Meloxicam Solución', '0.05 mg/kg vía oral', 'Cada 24 horas', 3, 1),
       (123, 2, 'Cranberry Urinary', '1 tableta vía oral', 'Cada 24 horas', 30, 1),
       (124, 1, 'Enrofloxacina', '5 mg/kg vía oral', 'Cada 24 horas', 10, 1),
       (124, 2, 'Cranberry Urinary', '1 tableta vía oral', 'Cada 24 horas', 30, 1),
       (125, 1, 'Lactato de Ringer', 'Vía intravenosa según déficit', 'Infusión continua', 2, 2),
       (125, 2, 'Tramadol Gotas', '2 mg/kg vía oral', 'Cada 12 horas', 5, 1),
       (126, 1, 'Synulox Tablets', '12.5 mg/kg vía oral', 'Cada 12 horas', 10, 2),
       (126, 2, 'Tramadol Gotas', '3 mg/kg vía oral', 'Cada 8 horas', 5, 1),
       (127, 1, 'Tramadol Gotas', '3 mg/kg vía oral', 'Cada 8 horas', 5, 1),
       (127, 2, 'Rimadyl', '2 mg/kg vía oral', 'Cada 12 horas', 5, 1),
       (129, 1, 'Fenobarbital 100mg', '2.5 mg/kg vía oral', 'Cada 12 horas', 30, 1),
       (132, 1, 'Caninsulin', '0.5 UI/kg subcutánea', 'Cada 12 horas', 30, 1),
       (133, 1, 'Trazodona 50mg', '5 mg/kg vía oral', 'Antes de la exposición al ruido', 7, 1),
       (134, 1, 'Trazodona 50mg', '5 mg/kg vía oral', 'Cada 24 horas', 30, 1),
       (135, 1, 'Carbón Activado', '1 g/kg vía oral', 'Dosis única', 1, 1),
       (135, 2, 'Lactato de Ringer', 'Vía intravenosa', 'Infusión continua', 1, 1),
       (136, 1, 'Doxitabs', '5 mg/kg vía oral', 'Cada 12 horas', 14, 2),
       (136, 2, 'Lactato de Ringer', 'Vía intravenosa según déficit', 'Infusión continua', 3, 2),
       (138, 1, 'Gluconato de Calcio 10%', '50 mg/kg intramuscular', 'Cada 12 horas', 2, 1),
       (140, 1, 'Doxitabs', '25 mg/kg vía oral', 'Cada 24 horas', 45, 1),
       (141, 1, 'Meloxicam Solución', '0.5 mg/kg vía oral', 'Cada 24 horas', 3, 1),
       (142, 1, 'Meloxicam Solución', '0.5 mg/kg vía oral', 'Cada 24 horas', 3, 1),
       (144, 1, 'Repti Calcium con D3', 'Espolvorear sobre el alimento', 'En cada comida', 60, 1),
       (146, 1, 'Azul de Metileno 1%', '1 ml por cada 10 litros de agua', 'Cada 24 horas', 7, 1),
       (147, 1, 'Azul de Metileno 1%', '1 ml por cada 10 litros de agua', 'Cada 24 horas', 5, 1),
       (149, 1, 'Itrafungol', 'Baño de 5 minutos en solución diluida', 'Cada 24 horas', 7, 1),
       (150, 1, 'Metamizol 50%', '25 mg/kg intravenosa', 'Dosis única', 1, 1);

create table #proc_cat (codigo varchar(20), nombre varchar(100), descripcion varchar(200), costo decimal(10, 2));
insert into #proc_cat (codigo, nombre, descripcion, costo)
values ('LIMP_OTICA', 'Limpieza ótica profunda', 'Lavado clínico del conducto auditivo externo.', 15),
       ('CITO_OTICA', 'Citología ótica', 'Toma de muestra del conducto auditivo y tinción.', 12),
       ('HEMOGRAMA', 'Hemograma completo', 'Conteo de células sanguíneas y plaquetas.', 15),
       ('RASPADO', 'Raspado de piel', 'Toma de muestra para búsqueda de ácaros.', 10),
       ('CITO_PIEL', 'Citología de piel', 'Tinción e identificación de bacterias y levaduras.', 12),
       ('WOOD', 'Examen con lámpara de Wood', 'Revisión de pelo y piel con luz ultravioleta.', 8),
       ('TRICOGRAMA', 'Tricograma', 'Revisión microscópica del pelo.', 10),
       ('CULTIVO', 'Cultivo micológico', 'Siembra de pelo en medio DTM para hongos.', 25),
       ('COPRO', 'Coprológico por flotación', 'Examen de heces para parásitos gastrointestinales.', 10),
       ('SNAP_PARVO', 'Prueba rápida de parvovirus', 'Detección de antígeno de parvovirus en heces.', 25),
       ('SNAP_4DX', 'Prueba rápida 4Dx', 'Detección de Ehrlichia, Anaplasma, Borrelia y Dirofilaria.', 35),
       ('FROTIS', 'Frotis sanguíneo', 'Búsqueda de hemoparásitos al microscopio.', 10),
       ('HOSP', 'Hospitalización (72 horas)', 'Internamiento con fluidoterapia y monitoreo.', 120),
       ('FLUIDO', 'Fluidoterapia intravenosa', 'Administración de líquidos y electrolitos.', 35),
       ('RX_TORAX', 'Radiografía de tórax', 'Dos proyecciones para evaluar pulmones y corazón.', 30),
       ('NEBULIZ', 'Nebulización', 'Terapia respiratoria para fluidificar secreciones.', 20),
       ('SNAP_MOQ', 'Prueba rápida de moquillo', 'Detección de antígeno de moquillo en secreción conjuntival.', 25),
       ('CURACION', 'Curación de herida', 'Limpieza, desbridamiento y vendaje de la herida.', 20),
       ('SUTURA', 'Sutura de herida', 'Cierre de herida con anestesia local o sedación.', 35),
       ('RX', 'Radiografía digital', 'Dos proyecciones ortogonales de la zona afectada.', 40),
       ('OSTEOSINTESIS', 'Cirugía ortopédica - Osteosíntesis', 'Fijación de fractura con placa y tornillos.', 350),
       ('ENFRIAMIENTO', 'Enfriamiento activo y monitoreo', 'Baño con agua templada y control de temperatura cada 10 minutos.', 30),
       ('LARVAS', 'Extracción de larvas', 'Retiro manual de larvas, lavado y curación de la herida.', 25),
       ('FLUORESCEINA', 'Prueba de fluoresceína', 'Tinción ocular para detectar úlceras.', 8),
       ('LIMP_OCULAR', 'Limpieza ocular con suero', 'Lavado de sacos conjuntivales.', 8),
       ('ECOCARDIO', 'Ecocardiograma Doppler', 'Evaluación de cámaras y flujo cardíaco.', 65),
       ('PERFIL', 'Perfil bioquímico', 'Análisis de función renal y hepática.', 35),
       ('ORINA', 'Examen general de orina', 'Toma de muestra y lectura de sedimento.', 12),
       ('ECO_ABD', 'Ecografía abdominal', 'Evaluación de órganos abdominales por imagen.', 40),
       ('PROFILAXIS', 'Profilaxis dental con ultrasonido', 'Limpieza dental bajo anestesia.', 60),
       ('EXT_DENTAL', 'Extracción dental', 'Extracción de pieza dental dañada.', 20),
       ('GLUCOSA', 'Medición de glucosa en sangre', 'Control rápido con glucómetro.', 6),
       ('CORTE_UNAS', 'Corte de uñas y pico', 'Recorte y limado de uñas y pico.', 8),
       ('LIMADO', 'Limado dental', 'Corrección de dientes sobrecrecidos en conejos y roedores.', 25),
       ('OVH', 'Ovariohisterectomía', 'Extirpación de útero y ovarios.', 180),
       ('MASTECTOMIA', 'Mastectomía regional', 'Extirpación de la cadena mamaria afectada.', 220),
       ('PAF', 'Citología por aspiración (PAF)', 'Punción con aguja fina para analizar la masa.', 20),
       ('EVAL_NUTRI', 'Evaluación nutricional', 'Cálculo de condición corporal y plan alimenticio.', 20),
       ('RET_SUTURA', 'Retiro de suturas', 'Extracción de puntos y limpieza de la zona.', 15),
       ('DRENAJE', 'Drenaje de otohematoma', 'Drenaje y colocación de puntos en el pabellón auricular.', 45),
       ('SONDAJE', 'Sondaje uretral', 'Desobstrucción uretral bajo sedación.', 45),
       ('INDUCCION', 'Inducción del vómito', 'Inducción controlada del vómito y lavado gástrico.', 25),
       ('VENDAJE', 'Vendaje de inmovilización', 'Vendaje para inmovilizar ala o miembro.', 15),
       ('RET_GARRAPATAS', 'Retiro manual de garrapatas', 'Extracción de garrapatas con pinza.', 8),
       ('FISIO', 'Sesión de fisioterapia', 'Ejercicios asistidos y masaje terapéutico.', 20);
go

-- 2.2 perfil de razas para las mascotas nuevas: popularidad, peso adulto (kg) y años de vida
create table #raza_perfil (especie varchar(30), raza varchar(100), popularidad int, peso_min decimal(8, 2),
                           peso_max decimal(8, 2), tamanio varchar(50), vida int);
insert into #raza_perfil (especie, raza, popularidad, peso_min, peso_max, tamanio, vida)
values ('Canino', 'Labrador Retriever', 6, 25, 36, null, 13),
       ('Canino', 'Pastor Alemán', 6, 25, 40, null, 12),
       ('Canino', 'Chihuahua', 10, 1.5, 3, null, 16),
       ('Canino', 'Golden Retriever', 4, 25, 34, null, 12),
       ('Canino', 'Bulldog Francés', 4, 8, 14, null, 11),
       ('Canino', 'Mestizo', 35, 6, 28, null, 15),
       ('Canino', 'Schnauzer Miniatura', 8, 5, 9, null, 14),
       ('Canino', 'Shih Tzu', 8, 4, 8, null, 14),
       ('Canino', 'Poodle', 7, 3, 8, null, 15),
       ('Canino', 'Husky Siberiano', 5, 18, 27, null, 13),
       ('Canino', 'Pitbull', 4, 16, 30, null, 13),
       ('Canino', 'Beagle', 3, 9, 14, null, 14),
       ('Felino', 'Siamés', 10, 3, 5, 'Mediano', 17),
       ('Felino', 'Persa', 7, 3, 5.5, 'Mediano', 15),
       ('Felino', 'Bengalí', 2, 4, 6.5, 'Mediano', 15),
       ('Felino', 'Maine Coon', 2, 5.5, 9, 'Grande', 14),
       ('Felino', 'Angora', 4, 3, 5, 'Mediano', 16),
       ('Felino', 'Doméstico de Pelo Corto', 60, 3, 6, 'Mediano', 17),
       ('Felino', 'Doméstico de Pelo Largo', 15, 3, 6, 'Mediano', 16),
       ('Ave', 'Loro', 12, 0.3, 0.5, 'Pequeño', 30),
       ('Ave', 'Canario', 20, 0.02, 0.03, 'Pequeño', 10),
       ('Ave', 'Cacatúa', 8, 0.3, 0.6, 'Pequeño', 30),
       ('Ave', 'Periquito', 35, 0.03, 0.04, 'Pequeño', 8),
       ('Ave', 'Agapornis', 25, 0.04, 0.06, 'Pequeño', 12),
       ('Roedor', 'Hámster Sirio', 35, 0.1, 0.18, 'Pequeño', 3),
       ('Roedor', 'Cobaya', 25, 0.7, 1.2, 'Pequeño', 7),
       ('Roedor', 'Chinchilla', 15, 0.4, 0.7, 'Pequeño', 15),
       ('Roedor', 'Rata Fancy', 15, 0.25, 0.5, 'Pequeño', 3),
       ('Roedor', 'Jerbo', 10, 0.06, 0.1, 'Pequeño', 4),
       ('Conejo', 'Holandés', 25, 1.6, 2.5, 'Pequeño', 10),
       ('Conejo', 'Angora', 10, 2.5, 4, 'Mediano', 10),
       ('Conejo', 'Rex', 15, 3, 4.5, 'Mediano', 10),
       ('Conejo', 'Lionhead', 20, 1.4, 1.9, 'Pequeño', 10),
       ('Conejo', 'Mini Lop', 30, 1.5, 2.5, 'Pequeño', 10),
       ('Reptil', 'Dragón Barbudo', 35, 0.3, 0.55, 'Mediano', 12),
       ('Reptil', 'Gecko Leopardo', 40, 0.05, 0.09, 'Pequeño', 15),
       ('Reptil', 'Iguana Verde', 25, 2, 5, 'Grande', 15),
       ('Pez', 'Betta', 50, 0.01, 0.01, 'Pequeño', 4),
       ('Pez', 'Goldfish', 35, 0.03, 0.1, 'Pequeño', 10),
       ('Pez', 'Guppy', 15, 0.01, 0.01, 'Pequeño', 3),
       ('Hurón', 'Hurón Estándar', 70, 0.8, 1.8, 'Pequeño', 8),
       ('Hurón', 'Hurón Angora', 15, 0.8, 1.5, 'Pequeño', 8),
       ('Hurón', 'Hurón Albino', 15, 0.8, 1.6, 'Pequeño', 8),
       ('Anfibio', 'Axolotl', 60, 0.1, 0.3, 'Pequeño', 12),
       ('Anfibio', 'Rana Africana', 25, 0.05, 0.12, 'Pequeño', 10),
       ('Anfibio', 'Salamandra Tigre', 15, 0.08, 0.15, 'Pequeño', 12),
       ('Équido', 'Caballo Árabe', 40, 380, 480, 'Grande', 28),
       ('Équido', 'Poni Shetland', 30, 150, 200, 'Mediano', 28),
       ('Équido', 'Burro Andaluz', 30, 180, 250, 'Mediano', 30),
       ('Porcino', 'Cerdo Vietnamita', 70, 40, 90, 'Mediano', 15),
       ('Porcino', 'Duroc', 15, 120, 250, 'Grande', 12),
       ('Porcino', 'Landrace', 15, 120, 250, 'Grande', 12),
       ('Ovino', 'Merino', 30, 45, 80, 'Mediano', 11),
       ('Ovino', 'Suffolk', 30, 60, 100, 'Mediano', 11),
       ('Ovino', 'Dorper', 40, 50, 90, 'Mediano', 11);

select x.especie, x.id_raza, x.peso_min, x.peso_max, x.tamanio, x.vida,
       (x.acum - x.popularidad) * 1.0 / x.total as desde,
       x.acum * 1.0 / x.total as hasta
into #raza_rango
from (select rp.*, r.id_raza,
             sum(rp.popularidad) over (partition by rp.especie order by r.id_raza rows unbounded preceding) as acum,
             sum(rp.popularidad) over (partition by rp.especie) as total
      from #raza_perfil rp
      join dbo.especies e on e.nombre_e = rp.especie
      join dbo.razas r on r.id_especie = e.id_especie and r.nombre_r = rp.raza) x;

-- 2.3 nombres, apellidos y direcciones
create table #nombre_mascota (sexo varchar(10), idx int, nombre varchar(100));
insert into #nombre_mascota (sexo, idx, nombre)
values ('Macho', 0, 'Max'),
       ('Macho', 1, 'Rocky'),
       ('Macho', 2, 'Toby'),
       ('Macho', 3, 'Simba'),
       ('Macho', 4, 'Thor'),
       ('Macho', 5, 'Zeus'),
       ('Macho', 6, 'Bruno'),
       ('Macho', 7, 'Rex'),
       ('Macho', 8, 'Oso'),
       ('Macho', 9, 'Milo'),
       ('Macho', 10, 'Lucky'),
       ('Macho', 11, 'Bobby'),
       ('Macho', 12, 'Firulais'),
       ('Macho', 13, 'Chester'),
       ('Macho', 14, 'Kaiser'),
       ('Macho', 15, 'Duque'),
       ('Macho', 16, 'Rufo'),
       ('Macho', 17, 'Pancho'),
       ('Macho', 18, 'Tommy'),
       ('Macho', 19, 'Oreo'),
       ('Macho', 20, 'Copito'),
       ('Macho', 21, 'Negro'),
       ('Macho', 22, 'Canelo'),
       ('Macho', 23, 'Coco'),
       ('Macho', 24, 'Jack'),
       ('Macho', 25, 'Leo'),
       ('Macho', 26, 'Rambo'),
       ('Macho', 27, 'Chispas'),
       ('Macho', 28, 'Tigre'),
       ('Macho', 29, 'Benito'),
       ('Hembra', 0, 'Luna'),
       ('Hembra', 1, 'Nala'),
       ('Hembra', 2, 'Bella'),
       ('Hembra', 3, 'Kira'),
       ('Hembra', 4, 'Mía'),
       ('Hembra', 5, 'Lola'),
       ('Hembra', 6, 'Maya'),
       ('Hembra', 7, 'Daisy'),
       ('Hembra', 8, 'Nina'),
       ('Hembra', 9, 'Pelusa'),
       ('Hembra', 10, 'Canela'),
       ('Hembra', 11, 'Princesa'),
       ('Hembra', 12, 'Sasha'),
       ('Hembra', 13, 'Kiara'),
       ('Hembra', 14, 'Frida'),
       ('Hembra', 15, 'Mora'),
       ('Hembra', 16, 'Chispa'),
       ('Hembra', 17, 'Lucy'),
       ('Hembra', 18, 'Molly'),
       ('Hembra', 19, 'Cleo'),
       ('Hembra', 20, 'Perla'),
       ('Hembra', 21, 'Estrella'),
       ('Hembra', 22, 'Mimi'),
       ('Hembra', 23, 'Linda'),
       ('Hembra', 24, 'Pepa'),
       ('Hembra', 25, 'Laika'),
       ('Hembra', 26, 'Fiona'),
       ('Hembra', 27, 'Dulce'),
       ('Hembra', 28, 'Greta'),
       ('Hembra', 29, 'Manchas');

create table #nombre_persona (genero varchar(10), idx int, nombre varchar(100));
insert into #nombre_persona (genero, idx, nombre)
values ('M', 0, 'José'),
       ('M', 1, 'Juan'),
       ('M', 2, 'Carlos'),
       ('M', 3, 'Luis'),
       ('M', 4, 'Jorge'),
       ('M', 5, 'Miguel'),
       ('M', 6, 'Francisco'),
       ('M', 7, 'Mario'),
       ('M', 8, 'Óscar'),
       ('M', 9, 'Roberto'),
       ('M', 10, 'René'),
       ('M', 11, 'Manuel'),
       ('M', 12, 'Rafael'),
       ('M', 13, 'Fernando'),
       ('M', 14, 'Ricardo'),
       ('M', 15, 'Mauricio'),
       ('M', 16, 'Edwin'),
       ('M', 17, 'Wilfredo'),
       ('M', 18, 'Kevin'),
       ('M', 19, 'Daniel'),
       ('M', 20, 'David'),
       ('M', 21, 'Josué'),
       ('M', 22, 'Alejandro'),
       ('M', 23, 'Javier'),
       ('M', 24, 'Héctor'),
       ('M', 25, 'Raúl'),
       ('M', 26, 'Julio'),
       ('M', 27, 'Ernesto'),
       ('M', 28, 'Nelson'),
       ('M', 29, 'Douglas'),
       ('F', 0, 'María'),
       ('F', 1, 'Ana'),
       ('F', 2, 'Rosa'),
       ('F', 3, 'Carmen'),
       ('F', 4, 'Gloria'),
       ('F', 5, 'Marta'),
       ('F', 6, 'Sandra'),
       ('F', 7, 'Claudia'),
       ('F', 8, 'Patricia'),
       ('F', 9, 'Karla'),
       ('F', 10, 'Andrea'),
       ('F', 11, 'Daniela'),
       ('F', 12, 'Fátima'),
       ('F', 13, 'Gabriela'),
       ('F', 14, 'Silvia'),
       ('F', 15, 'Reina'),
       ('F', 16, 'Ingrid'),
       ('F', 17, 'Jennifer'),
       ('F', 18, 'Katherine'),
       ('F', 19, 'Alejandra'),
       ('F', 20, 'Lucía'),
       ('F', 21, 'Sofía'),
       ('F', 22, 'Valeria'),
       ('F', 23, 'Evelyn'),
       ('F', 24, 'Beatriz'),
       ('F', 25, 'Xiomara'),
       ('F', 26, 'Yesenia'),
       ('F', 27, 'Wendy'),
       ('F', 28, 'Marisol'),
       ('F', 29, 'Elena');

create table #apellido (idx int, apellido varchar(100));
insert into #apellido (idx, apellido)
values (0, 'Hernández'),
       (1, 'López'),
       (2, 'Martínez'),
       (3, 'García'),
       (4, 'Rodríguez'),
       (5, 'Ramírez'),
       (6, 'Flores'),
       (7, 'Rivera'),
       (8, 'González'),
       (9, 'Pérez'),
       (10, 'Cruz'),
       (11, 'Mejía'),
       (12, 'Sánchez'),
       (13, 'Romero'),
       (14, 'Díaz'),
       (15, 'Aguilar'),
       (16, 'Ramos'),
       (17, 'Reyes'),
       (18, 'Torres'),
       (19, 'Vásquez'),
       (20, 'Portillo'),
       (21, 'Rivas'),
       (22, 'Alvarado'),
       (23, 'Guevara'),
       (24, 'Escobar'),
       (25, 'Menjívar'),
       (26, 'Orellana'),
       (27, 'Castro'),
       (28, 'Morales'),
       (29, 'Chávez'),
       (30, 'Campos'),
       (31, 'Argueta'),
       (32, 'Ayala'),
       (33, 'Bonilla'),
       (34, 'Molina'),
       (35, 'Mendoza'),
       (36, 'Henríquez'),
       (37, 'Quintanilla'),
       (38, 'Cáceres'),
       (39, 'Fuentes');

create table #colonia (idx int, colonia varchar(100), municipio varchar(100));
insert into #colonia (idx, colonia, municipio)
values (0, 'Colonia Escalón', 'San Salvador'),
       (1, 'Colonia San Benito', 'San Salvador'),
       (2, 'Colonia Miramonte', 'San Salvador'),
       (3, 'Colonia Flor Blanca', 'San Salvador'),
       (4, 'Colonia Médica', 'San Salvador'),
       (5, 'Colonia Centroamérica', 'San Salvador'),
       (6, 'Barrio San Jacinto', 'San Salvador'),
       (7, 'Colonia Layco', 'San Salvador'),
       (8, 'Colonia Satélite', 'San Salvador'),
       (9, 'Colonia Costa Rica', 'San Salvador'),
       (10, 'Colonia Atlacatl', 'San Salvador'),
       (11, 'Colonia San Mauricio', 'San Salvador'),
       (12, 'Colonia Zacamil', 'Mejicanos'),
       (13, 'Colonia Montebello', 'Mejicanos'),
       (14, 'Residencial Altavista', 'Ilopango'),
       (15, 'Colonia Santa Lucía', 'Ilopango'),
       (16, 'Urbanización Bosques de Prusia', 'Soyapango'),
       (17, 'Colonia Los Conacastes', 'Soyapango'),
       (18, 'Colonia Guadalupe', 'Soyapango'),
       (19, 'Residencial Valle del Sol', 'Apopa'),
       (20, 'Reparto Santa Alegría', 'Ciudad Delgado'),
       (21, 'Urbanización Madre Selva', 'Antiguo Cuscatlán'),
       (22, 'Colonia La Sultana', 'Antiguo Cuscatlán'),
       (23, 'Residencial Cumbres de Cuscatlán', 'Antiguo Cuscatlán'),
       (24, 'Residencial Santa Teresa', 'Santa Tecla'),
       (25, 'Colonia Utila', 'Santa Tecla'),
       (26, 'Urbanización Jardines de la Sabana', 'Santa Tecla'),
       (27, 'Colonia Las Delicias', 'Santa Tecla'),
       (28, 'Residencial Pinares de Suiza', 'Santa Tecla'),
       (29, 'Colonia Jardines de Guadalupe', 'Antiguo Cuscatlán');

create table #calle (idx int, calle varchar(100));
insert into #calle (idx, calle)
values (0, 'Calle Principal'),
       (1, 'Pasaje 3'),
       (2, 'Avenida Las Palmeras'),
       (3, 'Pasaje Los Pinos'),
       (4, 'Calle El Mirador'),
       (5, 'Senda 5'),
       (6, 'Calle Los Almendros'),
       (7, 'Pasaje B'),
       (8, 'Avenida Bernal'),
       (9, 'Calle Las Rosas');

-- dominio de correo según porcentaje acumulado
create table #dominio (dominio varchar(50), desde int, hasta int);
insert into #dominio (dominio, desde, hasta)
values ('gmail.com', 0, 60),
       ('hotmail.com', 60, 85),
       ('yahoo.com', 85, 93),
       ('outlook.com', 93, 100);
go

/* ------------------------------------------------------------
   3. calendario de los dos años de operación
   dia: 1 = lunes ... 7 = domingo (no depende de set datefirst)
   ------------------------------------------------------------ */
select x.anio_op, x.fecha, year(x.fecha) as anio, month(x.fecha) as mes,
       datediff(day, cast('1900-01-01' as date), x.fecha) % 7 + 1 as dia
into #calendario0
from (select a.anio_op, cast(dateadd(day, n.n - 1, a.inicio) as date) as fecha
      from #anio a
      join #n n on n.n <= datediff(day, a.inicio, a.fin) + 1) x;

-- ocurrencia: 1.er, 2.º, ... lunes del mes; veces: cuántos lunes tiene el mes
select c.*,
       row_number() over (partition by c.anio, c.mes, c.dia order by c.fecha) as ocurrencia,
       count(*) over (partition by c.anio, c.mes, c.dia) as veces
into #calendario
from #calendario0 c;
go

/* ------------------------------------------------------------
   4. consultas atendidas: fecha y hora
   Cada franja del documento (temporada, día, hora) se reparte entre
   los meses de su temporada en proporción a las consultas de cada
   mes, y dentro del mes entre las fechas de ese día de la semana.
   ------------------------------------------------------------ */
-- 4.1 meses de cada año de operación en orden; hasta = acumulado dentro de la temporada
select a.anio_op, m.mes, m.temporada, m.consultas,
       case when m.mes >= 11 then year(a.inicio) else year(a.fin) end as anio,
       sum(m.consultas) over (partition by a.anio_op, m.temporada
                              order by case when m.mes >= 11 then m.mes - 12 else m.mes end
                              rows unbounded preceding) as hasta
into #mes_rango
from #anio a
cross join #mes m;

-- 4.2 cada consulta de una franja recibe una clave entre 0 y 1 repartida en partes
--     iguales; ordenadas por clave, las primeras van al primer mes de la temporada,
--     las siguientes al segundo, etc. Así cada mes recibe su parte de cada franja.
select a.anio_op, f.temporada, f.dia, f.hora,
       row_number() over (partition by a.anio_op, f.temporada
                          order by (2.0 * n.n - 1) / (2.0 * f.cantidad), f.dia, f.hora) as r
into #u1
from #franja f
cross join #anio a
join #n n on n.n <= f.cantidad;

select u.anio_op, mr.anio, mr.mes, u.dia, u.hora, u.r,
       row_number() over (partition by mr.anio, mr.mes, u.dia, u.hora order by u.r) as k
into #u2
from #u1 u
join #mes_rango mr on mr.anio_op = u.anio_op and mr.temporada = u.temporada
                  and u.r between mr.hasta - mr.consultas + 1 and mr.hasta;

-- 4.3 las citas completadas de los datos base ya ocupan su lugar
select b.anio, b.mes, b.dia, b.hora, count(*) as cantidad
into #base_franja
from (select year(c.fecha_c) as anio, month(c.fecha_c) as mes,
             datediff(day, cast('1900-01-01' as date), cast(c.fecha_c as date)) % 7 + 1 as dia,
             datepart(hour, c.fecha_c) as hora
      from dbo.citas c
      where c.estado_c = 'Completada'
        and cast(c.fecha_c as date) between cast('2024-11-01' as date) and cast('2026-10-31' as date)) b
group by b.anio, b.mes, b.dia, b.hora;

select u.anio_op, u.anio, u.mes, u.dia, u.hora, u.r,
       row_number() over (partition by u.anio, u.mes, u.dia, u.hora order by u.r) as k
into #u3
from #u2 u
left join #base_franja b on b.anio = u.anio and b.mes = u.mes and b.dia = u.dia and b.hora = u.hora
where u.k > isnull(b.cantidad, 0);

-- 4.4 fecha: se reparten entre los lunes (martes, ...) del mes, rotando por hora
select u.anio_op, u.anio, u.mes, u.dia, u.hora, u.r, c.fecha
into #slot
from #u3 u
join #calendario c on c.anio = u.anio and c.mes = u.mes and c.dia = u.dia
                  and c.ocurrencia = (u.k - 1 + u.hora) % c.veces + 1;
go

/* ------------------------------------------------------------
   5. enfermedad de cada consulta (sección 8.4)
   Los casos de cada enfermedad se intercalan a lo largo del mes.
   En diciembre las heridas y traumas aumentan hacia el final del
   mes (pólvora de Navidad y Año Nuevo).
   ------------------------------------------------------------ */
-- 5.1 diagnósticos de los datos base por mes y enfermedad
select x.anio, x.mes, x.id_categoria, count(*) as cantidad
into #base_cat
from (select year(c.fecha_c) as anio, month(c.fecha_c) as mes,
             case when cast(d.descripcion_d as varchar(200)) like 'Paciente sano%' then 13
                  else isnull(k.id_categoria, 14) end as id_categoria
      from dbo.diagnosticos d
      join dbo.citas c on c.id_cita = d.id_cita
      left join #categoria k on k.nombre = cast(d.descripcion_d as varchar(200)) and k.id_categoria <= 12
      where cast(c.fecha_c as date) between cast('2024-11-01' as date) and cast('2026-10-31' as date)) x
group by x.anio, x.mes, x.id_categoria;

-- 5.2 casos que faltan por mes y enfermedad
select mr.anio_op, mr.anio, mr.mes, cs.id_categoria, cs.casos - isnull(b.cantidad, 0) as casos
into #cat_mes
from #casos cs
join #mes_rango mr on mr.mes = cs.mes
left join #base_cat b on b.anio = mr.anio and b.mes = mr.mes and b.id_categoria = cs.id_categoria;

-- 5.3 un renglón por caso, con una clave para intercalarlos en el mes
select cm.anio_op, cm.mes, cm.id_categoria,
       row_number() over (partition by cm.anio_op, cm.mes
                          order by case when cm.mes = 12 and cm.id_categoria = 10
                                        then sqrt((2.0 * n.n - 1) / (2.0 * cm.casos))
                                        else (2.0 * n.n - 1) / (2.0 * cm.casos) end,
                                   cm.id_categoria) as r_mes
into #cat_u
from #cat_mes cm
join #n n on n.n <= cm.casos;

-- 5.4 las consultas del mes, en orden de fecha y hora, reciben las enfermedades en ese orden
select s.anio_op, s.anio, s.mes, s.fecha, s.hora, s.r, cu.id_categoria
into #consulta0
from (select s.*, row_number() over (partition by s.anio_op, s.mes order by s.fecha, s.hora, s.r) as r_mes
      from #slot s) s
join #cat_u cu on cu.anio_op = s.anio_op and cu.mes = s.mes and cu.r_mes = s.r_mes;
go

/* ------------------------------------------------------------
   6. diagnóstico concreto dentro de cada enfermedad
   Se elige con los pesos del catálogo usando la secuencia del número
   áureo, que reparte cada diagnóstico de forma pareja en el mes.
   ------------------------------------------------------------ */
select x.id_dx, x.id_categoria, x.es_dic,
       (sum(x.p) over (partition by x.id_categoria, x.es_dic order by x.id_dx rows unbounded preceding) - x.p)
           / sum(x.p) over (partition by x.id_categoria, x.es_dic) as desde,
       sum(x.p) over (partition by x.id_categoria, x.es_dic order by x.id_dx rows unbounded preceding)
           / sum(x.p) over (partition by x.id_categoria, x.es_dic) as hasta
into #dx_rango
from (select id_dx, id_categoria, 0 as es_dic, peso as p from #dx
      union all
      select id_dx, id_categoria, 1, peso_dic from #dx) x;

select c.*, c.g - floor(c.g) as f
into #consulta1
from (select c.*,
             (row_number() over (partition by c.anio_op, c.mes, c.id_categoria order by c.fecha, c.hora, c.r)
              + c.mes * 37 + c.anio_op * 101) * 0.6180339887498949 as g
      from #consulta0 c) c;

select row_number() over (order by c.fecha, c.hora, c.r) as id_tmp,
       c.anio_op, c.anio, c.mes, c.fecha, c.hora, c.id_categoria, dr.id_dx
into #consulta2
from #consulta1 c
join #dx_rango dr on dr.id_categoria = c.id_categoria
                 and dr.es_dic = case when c.mes = 12 then 1 else 0 end
                 and c.f >= dr.desde and c.f < dr.hasta;

/* ------------------------------------------------------------
   7. año de operación 1: se queda el 92% de las consultas
   (número pseudoaleatorio determinista entre 0 y 1 a partir del id)
   ------------------------------------------------------------ */
select c.*
into #consulta
from #consulta2 c
join #anio a on a.anio_op = c.anio_op
where ((cast(c.id_tmp as bigint) * 7919 + 11) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 * 100 < a.pct;
go

/* ------------------------------------------------------------
   8. citas que no se atendieron
   - canceladas: 6% de las consultas que se agendan (no urgencias)
   - programadas: noviembre 2026; la primera semana más llena
   tipo: C = completada, X = cancelada, P = programada
   ------------------------------------------------------------ */
select row_number() over (order by x.tipo, x.fecha, x.hora, x.id_tmp) as id_tmp2, x.*
into #cita0
from (select 'C' as tipo, c.id_tmp, c.fecha, c.hora, c.id_dx, c.id_categoria
      from #consulta c
      union all
      select 'X', c.id_tmp, c.fecha, c.hora, c.id_dx, c.id_categoria
      from #consulta c
      where c.id_categoria not in (6, 10, 11, 12)
        and ((cast(c.id_tmp as bigint) * 7919 + 23) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 * 100 < 6
      union all
      select 'P', p.id_tmp, p.fecha_p, p.hora, p.id_dx, p.id_categoria
      from (select c.*, cast(dateadd(day, 364, c.fecha) as date) as fecha_p,
                   ((cast(c.id_tmp as bigint) * 7919 + 29) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 * 100 as azar
            from #consulta c
            where c.anio_op = 2 and c.mes = 11 and c.id_categoria not in (6, 10, 11, 12)) p
      where p.fecha_p > cast('2026-10-31' as date)
        and p.azar < case when p.fecha_p <= cast('2026-11-07' as date) then 45
                          when p.fecha_p <= cast('2026-11-14' as date) then 25
                          when p.fecha_p <= cast('2026-11-21' as date) then 12
                          else 6 end) x;
go

/* ------------------------------------------------------------
   9. propietarios y mascotas nuevos
   - cachorros y gatitos (parvovirus, moquillo, primeras vacunas):
     una mascota nueva por consulta, nacida 2 a 7 meses antes.
   - adultos: los necesarios para que cada mascota venga unas 3
     veces al año; nacieron antes de septiembre de 2024.
   - las especies que se eliminarán después no reciben mascotas.
   ------------------------------------------------------------ */
-- 9.1 adultos nuevos por especie (visitas / 6, menos las mascotas base)
select x.especie,
       case when ceiling(x.visitas / 6.0) > isnull(b.cantidad, 0)
            then cast(ceiling(x.visitas / 6.0) as int) - isnull(b.cantidad, 0) else 0 end as nuevas
into #adultos_esp
from (select d.especie, count(*) as visitas
      from #cita0 c
      join #dx d on d.id_dx = c.id_dx
      where not (c.tipo = 'C' and isnull(d.edad, '') = 'cria')
      group by d.especie) x
left join (select e.nombre_e as especie, count(*) as cantidad
           from dbo.mascotas m
           join dbo.razas r on r.id_raza = m.id_raza
           join dbo.especies e on e.id_especie = r.id_especie
           group by e.nombre_e) b on b.especie = x.especie;

-- 9.2 mascotas nuevas: primero adultos (especies con más mascotas primero), luego crías
select row_number() over (order by x.grupo, x.orden_esp, x.especie, x.n, x.id_tmp2) as k, x.*
into #mascota0
from (select 1 as grupo, ae.especie, n.n, cast(null as bigint) as id_tmp2, cast(null as date) as fecha_consulta,
             -ae.nuevas as orden_esp
      from #adultos_esp ae
      join #n n on n.n <= ae.nuevas
      union all
      select 2, d.especie, 0, c.id_tmp2, c.fecha, 0
      from #cita0 c
      join #dx d on d.id_dx = c.id_dx
      where c.tipo = 'C' and isnull(d.edad, '') = 'cria') x;

-- números pseudoaleatorios entre 0 y 1 para raza, sexo, edad, peso y nombre
select m.*,
       ((cast(m.k as bigint) * 7919 + 31) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 as u_raza,
       ((cast(m.k as bigint) * 7919 + 37) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 as u_sexo,
       ((cast(m.k as bigint) * 7919 + 41) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 as u_edad,
       ((cast(m.k as bigint) * 7919 + 43) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 as u_peso,
       ((cast(m.k as bigint) * 7919 + 47) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 as u_nombre,
       (((cast(m.k as bigint) * 7919 + 53) % 1000003) * ((cast(m.k as bigint) * 7919 + 53) % 1000003) + m.k)
           % 1000003 * 2654435761 % 4294967296 / 4294967296.0 as u_dueno
into #mascota1
from #mascota0 m;

select (select max(id_mascota) from dbo.mascotas) + m.k as id_mascota,
       m.k, m.grupo, m.id_tmp2, m.especie, rr.id_raza, rr.tamanio,
       rr.peso_min + (rr.peso_max - rr.peso_min) * m.u_peso as peso_adulto,
       case when m.u_sexo < 0.5 then 'Macho' else 'Hembra' end as sexo,
       case when m.grupo = 1
            then cast(dateadd(day, -cast(power(cast(m.u_edad as float), 1.3) * (rr.vida - 1) * 365 as int),
                              cast('2024-09-01' as date)) as date)
            else cast(dateadd(day, -(56 + cast(m.u_edad * 150 as int)), m.fecha_consulta) as date) end as nacimiento,
       m.u_nombre, m.u_dueno
into #mascota2
from #mascota1 m
join #raza_rango rr on rr.especie = m.especie and m.u_raza >= rr.desde and m.u_raza < rr.hasta;

-- peso al día de corte (las crías todavía no tienen el peso adulto) y nombre
select m.*,
       case when m.peso_corte < 0.01 then 0.01 else m.peso_corte end as peso,
       nm.nombre
into #mascota_nueva
from (select m.*,
             cast(round(m.peso_adulto *
                        case when datediff(day, m.nacimiento, cast('2026-10-31' as date)) >= 365 then 1.0
                             else 0.25 + 0.75 * datediff(day, m.nacimiento, cast('2026-10-31' as date)) / 365.0 end, 2)
                  as decimal(6, 2)) as peso_corte
      from #mascota2 m) m
join (select sexo, count(*) as total from #nombre_mascota group by sexo) nt on nt.sexo = m.sexo
join #nombre_mascota nm on nm.sexo = m.sexo and nm.idx = cast(floor(m.u_nombre * nt.total) as int);

-- 9.3 propietarios nuevos: uno por cada 1.5 mascotas nuevas (todos con al menos una mascota)
select n.n as k,
       (select max(id_propietario) from dbo.propietarios) + n.n as id_propietario,
       ((cast(n.n as bigint) * 7919 + 61) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 as u_genero,
       ((cast(n.n as bigint) * 7919 + 67) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 as u_nombre,
       ((cast(n.n as bigint) * 7919 + 71) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 as u_ap1,
       ((cast(n.n as bigint) * 7919 + 73) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 as u_ap2,
       ((cast(n.n as bigint) * 7919 + 79) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 as u_colonia,
       ((cast(n.n as bigint) * 7919 + 83) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 as u_calle,
       ((cast(n.n as bigint) * 7919 + 89) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 as u_dominio,
       -- dígitos del DUI, teléfono y teléfono fijo (únicos por propietario)
       concat('0', right(concat('000000', (n.n * 7919 + 2345671) % 10000000), 7)) as dui8,
       right(concat('000000', (n.n * 9973 + 1000003) % 10000000), 7) as tel7,
       right(concat('000000', (n.n * 7907 + 3000017) % 10000000), 7) as fijo7
into #propietario0
from #n n
where n.n <= (select ceiling(count(*) / 1.5) from #mascota_nueva);

select p.k, p.id_propietario,
       -- DUI: 8 dígitos y dígito verificador (pesos 9 a 2, módulo 10)
       concat(p.dui8, '-',
              (10 - (cast(substring(p.dui8, 1, 1) as int) * 9 + cast(substring(p.dui8, 2, 1) as int) * 8
                   + cast(substring(p.dui8, 3, 1) as int) * 7 + cast(substring(p.dui8, 4, 1) as int) * 6
                   + cast(substring(p.dui8, 5, 1) as int) * 5 + cast(substring(p.dui8, 6, 1) as int) * 4
                   + cast(substring(p.dui8, 7, 1) as int) * 3 + cast(substring(p.dui8, 8, 1) as int) * 2) % 10) % 10) as dui,
       np.nombre,
       concat(a1.apellido, ' ', a2.apellido) as apellido,
       p.genero,
       concat(case when p.k % 3 = 0 then '6' else '7' end, left(p.tel7, 3), '-', right(p.tel7, 4)) as telefono,
       concat('2', left(p.fijo7, 3), '-', right(p.fijo7, 4)) as telefono_fijo,
       -- correo sin tildes: nombre.apellido + número
       concat(replace(replace(replace(replace(replace(replace(replace(lower(np.nombre),
                  'á', 'a'), 'é', 'e'), 'í', 'i'), 'ó', 'o'), 'ú', 'u'), 'ü', 'u'), 'ñ', 'n'), '.',
              replace(replace(replace(replace(replace(replace(replace(lower(a1.apellido),
                  'á', 'a'), 'é', 'e'), 'í', 'i'), 'ó', 'o'), 'ú', 'u'), 'ü', 'u'), 'ñ', 'n'),
              p.k, '@', d.dominio) as correo,
       concat(co.colonia, ', ', ca.calle, ' #', p.k * 37 % 150 + 1, ', ', co.municipio) as direccion
into #propietario_nuevo
from (select p.*, case when p.u_genero < 0.55 then 'F' else 'M' end as genero
      from #propietario0 p) p
join (select genero, count(*) as total from #nombre_persona group by genero) nt on nt.genero = p.genero
join #nombre_persona np on np.genero = p.genero and np.idx = cast(floor(p.u_nombre * nt.total) as int)
join #apellido a1 on a1.idx = cast(floor(p.u_ap1 * (select count(*) from #apellido)) as int)
join #apellido a2 on a2.idx = cast(floor(p.u_ap2 * (select count(*) from #apellido)) as int)
join #colonia co on co.idx = cast(floor(p.u_colonia * (select count(*) from #colonia)) as int)
join #calle ca on ca.idx = cast(floor(p.u_calle * (select count(*) from #calle)) as int)
join #dominio d on p.u_dominio * 100 >= d.desde and p.u_dominio * 100 < d.hasta;
go

set identity_insert dbo.propietarios on;
insert into dbo.propietarios (id_propietario, dui_p, nombre_p, apellido_p, genero_p, telefono_p, telefono_secundario_p,
                              correo_p, direccion_p)
select id_propietario, dui, nombre, apellido, genero, telefono, telefono_fijo, correo, direccion
from #propietario_nuevo
order by id_propietario;
set identity_insert dbo.propietarios off;
go

-- 9.4 dueño de cada mascota: las primeras tienen un dueño propio; las demás se reparten
--     (familias con 2 o 3 mascotas)
set identity_insert dbo.mascotas on;
insert into dbo.mascotas (id_mascota, id_propietario, id_raza, nombre_m, fecha_nacimiento, sexo_m, peso_m, tamanio_m)
select m.id_mascota,
       case when m.k <= p.total then p.primero + m.k - 1
            else p.primero + cast(floor(m.u_dueno * p.total) as int) end,
       m.id_raza, m.nombre, m.nacimiento, m.sexo, m.peso,
       case when m.especie = 'Canino'
            then case when m.peso < 10 then 'Pequeño' when m.peso < 25 then 'Mediano' else 'Grande' end
            else m.tamanio end
from #mascota_nueva m
cross join (select min(id_propietario) as primero, count(*) as total from #propietario_nuevo) p
order by m.id_mascota;
set identity_insert dbo.mascotas off;
go

/* ------------------------------------------------------------
   10. mascota de cada cita
   Grupos por especie, sexo y edad (por ejemplo, piometra solo en
   hembras; enfermedad renal en mascotas de 8 años o más). Dentro
   del grupo la mascota se elige al azar (determinista), así unas
   vienen más veces que otras.
   ------------------------------------------------------------ */
select m.id_mascota, e.nombre_e as especie, m.sexo_m as sexo,
       case when m.fecha_nacimiento <= cast('2017-11-01' as date) then 1 else 0 end as senior
into #paciente
from dbo.mascotas m
join dbo.razas r on r.id_raza = m.id_raza
join dbo.especies e on e.id_especie = r.id_especie
where not exists (select 1 from #mascota_nueva c where c.id_mascota = m.id_mascota and c.grupo = 2);

select p.clave, p.id_mascota,
       row_number() over (partition by p.clave order by p.id_mascota) - 1 as idx,
       count(*) over (partition by p.clave) as tam
into #pool
from (select concat(especie, '|*|*') as clave, id_mascota from #paciente
      union all
      select concat(especie, '|', sexo, '|*'), id_mascota from #paciente
      union all
      select concat(especie, '|*|senior'), id_mascota from #paciente where senior = 1
      union all
      select concat(especie, '|', sexo, '|senior'), id_mascota from #paciente where senior = 1) p;

select c.*, d.edad,
       case when c.tipo = 'C' and isnull(d.edad, '') = 'cria' then null
            else concat(d.especie, '|', isnull(d.sexo, '*'), '|',
                        case when isnull(d.edad, '') = 'senior' then 'senior' else '*' end) end as clave
into #cita1
from #cita0 c
join #dx d on d.id_dx = c.id_dx;

-- x = n.º de cita dentro del grupo; y = paso lineal; u = (y² + x) mezclado, entre 0 y 1
select c.id_tmp2, c.tipo, c.fecha, c.hora, c.id_dx, c.id_categoria, c.edad,
       coalesce(cr.id_mascota, p.id_mascota) as id_mascota
into #cita2
from (select c.*, (c.y * c.y + c.x) % 1000003 * 2654435761 % 4294967296 / 4294967296.0 as u
      from (select c.*, (c.x * 7919 + 97) % 1000003 as y
            from (select c.*,
                         cast(row_number() over (partition by c.clave order by c.id_tmp2)
                              + dense_rank() over (order by c.clave) * 100003 as bigint) as x
                  from #cita1 c) c) c) c
left join #mascota_nueva cr on cr.grupo = 2 and cr.id_tmp2 = c.id_tmp2
left join (select distinct clave, tam from #pool) pt on pt.clave = c.clave
left join #pool p on p.clave = c.clave and p.idx = cast(floor(c.u * pt.tam) as int);
go

/* ------------------------------------------------------------
   11. veterinario y minuto de cada cita
   Dos veterinarios por especialidad que rotan cada semana: uno
   cubre la mañana (7:00-13:59) y el otro la tarde; el domingo
   atiende uno solo. Las citas de cada veterinario se reparten
   dentro de la hora en múltiplos de 5 minutos; si tiene pocas, la
   primera puede empezar a las :00, :15, :30 o :45.
   ------------------------------------------------------------ */
select e.nombre_esp, min(v.id_veterinario) as vet1, count(*) as cantidad
into #vet
from dbo.veterinario v
join dbo.especialidades e on e.id_especialidad = v.id_especialidad
group by e.nombre_esp;

select c.*, d.motivo, d.costo,
       v.vet1 + (case when c.dia = 7 then c.semana % 2
                      else (c.semana + case when c.hora < 14 then 0 else 1 end) % 2 end) % v.cantidad as id_veterinario
into #cita3
from (select c.*,
             datediff(day, cast('1900-01-01' as date), c.fecha) % 7 + 1 as dia,
             datediff(day, cast('2024-01-01' as date), c.fecha) / 7 as semana
      from #cita2 c) c
join #dx d on d.id_dx = c.id_dx
join #vet v on v.nombre_esp = d.especialidad;

select c.*,
       dateadd(minute, cast(c.hora * 60 + (c.rn - 1) * 60 / c.cnt / 5 * 5
                            + case when 60 / c.cnt / 15 >= 2 then c.desfase % (60 / c.cnt / 15) * 15 else 0 end as int),
               cast(c.fecha as datetime)) as fecha_c
into #cita4
from (select c.*,
             row_number() over (partition by c.fecha, c.hora, c.id_veterinario order by c.tipo, c.id_tmp2) as rn,
             count(*) over (partition by c.fecha, c.hora, c.id_veterinario) as cnt,
             ((cast(datediff(day, cast('2024-01-01' as date), c.fecha) as bigint) * 1000 + c.hora * 50
               + c.id_veterinario) * 7919 + 101) % 1000003 % 4 as desfase
      from #cita3 c) c;

select c.*, (select max(id_cita) from dbo.citas) + row_number() over (order by c.fecha_c, c.id_tmp2) as id_cita
into #cita
from #cita4 c;
go

/* ------------------------------------------------------------
   12. citas
   Las canceladas y programadas de cachorros, o de enfermedades,
   quedan como control de seguimiento.
   ------------------------------------------------------------ */
set identity_insert dbo.citas on;
insert into dbo.citas (id_cita, id_mascota, id_veterinario, fecha_c, motivo_c, estado_c, costo_c)
select c.id_cita, c.id_mascota, c.id_veterinario, c.fecha_c,
       case when c.tipo = 'C' then c.motivo
            when isnull(c.edad, '') = 'cria' or (c.tipo = 'P' and c.id_categoria <> 13) then 'Control de seguimiento'
            else c.motivo end,
       case c.tipo when 'C' then 'Completada' when 'X' then 'Cancelada' else 'Programada' end,
       case when c.tipo = 'X' then 0 else c.costo end
from #cita c
order by c.id_cita;
set identity_insert dbo.citas off;

-- si coincide con una cita base del mismo veterinario y minuto, se corre 2 minutos
update c
set fecha_c = dateadd(minute, 2, c.fecha_c)
from dbo.citas c
where c.id_cita >= (select min(id_cita) from #cita)
  and exists (select 1 from dbo.citas b
              where b.id_cita < (select min(id_cita) from #cita)
                and b.id_veterinario = c.id_veterinario
                and b.fecha_c = c.fecha_c);
go

/* ------------------------------------------------------------
   13. diagnósticos, procedimientos y tratamientos
   ------------------------------------------------------------ */
select c.id_cita, c.id_dx, c.fecha,
       (select max(id_diagnostico) from dbo.diagnosticos) + row_number() over (order by c.id_cita) as id_diagnostico
into #dx_cita
from #cita c
where c.tipo = 'C';

set identity_insert dbo.diagnosticos on;
insert into dbo.diagnosticos (id_diagnostico, id_cita, descripcion_d, observaciones_d, fecha_d)
select x.id_diagnostico, x.id_cita, d.descripcion, d.observaciones, x.fecha
from #dx_cita x
join #dx d on d.id_dx = x.id_dx
order by x.id_diagnostico;
set identity_insert dbo.diagnosticos off;

insert into dbo.procedimientos (id_diagnostico, nombre_p, descripcion_p, costo_p)
select x.id_diagnostico, p.nombre, p.descripcion, p.costo
from (select x.id_diagnostico, d.proc1 as codigo, 1 as orden
      from #dx_cita x
      join #dx d on d.id_dx = x.id_dx
      where d.proc1 is not null
      union all
      select x.id_diagnostico, d.proc2, 2
      from #dx_cita x
      join #dx d on d.id_dx = x.id_dx
      where d.proc2 is not null
        and ((cast(x.id_cita as bigint) * 7919 + 59) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 * 100 < d.pct_proc2) x
join #proc_cat p on p.codigo = x.codigo
order by x.id_diagnostico, x.orden;

select x.id_diagnostico, x.id_dx, x.fecha, d.tratamiento, d.indicaciones, d.dias,
       (select max(id_tratamiento) from dbo.tratamiento) + row_number() over (order by x.id_diagnostico) as id_tratamiento
into #trat
from #dx_cita x
join #dx d on d.id_dx = x.id_dx
where d.tratamiento is not null;

set identity_insert dbo.tratamiento on;
insert into dbo.tratamiento (id_tratamiento, id_diagnostico, fecha_inicio, fecha_fin, descripcion_t, indicaciones_t)
select t.id_tratamiento, t.id_diagnostico, t.fecha, dateadd(day, t.dias, t.fecha), t.tratamiento, t.indicaciones
from #trat t
order by t.id_tratamiento;
set identity_insert dbo.tratamiento off;

insert into dbo.detalles_tratamientos (id_detalle_tratamiento, id_tratamiento, id_medicamento, dosis_dt, frecuencia_dt,
                                       duracion_dias_dt)
select dm.orden, t.id_tratamiento, m.id_medicamento, dm.dosis, dm.frecuencia, dm.dias
from #trat t
join #dx_med dm on dm.id_dx = t.id_dx
join dbo.medicamentos m on m.nombre_m = dm.medicamento
order by t.id_tratamiento, dm.orden;
go

/* ------------------------------------------------------------
   14. facturas
   Una por cada cita completada que todavía no tiene. Casi todas
   están pagadas; las pendientes son sobre todo de los últimos días.
   Renglones: consulta, procedimientos y medicamentos del tratamiento.
   ------------------------------------------------------------ */
select c.id_cita, cast(c.fecha_c as date) as fecha,
       (select max(id_factura) from dbo.facturas) + row_number() over (order by c.fecha_c, c.id_cita) as id_factura,
       ((cast(c.id_cita as bigint) * 7919 + 61) % 1000003) * 2654435761 % 4294967296 / 4294967296.0 as u
into #factura_nueva
from dbo.citas c
where c.estado_c = 'Completada'
  and not exists (select 1 from dbo.facturas f where f.id_cita = c.id_cita);

set identity_insert dbo.facturas on;
insert into dbo.facturas (id_factura, id_cita, fecha_emision_f, estado_f, total_f)
select f.id_factura, f.id_cita, f.fecha,
       case when f.fecha > cast('2026-10-21' as date) and f.u < 0.25 then 'Pendiente'
            when f.u < 0.005 then 'Pendiente'
            else 'Pagada' end,
       0
from #factura_nueva f
order by f.id_factura;
set identity_insert dbo.facturas off;

-- unidades que se cobran de cada medicamento (los tratamientos base cobran 1)
select t.id_tratamiento, m.id_medicamento, dm.cantidad
into #cantidad
from #trat t
join #dx_med dm on dm.id_dx = t.id_dx
join dbo.medicamentos m on m.nombre_m = dm.medicamento;

select f.id_factura, f.id_cita
into #sin_detalle
from dbo.facturas f
where not exists (select 1 from dbo.detalles_facturas df where df.id_factura = f.id_factura);

select l.*, row_number() over (partition by l.id_factura order by l.tipo, l.orden) as renglon
into #linea
from (select s.id_factura, 1 as tipo, cast(0 as bigint) as orden, s.id_cita,
             cast(null as bigint) as id_medicamento, cast(null as bigint) as id_tratamiento,
             cast(null as bigint) as id_procedimiento,
             concat('Costo de atención - ', cast(c.motivo_c as varchar(200))) as descripcion,
             1 as cantidad, c.costo_c as precio
      from #sin_detalle s
      join dbo.citas c on c.id_cita = s.id_cita
      union all
      select s.id_factura, 2, p.id_procedimiento, null, null, null, p.id_procedimiento,
             concat('Procedimiento clínico: ', p.nombre_p), 1, p.costo_p
      from #sin_detalle s
      join dbo.diagnosticos d on d.id_cita = s.id_cita
      join dbo.procedimientos p on p.id_diagnostico = d.id_diagnostico
      union all
      select s.id_factura, 3, t.id_tratamiento * 100 + dt.id_detalle_tratamiento, null, m.id_medicamento,
             t.id_tratamiento, null,
             concat('Medicamento: ', m.nombre_m, ' (', m.presentacion_m, ')'), isnull(q.cantidad, 1), m.precio_m
      from #sin_detalle s
      join dbo.diagnosticos d on d.id_cita = s.id_cita
      join dbo.tratamiento t on t.id_diagnostico = d.id_diagnostico
      join dbo.detalles_tratamientos dt on dt.id_tratamiento = t.id_tratamiento
      join dbo.medicamentos m on m.id_medicamento = dt.id_medicamento
      left join #cantidad q on q.id_tratamiento = t.id_tratamiento and q.id_medicamento = m.id_medicamento) l;

insert into dbo.detalles_facturas (id_detalle_factura, id_factura, id_cita, id_medicamento, id_tratamiento,
                                   id_procedimiento, descripcion_df, cantidad_df, precio_unit_df)
select l.renglon, l.id_factura, l.id_cita, l.id_medicamento, l.id_tratamiento, l.id_procedimiento,
       l.descripcion, l.cantidad, l.precio
from #linea l
order by l.id_factura, l.renglon;

-- total de cada factura = suma de sus renglones
update f
set total_f = d.total
from dbo.facturas f
join (select id_factura, sum(subtotal_df) as total from dbo.detalles_facturas group by id_factura) d
  on d.id_factura = f.id_factura;
go

/* ------------------------------------------------------------
   15. verificación contra el documento
   Año de operación 2 (nov-2025 a oct-2026), solo citas completadas.
   ------------------------------------------------------------ */
-- 15.1 consultas por mes: las dos columnas deben ser iguales
select m.mes, m.temporada, m.consultas as documento, isnull(x.atendidas, 0) as base_de_datos
from #mes m
left join (select month(c.fecha_c) as mes, count(*) as atendidas
           from dbo.citas c
           where c.estado_c = 'Completada'
             and cast(c.fecha_c as date) between cast('2025-11-01' as date) and cast('2026-10-31' as date)
           group by month(c.fecha_c)) x on x.mes = m.mes
order by m.mes;

-- 15.2 consultas por temporada, día y hora: diferencias con el documento (debe salir vacío)
select coalesce(f.temporada, x.temporada) as temporada, coalesce(f.dia, x.dia) as dia,
       coalesce(f.hora, x.hora) as hora, isnull(f.cantidad, 0) as documento, isnull(x.atendidas, 0) as base_de_datos
from #franja f
full outer join (select m.temporada, y.dia, y.hora, count(*) as atendidas
                 from (select month(c.fecha_c) as mes,
                              datediff(day, cast('1900-01-01' as date), cast(c.fecha_c as date)) % 7 + 1 as dia,
                              datepart(hour, c.fecha_c) as hora
                       from dbo.citas c
                       where c.estado_c = 'Completada'
                         and cast(c.fecha_c as date) between cast('2025-11-01' as date) and cast('2026-10-31' as date)) y
                 join #mes m on m.mes = y.mes
                 group by m.temporada, y.dia, y.hora) x
  on x.temporada = f.temporada and x.dia = f.dia and x.hora = f.hora
where isnull(f.cantidad, 0) <> isnull(x.atendidas, 0);

-- 15.3 casos por enfermedad y mes: diferencias con la sección 8.4 (debe salir vacío)
select coalesce(cs.mes, x.mes) as mes, coalesce(cs.id_categoria, x.id_categoria) as id_categoria,
       isnull(cs.casos, 0) as documento, isnull(x.casos, 0) as base_de_datos
from #casos cs
full outer join (select y.mes, y.id_categoria, count(*) as casos
                 from (select month(c.fecha_c) as mes,
                              case when cast(d.descripcion_d as varchar(200)) like 'Paciente sano%' then 13
                                   else isnull(k.id_categoria, 14) end as id_categoria
                       from dbo.diagnosticos d
                       join dbo.citas c on c.id_cita = d.id_cita
                       left join #categoria k on k.nombre = cast(d.descripcion_d as varchar(200)) and k.id_categoria <= 12
                       where cast(c.fecha_c as date) between cast('2025-11-01' as date) and cast('2026-10-31' as date)) y
                 group by y.mes, y.id_categoria) x
  on x.mes = cs.mes and x.id_categoria = cs.id_categoria
where isnull(cs.casos, 0) <> isnull(x.casos, 0);

-- 15.4 las 5 enfermedades más comunes de cada mes (compárese con la sección 8.2)
select y.mes, y.puesto, y.enfermedad, y.casos,
       cast(100.0 * y.casos / m.consultas as decimal(4, 1)) as porcentaje
from (select month(c.fecha_c) as mes, cast(d.descripcion_d as varchar(100)) as enfermedad, count(*) as casos,
             row_number() over (partition by month(c.fecha_c)
                                order by count(*) desc, cast(d.descripcion_d as varchar(100))) as puesto
      from dbo.diagnosticos d
      join dbo.citas c on c.id_cita = d.id_cita
      where cast(c.fecha_c as date) between cast('2025-11-01' as date) and cast('2026-10-31' as date)
        and cast(d.descripcion_d as varchar(100)) not like 'Paciente sano%'
      group by month(c.fecha_c), cast(d.descripcion_d as varchar(100))) y
join #mes m on m.mes = y.mes
where y.puesto <= 5
order by y.mes, y.puesto;

-- 15.5 citas fuera del horario de atención (debe ser 0)
select count(*) as citas_fuera_de_horario
from (select datediff(day, cast('1900-01-01' as date), cast(c.fecha_c as date)) % 7 + 1 as dia,
             datepart(hour, c.fecha_c) as hora
      from dbo.citas c) x
where (x.dia <= 6 and x.hora not between 7 and 19)
   or (x.dia = 7 and x.hora not between 7 and 12);

-- 15.6 diagnósticos que no son enfermedad ("Paciente sano: ...")
select cast(100.0 * sum(case when cast(descripcion_d as varchar(200)) like 'Paciente sano%' then 1 else 0 end)
            / count(*) as decimal(4, 1)) as porcentaje_sin_enfermedad
from dbo.diagnosticos;

-- 15.7 los 3 medicamentos más usados en cada enfermedad del documento
select y.enfermedad, y.puesto, y.medicamento, y.veces
from (select cast(d.descripcion_d as varchar(100)) as enfermedad, m.nombre_m as medicamento, count(*) as veces,
             row_number() over (partition by cast(d.descripcion_d as varchar(100))
                                order by count(*) desc, m.nombre_m) as puesto
      from dbo.diagnosticos d
      join #categoria k on k.nombre = cast(d.descripcion_d as varchar(100)) and k.id_categoria <= 12
      join dbo.tratamiento t on t.id_diagnostico = d.id_diagnostico
      join dbo.detalles_tratamientos dt on dt.id_tratamiento = t.id_tratamiento
      join dbo.medicamentos m on m.id_medicamento = dt.id_medicamento
      group by cast(d.descripcion_d as varchar(100)), m.nombre_m) y
where y.puesto <= 3
order by y.enfermedad, y.puesto;
go

-- tablas auxiliares
drop table #n, #anio, #mes, #franja_doc, #franja, #categoria, #casos_doc, #casos, #dx, #dx_med, #proc_cat,
           #raza_perfil, #raza_rango, #nombre_mascota, #nombre_persona, #apellido, #colonia, #calle, #dominio,
           #calendario0, #calendario, #mes_rango, #u1, #u2, #base_franja, #u3, #slot, #base_cat, #cat_mes, #cat_u,
           #consulta0, #dx_rango, #consulta1, #consulta2, #consulta, #cita0, #adultos_esp, #mascota0, #mascota1,
           #mascota2, #mascota_nueva, #propietario0, #propietario_nuevo, #paciente, #pool, #cita1, #cita2, #vet,
           #cita3, #cita4, #cita, #dx_cita, #trat, #factura_nueva, #cantidad, #sin_detalle, #linea;
go
set nocount off
go

/* ============================================================
   VERIFICACIÓN: filas por tabla
   ============================================================ */
select 'citas' as tabla, count(*) as filas from dbo.citas
union all select 'detalles_facturas', count(*) from dbo.detalles_facturas
union all select 'detalles_tratamientos', count(*) from dbo.detalles_tratamientos
union all select 'diagnosticos', count(*) from dbo.diagnosticos
union all select 'especialidades', count(*) from dbo.especialidades
union all select 'especies', count(*) from dbo.especies
union all select 'facturas', count(*) from dbo.facturas
union all select 'mascotas', count(*) from dbo.mascotas
union all select 'medicamentos', count(*) from dbo.medicamentos
union all select 'procedimientos', count(*) from dbo.procedimientos
union all select 'propietarios', count(*) from dbo.propietarios
union all select 'razas', count(*) from dbo.razas
union all select 'tratamiento', count(*) from dbo.tratamiento
union all select 'veterinario', count(*) from dbo.veterinario
order by tabla
go

use [master]
go
alter database [ClinicaVeterinaria] set read_write
go