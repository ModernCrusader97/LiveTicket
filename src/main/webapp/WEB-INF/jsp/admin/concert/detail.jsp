<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="${concert.title}" scope="request"/>
<%@ include file="../common/head.jspf"%>

<c:if test="${concert == null}">
  <div class="text-center py-20 text-slate-500">공연을 찾을 수 없습니다.</div>
</c:if>

<c:if test="${concert != null}">

<%-- 상단 헤더 --%>
<div class="flex items-start justify-between mb-6">
  <div>
    <div class="flex items-center gap-3 mb-1">
      <a href="/admin/concert/list" class="text-slate-500 hover:text-slate-300 text-sm">← 목록</a>
      <c:choose>
        <c:when test="${concert.status == 'OPEN'}"><span class="badge badge-success font-bold">OPEN</span></c:when>
        <c:when test="${concert.status == 'PAUSED'}"><span class="badge badge-warning font-bold">PAUSED</span></c:when>
        <c:when test="${concert.status == 'CLOSED'}"><span class="badge badge-error font-bold">CLOSED</span></c:when>
        <c:otherwise><span class="badge badge-ghost font-bold">DRAFT</span></c:otherwise>
      </c:choose>
    </div>
    <h1 class="text-3xl font-black text-white">${concert.title}</h1>
    <p class="text-slate-400 text-sm mt-1 font-mono">${concert.startDate} ~ ${concert.endDate}</p>
  </div>
  <div class="flex gap-2">
    <a href="/admin/concert/edit?id=${concert.id}" class="btn btn-sm btn-outline btn-amber" style="border-color:#f59e0b;color:#f59e0b;">수정</a>
  </div>
</div>

<div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-8">

  <%-- 공연 정보 카드 --%>
  <div class="lg:col-span-2 bg-slate-900/60 rounded-xl border border-slate-800 p-5 space-y-4">
    <h2 class="text-sm font-bold text-slate-400 uppercase tracking-wider">공연 정보</h2>
    <div class="grid grid-cols-2 gap-3 text-sm">
      <div>
        <p class="text-slate-500 text-xs mb-1">예매 시작일시</p>
        <p class="font-mono text-white">${concert.bookingStartAt}</p>
      </div>
      <div>
        <p class="text-slate-500 text-xs mb-1">평점</p>
        <p class="text-amber-400 font-bold text-lg">${concert.extra__avgRating} <span class="text-slate-500 text-xs font-normal">(${concert.reviewCount}개)</span></p>
      </div>
    </div>
    <c:if test="${not empty concert.body}">
      <div>
        <p class="text-slate-500 text-xs mb-1">설명</p>
        <p class="text-slate-300 text-sm leading-relaxed">${concert.body}</p>
      </div>
    </c:if>

    <%-- 시리즈 전체 상태 변경 --%>
    <div class="pt-2 border-t border-slate-800">
      <p class="text-slate-500 text-xs mb-2">시리즈 전체 상태 변경</p>
      <form method="post" action="/admin/concert/statusChange" class="flex gap-2 items-center">
        <input type="hidden" name="id" value="${concert.id}">
        <select name="status" class="select select-sm select-bordered bg-slate-950 text-white">
          <option value="DRAFT"  ${concert.status == 'DRAFT'  ? 'selected' : ''}>DRAFT</option>
          <option value="OPEN"   ${concert.status == 'OPEN'   ? 'selected' : ''}>OPEN</option>
          <option value="PAUSED" ${concert.status == 'PAUSED' ? 'selected' : ''}>PAUSED</option>
          <option value="CLOSED" ${concert.status == 'CLOSED' ? 'selected' : ''}>CLOSED</option>
        </select>
        <button type="submit" class="btn btn-sm btn-warning">변경</button>
      </form>
    </div>
  </div>

  <%-- 포스터 --%>
  <div class="bg-slate-900/60 rounded-xl border border-slate-800 overflow-hidden flex items-center justify-center min-h-40">
    <c:choose>
      <c:when test="${not empty concert.posterImg}">
        <img src="${concert.posterImg}" alt="포스터" class="w-full object-cover max-h-64">
      </c:when>
      <c:otherwise>
        <p class="text-slate-600 text-sm">포스터 없음</p>
      </c:otherwise>
    </c:choose>
  </div>

