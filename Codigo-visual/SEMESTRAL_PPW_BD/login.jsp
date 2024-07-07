<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <% 
        String usuario = "LABS_ALEX";
        String contraseña = "LAB_2003";

        // captura de los valores que vienen desde el formulario.
        String correo = request.getParameter("Correo");
        String con = request.getParameter("Contraseña");
        Number n = request.getParameter("op_login");
        
        //creamos la conexion        
        Class.forName("oracle.jdbc.driver.OracleDriver");
        Connection dbconnect = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:XE", usuario, contraseña);
        Statement dbstatement = dbconnect.createStatement();
        
        if(n == 1){
            PreparedStatement preparado = dbconnect.prepareStatement("SELECT correo_pr, contrasena_pr FROM Profesores WHERE correo_pr=? AND contrasena_pr=?");
        } else if(n == 2){
            PreparedStatement preparado = dbconnect.prepareStatement("SELECT correo_adm, contrasena_adm FROM Admins WHERE correo_adm=? AND contrasena_adm=?");
        } else {
            PreparedStatement preparado = dbconnect.prepareStatement("SELECT correo_usr, contrasena_usr FROM Usuarios WHERE correo_usr=? AND contrasena_usr=?");
        }
        
        //Prepared Statement para proteger de SQL injection
        preparado.setString(1,correo);
        preparado.setString(2,con);

        //Ejecutamos consulta y obtenemos un resulSet
        ResultSet resultados = preparado.executeQuery();

        //Recorremos el ResultSet para ver si NO esta vacio.
        String msg;
        if(resultados.next())
        	msg = "<h1 style='color: green;'>FELICIDADES, USUARIO CORRECTO</h1>";
        else
        	msg = "<h1 style='color: red;'>****ERROR*** <br> USUARIO INCORRECTO</h1>";
    %>
    
    <%= msg %>
</body>
</html>