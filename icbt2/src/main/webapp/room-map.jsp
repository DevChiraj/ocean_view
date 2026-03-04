<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View | Floor Intelligence</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        :root { --primary: #38bdf8; --bg: #020617; --glass: rgba(255, 255, 255, 0.03); --border: rgba(255, 255, 255, 0.1); --available: #10b981; --occupied: #fb7185; --text-dim: #94a3b8; }
        body { margin: 0; font-family: 'Plus Jakarta Sans', sans-serif; background: var(--bg); color: white; display: flex; min-height: 100vh; overflow-x: hidden; }
        .main-content { margin-left: 280px; padding: 50px; width: calc(100% - 280px); }

        /* Room Cards Styling */
        .map-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 40px; }
        .legend { display: flex; gap: 20px; background: var(--glass); padding: 15px 25px; border-radius: 15px; border: 1px solid var(--border); }
        .legend-item { display: flex; align-items: center; gap: 8px; font-size: 13px; font-weight: 600; }
        .dot { width: 10px; height: 10px; border-radius: 50%; }
        .room-cluster { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 25px; }
        .room-node { background: var(--glass); border: 1px solid var(--border); border-radius: 25px; padding: 35px 15px; text-align: center; transition: 0.4s; cursor: pointer; position: relative; }
        .room-node i { font-size: 30px; margin-bottom: 12px; display: block; }
        .room-node.available { border-bottom: 5px solid var(--available); }
        .room-node.available:hover { background: rgba(16, 185, 129, 0.1); transform: translateY(-5px); }
        .room-node.occupied { border-bottom: 5px solid var(--occupied); opacity: 0.6; cursor: not-allowed; }

        /* Modern Modal Styling */
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8); display: none; align-items: center; justify-content: center; z-index: 1000; backdrop-filter: blur(8px); }
        .booking-modal { background: #0f172a; padding: 40px; border-radius: 30px; border: 1px solid var(--primary); text-align: center; max-width: 400px; transform: scale(0.8); transition: 0.3s; box-shadow: 0 0 50px rgba(56, 189, 248, 0.2); }
        .modal-active { display: flex; }
        .modal-active .booking-modal { transform: scale(1); }
        .modal-icon { width: 70px; height: 70px; background: rgba(56, 189, 248, 0.1); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: var(--primary); font-size: 30px; margin: 0 auto 20px; }
        .btn-go { background: var(--primary); color: #020617; border: none; padding: 15px 30px; border-radius: 15px; font-weight: 800; cursor: pointer; margin-top: 25px; width: 100%; transition: 0.3s; text-decoration: none; display: inline-block; }
        .btn-go:hover { box-shadow: 0 0 20px var(--primary); transform: translateY(-2px); }
        .btn-close { color: var(--text-dim); background: none; border: none; margin-top: 15px; cursor: pointer; font-size: 13px; text-decoration: underline; }
    </style>
</head>
<body>
    <jsp:include page="slidebar.jsp" />

    <main class="main-content">
        <div class="map-header">
            <div>
                <h1 style="margin:0; font-size:32px; font-weight:800;">Floor Map</h1>
                <p style="color: var(--text-dim);">Select an available room to start booking.</p>
            </div>
            <div class="legend">
                <div class="legend-item"><div class="dot" style="background: var(--available);"></div> Ready</div>
                <div class="legend-item"><div class="dot" style="background: var(--occupied);"></div> Occupied</div>
            </div>
        </div>

        <div class="room-cluster">
            <%
                List<Map<String, String>> list = (List<Map<String, String>>) request.getAttribute("rooms");
                if (list != null) {
                    for (Map<String, String> r : list) {
                        String status = r.get("status").toLowerCase();
            %>
                <div class="room-node <%= status %>"
                     onclick="<%= status.equals("available") ? "openBookingModal('" + r.get("id") + "')" : "" %>">
                    <i class="fa-solid <%= r.get("type").equalsIgnoreCase("Luxury") ? "fa-crown" : "fa-bed" %>"></i>
                    <span style="font-weight: 800; font-size: 22px; display: block;"><%= r.get("id") %></span>
                    <span style="font-size: 10px; font-weight: 800; text-transform: uppercase; color: <%= status.equals("available") ? "var(--available)" : "var(--occupied)" %>">
                        <%= r.get("status") %>
                    </span>
                </div>
            <% } } %>
        </div>
    </main>

    <div class="modal-overlay" id="bookingModal">
        <div class="booking-modal">
            <div class="modal-icon"><i class="fa-solid fa-calendar-check"></i></div>
            <h2 style="margin:0;">Room <span id="selectedRoom"></span></h2>
            <p style="color: var(--text-dim); margin: 10px 0;">This room is ready for a new guest. Would you like to proceed to the registration page?</p>

            <button class="btn-go" onclick="triggerSidebarBooking()">
                <i class="fa-solid fa-arrow-right-to-bracket"></i> GO TO BOOKING
            </button>
            <br>
            <button class="btn-close" onclick="closeModal()">Maybe later</button>
        </div>
    </div>

    <script>
        let currentRoom = "";

        // මොඩල් එක ඕපන් කරන ෆන්ක්ෂන් එක
        function openBookingModal(roomId) {
            currentRoom = roomId;
            document.getElementById('selectedRoom').innerText = roomId;
            document.getElementById('bookingModal').classList.add('modal-active');
        }

        // මොඩල් එක වහන ෆන්ක්ෂන් එක
        function closeModal() {
            document.getElementById('bookingModal').classList.remove('modal-active');
        }

        // ඔයා ඉල්ලපු ලින්ක් එකට යවන ෆන්ක්ෂන් එක
        function triggerSidebarBooking() {
            // දැන් මේක කෙලින්ම සර්ව්ලට් එකට රූම් අංකයත් අරන් යනවා
            window.location.href = 'ReservationServlet?action=new&room=' + currentRoom;
        }
    </script>
</body>
</html>