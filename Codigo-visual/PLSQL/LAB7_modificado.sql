
--CREACION DE TABLAS

--Crear tabla de clientes
CREATE TABLE clientes (
    id_cliente NUMBER PRIMARY KEY NOT NULL, 
    cedula VARCHAR2(25) NOT NULL, 
    nombre VARCHAR2(25) NOT NULL, 
    apellido VARCHAR2(25) NOT NULL, 
    sexo CHAR NOT NULL,
    fecha_naciminto DATE NOT NULL
);


--Crear tabla de profesiones
CREATE TABLE profesiones(
    id_profesion NUMBER PRIMARY KEY, 
    profesion VARCHAR2(25) NOT NULL
);


--Crear tabla profesiones_clientes
CREATE TABLE profesiones_clientes(
    id_cliente NUMBER NOT NULL, 
    id_profesion NUMBER NOT NULL, 
    PRIMARY KEY (id_profesion, id_cliente), 
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente), 
    FOREIGN key (id_profesion) REFERENCES profesiones(id_profesion)
);


--Crear tabla de tipos_email
CREATE TABLE tipos_email(
    id_tipo_email NUMBER PRIMARY KEY, 
    tipo_email VARCHAR2(25)
);


--Crear tabla de tipos_email_clientes
CREATE TABLE tipos_email_clientes(
    id_cliente NUMBER NOT NULL, 
    id_tipo_email NUMBER NOT NULL, 
    email VARCHAR2(50) NOT NULL, 
    PRIMARY KEY (id_cliente, id_tipo_email), 
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente), 
    FOREIGN KEY (id_tipo_email) REFERENCES tipos_email(id_tipo_email)
);


-- Crear tabla de tipos_telefonos
CREATE TABLE tipos_telefonos(
    id_tipo_telefono NUMBER PRIMARY KEY, 
    tipo_telefono VARCHAR2(25) NOT NULL
);


--Crear tabla de tipos_telefonos_clientes
CREATE TABLE tipos_telefono_cliente(
    id_cliente NUMBER NOT NULL, 
    id_tipo_telefono NUMBER NOT NULL, 
    telefono VARCHAR2(15) NOT NULL, 
    PRIMARY KEY (id_cliente, id_tipo_telefono), 
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente), 
    FOREIGN KEY (id_tipo_telefono) REFERENCES tipos_telefonos(id_tipo_telefono)
);


--Crear taba de prestamos
CREATE TABLE prestamos(
    num_prestamo NUMBER PRIMARY KEY, 
    id_cliente NUMBER NOT NULL,  
    fecha_aprobado DATE NOT NULL, 
    monto_aprobado NUMBER NOT NULL, 
    tasa_interes NUMBER NOT NULL, 
    letra_mensual NUMBER NOT NULL,
    saldo_actual NUMBER NOT NULL, 
    monto_pagado NUMBER, 
    interes_pagado NUMBER, 
    fecha_pago DATE NOT NULL
);


--crear tabla de tipo_prestamo
CREATE TABLE tipos_prestamos(
    id_tipo_prestamo NUMBER PRIMARY KEY, 
    tipo_prestamo VARCHAR2(25)
);

-- enlazar las tablas de prestamos y tipo de prestamo
ALTER TABLE prestamos
ADD id_tipo_prestamo NUMBER;

ALTER TABLE prestamos
ADD CONSTRAINT fk_tipo_prestamo
FOREIGN KEY (id_tipo_prestamo)
REFERENCES tipos_prestamos(id_tipo_prestamo);

--*********SEGUNDA PARTE*********

--agregar atributo de edad en clientes 
ALTER TABLE clientes
ADD edad NUMBER;

-- Crear tabla de sucursales
CREATE TABLE sucursales (
    id_sucursal NUMBER PRIMARY KEY,
    nombre_sucursal VARCHAR2(50) NOT NULL
);


--modificaciones nuevas

CREATE TABLE sucursal_tipo_prestamo(
    id_sucursal NUMBER,
    id_tipo_prestamo NUMBER,
    monto_prest_suc NUMBER,
    CONSTRAINT pk_sucursal_tipo_prestamo PRIMARY KEY (id_sucursal, id_tipo_prestamo),
    CONSTRAINT fk_sucursal FOREIGN KEY (id_sucursal) REFERENCES sucursales (id_sucursal),
    CONSTRAINT fk_tipo_prestamo_sucursal FOREIGN KEY (id_tipo_prestamo) REFERENCES tipos_prestamos (id_tipo_prestamo)
);

--fin de las cosas nuevas

-- enlazar las talbas de cliente y sucursal
ALTER TABLE clientes
ADD id_sucursal_cl NUMBER;

ALTER TABLE clientes
ADD CONSTRAINT fk_sucursal_cl
FOREIGN KEY (id_sucursal_cl)
REFERENCES sucursales(id_sucursal);


