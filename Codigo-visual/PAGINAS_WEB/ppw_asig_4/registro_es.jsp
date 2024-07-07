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
            String indice = request.getParameter("indice");
            String centro_regional = request.getParameter("centro_rg_es");
            String soldadura = request.getParameter("soldadura");
            String electronica = request.getParameter("electronica");
            String cocina = request.getParameter("cocina");
            String programacion = request.getParameter("programacion");
            String election_year_tmp = request.getParameter("election_year_tmp");

            if (nombre != null && apellido != null && cedula != null && centro_regional != null && indice != null && election_year_tmp != null) {
                String insertarsql = "INSERT INTO estudiantes (cedula, nombre, apellido, indice, sucursales_es, curso1_es, curso2_es, curso3_es, curso4_es, election_year_tmp) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement pstmt = dbconnect.prepareStatement(insertarsql);
                pstmt.setString(1, cedula);
                pstmt.setString(2, nombre);
                pstmt.setString(3, apellido);
                pstmt.setString(4, indice);
                pstmt.setString(5, centro_regional);
                pstmt.setString(6, soldadura);
                pstmt.setString(7, electronica);
                pstmt.setString(8, cocina);
                pstmt.setString(9, programacion);
                pstmt.setString(10, election_year_tmp);

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


  
