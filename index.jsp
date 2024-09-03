<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Sistema de Gestión de Tareas</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
            color: #333;
            text-align: center; /* Centra el contenido */
        }
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
        }
        header {
            background-color: #4CAF50;
            color: white;
            padding: 20px;
            text-align: center;
        }
        nav {
            background-color: #333;
            padding: 15px;
            margin: 20px auto;
            display: flex;
            justify-content: center;
            border-radius: 5px;
        }
        nav ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
            display: flex;
            justify-content: center;
        }
        nav ul li {
            margin: 0 15px;
        }
        nav ul li a {
            color: white;
            text-decoration: none;
            font-weight: bold;
        }
        nav ul li a:hover {
            text-decoration: underline;
        }
        .welcome {
            margin-top: 20px;
            font-size: 1.2em;
        }
    </style>
</head>
<body>
    <header>
        <h1>Sistema de Gestión de Tareas</h1>
    </header>
    <div class="container">
        <div class="welcome">
            <p>Bienvenidos al Sistema de Gestión de Tareas.</p>
            <p>Este proyecto ha sido desarrollado por Jordan Pérez y Elizabeth Bacilio.</p>
        </div>
        <nav>
            <ul>
                <li><a href="creartarea.jsp">Crear Tarea</a></li>
                <li><a href="listatareas.jsp">Listar Tareas</a></li>
                <li><a href="reportes.jsp">Reportes</a></li>
            </ul>
        </nav>
    </div>
</body>
</html>