-- enlazar las tablas de prestamos y sucursal
ALTER TABLE prestamos
ADD id_sucursal NUMBER;

ALTER TABLE prestamos
ADD CONSTRAINT fk_sucursales
FOREIGN KEY (id_sucursal)
REFERENCES sucursales(id_sucursal);

--añadir nuevos atributos a la tabla prestamos
ALTER TABLE prestamos
ADD fechamodificacion TIMESTAMP;

ALTER TABLE prestamos
ADD usuario VARCHAR2(25);


-- Crear tabla transacpagos
CREATE TABLE transacpagos (
    id_transaccion NUMBER PRIMARY KEY,
    id_cliente NUMBER NOT NULL,
    id_tipo_prestamo NUMBER NOT NULL,
    fecha_transaccion DATE NOT NULL,
    monto_pago NUMBER NOT NULL,
    fecha_insercion TIMESTAMP NOT NULL,
    usuario VARCHAR2(50) NOT NULL,
    id_sucursal NUMBER NOT NULL, 
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_tipo_prestamo) REFERENCES tipos_prestamos(id_tipo_prestamo)
);



--CREACION DE SEQUENCIAS

-- Crear secuencias para los IDs
CREATE SEQUENCE seq_id_cliente START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_num_prestamo START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_transaccion START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_tipo_telefono START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_tipo_email START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_profesion START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_sucursal START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_id_tipo_prestamo START WITH 1 INCREMENT BY 1;



--CREACION DE PROCEDIMIENTOS

-- Procedimiento para insertar tipos de teléfonos
CREATE OR REPLACE PROCEDURE insertar_tipo_telefono(p_tipo_telefono VARCHAR2) AS
BEGIN
    INSERT INTO tipos_telefonos (id_tipo_telefono, tipo_telefono) 
    VALUES (seq_id_tipo_telefono.NEXTVAL, p_tipo_telefono);
END;
/

-- Procedimiento para insertar tipos de email
CREATE OR REPLACE PROCEDURE insertar_tipo_email(p_tipo_email VARCHAR2) AS
BEGIN
INSERT INTO tipos_email (id_tipo_email, tipo_email) 
VALUES(seq_id_tipo_email.NEXTVAL, p_tipo_email);
END;
/

-- Procedimiento para insertar profesiones
CREATE OR REPLACE PROCEDURE insertar_profesion(p_profesion VARCHAR2) AS
BEGIN
    INSERT INTO profesiones (id_profesion, profesion) 
    VALUES (seq_id_profesion.NEXTVAL, p_profesion);
END;
/

-- Procedimiento para insertar sucursales
CREATE OR REPLACE PROCEDURE insertar_sucursal(p_nombre_sucursal VARCHAR2) AS
BEGIN
    INSERT INTO sucursales (id_sucursal, nombre_sucursal) 
    VALUES (seq_id_sucursal.NEXTVAL, p_nombre_sucursal);
END;
/

-- Procedimiento para insertar tipos de prestamos
CREATE OR REPLACE PROCEDURE insertar_tipo_prestamo(p_tipo_prestamo VARCHAR2) AS
BEGIN
    INSERT INTO tipos_prestamos (id_tipo_prestamo, tipo_prestamo) 
    VALUES (seq_id_tipo_prestamo.NEXTVAL, p_tipo_prestamo);
END;
/

-- Función para calcular la edad
CREATE OR REPLACE FUNCTION calcular_edad(p_fecha_nacimiento DATE) RETURN NUMBER AS
    v_edad NUMBER;
BEGIN
    SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, p_fecha_nacimiento) / 12) INTO v_edad FROM dual;
    RETURN v_edad;
END;
/

-- Procedimiento para insertar clientes
CREATE OR REPLACE PROCEDURE insertar_cliente(p_cedula VARCHAR2, p_nombre VARCHAR2, p_apellido VARCHAR2, p_sexo CHAR, p_fecha_nacimiento DATE, p_id_sucursal NUMBER) AS
    v_edad NUMBER;
BEGIN
    v_edad := calcular_edad(p_fecha_nacimiento);
    INSERT INTO clientes (id_cliente, cedula, nombre, apellido, sexo, fecha_naciminto, edad, id_sucursal_cl) 
    VALUES (seq_id_cliente.NEXTVAL, p_cedula, p_nombre, p_apellido, p_sexo, p_fecha_nacimiento, v_edad, p_id_sucursal);
END;
/



-- Procedimiento para insertar suc_tipo_prest
CREATE OR REPLACE PROCEDURE intertar_suc_tipo_prest(p_id_sucursal NUMBER, p_id_tipo_prestamo NUMBER, p_monto_aprobado NUMBER) AS
    BEGIN
        INSERT INTO sucursal_tipo_prestamo(id_sucursal, id_tipo_prestamo, monto_prest_suc)
        VALUES (p_id_sucursal, p_id_tipo_prestamo, p_monto_aprobado);
    END;
