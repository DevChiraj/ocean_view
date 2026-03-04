package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/StaffServlet")
public class StaffServlet extends HttpServlet {

    // Singleton නිසා මෙතන අලුතින් new UserDAO() කරන්න අවශ්‍ය නැහැ

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserDAO userDAO = new UserDAO();
        List<Map<String, String>> staffList = userDAO.getAllUsers();

        request.setAttribute("staffList", staffList);
        // JSP එකේ නම manage-staff.jsp ද කියලා නැවත බලන්න
        request.getRequestDispatcher("manage-staff.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("fullName");
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String role = request.getParameter("role");

        // සියලුම දත්ත ලැබී ඇත්දැයි පරීක්ෂා කිරීම
        if (name == null || name.isEmpty() || user == null || user.isEmpty() || pass == null || role == null) {
            response.sendRedirect("StaffServlet?status=missing");
            return;
        }

        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.registerUser(name, user, pass, role);

        if (success) {
            response.sendRedirect("StaffServlet?status=success");
        } else {
            response.sendRedirect("StaffServlet?status=error");
        }
    }
}