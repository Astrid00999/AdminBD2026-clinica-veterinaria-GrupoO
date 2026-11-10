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
