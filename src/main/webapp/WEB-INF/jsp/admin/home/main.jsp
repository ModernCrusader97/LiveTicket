<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="관리자 홈" scope="request"/>
<%@ include file="../common/head.jspf"%>

<%-- 인사 --%>
<div class="flex items-center justify-between mb-8">
  <div>
    <h1 class="text-2xl font-black text-white">대시보드</h1>
    <p class="text-slate-500 text-sm mt-1">Cast Live Ticket 관리자 패널</p>
  </div>
  <a href="/admin/concert/create" class="btn btn-primary btn-sm font-bold">+ 공연 등록</a>
</div>

<%-- 통계 카드 --%>
<div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-10">
  <div class="bg-slate-900/60 border border-slate-800 rounded-xl p-5 text-center">
    <p class="text-slate-500 text-xs mb-1">전체 공연</p>
    <p class="text-3xl font-black text-white">${concerts.size()}</p>
  </div>
  <div class="bg-slate-900/60 border border-emerald-900/50 rounded-xl p-5 text-center">
    <p class="text-slate-500 text-xs mb-1">OPEN</p>
    <p class="text-3xl font-black text-emerald-400">${openCount}</p>
  </div>
  <div class="bg-slate-900/60 border border-slate-800 rounded-xl p-5 text-center">
    <p class="text-slate-500 text-xs mb-1">DRAFT</p>
    <p class="text-3xl font-black text-slate-400">${draftCount}</p>
  </div>
  <div class="bg-slate-900/60 border border-slate-800 rounded-xl p-5 text-center">
    <p class="text-slate-500 text-xs mb-1">총 조회수</p>
    <p class="text-3xl font-black text-cyan-400">${totalViews}</p>
  </div>
</div>

<%-- 빠른 메뉴 --%>
<div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-10">
  <a href="/admin/concert/list"
     class="bg-slate-900/60 border border-slate-800 hover:border-amber-500/40 rounded-xl p-6 flex items-center gap-4 transition-all group">
    <span class="text-3xl">🎬</span>
    <div>
      <p class="font-black text-white group-hover:text-amber-400 transition-colors">공연 목록</p>
      <p class="text-slate-500 text-xs mt-0.5">등록된 공연 전체 보기</p>
    </div>
  </a>
  <a href="/admin/concert/create"
     class="bg-slate-900/60 border border-slate-800 hover:border-cyan-500/40 rounded-xl p-6 flex items-center gap-4 transition-all group">
    <span class="text-3xl">➕</span>
    <div>
      <p class="font-black text-white group-hover:text-cyan-400 transition-colors">공연 등록</p>
      <p class="text-slate-500 text-xs mt-0.5">새 공연 및 회차 추가</p>
    </div>
  </a>
  <a href="/"
     class="bg-slate-900/60 border border-slate-800 hover:border-slate-600 rounded-xl p-6 flex items-center gap-4 transition-all group">
    <span class="text-3xl">🌐</span>
    <div>
      <p class="font-black text-white group-hover:text-slate-300 transition-colors">사용자 화면</p>
      <p class="text-slate-500 text-xs mt-0.5">일반 페이지로 이동</p>
    </div>
  </a>
</div>

<%-- 공연 현황 테이블 --%>
<div>
  <h2 class="text-base font-bold text-amber-400 mb-4">📋 공연 현황</h2>
  <c:choose>
    <c:when test="${empty concerts}">
      <p class="text-slate-500 text-sm">등록된 공연이 없습니다.</p>
    </c:when>
    <c:otherwise>
      <div class="overflow-x-auto rounded-xl border border-slate-800">
        <table class="table table-zebra w-full text-sm">
          <thead class="bg-slate-800 text-slate-300 text-xs uppercase">
            <tr>
              <th>ID</th>
              <th>공연명</th>
              <th>기간</th>
              <th class="text-center">상태</th>
              <th class="text-center">조회수</th>
              <th class="text-center">평점</th>
              <th class="text-center">관리</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="c" items="${concerts}">
              <tr class="hover:bg-slate-800/50">
                <td class="text-slate-500 font-mono text-xs">${c.id}</td>
                <td class="font-semibold text-white">${c.title}</td>
                <td class="text-slate-400 text-xs font-mono">${c.startDate.substring(0,10)} ~ ${c.endDate.substring(0,10)}</td>
                <td class="text-center">
                  <c:choose>
                    <c:when test="${c.status == 'OPEN'}"><span class="badge badge-success badge-sm">OPEN</span></c:when>
                    <c:when test="${c.status == 'PAUSED'}"><span class="badge badge-warning badge-sm">PAUSED</span></c:when>
                    <c:when test="${c.status == 'CLOSED'}"><span class="badge badge-error badge-sm">CLOSED</span></c:when>
                    <c:otherwise><span class="badge badge-ghost badge-sm">DRAFT</span></c:otherwise>
                  </c:choose>
                </td>
                <td class="text-center text-cyan-400 font-bold">${c.viewCount}</td>
                <td class="text-center text-amber-400 font-bold">${c.extra__avgRating > 0 ? c.extra__avgRating : '-'}</td>
                <td class="text-center">
                  <a href="/admin/concert/detail?id=${c.id}" class="btn btn-xs btn-ghost text-cyan-400">상세</a>
                  <a href="/admin/concert/edit?id=${c.id}" class="btn btn-xs btn-ghost text-amber-400">수정</a>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </c:otherwise>
  </c:choose>
</div>

<%@ include file="../common/foot.jspf"%>
