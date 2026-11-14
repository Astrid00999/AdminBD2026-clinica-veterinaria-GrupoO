--Inserción de datos de Veterinario, medicina ...

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


insert into catalogos.veterinario (id_especialidad, nombre_v, apellido_v, telefono_v, correo_v)
select (select id_especialidad
        from catalogos.especialidades
        where nombre_esp = 'Medicina General Veterinaria'),
       'Yospire', 'Chavez', '7000-0048', 'yospire.vasquez@veterinaria.com'
where not exists (select 1
                  from catalogos.veterinario
                  where correo_v = 'yospire.vasquez@veterinaria.com');

print cast(@@rowcount as varchar(10)) + N' veterinario insertado.';
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



--Insertar nuevos datos.

set nocount on;

declare @nuevos table (
    seq            int identity(1, 1),
    id_factura     int,
    id_medicamento int,
    id_tratamiento int,
    descripcion_df nvarchar(500),
    cantidad_df    int,
    precio_unit_df decimal(10, 2)
);

insert into @nuevos (id_factura, id_medicamento, id_tratamiento, descripcion_df, cantidad_df, precio_unit_df)
values
    (1, 24, 1, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 1, 18.75),
    (1, 8, 1, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 1, 11.20),
    (1, 12, 1, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (1, 60, 1, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (1, 13, 1, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (1, 29, 1, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (1, 25, 1, N'Medicamento: Omeprazol Vet (Caja 14 cápsulas 20mg)', 1, 9.80),
    (1, 16, 1, N'Medicamento: Prednisolona 5mg (Blíster 10 tabletas)', 2, 4.20),
    (2, 24, 2, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 2, 18.75),
    (2, 8, 2, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 2, 11.20),
    (2, 12, 2, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (2, 60, 2, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (2, 13, 2, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (2, 14, 2, N'Medicamento: Clindamicina (Caja 16 cápsulas 150mg)', 1, 13.10),
    (2, 16, 2, N'Medicamento: Prednisolona 5mg (Blíster 10 tabletas)', 2, 4.20),
    (4, 24, 4, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 2, 18.75),
    (4, 8, 4, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 2, 11.20),
    (4, 12, 4, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (4, 60, 4, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (4, 13, 4, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (4, 14, 4, N'Medicamento: Clindamicina (Caja 16 cápsulas 150mg)', 1, 13.10),
    (4, 16, 4, N'Medicamento: Prednisolona 5mg (Blíster 10 tabletas)', 2, 4.20),
    (4, 18, 4, N'Medicamento: Tramadol Gotas (Frasco gotero 20ml)', 1, 13.40),
    (5, 24, 5, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 1, 18.75),
    (5, 8, 5, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 1, 11.20),
    (5, 60, 5, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (5, 13, 5, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (5, 29, 5, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (5, 25, 5, N'Medicamento: Omeprazol Vet (Caja 14 cápsulas 20mg)', 1, 9.80),
    (5, 51, 5, N'Medicamento: Bromhexina Jarabe (Frasco 120ml)', 1, 6.00),
    (6, 24, 6, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 2, 18.75),
    (6, 8, 6, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 2, 11.20),
    (6, 12, 6, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (6, 60, 6, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (6, 29, 6, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (6, 14, 6, N'Medicamento: Clindamicina (Caja 16 cápsulas 150mg)', 1, 13.10),
    (6, 28, 6, N'Medicamento: Rimadyl (Blíster 14 tabletas 50mg)', 1, 26.00),
    (7, 24, 7, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 1, 18.75),
    (7, 8, 7, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 1, 11.20),
    (7, 12, 7, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (7, 60, 7, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (7, 13, 7, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (7, 29, 7, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (7, 18, 7, N'Medicamento: Tramadol Gotas (Frasco gotero 20ml)', 1, 13.40),
    (9, 24, 9, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 1, 18.75),
    (9, 8, 9, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 1, 11.20),
    (9, 12, 9, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (9, 60, 9, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (9, 13, 9, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (9, 14, 9, N'Medicamento: Clindamicina (Caja 16 cápsulas 150mg)', 1, 13.10),
    (9, 23, 9, N'Medicamento: Aureomicina Oftálmica (Tubo 3.5g)', 1, 11.50),
    (11, 24, 12, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 1, 18.75),
    (11, 8, 12, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 1, 11.20),
    (11, 12, 12, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (11, 60, 12, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (11, 7, 12, N'Medicamento: Tobramicina Gotas (Frasco gotero oftálmico 5ml)', 1, 7.50),
    (11, 13, 12, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (11, 1, 12, N'Medicamento: Epiotic Complete (Solución limpiadora ótica 125ml)', 1, 18.50),
    (12, 24, 13, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 2, 18.75),
    (12, 8, 13, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 2, 11.20),
    (12, 12, 13, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (12, 60, 13, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (12, 23, 13, N'Medicamento: Aureomicina Oftálmica (Tubo 3.5g)', 1, 11.50),
    (12, 13, 13, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (12, 43, 13, N'Medicamento: Otomax (Suspensión ótica 15g)', 1, 19.50),
    (13, 24, 14, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 1, 18.75),
    (13, 12, 14, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (13, 60, 14, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (13, 13, 14, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (13, 29, 14, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (13, 28, 14, N'Medicamento: Rimadyl (Blíster 14 tabletas 50mg)', 1, 26.00),
    (13, 25, 14, N'Medicamento: Omeprazol Vet (Caja 14 cápsulas 20mg)', 1, 9.80),
    (13, 16, 14, N'Medicamento: Prednisolona 5mg (Blíster 10 tabletas)', 2, 4.20),
    (14, 24, 16, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 2, 18.75),
    (14, 8, 16, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 2, 11.20),
    (14, 12, 16, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (14, 60, 16, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (14, 13, 16, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (14, 29, 16, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (14, 18, 16, N'Medicamento: Tramadol Gotas (Frasco gotero 20ml)', 1, 13.40),
    (15, 24, 19, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 1, 18.75),
    (15, 8, 19, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 1, 11.20),
    (15, 12, 19, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (15, 60, 19, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (15, 13, 19, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (15, 30, 19, N'Medicamento: Mupirocina Ungüento (Tubo 15g)', 1, 8.90),
    (15, 44, 19, N'Medicamento: Panacur 10% (Suspensión oral 100ml)', 1, 14.00),
    (16, 24, 41, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 2, 18.75),
    (16, 8, 41, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 2, 11.20),
    (16, 12, 41, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (16, 60, 41, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (16, 13, 41, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (16, 29, 41, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (16, 51, 41, N'Medicamento: Bromhexina Jarabe (Frasco 120ml)', 1, 6.00),
    (17, 8, 42, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 1, 11.20),
    (17, 12, 42, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (17, 60, 42, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (17, 13, 42, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (17, 29, 42, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (17, 18, 42, N'Medicamento: Tramadol Gotas (Frasco gotero 20ml)', 1, 13.40),
    (17, 25, 42, N'Medicamento: Omeprazol Vet (Caja 14 cápsulas 20mg)', 1, 9.80),
    (18, 8, 43, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 2, 11.20),
    (18, 12, 43, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (18, 13, 43, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (18, 29, 43, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (18, 25, 43, N'Medicamento: Omeprazol Vet (Caja 14 cápsulas 20mg)', 1, 9.80),
    (18, 14, 43, N'Medicamento: Clindamicina (Caja 16 cápsulas 150mg)', 1, 13.10),
    (18, 16, 43, N'Medicamento: Prednisolona 5mg (Blíster 10 tabletas)', 2, 4.20),
    (19, 24, 45, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 1, 18.75),
    (19, 12, 45, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (19, 60, 45, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (19, 13, 45, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (19, 29, 45, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (19, 25, 45, N'Medicamento: Omeprazol Vet (Caja 14 cápsulas 20mg)', 1, 9.80),
    (19, 6, 45, N'Medicamento: Doxitabs (Blíster 10 tabletas 100mg)', 2, 9.50),
    (21, 24, 31, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 1, 18.75),
    (21, 8, 31, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 1, 11.20),
    (21, 60, 31, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (21, 29, 31, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (21, 14, 31, N'Medicamento: Clindamicina (Caja 16 cápsulas 150mg)', 1, 13.10),
    (21, 16, 31, N'Medicamento: Prednisolona 5mg (Blíster 10 tabletas)', 2, 4.20),
    (21, 31, 31, N'Medicamento: Vanguard Plus 5/L4 (Vial 1 dosis)', 1, 18.00),
    (22, 24, 32, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 2, 18.75),
    (22, 8, 32, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 2, 11.20),
    (22, 12, 32, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (22, 60, 32, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (22, 13, 32, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (22, 31, 32, N'Medicamento: Vanguard Plus 5/L4 (Vial 1 dosis)', 1, 18.00),
    (22, 29, 32, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (24, 8, 34, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 2, 11.20),
    (24, 12, 34, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (24, 13, 34, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (24, 29, 34, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (24, 25, 34, N'Medicamento: Omeprazol Vet (Caja 14 cápsulas 20mg)', 1, 9.80),
    (24, 14, 34, N'Medicamento: Clindamicina (Caja 16 cápsulas 150mg)', 1, 13.10),
    (24, 30, 34, N'Medicamento: Mupirocina Ungüento (Tubo 15g)', 1, 8.90),
    (25, 24, 35, N'Medicamento: Baytril (Blíster 10 tabletas 50mg)', 1, 18.75),
    (25, 8, 35, N'Medicamento: Meloxicam Solución (Frasco gotas 10ml 0.5%)', 1, 11.20),
    (25, 12, 35, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (25, 60, 35, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (25, 13, 35, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (25, 29, 35, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (25, 16, 35, N'Medicamento: Prednisolona 5mg (Blíster 10 tabletas)', 2, 4.20),
    (29, 12, 39, N'Medicamento: Drontal Plus (Tableta individual)', 2, 4.50),
    (29, 60, 39, N'Medicamento: Critical Care (Bolsa 141g)', 1, 16.00),
    (29, 13, 39, N'Medicamento: NexGard Spectra (Tableta masticable 2-3.5kg)', 1, 19.75),
    (29, 29, 39, N'Medicamento: Metronidazol Vet (Caja 20 tabletas 250mg)', 1, 14.50),
    (29, 14, 39, N'Medicamento: Clindamicina (Caja 16 cápsulas 150mg)', 1, 13.10),
    (29, 25, 39, N'Medicamento: Omeprazol Vet (Caja 14 cápsulas 20mg)', 1, 9.80),
    (29, 28, 39, N'Medicamento: Rimadyl (Blíster 14 tabletas 50mg)', 1, 26.00);



