<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View | Guest Directory</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        :root {
            --primary: #38bdf8; --bg-dark: #020617; --glass: rgba(255, 255, 255, 0.03);
            --glass-border: rgba(255, 255, 255, 0.08); --text-dim: #94a3b8;
        }
        body {
            margin: 0; font-family: 'Plus Jakarta Sans', sans-serif; background: var(--bg-dark);
            background-image: radial-gradient(at 0% 0%, hsla(217,100%,15%,1) 0, transparent 50%);
            color: white; display: flex;
        }
        .content { margin-left: 280px; padding: 60px; width: 100%; }
        .glass-panel {
            background: var(--glass); border: 1px solid var(--glass-border);
            border-radius: 30px; padding: 40px; backdrop-filter: blur(20px);
        }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { text-align: left; color: var(--text-dim); font-size: 12px; text-transform: uppercase; padding: 15px; border-bottom: 1px solid var(--glass-border); }
        td { padding: 20px 15px; border-bottom: 1px solid rgba(255,255,255,0.02); font-size: 14px; }
        .action-btn {
            padding: 8px 15px; border-radius: 10px; text-decoration: none;
            font-size: 12px; font-weight: 700; transition: 0.3s;
        }
        .btn-view { background: rgba(56, 189, 248, 0.1); color: var(--primary); border: 1px solid var(--primary); }
        .btn-bill { background: rgba(16, 185, 129, 0.1); color: #10b981; border: 1px solid #10b981; margin-left: 5px; }
        .action-btn:hover { opacity: 0.8; transform: translateY(-2px); }
    </style>
</head>
<body>

    <%@ include file="slidebar.jsp" %>

    <div class="content">
        <header style="margin-bottom: 40px;">
            <h1 style="font-size: 36px; font-weight: 800; margin: 0;">Guest Directory</h1>
            <p style="color: var(--text-dim);">Manage and monitor all active resort reservations.</p>
        </header>

        <div class="glass-panel">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Guest Name</th>
                        <th>Room</th>
                        <th>Stay Period</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Map<String, String>> guests = (List<Map<String, String>>) request.getAttribute("guestList");
                        if(guests != null) {
                            for(Map<String, String> g : guests) {
                    %>
                        <tr>
                            <td style="color: var(--primary); font-weight: 700;"><%= g.get("res_id") %></td>
                            <td>
                                <b><%= g.get("guest_name") %></b><br>
                                <small style="color: var(--text-dim);"><%= g.get("email") %></small>
                            </td>
                            <td>
                                Room <%= g.get("room_no") %><br>
                                <small style="color: var(--primary);"><%= g.get("room_type") %></small>
                            </td>
                            <td>
                                <i class="fa-regular fa-calendar-check"></i> <%= g.get("check_in") %><br>
                                <i class="fa-regular fa-calendar-xmark"></i> <%= g.get("check_out") %>
                            </td>
                            <td>
                                <a href="ReservationServlet?action=search&searchTerm=<%= g.get("res_id") %>" class="action-btn btn-view">Edit</a>
                                <a href="ReservationServlet?action=checkout&resId=<%= g.get("res_id") %>" class="action-btn btn-bill">Bill</a>
                            </td>
                        </tr>
                    <%      }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>