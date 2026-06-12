<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="pageTitle" value="예매 가능한 공연 목록"></c:set>

<%@ include file="../common/head.jspf"%>

<div
	class="w-full bg-base-200 text-base-content min-h-screen py-12 antialiased font-sans transition-colors duration-200">
	<div class="container mx-auto px-4 max-w-7xl">

		<!-- 페이지 메인 타이틀 섹션 -->
		<div
			class="border-b border-base-300 pb-6 mb-10 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
			<div>
				<h2 class="text-2xl md:text-3xl font-black tracking-tight">티켓 오픈 안내</h2>
				<p class="text-sm opacity-50 mt-1.5">현재 라이브티켓에서 예매 가능한 진행 중인 공연 라인업입니다.</p>
			</div>
			<div class="text-sm font-semibold opacity-70 bg-base-100 px-4 py-2 rounded-xl border border-base-300 shadow-xs">
				총
				<span class="text-primary font-black">${concerts.size()}</span>
				개의 공연
			</div>
		</div>

		<!-- 공연 리스트 카드 그리드 영역 -->
		<c:choose>
			<c:when test="${empty concerts}">
				<div class="bg-base-100 border border-base-300 rounded-2xl py-24 text-center shadow-sm">
					<span class="text-5xl block mb-4">🎫</span>
					<h3 class="text-lg font-bold">현재 대기 중인 공연이 없습니다</h3>
					<p class="text-sm opacity-40 mt-1">새로운 멋진 공연으로 곧 찾아뵙겠습니다. 기대해 주세요!</p>
				</div>
			</c:when>

			<c:otherwise>
				<div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6 gap-6 w-full items-stretch">

					<c:forEach var="concert" items="${concerts}">
						<a href="../concert/detail?id=${concert.id}"
							class="group flex flex-col h-full bg-base-100 border border-base-300 rounded-3xl shadow-sm hover:shadow-2xl transition-all duration-300 overflow-hidden">

							<div class="relative w-full aspect-[2/3] rounded-t-3xl overflow-hidden flex-shrink-0 bg-base-300">
								<c:choose>
									<c:when test="${not empty concert.posterImg && concert.posterImg != ''}">
										<img src="${concert.posterImg}" alt="${concert.title}"
											class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" />
									</c:when>
									<c:otherwise>
										<div class="flex flex-col items-center justify-center h-full text-base-content/40">
											<span class="text-6xl mb-4">🎬</span>
											<span class="font-bold uppercase tracking-widest">NO POSTER</span>
										</div>
									</c:otherwise>
								</c:choose>
							</div>

							<div class="p-6 flex flex-col flex-grow">
								<div class="text-primary font-bold text-sm mb-2">${concert.startDate.substring(5, 10).replace("-", ".")}</div>
								<h3 class="font-black text-xl leading-snug mb-2 group-hover:text-primary transition-colors line-clamp-2">
									${concert.title}</h3>
								<div class="text-sm opacity-60 font-medium mt-auto">일반예매</div>
							</div>
						</a>
					</c:forEach>
				</div>
			</c:otherwise>
		</c:choose>

	</div>
</div>

<%@ include file="../common/foot.jspf"%>