# Fast Paws — Sistema de Administración de Base de Datos

Proyecto de la asignatura **Administración de Bases de Datos**.

**Base de datos:** `ClinicaVeterinaria`  
**Motor:** Microsoft SQL Server  
**Entorno:** Docker  
**Herramientas principales:** SQL Server Management Studio, SQL Server Agent, Database Mail y Power BI Desktop.

---

## Integrantes

| # | Nombre | Carnet |
|---|---|---|
| 1 | Monterrosa Cisneros, Angel Gustavo | 00048825 |
| 2 | Ogawa Urquilla, Yukio Alberto | 00171625 |
| 3 | Astrid Adamaris, Alonzo Gómez | 00091525 |
| 4 | Rubén Eliseo, Martínez Pérez | 00076325 |
| 5 | Guzmán Soriano, Diego Armando | 00188625 |

---

## 1. Descripción del proyecto

**Fast Paws** es una clínica veterinaria dedicada a la atención médica de mascotas, principalmente perros y gatos, aunque también recibe otras especies.

La clínica ofrece consultas generales y de especialidad, diagnósticos, procedimientos clínicos y tratamientos con medicamentos de su propia farmacia. Además, registra y gestiona la facturación correspondiente a los servicios prestados.

Fast Paws cuenta con un equipo de **40 veterinarios distribuidos en 20 especialidades**, atiende de lunes a sábado de **07:00 a 20:00** y los domingos de **07:00 a 13:00**, y registra aproximadamente **25,000 consultas al año**.

Debido al volumen de información que genera, la clínica requiere una solución de base de datos que permita centralizar sus operaciones, proteger la información, mantener la integridad de los datos, mejorar el rendimiento de las consultas y garantizar la recuperación de la información ante posibles fallas.

---

## 2. Contexto y problema

El proyecto toma como referencia el funcionamiento de Fast Paws. La clínica atiende alrededor de 25,000 consultas al año, con una demanda que varía según la época: esta es mayor durante junio, julio, agosto y diciembre, y menor durante febrero y abril.

Ante este volumen de atención, resulta necesario registrar de forma organizada:

- Propietarios y sus datos personales.
- Mascotas y sus características.
- Agenda y atención de citas.
- Historial clínico.
- Diagnósticos y procedimientos.
- Medicamentos y tratamientos.
- Inventario.
- Facturación y cobros.
- Auditoría de modificaciones.
- Información necesaria para análisis y generación de indicadores.

El manejo disperso de esta información puede producir problemas como datos duplicados, historiales clínicos incompletos, inconsistencias en los totales de las facturas, falta de control sobre el inventario de medicamentos y ausencia de trazabilidad sobre los cambios realizados en la información.

También existe la necesidad de proteger datos personales de los propietarios, como DUI, teléfonos y correo electrónico, así como garantizar la disponibilidad de la información ante fallas del sistema.

---

## 3. Objetivo del proyecto

Diseñar, implementar y administrar la base de datos **`ClinicaVeterinaria`** en SQL Server para Fast Paws, con el propósito de centralizar la información de la clínica, garantizar la integridad y seguridad de los datos, automatizar reglas de negocio, facilitar el análisis de la información y establecer mecanismos de respaldo y recuperación ante fallas.

---

## 4. Actores

El sistema contempla los siguientes actores:

### Propietarios y mascotas
Los propietarios son los clientes de la clínica y las mascotas, de distintas especies y razas, son los pacientes atendidos.

### Personal de recepción
Registra propietarios y mascotas y administra la agenda de citas.

### Médicos veterinarios
Atienden las citas y registran diagnósticos, procedimientos y tratamientos, de acuerdo con su especialidad.

### Personal de facturación
Emite y controla las facturas y los cobros asociados a los servicios prestados.

### Administración y análisis
Comprende la administración técnica de la base de datos y al personal encargado de consultar indicadores de productividad, finanzas y atención mediante Power BI.

---

## 5. Procesos principales

### Registro de propietarios y mascotas

Cada propietario se identifica de forma única mediante sus datos correspondientes, mientras que cada mascota queda asociada a un propietario y a una raza.

### Programación y atención de citas

Cada cita relaciona una mascota con un veterinario en una fecha determinada y puede pasar por diferentes estados:

- Programada
- En curso
- Completada
- Cancelada

### Atención clínica

Una cita atendida genera un diagnóstico. A partir de este se registran los procedimientos y tratamientos correspondientes, incluyendo los medicamentos recetados, su dosis, frecuencia y duración.

### Facturación

Cada cita genera una factura cuyo detalle incluye los servicios y medicamentos correspondientes.

El sistema automatiza el cálculo del total de la factura y el control del inventario. Al facturar medicamentos se descuentan las existencias correspondientes y, en caso de anulación de una factura, estas pueden ser restituidas.

### Consulta y análisis de información

