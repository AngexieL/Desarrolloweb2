<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*, javax.naming.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Crear Tarea</title>
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
        nav {
            background-color: #333;
            color: white;
            padding: 10px;
            border-radius: 5px;
            margin-top: 20px;
        }
        nav ul {
            list-style-type: none;
            padding: 0;
        }
        nav ul li {
            display: inline;
            margin-right: 15px;
        }
        nav ul li a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }
        .form-container {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group select, .form-group input[type="text"] {
            width: calc(100% - 22px); /* Adjust width for padding and border */
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .form-group input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }
        .form-group input[type="submit"]:hover {
            background-color: #45a049;
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
            <h2>Crear Nueva Tarea</h2>
            <form action="creartarea.jsp" method="post">
                <div class="form-group">
                    <label for="usuario_id">Seleccionar Usuario:</label>
                    <select id="usuario_id" name="usuario_id" required>
                        <option value="">Seleccione un usuario</option>
                        <% 
                            Connection conn = null;
                            PreparedStatement ps = null;
                            ResultSet rs = null;

                            try {
                                Class.forName("com.mysql.cj.jdbc.Driver");
                                conn = DriverManager.getConnection("jdbc:mysql://localhost/dw2", "dw2", "dw2");
                                String sql = "SELECT id, nombre FROM usuarios";
                                ps = conn.prepareStatement(sql);
                                rs = ps.executeQuery();

                                while (rs.next()) {
                                    int id = rs.getInt("id");
                                    String nombre = rs.getString("nombre");
                        %>
                        <option value="<%= id %>"><%= nombre %></option>
                        <% 
                                }
                            } catch (ClassNotFoundException e) {
                                out.println("Error: Clase no encontrada. " + e.getMessage());
                            } catch (SQLException e) {
                                out.println("Error en SQL: " + e.getMessage());
                            } catch (Exception e) {
                                out.println("Error: " + e.getMessage());
                            } finally {
                                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                                if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                            }
                        %>
                    </select>
                </div>
                <div class="form-group">
                    <label for="titulo">Título de la Tarea:</label>
                    <input type="text" id="titulo" name="titulo" required>
                </div>
                <div class="form-group">
                    <label for="descripcion">Descripción de la Tarea:</label>
                    <input type="text" id="descripcion" name="descripcion">
                </div>
                <div class="form-group">
                    <input type="submit" value="Guardar Tarea">
                </div>
                <div class="form-group">
                    <a href="index.jsp" class="btn-back">Volver al Menú Principal</a>
                </div>
                <% 
                    if (request.getMethod().equalsIgnoreCase("post")) {
                        String usuarioId = request.getParameter("usuario_id");
                        String titulo = request.getParameter("titulo");
                        String descripcion = request.getParameter("descripcion");

                        Connection connInsert = null;
                        PreparedStatement psInsert = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            connInsert = DriverManager.getConnection("jdbc:mysql://localhost/dw2", "dw2", "dw2");
                            String sqlInsert = "INSERT INTO tareas (usuario_id, titulo, descripcion, fecha_creacion, estado, fecha_cierre) VALUES (?, ?, ?, NOW(), 'Pendiente', NULL)";
                            psInsert = connInsert.prepareStatement(sqlInsert);
                            psInsert.setInt(1, Integer.parseInt(usuarioId));
                            psInsert.setString(2, titulo);
                            psInsert.setString(3, descripcion);
                            psInsert.executeUpdate();
                            out.println("<p>Tarea guardada exitosamente.</p>");
                        } catch (ClassNotFoundException e) {
                            out.println("Error: Clase no encontrada. " + e.getMessage());
                        } catch (SQLException e) {
                            out.println("Error en SQL: " + e.getMessage());
                        } catch (Exception e) {
                            out.println("Error: " + e.getMessage());
                        } finally {
                            if (psInsert != null) try { psInsert.close(); } catch (SQLException e) { e.printStackTrace(); }
                            if (connInsert != null) try { connInsert.close(); } catch (SQLException e) { e.printStackTrace(); }
                        }
                    }
                %>
            </form>
        </div>
    </div>
</body>
</html>
