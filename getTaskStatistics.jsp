<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.sql.*" %>
<%
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost/dw2", "dw2", "dw2");

        // Get task counts by state
        String sqlStates = "SELECT estado, COUNT(*) AS count FROM tareas GROUP BY estado";
        ps = conn.prepareStatement(sqlStates);
        rs = ps.executeQuery();

        StringBuilder jsonStates = new StringBuilder("[");
        while (rs.next()) {
            String estado = rs.getString("estado");
            int count = rs.getInt("count");
            jsonStates.append("{\"name\":\"").append(estado).append("\", \"count\":").append(count).append("},");
        }
        if (jsonStates.length() > 1) {
            jsonStates.setLength(jsonStates.length() - 1); // Remove trailing comma
        }
        jsonStates.append("]");

        rs.close();
        ps.close();

        // Get task counts by user
        String sqlUsers = "SELECT u.nombre AS name, COUNT(t.id) AS count FROM tareas t JOIN usuarios u ON t.usuario_id = u.id GROUP BY u.nombre";
        ps = conn.prepareStatement(sqlUsers);
        rs = ps.executeQuery();

        StringBuilder jsonUsers = new StringBuilder("[");
        while (rs.next()) {
            String name = rs.getString("name");
            int count = rs.getInt("count");
            jsonUsers.append("{\"name\":\"").append(name).append("\", \"count\":").append(count).append("},");
        }
        if (jsonUsers.length() > 1) {
            jsonUsers.setLength(jsonUsers.length() - 1); // Remove trailing comma
        }
        jsonUsers.append("]");

        out.print("{\"states\":" + jsonStates.toString() + ",\"users\":" + jsonUsers.toString() + "}");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
