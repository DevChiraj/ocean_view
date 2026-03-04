<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View | Staff Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #38bdf8;
            --primary-glow: rgba(56, 189, 248, 0.4);
            --bg-dark: #020617;
            --glass: rgba(255, 255, 255, 0.03);
            --glass-border: rgba(255, 255, 255, 0.08);
            --text-dim: #94a3b8;
        }

        body {
            margin: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: var(--bg-dark);
            /* Ultra-modern animated mesh background */
            background-image:
                radial-gradient(at 0% 0%, hsla(217,100%,15%,1) 0, transparent 50%),
                radial-gradient(at 100% 100%, hsla(190,100%,10%,1) 0, transparent 50%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            overflow: hidden;
            color: white;
        }

        /* Top System Header */
        .system-header {
            font-size: 13px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 7px;
            color: var(--primary);
            margin-bottom: 30px;
            text-align: center;
            opacity: 0.9;
        }

        .main-auth-card {
            display: flex;
            width: 1000px;
            height: 620px;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(30px);
            border-radius: 40px;
            border: 1px solid var(--glass-border);
            box-shadow: 0 50px 100px -20px rgba(0,0,0,0.7);
            overflow: hidden;
            animation: fadeIn 1s cubic-bezier(0.4, 0, 0.2, 1);
        }

        @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

        /* Left Panel with Animated Circle */
        .brand-panel {
            width: 45%;
            background: linear-gradient(135deg, rgba(30, 64, 175, 0.4) 0%, rgba(15, 23, 42, 0.8) 100%);
            padding: 60px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            position: relative;
            border-right: 1px solid var(--glass-border);
        }

        .circle-animation {
            position: absolute;
            width: 300px;
            height: 300px;
            border: 1px solid var(--primary);
            border-radius: 50%;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            opacity: 0.1;
            border-style: dashed;
            animation: rotate 20s linear infinite;
        }

        @keyframes rotate { from { transform: translate(-50%, -50%) rotate(0deg); } to { transform: translate(-50%, -50%) rotate(360deg); } }

        .brand-panel h1 { font-size: 44px; font-weight: 800; margin: 0; letter-spacing: -2px; color: white; position: relative; z-index: 2; }
        .brand-panel p { color: var(--text-dim); line-height: 1.7; margin-top: 20px; font-size: 15px; position: relative; z-index: 2; }

        .security-list { margin-top: 40px; list-style: none; padding: 0; position: relative; z-index: 2; }
        .security-item { margin-bottom: 18px; font-size: 13px; color: var(--text-dim); font-weight: 500; letter-spacing: 0.5px; }

        /* Login Form Panel */
        .login-panel { width: 55%; padding: 60px; display: flex; flex-direction: column; justify-content: center; }
        .login-panel h2 { font-size: 32px; font-weight: 700; margin-bottom: 10px; color: white; }
        .login-panel p.sub { color: var(--text-dim); margin-bottom: 35px; font-size: 14px; }

        /* Role Selection at Top */
        .role-section { margin-bottom: 30px; }
        .role-label { display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 2px; color: var(--text-dim); margin-bottom: 12px; }
        .role-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .role-box input { position: absolute; opacity: 0; }
        .role-box label {
            display: block; text-align: center; padding: 15px; background: var(--glass); border: 1px solid var(--glass-border);
            border-radius: 20px; cursor: pointer; transition: 0.3s; font-weight: 700; font-size: 13px; color: var(--text-dim);
        }
        .role-box input:checked + label { border-color: var(--primary); background: rgba(56, 189, 248, 0.1); color: var(--primary); box-shadow: 0 0 20px var(--primary-glow); }

        .form-group { margin-bottom: 22px; }
        .form-group label { display: block; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 2px; color: var(--text-dim); margin-bottom: 10px; }

        /* Input without Icons */
        input[type="text"], input[type="password"] {
            width: 100%; padding: 18px 25px; background: rgba(0,0,0,0.3); border: 1px solid var(--glass-border);
            border-radius: 20px; color: white; font-size: 15px; transition: 0.3s; box-sizing: border-box;
        }
        input:focus { border-color: var(--primary); outline: none; background: rgba(255,255,255,0.05); box-shadow: 0 0 25px rgba(56, 189, 248, 0.2); }

        .btn-login {
            width: 100%; padding: 20px; background: var(--primary); color: var(--bg-dark); border: none;
            border-radius: 22px; font-size: 15px; font-weight: 800; cursor: pointer; transition: 0.4s;
            text-transform: uppercase; letter-spacing: 1px; margin-top: 15px;
        }
        .btn-login:hover { transform: translateY(-5px); box-shadow: 0 20px 40px -10px var(--primary-glow); }

        .error-message { color: #f87171; text-align: center; font-size: 13px; margin-top: 25px; font-weight: 600; background: rgba(239, 68, 68, 0.1); padding: 12px; border-radius: 12px; }
    </style>
</head>
<body>

    <div class="system-header">Ocean View Resort Management System</div>

    <div class="main-auth-card">
        <div class="brand-panel">
            <div class="circle-animation"></div>
            <h1>OCEAN VIEW</h1>
            <p>Experience the future of resort management through our 3-Tier Distributed Intelligence System.</p>

            <ul class="security-list">
                <li class="security-item">Encrypted Access Control</li>
                <li class="security-item">Role-Based Permissions</li>
                <li class="security-item">Distributed Data Layer</li>
            </ul>
        </div>

        <div class="login-panel">
            <h2>Staff Portal</h2>
            <p class="sub">Please verify your identity to access the management hub.</p>

            <form action="LoginServlet" method="post">

                <div class="role-section">
                    <span class="role-label">System Access Level</span>
                    <div class="role-grid">
                        <div class="role-box">
                            <input type="radio" id="staff" name="role" value="Staff" checked>
                            <label for="staff">Staff Member</label>
                        </div>
                        <div class="role-box">
                            <input type="radio" id="admin" name="role" value="Admin">
                            <label for="admin">System Admin</label>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label>Employee ID / Username</label>
                    <input type="text" name="username" placeholder="Enter your ID" required>
                </div>

                <div class="form-group">
                    <label>Security Key (Password)</label>
                    <input type="password" name="password" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn-login">Open Management Hub</button>
            </form>

            <% if(request.getParameter("error") != null) { %>
                <div class="error-message">
                    Access Denied. Check credentials and try again.
                </div>
            <% } %>
        </div>
    </div>

</body>
</html>