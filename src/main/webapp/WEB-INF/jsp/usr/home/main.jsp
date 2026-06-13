<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="홈"/>
<%@ include file="../common/head.jspf"%>

<%-- Hero --%>
<section class="relative overflow-hidden bg-gradient-to-br from-base-100 via-base-200 to-base-100 border-b border-base-300">
  <div class="absolute inset-0 opacity-10"
       style="background-image:radial-gradient(circle at 30% 50%, oklch(var(--p)) 0%, transparent 60%), radial-gradient(circle at 80% 20%, oklch(var(--s)) 0%, transparent 50%);"></div>
  <div class="relative max-w-screen-xl mx-auto px-4 py-20 sm:py-28 flex flex-col items-center text-center gap-6">
    <div class="badge badge-primary badge-outline font-bold tracking-widest text-xs px-4 py-2">LIVE TICKET</div>
    <h1 class="text-4xl sm:text-6xl font-black leading-tight tracking-tight">
      지금 이 순간,<br/>
      <span class="text-primary">무대</span>를 경험하세요
    </h1>
    <p class="text-base-content/50 text-base sm:text-lg max-w-md">
      국내 최고의 공연을 한 곳에서. 간편하게 예매하고 설레는 순간을 즐기세요.
    </p>
    <div class="flex gap-3 mt-2">
      <a href="/usr/concert/list" class="btn btn-primary btn-lg rounded-xl px-8 font-black">공연 목록 보기</a>
      <a href="/usr/review/list" class="btn btn-ghost btn-lg rounded-xl font-semibold">커뮤니티</a>
    </div>
  </div>
</section>

<%-- 공연 목록 --%>
<section class="max-w-screen-xl mx-auto px-4 py-14">
  <div class="flex items-end justify-between mb-8">
    <div>
      <p class="text-xs font-bold text-primary uppercase tracking-widest mb-1">Now On Stage</p>
      <h2 class="text-2xl sm:text-3xl font-black">현재 진행 중인 공연</h2>
    </div>
    <a href="/usr/concert/list" class="btn btn-ghost btn-sm text-xs font-semibold opacity-60 hover:opacity-100">전체 보기 →</a>
  </div>

  <c:choose>
    <c:when test="${empty concerts}">
      <div class="bg-base-100 border border-base-300 rounded-2xl py-20 text-center">
        <span class="text-4xl block mb-3">🎫</span>
        <p class="font-bold opacity-50">현재 진행 중인 공연이 없습니다</p>
      </div>
    </c:when>
    <c:otherwise>
      <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4 sm:gap-6">
        <c:forEach var="concert" items="${concerts}" varStatus="vs">
          <c:if test="${vs.index < 10}">
          <a href="/usr/concert/detail?id=${concert.id}"
             class="group flex flex-col bg-base-100 border border-base-300 rounded-2xl overflow-hidden hover:shadow-xl hover:border-primary/30 transition-all duration-300">
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
                  <span class="badge badge-error badge-sm font-bold text-white">OPEN</span>
                </div>
              </c:if>
              <c:if test="${concert.viewCount > 0}">
                <div class="absolute bottom-2 right-2 bg-black/60 rounded-full px-2 py-0.5 text-white text-xs font-bold flex items-center gap-1">
                  <i class="fas fa-eye text-xs opacity-80"></i> ${concert.viewCount}
                </div>
              </c:if>
            </div>
            <div class="p-3 flex flex-col gap-1">
              <p class="text-primary text-xs font-bold">${concert.startDate.substring(0, 10)}</p>
              <h3 class="font-black text-sm leading-snug line-clamp-2 group-hover:text-primary transition-colors">${concert.title}</h3>
              <c:if test="${concert.extra__avgRating > 0}">
                <p class="text-amber-400 text-xs font-bold">★ ${concert.extra__avgRating} <span class="text-base-content/40 font-normal">(${concert.reviewCount})</span></p>
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
        <p class="text-xs font-bold text-secondary uppercase tracking-widest mb-1">Community</p>
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
               class="group bg-base-200 border border-base-300 rounded-2xl p-5 hover:border-secondary/30 hover:shadow-lg transition-all duration-300 flex flex-col gap-3">
              <div class="flex items-center justify-between">
                <span class="text-amber-400 font-black text-sm">★ ${review.rating}.0</span>
                <span class="text-xs text-base-content/40">${review.regDate.substring(0, 10)}</span>
              </div>
              <h4 class="font-black text-base leading-snug line-clamp-2 group-hover:text-secondary transition-colors">${review.title}</h4>
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
