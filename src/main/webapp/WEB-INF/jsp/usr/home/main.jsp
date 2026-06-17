<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="pageTitle" value="홈"/>
<%@ include file="../common/head.jspf"%>

<%-- Hero --%>
<section class="relative overflow-hidden bg-gradient-to-br from-base-100 via-base-200 to-base-100 border-b border-base-300">
  <div class="absolute inset-0 opacity-10"
       style="background-image:radial-gradient(circle at 25% 50%, oklch(var(--p)) 0%, transparent 55%), radial-gradient(circle at 80% 30%, oklch(var(--s)) 0%, transparent 50%);"></div>
  <div class="relative max-w-screen-xl mx-auto px-6 py-16 sm:py-24 flex flex-col sm:flex-row items-center gap-10 sm:gap-16">

    <%-- 왼쪽: 로고 --%>
    <div class="shrink-0 flex justify-center sm:justify-start">
      <img src="/img/logo_blue.png" alt="C.A.S.T."
           class="w-64 h-64 sm:w-80 sm:h-80 object-contain"
           style="filter: drop-shadow(0 0 36px rgba(99,179,237,0.7));" />
    </div>

    <%-- 오른쪽: 텍스트 --%>
    <div class="flex flex-col gap-5 text-center sm:text-left">
      <div class="space-y-2 font-mono text-lg sm:text-xl">
        <p><span class="text-primary font-black text-2xl sm:text-3xl">C</span><span class="text-base-content/50">oncurrent</span> <span class="text-base-content/30 mx-1">—</span> <span class="text-base-content/80 font-semibold">동시에 몰려도</span></p>
        <p><span class="text-secondary font-black text-2xl sm:text-3xl">A</span><span class="text-base-content/50">nd</span> <span class="text-base-content/30 mx-1">—</span> <span class="text-base-content/80 font-semibold">언제나</span></p>
        <p><span class="text-accent font-black text-2xl sm:text-3xl">S</span><span class="text-base-content/50">ecure</span> <span class="text-base-content/30 mx-1">—</span> <span class="text-base-content/80 font-semibold">안전하게</span></p>
        <p><span class="text-warning font-black text-2xl sm:text-3xl">T</span><span class="text-base-content/50">icketing</span> <span class="text-base-content/30 mx-1">—</span> <span class="text-base-content/80 font-semibold">내 자리를</span></p>
      </div>
      <p class="text-base-content/40 text-sm sm:text-base max-w-md">
        수만 명이 동시에 접속해도, 내 자리는 공정하게 확보됩니다.<br/>
        빠르고 안전한 티켓팅, C.A.S.T.가 함께합니다.
      </p>
      <div class="flex gap-3 justify-center sm:justify-start">
        <a href="/usr/concert/list" class="btn btn-primary btn-lg rounded-xl px-8 font-black">공연 목록 보기</a>
        <a href="/usr/review/list"  class="btn btn-ghost btn-lg rounded-xl font-semibold">커뮤니티</a>
      </div>
    </div>

  </div>
</section>

