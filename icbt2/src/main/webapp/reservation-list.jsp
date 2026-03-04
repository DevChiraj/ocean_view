<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Guest Analytics | Ocean View Resort</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        :root {
            --primary: #38bdf8; --bg: #020617; --card: #0f172a;
            --glass: rgba(255, 255, 255, 0.03); --glass-border: rgba(255, 255, 255, 0.08);
            --text-dim: #94a3b8; --accent: #10b981;
        }

        body {
            background: var(--bg); color: #f1f5f9; font-family: 'Plus Jakarta Sans', sans-serif;
            margin: 0; display: flex; min-height: 100vh;
        }

        .main-content { margin-left: 280px; padding: 50px; width: 100%; }

        .header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
        .header-section h2 { font-size: 32px; font-weight: 800; margin: 0; background: linear-gradient(to right, #fff, #94a3b8); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }

        .table-wrapper {
            background: var(--glass); backdrop-filter: blur(12px); border: 1px solid var(--glass-border);
            border-radius: 30px; padding: 10px; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
        }

        table { width: 100%; border-collapse: separate; border-spacing: 0 8px; }
        th { padding: 20px; text-align: left; color: var(--text-dim); font-size: 12px; text-transform: uppercase; letter-spacing: 1px; font-weight: 700; }
        td { padding: 20px; background: rgba(255,255,255,0.02); transition: 0.3s; }

        tr td:first-child { border-radius: 20px 0 0 20px; }
        tr td:last-child { border-radius: 0 20px 20px 0; }
        tr:hover td { background: rgba(56, 189, 248, 0.08); transform: scale(1.002); }

        .guest-info b { display: block; font-size: 15px; color: #fff; }
        .guest-info span { font-size: 12px; color: var(--text-dim); }

        .room-badge { background: rgba(56, 189, 248, 0.1); color: var(--primary); padding: 6px 14px; border-radius: 12px; font-weight: 800; font-size: 12px; border: 1px solid rgba(56, 189, 248, 0.2); }

        .btn-invoice {
            background: var(--primary); color: #020617; padding: 12px 24px;
            text-decoration: none; border-radius: 14px; font-weight: 800; font-size: 13px;
            display: inline-flex; align-items: center; gap: 8px; transition: 0.3s;
        }
        .btn-invoice:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(56, 189, 248, 0.3); }

        .empty-state { padding: 100px; text-align: center; color: var(--text-dim); }
    </style>
</head>
<body>

    <jsp:include page="slidebar.jsp" />

    <div class="main-content">
        <div class="header-section">
            <div>
                <h2>Guest Registry</h2>
                <p style="color: var(--text-dim); margin-top: 5px;">Manage active reservations and financial documents.</p>
            </div>
        </div>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Reservation ID</th>
                        <th>Guest</th>
                        <th>Room</th>
                        <th>Check-In / Out</th>
                        <th>Total Amount</th>
                        <th>Billing</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<Map<String, String>> list = (List<Map<String, String>>) request.getAttribute("reservationList");
                        if(list != null && !list.isEmpty()) {
                            for(Map<String, String> res : list) {
                    %>
                    <tr>
                        <td><b style="color: var(--primary); font-family: monospace; font-size: 16px;"><%= res.get("res_id") %></b></td>
                        <td class="guest-info">
                            <b><%= res.get("guest_name") %></b>
                            <span>Contact: <%= res.get("contact") %></span>
                        </td>
                        <td><span class="room-badge">ROOM <%= res.get("room_no") %></span></td>
                        <td>
                            <div style="font-size: 13px; font-weight: 600;"><%= res.get("check_in") %></div>
                            <div style="font-size: 11px; color: var(--text-dim);">to <%= res.get("check_out") %></div>
                        </td>
                        <td><b style="color: var(--accent);">LKR <%= String.format("%,.2f", Double.parseDouble(res.get("grand_total"))) %></b></td>
                        <td>
                            <%-- ඔයා ඉල්ලපු විදිහට billing-invoice.jsp එකට යොමු කරන ලින්ක් එක --%>
                            <a href="ReservationServlet?action=checkout&resId=<%= res.get("res_id") %>" class="btn-invoice">
                                <i class="fa-solid fa-file-invoice-dollar"></i> INVOICE
                            </a>
                        </td>
                    </tr>
                    <%      }
                        } else { %>
                    <tr><td colspan="6" class="empty-state">
                        <i class="fa-solid fa-folder-open" style="font-size: 48px; margin-bottom: 20px; display: block;"></i>
                        No active reservations found.
                    </td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>