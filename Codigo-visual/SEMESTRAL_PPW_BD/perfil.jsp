<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Perfil del Usuario</title>
</head>
<body>
    <h1>Perfil del Usuario</h1>
    
    <% 
        // Obtener los parámetros de la URL
        String idUsuario = request.getParameter("id_usuario_usr");
        String tupla = request.getParameter("tupla");

        if (idUsuario != null && tupla != null) {
            // Convertir idUsuario a un entero
            int idUsuarioInt = Integer.parseInt(idUsuario);
            
            // Imprimir los valores obtenidos
            out.println("ID Usuario: " + idUsuarioInt + "<br>");
            out.println("Número de Tupla: " + tupla + "<br>");

            // Aquí puedes agregar la lógica para conectar a la base de datos y obtener más detalles del usuario
            try {
                String usuario = "LABS_ALEX";
                String contrasena = "LAB_2003";

                Class.forName("oracle.jdbc.driver.OracleDriver");
                Connection dbconnect = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", usuario, contrasena);
                Statement dbstatement = dbconnect.createStatement();

                String sql = "SELECT * FROM Usuarios WHERE id_usuario_usr = " + idUsuarioInt;
                ResultSet rs = dbstatement.executeQuery(sql);

                if (rs.next()) {
                    out.println("Nombre: " + rs.getString("nombre_usr") + "<br>");
                    out.println("Apellido: " + rs.getString("apellido_usr") + "<br>");
                    out.println("Correo: " + rs.getString("correo_usr") + "<br>");
                    // Agrega más campos según sea necesario
                } else {
                    out.println("No se encontró el usuario con ID: " + idUsuarioInt + "<br>");
                }

                rs.close();
                dbstatement.close();
                dbconnect.close();
            } catch (Exception e) {
                out.println("Error en la conexión o consulta: " + e.getMessage());
            }
        } else {
            out.println("Parámetros no válidos.<br>");
        }
    %>
</body>
</html>

