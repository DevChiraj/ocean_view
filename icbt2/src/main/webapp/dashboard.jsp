<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    List<Map<String, String>> recentGuests = (List<Map<String, String>>) request.getAttribute("recentGuests");

    if (stats == null) {
        stats = new HashMap<>();
        stats.put("occupied", 0); stats.put("available", 0);
        stats.put("arrivals", 0); stats.put("revenue", 0.0);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View | Command Center</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root { --primary: #38bdf8; --bg: #020617; --glass: rgba(255, 255, 255, 0.03); --border: rgba(255, 255, 255, 0.08); --text-dim: #94a3b8; }
        body { margin: 0; font-family: 'Plus Jakarta Sans', sans-serif; background: var(--bg); color: white; display: flex; min-height: 100vh; overflow-x: hidden; }
        .main-wrapper { margin-left: 280px; padding: 40px 60px; width: calc(100% - 280px); }
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 40px; }
        .stat-card { background: var(--glass); border: 1px solid var(--border); padding: 25px; border-radius: 26px; backdrop-filter: blur(10px); }
        .stat-card span { color: var(--text-dim); font-size: 11px; text-transform: uppercase; letter-spacing: 1px; font-weight: 700; }
        .stat-card b { font-size: 28px; display: block; margin-top: 8px; font-weight: 800; }
        .dashboard-grid { display: grid; grid-template-columns: 1.8fr 1.2fr; gap: 35px; }
        .glass-panel { background: var(--glass); border: 1px solid var(--border); border-radius: 28px; padding: 30px; margin-bottom: 30px; }
        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; color: var(--text-dim); font-size: 12px; padding-bottom: 18px; text-transform: uppercase; }
        td { padding: 18px 0; border-top: 1px solid var(--border); font-size: 14px; }
        .dir-btn { background: var(--glass); border: 1px solid var(--border); padding: 22px; border-radius: 20px; text-align: center; text-decoration: none; color: white; display: block; margin-bottom: 15px; font-weight: 700; transition: 0.3s; }
        .dir-btn:hover { border-color: var(--primary); background: rgba(56, 189, 248, 0.05); }
    </style>
</head>
<body>
    <jsp:include page="slidebar.jsp" />
    <main class="main-wrapper">
        <header style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 50px;">
            <div><h1 style="margin: 0; font-size: 34px; font-weight: 800;">Executive Hub</h1><p style="color: var(--text-dim);">Real-time asset and revenue monitoring.</p></div>
        </header>

        <div class="stats-grid">
            <div class="stat-card"><span>Gross Revenue</span><b style="color: #10b981;">LKR <%= stats.get("revenue") %></b></div>
            <div class="stat-card"><span>Arrivals Today</span><b><%= stats.get("arrivals") %></b></div>
            <div class="stat-card"><span>Vacant Units</span><b style="color: #f59e0b;"><%= stats.get("available") %> Rooms</b></div>
            <div class="stat-card"><span>Occupied Units</span><b style="color: #38bdf8;"><%= stats.get("occupied") %> Rooms</b></div>
        </div>

        <div class="dashboard-grid">
            <div class="ops-column">
                <div class="glass-panel">
                    <table>
                        <thead><tr><th>Entity ID</th><th>Guest Name</th><th>Category</th><th>Status</th></tr></thead>
                        <tbody>
                            <% if (recentGuests != null && !recentGuests.isEmpty()) {
                                for (Map<String, String> guest : recentGuests) { %>
                                <tr>
                                    <td style="color: #38bdf8; font-weight: 700;"><%= guest.get("res_id") %></td>
                                    <td><%= guest.get("guest_name") %></td>
                                    <td><%= guest.get("room_type") %></td>
                                    <td><span style="color: #10b981; font-weight: 800; font-size: 11px;">ACTIVE</span></td>
                                </tr>
                            <% } } else { %>
                                <tr><td colspan="4" style="text-align: center; color: var(--text-dim); padding: 20px;">No records found.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
                <h3>Operational Directives</h3>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <a href="add-reservation.jsp" class="dir-btn"><i class="fa-solid fa-plus-circle"></i><br>New Booking</a>
                    <a href="RoomMap" class="dir-btn"><i class="fa-solid fa-bed"></i><br>Room Map</a>
                    <a href="ReservationServlet?action=list" class="dir-btn"><i class="fa-solid fa-users"></i><br>All Guests</a>
                    <a href="ReportServlet" class="dir-btn"><i class="fa-solid fa-file-pdf"></i><br>Reports</a>
                </div>
            </div>
            <div class="analytics-column">
                <div class="glass-panel" style="display: flex; justify-content: center;">
                    <canvas id="marketGraph" height="250"></canvas>
                </div>
            </div>
        </div>
    </main>

    <script>
        new Chart(document.getElementById('marketGraph').getContext('2d'), {
            type: 'doughnut',
            data: {
                labels: ['Occupied', 'Available'],
                datasets: [{
                    data: [<%= stats.get("occupied") %>, <%= stats.get("available") %>],
                    backgroundColor: ['#38bdf8', 'rgba(255, 255, 255, 0.05)'],
                    borderWidth: 0
                }]
            },
            options: { plugins: { legend: { position: 'bottom', labels: { color: '#94a3b8' } } }, cutout: '80%' }
        });
    </script>
</body>
</html>