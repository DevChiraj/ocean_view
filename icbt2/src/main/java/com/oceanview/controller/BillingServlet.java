package com.oceanview.controller;

import com.oceanview.dao.BillingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/BillingServlet")
public class BillingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String resId = request.getParameter("resId");

        // ID එකක් නැතිනම් ආපසු හරවා යැවීම
        if (resId == null || resId.trim().isEmpty()) {
            response.sendRedirect("reservation-list.jsp?error=MissingID");
            return;
        }

        BillingDAO dao = new BillingDAO();
        Map<String, String> data = dao.getBillDetails(resId);

        if (data != null && !data.isEmpty()) {
            try {
                // දින ගණන නිවැරදිව ගණනය කිරීම
                LocalDate checkIn = LocalDate.parse(data.get("check_in"));
                LocalDate checkOut = LocalDate.parse(data.get("check_out"));
                long nights = ChronoUnit.DAYS.between(checkIn, checkOut);

                if (nights <= 0) nights = 1;

                // මිල ලබාගැනීම (දත්ත නොමැතිනම් 5000ක් ලෙස Default අගයක් ගැනීම)
                String priceStr = data.get("price");
                double pricePerNight = (priceStr != null) ? Double.parseDouble(priceStr) : 5000.0;

                double totalAmount = nights * pricePerNight;

                // JSP එකට දත්ත යැවීම
                request.setAttribute("billData", data);
                request.setAttribute("nightsCount", nights);
                request.setAttribute("totalBill", totalAmount);

                request.getRequestDispatcher("print-bill.jsp").forward(request, response);

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("reservation-list.jsp?error=CalculationError");
            }
        } else {
            response.sendRedirect("reservation-list.jsp?error=NoDataFound");
        }
    }
}