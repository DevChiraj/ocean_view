package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Session Check: Verify if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Data Retrieval
        ReservationDAO dao = new ReservationDAO();

        // Get summary statistics for cards
        Map<String, Object> stats = dao.getDashboardStats();

        // Get latest 5 activities for the table
        List<Map<String, String>> recentGuests = dao.getRecentReservations(5);

        // 3. Set Attributes and Forward to JSP
        request.setAttribute("stats", stats);
        request.setAttribute("recentGuests", recentGuests);
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}