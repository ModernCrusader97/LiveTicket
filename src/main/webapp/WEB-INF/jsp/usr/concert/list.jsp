<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="pageTitle" value="공연 목록"/>
<%@ include file="../common/head.jspf"%>

<div class="max-w-screen-xl mx-auto px-4 py-10">

  <%-- 헤더 --%>
  <div class="mb-8">
    <h2 class="text-3xl font-black tracking-tight">공연 라인업</h2>
    <p class="text-base-content/40 text-sm mt-1">현재 예매 가능한 모든 공연을 확인하세요.</p>
  </div>

  <%-- 검색 + 필터 + 정렬 --%>
  <form method="get" action="/usr/concert/list" class="mb-8 space-y-4">

    <%-- 검색 --%>
    <div class="flex gap-2">
      <input type="text" name="keyword" value="${keyword}"
             placeholder="공연 제목 검색..."
             class="input input-bordered flex-1 bg-base-100 text-sm"/>
      <button type="submit" class="btn btn-primary px-6">검색</button>
      <c:if test="${not empty keyword or not empty status or (not empty sort and sort != 'latest')}">
        <a href="/usr/concert/list" class="btn btn-ghost px-4 text-sm">초기화</a>
      </c:if>
    </div>

    <%-- 상태 필터 탭 --%>
    <div class="flex gap-2 flex-wrap">
      <c:set var="curStatus" value="${empty status ? '' : status}"/>
      <a href="/usr/concert/list?sort=${sort}&keyword=${keyword}"
         class="btn btn-sm ${curStatus == '' ? 'btn-primary' : 'btn-ghost border border-base-300'}">전체</a>
      <a href="/usr/concert/list?sort=${sort}&status=OPEN&keyword=${keyword}"
         class="btn btn-sm ${curStatus == 'OPEN' ? 'btn-error text-white' : 'btn-ghost border border-base-300'}">OPEN</a>
      <a href="/usr/concert/list?sort=${sort}&status=DRAFT&keyword=${keyword}"
         class="btn btn-sm ${curStatus == 'DRAFT' ? 'btn-neutral' : 'btn-ghost border border-base-300'}">예정</a>

      <div class="flex-1"></div>

      <%-- 정렬 --%>
      <c:set var="curSort" value="${empty sort ? 'latest' : sort}"/>
      <a href="/usr/concert/list?sort=latest&status=${status}&keyword=${keyword}"
         class="btn btn-sm ${curSort == 'latest' ? 'btn-primary' : 'btn-ghost border border-base-300'}">최신순</a>
      <a href="/usr/concert/list?sort=viewCount&status=${status}&keyword=${keyword}"
         class="btn btn-sm ${curSort == 'viewCount' ? 'btn-primary' : 'btn-ghost border border-base-300'}">인기순</a>
      <a href="/usr/concert/list?sort=rating&status=${status}&keyword=${keyword}"
         class="btn btn-sm ${curSort == 'rating' ? 'btn-primary' : 'btn-ghost border border-base-300'}">평점순</a>
      <a href="/usr/concert/list?sort=bookingRate&status=${status}&keyword=${keyword}"
         class="btn btn-sm ${curSort == 'bookingRate' ? 'btn-primary' : 'btn-ghost border border-base-300'}">예매율순</a>
    </div>

  </form>

  <%-- 결과 수 --%>
  <div class="text-xs text-base-content/40 mb-4 font-semibold">
    총 <span class="text-primary font-black">${fn:length(concerts)}</span>개 공연
    <c:if test="${not empty keyword}"> — "<span class="text-base-content/70">${keyword}</span>" 검색 결과</c:if>
  </div>

  <%-- 공연 그리드 --%>
  <c:choose>
    <c:when test="${empty concerts}">
      <div class="bg-base-100 border border-base-300 rounded-2xl py-24 text-center">
        <span class="text-5xl block mb-4">🎫</span>
        <h3 class="text-lg font-bold">조건에 맞는 공연이 없습니다</h3>
        <p class="text-sm opacity-40 mt-1">다른 조건으로 검색해보세요.</p>
      </div>
    </c:when>
    <c:otherwise>
      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
        <c:forEach var="concert" items="${concerts}">
          <a href="/usr/concert/detail?id=${concert.id}"
             class="group flex flex-col bg-base-100 border border-base-300 rounded-2xl shadow-sm hover:shadow-xl hover:border-primary/30 transition-all duration-300 overflow-hidden">

            <div class="relative aspect-[2/3] bg-base-300 overflow-hidden">
              <c:choose>
                <c:when test="${not empty concert.posterImg}">
                  <img src="${concert.posterImg}" alt="${concert.title}"
                       class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"/>
                </c:when>
                <c:otherwise>
                  <div class="flex flex-col items-center justify-center h-full opacity-30">
                    <span class="text-5xl">🎬</span>
                  </div>
                </c:otherwise>
              </c:choose>

              <c:if test="${concert.status == 'OPEN'}">
                <div class="absolute top-2 left-2">
                  <span class="badge badge-error badge-sm font-bold text-white text-xs">OPEN</span>
                </div>
              </c:if>

              <%-- 예매율 배지 --%>
              <c:if test="${concert.extra__bookingRate > 0}">
                <div class="absolute bottom-2 left-2 bg-black/70 rounded-full px-2 py-0.5 text-white text-xs font-bold">
                  <fmt:formatNumber value="${concert.extra__bookingRate}" maxFractionDigits="0"/>%
                </div>
              </c:if>

              <%-- 조회수 --%>
              <div class="absolute bottom-2 right-2 bg-black/50 rounded-full px-2 py-0.5 text-white text-xs flex items-center gap-1">
                <i class="fas fa-eye text-xs opacity-70"></i> ${concert.viewCount}
              </div>
            </div>

            <div class="p-3 flex flex-col gap-1">
              <p class="text-primary text-xs font-bold">${concert.startDate.substring(0, 10)}</p>
              <h3 class="font-black text-sm leading-snug line-clamp-2 group-hover:text-primary transition-colors">${concert.title}</h3>
              <div class="flex items-center justify-between mt-1">
                <c:if test="${concert.extra__avgRating > 0}">
                  <span class="text-amber-400 text-xs font-bold">★ ${concert.extra__avgRating}</span>
                </c:if>
                <c:if test="${concert.extra__avgRating == 0}"><span></span></c:if>
                <c:if test="${concert.extra__bookingRate > 0}">
                  <span class="text-xs text-base-content/40 font-mono">예매 <fmt:formatNumber value="${concert.extra__bookingRate}" maxFractionDigits="0"/>%</span>
                </c:if>
              </div>
            </div>
          </a>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>

</div>

<%@ include file="../common/foot.jspf"%>
