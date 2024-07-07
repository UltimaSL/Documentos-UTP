<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>vista_est</title>
</head>
<body>
    <h1>Lista de Estudiantes</h1>
    <table border="1">
        <tr>
            <th>ID Usuario</th>
            <th>Nombre</th>
            <th>Apellido</th>
            <th>Ver perfil</th>
        </tr>
        <% 
            String usuario = "LABS_ALEX";
            String contrasena = "LAB_2003";
            
            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                Connection dbconnect = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", usuario, contrasena);
                Statement dbstatement = dbconnect.createStatement();
                
                String mostrarsql = "SELECT * FROM Profesores";
                ResultSet rs = dbstatement.executeQuery(mostrarsql);
                boolean hayDatos = false;

                while (rs.next()) {
                    hayDatos = true;

        %>
                    <tr>
                        <td><%= rs.getInt("id_profesor") %></td>
                        <td><%= rs.getString("nombre_pr") %></td>
                        <td><%= rs.getString("apellido_pr") %></td>
                        <td><a href="perfil.jsp?id=<%= rs.getInt("id_profesor") %>">Perfil</a></td>
                    </tr>
        <% 
                }

                if (!hayDatos) {
                    out.println("No se encontraron registros en la tabla Usuarios<br>");
                }

                rs.close();
                dbstatement.close();
                dbconnect.close();
                
            } catch (Exception e) {
                out.println("Error en la conexión o consulta: " + e.getMessage());
            }
        %>
    </table>
</body>
</html>