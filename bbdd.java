// SaveTaskServlet.java
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/saveTask")
public class SaveTaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String usuarioId = request.getParameter("usuario_id");
        String titulo = request.getParameter("titulo");

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost/dw2", "dw2", "dw2");
            String sql = "INSERT INTO tareas (usuario_id, titulo, fecha_creacion, estado, fecha_cierre) VALUES (?, ?, NOW(), 'Pendiente', NULL)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(usuarioId));
            ps.setString(2, titulo);

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("success.jsp"); // Redirige a una página de éxito
            } else {
                response.sendRedirect("error.jsp"); // Redirige a una página de error
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        } finally {
            if (ps != null) try { ps.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
