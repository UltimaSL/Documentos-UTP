---------------TABLAS PRINCIPALES------------------------------------

CREATE TABLE Admins (
    id_admin NUMBER(8) NOT NULL PRIMARY KEY,
    nombre_adm VARCHAR2(25) NOT NULL,
    apellido_adm VARCHAR2(25) NOT NULL,
    fecha_de_nacimiento_adm DATE NOT NULL,
    edad_adm NUMBER(2) NOT NULL,
    correo_adm VARCHAR2(50) NOT NULL,
    contrasena_adm VARCHAR2(50) NOT NULL,
    celular_adm NUMBER(8) NOT NULL
);

CREATE TABLE Usuarios (
    id_usuario_usr NUMBER(8) NOT NULL PRIMARY KEY,
    nombre_usr VARCHAR2(25) NOT NULL,
    apellido_usr VARCHAR2(25) NOT NULL,
    fecha_nacimiento_usr DATE NOT NULL,
    edad_usr NUMBER(2) NOT NULL,
    username VARCHAR2(25) NOT NULL,
    correo_usr VARCHAR2(50) NOT NULL,
    contrasena_usr VARCHAR2(50) NOT NULL
);

CREATE TABLE Especialidades (
    id_esp NUMBER(8) NOT NULL PRIMARY KEY,
    especialidad VARCHAR2(50) NOT NULL
);

CREATE TABLE Profesores (
    id_profesor NUMBER(8) NOT NULL PRIMARY KEY,
    nombre_pr VARCHAR2(25) NOT NULL,
    apellido_pr VARCHAR2(25) NOT NULL,
    fecha_de_nacimiento_pr DATE NOT NULL,
    edad_pr NUMBER(2) NOT NULL,
    correo_pr VARCHAR2(50) NOT NULL,
    contrasena_pr VARCHAR2(50) NOT NULL,
    id_esp_fk_pr NUMBER(8) NOT NULL,
    id_admin_fk_pr NUMBER(8) NOT NULL,
    celular_pr NUMBER(8) NOT NULL,
    CONSTRAINT fk_especialidad FOREIGN KEY (id_esp_fk_pr) REFERENCES Especialidades(id_esp),
    CONSTRAINT fk_administrador FOREIGN KEY (id_admin_fk_pr) REFERENCES Admins(id_admin)
);

CREATE TABLE Cursos (
    id_curso NUMBER(8) NOT NULL PRIMARY KEY,
    nombre_cur VARCHAR2(50) NOT NULL,
    descripcion_cur VARCHAR2(50) NOT NULL,
    duracion_cur NUMBER(2) NOT NULL,
    dificultad_cur NUMBER(2) NOT NULL,
    id_admin_fk_cur NUMBER(8) NOT NULL,
    CONSTRAINT fk_administrador_cr FOREIGN KEY (id_admin_fk_cur) REFERENCES Admins(id_admin)
);

CREATE TABLE Lecciones (
    id_leccion NUMBER(8) NOT NULL PRIMARY KEY,
    nombre_lec VARCHAR2(50) NOT NULL,
    contenido_lec VARCHAR2(50) NOT NULL,
    dificultad_lec NUMBER(2) NOT NULL,
    id_curso_fk_lec NUMBER(8) NOT NULL,
    CONSTRAINT fk_curso_lc FOREIGN KEY (id_curso_fk_lec) REFERENCES Cursos(id_curso)
);

CREATE TABLE Problemas (
    id_problema NUMBER(8) NOT NULL PRIMARY KEY,
    opcion1_pb VARCHAR2(50) NOT NULL,
    opcion2_pb VARCHAR2(50) NOT NULL,
    opcion3_pb VARCHAR2(50) NOT NULL,
    solucion_pb VARCHAR2(50) NOT NULL,
    id_leccion_fk_pb NUMBER(8) NOT NULL,
    CONSTRAINT fk_leccion_pb FOREIGN KEY (id_leccion_fk_pb) REFERENCES Lecciones(id_leccion)
);

