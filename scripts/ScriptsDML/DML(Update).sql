/* ============================================================
	!SCRIPT DML - Sistema de Gestión Veterinaria!
		> Script DML de actualización de datos representativos (UPDATE)
	Repartición de tablas:
	* (1. especies, 2. razas, 3. propietarios, 4. mascotas, 5. especialidades, 6. veterinario, 7. citas) - Adriana
	* (8. diagnosticos, 9. procedimientos, 10. tratamiento, 11. medicamentos, 12. detalles_tratamientos, 13. facturas, 14. detalles_facturas) - Susan
 ============================================================ */

-- ============================================================
-- 1° UPDATE: especies (5)
-- ============================================================
UPDATE especies
SET descripcion_e = 'Mamífero doméstico de la familia Canidae, conocido por su lealtad y diversidad de razas.'
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Can'
) RETURNING *;

UPDATE especies
SET descripcion_e = 'Animal acuático de sangre fría con aletas y branquias, incluye especies de agua dulce y salada.'
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Pez'
) RETURNING *;

UPDATE especies
SET nombre_e = 'Félido'
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Felino'
) RETURNING *;

UPDATE especies
SET nombre_e = 'Lagomorfo'
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Conejo'
) RETURNING *;

UPDATE especies
SET nombre_e = 'Mustélido'
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Hurón'
) RETURNING *;

-- ============================================================
-- 2° UPDATE: razas (3)
-- ============================================================
UPDATE razas
SET nombre_r = 'Hurón Doméstico'
WHERE id_raza = (
    SELECT id_raza
    FROM razas
    WHERE nombre_r = 'Hurón Estándar'
) RETURNING *;

UPDATE razas
SET nombre_r = 'Gecko de Cola Gruesa'
WHERE id_raza = (
    SELECT id_raza
    FROM razas
    WHERE nombre_r = 'Gecko Leopardo'
) RETURNING *;

UPDATE razas
SET nombre_r = 'Canario Roller'
WHERE id_raza = (
    SELECT id_raza
    FROM razas
    WHERE nombre_r = 'Canario'
) RETURNING *;

-- ============================================================
-- 3° UPDATE: propietarios (5)
-- ============================================================
UPDATE propietarios
SET correo_p = 'francisco.nose@hotmail.com'
WHERE id_propietario = (
    SELECT id_propietario
    FROM propietarios
    WHERE dui_p = '03456789-0'
) RETURNING *;

UPDATE propietarios
SET direccion_p = 'Colonia San Benito, San Salvador'
WHERE id_propietario = (
    SELECT id_propietario
    FROM propietarios
    WHERE dui_p = '04567890-1'
) RETURNING *;

UPDATE propietarios
SET telefono_p = '7999-1111'
WHERE id_propietario = (
    SELECT id_propietario
    FROM propietarios
    WHERE dui_p = '11234567-8'
) RETURNING *;

UPDATE propietarios
SET apellido_p = 'Rodríguez Flores'
WHERE id_propietario = (
    SELECT id_propietario
    FROM propietarios
    WHERE dui_p = '05678901-2'
) RETURNING *;

UPDATE propietarios
SET genero_p = 'Otro'
WHERE id_propietario = (
    SELECT id_propietario
    FROM propietarios
    WHERE dui_p = '16789012-3'
) RETURNING *;

-- ============================================================
-- 4° UPDATE: mascotas (5)
-- ============================================================
UPDATE mascotas
SET peso_m = 31.0
WHERE id_mascota = (
    SELECT id_mascota
    FROM mascotas
    WHERE nombre_m = 'Max'
    AND id_raza = (
        SELECT id_raza
        FROM razas
        WHERE nombre_r = 'Labrador Retriever'
    )
) RETURNING *;

UPDATE mascotas
SET edad_m = 5,
    peso_m = 36.0
WHERE id_mascota = (
    SELECT id_mascota
    FROM mascotas
    WHERE nombre_m = 'Rex'
    AND id_raza = (
        SELECT id_raza
        FROM razas
        WHERE nombre_r = 'Pastor Alemán'
    )
) RETURNING *;

UPDATE mascotas
SET tamanio_m = 'Grande'
WHERE id_mascota = (
    SELECT id_mascota
    FROM mascotas
    WHERE nombre_m = 'Gigante'
    AND id_raza = (
        SELECT id_raza
        FROM razas
        WHERE nombre_r = 'Maine Coon'
    )
) RETURNING *;

UPDATE mascotas
SET nombre_m = 'Manchitas'
WHERE id_mascota = (
    SELECT id_mascota
    FROM mascotas
    WHERE nombre_m = 'Manchas'
    AND id_raza = (
        SELECT id_raza
        FROM razas
        WHERE nombre_r = 'Cobaya'
    )
) RETURNING *;

UPDATE mascotas
SET sexo_m = 'Hembra',
    peso_m = 0.42
WHERE id_mascota = (
    SELECT id_mascota
    FROM mascotas
    WHERE nombre_m = 'Paco'
    AND id_raza = (
        SELECT id_raza
        FROM razas
        WHERE nombre_r = 'Loro'
    )
) RETURNING *;

