-- ============================================================
-- SCRIPT DDL - Sistema de Gestión Veterinaria
-- Versión mejorada con validaciones de integridad
-- ============================================================

--CREATE DATABASE db_veterinaria;

-- ============================================================
-- 1. TABLA: especies
-- ============================================================
CREATE TABLE especies (
    id_especie        BIGINT         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_e          VARCHAR(100)   NOT NULL,
    descripcion_e     TEXT           NOT NULL,
    CONSTRAINT uq_especie_nombre UNIQUE (nombre_e)
);

-- ============================================================
-- 2. TABLA: razas
-- ============================================================
CREATE TABLE razas (
    id_raza           BIGINT         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_especie        BIGINT         NOT NULL,
    nombre_r          VARCHAR(100)   NOT NULL,
    CONSTRAINT fk_razas_especie
        FOREIGN KEY (id_especie) REFERENCES especies (id_especie)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT uq_raza_por_especie UNIQUE (id_especie, nombre_r)
);

-- ============================================================
-- 3. TABLA: propietarios
-- ============================================================
CREATE TABLE propietarios (
    id_propietario          BIGINT         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dui_p                   VARCHAR(20)    UNIQUE NOT NULL,
    nombre_p                VARCHAR(100)   NOT NULL,
    apellido_p              VARCHAR(100)   NOT NULL,
    genero_p                VARCHAR(10)    CHECK (genero_p IN ('M', 'F', 'Otro')),
    telefono_p              VARCHAR(20)    NOT NULL UNIQUE,
    telefono_secundario_p   VARCHAR(20)    NOT NULL,
    correo_p                VARCHAR(150)   UNIQUE,
    direccion_p             TEXT,
    CONSTRAINT chk_correo_p CHECK (correo_p IS NULL OR correo_p LIKE '%@%.%'),
    CONSTRAINT chk_dui_p CHECK (LENGTH(TRIM(dui_p)) > 0),
    CONSTRAINT chk_telefonos_distintos CHECK (telefono_p <> telefono_secundario_p)
);