---------------TABLAS DE RELACION------------------------------------

CREATE TABLE Cursos_profesores (
    id_curso_fk_lp NUMBER(8) NOT NULL,
    id_profesor_fk_lp NUMBER(8) NOT NULL,
    CONSTRAINT pk_Cursos_profesores_lp PRIMARY KEY (id_curso_fk_lp, id_profesor_fk_lp),
    CONSTRAINT fk_Cursos_lp FOREIGN KEY (id_curso_fk_lp) REFERENCES Cursos(id_curso),
    CONSTRAINT fk_profesores_lp FOREIGN KEY (id_profesor_fk_lp) REFERENCES Profesores(id_profesor)
);

CREATE TABLE Usuarios_curso (
    id_usuario_fk_uc NUMBER(8) NOT NULL,
    id_curso_fk_uc NUMBER(8) NOT NULL,
    posicion_usuario_fk_uc NUMBER(8),
    CONSTRAINT pk_usuarios_curso_uc PRIMARY KEY (id_usuario_fk_uc, id_curso_fk_uc),
    CONSTRAINT fk_id_usuarios_curso_uc FOREIGN KEY (id_usuario_fk_uc) REFERENCES Usuarios(id_usuario_usr),
    CONSTRAINT fk_id_curso_uc FOREIGN KEY (id_curso_fk_uc) REFERENCES Cursos(id_curso)
);

CREATE TABLE Usuario_problema (
    id_usuario_fk_up NUMBER(8) NOT NULL,
    id_problema_fk_up NUMBER(8) NOT NULL,
    fecha_realizacion_up DATE,
    puntaje_up NUMBER(3),
    CONSTRAINT pk_usuario_problema_up PRIMARY KEY (id_usuario_fk_up, id_problema_fk_up),
    CONSTRAINT fk_id_usuario_up FOREIGN KEY (id_usuario_fk_up) REFERENCES Usuarios(id_usuario_usr),
    CONSTRAINT fk_id_problema_up FOREIGN KEY (id_problema_fk_up) REFERENCES Problemas(id_problema)
);

---------------FIN CREACION DE LA BASE DE DATOS-------------------

CREATE SEQUENCE seq_admins START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_profesores START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_usuarios START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE sep_lecciones START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE sep_cursos START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE sep_problemas START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE sep_esp START WITH 1 INCREMENT BY 1;


--------------------FUNCION CALCULAR EDAD------------------------------
CREATE OR REPLACE FUNCTION calcular_edad(p_fecha_nacimiento DATE) RETURN NUMBER AS
    v_edad NUMBER;
BEGIN
    --calculamos la edad tomando la cantidad de meses que han pasado hasta el momento y dividiendola entre 12
    SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, p_fecha_nacimiento) / 12) INTO v_edad FROM dual; 
    RETURN v_edad;
END;
/

--------------------FUNCION CALCULAR EDAD FIN------------------------------

--------------------FUNCION BUSCAR ADMIN------------------------------

CREATE OR REPLACE FUNCTION buscar_admin(p_id_admin NUMBER) RETURN NUMBER IS
    p_existir_admin NUMBER := 0; -- Inicializar la variable de existencia

    CURSOR buscar_admin IS
        SELECT id_admin 
        FROM Admins
        WHERE id_admin = p_id_admin; -- Filtrar por el cliente dado

BEGIN
    FOR buscar_adm IN buscar_admin LOOP
        IF buscar_adm.id_admin = p_id_admin THEN
            p_existir_admin := 1; -- Establecer existencia a 1 si encontramos el préstamo
            EXIT; -- Salir del bucle una vez que se haya encontrado el préstamo
        END IF;
    END LOOP;

    RETURN p_existir_admin;
END;
/

--------------------FUNCION BUSCAR ADMIN FIN------------------------------

--------------------FUNCION BUSCAR USUARIO------------------------------

