package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {

    private final ReservationDAO dao = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        // 1. View All Guests
        if ("list".equals(action)) {
            List<Map<String, String>> list = dao.getAllReservations();
            request.setAttribute("reservationList", list);
            request.getRequestDispatcher("reservation-list.jsp").forward(request, response);
        }

        // 2. New Reservation Page
        else if ("new".equals(action)) {
            try {
                List<Map<String, String>> rooms = dao.getAllRooms();
                request.setAttribute("allRooms", rooms);
                String preSelectedRoom = request.getParameter("roomNo");
                request.setAttribute("selectedRoomId", (preSelectedRoom != null) ? preSelectedRoom : "");
                request.getRequestDispatcher("add-reservation.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("dashboard.jsp?error=loading_failed");
            }
        }

        // 3. Room Map
        else if ("map".equals(action)) {
            List<Map<String, String>> rooms = dao.getAllRooms();
            request.setAttribute("rooms", rooms);
            request.getRequestDispatcher("room-map.jsp").forward(request, response);
        }

        // 4. Search & Suggestions
        else if ("search".equals(action)) {
            request.setAttribute("reservationList", dao.getAllReservations());
            String searchTerm = request.getParameter("searchTerm");
            Map<String, String> result = dao.searchReservation(searchTerm);
            request.setAttribute("searchResult", result);
            request.getRequestDispatcher("view-reservation.jsp").forward(request, response);
        }

        // 5. Invoice Generation (Fixed Method Call)
        else if ("checkout".equals(action)) {
            String resId = request.getParameter("resId");
            // DAO එකේ තියෙන නිවැරදි මෙතඩ් එක කැඳවීම
            Map<String, Object> billData = dao.getBillingDetails(resId);
            request.setAttribute("billData", billData);
            request.getRequestDispatcher("billing-invoice.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            try {
                String resId = request.getParameter("resId");
                String name = request.getParameter("guestName");
                String nic = request.getParameter("nic");
                String address = request.getParameter("address");
                String email = request.getParameter("email");
                String contact = request.getParameter("contact");
                int roomNo = Integer.parseInt(request.getParameter("roomNo"));
                String checkIn = request.getParameter("checkIn");
                String checkOut = request.getParameter("checkOut");

                double svcTotal = Double.parseDouble(request.getParameter("svcTotal") != null ? request.getParameter("svcTotal") : "0");
                double grandTotal = Double.parseDouble(request.getParameter("grandTotal") != null ? request.getParameter("grandTotal") : "0");

                boolean success = dao.addReservation(resId, name, nic, address, email, contact, roomNo, checkIn, checkOut, svcTotal, grandTotal);

                if (success) {
                    response.sendRedirect("DashboardServlet?status=added");
                } else {
                    response.sendRedirect("ReservationServlet?action=new&status=error");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("ReservationServlet?action=new&error=invalid_data");
            }
        }

        else if ("confirmCheckout".equals(action)) {
            try {
                int roomNo = Integer.parseInt(request.getParameter("roomNo"));
                boolean success = dao.finalizeCheckout(roomNo);
                if(success) {
                    response.sendRedirect("DashboardServlet?status=checkedout");
                } else {
                    response.sendRedirect("dashboard.jsp?error=checkout_failed");
                }
            } catch (Exception e) {
                response.sendRedirect("dashboard.jsp?error=invalid_format");
            }
        }
    }
}