-- ============================================================
-- 4. TABLA: mascotas
-- ============================================================
CREATE TABLE mascotas (
    id_mascota        BIGINT            GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_propietario    BIGINT            NOT NULL,
    id_raza           BIGINT            NOT NULL,
    nombre_m          VARCHAR(100)      NOT NULL,
    fecha_nacimiento  DATE,
    sexo_m            VARCHAR(10)       CHECK (sexo_m IN ('Macho', 'Hembra')),
    peso_m            DECIMAL(6,2),
    tamanio_m         VARCHAR(50),
    CONSTRAINT fk_mascotas_propietario
        FOREIGN KEY (id_propietario) REFERENCES propietarios (id_propietario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_mascotas_raza
        FOREIGN KEY (id_raza) REFERENCES razas (id_raza)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_peso_m CHECK (peso_m IS NULL OR peso_m > 0),
    CONSTRAINT chk_fecha_nacimiento CHECK (fecha_nacimiento IS NULL OR fecha_nacimiento <= CURRENT_DATE),
    CONSTRAINT chk_nombre_mascota CHECK (LENGTH(TRIM(nombre_m)) > 0)
);

-- ============================================================
-- 5. TABLA: especialidades
-- ============================================================
CREATE TABLE especialidades (
    id_especialidad   BIGINT         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_esp        VARCHAR(150)   NOT NULL,
    descripcion_esp   TEXT,
    CONSTRAINT uq_especialidad_nombre UNIQUE (nombre_esp)
);

-- ============================================================
-- 6. TABLA: veterinario
-- ============================================================
CREATE TABLE veterinario (
    id_veterinario    BIGINT         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_especialidad   BIGINT         NOT NULL,
    nombre_v          VARCHAR(100)   NOT NULL,
    apellido_v        VARCHAR(100)   NOT NULL,
    telefono_v        VARCHAR(20)    UNIQUE,
    correo_v          VARCHAR(150)   UNIQUE,
    CONSTRAINT fk_veterinario_especialidad
        FOREIGN KEY (id_especialidad) REFERENCES especialidades (id_especialidad)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_correo_v CHECK (correo_v IS NULL OR correo_v LIKE '%@%.%'),
    CONSTRAINT chk_nombre_v CHECK (LENGTH(TRIM(nombre_v)) > 0),
    CONSTRAINT chk_apellido_v CHECK (LENGTH(TRIM(apellido_v)) > 0)
);

-- ============================================================
-- 7. TABLA: citas
-- ============================================================
CREATE TABLE citas (
    id_cita           BIGINT         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_mascota        BIGINT         NOT NULL,
    id_veterinario    BIGINT         NOT NULL,
    fecha_c           TIMESTAMP      NOT NULL,
    motivo_c          TEXT,
    estado_c          VARCHAR(20)    NOT NULL DEFAULT 'Programada',
    costo_c           DECIMAL(10,2),
    CONSTRAINT fk_citas_mascota
        FOREIGN KEY (id_mascota) REFERENCES mascotas (id_mascota)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_citas_veterinario
        FOREIGN KEY (id_veterinario) REFERENCES veterinario (id_veterinario)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_estado_c
        CHECK (estado_c IN ('Programada', 'En curso', 'Completada', 'Cancelada')),
    CONSTRAINT chk_costo_c CHECK (costo_c IS NULL OR costo_c >= 0),
    CONSTRAINT chk_fecha_cita_programada
        CHECK (estado_c <> 'Programada' OR fecha_c >= NOW() - INTERVAL '1 hour')
);

-- ============================================================
-- 8. TABLA: diagnosticos
-- ============================================================
CREATE TABLE diagnosticos (
    id_diagnostico    BIGINT            GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_cita           BIGINT            NOT NULL UNIQUE,
    descripcion_d     TEXT              NOT NULL,
    observaciones_d   TEXT,
    fecha_d           DATE,
    CONSTRAINT fk_diagnosticos_cita
        FOREIGN KEY (id_cita) REFERENCES citas (id_cita)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_fecha_diagnostico
        CHECK (fecha_d IS NULL OR fecha_d <= CURRENT_DATE),
    CONSTRAINT chk_descripcion_diagnostico
        CHECK (LENGTH(TRIM(descripcion_d)) > 0)
);

-- ============================================================
-- 9. TABLA: procedimientos
-- ============================================================
CREATE TABLE procedimientos (
    id_procedimiento   BIGINT           GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_diagnostico    BIGINT           NOT NULL,
    nombre_p          VARCHAR(100),
    descripcion_p     TEXT,
    costo_p           DECIMAL(10,2),
    CONSTRAINT fk_procedimientos_diagnostico
        FOREIGN KEY (id_diagnostico)
        REFERENCES diagnosticos (id_diagnostico)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_costo_p CHECK (costo_p IS NULL OR costo_p >= 0),
    CONSTRAINT chk_nombre_procedimiento
        CHECK (nombre_p IS NULL OR LENGTH(TRIM(nombre_p)) > 0)
);

-- ============================================================
-- 10. TABLA: tratamiento
-- ============================================================
CREATE TABLE tratamiento (
    id_tratamiento      BIGINT           GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_diagnostico      BIGINT           NOT NULL,
    fecha_inicio        DATE,
    fecha_fin           DATE,
    descripcion_t       TEXT,
    indicaciones_t      TEXT,
    CONSTRAINT fk_tratamiento_diagnostico
        FOREIGN KEY (id_diagnostico)
        REFERENCES diagnosticos (id_diagnostico)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_fechas_tratamiento
        CHECK (fecha_inicio IS NULL OR fecha_fin IS NULL OR fecha_inicio <= fecha_fin),
    CONSTRAINT chk_fecha_inicio_minima
        CHECK (fecha_inicio IS NULL OR fecha_inicio >= '2000-01-01'),
    CONSTRAINT chk_fecha_fin_requiere_inicio
        CHECK (fecha_fin IS NULL OR fecha_inicio IS NOT NULL)
);

-- ============================================================
-- 11. TABLA: medicamentos
-- ============================================================
CREATE TABLE medicamentos (
    id_medicamento    BIGINT            GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_m          VARCHAR(150)      NOT NULL,
    presentacion_m    VARCHAR(100),
    laboratorio_m     VARCHAR(150),
    precio_m          DECIMAL(10,2)     NOT NULL DEFAULT 0,
    stock_m           INT               NOT NULL DEFAULT 0,
    CONSTRAINT chk_precio_m CHECK (precio_m >= 0),
    CONSTRAINT chk_stock_m CHECK (stock_m >= 0),
    CONSTRAINT uq_medicamento_nombre_presentacion
        UNIQUE (nombre_m, presentacion_m),
    CONSTRAINT chk_nombre_medicamento
        CHECK (LENGTH(TRIM(nombre_m)) > 0)
);

-- ============================================================
-- 12. TABLA: detalles_tratamientos (ENTIDAD DÉBIL)
-- ============================================================
CREATE TABLE detalles_tratamientos (
    id_detalle_tratamiento  BIGINT       NOT NULL, -- Controlado por trigger
    id_tratamiento          BIGINT       NOT NULL,
    id_medicamento          BIGINT       NOT NULL,
    dosis_dt                VARCHAR(100),
    frecuencia_dt           VARCHAR(100),
    duracion_dias_dt        INT,
    PRIMARY KEY (id_tratamiento, id_detalle_tratamiento),
    CONSTRAINT fk_dt_tratamiento
        FOREIGN KEY (id_tratamiento)
        REFERENCES tratamiento (id_tratamiento)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_dt_medicamento
        FOREIGN KEY (id_medicamento)
        REFERENCES medicamentos (id_medicamento)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_duracion
        CHECK (duracion_dias_dt IS NULL OR duracion_dias_dt > 0),
    CONSTRAINT uq_medicamento_por_tratamiento
        UNIQUE (id_tratamiento, id_medicamento),
    CONSTRAINT chk_duracion_maxima
        CHECK (duracion_dias_dt IS NULL OR duracion_dias_dt <= 365)
);

-- ============================================================
-- 13. TABLA: facturas
-- ============================================================
CREATE TABLE facturas (
    id_factura        BIGINT         GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_cita           BIGINT         UNIQUE,
    fecha_emision_f   DATE           NOT NULL,
    estado_f          VARCHAR(50)    DEFAULT 'Pendiente',
    total_f           DECIMAL(10,2)  DEFAULT 0,
    CONSTRAINT fk_facturas_cita
        FOREIGN KEY (id_cita)
        REFERENCES citas (id_cita)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT chk_estado_f
        CHECK (estado_f IN ('Pendiente', 'Pagada', 'Anulada', 'Cancelada')),
    CONSTRAINT chk_total_f
        CHECK (total_f >= 0),
    CONSTRAINT chk_fecha_emision_f
        CHECK (fecha_emision_f <= CURRENT_DATE),
    CONSTRAINT chk_factura_pagada_con_total
        CHECK (estado_f <> 'Pagada' OR total_f > 0)
);

-- ============================================================
-- 14. TABLA: detalles_facturas (ENTIDAD DÉBIL)
-- ============================================================
CREATE TABLE detalles_facturas (
    id_detalle_factura  BIGINT           NOT NULL, -- Controlado por trigger
    id_factura          BIGINT           NOT NULL,
    id_cita             BIGINT           NULL,
    id_medicamento      BIGINT           NULL,
    id_tratamiento      BIGINT           NULL,
    id_procedimiento    BIGINT           NULL,
    descripcion_df      TEXT             NOT NULL,
    cantidad_df         BIGINT           NOT NULL DEFAULT 1,
    precio_unit_df      DECIMAL(10,2)    NOT NULL DEFAULT 0,
    subtotal_df         DECIMAL(10,2)    GENERATED ALWAYS AS (cantidad_df * precio_unit_df) STORED,
    PRIMARY KEY (id_factura, id_detalle_factura),
    CONSTRAINT fk_df_factura
        FOREIGN KEY (id_factura)
        REFERENCES facturas (id_factura)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_df_cita
        FOREIGN KEY (id_cita)
        REFERENCES citas (id_cita)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_df_medicamento
        FOREIGN KEY (id_medicamento)
        REFERENCES medicamentos (id_medicamento)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_df_tratamiento
        FOREIGN KEY (id_tratamiento)
        REFERENCES tratamiento (id_tratamiento)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_df_procedimiento
        FOREIGN KEY (id_procedimiento)
        REFERENCES procedimientos (id_procedimiento)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT chk_cantidad_df
        CHECK (cantidad_df > 0),
    CONSTRAINT chk_precio_unit_df
        CHECK (precio_unit_df >= 0),
    CONSTRAINT chk_descripcion_df
        CHECK (LENGTH(TRIM(descripcion_df)) > 0),
    -- Exactamente uno de los campos de referencia debe estar poblado
    CONSTRAINT chk_un_solo_item CHECK (
        (id_cita IS NOT NULL AND id_medicamento IS NULL AND id_tratamiento IS NULL AND id_procedimiento IS NULL) OR
        (id_cita IS NULL AND id_medicamento IS NOT NULL AND id_tratamiento IS NOT NULL AND id_procedimiento IS NULL) OR
        (id_cita IS NULL AND id_medicamento IS NULL AND id_tratamiento IS NULL AND id_procedimiento IS NOT NULL)
    )
);