El esquema `reportes` contiene vistas destinadas a facilitar la consulta de información operativa, clínica y financiera.

Entre estas se encuentran vistas construidas utilizando **funciones ventana**, utilizadas como fuente para el análisis y visualización en Power BI.

### Seguridad y auditoría

El acceso a la información se controla mediante roles, de manera que cada tipo de usuario tenga únicamente los permisos necesarios para realizar sus funciones.

Los cambios relevantes en información clínica y financiera son registrados mediante mecanismos de auditoría.

### Respaldo y recuperación

La solución contempla respaldos:

- Completos.
- Diferenciales.
- De log.

La frecuencia de los respaldos se adapta a la demanda de la clínica y se utilizan mecanismos de automatización y notificación para detectar posibles fallos.

---

## 6. Arquitectura de la base de datos

La base de datos se implementa en **Microsoft SQL Server**, ejecutándose dentro de un contenedor de **Docker**.

Los datos originales se encontraban en PostgreSQL y fueron migrados mediante **ESF Database Migration Toolkit**.

Posteriormente, las tablas fueron organizadas por áreas funcionales mediante esquemas:

| Esquema | Propósito |
|---|---|
| `catalogos` | Información de catálogo utilizada por el sistema |
| `gestion` | Gestión de propietarios, mascotas y citas |
| `clinica` | Información relacionada con la atención médica |
| `finanzas` | Facturación y operaciones financieras |
| `reportes` | Vistas utilizadas para consulta y análisis |
| `seguridad` | Elementos relacionados con auditoría y seguridad |

En total, la base de datos cuenta con **17 tablas**, además de vistas, funciones, procedimientos almacenados y triggers.

---

## 7. Seguridad

El acceso a la base de datos se administra mediante roles de SQL Server.

Se definieron **nueve roles**, entre los que se encuentran roles orientados a:

- Veterinarios.
- Recepción.
- Facturación.
- Análisis.
- Respaldo.
- Auditoría.

Cada rol posee permisos de acuerdo con las funciones que desempeña dentro de la clínica.

También se implementan mecanismos de auditoría para registrar modificaciones realizadas sobre información relevante, permitiendo mantener trazabilidad de las operaciones.

---

## 8. Programabilidad

La base de datos utiliza diferentes mecanismos de programabilidad de SQL Server para automatizar reglas de negocio y facilitar el acceso a los datos.

### Funciones

Se implementaron funciones para obtener información derivada, entre ellas:

- `fn_get_edad`
- `fn_get_historial_clinico`

### Procedimientos almacenados

Se implementaron procedimientos almacenados para operaciones específicas, incluyendo:

- Agregar medicamentos.
- Cancelar facturas.
- Registrar información veterinaria.

### Triggers

Se implementaron triggers para automatizar procesos y mantener la integridad de la información, entre ellos:

- Auditoría del historial clínico.
- Registro de cambios en finanzas.
- Control de secuencias.
- Totalización de facturas.

---

## 9. Índices y optimización

Se crearon índices para mejorar el rendimiento de las consultas sobre la base de datos.

Además, se realizaron pruebas de rendimiento utilizando consultas con **funciones ventana** y sus respectivos planes de ejecución.

Estas pruebas permiten evaluar el comportamiento de las consultas y determinar el impacto de los índices implementados.

Los scripts relacionados con esta sección se encuentran en:

```text
04_indexes/
├── Consultas_FuncionesVentana_esquemas.sql
└── indexes.sql
```

---

## 10. Backups y recuperación

La solución implementa una estrategia de respaldo basada en tres tipos de backup:

### Backup completo

Se genera un respaldo completo de la base de datos.

### Backup diferencial

Permite respaldar los cambios realizados desde el último backup completo.

### Backup de log

Permite respaldar las transacciones realizadas desde el último respaldo de log.

La estrategia contempla diferentes frecuencias de respaldo dependiendo de la demanda de la clínica. Los periodos de mayor demanda son considerados temporadas de mayor frecuencia de respaldo.

La automatización se realiza mediante **SQL Server Agent**, mientras que las notificaciones de fallos utilizan **Database Mail**.

Los archivos relacionados se encuentran en:

```text
06_backup_restore/
├── backup_strategies.sql
└── restauracion_clinica.sql
```

---

## 11. Business Intelligence

La información de la base de datos puede ser analizada mediante **Power BI Desktop**.

El esquema `reportes` contiene vistas diseñadas para facilitar el análisis de la información. Entre ellas se incluyen vistas construidas con funciones ventana que sirven como fuente para el tablero de Power BI.

Power BI se conecta a la base de datos utilizando una cuenta destinada al análisis y trabaja en modo **DirectQuery**.

El archivo final de Power BI será incorporado posteriormente en:

```text
07_bi/
```

Actualmente, esta carpeta contiene un `.gitkeep` como marcador:

