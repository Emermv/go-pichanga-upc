drop table if exists usuario;
drop table if exists persona;
create table persona(
  id int not null primary key auto_increment,
  nombre varchar(500),
  fecha_nacimiento datetime,
  genero char(1),
  direccion varchar(1500),
  biografia text,
  estado int not null default 1
);

drop table if exists usuario;
create table usuario(
id int not null primary key auto_increment,
id_persona int not null,
usuario varchar(100),
contrasenia varchar(200),
perfil varchar(500),
rol int not null default 0,
tipo_usuario int not null default 0,
foreign key(id_persona) references persona(id)
);

drop table if exists cancha_imagen;
drop table if exists cancha_calificacion;
drop table if exists cancha;
create table cancha(
id int not null primary key auto_increment,
nombre varchar(500),
descripcion text,
direccion varchar(500),
latitud int,
longitud int,
altitud int,
tipo int,
estado int not null default 0,
id_usuario int not null
);

create table cancha_imagen(
id int not null primary key auto_increment,
id_cancha int not null,
imagen varchar(500),
descripcion text,
foreign key(id_cancha) references cancha(id)
);

create table cancha_calificacion(
id int not null primary key auto_increment,
id_cancha int not null,
id_usuario int,
calificacion int,
comentario text
);

drop table if exists pichanga_detalle;
drop table if exists pichanga;
create table pichanga(
id int not null primary key auto_increment,
id_usuario int not null,
id_cancha int not null,
descripcion text,
fecha_inicio datetime,
fecha_fin datetime,
estado  int not null default 0,
foreign key(id_usuario) references usuario(id),
foreign key(id_cancha) references cancha(id)
);

create table pichanga_comentario(
id int not null primary key auto_increment,
id_pichanga int not null,
comentario text
);
create table pichanga_detalle(
id int not null primary key auto_increment,
id_pichanga int not null,
id_equipo int not null
);


drop table if exists equipo_detalle;
drop table if exists equipo;
create table equipo(
id int not null primary key auto_increment,
nombre varchar(500),
logo varchar(1000),
victorias int,
puesto int,
derrotas int,
estado int not null default 1,
fecha_creacion datetime default now()
);
create table equipo_detalle(
id int not null primary key auto_increment,
id_usuario,
estado int not null default 1
);