</div>

<%-- 예매 통계 --%>
<div class="grid grid-cols-3 gap-4 mb-8">
  <div class="bg-slate-900/60 rounded-xl border border-slate-800 p-4 text-center">
    <p class="text-slate-500 text-xs mb-1">총 좌석</p>
    <p class="text-2xl font-black text-white">${totalSeats}</p>
  </div>
  <div class="bg-slate-900/60 rounded-xl border border-slate-800 p-4 text-center">
    <p class="text-slate-500 text-xs mb-1">예매 수 / 예매율</p>
    <p class="text-2xl font-black text-cyan-400">${reservedCount} <span class="text-base text-slate-400 font-normal">(${bookingRate}%)</span></p>
  </div>
  <div class="bg-slate-900/60 rounded-xl border border-slate-800 p-4 text-center">
    <p class="text-slate-500 text-xs mb-1">총 매출</p>
    <p class="text-2xl font-black text-emerald-400">${revenue}원</p>
  </div>
</div>

<%-- 회차 목록 --%>
<div class="mb-8">
  <h2 class="text-lg font-bold text-amber-400 mb-3">회차 목록</h2>
  <c:choose>
    <c:when test="${empty schedules}">
      <div class="bg-slate-900/40 rounded-xl border border-slate-800 p-8 text-center text-slate-500">등록된 회차가 없습니다.</div>
    </c:when>
    <c:otherwise>
      <div class="overflow-x-auto rounded-xl border border-slate-800">
        <table class="table table-zebra w-full text-sm">
          <thead class="bg-slate-800 text-slate-300 text-xs uppercase tracking-wider">
            <tr>
              <th class="w-12">ID</th>
              <th>회차 제목</th>
              <th>공연일시</th>
              <th class="w-20 text-center">좌석</th>
              <th class="w-24 text-center">가격</th>
              <th class="w-24 text-center">상태</th>
              <th class="w-48 text-center">상태 변경</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="s" items="${schedules}">
              <tr class="hover:bg-slate-800/60">
                <td class="text-slate-500 font-mono text-xs">${s.id}</td>
                <td class="font-medium text-white">${s.title}</td>
                <td class="font-mono text-slate-300">${s.performDate}</td>
                <td class="text-center text-slate-300">${s.totalSeats}</td>
                <td class="text-center text-slate-300"><c:if test="${s.price > 0}">${s.price}원</c:if><c:if test="${s.price == 0}">-</c:if></td>
                <td class="text-center">
                  <c:choose>
                    <c:when test="${s.status == 'OPEN'}"><span class="badge badge-success badge-sm">OPEN</span></c:when>
                    <c:when test="${s.status == 'PAUSED'}"><span class="badge badge-warning badge-sm">PAUSED</span></c:when>
                    <c:when test="${s.status == 'CLOSED'}"><span class="badge badge-error badge-sm">CLOSED</span></c:when>
                    <c:otherwise><span class="badge badge-ghost badge-sm">DRAFT</span></c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <form method="post" action="/admin/schedule/statusChange" class="flex gap-1 items-center justify-center">
                    <input type="hidden" name="scheduleId" value="${s.id}">
                    <input type="hidden" name="concertId" value="${concert.id}">
                    <select name="status" class="select select-xs select-bordered bg-slate-950 text-white w-28">
                      <option value="DRAFT"  ${s.status == 'DRAFT'  ? 'selected' : ''}>DRAFT</option>
                      <option value="OPEN"   ${s.status == 'OPEN'   ? 'selected' : ''}>OPEN</option>
                      <option value="PAUSED" ${s.status == 'PAUSED' ? 'selected' : ''}>PAUSED</option>
                      <option value="CLOSED" ${s.status == 'CLOSED' ? 'selected' : ''}>CLOSED</option>
                    </select>
                    <button type="submit" class="btn btn-xs btn-outline btn-warning">변경</button>
                  </form>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:otherwise>
  </c:choose>
</div>

</c:if>

<%@ include file="../common/foot.jspf"%>
