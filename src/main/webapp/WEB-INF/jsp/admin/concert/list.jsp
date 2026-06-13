<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>공연 목록 - 관리자</title>
</head>
<body>
<h1>공연 목록 (관리자)</h1>
<table border="1" cellpadding="6">
    <thead>
    <tr>
        <th>ID</th>
        <th>타이틀</th>
        <th>공연일</th>
        <th>시작시간</th>
        <th>가격</th>
        <th>관리</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="c" items="${concerts}">
        <tr>
            <td>${c.id}</td>
            <td>${c.title}</td>
            <td>${c.performDate}</td>
            <td>${c.startAt}</td>
            <td>${c.price}</td>
            <td>
                <a href="/admin/concert/detail?id=${c.id}">상세</a>
                &nbsp;|&nbsp;
                <a href="/admin/concert/edit?id=${c.id}">수정</a>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>