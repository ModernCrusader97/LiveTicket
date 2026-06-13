<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>공연 등록 완료</title>
</head>
<body>
<h1>공연 등록 완료</h1>
<p>${msg}</p>
<p>생성된 공연 ID: ${id}</p>
<p><a href="/admin/concert/create">다시 등록</a> | <a href="/admin/concert/detail?id=${id}">등록한 공연 보기</a> | <a href="/admin/concert/list">관리자 목록</a></p>
</body>
</html>