CREATE OR REPLACE FUNCTION buscar_usuario(p_id_usuario NUMBER) RETURN NUMBER IS
    p_existir_usuario NUMBER := 0; -- Inicializar la variable de existencia

    CURSOR buscar_usuario IS
        SELECT id_usuario_usr 
        FROM Usuarios
        WHERE id_usuario_usr  = p_id_usuario; -- Filtrar por el cliente dado

BEGIN
    FOR buscar_usr IN buscar_usuario LOOP
        IF buscar_usr.id_usuario_usr = p_id_usuario THEN
            p_existir_usuario := 1; -- Establecer existencia a 1 si encontramos el préstamo
            EXIT; -- Salir del bucle una vez que se haya encontrado el préstamo
        END IF;
    END LOOP;

    RETURN p_existir_usuario;
END;
/

--------------------FUNCION BUSCAR USUARIO FIN------------------------------


--------------------FUNCION BUSCAR CURSO------------------------------

CREATE OR REPLACE FUNCTION buscar_curso(p_id_cursos NUMBER) RETURN NUMBER IS
    p_existir_curso NUMBER := 0; -- Inicializar la variable de existencia

    CURSOR buscar_curso IS
        SELECT id_curso 
        FROM Cursos
        WHERE id_curso = p_id_cursos; -- Filtrar por el cliente dado

BEGIN
    FOR buscar_cr IN buscar_curso LOOP
        IF buscar_cr.id_curso = p_id_cursos THEN
            p_existir_curso := 1; -- Establecer existencia a 1 si encontramos el préstamo
            EXIT; -- Salir del bucle una vez que se haya encontrado el préstamo
        END IF;
    END LOOP;

    RETURN p_existir_curso;
END;
/

--------------------FUNCION BUSCAR CURSO------------------------------


--------------------FUNCION BUSCAR PROFESOR------------------------------

CREATE OR REPLACE FUNCTION buscar_profesor(p_id_profesor NUMBER) RETURN NUMBER IS
    p_existir_profesor NUMBER := 0; -- Inicializar la variable de existencia

    CURSOR buscar_profesor IS
        SELECT id_profesor 
        FROM Profesores
        WHERE id_profesor  = p_id_profesor; -- Filtrar por el cliente dado

BEGIN
    FOR buscar_pr IN buscar_profesor LOOP
        IF buscar_pr.id_profesor = p_id_profesor THEN
            p_existir_profesor := 1; -- Establecer existencia a 1 si encontramos el préstamo
            EXIT; -- Salir del bucle una vez que se haya encontrado el préstamo
        END IF;
    END LOOP;

    RETURN p_existir_profesor;
END;
/

--------------------FUNCION BUSCAR PROFESOR FIN------------------------------



------------------ INSERTAR PROFESORES-------------------
CREATE OR REPLACE PROCEDURE insertar_profesores(
    p_nombre_pr VARCHAR2,
    p_apellido_pr VARCHAR2,
    p_fecha_nacimiento DATE,
    p_correo_pr VARCHAR2,
    p_contrasena_pr VARCHAR2,
    p_id_esp_pr NUMBER,
    p_id_admin NUMBER,
    p_celular_pr NUMBER,
    p_id_curso NUMBER
) AS
    v_edad NUMBER;
    v_id_prof NUMBER;
    v_admin_exists NUMBER;
    v_curso_exists NUMBER;
