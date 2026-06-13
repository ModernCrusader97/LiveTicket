<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>공연 상세 - 관리자</title>
</head>
<body>
<h1>공연 상세 (관리자)</h1>
<c:if test="${concert == null}">
    <p>공연을 찾을 수 없습니다.</p>
</c:if>
<c:if test="${concert != null}">
    <div>
        <h2>${concert.title} (ID: ${concert.id})</h2>
        <p>공연일: ${concert.performDate}</p>
        <p>시작시간: ${concert.startAt}</p>
        <p>예약시작: ${concert.bookingStartAt}</p>
        <p>가격: ${concert.price}</p>
        <p>설명: ${concert.body}</p>
        <p>평점(평균): ${concert.extra__avgRating}</p>
    </div>

    <h3>출연진</h3>
    <ul>
        <c:forEach var="a" items="${artists}">
            <li>${a.name} - ${a.profileImg}</li>
        </c:forEach>
    </ul>

    <h3>남은 좌석 (등급별)</h3>
    <ul>
        <c:forEach var="s" items="${remainingSeats}">
            <li>${s.extra__gradeName} : ${s.remainCount}석</li>
        </c:forEach>
    </ul>

    <h3>예매 현황</h3>
    <p>예매 수: ${reservedCount} / 총 좌석: ${concert.totalSeats}</p>
    <p>예매율: ${bookingRate}%</p>
    <p>매출: ${revenue}원</p>

    <div style="margin-top:1em">
        <label>공연 상태: <strong id="displayStatus">${concert.status}</strong></label>
        <select id="detailStatusSelect">
            <option value="DRAFT">DRAFT</option>
            <option value="OPEN">OPEN</option>
            <option value="PAUSED">PAUSED</option>
            <option value="CLOSED">CLOSED</option>
        </select>
        <button type="button" id="detailStatusBtn">상태 변경</button>
    </div>

    <p style="margin-top:1em"><a href="/admin/concert/edit?id=${concert.id}">공연 수정</a></p>
    <p><a href="/admin/concert/list">목록으로</a></p>

    <script>
        function postStatusChange(id, status) {
            var form = document.createElement('form');
            form.method = 'POST';
            form.action = '/admin/concert/statusChange';
            var idInput = document.createElement('input');
            idInput.type = 'hidden'; idInput.name = 'id'; idInput.value = id;
            var statusInput = document.createElement('input');
            statusInput.type = 'hidden'; statusInput.name = 'status'; statusInput.value = status;
            form.appendChild(idInput); form.appendChild(statusInput);
            document.body.appendChild(form);
            form.submit();
        }

        document.addEventListener('DOMContentLoaded', function(){
            var btn = document.getElementById('detailStatusBtn');
            if(btn){
                btn.addEventListener('click', function(){
                    var sel = document.getElementById('detailStatusSelect');
                    postStatusChange(${concert.id}, sel.value);
                });
            }
        });
    </script>
</c:if>
</body>
</html>