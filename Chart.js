<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Estadísticas de Tareas</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        canvas {
            width: 100% !important;
            height: auto !important;
        }
        .chart-container {
            margin-bottom: 50px;
        }
    </style>
</head>
<body>
    <header>
        <h1>Estadísticas de Tareas</h1>
    </header>
    <div class="container">
        <!-- Gráfico de tareas por estado -->
        <div class="chart-container">
            <h2>Distribución de Tareas por Estado</h2>
            <canvas id="tasksByState"></canvas>
        </div>
        <!-- Gráfico de tareas por usuario -->
        <div class="chart-container">
            <h2>Cantidad de Tareas por Usuario</h2>
            <canvas id="tasksByUser"></canvas>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const ctxState = document.getElementById('tasksByState').getContext('2d');
                const ctxUser = document.getElementById('tasksByUser').getContext('2d');
                
                fetch('getTaskStatistics.jsp')
                    .then(response => response.json())
                    .then(data => {
                        // Crear gráfico para tareas por estado
                        new Chart(ctxState, {
                            type: 'pie',
                            data: {
                                labels: data.states.map(s => s.name),
                                datasets: [{
                                    label: 'Tareas por Estado',
                                    data: data.states.map(s => s.count),
                                    backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56']
                                }]
                            },
                            options: {
                                responsive: true
                            }
                        });

                        // Crear gráfico para tareas por usuario
                        new Chart(ctxUser, {
                            type: 'bar',
                            data: {
                                labels: data.users.map(u => u.name),
                                datasets: [{
                                    label: 'Tareas por Usuario',
                                    data: data.users.map(u => u.count),
                                    backgroundColor: '#4CAF50'
                                }]
                            },
                            options: {
                                responsive: true,
                                scales: {
                                    x: {
                                        beginAtZero: true
                                    }
                                }
                            }
                        });
                    });
            });
        </script>
    </div>
</body>
</html>