BEGIN
    v_admin_exists := buscar_admin(p_id_admin);
    v_curso_exists := buscar_curso(p_id_curso);

    -- Verificar si el administrador existe
    IF v_admin_exists = 1 THEN
        IF v_curso_exists = 1 THEN
            -- Calcular la edad del profesor
            v_edad := calcular_edad(p_fecha_nacimiento);
            v_id_prof := seq_profesores.NEXTVAL; -- Asignar un nuevo valor para el siguiente profesor

            -- Insertar el nuevo profesor
            INSERT INTO Profesores(id_profesor, nombre_pr, apellido_pr, fecha_de_nacimiento_pr, edad_pr, correo_pr, contrasena_pr, id_esp_fk_pr, id_admin_fk_pr, celular_pr) 
            VALUES (v_id_prof, p_nombre_pr, p_apellido_pr, p_fecha_nacimiento, v_edad, p_correo_pr, p_contrasena_pr, p_id_esp_pr, p_id_admin, p_celular_pr);

            -- Confirmar la transacción
            INSERT INTO Cursos_profesores(id_curso_fk_lp, id_profesor_fk_lp)
            VALUES (p_id_curso, v_id_prof);
            
            COMMIT;
        ELSE
            DBMS_OUTPUT.PUT_LINE('No existe el curso');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe el administrador asignado');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- Deshacer la transacción en caso de error
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END insertar_profesores;
/

------------------ INSERTAR PROFESORES FIN -------------------

------------------ INSERTAR ADMINISTRADORES -------------------
CREATE OR REPLACE PROCEDURE insertar_admins(
    p_nombre_adm VARCHAR2,
    p_apellido_adm VARCHAR2,
    p_fecha_nacimiento DATE,
    p_correo_adm VARCHAR2,
    p_contrasena_adm VARCHAR2,
    p_celular_adm NUMBER
) AS
    v_edad NUMBER;
BEGIN
    v_edad := calcular_edad(p_fecha_nacimiento);

    INSERT INTO Admins(id_admin, nombre_adm, apellido_adm, fecha_de_nacimiento_adm, edad_adm, correo_adm, contrasena_adm, celular_adm) 
    VALUES (seq_admins.NEXTVAL, p_nombre_adm, p_apellido_adm, p_fecha_nacimiento, v_edad, p_correo_adm, p_contrasena_adm, p_celular_adm);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END insertar_admins;
/

------------------ INSERTAR ADMINISTRADORES FIN -------------------        

------------------ INSERTAR USUARIOS -------------------

CREATE OR REPLACE PROCEDURE insertar_usuarios(
    p_nombre_us VARCHAR2,
    p_apellido_us VARCHAR2,
    p_fecha_nacimiento DATE,
    p_username_us VARCHAR2,
    p_correo_us VARCHAR2,
    p_contrasena_us VARCHAR2
) AS
    v_usuario NUMBER;
    v_edad NUMBER;
BEGIN

    v_edad := calcular_edad(p_fecha_nacimiento);
    v_usuario := seq_usuarios.NEXTVAL;

    INSERT INTO Usuarios(id_usuario_usr, nombre_usr, apellido_usr, fecha_nacimiento_usr, edad_usr, username, correo_usr, contrasena_usr) 
    VALUES(v_usuario, p_nombre_us, p_apellido_us, p_fecha_nacimiento, v_edad, p_username_us, p_correo_us, p_contrasena_us);
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
END insertar_usuarios;
/


------------------ INSERTAR USUARIOS FIN-------------------

------------------ INSERTAR CURSO -------------------
        
CREATE OR REPLACE PROCEDURE insertar_curso(
    p_nombre_cr VARCHAR2,
    p_descripcion_cr VARCHAR2,
    p_duracion_cr NUMBER,
    p_dificultad_cr NUMBER,
    p_id_admin NUMBER
)AS
    v_id_curso NUMBER;
BEGIN
    v_id_curso := sep_cursos.NEXTVAL;
    INSERT INTO Cursos(id_curso, nombre_cur, descripcion_cur, duracion_cur, dificultad_cur, id_admin_fk_cur) 
    VALUES(v_id_curso, p_nombre_cr, p_descripcion_cr, p_duracion_cr, p_dificultad_cr, p_id_admin);

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
    
END insertar_curso;
/

------------------ INSERTAR CURSO FIN -------------------

------------------ INSERTAR ESPECIALIDADES -------------------

CREATE OR REPLACE PROCEDURE insertar_especialidad(
    p_especialidad VARCHAR2
)AS

BEGIN
    INSERT INTO Especialidades(id_esp, especialidad)
    VALUES(sep_esp.NEXTVAL, p_especialidad);
