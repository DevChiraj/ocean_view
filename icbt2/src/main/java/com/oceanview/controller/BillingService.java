package com.oceanview.controller;

import com.oceanview.dao.BillingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Map;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/BillingService")
public class BillingService extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        BillingDAO dao = new BillingDAO();
        Map<String, String> data = dao.getBillDetails(id);

        if (data != null) {
            LocalDate d1 = LocalDate.parse(data.get("in"));
            LocalDate d2 = LocalDate.parse(data.get("out"));
            long nights = ChronoUnit.DAYS.between(d1, d2);
            if (nights <= 0) nights = 1;

            double price = Double.parseDouble(data.get("price"));
            request.setAttribute("resData", data);
            request.setAttribute("nights", nights);
            request.setAttribute("total", (nights * price));
            request.getRequestDispatcher("billing-invoice.jsp").forward(request, response);
        } else {
            response.sendRedirect("reservation-list.jsp?msg=NoData");
        }
    }
}