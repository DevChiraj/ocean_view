<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View | System Documentation & Help</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #22d3ee;
            --bg: #0f172a;
            --card: #1e293b;
            --text-main: #f1f5f9;
            --text-dim: #94a3b8;
            --accent: #38bdf8;
            --success: #10b981;
            --warning: #f59e0b;
        }

        body {
            background: var(--bg);
            color: var(--text-main);
            font-family: 'Segoe UI', system-ui, sans-serif;
            margin: 0;
            display: flex;
            line-height: 1.6;
        }

        .main-content {
            margin-left: 280px;
            padding: 40px;
            width: 100%;
        }

        .hero-banner {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            padding: 50px;
            border-radius: 24px;
            border-left: 6px solid var(--primary);
            margin-bottom: 40px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        .hero-banner h1 { margin: 0; font-size: 36px; color: var(--primary); }
        .hero-banner p { color: var(--text-dim); font-size: 18px; margin-top: 15px; max-width: 800px; }

        .doc-section {
            background: var(--card);
            padding: 35px;
            border-radius: 24px;
            margin-bottom: 35px;
            border: 1px solid rgba(255,255,255,0.05);
        }

        .doc-section h2 {
            color: var(--accent);
            border-bottom: 2px solid rgba(56, 189, 248, 0.2);
            padding-bottom: 15px;
            margin-top: 0;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 24px;
        }

        .role-badge {
            font-size: 11px;
            padding: 5px 14px;
            border-radius: 20px;
            text-transform: uppercase;
            font-weight: bold;
            letter-spacing: 1px;
        }
        .admin-badge { background: rgba(239, 68, 68, 0.2); color: #f87171; }
        .staff-badge { background: rgba(34, 211, 238, 0.2); color: var(--primary); }

        .instruction-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .instruction-item {
            background: rgba(15, 23, 42, 0.4);
            padding: 25px;
            border-radius: 16px;
            border-top: 4px solid var(--accent);
        }

        .instruction-item h4 { color: var(--primary); margin-top: 0; margin-bottom: 10px; font-size: 18px; }
        .instruction-item p { color: var(--text-dim); font-size: 14px; margin: 0; }

        .important-note {
            background: rgba(245, 158, 11, 0.1);
            color: #fbbf24;
            padding: 20px;
            border-radius: 15px;
            border: 1px dashed #fbbf24;
            margin-top: 30px;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .summary-box {
            margin-top: 40px;
            padding: 30px;
            background: rgba(34, 211, 238, 0.05);
            border-radius: 20px;
        }

        .step-tag {
            display: inline-block;
            background: var(--primary);
            color: var(--bg);
            padding: 2px 10px;
            border-radius: 5px;
            font-size: 12px;
            font-weight: bold;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

    <jsp:include page="slidebar.jsp" />

    <div class="main-content">
        <div class="hero-banner">
            <h1><i class="fa-solid fa-circle-info"></i> System Help & Documentation</h1>
            <p>Comprehensive operational manual for the Ocean View Resort Management System. This guide provides step-by-step instructions for all user roles defined in the system requirements.</p>
        </div>

        <div class="doc-section">
            <h2><i class="fa-solid fa-user-gear"></i> Administrative Operations <span class="role-badge admin-badge">Admin Access</span></h2>
            <p>Administrators have full authority over the system backend, user management, and financial oversight.</p>

            <div class="instruction-grid">
                <div class="instruction-item">
                    <span class="step-tag">Phase 01</span>
                    <h4>User Management</h4>
                    <p>Register new staff members, assign roles (Admin/Staff), and manage secure login credentials within the 'User Management' panel.</p>
                </div>
                <div class="instruction-item">
                    <span class="step-tag">Phase 02</span>
                    <h4>Financial Oversight</h4>
                    <p>Monitor real-time revenue stats. The system aggregates 'Grand Total' values from all completed reservations to provide income insights.</p>
                </div>
                <div class="instruction-item">
                    <span class="step-tag">Phase 03</span>
                    <h4>Database Integrity</h4>
                    <p>The system utilizes a <b>Singleton Design Pattern</b> for database connections, ensuring high performance and data consistency.</p>
                </div>
            </div>
        </div>

        <div class="doc-section">
            <h2><i class="fa-solid fa-hotel"></i> Staff Operations <span class="role-badge staff-badge">Staff Access</span></h2>
            <p>Staff members are responsible for the daily workflow, guest management, and billing cycle.</p>

            <div class="instruction-grid">
                <div class="instruction-item">
                    <span class="step-tag">Task A</span>
                    <h4>Guest Registration</h4>
                    <p>Navigate to 'Add Reservation'. Collect Guest Name, Address, Contact, and Stay Dates. Ensure a unique Reservation ID is assigned.</p>
                </div>
                <div class="instruction-item">
                    <span class="step-tag">Task B</span>
                    <h4>Room Allocation</h4>
                    <p>Select available rooms from the list. The system automatically updates room status to 'Occupied' upon successful booking.</p>
                </div>
                <div class="instruction-item">
                    <span class="step-tag">Task C</span>
                    <h4>Billing & Checkout</h4>
                    <p>Locate the guest in the 'All Guests' table. Click 'Generate Bill'. The system calculates cost based on: <b>(Price per Night x Total Nights)</b>.</p>
                </div>
            </div>
        </div>

        <div class="doc-section">
            <h2><i class="fa-solid fa-code"></i> System Technical Overview</h2>
            <div class="summary-box">
                <p>This reservation system is built using the <b>Java EE (Jakarta EE)</b> framework. It follows the <b>Model-View-Controller (MVC)</b> architecture to separate data handling (DAO), logic (Servlet), and presentation (JSP).</p>
                <p><b>Key Security Features:</b>
                    <br>• Role-based access control (Admin vs Staff)
                    <br>• Session management for secure login/logout
                    <br>• Singleton Pattern for optimized SQL connectivity
                </p>
            </div>
        </div>

        <div class="important-note">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <div>
                <strong>Security Compliance:</strong>
                Always ensure you use the <b>Exit System (Logout)</b> button before closing your browser. This clears the active session and prevents unauthorized access to guest records.
            </div>
        </div>
    </div>

</body>
</html>