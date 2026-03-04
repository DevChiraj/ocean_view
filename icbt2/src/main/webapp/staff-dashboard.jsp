<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View | Staff Hub</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        :root { --primary: #38bdf8; --bg: #020617; --glass: rgba(255, 255, 255, 0.03); --border: rgba(255, 255, 255, 0.1); }
        body { margin: 0; font-family: 'Plus Jakarta Sans', sans-serif; background: var(--bg); color: white; display: flex; min-height: 100vh; }
        .main-content { margin-left: 280px; padding: 50px; width: calc(100% - 280px); }
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 40px; }
        .stat-card { background: var(--glass); border: 1px solid var(--border); padding: 25px; border-radius: 24px; backdrop-filter: blur(10px); }
        .stat-card i { font-size: 24px; color: var(--primary); margin-bottom: 15px; display: block; }
        .stat-val { font-size: 28px; font-weight: 800; display: block; }
        .action-row { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 40px; }
        .action-btn {
            padding: 25px; background: rgba(56, 189, 248, 0.05); border: 1px dashed var(--primary);
            border-radius: 20px; text-align: center; cursor: pointer; transition: 0.3s; text-decoration: none; color: var(--primary);
        }
        .action-btn:hover { background: var(--primary); color: #000; transform: translateY(-5px); }
        .glass-panel { background: var(--glass); border: 1px solid var(--border); border-radius: 30px; padding: 30px; }
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; color: #94a3b8; padding: 15px; font-size: 11px; text-transform: uppercase; }
        td { padding: 15px; border-bottom: 1px solid rgba(255,255,255,0.05); font-size: 14px; }
    </style>
</head>
<body>

    <jsp:include page="slidebar.jsp" />

    <div class="main-content">
        <header style="margin-bottom: 40px;">
            <h1 style="font-size: 32px; font-weight: 800; margin: 0;">Operations Dashboard</h1>
            <p style="color: #94a3b8;">Logged in as: <b style="color: var(--primary);"><%= session.getAttribute("username") %></b></p>
        </header>

        <%
            Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
            if (stats == null) {
                stats = new HashMap<>(); // Null safety
                stats.put("available", 0); stats.put("arrivals", 0); stats.put("occupied", 0); stats.put("revenue", 0.0);
            }
        %>

        <div class="stats-grid">
            <div class="stat-card">
                <i class="fa-solid fa-door-open"></i>
                <span class="stat-val"><%= stats.get("available") %></span>
                <small style="color: #94a3b8;">Available Rooms</small>
            </div>
            <div class="stat-card">
                <i class="fa-solid fa-user-check"></i>
                <span class="stat-val"><%= stats.get("arrivals") %></span>
                <small style="color: #94a3b8;">Today's Arrivals</small>
            </div>
            <div class="stat-card">
                <i class="fa-solid fa-bed"></i>
                <span class="stat-val"><%= stats.get("occupied") %></span>
                <small style="color: #94a3b8;">Occupied Rooms</small>
            </div>
            <div class="stat-card">
                <i class="fa-solid fa-hand-sparkles"></i>
                <span class="stat-val">04</span>
                <small style="color: #94a3b8;">Service Pending</small>
            </div>
        </div>

        <h3 style="margin-bottom: 20px;">Quick Access</h3>
        <div class="action-row">
            <a href="add-reservation.jsp" class="action-btn">
                <i class="fa-solid fa-plus-circle"></i><br><b style="font-size: 14px;">New Check-in</b>
            </a>
            <a href="ReservationServlet?action=list" class="action-btn">
                <i class="fa-solid fa-address-book"></i><br><b style="font-size: 14px;">Guest Directory</b>
            </a>
            <a href="RoomMap" class="action-btn">
                <i class="fa-solid fa-layer-group"></i><br><b style="font-size: 14px;">Live Room Map</b>
            </a>
        </div>

        <div class="glass-panel">
            <h3 style="margin-top: 0; margin-bottom: 20px;">Recent Activity</h3>
            <table>
                <thead>
                    <tr><th>ID</th><th>Guest</th><th>Room Type</th><th>Status</th></tr>
                </thead>
                <tbody>
                    <%
                        List<Map<String, String>> recent = (List<Map<String, String>>) request.getAttribute("recentBookings");
                        if(recent != null && !recent.isEmpty()) {
                            for(Map<String, String> r : recent) {
                    %>
                    <tr>
                        <td style="color: var(--primary); font-weight: 700;"><%= r.get("res_id") %></td>
                        <td><%= r.get("guest_name") %></td>
                        <td><%= r.get("room_type") %></td>
                        <td><span style="background: rgba(16, 185, 129, 0.15); color: #10b981; padding: 4px 10px; border-radius: 8px; font-size: 11px; font-weight: 700;">ACTIVE</span></td>
                    </tr>
                    <%      }
                        } else {
                    %>
                    <tr><td colspan="4" style="text-align: center; color: #94a3b8;">No recent bookings found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>