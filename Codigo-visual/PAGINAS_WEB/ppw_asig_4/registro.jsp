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
        // Definir las credenciales de conexión
        String usuario = "LABS_ALEX";
        String contraseña = "LAB_2003";

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection dbconnect = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", usuario, contraseña);
            Statement dbstatement = dbconnect.createStatement();

            String nombre = request.getParameter("fname");
            String apellido = request.getParameter("lname");
            String cedula = request.getParameter("cedula");
            String materia = request.getParameter("especialidad");
            String centro_regional = request.getParameter("centro_rg");
            String exp_virtual = request.getParameter("exp_virtual");

            if (nombre != null && apellido != null && cedula != null && materia != null && centro_regional != null && exp_virtual != null) {
                String insertarsql = "INSERT INTO profesores (cedula, nombre, apellido, sucursales_pf, cursos_pf, clases_virt) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement pstmt = dbconnect.prepareStatement(insertarsql);
                pstmt.setString(1, cedula);
                pstmt.setString(2, nombre);
                pstmt.setString(3, apellido);
                pstmt.setString(4, centro_regional);
                pstmt.setString(5, materia);
                pstmt.setString(6, exp_virtual);

                int rows = pstmt.executeUpdate();

                if (rows > 0) {
                    out.println("Registro exitoso");
                } else {
                    out.println("No se pudo realizar el registro");
                }

                pstmt.close();
            } else {
                out.println("Por favor, complete todos los campos");
            }

            dbstatement.close();
            dbconnect.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("Error: " + e.getMessage());
        }
    %> 
</body>
</html>


  
