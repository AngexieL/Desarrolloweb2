<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Lista de Tareas</title>
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
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #4CAF50;
            color: white;
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
        .date-container {
            background-color: #f4f4f4;
            padding: 10px;
            border-radius: 5px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <header>
        <h1>Sistema de Gestión de Tareas</h1>
    </header>
    <div class="container">
        <nav>
            <ul>
                <li><a href="index.jsp">Inicio</a></li>
                <li><a href="creartarea.jsp">Crear Tarea</a></li>
                <li><a href="listatareas.jsp">Listar Tareas</a></li>
            </ul>
        </nav>
        <h2>Tareas Pendientes y en Progreso</h2>
        <table>
            <thead>
                <tr>
                    <th>Usuario</th>
                    <th>Título</th>
                    <th>Descripción</th>
                    <th>Fecha de Creación</th>
                    <th>Estado</th>
                    <th>Actualizar Estado</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost/dw2", "dw2", "dw2");

                        String sql = "SELECT t.id, t.titulo, t.descripcion, t.fecha_creacion, t.estado, u.nombre " +
                                     "FROM tareas t JOIN usuarios u ON t.usuario_id = u.id " +
                                     "WHERE t.estado IN ('PENDIENTE', 'EN PROGRESO')";
                        ps = conn.prepareStatement(sql);
                        rs = ps.executeQuery();

                        while (rs.next()) {
                            int id = rs.getInt("id");
                            String titulo = rs.getString("titulo");
                            String descripcion = rs.getString("descripcion");
                            String fechaCreacion = rs.getString("fecha_creacion");
                            String estado = rs.getString("estado");
                            String nombreUsuario = rs.getString("nombre");
                %>
                <tr>
                    <td><%= nombreUsuario %></td>
                    <td><%= titulo %></td>
                    <td><%= descripcion %></td>
                    <td><%= fechaCreacion %></td>
                    <td><%= estado %></td>
                    <td>
                        <form action="updateTaskStatus.jsp" method="post">
                            <input type="hidden" name="task_id" value="<%= id %>">
                            <select name="estado" required>
                                <option value="EN PROGRESO" <%= estado.equals("EN PROGRESO") ? "selected" : "" %>>En Progreso</option>
                                <option value="FINALIZADA" <%= estado.equals("FINALIZADA") ? "selected" : "" %>>Finalizada</option>
                                <option value="CANCELADA" <%= estado.equals("CANCELADA") ? "selected" : "" %>>Cancelada</option>
                            </select>
                            <input type="submit" value="Actualizar">
                        </form>
                    </td>
                </tr>
                <% 
                        }
                    } catch (ClassNotFoundException e) {
                        out.println("Error: Clase no encontrada. " + e.getMessage());
                    } catch (SQLException e) {
                        out.println("Error en SQL: " + e.getMessage());
                    } finally {
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </tbody>
        </table>

        <h2>Tareas Finalizadas y Canceladas</h2>
        <table>
            <thead>
                <tr>
                    <th>Usuario</th>
                    <th>Título</th>
                    <th>Descripción</th>
                    <th>Fecha de Creación</th>
                    <th>Estado</th>
                    <th>Fecha de Cierre</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    try {
                        Connection conn2 = DriverManager.getConnection("jdbc:mysql://localhost/dw2", "dw2", "dw2");

                        String sql2 = "SELECT t.id, t.titulo, t.descripcion, t.fecha_creacion, t.estado, t.fecha_cierre, u.nombre " +
                                      "FROM tareas t JOIN usuarios u ON t.usuario_id = u.id " +
                                      "WHERE t.estado IN ('FINALIZADA', 'CANCELADA')";
                        PreparedStatement ps2 = conn2.prepareStatement(sql2);
                        ResultSet rs2 = ps2.executeQuery();

                        while (rs2.next()) {
                            String fechaCierre = rs2.getString("fecha_cierre");
                            int id = rs2.getInt("id");
                            String titulo = rs2.getString("titulo");
                            String descripcion = rs2.getString("descripcion");
                            String fechaCreacion = rs2.getString("fecha_creacion");
                            String estado = rs2.getString("estado");
                            String nombreUsuario = rs2.getString("nombre");
                %>
                <tr>
                    <td><%= nombreUsuario %></td>
                    <td><%= titulo %></td>
                    <td><%= descripcion %></td>
                    <td><%= fechaCreacion %></td>
                    <td><%= estado %></td>
                    <td class="date-container"><%= fechaCierre %></td>
                </tr>
                <% 
                        }
                        rs2.close();
                        ps2.close();
                        conn2.close();
                    } catch (SQLException e) {
                        out.println("Error en SQL: " + e.getMessage());
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
