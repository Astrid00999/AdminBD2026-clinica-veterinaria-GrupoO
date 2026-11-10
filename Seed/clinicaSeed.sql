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
  
       ((select id_especialidad from especialidades where nombre_esp = 'Urgencias Veterinarias'), 'Iván', 'Peña', '7000-0035', 'ivan.pena@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Urgencias Veterinarias'), 'Mónica', 'Vargas', '7000-0036', 'monica.vargas@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Diagnóstico por Imágenes'), 'Roberto', 'León', '7000-0037', 'roberto.leon@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Diagnóstico por Imágenes'), 'Melissa', 'Pineda', '7000-0038', 'melissa.pineda@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Fisioterapia y Rehabilitación'), 'Cristian', 'Durán', '7000-0039', 'cristian.duran@veterinaria.com'),
       ((select id_especialidad from especialidades where nombre_esp = 'Fisioterapia y Rehabilitación'), 'Alejandra', 'Escobar', '7000-0040', 'alejandra.escobar@veterinaria.com');
go


