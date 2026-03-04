<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Session එකෙන් පරිශීලකයාගේ Role එක ලබා ගැනීම
    String userRole = (String) session.getAttribute("role");

    // Dashboard එක තීරණය කිරීම (Admin හෝ Staff අනුව)
    String dashboardLink = "StaffDashboard";
    if ("Admin".equalsIgnoreCase(userRole)) {
        dashboardLink = "DashboardServlet";
    }
%>
<style>
    :root {
        --primary-blue: #38bdf8;
        --sidebar-bg: rgba(15, 23, 42, 0.95);
        --text-gray: #94a3b8;
        --glass-border: rgba(255, 255, 255, 0.1);
    }

    .sidebar {
        width: 280px; background: var(--sidebar-bg); backdrop-filter: blur(30px);
        border-right: 1px solid var(--glass-border); padding: 40px 20px;
        display: flex; flex-direction: column; position: fixed;
        height: 100vh; z-index: 1000; top: 0; left: 0;
    }

    .brand {
        font-size: 22px; font-weight: 800; color: var(--primary-blue);
        margin-bottom: 40px; display: flex; align-items: center; gap: 12px;
    }

    .nav-menu { list-style: none; padding: 0; margin: 0; flex-grow: 1; overflow-y: auto; }

    .nav-link {
        text-decoration: none; color: var(--text-gray); padding: 12px 18px;
        border-radius: 14px; display: flex; align-items: center; gap: 12px;
        transition: 0.3s; margin-bottom: 5px; font-size: 14px;
    }

    .nav-link:hover, .nav-link.active {
        background: rgba(56, 189, 248, 0.1); color: var(--primary-blue); transform: translateX(5px);
    }

    .nav-section-label {
        font-size: 10px; font-weight: 800; color: #475569;
        letter-spacing: 1.5px; text-transform: uppercase; margin: 20px 0 10px 18px;
    }

    /* Logout Section Styling */
    .logout-container { margin-top: auto; padding-top: 20px; border-top: 1px solid rgba(251, 113, 133, 0.1); }
    .logout-btn { color: #fb7185 !important; }
    .logout-btn:hover { background: rgba(251, 113, 133, 0.1) !important; color: #f43f5e !important; }
</style>

<aside class="sidebar">
    <div class="brand">
        <i class="fa-solid fa-water"></i> OCEAN VIEW
    </div>

    <div class="nav-menu">
        <div class="nav-section-label">Main View</div>
        <a href="<%= dashboardLink %>" class="nav-link"><i class="fa-solid fa-house"></i> Dashboard</a>

<a href="RoomMap" class="nav-link">
    <i class="fa-solid fa-bed"></i> Rooms Map
</a>
       <div class="nav-section-label">Guest Management</div>
       <a href="ReservationServlet?action=list" class="nav-link"><i class="fa-solid fa-list-ul"></i> All Guests</a>
       <a href="ReservationServlet?action=new" class="nav-link"><i class="fa-solid fa-plus"></i> New Booking</a>

        <a href="view-reservation.jsp" class="nav-link">
            <i class="fa-solid fa-magnifying-glass"></i> Find Guest (View)
        </a>

        <%-- වැදගත්: Admin සඳහා පමණක් පෙනෙන Administration කොටස --%>
        <% if ("Admin".equalsIgnoreCase(userRole)) { %>
            <div class="nav-section-label">Administration</div>
            <a href="manage-staff.jsp" class="nav-link"><i class="fa-solid fa-user-group"></i> Team Settings</a>
            <a href="ReportServlet" class="nav-link"><i class="fa-solid fa-file-invoice-dollar"></i> Money Reports</a>
        <% } %>

        <div class="nav-section-label">Support</div>
        <a href="settings.jsp" class="nav-link"><i class="fa-solid fa-user-gear"></i> Profile</a>
        <a href="help.jsp" class="nav-link"><i class="fa-solid fa-circle-question"></i> Help Guide</a>
    </div>

    <div class="logout-container">
        <a href="LogoutServlet" class="nav-link logout-btn">
            <i class="fa-solid fa-power-off"></i> Exit System
        </a>
    </div>

    <div class="logout-section" style="margin-top: auto; padding: 20px;">
        <a href="LogoutServlet" style="color: #ef4444; text-decoration: none; display: flex; align-items: center; gap: 10px; font-weight: bold;">
            <i class="fa-solid fa-right-from-bracket"></i> Exit System
        </a>
    </div>
</aside>