END insertar_especialidad;
/

------------------ INSERTAR ESPECIALIDADES FIN -------------------


------------------ INSERTAR USUARIOS A LOS CURSOS-------------------

CREATE OR REPLACE PROCEDURE insertar_usuarios_curso(
    p_id_usuario NUMBER,
    p_id_curso NUMBER
)AS
    v_curso_exists NUMBER;
    v_usuario_exists NUMBER;

BEGIN
    v_curso_exists := buscar_curso(p_id_curso);
    v_usuario_exists := buscar_usuario(p_id_usuario);

    IF v_usuario_exists =1 THEN
        IF v_curso_exists = 1 THEN
            INSERT INTO Usuarios_curso(id_usuario_fk_uc, id_curso_fk_uc) 
            VALUES(p_id_usuario, p_id_curso);
            COMMIT;
        ELSE
            DBMS_OUTPUT.PUT_LINE('No existe el curso');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe el usuario');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
    
END insertar_usuarios_curso;
/

------------------ INSERTAR USUARIOS A LOS CURSOS FIN -------------------



------------------INSERTAR LECCIONES -------------------------

CREATE OR REPLACE PROCEDURE insertar_lecciones(
    p_nombre_lec VARCHAR2,
    p_contenido_lec VARCHAR2,
    p_dificultad_lec NUMBER,
    p_id_curso NUMBER
)AS
    v_curso_exists NUMBER;

BEGIN
    v_curso_exists := buscar_curso(p_id_curso);

    IF v_curso_exists =1 THEN
        INSERT INTO Lecciones(id_leccion, nombre_lec, contenido_lec, dificultad_lec, id_curso_fk_lec)
        VALUES(sep_lecciones.NEXTVAL, p_nombre_lec, p_contenido_lec, p_dificultad_lec, p_id_curso);
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('No existe el Curso');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error: ' || SQLERRM);
    
END insertar_lecciones;
/

------------------INSERTAR LECCIONES FIN -------------------------


------------------ INSERTAR TABLA DE AUDITORIA -------------------
--Auditamos la tabla de cursos
CREATE TABLE Auditoria_lecciones(
    id_leccion_aud NUMBER(8),
    id_curso_aud NUMBER(8) NOT NULL,
    nombre_leccion_aud VARCHAR2(50),
    contenido_leccion_aud VARCHAR2(50),
    dificultad_leccion_aud NUMBER,
    id_profesor_aud NUMBER(8),
    id_usuario_aud NUMBER(8),
    id_admin_aud NUMBER(8) NOT NULL,
    fecha_de_cambio_aud TIMESTAMP NOT NULL,
    operacion VARCHAR2(10) NOT NULL,
    CONSTRAINT pk_Cursos_pr_lec_aud PRIMARY KEY (id_curso_aud, id_profesor_aud, id_leccion_aud)
);

------------------ INSERTAR TABLA DE AUDITORIA FIN-------------------


------------------ INSERTAR TRIGGER PARA LA TABLA DE AUDITORIA DE LECCIONES -------------------

CREATE OR REPLACE TRIGGER trg_auditar_lecciones
BEFORE INSERT OR UPDATE OR DELETE ON Lecciones
FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_id_profesor NUMBER(8);
    v_id_usuario NUMBER(8);
    v_id_admin NUMBER(8);
