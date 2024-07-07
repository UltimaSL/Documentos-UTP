CREATE TABLE sucursales(
    id_sucursales NUMBER PRIMARY KEY NOT NULL,
    sucursales VARCHAR2(50) NOT NULL
);

CREATE TABLE cursos(
    id_cursos NUMBER PRIMARY KEY NOT NULL,
    cursos VARCHAR2(50) NOT NULL
);

CREATE TABLE estudiantes(
    id_estudiante NUMBER PRIMARY KEY NOT NULL,
    nombre VARCHAR2(25) NOT NULL,
    apellido VARCHAR2(25) NOT NULL,
    cedula VARCHAR2(16) NOT NULL,
    election_year Date NOT NULL,
    id_sucursales_es NUMBER NOT NULL,
    CONSTRAINT fk_id_sucursales_es FOREIGN KEY (id_sucursales_es) REFERENCES sucursales(id_sucursales)
);

CREATE TABLE estudiantes_cursos(
    id_estudiantes_cc NUMBER NOT NULL,
    id_cursos_cc NUMBER NOT NULL,
    CONSTRAINT pk_estudiantes_cursos_cc PRIMARY KEY (id_estudiantes_cc, id_cursos_cc),
    CONSTRAINT fk_id_estudiantes_cc FOREIGN KEY (id_estudiantes_cc) REFERENCES estudiantes(id_estudiantes),
    CONSTRAINT fk_id_cursos_cc FOREIGN KEY (id_cursos_cc) REFERENCES cursos(id_cursos)
);

CREATE TABLE profesores(
    id_profesores NUMBER PRIMARY KEY NOT NULL,
    nombre VARCHAR2(25) NOT NULL,
    apellido VARCHAR2(25) NOT NULL,
    cedula VARCHAR2(16) NOT NULL,
    id_sucursales_pf NUMBER NOT NULL,
    id_cursos_pf NUMBER NOT NULL,
    clases_virt BOOLEAN NOT NULL,
    CONSTRAINT fk_id_sucursales_pf FOREIGN KEY (id_sucursales_pf) REFERENCES sucursales(id_sucursales),
    CONSTRAINT fk_id_cursos_pf FOREIGN KEY (id_cursos_pf) REFERENCES cursos(id_cursos)
);
