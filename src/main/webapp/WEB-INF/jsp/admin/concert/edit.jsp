<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="공연 수정" scope="request"/>
<%@ include file="../common/head.jspf"%>

<c:if test="${concert == null}">
  <div class="text-center py-20 text-slate-500">공연을 찾을 수 없습니다.</div>
</c:if>

<c:if test="${concert != null}">

<div class="flex items-center gap-3 mb-6">
  <a href="/admin/concert/detail?id=${concert.id}" class="text-slate-500 hover:text-slate-300 text-sm">← 상세로</a>
  <h1 class="text-2xl font-bold text-amber-400">공연 수정</h1>
</div>

<c:if test="${not empty msg}">
  <div class="alert alert-error mb-4 text-sm">${msg}</div>
</c:if>

<%-- 마스터 공연 기본 정보 --%>
<div class="bg-slate-900/60 rounded-xl border border-slate-800 p-6 mb-6">
  <h2 class="text-base font-bold text-cyan-400 mb-4">📋 공연 기본 정보</h2>
  <form action="/admin/concert/modify" method="post" enctype="multipart/form-data" class="space-y-4">
    <input type="hidden" name="id" value="${concert.id}">
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div class="md:col-span-2">
        <label class="label text-xs text-slate-400">공연 타이틀</label>
        <input type="text" name="title" value="${concert.title}"
               class="input input-bordered w-full bg-slate-950 text-white" required>
      </div>
      <div>
        <label class="label text-xs text-slate-400">예매 시작일시</label>
        <input type="datetime-local" name="bookingStartAt"
               value="${concert.bookingStartAt}"
               class="input input-bordered w-full bg-slate-950 text-white font-mono">
      </div>
      <div>
        <label class="label text-xs text-slate-400">포스터 교체 (선택)</label>
        <input type="file" name="posterFile" accept="image/*"
               class="file-input file-input-bordered file-input-sm bg-slate-950 w-full">
        <c:if test="${not empty concert.posterImg}">
          <img src="${concert.posterImg}" alt="현재 포스터" class="mt-2 h-20 rounded object-cover opacity-60">
        </c:if>
      </div>
      <div class="md:col-span-2">
        <label class="label text-xs text-slate-400">설명</label>
        <textarea name="body" rows="3"
                  class="textarea textarea-bordered w-full bg-slate-950 text-white">${concert.body}</textarea>
      </div>
    </div>
    <div class="flex gap-2 pt-2">
      <button type="submit" class="btn btn-primary">저장</button>
      <a href="/admin/concert/detail?id=${concert.id}" class="btn btn-ghost">취소</a>
    </div>
  </form>
</div>

<%-- 회차별 수정 --%>
<div class="mb-4">
  <h2 class="text-base font-bold text-amber-400 mb-4">📅 회차별 수정</h2>
  <c:choose>
    <c:when test="${empty schedules}">
      <p class="text-slate-500 text-sm">등록된 회차가 없습니다.</p>
    </c:when>
    <c:otherwise>
      <div class="space-y-4">
        <c:forEach var="s" items="${schedules}">
          <details class="bg-slate-900/60 rounded-xl border border-slate-800">
            <summary class="p-4 cursor-pointer flex items-center gap-3 hover:bg-slate-800/40 rounded-xl select-none">
              <c:choose>
                <c:when test="${s.status == 'OPEN'}"><span class="badge badge-success badge-sm">${s.status}</span></c:when>
                <c:when test="${s.status == 'PAUSED'}"><span class="badge badge-warning badge-sm">${s.status}</span></c:when>
                <c:when test="${s.status == 'CLOSED'}"><span class="badge badge-error badge-sm">${s.status}</span></c:when>
                <c:otherwise><span class="badge badge-ghost badge-sm">${s.status}</span></c:otherwise>
              </c:choose>
              <span class="font-semibold text-white">${s.title}</span>
              <span class="text-slate-400 text-sm font-mono">${s.performDate}</span>
              <span class="text-slate-500 text-sm ml-auto">${s.price}원 / ${s.totalSeats}석</span>
            </summary>
            <div class="p-5 border-t border-slate-800">
              <form action="/admin/schedule/modify" method="post" class="space-y-4">
                <input type="hidden" name="scheduleId" value="${s.id}">
                <input type="hidden" name="concertId" value="${concert.id}">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div class="md:col-span-2">
                    <label class="label text-xs text-slate-400">회차 제목</label>
                    <input type="text" name="title" value="${s.title}"
                           class="input input-bordered w-full bg-slate-950 text-white">
                  </div>
                  <div>
                    <label class="label text-xs text-slate-400">공연일시</label>
                    <input type="datetime-local" name="performDate" value="${s.performDate}"
                           class="input input-bordered w-full bg-slate-950 text-white font-mono">
                  </div>
                  <div>
                    <label class="label text-xs text-slate-400">가격 (원)</label>
                    <input type="number" name="price" value="${s.price}"
                           class="input input-bordered w-full bg-slate-950 text-white">
                  </div>
                  <div>
                    <label class="label text-xs text-slate-400">총 좌석 수</label>
                    <input type="number" name="totalSeats" value="${s.totalSeats}"
                           class="input input-bordered w-full bg-slate-950 text-white">
                  </div>
                  <div class="md:col-span-2">
                    <label class="label text-xs text-slate-400">회차 설명</label>
                    <textarea name="body" rows="2"
                              class="textarea textarea-bordered w-full bg-slate-950 text-white">${s.body}</textarea>
                  </div>
                </div>

                <div class="border-t border-slate-800 pt-4">
                  <p class="text-xs text-slate-500 mb-3">좌석 구조 교체 — 예매가 없을 때만 가능. 입력하지 않으면 유지됩니다.</p>
                  <div id="grade-container-${s.id}" class="space-y-2 mb-2"></div>
                  <button type="button" onclick="addGrade('${s.id}')"
                          class="btn btn-xs btn-outline btn-ghost w-full">+ 구역 추가</button>
                  <div class="mt-2">
                    <label class="label text-xs text-slate-400">비활성 좌석 키 (예: 0_1_1,0_1_2)</label>
                    <input type="text" name="disabledSeatsStr" placeholder="없으면 비워두세요"
                           class="input input-bordered input-sm w-full bg-slate-950 text-white font-mono">
                  </div>
                </div>

                <div class="flex gap-2">
                  <button type="submit" class="btn btn-sm btn-primary">저장</button>
                </div>
              </form>
            </div>
          </details>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</div>

</c:if>

<script>
function addGrade(scheduleId) {
    var container = document.getElementById('grade-container-' + scheduleId);
    var div = document.createElement('div');
    div.className = 'flex gap-2 items-center bg-slate-950 p-2 rounded border border-slate-800';
    div.innerHTML =
        '<input type="text" name="gradeNames" placeholder="구역명" class="input input-xs input-bordered bg-slate-900 text-white flex-1">' +
        '<input type="number" name="gradePrices" placeholder="가격" class="input input-xs input-bordered bg-slate-900 text-white w-28">' +
        '<input type="number" name="gradeRowCounts" placeholder="행수" class="input input-xs input-bordered bg-slate-900 text-white w-20">' +
        '<button type="button" onclick="this.parentElement.remove()" class="btn btn-xs btn-ghost text-error">✕</button>';
    container.appendChild(div);
}
</script>

<%@ include file="../common/foot.jspf"%>
