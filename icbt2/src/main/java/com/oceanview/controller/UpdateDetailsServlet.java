package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/UpdateDetailsServlet")
public class UpdateDetailsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // ෆෝම් එකෙන් දත්ත ලබා ගැනීම
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String username = (String) session.getAttribute("username"); // Session එකෙන් username එක ගන්න

        UserDAO dao = new UserDAO();
        boolean success = dao.updateUserDetails(fullName, email, phone, username);

        if (success) {
            // සෙෂන් එකේ තියෙන නම අලුත් නමට වෙනස් කරන්න
            session.setAttribute("user", fullName);
            response.sendRedirect("settings.jsp?status=success");
        } else {
            response.sendRedirect("settings.jsp?status=error");
        }
    }
}