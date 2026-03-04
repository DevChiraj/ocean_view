package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/MoneyReportServlet")
public class MoneyReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // ආරක්ෂාව සඳහා ඇඩ්මින් ද යන්න පරීක්ෂා කිරීම
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !session.getAttribute("role").equals("Admin")) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            ReservationDAO dao = new ReservationDAO();

            // 1. Dashboard stats ලබා ගැනීම (Total Revenue, Occupied count ආදිය)
            Map<String, Object> stats = dao.getDashboardStats();
            request.setAttribute("stats", stats);

            // 2. මාසික ආදායම ලබා ගැනීම (ග්‍රාෆ් එක සඳහා)
            Map<String, Double> revenueMap = dao.getMonthlyRevenue();
            request.setAttribute("revenueMap", revenueMap);

            // 3. report.jsp එකට දත්ත යැවීම
            request.getRequestDispatcher("report.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=report_failed");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // වාර්තා සාමාන්‍යයෙන් ලබා ගන්නේ GET ක්‍රමයට නිසා මෙතන doPost අවශ්‍ය නොවේ
        doGet(request, response);
    }
}