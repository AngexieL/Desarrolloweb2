<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reportes - Sistema de Tareas</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="styles.css"> <!-- Asegúrate de tener este archivo o ajusta el enlace según tu CSS -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .chart-container {
            position: relative;
            height: 40vh;
            width: 100%;
        }
        .container {
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <a class="navbar-brand" href="index.jsp">Inicio</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="listatareas.jsp">Listado de Tareas</a>
                </li>
                <li class="nav-item active">
                    <a class="nav-link" href="reportes.jsp">Reportes</a>
                </li>
            </ul>
        </div>
    </nav>
    
    <div class="container">
        <h2 class="text-center">Reportes</h2>
        <div class="row">
            <div class="col-md-6 chart-container">
                <canvas id="taskStatusChart"></canvas>
            </div>
            <div class="col-md-6 chart-container">
                <canvas id="userTasksChart"></canvas>
            </div>
        </div>
    </div>
    
    <script>
        // Obtener datos de la base de datos a través de JSP
        var taskStatusData = <%= taskStatusData %>;
        var userTasksData = <%= userTasksData %>;

        // Configuración del gráfico de estado de tareas
        var ctx1 = document.getElementById('taskStatusChart').getContext('2d');
        var taskStatusChart = new Chart(ctx1, {
            type: 'pie',
            data: taskStatusData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                title: {
                    display: true,
                    text: 'Distribución de Estados de Tareas'
                }
            }
        });

        // Configuración del gráfico de tareas por usuario
        var ctx2 = document.getElementById('userTasksChart').getContext('2d');
        var userTasksChart = new Chart(ctx2, {
            type: 'bar',
            data: userTasksData,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                title: {
                    display: true,
                    text: 'Tareas Pendientes por Usuario'
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>

    <% 
        // Conectar a la base de datos
        String dbURL = "jdbc:mysql://localhost:3306/dw2";
        String dbUser = "dw2";
        String dbPassword = "dw2";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Obtener datos para el gráfico de estados de tareas
            JSONObject taskStatusData = new JSONObject();
            JSONArray taskStatusLabels = new JSONArray();
            JSONArray taskStatusCounts = new JSONArray();

            ps = conn.prepareStatement("SELECT estado, COUNT(*) AS count FROM tareas GROUP BY estado");
            rs = ps.executeQuery();

            while (rs.next()) {
                taskStatusLabels.put(rs.getString("estado"));
                taskStatusCounts.put(rs.getInt("count"));
            }

            taskStatusData.put("labels", taskStatusLabels);
            taskStatusData.put("datasets", new JSONArray().put(new JSONObject().put("data", taskStatusCounts).put("backgroundColor", new JSONArray().put("#FF6384").put("#36A2EB").put("#FFCE56"))));

            rs.close();
            ps.close();

            // Obtener datos para el gráfico de tareas por usuario
            JSONObject userTasksData = new JSONObject();
            JSONArray userLabels = new JSONArray();
            JSONArray userCounts = new JSONArray();

            ps = conn.prepareStatement("SELECT usuario, COUNT(*) AS count FROM tareas WHERE estado = 'PENDIENTE' GROUP BY usuario");
            rs = ps.executeQuery();

            while (rs.next()) {
                userLabels.put(rs.getString("usuario"));
                userCounts.put(rs.getInt("count"));
            }

            userTasksData.put("labels", userLabels);
            userTasksData.put("datasets", new JSONArray().put(new JSONObject().put("data", userCounts).put("backgroundColor", "#36A2EB")));

            // Pasar datos a la página JSP
            pageContext.setAttribute("taskStatusData", taskStatusData.toString());
            pageContext.setAttribute("userTasksData", userTasksData.toString());

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</body>
</html>
