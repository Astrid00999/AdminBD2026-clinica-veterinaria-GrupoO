-- TRIGGERS
-- ============================================================

--TRIGGERS PARA EL CONTROL DE ENTIDADES DÉBILES
-- ============================================================
-- 1. Automatización para DETALLES_FACTURAS
CREATE OR REPLACE FUNCTION tg_secuencia_detalle_factura()
    RETURNS TRIGGER AS $$
BEGIN
    -- Busca el último número de renglón de esta factura y le suma 1. Si es el primero, inicia en 1.
    SELECT COALESCE(MAX(id_detalle_factura), 0) + 1
    INTO NEW.id_detalle_factura
    FROM detalles_facturas
    WHERE id_factura = NEW.id_factura;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_antes_insertar_detalle_factura
    BEFORE INSERT ON detalles_facturas
    FOR EACH ROW
EXECUTE FUNCTION tg_secuencia_detalle_factura();

-- ===================================================================================

-- 2. Automatización para DETALLES_TRATAMIENTOS
CREATE OR REPLACE FUNCTION tg_secuencia_detalle_tratamiento()
    RETURNS TRIGGER AS $$
BEGIN
    -- Busca el último número de renglón de este tratamiento y le suma 1. Si es el primero, inicia en 1.
    SELECT COALESCE(MAX(id_detalle_tratamiento), 0) + 1
    INTO NEW.id_detalle_tratamiento
    FROM detalles_tratamientos
    WHERE id_tratamiento = NEW.id_tratamiento;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_antes_insertar_detalle_tratamiento
    BEFORE INSERT ON detalles_tratamientos
    FOR EACH ROW
EXECUTE FUNCTION tg_secuencia_detalle_tratamiento();

-- ===================================================================================
-- TRIGGERS PARA EL CONTROL DEL TOTALIZADOR DE LA FACTURA

-- 3. Actualiza el totalizador de la factura
CREATE OR REPLACE FUNCTION tg_actualizar_total_factura()
    RETURNS TRIGGER AS $$
BEGIN
    -- Sumamos el subtotal generado en el detalle al total acumulado de la factura
    UPDATE facturas
    SET total_f = total_f + NEW.subtotal_df
    WHERE id_factura = NEW.id_factura;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger (Se ejecuta AFTER porque necesitamos que subtotal_df ya esté calculado)
CREATE TRIGGER tr_acumular_total_factura
    AFTER INSERT ON detalles_facturas
    FOR EACH ROW
EXECUTE FUNCTION tg_actualizar_total_factura();

-- ===================================================================================
-- TRIGGERS PARA EL CONTROL DEL INVENTARIO DE MEDICAMENTOS

-- 4. Reduce el stock del medicamento vendido en la factura
CREATE OR REPLACE FUNCTION tg_controlar_stock_medicamento()
    RETURNS TRIGGER AS $$
DECLARE
    v_stock_actual INT;
BEGIN
    -- Solo actuamos si el renglón de la factura corresponde a un medicamento
    IF NEW.id_medicamento IS NOT NULL THEN

        -- 1. Obtener el stock actual del medicamento en la tabla de medicamentos
        SELECT stock_m INTO v_stock_actual
        FROM medicamentos
        WHERE id_medicamento = NEW.id_medicamento;

        -- 2. Validar si hay suficiente existencia
        IF v_stock_actual < NEW.cantidad_df THEN
            RAISE EXCEPTION 'Error de Inventario: No hay suficiente stock para el medicamento solicitado. Disponible: %, Solicitado: %',
                v_stock_actual, NEW.cantidad_df;
        END IF;

        -- 3. Si hay stock, restar las unidades del inventario
        UPDATE medicamentos
        SET stock_m = stock_m - NEW.cantidad_df
        WHERE id_medicamento = NEW.id_medicamento;

    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger (Se ejecuta AFTER para actuar después de validar los CHECKS)
CREATE TRIGGER tr_actualizar_inventario_farmacia
    AFTER INSERT ON detalles_facturas
    FOR EACH ROW
EXECUTE FUNCTION tg_controlar_stock_medicamento();