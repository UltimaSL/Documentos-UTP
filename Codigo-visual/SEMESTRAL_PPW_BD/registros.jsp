<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registro</title>
</head>
<body>

    <%
            String usuario = "LABS_ALEX";
            String contraseña = "LAB_2003";

        try {
                //Conectar a la BD
                Class.forName("oracle.jdbc.driver.OracleDriver");
                Connection dbconnect = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", usuario, contraseña);
                Statement dbstatement = dbconnect.createStatement();

            if(){
                    
                //Llamar al procedimiento almacenado
                String sql = "{call insertar_profesores(?, ?, ?, ?, ?, ?, ?)}";
                callableStatement = connection.prepareCall(sql);

                //Establecer los parámetros del procedimiento almacenado
                String nombre = request.getParameter("fname");
                String apellido = request.getParameter("lname");
                java.sql.Date fechaNacimiento = request.getParameter("fecha_de_nacimiento");
                String correo = request.getParameter("Correo");
                String contraseña = request.getParameter("Contraseña");
                int idEsp = request.getParameter("especialidad");
                int idAdmin = request.getParameter("id_admin");
                int idCurso = request.getParameter("id_curso");

                //nota de backend: sirve para ingresar los valores a cada una de las varables del procedimiento almacenado
                callableStatement.setString(1, nombre);
                callableStatement.setString(2, apellido);
                callableStatement.setDate(3, fechaNacimiento);
                callableStatement.setString(4, correo);
                callableStatement.setString(5, contraseña);
                callableStatement.setInt(6, idEsp);
                callableStatement.setInt(7, idAdmin);
                callableStatement.setInt(8, idCurso);

                //nota de backend: Con esto ejecutamos el procecimiento almacenado en la base de datos
                callableStatement.execute();
            }

            else if(){
                // Llamar al procedimiento almacenado
                String sql = "{call insertar_admins(?, ?, ?, ?, ?, ?)}";
                callableStatement = connection.prepareCall(sql);

                // Establecer los parámetros del procedimiento almacenado
                String nombreAdm = request.getParameter("fname");
                String apellidoAdm = request.getParameter("lname");
                String fechaNacimientoAdm = request.getParameter("fecha_de_nacimiento"); // Fecha en formato VARCHAR2
                int numDeptAdm = request.getParameter("numDeptAdm");
                String correoAdm = request.getParameter("Correo");
                String contraseñaAdm = request.getParameter("Contraseña");

                //nota de backend: sirve para ingresar los valores a cada una de las varables del procedimiento almacenado
                callableStatement.setString(1, nombreAdm);
                callableStatement.setString(2, apellidoAdm);
                callableStatement.setString(3, fechaNacimientoAdm);
                callableStatement.setString(4, numDeptAdm);
                callableStatement.setString(5, correoAdm);
                callableStatement.setString(6, contraseñaAdm);

                //nota de backend: Con esto ejecutamos el procecimiento almacenado en la base de datos
                callableStatement.execute();     
            }

            else{
                // Llamar al procedimiento almacenado
                String sql = "{call insertar_usuarios(?, ?, ?, ?, ?, ?)}"; 
                callableStatement = connection.prepareCall(sql);

                // Establecer los parámetros del procedimiento almacenado
                String nombreUs = request.getParameter("fname");
                String apellidoUs = request.getParameter("lname");
                java.sql.Date fechaNacimiento = request.getParameter("fecha_de_nacimiento");
                String usernameUs = request.getParameter("usernameUs");
                String correoUs = getParameter("Correo");
                String contraseñaUs = request.getParameter("Contraseña");
                int idCursoUs = request.getParameter("id_curso");


                //nota de backend: sirve para ingresar los valores a cada una de las varables del procedimiento almacenado
                callableStatement.setString(1, nombreUs);
                callableStatement.setString(2, apellidoUs);
                callableStatement.setDate(3, fechaNacimiento);
                callableStatement.setString(4, usernameUs);
                callableStatement.setString(5, correoUs);
                callableStatement.setString(6, contraseñaUs);
                callableStatement.setInt(7, idCursoUs);

                //nota de backend: Con esto ejecutamos el procecimiento almacenado en la base de datos
                callableStatement.execute();
            }


            out.println("Procedimiento almacenado ejecutado con éxito.");
        } catch (ClassNotFoundException e) {
            out.println("Error al cargar el driver JDBC: " + e.getMessage()); //nota de backend: con e.getMessage obtenemos el error que se a producido
        } catch (SQLException e) {
            out.println("Error al ejecutar el procedimiento almacenado: " + e.getMessage());
        }
    %>
<body>
</html>
