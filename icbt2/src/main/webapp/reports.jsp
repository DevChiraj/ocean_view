<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // ආරක්ෂාව සඳහා ඇඩ්මින් ද යන්න පරීක්ෂා කිරීම
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("Admin")) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    // දත්ත ලබා ගැනීම සහ Null Check කිරීම
    Map<String, Object> stats = (Map<String, Object>) request.getAttribute("stats");
    Map<String, Double> revData = (Map<String, Double>) request.getAttribute("revenueMap");

    double revenue = (stats != null && stats.get("revenue") != null) ? (Double) stats.get("revenue") : 0.0;
    int occupied = (stats != null && stats.get("occupied") != null) ? (Integer) stats.get("occupied") : 0;
    int arrivals = (stats != null && stats.get("arrivals") != null) ? (Integer) stats.get("arrivals") : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Executive Analytics | Ocean View Resort</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        :root { --primary: #38bdf8; --bg: #020617; --card: #1e293b; --text: #f1f5f9; --accent: #10b981; }
        body { background: var(--bg); color: var(--text); font-family: 'Plus Jakarta Sans', sans-serif; display: flex; margin: 0; }
        .main-content { margin-left: 280px; padding: 40px; width: calc(100% - 280px); }

        /* Real World Layout Grid */
        .analytics-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 25px; margin-top: 30px; }

        /* Stats Cards with Percentages */
        .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .stat-card { background: var(--card); padding: 25px; border-radius: 20px; border: 1px solid rgba(255,255,255,0.05); }
        .trend-up { color: var(--accent); font-size: 12px; font-weight: bold; }

        /* Professional Calculator */
        .calc-box { background: #0f172a; padding: 25px; border-radius: 20px; border: 1px solid var(--primary); height: fit-content; }
        .calc-screen { width: 100%; background: #1e293b; border: none; padding: 15px; color: var(--primary); text-align: right; font-size: 20px; border-radius: 10px; margin-bottom: 15px; }
        .calc-btns { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; }
        .calc-btns button { padding: 12px; border: none; border-radius: 8px; background: #334155; color: white; cursor: pointer; transition: 0.2s; }
        .calc-btns button:hover { background: var(--primary); color: #020617; }

        .chart-box { background: var(--card); padding: 25px; border-radius: 20px; border: 1px solid rgba(255,255,255,0.05); }
        @media print { .sidebar, .btn-print, .calc-box { display: none !important; } .main-content { margin-left: 0; width: 100%; } }
    </style>
</head>
<body>
    <jsp:include page="slidebar.jsp" />

    <div class="main-content">
        <div class="report-header" style="display:flex; justify-content: space-between; align-items: center;">
            <div>
                <h1 style="margin:0; font-weight:800; color:var(--primary);">Financial Intelligence</h1>
                <p style="color: #94a3b8;">Real-time revenue tracking and forecasting.</p>
            </div>
            <button class="btn-print" onclick="window.print()" style="background:var(--primary); padding:12px 20px; border-radius:12px; border:none; font-weight:bold; cursor:pointer;">
                <i class="fa-solid fa-file-pdf"></i> EXPORT REPORT
            </button>
        </div>

        <div class="stats-grid" style="margin-top: 30px;">
            <div class="stat-card">
                <p style="color:#94a3b8; margin:0; font-size:12px;">NET REVENUE</p>
                <h2 style="margin:10px 0;">LKR <%= String.format("%,.2f", revenue) %></h2>
                <span class="trend-up"><i class="fa-solid fa-arrow-up"></i> 14.2% vs last month</span>
            </div>
            <div class="stat-card">
                <p style="color:#94a3b8; margin:0; font-size:12px;">ROOM OCCUPANCY</p>
                <h2 style="margin:10px 0;"><%= occupied %> Units</h2>
                <span class="trend-up"><i class="fa-solid fa-arrow-up"></i> 5.8% increase</span>
            </div>
            <div class="stat-card" style="border-bottom: 4px solid var(--accent);">
                <p style="color:#94a3b8; margin:0; font-size:12px;">SYSTEM HEALTH</p>
                <h2 style="margin:10px 0; color:var(--accent);">OPTIMAL</h2>
                <span style="color:#94a3b8; font-size:12px;">All services operational</span>
            </div>
        </div>

        <div class="analytics-grid">
            <div class="chart-box">
                <h3 style="margin-top:0;"><i class="fa-solid fa-chart-line"></i> Revenue Projection</h3>
                <canvas id="revenueChart" height="150"></canvas>
            </div>

            <div class="calc-box">
                <h3 style="margin-top:0; color:var(--primary);"><i class="fa-solid fa-calculator"></i> Quick Calc</h3>
                <input type="text" id="screen" class="calc-screen" readonly value="0">
                <div class="calc-btns">
                    <button onclick="clearScreen()">C</button><button onclick="press('/')">/</button><button onclick="press('*')">*</button><button onclick="backspace()">DEL</button>
                    <button onclick="press('7')">7</button><button onclick="press('8')">8</button><button onclick="press('9')">9</button><button onclick="press('-')">-</button>
                    <button onclick="press('4')">4</button><button onclick="press('5')">5</button><button onclick="press('6')">6</button><button onclick="press('+')">+</button>
                    <button onclick="press('1')">1</button><button onclick="press('2')">2</button><button onclick="press('3')">3</button><button onclick="calculate()" style="grid-row: span 2; background: var(--primary); color:#020617;">=</button>
                    <button onclick="press('0')" style="grid-column: span 2;">0</button><button onclick="press('.')">.</button>
                </div>
            </div>
        </div>
    </div>



    <script>
        // Graph Logic
        const ctx = document.getElementById('revenueChart').getContext('2d');
        <%
            List<String> months = new ArrayList<>();
            List<Double> vals = new ArrayList<>();
            if (revData != null) { months.addAll(revData.keySet()); vals.addAll(revData.values()); }
        %>
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: <%= months.toString().replace("[", "['").replace("]", "']").replace(", ", "','") %>,
                datasets: [{
                    label: 'Gross Revenue',
                    data: <%= vals.toString() %>,
                    borderColor: '#38bdf8',
                    backgroundColor: 'rgba(56, 189, 248, 0.2)',
                    fill: true, tension: 0.4, borderWidth: 3
                }]
            },
            options: { plugins: { legend: { labels: { color: '#94a3b8' } } }, scales: { y: { grid: { color: 'rgba(255,255,255,0.05)' }, ticks: { color: '#94a3b8' } }, x: { ticks: { color: '#94a3b8' } } } }
        });

        // Calculator Logic
        let screen = document.getElementById('screen');
        function press(v) { if(screen.value == '0') screen.value = v; else screen.value += v; }
        function clearScreen() { screen.value = '0'; }
        function calculate() { try { screen.value = eval(screen.value); } catch(e) { screen.value = 'Error'; } }
        function backspace() { screen.value = screen.value.slice(0, -1); if(screen.value == '') screen.value = '0'; }
    </script>
</body>
</html>