<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    List<Map<String, Object>> seats = (List<Map<String, Object>>) request.getAttribute("seats");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>좌석 선택</title>
    <style>
        body { text-align: center; font-family: sans-serif; }
        .stage { 
            background-color: #333; color: white; width: 60%; margin: 20px auto; 
            padding: 20px 0; font-weight: bold; border-radius: 10px; font-size: 20px;
        }
        .seat-container { margin: 40px auto; width: 80%; }
        .seat-row { margin-bottom: 10px; display: flex; justify-content: center; align-items: center; }
        .row-label { margin-right: 20px; font-weight: bold; width: 50px; text-align: right; }
        

        .seat { 
            width: 40px; height: 40px; margin: 0 5px; border-radius: 5px; 
            border: 1px solid #ccc; font-size: 12px; cursor: pointer;
            display: flex; flex-direction: column; justify-content: center; align-items: center;
        }
        
        .seat.AVAILABLE { background-color: #4CAF50; color: white; border-color: #388E3C; }
        .seat.AVAILABLE:hover { background-color: #45a049; }
        .seat.RESERVED { background-color: #9e9e9e; color: white; cursor: not-allowed; }
        .seat.PENDING { background-color: #ff9800; color: white; cursor: not-allowed; }
        .seat.SELECTED { background-color: #e91e63 !important; color: white; border: 2px solid #000; }

        .form-box { margin-top: 30px; padding: 20px; background-color: #f4f4f4; border-radius: 10px; display: inline-block; }
        .btn-submit { padding: 10px 20px; font-size: 18px; background-color: #2196F3; color: white; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <%@ include file="../part/top_bar.jspf"%>

    <h2>좌석 선택</h2>
    
    <div class="stage">STAGE</div>

    <div class="seat-container">
        <% 
        if (seats == null || seats.isEmpty()) { 
        %>
            <p>등록된 좌석이 없습니다.</p>
        <% 
        } else { 
            String currentRow = "";
            for (Map<String, Object> seat : seats) { 
                String rowName = (String) seat.get("row_name");
                String status = (String) seat.get("status");
                

                if (!currentRow.equals(rowName)) {
                    if (!currentRow.isEmpty()) {
                        out.print("</div>"); // 이전 줄 닫기
                    }
                    out.print("<div class='seat-row'>");
                    out.print("<div class='row-label'>" + rowName + "열</div>");
                    currentRow = rowName;
                }
                

                String clickEvent = status.equals("AVAILABLE") ? 
                    "onclick='selectSeat(this, " + seat.get("id") + ", " + seat.get("version") + ", \"" + seat.get("grade_name") + "\", " + seat.get("price") + ")'" : "";
                
        %>
                <div class="seat <%= status %>" <%= clickEvent %> title="<%= seat.get("grade_name") %>석 - <%= seat.get("price") %>원">
                    <%= seat.get("col_number") %>
                </div>
        <% 
            }
            if (!currentRow.isEmpty()) {
                out.print("</div>");
            }
        } 
        %>
    </div>

    <div class="form-box">
        <h3 id="selectedInfo">선택된 좌석: 없음</h3>
        <form action="../reservation/doHold" method="post" id="holdForm">
            <input type="hidden" name="seatId" id="inputSeatId" value="">
            <input type="hidden" name="version" id="inputVersion" value="">
            <button type="button" class="btn-submit" onclick="submitHold()">결제 진행하기 (좌석 선점)</button>
        </form>
    </div>

    <script>
        function selectSeat(element, seatId, version, gradeName, price) {

            let previousSelected = document.querySelector('.seat.SELECTED');
            if (previousSelected) {
                previousSelected.classList.remove('SELECTED');
            }

            element.classList.add('SELECTED');

            document.getElementById('inputSeatId').value = seatId;
            document.getElementById('inputVersion').value = version;


            document.getElementById('selectedInfo').innerText = "선택된 좌석: " + gradeName + "석 " + price + "원";
        }

        function submitHold() {
            let seatId = document.getElementById('inputSeatId').value;
            if (!seatId) {
                alert("먼저 예매하실 좌석을 선택해주세요.");
                return;
            }
            document.getElementById('holdForm').submit();
        }
    </script>
</body>
</html>