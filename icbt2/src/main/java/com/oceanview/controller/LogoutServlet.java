package com.oceanview.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. දැනට පවතින සෙෂන් එක ලබාගෙන එය අවලංගු කරන්න
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // 2. පරිශීලකයා නැවත ලොගින් පේජ් එකට යොමු කරන්න
        response.sendRedirect("login.jsp?msg=LoggedOut");
    }
}