```text
07_bi/
└── .gitkeep
```

Una vez agregado el archivo final, esta sección deberá actualizarse con el nombre y descripción del reporte correspondiente.

---

## 12. Estructura del proyecto

```text
AdminBD2026-clinica-veterinaria-GrupoO/
│
├── .gitignore
├── AdminBD2026-clinica-veterinaria-GrupoO.slnx
├── LICENSE
├── README.md
│
├── 01_design/
│   └── tablas_auditoria.sql
│
├── 02_migration/
│   ├── schemas_and_transfer.sql
│   └── schema_and_data.sql
│
├── 03_security/
│   ├── audits.sql
│   └── roles_users.sql
│
├── 04_indexes/
│   ├── Consultas_FuncionesVentana_esquemas.sql
│   └── indexes.sql
│
├── 05_programmability/
│   ├── views.sql
│   │
│   ├── functions/
│   │   ├── fn_get_edad.sql
│   │   └── fn_get_historial_clinico.sql
│   │
│   ├── stored_procedures/
│   │   ├── sp_agregar_medicamento.sql
│   │   ├── sp_cancelar_factura.sql
│   │   └── sp_registro veterinario.sql
│   │
│   └── triggers/
│       ├── tgg_auditoria_historial_clinico.sql
│       ├── tgg_historial_cambios_finanzas.sql
│       ├── tgg_secuencia_tablas_débiles.sql
│       └── tgg_totalizar_factura.sql
│
├── 06_backup_restore/
│   ├── backup_strategies.sql
│   └── restauracion_clinica.sql
│
├── 07_bi/
│   └── [archivo Power BI]
│
├── 08_config/
│   └── configure_database_mail.sql
│
└── Seed/
    ├── 01_catalogosSeed.sql
    ├── 02_gestionSeed.sql
    ├── 03_clinicaSeed.sql
    ├── 04_finanzasSeed.sql
    └── 05_cargaMasivaDatos.sql
```

---

## 13. Descripción de directorios

| Directorio | Descripción |
|---|---|
| `01_design` | Diseño y tablas relacionadas con auditoría |
| `02_migration` | Migración, creación de esquemas y carga inicial de datos |
| `03_security` | Roles, usuarios, permisos y auditoría |
| `04_indexes` | Índices y consultas utilizadas para evaluar rendimiento |
| `05_programmability` | Vistas, funciones, procedimientos almacenados y triggers |
| `06_backup_restore` | Estrategia de respaldos y procedimientos de restauración |
| `07_bi` | Archivos relacionados con el tablero de Power BI |
| `08_config` | Configuración de Database Mail |
| `Seed` | Scripts de carga de datos para las diferentes áreas de la base |

---

## 14. Tecnologías utilizadas

- **Microsoft SQL Server**
- **SQL Server Management Studio (SSMS)**
- **Docker**
- **SQL Server Agent**
- **Database Mail**
- **Power BI Desktop**
- **ESF Database Migration Toolkit**
- **Git / GitHub**

---

## 15. Flujo general de implementación

El proyecto se organiza siguiendo el siguiente flujo:

```text
Datos originales en PostgreSQL
              │
              ▼
     Migración de datos
              │
              ▼
     Diseño de la estructura
              │
              ▼
      Creación de esquemas
              │
              ▼
       Carga de información
              │
              ▼
   Seguridad y control de acceso
              │
              ▼
 Funciones, procedimientos y triggers
              │
              ▼
     Índices y optimización
              │
              ▼
      Backups y recuperación
              │
              ▼
       Vistas de reportes
              │
              ▼
          Power BI
```

---

## 16. Resultado

El proyecto implementa una solución integral de administración de bases de datos para la clínica veterinaria Fast Paws.

La solución permite centralizar la información operativa, clínica y financiera de la organización, aplicar controles de seguridad y auditoría, automatizar reglas de negocio, optimizar consultas mediante índices, generar información para análisis mediante Power BI y establecer una estrategia de respaldo y recuperación ante fallas.

### Dashboard de Power BI

La información generada por la base de datos se presenta mediante un dashboard desarrollado en Power BI, utilizando las vistas del esquema `reportes` como fuente de información.

A continuación se muestran algunas de las principales visualizaciones desarrolladas:

### Vista general

![Dashboard general](07_bi/screenshots/dashboard_general.png)

### Análisis financiero

![Dashboard financiero](07_bi/screenshots/dashboard_finanzas.png)

### Productividad de veterinarios

![Dashboard de productividad](07_bi/screenshots/dashboard_productividad.png)

### Atención de mascotas

![Dashboard de atención](07_bi/screenshots/dashboard_atencion.png)

Estas visualizaciones permiten analizar diferentes aspectos del funcionamiento de Fast Paws, incluyendo la atención de pacientes, productividad del personal veterinario y comportamiento financiero de la clínica.
