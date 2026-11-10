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
