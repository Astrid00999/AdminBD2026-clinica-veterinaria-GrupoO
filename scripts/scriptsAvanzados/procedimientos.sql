-- ============================================================
-- PROCEDIMIENTOS ALMACENADOS
-- ============================================================

-- 1. Registrar un veterinario con su especialidad
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_registrar_veterinario(
    p_nombre_esp      VARCHAR(150),
    p_descripcion_esp TEXT,
    p_nombre_v        VARCHAR(100),
    p_apellido_v      VARCHAR(100),
    p_telefono_v      VARCHAR(20),
    p_correo_v        VARCHAR(150)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_especialidad BIGINT;
BEGIN
    -- 0. Validar que el nombre de la especialidad no esté vacío
    IF LENGTH(TRIM(p_nombre_esp)) = 0 THEN
        RAISE EXCEPTION 'Error: El nombre de la especialidad no puede estar vacío.';
    END IF;

    -- 1. Validar que el nombre del veterinario no esté vacío
    IF LENGTH(TRIM(p_nombre_v)) = 0 OR LENGTH(TRIM(p_apellido_v)) = 0 THEN
        RAISE EXCEPTION 'Error: El nombre y apellido del veterinario no pueden estar vacíos.';
    END IF;

    -- 2. Validar que el correo no esté ya registrado
    IF EXISTS (SELECT 1 FROM veterinario WHERE correo_v = p_correo_v) THEN
        RAISE EXCEPTION 'Error: El correo % ya está registrado para otro veterinario.', p_correo_v;
    END IF;

    -- 3. Validar que el teléfono no esté ya registrado
    IF EXISTS (SELECT 1 FROM veterinario WHERE telefono_v = p_telefono_v) THEN
        RAISE EXCEPTION 'Error: El teléfono % ya está registrado para otro veterinario.', p_telefono_v;
    END IF;

    -- 4. Verificar si la especialidad ya existe para no duplicarla
    SELECT id_especialidad INTO v_id_especialidad
    FROM especialidades
    WHERE nombre_esp = p_nombre_esp;

    -- 5. Si no existe la especialidad, crearla
    IF NOT FOUND THEN
        INSERT INTO especialidades (nombre_esp, descripcion_esp)
        VALUES (p_nombre_esp, p_descripcion_esp)
        RETURNING id_especialidad INTO v_id_especialidad;
    END IF;

    -- 6. Registrar el veterinario vinculado a la especialidad
    INSERT INTO veterinario (id_especialidad, nombre_v, apellido_v, telefono_v, correo_v)
    VALUES (v_id_especialidad, p_nombre_v, p_apellido_v, p_telefono_v, p_correo_v);

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Error al registrar el veterinario: %', SQLERRM;
    COMMIT; -- Escritura en disco
END;
$$;

-- ============================================================
-- 2. Registrar un medicamento nuevo o actualizar su stock si ya existe
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_agregar_medicamento(
    p_nombre_m       VARCHAR(150),
    p_presentacion_m VARCHAR(100),
    p_laboratorio_m  VARCHAR(150),
    p_precio_m       DECIMAL(10,2),
    p_cantidad       INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_medicamento BIGINT;
BEGIN
    -- 1. Validar que la cantidad a agregar sea positiva
    IF p_cantidad <= 0 THEN
        RAISE EXCEPTION 'Error: La cantidad debe ser mayor a 0. Recibido: %', p_cantidad;
    END IF;

    -- 2. Validar que el precio sea positivo
    IF p_precio_m < 0 THEN
        RAISE EXCEPTION 'Error: El precio no puede ser negativo. Recibido: %', p_precio_m;
    END IF;

    -- 3. Verificar si el medicamento ya existe por nombre y presentación
    SELECT id_medicamento INTO v_id_medicamento
    FROM medicamentos
    WHERE nombre_m = p_nombre_m
      AND presentacion_m = p_presentacion_m;

    IF NOT FOUND THEN
        -- 4a. Si no existe, registrar el medicamento nuevo con el stock inicial
        INSERT INTO medicamentos (nombre_m, presentacion_m, laboratorio_m, precio_m, stock_m)
        VALUES (p_nombre_m, p_presentacion_m, p_laboratorio_m, p_precio_m, p_cantidad);

    ELSE
        -- 4b. Si ya existe, sumar stock y actualizar precio
        UPDATE medicamentos
        SET stock_m = stock_m + p_cantidad,
            precio_m = p_precio_m
        WHERE id_medicamento = v_id_medicamento;

    END IF;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE EXCEPTION 'Error al agregar el medicamento: %', SQLERRM;
    COMMIT; -- Escritura en disco
END;
$$;
-- ============================================================
-- PRUEBAS DE LOS PROCEDIMIENTOS
-- ============================================================

-- ============================================================
-- PRUEBAS: sp_registrar_veterinario
-- ============================================================

-- caso 0: Error por especialidad vacía
CALL sp_registrar_veterinario(
    '   ',
    'Descripción cualquiera',
    'Luis',
    'González',
    '7891-0000',
    'luis@vetclinica.com'
);

-- CASO 1: Registro exitoso con especialidad nueva
CALL sp_registrar_veterinario(
    'Dermatología',
    'Especialidad en enfermedades de la piel en animales',
    'Sofía',
    'Martínez',
    '7090-1234',
    'sofia.martinez@vetclinica.com'
);
-- Verificar que se creó la especialidad y el veterinario
SELECT v.nombre_v, v.apellido_v, v.correo_v, e.nombre_esp
FROM veterinario v
JOIN especialidades e ON v.id_especialidad = e.id_especialidad
WHERE v.correo_v = 'sofia.martinez@vetclinica.com'; 

-- ============================================================
-- CASO 2: Registro exitoso reutilizando especialidad ya existente
-- (Dermatología ya existe del caso anterior, no debe duplicarse)
CALL sp_registrar_veterinario(
    'Dermatología',
    'Esta descripción se ignora porque la especialidad ya existe',
    'Carlos',
    'Reyes',
    '7090-5678',
    'carlos.eyes@vetclinica.com'
);
-- Verificar que sigue habiendo solo UNA fila de Dermatología
SELECT COUNT(*) AS total_especialidades
FROM especialidades
WHERE nombre_esp = 'Dermatología';

-- ============================================================
-- CASO 3: Error por correo duplicado
CALL sp_registrar_veterinario(
    'Cardiología',
    'Especialidad en enfermedades del corazón',
    'Luis',
    'González',
    '7891-0000',
    'sofia.martinez@vetclinica.com' -- correo ya registrado
);

-- CASO 4: Error por teléfono duplicado
CALL sp_registrar_veterinario(
    'Cardiología',
    'Especialidad en enfermedades del corazón',
    'Luis',
    'González',
    '7890-1234', -- teléfono ya registrado
    'luis.gonzalez@vetclinica.com'
);

-- CASO 5: Error por nombre vacío
CALL sp_registrar_veterinario(
    'Cardiología',
    'Especialidad en enfermedades del corazón',
    '   ',
    'González',
    '7892-0000',
    'luis.gonzalez2@vetclinica.com'
);


-- ============================================================
-- PRUEBAS: sp_agregar_medicamento
-- ============================================================

-- CASO 1: Registro exitoso de medicamento nuevo
CALL sp_agregar_medicamento(
    'Amoxicilina',
    'Tabletas 500mg',
    'Laboratorio Bayer',
    2.50,
    100
);
-- Verificar que se creó correctamente
SELECT nombre_m, presentacion_m, laboratorio_m, precio_m, stock_m
FROM medicamentos
WHERE nombre_m = 'Amoxicilina' AND presentacion_m = 'Tabletas 500mg';

-- ============================================================
-- CASO 2: Medicamento ya existe, debe sumar stock
CALL sp_agregar_medicamento(
    'Amoxicilina',
    'Tabletas 500mg',
    'Laboratorio Bayer',
    2.50,
    50               -- llega un nuevo lote de 50 unidades
);
-- Verificar que el stock ahora es 150
SELECT stock_m
FROM medicamentos
WHERE nombre_m = 'Amoxicilina' AND presentacion_m = 'Tabletas 500mg';

-- ============================================================
-- CASO 3: Error por cantidad negativa
CALL sp_agregar_medicamento(
    'Ibuprofeno',
    'Jarabe 200ml',
    'Laboratorio MK',
    3.75,
    -10              -- cantidad inválida
);

-- CASO 4: Error por precio negativo
CALL sp_agregar_medicamento(
    'Ibuprofeno',
    'Jarabe 200ml',
    'Laboratorio MK',
    -5.00,           -- precio inválido
    20
);

-- CASO 5: Error por cantidad cero
CALL sp_agregar_medicamento(
    'Ibuprofeno',
    'Jarabe 200ml',
    'Laboratorio MK',
    3.75,
    0-- cantidad inválida
);