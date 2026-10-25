--================================================================================
--                                    FUNCIONES
--================================================================================


-- 1- Función que calcula la edad del paciente.
---------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_get_edad(f_fecha_nacimiento date)
	RETURNS int
	LANGUAGE plpgsql
AS $$
DECLARE
	c_edad bigint;
BEGIN
	c_edad = EXTRACT(YEAR FROM age(current_date, f_fecha_nacimiento)); 
   
--Retorna la edad calculada, si es NULL retorna 0
RETURN coalesce(c_edad,0);

END;
$$;

-- Uso de la función en una consulta SELECT
SELECT nombre_m, fecha_nacimiento, fn_get_edad(fecha_nacimiento) AS edad FROM mascotas;


--2. Función que retorna historial clínico de una mascota. 
--------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_get_historial_medico(id int)
RETURNS TABLE(
    nombre_ma text,
    edad int,
    peso numeric(6,2),
    fecha_cita timestamp,
    veterinario text,
    diagnostico text,
    tratamiento text,
    medicamentos_recetados text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN query
    SELECT
        m.nombre_m::text,
        fn_get_edad(m.fecha_nacimiento)::int,
        m.peso_m,
        c.fecha_c,
		v.nombre_v::text,
        d.descripcion_d::text,
        t.descripcion_t::text,
--Función de agregada que concatena valores de varias filas en una sola cadena.
		string_agg(
            me.nombre_m || ' (' || dt.dosis_dt || ')',
            ', '
        )::text as medicamentos_recetados
    FROM mascotas m

    JOIN citas c on c.id_mascota = m.id_mascota
	JOIN veterinario v on v.id_veterinario = c.id_veterinario
    JOIN diagnosticos d on d.id_cita = c.id_cita
    JOIN tratamiento t on t.id_diagnostico = d.id_diagnostico
    JOIN detalles_tratamientos dt on dt.id_tratamiento = t.id_tratamiento
    JOIN medicamentos me on me.id_medicamento = dt.id_medicamento
    WHERE m.id_mascota = id
GROUP BY
 	m.nombre_m,
    m.fecha_nacimiento,
    m.peso_m,
    c.fecha_c,
    d.descripcion_d,  
    t.descripcion_t,
	v.nombre_v;
END;
$$;

--Consulta select para mostrar el historial médico. 
SELECT * FROM fn_get_historial_medico(3);

--=====================================================================================