/


-- Procedimiento para insertar prestamos
CREATE OR REPLACE PROCEDURE insertar_prestamo(
p_id_cliente NUMBER, 
p_id_tipo_prestamo NUMBER, 
p_fecha_aprobado DATE, 
p_fecha_de_pago DATE, 
p_monto_aprobado NUMBER, 
p_saldo_actual NUMBER, 
p_tasa_interes NUMBER, 
p_letra_mensual NUMBER, 
p_id_sucursal NUMBER,
p_monto_pago NUMBER, 
p_interes_pago NUMBER 
) AS

    --variable temporal para obtener el usuario actual de la base de datos
    v_usuario VARCHAR2(30);

BEGIN
    --obtener el usuario de la base de datos
    v_usuario := SYS_CONTEXT('USERENV', 'SESSION_USER');

    INSERT INTO prestamos (num_prestamo, id_cliente, id_tipo_prestamo, fecha_aprobado, fecha_pago, monto_aprobado, saldo_actual, tasa_interes, letra_mensual, fechamodificacion, usuario, id_sucursal, monto_pagado, interes_pagado)
    VALUES  (seq_num_prestamo.NEXTVAL, p_id_cliente, p_id_tipo_prestamo, p_fecha_aprobado, p_fecha_de_pago, p_monto_aprobado, p_saldo_actual, p_tasa_interes, p_letra_mensual, SYSTIMESTAMP, v_usuario, p_id_sucursal, p_monto_pago, p_interes_pago);
    
    UPDATE sucursal_tipo_prestamo
    SET monto_prest_suc = monto_prest_suc - p_monto_aprobado
    WHERE id_sucursal = p_id_sucursal AND id_tipo_prestamo = p_id_tipo_prestamo;
    
END;
/


-----------------------------ACTUALIZACIONES-----------------------------------

CREATE OR REPLACE FUNCTION actualizar_pagos_prestamos(p_num_prestamo NUMBER, p_id_cliente NUMBER, p_id_tipo_prestamo NUMBER) RETURN NUMBER IS
    p_existir NUMBER := 0; -- Inicializar la variable de existencia

    CURSOR pagos_cursor IS
        SELECT num_prestamo, id_cliente, id_tipo_prestamo, id_sucursal 
        FROM prestamos
        WHERE id_cliente = p_id_cliente; -- Filtrar por el cliente dado

BEGIN
    FOR pago IN pagos_cursor LOOP
        IF pago.num_prestamo = p_num_prestamo THEN
            p_existir := 1; -- Establecer existencia a 1 si encontramos el préstamo
            EXIT; -- Salir del bucle una vez que se haya encontrado el préstamo
        END IF;
    END LOOP;

    RETURN p_existir;
END;
/

-- Procedimiento para insertar pagos de clientes
CREATE OR REPLACE PROCEDURE insertar_pago(p_num_prestamo NUMBER, p_id_sucursal NUMBER, p_id_cliente NUMBER, p_id_tipo_prestamo NUMBER, p_fecha_transaccion DATE, p_monto_pago NUMBER) AS
    --variable temporal para obtener el usuario actual de la base de datos
    v_usuario VARCHAR2(30);
    v_existencia_pago NUMBER := 0; 

