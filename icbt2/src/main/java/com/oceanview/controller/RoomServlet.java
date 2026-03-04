package com.oceanview.controller;

import com.oceanview.dao.RoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/RoomMap")
public class RoomServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        RoomDAO dao = new RoomDAO();
        List<Map<String, String>> roomList = dao.getAllRooms();
        request.setAttribute("rooms", roomList);
        request.getRequestDispatcher("room-map.jsp").forward(request, response);
    }
}