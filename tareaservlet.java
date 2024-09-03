package com.example.taskmanagement.servlet;

import com.example.taskmanagement.model.Tarea;
import com.example.taskmanagement.model.Usuario;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet("/tareas")
public class TareaServlet extends HttpServlet {

    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("TaskManagementPU");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        // Código para manejar solicitudes GET y listar tareas
        em.close();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        EntityManager em = emf.createEntityManager();
        em.getTransaction().begin();

        Tarea tarea = new Tarea();
        tarea.setTitulo(req.getParameter("titulo"));
        tarea.setDescripcion(req.getParameter("descripcion"));
        tarea.setFechaCreacion(LocalDate.now());
        tarea.setFechaLimite(LocalDate.parse(req.getParameter("fechaLimite")));
        tarea.setEstado(Tarea.EstadoTarea.PENDIENTE);

        Usuario usuario = em.find(Usuario.class, 1L); // Asignar tarea a un usuario con id 1
        tarea.setUsuario(usuario);

        em.persist(tarea);
        em.getTransaction().commit();
        em.close();

        resp.sendRedirect(req.getContextPath() + "/tareas");
    }

    @Override
    public void destroy() {
        emf.close();
    }
}