-- ============================================================
-- 5° UPDATE: especialidades (5)
-- ============================================================
UPDATE especialidades
SET descripcion_esp = 'Atención médica preventiva, diagnóstica y terapéutica para mascotas de distintas especies.'
WHERE id_especialidad = (
    SELECT id_especialidad
    FROM especialidades
    WHERE nombre_esp = 'Medicina General Veterinaria'
) RETURNING *;

UPDATE especialidades
SET nombre_esp = 'Cirugía General Veterinaria'
WHERE id_especialidad = (
    SELECT id_especialidad
    FROM especialidades
    WHERE nombre_esp = 'Cirugía Veterinaria'
) RETURNING *;

UPDATE especialidades
SET descripcion_esp = 'Diagnóstico y tratamiento especializado de enfermedades cardíacas en animales.'
WHERE id_especialidad = (
    SELECT id_especialidad
    FROM especialidades
    WHERE nombre_esp = 'Cardiología Veterinaria'
) RETURNING *;

UPDATE especialidades
SET nombre_esp = 'Medicina y Cirugía de Animales Exóticos'
WHERE id_especialidad = (
    SELECT id_especialidad
    FROM especialidades
    WHERE nombre_esp = 'Medicina de Animales Exóticos'
) RETURNING *;

UPDATE especialidades
SET descripcion_esp = 'Estudios diagnósticos mediante radiografías, ecografías y técnicas de imagen avanzadas.'
WHERE id_especialidad = (
    SELECT id_especialidad
    FROM especialidades
    WHERE nombre_esp = 'Diagnóstico por Imágenes'
) RETURNING *;

-- ============================================================
-- 6° UPDATE: veterinario (5)
-- ============================================================
UPDATE veterinario
SET telefono_v = '7555-1001'
WHERE id_veterinario = (
    SELECT id_veterinario
    FROM veterinario
    WHERE correo_v = 'carlos.martinez@veterinaria.com'
) RETURNING *;

UPDATE veterinario
SET correo_v = 'ana.lopez.cirugia@veterinaria.com'
WHERE id_veterinario = (
    SELECT id_veterinario
    FROM veterinario
    WHERE correo_v = 'ana.lopez@veterinaria.com'
) RETURNING *;

UPDATE veterinario
SET apellido_v = 'Ramírez Hernández'
WHERE id_veterinario = (
    SELECT id_veterinario
    FROM veterinario
    WHERE correo_v = 'jorge.ramirez@veterinaria.com'
) RETURNING *;

UPDATE veterinario
SET nombre_v = 'María Sofía'
WHERE id_veterinario = (
    SELECT id_veterinario
    FROM veterinario
    WHERE correo_v = 'sofia.castro@veterinaria.com'
) RETURNING *;

UPDATE veterinario
SET telefono_v = '7555-1005',
    correo_v = 'ricardo.cardiologia@veterinaria.com'
WHERE id_veterinario = (
    SELECT id_veterinario
    FROM veterinario
    WHERE correo_v = 'ricardo.mendoza@veterinaria.com'
) RETURNING *;

-- ============================================================
-- 7° UPDATE: citas (5)
-- ============================================================
UPDATE citas
SET costo_c = 25.00
WHERE id_cita = 1 RETURNING *;

UPDATE citas
SET estado_c = 'Completada',
    costo_c = 55.00
WHERE id_cita = 37 RETURNING *;

UPDATE citas
SET motivo_c = 'Control veterinario integral'
WHERE id_cita = 8 RETURNING *;

UPDATE citas
SET costo_c = 40.00,
    motivo_c = 'Consulta dermatológica especializada'
WHERE id_cita = 19 RETURNING *;

UPDATE citas
SET fecha_c = '2026-08-25 10:00:00'
WHERE id_cita = 49 RETURNING *;


-- ============================================================
-- ============================================================

-- MEDICAMENTOS: Actualización de Inventario (Caja/Farmacia)
-- Se vendieron medicamentos en las facturas, por lo que actualizamos el stock físico en bodega.
UPDATE medicamentos
SET stock_m = stock_m - 5 -- Restamos las 5 suspensiones de Amoxicilina usadas
WHERE id_medicamento = 19;

UPDATE medicamentos
SET stock_m = stock_m - 3 -- Restamos las 3 cápsulas de Clindamicina vendidas
WHERE id_medicamento = 14;

-- FACTURA: Cambio de estado de Facturas (Flujo de Caja)
-- La factura 10 estaba 'Pendiente'. El propietario llega a colecturía y realiza el pago completo.
UPDATE facturas
SET estado_f = 'Pagada'
WHERE id_factura = 1;

UPDATE facturas
SET estado_f = 'Pagada'
WHERE id_factura = 2;

-- TRATAMIENTO: Corrección de errores médicos (Historial Clínico)
-- El veterinario se equivocó en las indicaciones del tratamiento #4. El dueño llamó para corregir.
UPDATE tratamiento
SET indicaciones_t = 'Mantener en ambiente cálido, asear nariz con suero fisiológico cada 8 horas.'
WHERE id_tratamiento = 4;