<%-- 인기 공연 (조회수 기준) --%>
<section class="max-w-screen-xl mx-auto px-4 py-14">
  <div class="flex items-end justify-between mb-8">
    <div>
      <p class="text-xs font-bold text-primary uppercase tracking-widest mb-1">Most Viewed</p>
      <h2 class="text-2xl sm:text-3xl font-black">지금 가장 인기 있는 공연</h2>
    </div>
    <a href="/usr/concert/list?sort=viewCount" class="btn btn-ghost btn-sm text-xs font-semibold opacity-60 hover:opacity-100">전체 보기 →</a>
  </div>

  <c:choose>
    <c:when test="${empty topByViews}">
      <div class="bg-base-100 border border-base-300 rounded-2xl py-12 text-center">
        <p class="opacity-40 text-sm">아직 공연이 없습니다</p>
      </div>
    </c:when>
    <c:otherwise>
      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
        <c:forEach var="concert" items="${topByViews}">
          <a href="/usr/concert/detail?id=${concert.id}"
             class="group flex flex-col bg-base-100 border border-base-300 rounded-2xl overflow-hidden hover:shadow-xl hover:border-primary/30 transition-all duration-300">
            <div class="relative aspect-[2/3] bg-base-300 overflow-hidden">
              <c:choose>
                <c:when test="${not empty concert.posterImg}">
                  <img src="${concert.posterImg}" alt="${concert.title}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"/>
                </c:when>
                <c:otherwise>
                  <div class="flex items-center justify-center h-full opacity-20"><span class="text-4xl">🎬</span></div>
                </c:otherwise>
              </c:choose>
              <c:if test="${concert.status == 'OPEN'}">
                <div class="absolute top-2 left-2"><span class="badge badge-error badge-sm font-bold text-white">OPEN</span></div>
              </c:if>
              <div class="absolute bottom-2 right-2 bg-black/60 rounded-full px-2 py-0.5 text-white text-xs flex items-center gap-1">
                <i class="fas fa-eye text-xs opacity-70"></i> ${concert.viewCount}
              </div>
            </div>
            <div class="p-3">
              <p class="text-primary text-xs font-bold mb-1">${concert.startDate.substring(0, 10)}</p>
              <h3 class="font-black text-sm leading-snug line-clamp-2 group-hover:text-primary transition-colors">${concert.title}</h3>
            </div>
          </a>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</section>

<%-- 예매율 높은 공연 --%>
<section class="bg-base-100 border-t border-b border-base-300">
  <div class="max-w-screen-xl mx-auto px-4 py-14">
    <div class="flex items-end justify-between mb-8">
      <div>
        <p class="text-xs font-bold text-secondary uppercase tracking-widest mb-1">Hot Booking</p>
        <h2 class="text-2xl sm:text-3xl font-black">예매율 높은 공연 🔥</h2>
      </div>
      <a href="/usr/concert/list?sort=bookingRate" class="btn btn-ghost btn-sm text-xs font-semibold opacity-60 hover:opacity-100">전체 보기 →</a>
    </div>

    <c:choose>
      <c:when test="${empty topByBooking}">
        <div class="border border-base-300 rounded-2xl py-12 text-center">
          <p class="opacity-40 text-sm">데이터가 없습니다</p>
        </div>
      </c:when>
      <c:otherwise>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          <c:forEach var="concert" items="${topByBooking}" varStatus="vs">
            <c:if test="${concert.extra__bookingRate > 0}">
            <a href="/usr/concert/detail?id=${concert.id}"
               class="group flex items-center gap-4 bg-base-200 border border-base-300 rounded-2xl p-4 hover:border-secondary/30 hover:shadow-lg transition-all duration-300">
              <div class="text-2xl font-black text-base-content/20 w-8 shrink-0">${vs.index + 1}</div>
              <div class="w-14 h-14 rounded-xl overflow-hidden bg-base-300 shrink-0">
                <c:choose>
                  <c:when test="${not empty concert.posterImg}">
                    <img src="${concert.posterImg}" alt="${concert.title}" class="w-full h-full object-cover"/>
                  </c:when>
                  <c:otherwise>
                    <div class="flex items-center justify-center h-full opacity-20"><span class="text-2xl">🎬</span></div>
                  </c:otherwise>
                </c:choose>
              </div>
              <div class="flex-1 min-w-0">
                <h4 class="font-black text-sm leading-snug line-clamp-1 group-hover:text-secondary transition-colors">${concert.title}</h4>
                <p class="text-xs text-base-content/40 mt-0.5">${concert.startDate.substring(0, 10)}</p>
              </div>
              <div class="text-right shrink-0">
                <div class="text-secondary font-black text-lg"><fmt:formatNumber value="${concert.extra__bookingRate}" maxFractionDigits="0"/>%</div>
                <div class="text-xs text-base-content/40">예매율</div>
              </div>
            </a>
            </c:if>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</section>

