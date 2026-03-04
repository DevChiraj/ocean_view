<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View | Manage Staff</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #22d3ee;
            --bg: #0f172a;
            --card: #1e293b;
            --text: #f1f5f9;
        }
        body { background: var(--bg); color: var(--text); font-family: 'Segoe UI', sans-serif; margin: 0; display: flex; }
        .main-content { margin-left: 280px; padding: 40px; width: 100%; }

        /* Form Styling */
        .staff-form {
            background: var(--card); padding: 30px; border-radius: 20px;
            margin-bottom: 40px; border: 1px solid rgba(255,255,255,0.05);
        }
        .form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; }
        input, select {
            background: #0f172a; border: 1px solid #334155; color: white;
            padding: 12px; border-radius: 10px; outline: none;
        }
        .btn-add {
            background: var(--primary); color: #0f172a; border: none;
            padding: 12px 25px; border-radius: 10px; font-weight: bold; cursor: pointer;
            grid-column: span 2; transition: 0.3s;
        }
        .btn-add:hover { background: #06b6d4; transform: scale(1.02); }

        /* Table Styling */
        table {
            width: 100%; border-collapse: collapse; background: var(--card);
            border-radius: 15px; overflow: hidden;
        }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #334155; }
        th { background: rgba(34, 211, 238, 0.1); color: var(--primary); }
        .role-badge {
            background: rgba(34, 211, 238, 0.1); color: var(--primary);
            padding: 4px 10px; border-radius: 6px; font-size: 12px;
        }
        .status-msg { padding: 15px; border-radius: 10px; margin-bottom: 20px; text-align: center; }
        .success { background: rgba(16, 185, 129, 0.2); color: #10b981; }
        .error { background: rgba(239, 68, 68, 0.2); color: #ef4444; }
    </style>
</head>
<body>

    <jsp:include page="slidebar.jsp" />

    <div class="main-content">
        <h2><i class="fa-solid fa-users-gear"></i> Staff Management</h2>

        <%-- Notification Messages --%>
        <% String status = request.getParameter("status");
           if("success".equals(status)) { %>
            <div class="status-msg success">Staff member registered successfully!</div>
        <% } else if("error".equals(status)) { %>
            <div class="status-msg error">Error registering staff. Please try again.</div>
        <% } %>

        <%-- Registration Form --%>
        <div class="staff-form">
            <h3 style="margin-top:0">Add New Staff Member</h3>
            <form action="StaffServlet" method="POST" class="form-grid">
                <input type="text" name="fullName" placeholder="Full Name" required>
                <input type="text" name="username" placeholder="Username" required>
                <input type="password" name="password" placeholder="Password" required>
                <select name="role" required>
                    <option value="" disabled selected>Select Role</option>
                    <option value="Admin">Administrator</option>
                    <option value="Staff">Regular Staff</option>
                </select>
                <button type="submit" class="btn-add">Register Staff Member</button>
            </form>
        </div>

        <%-- Staff List Table --%>
        <table>
            <thead>
                <tr>
                    <th>Full Name</th>
                    <th>Username</th>
                    <th>Role</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Map<String, String>> list = (List<Map<String, String>>) request.getAttribute("staffList");
                    if(list != null && !list.isEmpty()) {
                        for(Map<String, String> user : list) {
                %>
                <tr>
                    <td><%= user.get("fullName") %></td>
                    <td><%= user.get("username") %></td>
                    <td><span class="role-badge"><%= user.get("role") %></span></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="3" style="text-align:center; padding: 30px; color: #94a3b8;">
                        No staff members found. Click 'Refresh' or add a new member.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

</body>
</html>