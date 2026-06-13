<%@ page contentType="text/html; charset=UTF-8" isELIgnored="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>공연 수정 - 관리자</title>
</head>
<body>
<h1>공연 수정 (관리자)</h1>
<c:if test="${concert == null}">
    <p>공연을 찾을 수 없습니다.</p>
</c:if>
<c:if test="${concert != null}">
    <form action="/admin/concert/modify" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="${concert.id}">
        <div>
            <label>타이틀</label>
            <input type="text" name="title" value="${concert.title}">
        </div>
        <div>
            <label>포스터 교체</label>
            <input type="file" name="posterFile">
        </div>
        <div>
            <label>공연일</label>
            <input type="text" name="performDate" value="${concert.performDate}">
        </div>
        <div>
            <label>시작시간</label>
            <input type="text" name="startAt" value="${concert.startAt}">
        </div>
        <div>
            <label>예약시작</label>
            <input type="text" name="bookingStartAt" value="${concert.bookingStartAt}">
        </div>
        <div>
            <label>가격</label>
            <input type="number" name="price" value="${concert.price}">
        </div>
        <div>
            <label>설명</label>
            <textarea name="body">${concert.body}</textarea>
        </div>
        <div>
            <label>공연 상태</label>
            <span id="currentStatus">${concert.status}</span>
            <select id="statusSelect">
                <option value="DRAFT">DRAFT</option>
                <option value="OPEN">OPEN</option>
                <option value="PAUSED">PAUSED</option>
                <option value="CLOSED">CLOSED</option>
            </select>
            <button type="button" id="statusChangeBtn">상태 변경</button>
        </div>
        <hr>
        <h3>좌석 구조 교체 (전체 교체됩니다)</h3>
        <p>같은 인덱스로 구역명/가격/행수를 입력하세요. 비활성 좌석 키는 <code>구역인덱스_행_열</code> 형태로 콤마로 구분하여 입력합니다.</p>
        <div>
            <label>구역들</label>
            <div id="grade-rows">
                <c:forEach var="g" items="${seatGrades}">
                    <div class="grade-row">
                        <input type="text" name="gradeNames" value="${g.name}" placeholder="구역명">
                        <input type="number" name="gradePrices" value="${g.price}" placeholder="가격">
                        <input type="number" name="gradeRowCounts" value="3" placeholder="행수">
                        <button type="button" class="remove-grade">삭제</button>
                    </div>
                </c:forEach>
                <!-- empty template -->
                <div class="grade-row template" style="display:none">
                    <input type="text" name="gradeNames" placeholder="구역명">
                    <input type="number" name="gradePrices" placeholder="가격">
                    <input type="number" name="gradeRowCounts" placeholder="행수">
                    <button type="button" class="remove-grade">삭제</button>
                </div>
            </div>
            <button type="button" id="add-grade">구역 추가</button>
        </div>
        <div>
            <label>비활성 좌석 키(comma separated)</label>
            <input type="text" name="disabledSeatsStr" placeholder="0_1_1,0_1_2">
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script>
            // Avoid nested forms by performing a small POST via dynamically created form
            function submitStatusChange(id, status) {
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '/admin/concert/statusChange';
                var idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'id';
                idInput.value = id;
                var statusInput = document.createElement('input');
                statusInput.type = 'hidden';
                statusInput.name = 'status';
                statusInput.value = status;
                form.appendChild(idInput);
                form.appendChild(statusInput);
                document.body.appendChild(form);
                form.submit();
            }

            document.addEventListener('DOMContentLoaded', function(){
                var btn = document.getElementById('statusChangeBtn');
                if(btn){
                    btn.addEventListener('click', function(){
                        var sel = document.getElementById('statusSelect');
                        var status = sel.value;
                        submitStatusChange(${concert.id}, status);
                    });
                }
            });
        </script>
        <script>
            $(function(){
                $('#add-grade').on('click', function(){
                    var tpl = $('#grade-rows .template').clone().removeClass('template').show();
                    $('#grade-rows').append(tpl);
                });
                $(document).on('click', '.remove-grade', function(){
                    $(this).closest('.grade-row').remove();
                });
            });
        </script>
        <div>
            <button type="submit">저장</button>
            <a href="/admin/concert/detail?id=${concert.id}">취소</a>
        </div>
    </form>
</c:if>
</body>
</html>