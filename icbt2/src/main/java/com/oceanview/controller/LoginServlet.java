package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        String roleFromForm = request.getParameter("role"); // Form එකෙන් එන Role එක (Admin/Staff)

        UserDAO dao = new UserDAO();
        // ඩේටාබේස් එකේ පරිශීලකයා පරීක්ෂා කිරීම
        String fullName = dao.checkUser(user, pass, roleFromForm);

        if (fullName != null) {
            HttpSession session = request.getSession();
            session.setAttribute("username", user);
            session.setAttribute("fullName", fullName);
            session.setAttribute("role", roleFromForm); // Role එක Session එකේ සේව් කිරීම

            // Role එක අනුව අදාළ Dashboard එකට යොමු කිරීම
            if ("Admin".equalsIgnoreCase(roleFromForm)) {
                response.sendRedirect("DashboardServlet");
            } else {
                // Staff සඳහා වෙනම Dashboard එකක් ඇත්නම් එයට යොමු කරන්න
                response.sendRedirect("DashboardServlet");
            }
        } else {
            // දත්ත වැරදි නම් නැවත Login එකට
            response.sendRedirect("login.jsp?error=true");
        }
    }
}