<%-- 전체 공연 --%>
<section class="max-w-screen-xl mx-auto px-4 py-14">
  <div class="flex items-end justify-between mb-8">
    <div>
      <p class="text-xs font-bold text-accent uppercase tracking-widest mb-1">All Concerts</p>
      <h2 class="text-2xl sm:text-3xl font-black">전체 공연</h2>
    </div>
    <a href="/usr/concert/list" class="btn btn-ghost btn-sm text-xs font-semibold opacity-60 hover:opacity-100">전체 보기 →</a>
  </div>

  <c:choose>
    <c:when test="${empty allConcerts}">
      <div class="bg-base-100 border border-base-300 rounded-2xl py-20 text-center">
        <span class="text-4xl block mb-3">🎫</span>
        <p class="font-bold opacity-50">현재 진행 중인 공연이 없습니다</p>
      </div>
    </c:when>
    <c:otherwise>
      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
        <c:forEach var="concert" items="${allConcerts}" varStatus="vs">
          <c:if test="${vs.index < 10}">
          <a href="/usr/concert/detail?id=${concert.id}"
             class="group flex flex-col bg-base-100 border border-base-300 rounded-2xl overflow-hidden hover:shadow-xl hover:border-primary/30 transition-all duration-300">
            <div class="relative aspect-[2/3] bg-base-300 overflow-hidden">
              <c:choose>
                <c:when test="${not empty concert.posterImg}">
                  <img src="${concert.posterImg}" alt="${concert.title}" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500"/>
                </c:when>
                <c:otherwise>
                  <div class="flex items-center justify-center h-full opacity-20"><span class="text-4xl">🎬</span></div>
                </c:otherwise>
              </c:choose>
              <c:if test="${concert.status == 'OPEN'}">
                <div class="absolute top-2 left-2"><span class="badge badge-error badge-sm font-bold text-white">OPEN</span></div>
              </c:if>
            </div>
            <div class="p-3 flex flex-col gap-1">
              <p class="text-primary text-xs font-bold">${concert.startDate.substring(0, 10)}</p>
              <h3 class="font-black text-sm leading-snug line-clamp-2 group-hover:text-primary transition-colors">${concert.title}</h3>
              <c:if test="${concert.extra__avgRating > 0}">
                <p class="text-amber-400 text-xs font-bold">★ ${concert.extra__avgRating}</p>
              </c:if>
            </div>
          </a>
          </c:if>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>
</section>

<%-- 베스트 후기 --%>
<section class="bg-base-100 border-t border-base-300">
  <div class="max-w-screen-xl mx-auto px-4 py-14">
    <div class="flex items-end justify-between mb-8">
      <div>
        <p class="text-xs font-bold text-warning uppercase tracking-widest mb-1">Community</p>
        <h2 class="text-2xl sm:text-3xl font-black">관람 후기</h2>
      </div>
      <a href="/usr/review/list" class="btn btn-ghost btn-sm text-xs font-semibold opacity-60 hover:opacity-100">전체 보기 →</a>
    </div>

    <c:choose>
      <c:when test="${empty bestReviews}">
        <div class="border border-base-300 rounded-2xl py-16 text-center">
          <span class="text-4xl block mb-3">💬</span>
          <p class="font-bold opacity-50">아직 작성된 후기가 없습니다</p>
        </div>
      </c:when>
      <c:otherwise>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          <c:forEach var="review" items="${bestReviews}" varStatus="vs">
            <c:if test="${vs.index < 6}">
            <a href="/usr/review/detail?id=${review.id}"
               class="group bg-base-200 border border-base-300 rounded-2xl p-5 hover:border-warning/30 hover:shadow-lg transition-all duration-300 flex flex-col gap-3">
              <div class="flex items-center justify-between">
                <span class="text-amber-400 font-black text-sm">★ ${review.rating}.0</span>
                <span class="text-xs text-base-content/40">${review.regDate.substring(0, 10)}</span>
              </div>
              <h4 class="font-black text-base leading-snug line-clamp-2 group-hover:text-warning transition-colors">${review.title}</h4>
              <p class="text-xs text-base-content/50 line-clamp-2">${review.body}</p>
              <div class="flex items-center gap-2 mt-auto pt-2 border-t border-base-300">
                <span class="text-xs font-semibold text-base-content/60">${review.extra__writer}</span>
              </div>
            </a>
            </c:if>
          </c:forEach>
        </div>
      </c:otherwise>
    </c:choose>
  </div>
</section>

<%@ include file="../common/foot.jspf"%>