BEGIN
    -- Determinar el tipo de operación
    IF INSERTING THEN
        v_operacion := 'INSERT';
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
    ELSIF DELETING THEN
        v_operacion := 'DELETE';
    END IF;

    -- Proceso para INSERT
    IF INSERTING THEN
        SELECT id_profesor_fk_lp INTO v_id_profesor
        FROM Cursos_profesores
        WHERE id_curso_fk_lp = :NEW.id_curso_fk_lec;

        SELECT id_usuario_fk_uc INTO v_id_usuario
        FROM Usuarios_curso
        WHERE id_curso_fk_uc = :NEW.id_curso_fk_lec;

        SELECT id_admin_fk_pr INTO v_id_admin
        FROM Profesores
        WHERE id_profesor = v_id_profesor;

    -- Proceso para UPDATE
    ELSIF UPDATING THEN
        SELECT id_profesor_fk_lp INTO v_id_profesor
        FROM Cursos_profesores
        WHERE id_curso_fk_lp = :NEW.id_curso_fk_lec;

        SELECT id_usuario_fk_uc INTO v_id_usuario
        FROM Usuarios_curso
        WHERE id_curso_fk_uc = :NEW.id_curso_fk_lec;

        SELECT id_admin_fk_pr
        INTO v_id_admin
        FROM Profesores
        WHERE id_profesor = v_id_profesor;
    
    -- Proceso para DELETE
    ELSIF DELETING THEN
        SELECT id_profesor_fk_lp INTO v_id_profesor
        FROM Cursos_profesores
        WHERE id_curso_fk_lp = :OLD.id_curso_fk_lec;

        SELECT id_usuario_fk_uc INTO v_id_usuario
        FROM Usuarios_curso
        WHERE id_curso_fk_uc = :OLD.id_curso_fk_lec;

        SELECT id_admin_fk_pr INTO v_id_admin
        FROM Profesores
        WHERE id_profesor = v_id_profesor;

    END IF;

    -- Insertar registro en Auditoria_lecciones
    INSERT INTO Auditoria_lecciones (id_leccion_aud, id_curso_aud, nombre_leccion_aud, contenido_leccion_aud, dificultad_leccion_aud, id_profesor_aud, id_usuario_aud, id_admin_aud, fecha_de_cambio_aud, operacion) 
    VALUES (:NEW.id_leccion, :NEW.id_curso_fk_lec, :NEW.nombre_lec, :NEW.contenido_lec, :NEW.dificultad_lec, v_id_profesor, v_id_usuario, v_id_admin, SYSTIMESTAMP, v_operacion);

END;
/



------------------ INSERTAR TRIGGER PARA LA TABLA DE AUDITORIA DE LECCIONES FIN -------------------

CREATE OR REPLACE TRIGGER trg_auditar_lecciones
AFTER INSERT OR UPDATE OR DELETE ON Lecciones
FOR EACH ROW
DECLARE
    v_id_admin NUMBER(8);
    v_id_profesor NUMBER(8);
    v_id_usuario NUMBER(8);
BEGIN
    -- Obtener el id_admin, id_profesor y id_usuario del curso relacionado
    SELECT p.id_admin_fk_pr, cp.id_profesor_fk_lp, uc.id_usuario_fk_uc
    INTO v_id_admin, v_id_profesor, v_id_usuario
    FROM Cursos c
    JOIN Profesores p ON c.id_curso = p.id_admin_fk_pr
    JOIN Cursos_profesores cp ON c.id_curso = cp.id_curso_fk_lp
    JOIN Usuarios_curso uc ON c.id_curso = uc.id_curso_fk_uc
    WHERE c.id_curso = :NEW.id_curso_fk_lec;
    
    -- Insertar registro en Auditoria_lecciones
    IF INSERTING THEN
        INSERT INTO Auditoria_lecciones (id_leccion_aud, id_curso_aud, nombre_leccion_aud, contenido_leccion_aud, dificultad_leccion_aud, id_profesor_aud, id_usuario_aud, id_admin_aud, fecha_de_cambio_aud, operacion) 
        VALUES (:NEW.id_leccion, :NEW.id_curso_fk_lec, :NEW.nombre_lec, :NEW.contenido_lec, :NEW.dificultad_lec, v_id_profesor, v_id_usuario, v_id_admin, SYSTIMESTAMP, 'INSERT');
    ELSIF UPDATING THEN
        INSERT INTO Auditoria_lecciones (id_leccion_aud, id_curso_aud, nombre_leccion_aud, contenido_leccion_aud, dificultad_leccion_aud, id_profesor_aud, id_usuario_aud, id_admin_aud, fecha_de_cambio_aud, operacion) 
        VALUES (:NEW.id_leccion, :NEW.id_curso_fk_lec, :NEW.nombre_lec, :NEW.contenido_lec, :NEW.dificultad_lec, v_id_profesor, v_id_usuario, v_id_admin, SYSTIMESTAMP, 'UPDATE');

    ELSIF DELETING THEN
        INSERT INTO Auditoria_lecciones (id_leccion_aud, id_curso_aud, nombre_leccion_aud, contenido_leccion_aud, dificultad_leccion_aud, id_profesor_aud, id_usuario_aud, id_admin_aud, fecha_de_cambio_aud, operacion) 
        VALUES (:OLD.id_leccion, :OLD.id_curso_fk_lec, :OLD.nombre_lec, :OLD.contenido_lec, :OLD.dificultad_lec, v_id_profesor, v_id_usuario, v_id_admin, SYSTIMESTAMP, 'DELETE');

    END IF;
