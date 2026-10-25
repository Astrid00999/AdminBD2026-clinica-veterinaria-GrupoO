/* ============================================================
	!SCRIPT DML - Sistema de Gestión Veterinaria!
		> Script DML de eliminación de datos representativos (DELETE)
	Repartición de tablas:
	* (1. especies, 2. razas, 3. propietarios, 4. mascotas, 5. especialidades, 6. veterinario, 7. citas) - Adriana
	* (8. diagnosticos, 9. procedimientos, 10. tratamiento, 11. medicamentos, 12. detalles_tratamientos, 13. facturas, 14. detalles_facturas) - Susan
 ============================================================ */
/*	ELimina el contenido de TODA la BD, (mantiene la estructura) (creo)
		(Usado para pruebas y resolución de conflictos, no quitar :c)
	DROP SCHEMA public CASCADE;
	CREATE SCHEMA public;*/

-- ============================================================
-- 1° DELETE: especies (5)
-- ============================================================
DELETE FROM especies
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Arácnido'
);

DELETE FROM especies
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Marsupial'
);

DELETE FROM especies
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Primate'
);

DELETE FROM especies
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Ave de corral'
);

DELETE FROM especies
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Caprino'
);

-- ============================================================
-- 2° DELETE: razas (5)
-- ============================================================
DELETE FROM razas
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Arácnido'
);

DELETE FROM razas
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Marsupial'
);

DELETE FROM razas
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Primate'
);

DELETE FROM razas
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Ave de corral'
);

DELETE FROM razas
WHERE id_especie = (
    SELECT id_especie
    FROM especies
    WHERE nombre_e = 'Caprino'
);

-- ============================================================
-- 3° DELETE: propietarios (5)
-- ============================================================
DELETE FROM propietarios
WHERE id_propietario = (
    SELECT id_propietario
    FROM propietarios
    WHERE dui_p = '17890123-4'
);

DELETE FROM propietarios
WHERE id_propietario = (
    SELECT id_propietario
    FROM propietarios
    WHERE dui_p = '18901234-5'
);

DELETE FROM propietarios
WHERE id_propietario = (
    SELECT id_propietario
    FROM propietarios
    WHERE dui_p = '19012345-6'
);

DELETE FROM propietarios
WHERE id_propietario = (
    SELECT id_propietario
    FROM propietarios
    WHERE dui_p = '10123456-7'
);

DELETE FROM propietarios
WHERE id_propietario = (
    SELECT id_propietario
    FROM propietarios
    WHERE dui_p = '00123456-7'
);

-- ============================================================
-- 4° DELETE: mascotas (5)
-- ============================================================
DELETE FROM mascotas
WHERE id_mascota = (
    SELECT id_mascota
    FROM mascotas
    WHERE nombre_m = 'Colores'
    AND id_raza = (
        SELECT id_raza
        FROM razas
        WHERE nombre_r = 'Guppy'
    )
);

DELETE FROM mascotas
WHERE id_mascota = (
    SELECT id_mascota
    FROM mascotas
    WHERE nombre_m = 'Oink'
    AND id_raza = (
        SELECT id_raza
        FROM razas
        WHERE nombre_r = 'Landrace'
    )
);

DELETE FROM mascotas
WHERE id_mascota = (
    SELECT id_mascota
    FROM mascotas
    WHERE nombre_m = 'Borrego'
    AND id_raza = (
        SELECT id_raza
        FROM razas
        WHERE nombre_r = 'Dorper'
    )
);

DELETE FROM mascotas
WHERE id_mascota = (
    SELECT id_mascota
    FROM mascotas
    WHERE nombre_m = 'Tigresa'
    AND id_raza = (
        SELECT id_raza
        FROM razas
        WHERE nombre_r = 'Salamandra Tigre'
    )
);

DELETE FROM mascotas
WHERE id_mascota = (
    SELECT id_mascota
    FROM mascotas
    WHERE nombre_m = 'Burrito'
    AND id_raza = (
        SELECT id_raza
        FROM razas
        WHERE nombre_r = 'Burro Andaluz'
    )
);

-- ============================================================
-- 5° DELETE: especialidades (5)
-- ============================================================
DELETE FROM especialidades
WHERE id_especialidad = (
    SELECT id_especialidad
    FROM especialidades
    WHERE nombre_esp = 'Etología Veterinaria'
);

DELETE FROM especialidades
WHERE id_especialidad = (
    SELECT id_especialidad
    FROM especialidades
    WHERE nombre_esp = 'Oncología Veterinaria'
);

DELETE FROM especialidades
WHERE id_especialidad = (
    SELECT id_especialidad
    FROM especialidades
    WHERE nombre_esp = 'Reproducción Animal'
);

DELETE FROM especialidades
WHERE id_especialidad = (
    SELECT id_especialidad
    FROM especialidades
    WHERE nombre_esp = 'Neurología Veterinaria'
);

DELETE FROM especialidades
WHERE id_especialidad = (
    SELECT id_especialidad
    FROM especialidades
    WHERE nombre_esp = 'Fisioterapia y Rehabilitación'
);

-- ============================================================
-- 6° DELETE: veterinario (5)
-- ============================================================
DELETE FROM veterinario
WHERE id_veterinario = (
    SELECT id_veterinario
    FROM veterinario
    WHERE correo_v = 'cristian.duran@veterinaria.com'
);

DELETE FROM veterinario
WHERE id_veterinario = (
    SELECT id_veterinario
    FROM veterinario
    WHERE correo_v = 'alejandra.escobar@veterinaria.com'
);

DELETE FROM veterinario
WHERE id_veterinario = (
    SELECT id_veterinario
    FROM veterinario
    WHERE correo_v = 'roberto.leon@veterinaria.com'
);

DELETE FROM veterinario
WHERE id_veterinario = (
    SELECT id_veterinario
    FROM veterinario
    WHERE correo_v = 'melissa.pineda@veterinaria.com'
);

DELETE FROM veterinario
WHERE id_veterinario = (
    SELECT id_veterinario
    FROM veterinario
    WHERE correo_v = 'ivan.pena@veterinaria.com'
);

-- ============================================================
-- 7° DELETE: citas (5)
-- ============================================================
DELETE FROM citas
WHERE id_cita = 41;

DELETE FROM citas
WHERE id_cita = 42;

DELETE FROM citas
WHERE id_cita = 43;

DELETE FROM citas
WHERE id_cita = 44;

DELETE FROM citas
WHERE id_cita = 45;

-- ============================================================
-- ============================================================

-- CITAS: Eliminación de citas canceladas (Limpieza de Agenda)
-- La cita #41 fue cancelada por el propietario y nunca llegó a la clínica.
-- Como su costo_c es 0 y no generó diagnóstico ni factura, se puede borrar de la agenda de forma segura.
DELETE FROM citas
WHERE id_cita = 41 AND estado_c = 'Cancelada';


-- TRATAMIENTO: Eliminación en cascada de Entidades Débiles
-- El veterinario decidió anular por completo el Tratamiento #20 porque la mascota era alérgica.
-- Al borrar el tratamiento, la restricción ON DELETE CASCADE borrará automáticamente los renglones en detalles_tratamientos.
DELETE FROM tratamiento
WHERE id_tratamiento = 20;
