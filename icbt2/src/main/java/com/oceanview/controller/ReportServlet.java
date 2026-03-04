package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            ReservationDAO dao = new ReservationDAO();

            // ඩේටාබේස් එකෙන් රිපෝට් එකට අවශ්‍ය දත්ත ලබා ගැනීම
            Map<String, Object> stats = dao.getDashboardStats();
            Map<String, Double> revenueMap = dao.getMonthlyRevenue();

            // JSP එකට දත්ත යැවීම සඳහා attributes සකස් කිරීම
            request.setAttribute("stats", stats);
            request.setAttribute("revenueMap", revenueMap);

            // reports.jsp පිටුවට දත්ත යොමු කිරීම (Forward)
            request.getRequestDispatcher("reports.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // එරර් එකක් ආවොත් ලොග් එකේ පෙන්වීමට සකස් කර ඇත
        }
    }
}