<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="공연 목록" scope="request"/>
<%@ include file="../common/head.jspf"%>

<div class="flex items-center justify-between mb-6">
  <h1 class="text-2xl font-bold text-amber-400">공연 목록</h1>
  <a href="/admin/concert/create" class="btn btn-sm bg-amber-500 hover:bg-amber-400 text-black border-none font-bold">+ 새 공연 등록</a>
</div>

<c:choose>
  <c:when test="${empty concerts}">
    <div class="text-center py-20 text-slate-500">
      <p class="text-5xl mb-4">🎭</p>
      <p class="text-lg">등록된 공연이 없습니다.</p>
      <a href="/admin/concert/create" class="btn btn-primary mt-4">첫 공연 등록하기</a>
    </div>
  </c:when>
  <c:otherwise>
    <div class="overflow-x-auto rounded-xl border border-slate-800">
      <table class="table table-zebra w-full">
        <thead class="bg-slate-800 text-slate-300 text-xs uppercase tracking-wider">
          <tr>
            <th class="w-12">ID</th>
            <th>공연명</th>
            <th>공연 기간</th>
            <th>예매 시작</th>
            <th class="w-24 text-center">상태</th>
            <th class="w-24 text-center">관리</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="c" items="${concerts}">
            <tr class="hover:bg-slate-800/60 transition-colors">
              <td class="text-slate-500 text-sm">${c.id}</td>
              <td>
                <div class="font-semibold text-white">${c.title}</div>
              </td>
              <td class="text-slate-400 text-sm font-mono">
                ${c.startDate} ~ ${c.endDate}
              </td>
              <td class="text-slate-400 text-sm font-mono">${c.bookingStartAt}</td>
              <td class="text-center">
                <c:choose>
                  <c:when test="${c.status == 'OPEN'}">
                    <span class="badge badge-success badge-sm font-bold">OPEN</span>
                  </c:when>
                  <c:when test="${c.status == 'PAUSED'}">
                    <span class="badge badge-warning badge-sm font-bold">PAUSED</span>
                  </c:when>
                  <c:when test="${c.status == 'CLOSED'}">
                    <span class="badge badge-error badge-sm font-bold">CLOSED</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge badge-ghost badge-sm font-bold">DRAFT</span>
                  </c:otherwise>
                </c:choose>
              </td>
              <td class="text-center">
                <a href="/admin/concert/detail?id=${c.id}" class="btn btn-xs btn-outline btn-primary mr-1">상세</a>
                <a href="/admin/concert/edit?id=${c.id}" class="btn btn-xs btn-outline btn-ghost">수정</a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </c:otherwise>
</c:choose>

<%@ include file="../common/foot.jspf"%>
