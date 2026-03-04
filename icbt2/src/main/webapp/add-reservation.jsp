<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // සර්ව්ලට් එකෙන් එන කාමර ලැයිස්තුව ලබා ගැනීම
    List<Map<String, String>> allRooms = (List<Map<String, String>>) request.getAttribute("allRooms");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View | Modern Booking</title>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        :root {
            --primary: #38bdf8;
            --bg: #020617;
            --glass: rgba(255, 255, 255, 0.03);
            --border: rgba(255, 255, 255, 0.08);
        }

        body {
            margin: 0; font-family: 'Plus Jakarta Sans', sans-serif;
            background: var(--bg);
            background-image: radial-gradient(at 0% 0%, hsla(217,100%,15%,1) 0, transparent 50%),
                              radial-gradient(at 100% 100%, hsla(200,100%,10%,1) 0, transparent 50%);
            color: white; display: flex; min-height: 100vh;
        }

        .main-content { margin-left: 280px; padding: 50px; display: grid; grid-template-columns: 1.8fr 1.2fr; gap: 40px; width: 100%; }
        .glass-card { background: var(--glass); border: 1px solid var(--border); border-radius: 30px; padding: 35px; backdrop-filter: blur(20px); }

        input, select, textarea {
            width: 100%; padding: 14px; background: rgba(0,0,0,0.3);
            border: 1px solid var(--border); border-radius: 12px; color: white;
            margin-top: 8px; box-sizing: border-box;
        }

        /* Occupied Room Blur Styling */
        option.occupied-room { color: #f87171; background: #1e1b4b; filter: blur(1px); opacity: 0.5; }

        .svc-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-top: 15px; }
        .svc-item { background: rgba(255,255,255,0.02); padding: 10px; border-radius: 10px; border: 1px solid var(--border); font-size: 12px; display: flex; align-items: center; gap: 10px; cursor: pointer; }
        .btn-submit { width: 100%; padding: 18px; background: var(--primary); border: none; border-radius: 15px; color: #000; font-weight: 800; cursor: pointer; margin-top: 20px; transition: 0.3s; }
        .btn-submit:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(56, 189, 248, 0.2); }
    </style>
</head>
<body>
    <jsp:include page="slidebar.jsp" />

    <main class="main-content">
        <div class="form-side">
            <header style="margin-bottom: 30px;">
                <h1 style="margin: 0; font-size: 32px; font-weight: 800;">New Guest Registration</h1>
                <p style="color: #94a3b8;">Assign assets and services to new entities.</p>
            </header>

            <form id="bookingForm" action="ReservationServlet" method="post" class="glass-card">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="svcTotal" id="svcTotalInput">
                <input type="hidden" name="grandTotal" id="grandTotalInput">

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div><label>Reservation ID</label><input type="text" name="resId" value="OV-RE-<%= System.currentTimeMillis() % 10000 %>" readonly></div>
                    <div><label>Select Room</label>
                        <select name="roomNo" id="roomSelect" required onchange="updateBill()">
                            <option value="" data-price="0">-- Select Room --</option>
                            <% if(allRooms != null) { for(Map<String, String> r : allRooms) {
                                boolean isOccupied = "Occupied".equals(r.get("status"));
                            %>
                                <option value="<%= r.get("id") %>"
                                        data-price="<%= r.get("price") %>"
                                        class="<%= isOccupied ? "occupied-room" : "" %>"
                                        <%= isOccupied ? "disabled" : "" %>>
                                    Room <%= r.get("id") %> - <%= r.get("type") %> <%= isOccupied ? "(OCCUPIED)" : "(LKR " + r.get("price") + ")" %>
                                </option>
                            <% } } %>
                        </select>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 20px;">
                    <div><label>Guest Full Name</label><input type="text" name="guestName" required></div>
                    <div><label>NIC / Passport</label><input type="text" name="nic" required></div>
                </div>

                <div style="margin-top: 20px;"><label>Permanent Address</label><textarea name="address" rows="2" required></textarea></div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 20px;">
                    <div><label>Check-In</label><input type="date" id="checkIn" name="checkIn" required onchange="validateDates()"></div>
                    <div><label>Check-Out</label><input type="date" id="checkOut" name="checkOut" required onchange="validateDates()"></div>
                </div>

                <div style="margin-top: 20px;"><label>Additional Amenities (Daily)</label>
                    <div class="svc-grid">
                        <label class="svc-item"><input type="checkbox" class="svc" data-p="1500" onchange="updateBill()"> Breakfast</label>
                        <label class="svc-item"><input type="checkbox" class="svc" data-p="4500" onchange="updateBill()"> Full Board</label>
                        <label class="svc-item"><input type="checkbox" class="svc" data-p="3500" onchange="updateBill()"> Airport Transfer</label>
                        <label class="svc-item"><input type="checkbox" class="svc" data-p="5000" onchange="updateBill()"> Spa Access</label>
                    </div>
                </div>
            </form>
        </div>

        <div class="summary-side">
            <div class="glass-card" style="position: sticky; top: 50px; border-color: var(--primary);">
                <h3 style="color: var(--primary); margin-top: 0;">Payment Summary</h3>
                <div style="display: flex; justify-content: space-between; margin: 20px 0;">
                    <span style="color: #94a3b8;">Nights Count</span>
                    <b id="dispNights">0</b>
                </div>
                <hr style="border-top: 1px solid var(--border); margin: 20px 0;">
                <span style="font-size: 12px; color: #94a3b8;">Total Amount Due</span>
                <div style="font-size: 36px; font-weight: 800; color: var(--primary); margin: 10px 0;" id="dispTotal">LKR 0.00</div>
                <button type="button" class="btn-submit" onclick="confirmSubmit()">Confirm Booking</button>
            </div>
        </div>
    </main>

    <script>
        function validateDates() {
            const cin = new Date(document.getElementById('checkIn').value);
            const cout = new Date(document.getElementById('checkOut').value);
            if (cin && cout && cout <= cin) {
                Swal.fire('Invalid Date', 'Check-out must be after check-in', 'error');
                document.getElementById('checkOut').value = '';
            }
            updateBill();
        }

        function updateBill() {
            const select = document.getElementById('roomSelect');
            const roomPrice = parseInt(select.selectedOptions[0].getAttribute('data-price') || 0);
            let svcTotal = 0;
            document.querySelectorAll('.svc:checked').forEach(cb => svcTotal += parseInt(cb.getAttribute('data-p')));

            const cin = new Date(document.getElementById('checkIn').value);
            const cout = new Date(document.getElementById('checkOut').value);
            let nights = (cin && cout && cout > cin) ? Math.ceil((cout - cin) / (1000 * 60 * 60 * 24)) : 0;

            document.getElementById('dispNights').innerText = nights;
            let finalTotal = (roomPrice + svcTotal) * (nights > 0 ? nights : 1);
            document.getElementById('dispTotal').innerText = "LKR " + finalTotal.toLocaleString();

            document.getElementById('svcTotalInput').value = svcTotal;
            document.getElementById('grandTotalInput').value = finalTotal;
        }

        function confirmSubmit() {
            if(!document.getElementById('roomSelect').value) { Swal.fire('Error', 'Select a room', 'error'); return; }
            Swal.fire({
                title: 'Confirm Reservation?',
                text: 'This will lock the asset to the guest.',
                icon: 'question',
                showCancelButton: true,
                confirmButtonColor: '#38bdf8'
            }).then((r) => { if(r.isConfirmed) document.getElementById('bookingForm').submit(); });
        }
    </script>
</body>
</html>