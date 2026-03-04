<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    Map<String, Object> d = (Map<String, Object>) request.getAttribute("billData");
    if (d == null || d.isEmpty()) {
        response.sendRedirect("ReservationServlet?action=list&error=no_data");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Invoice - #<%= d.get("res_id") %></title>
    <style>
        .bill-box { max-width: 400px; margin: auto; padding: 30px; border: 1px solid #eee; font-family: sans-serif; }
        .row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px dashed #ccc; }
        .print-btn { background: #38bdf8; padding: 10px 20px; border: none; cursor: pointer; display: block; margin: 20px auto; }
        @media print { .print-btn { display: none; } }
    </style>
</head>
<body>
    <div class="bill-box">
        <h2 style="text-align: center;">OCEAN VIEW RESORT</h2>
        <div class="row"><span>Reservation ID:</span> <b>#<%= d.get("res_id") %></b></div>
        <div class="row"><span>Guest Name:</span> <b><%= d.get("guest") %></b></div>
        <div class="row"><span>Room Category:</span> <b><%= d.get("type") %></b></div>
        <div class="row"><span>Nightly Rate:</span> <b>LKR <%= String.format("%,.2f", d.get("price")) %></b></div>
        <div class="row"><span>Total Stay:</span> <b><%= d.get("nights") %> Nights</b></div>
        <hr>
        <div class="row" style="font-size: 20px; color: #10b981;">
            <span>Grand Total:</span> <b>LKR <%= String.format("%,.2f", d.get("grand_total")) %></b>
        </div>

        <button class="print-btn" onclick="window.print()">
            <i class="fa-solid fa-print"></i> PRINT INVOICE
        </button>
    </div>
</body>
</html>