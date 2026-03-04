package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/StaffDashboard")
public class StaffDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Session පරීක්ෂාව: යූසර් ලොග් වෙලාද බලන්න
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. දත්ත ලබාගැනීම
        ReservationDAO dao = new ReservationDAO();
        Map<String, Object> stats = dao.getDashboardStats();
        List<Map<String, String>> recentBookings = dao.getRecentReservations(5);

        // 3. දත්ත JSP එකට යැවීම (Null නොවීමට මෙය අනිවාර්යයි)
        request.setAttribute("stats", stats);
        request.setAttribute("recentBookings", recentBookings);

        // 4. JSP පේජ් එකට යොමු කිරීම
        request.getRequestDispatcher("staff-dashboard.jsp").forward(request, response);
    }
}