END;
/


SELECT*FROM Lecciones;

CREATE OR REPLACE TRIGGER trg_auditar_lecciones
AFTER INSERT OR UPDATE OR DELETE ON Lecciones
FOR EACH ROW
DECLARE
    v_id_admin NUMBER(8);
    v_id_profesor NUMBER(8);
    v_id_usuario NUMBER(8);
BEGIN
    -- Obtener el id_admin, id_profesor y id_usuario del curso relacionado
    SELECT c.id_admin_fk_cur, cp.id_profesor_fk_lp, uc.id_usuario_fk_uc
    INTO v_id_admin, v_id_profesor, v_id_usuario
    FROM Cursos c
    LEFT JOIN Cursos_profesores cp ON c.id_curso = cp.id_curso_fk_lp
    LEFT JOIN Usuarios_curso uc ON c.id_curso = uc.id_curso_fk_uc
    WHERE c.id_curso = :NEW.id_curso_fk_lec;

    -- Insertar registro en Auditoria_lecciones
    IF INSERTING THEN
        INSERT INTO Auditoria_lecciones (
            id_leccion_aud, id_curso_aud, nombre_leccion_aud,
            contenido_leccion_aud, dificultad_leccion_aud,
            id_profesor_aud, id_usuario_aud, id_admin_aud,
            fecha_de_cambio_aud, operacion
        ) VALUES (
            :NEW.id_leccion, :NEW.id_curso_fk_lec, :NEW.nombre_lec,
            :NEW.contenido_lec, :NEW.dificultad_lec,
            v_id_profesor, v_id_usuario, v_id_admin,
            SYSTIMESTAMP, 'INSERT'
        );
    ELSIF UPDATING THEN
        INSERT INTO Auditoria_lecciones (
            id_leccion_aud, id_curso_aud, nombre_leccion_aud,
            contenido_leccion_aud, dificultad_leccion_aud,
            id_profesor_aud, id_usuario_aud, id_admin_aud,
            fecha_de_cambio_aud, operacion
        ) VALUES (
            :NEW.id_leccion, :NEW.id_curso_fk_lec, :NEW.nombre_lec,
            :NEW.contenido_lec, :NEW.dificultad_lec,
            v_id_profesor, v_id_usuario, v_id_admin,
            SYSTIMESTAMP, 'UPDATE'
        );
    ELSIF DELETING THEN
        INSERT INTO Auditoria_lecciones (
            id_leccion_aud, id_curso_aud, nombre_leccion_aud,
            contenido_leccion_aud, dificultad_leccion_aud,
            id_profesor_aud, id_usuario_aud, id_admin_aud,
            fecha_de_cambio_aud, operacion
        ) VALUES (
            :OLD.id_leccion, :OLD.id_curso_fk_lec, :OLD.nombre_lec,
            :OLD.contenido_lec, :OLD.dificultad_lec,
            v_id_profesor, v_id_usuario, v_id_admin,
            SYSTIMESTAMP, 'DELETE'
        );
    END IF;
END;
/
