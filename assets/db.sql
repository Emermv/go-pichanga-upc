drop table if exists persona;
create table persona(
  id int not null primary key auto_increment,
  nombre varchar(500),
  edad int,
  genero char(1),
  direccion varchar(1500),
  descripcion text,
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
foreing key(id_persona) references persona(id)
);

create table cancha(
id int not null primary key auto_increment,
nombre varchar(500),
descripcion text,
direccion varchar(500),
calificacion int,
estado int not null default 0,
id_usuario int not null,
);

create table cancha_imagen(
id int not null primary key auto_increment,
id_cancha int not null,
imagen varchar(500),
descripcion text,
foreing key(id_cancha) references cancha(id)
);

create table partido(
id int not null primary key auto_increment,
id_usuario int not null,
id_cancha int not null,
descripcion text,
fecha_inicio datetime,
fecha_fin datetime,
estado  int not null default 0,
foreing key(id_usuario) references usuario(id),
foreing key(id_cancha) references cancha(id)
);


create table partido_detalle(
id int not null primary key auto_increment,
id_partido int not null,
id_jugador int not null,

);