BEGIN

    v_existencia_pago := actualizar_pagos_prestamos(p_num_prestamo, p_id_cliente, p_id_tipo_prestamo);

    IF v_existencia_pago = 1 THEN

        --obtener el usuario de la base de datos
        v_usuario := SYS_CONTEXT('USERENV', 'SESSION_USER');

        INSERT INTO transacpagos (id_sucursal, id_transaccion, id_cliente, id_tipo_prestamo, fecha_transaccion, monto_pago, fecha_insercion, usuario) 
        VALUES (p_id_sucursal, seq_id_transaccion.NEXTVAL, p_id_cliente, p_id_tipo_prestamo, p_fecha_transaccion, p_monto_pago, SYSTIMESTAMP, v_usuario);
        -- Actualizar saldo actual e interes pagado en prestamos
        UPDATE prestamos 
        SET saldo_actual = saldo_actual - (p_monto_pago-(p_monto_pago*tasa_interes / 100)),
            interes_pagado = interes_pagado+(p_monto_pago*tasa_interes / 100),
            monto_pagado = monto_pagado+(p_monto_pago-(p_monto_pago*tasa_interes / 100)),
            fechamodificacion = SYSTIMESTAMP,
            usuario = v_usuario
        WHERE id_cliente = p_id_cliente AND num_prestamo = p_num_prestamo;
        
        -- Actualizar monto de prestamos en sucursales
        UPDATE sucursal_tipo_prestamo
        SET monto_prest_suc = monto_prest_suc + p_monto_pago
        WHERE id_sucursal = p_id_sucursal AND id_tipo_prestamo = p_id_tipo_prestamo;

    ELSE
        -- Si no existe el préstamo, mostrar un mensaje (o realizar otra acción según tu lógica)
        DBMS_OUTPUT.PUT_LINE('El préstamo no existe para el cliente dado.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        -- Manejar excepciones si ocurre algún error durante la ejecución
        DBMS_OUTPUT.PUT_LINE('Error al insertar el pago: ' || SQLERRM);
    
END insertar_pago;
/

-----------------------------FIN ACTUALIZACIONES-----------------------------------


--Procedimiento para insertar profesiones-clientes
CREATE OR REPLACE PROCEDURE insertar_profesion_cliente(p_id_cliente NUMBER, p_id_profesion NUMBER) AS
BEGIN
    INSERT INTO profesiones_clientes (id_cliente, id_profesion) 
    VALUES (p_id_cliente, p_id_profesion);
END;
/

--Procedimiento para insertar tipos de correos-clientes
CREATE OR REPLACE PROCEDURE insertar_tipo_email_cliente(p_id_cliente NUMBER, p_id_tipo_email NUMBER, p_email VARCHAR2) AS
BEGIN
    INSERT INTO tipos_email_clientes (id_cliente, id_tipo_email, email) 
    VALUES (p_id_cliente, p_id_tipo_email, p_email);
END;
/

--Procedimiento para insertar tipos de teléfonos-clientes
CREATE OR REPLACE PROCEDURE insertar_tipo_telefono_cliente(p_id_cliente NUMBER, p_id_tipo_telefono NUMBER, p_telefono VARCHAR2) AS
BEGIN
    INSERT INTO tipos_telefono_cliente (id_cliente, id_tipo_telefono, telefono) 
    VALUES (p_id_cliente, p_id_tipo_telefono, p_telefono);
END;
/


-- CREACION DE VISTAS

-- Vista para clientes y sus profesiones
CREATE OR REPLACE VIEW vista_clientes_profesiones AS
SELECT c.id_cliente, c.nombre, c.apellido, p.profesion
FROM clientes c
JOIN profesiones_clientes pc ON c.id_cliente = pc.id_cliente
JOIN profesiones p ON pc.id_profesion = p.id_profesion;

-- Vista para clientes y sus tipos de correos
CREATE OR REPLACE VIEW vista_clientes_emails AS
SELECT c.id_cliente, c.nombre, c.apellido, te.tipo_email, tec.email
FROM clientes c
JOIN tipos_email_clientes tec ON c.id_cliente = tec.id_cliente
JOIN tipos_email te ON tec.id_tipo_email = te.id_tipo_email;

-- Vista para clientes y sus tipos de teléfonos
CREATE OR REPLACE VIEW vista_clientes_telefonos AS
SELECT c.id_cliente, c.nombre, c.apellido, tt.tipo_telefono, ttc.telefono
FROM clientes c
JOIN tipos_telefono_cliente ttc ON c.id_cliente = ttc.id_cliente
JOIN tipos_telefonos tt ON ttc.id_tipo_telefono = tt.id_tipo_telefono;

-- Vista para préstamos y sucursales
CREATE OR REPLACE VIEW vista_prestamos_sucursales AS
SELECT p.num_prestamo, c.nombre, c.apellido, tp.tipo_prestamo, s.nombre_sucursal, p.monto_aprobado, p.saldo_actual
FROM prestamos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN tipos_prestamos tp ON p.id_tipo_prestamo = tp.id_tipo_prestamo
JOIN sucursales s ON p.id_sucursal = s.id_sucursal;

-- Vista para pagos y sucursales
CREATE OR REPLACE VIEW vista_pagos_sucursales AS
SELECT t.id_transaccion, c.nombre, c.apellido, tp.tipo_prestamo, s.nombre_sucursal, t.monto_pago, t.fecha_transaccion
FROM transacpagos t
JOIN clientes c ON t.id_cliente = c.id_cliente
JOIN tipos_prestamos tp ON t.id_tipo_prestamo = tp.id_tipo_prestamo
JOIN sucursales s ON t.id_sucursal = s.id_sucursal;

-- Mostrar la vista de clientes y sus profesiones
SELECT * FROM vista_clientes_profesiones;

-- Mostrar la vista de clientes y sus tipos de correos
SELECT * FROM vista_clientes_emails;

-- Mostrar la vista de clientes y sus tipos de teléfonos
SELECT * FROM vista_clientes_telefonos;

-- Mostrar la vista de préstamos y sucursales
SELECT * FROM vista_prestamos_sucursales;

-- Mostrar la vista de pagos y sucursales
SELECT * FROM vista_pagos_sucursales;
