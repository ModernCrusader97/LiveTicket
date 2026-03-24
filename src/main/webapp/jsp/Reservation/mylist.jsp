<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>

<%
List<Map<String, Object>> myReservations = (List<Map<String, Object>>) request.getAttribute("myReservations");
boolean isEmpty = (boolean)myReservations.isEmpty();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지 - 내 예약 목록</title>
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        th { background-color: #f4f4f4; }
    </style>
</head>
<body>
    <h2>내 예약 목록</h2>
    <table>
        <thead>
            <tr>
                <th>예약번호</th>
                <th>공연명</th>
                <th>공연일시</th>
                <th>좌석정보</th>
                <th>결제금액</th>
                <th>예약상태</th>
            </tr>
        </thead>
        <tbody>
	<%
	if (isEmpty) {
	%>

                <tr>
                    <td colspan="6">예약된 내역이 없습니다.</td>
                </tr>

	<%
	} else { 
        for (Map<String, Object> res : myReservations) {
	%>

                <tr>
					<td><%= res.get("id") %></td>
                    <td><%= res.get("title") %></td> 
                    <td><%= res.get("start_at") %></td>
                    <td><%= res.get("grade_name") %>석 / <%= res.get("row_name") %>열 <%= res.get("col_number") %>번</td> 
                    <td><%= res.get("paid_price") %>원</td>
                    <td><%= res.get("status") %></td>
                </tr>
                    <%
        	}
        }
	%>

        </tbody>
    </table>

</body>
</html>