<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Map<String, Object> concert = (Map<String, Object>) request.getAttribute("concert");
    List<Map<String, Object>> remainSeats = (List<Map<String, Object>>) request.getAttribute("remainSeats");
    String startAt = String.valueOf(concert.get("start_at")).replace("T", " ");
   	String newStart = startAt.substring(0, 4) + "년 " + startAt.substring(5, 7) + "월 " + startAt.substring(8, 10) + "일 " + startAt.substring(11, 16);

	String bookingStartAt = String.valueOf(concert.get("booking_start_at")).replace("T", " ");
	String newbookingStartAt = bookingStartAt.substring(0, 4) + "년 " + bookingStartAt.substring(5, 7) + "월 " + bookingStartAt.substring(8, 10) + "일 " + bookingStartAt.substring(11, 16);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공연 상세 정보</title>
    <style>
        .info-box { border: 1px solid #ccc; padding: 20px; margin-bottom: 20px; background-color: #f9f9f9; }
        table { width: 50%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        th { background-color: #f4f4f4; }
        .btn-book { padding: 10px 20px; font-size: 16px; cursor: pointer; background-color: #ff5e5e; color: white; border: none; font-weight: bold; }
    </style>
</head>
<body>
    <%@ include file="../part/top_bar.jspf"%>
    <h2>공연 상세 정보</h2>
    
    <div class="info-box">
        <h3><%= concert.get("title") %></h3>
        <p><strong>설명:</strong> <%= concert.get("description") %></p>
        <p><strong>공연 일시:</strong> <%= newStart %></p>
        <p><strong>예매 오픈:</strong> <%= newbookingStartAt %></p>
    </div>

    <h3>등급별 남은 좌석</h3>
    <table>
        <thead>
            <tr>
                <th>좌석 등급</th>
                <th>가격</th>
                <th>남은 좌석 수</th>
            </tr>
        </thead>
        <tbody>
            <% 
            if (remainSeats == null || remainSeats.isEmpty()) { 
            %>
                <tr>
                    <td colspan="3">좌석 정보가 없습니다.</td>
                </tr>
            <% 
            } else { 
                for (Map<String, Object> seat : remainSeats) { 
            %>
                <tr>
                    <td><b><%= seat.get("grade_name") %>석</b></td>
                    <td><%= seat.get("price") %>원</td>
                    <td><strong style="color:red;"><%= seat.get("remain_count") %></strong> 석</td>
                </tr>
            <% 
                } 
            } 
            %>
        </tbody>
    </table>
    
    <br>
    <a href="../reservation/book?concertId=<%= concert.get("id") %>">
        <button class="btn-book">좌석 선택 및 예매하기</button>
    </a>
    <button onclick="history.back()" style="padding: 10px 20px; font-size: 16px; cursor: pointer;">뒤로가기</button>

</body>
</html>