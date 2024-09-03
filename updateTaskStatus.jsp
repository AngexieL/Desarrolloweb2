<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Actualizar Estado de Tarea</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
        }
        header {
            background-color: #4CAF50;
            color: white;
            padding: 10px 0;
            text-align: center;
        }
        .form-container {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .btn-back {
            background-color: #f44336;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            margin-top: 20px;
        }
        .btn-back:hover {
            background-color: #d32f2f;
        }
    </style>
</head>
<body>
    <header>
        <h1>Sistema de Gestión de Tareas</h1>
    </header>
    <div class="container">
        <div class="form-container">
            <h2>Actualizar Estado de Tarea</h2>
            <%
                String taskId = request.getParameter("task_id");
                String newState = request.getParameter("estado");

                if (taskId != null && newState != null) {
                    Connection conn = null;
                    PreparedStatement ps = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost/dw2", "dw2", "dw2");
                        String sql = "UPDATE tareas SET estado = ?, fecha_cierre = NOW() WHERE id = ?";
                        ps = conn.prepareStatement(sql);
                        ps.setString(1, newState);
                        ps.setInt(2, Integer.parseInt(taskId));
                        ps.executeUpdate();

                        out.println("<p>Estado de la tarea actualizado con éxito.</p>");
                    } catch (ClassNotFoundException e) {
                        out.println("Error: Clase no encontrada. " + e.getMessage());
                    } catch (SQLException e) {
                        out.println("Error en SQL: " + e.getMessage());
                    } catch (Exception e) {
                        out.println("Error: " + e.getMessage());
                    } finally {
                        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                } else {
                    out.println("<p>Parámetros no válidos.</p>");
                }
            %>
            <a href="listatareas.jsp" class="btn-back">Volver a la Lista de Tareas</a>
        </div>
    </div>
</body>
</html>
