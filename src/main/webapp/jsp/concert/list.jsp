<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    List<Map<String, Object>> concerts = (List<Map<String, Object>>) request.getAttribute("concerts");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>예매 가능한 공연 목록</title>
    <style>
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        th { background-color: #f4f4f4; }
        button { cursor: pointer; padding: 5px 10px; }
    </style>
</head>
<body>
    <%@ include file="../part/top_bar.jspf"%>
     <h2> 예매 가능한 공연 목록</h2>
    
    <table>
        <thead>
            <tr>
                <th>공연번호</th>
                <th>공연명</th>
                <th>공연일시</th>
                <th>예매오픈일</th>
                <th>예매하기</th>
            </tr>
        </thead>
        <tbody>
            <% 
            if (concerts == null || concerts.isEmpty()) { 
            %>
                <tr>
                    <td colspan="5">현재 오픈된 공연이 없습니다.</td>
                </tr>
            <% 
            } else { 
                for (Map<String, Object> concert : concerts) { 
                	String startAt = String.valueOf(concert.get("start_at")).replace("T", " ");
                	String newStart = startAt.substring(0, 4) + "년 " + startAt.substring(5, 7) + "월 " + startAt.substring(8, 10) + "일 " + startAt.substring(11, 16);

                	String bookingStartAt = String.valueOf(concert.get("booking_start_at")).replace("T", " ");
                	String newbookingStartAt = bookingStartAt.substring(0, 4) + "년 " + bookingStartAt.substring(5, 7) + "월 " + bookingStartAt.substring(8, 10) + "일 " + bookingStartAt.substring(11, 16);
                	%>
                <tr>
                    <td><%= concert.get("id") %></td>
                    <td><b><%= concert.get("title") %></b></td>
                    <td><%= newStart %></td>
                    <td><%= newbookingStartAt %></td>
                    <td>
                        <a href="../concert/detail?id=<%= concert.get("id") %>">
                            <button>상세보기 및 예매</button>
                        </a>
                    </td>
                </tr>
            <% 
                } 
            } 
            %>
        </tbody>
    </table>
</body>
</html>