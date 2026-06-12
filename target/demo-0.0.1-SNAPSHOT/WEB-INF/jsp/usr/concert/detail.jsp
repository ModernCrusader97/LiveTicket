<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

<c:set var="pageTitle" value="공연 상세 정보"></c:set>

<%@ include file="../common/head.jspf"%>

<div
	class="w-full bg-base-200 text-base-content min-h-screen py-10 antialiased font-sans transition-colors duration-200">
	<div class="container mx-auto px-4 max-w-screen-2xl">

		<div class="grid grid-cols-1 lg:grid-cols-4 gap-8 items-start w-full">

			<div class="lg:col-span-3 w-full space-y-6">

				<div
					class="card bg-base-100 p-6 md:p-8 rounded-2xl border border-base-300 shadow-sm flex flex-col sm:flex-row gap-8">

					<div
						class="w-48 h-64 bg-base-300 rounded-xl border border-base-300 shrink-0 flex items-center justify-center overflow-hidden shadow-md mx-auto sm:mx-0">
						<c:choose>
							<c:when test="${not empty concert.posterImg && concert.posterImg != ''}">
								<img src="${concert.posterImg}" alt="포스터" class="w-full h-full object-cover" />
							</c:when>
							<c:otherwise>
								<div class="text-center opacity-40">
									<span class="text-4xl block mb-2">🎬</span>
									<span class="text-xs font-bold">포스터 등록전</span>
								</div>
							</c:otherwise>
						</c:choose>
					</div>

					<div class="flex-1 flex flex-col justify-between py-1 text-center sm:text-left">
						<div>
							<%-- ⭐ 1. 상단 예매 상태 및 카운트다운 컨테이너 --%>
							<div class="mb-2 flex items-center gap-3" id="booking-status-area">
								<c:choose>
									<c:when test="${isBookingOpen}">
										<span class="badge badge-error text-white font-bold text-xs rounded px-2.5 py-1">티켓오픈</span>
									</c:when>
									<c:otherwise>
										<span class="badge badge-neutral text-white font-bold text-xs rounded px-2.5 py-1">예매 오픈 전</span>
										<span class="text-error font-black text-xs tracking-wider animate-pulse" id="countdown-display"></span>
									</c:otherwise>
								</c:choose>
							</div>
							<h1 class="text-2xl md:text-3xl font-black mb-4 leading-tight">${concert.title}</h1>

							<div class="space-y-2.5 text-sm md:text-base text-base-content/80 max-w-xl mx-auto sm:mx-0">
								<div class="flex items-center gap-4">
									<span class="w-20 font-bold opacity-50 shrink-0 text-left">공연일시</span>
									<span class="font-semibold">${concert.performDate.substring(0, 16)}</span>
								</div>
								<div class="flex items-start gap-4">
									<span class="w-20 font-bold opacity-50 shrink-0 text-left">예매기간</span>
									<span class="font-semibold leading-relaxed">${concert.startDate.substring(0, 16)}
										<br class="sm:hidden" />
										~ ${concert.endDate.substring(0, 16)}
									</span>
								</div>
							</div>
						</div>

						<div class="border-t border-base-300 pt-4 mt-5">
							<div class="text-xs font-bold opacity-50 uppercase tracking-wider mb-2">등급별 기본 가격</div>
							<div class="flex flex-wrap justify-center sm:justify-start gap-x-6 gap-y-1 text-sm">
								<c:forEach var="seat" items="${remainSeats}">
									<div>
										<span class="font-bold text-primary">${seat.gradeName}석</span>
										${seat.price}원
									</div>
								</c:forEach>
							</div>
						</div>
					</div>
				</div>

				<div role="tablist"
					class="tabs tabs-bordered w-full bg-base-100 rounded-2xl border border-base-300 p-6 md:p-8 shadow-sm">

					<input type="radio" name="interpark_tabs" role="tab"
						class="tab font-bold text-sm md:text-base whitespace-nowrap pb-3 text-base-content" aria-label="공연정보" checked />
					<div role="tabpanel" class="tab-content bg-base-100 pt-6 space-y-6">

						<div>
							<h3 class="text-lg md:text-xl font-black mb-4">Cast Lineup</h3>
							<div class="flex flex-wrap gap-6 p-6 bg-base-200 rounded-xl border border-base-300">
								<c:choose>
									<c:when test="${not empty artists}">
										<c:forEach var="artist" items="${artists}">
											<div class="text-center w-24">
												<div class="w-20 h-20 rounded-full mx-auto bg-base-300 border-2 border-base-100 shadow overflow-hidden">
													<img src="${artist.profileImg}" alt="${artist.name}" class="w-full h-full object-cover" />
												</div>
												<div class="text-sm font-bold mt-2 truncate">${artist.roleName}</div>
												<div class="text-xs opacity-50 truncate">${artist.name}</div>
											</div>
										</c:forEach>
									</c:when>
									<c:otherwise>
										<div class="w-full text-center py-6 bg-base-200 rounded-xl border border-base-300 shadow-inner">
											<span class="text-sm opacity-40 font-medium">💡 등록된 메인 출연진 정보가 없습니다.</span>
										</div>
									</c:otherwise>
								</c:choose>
							</div>
						</div>

						<div>
							<h3 class="text-lg md:text-xl font-black mb-3">공연 설명</h3>
							<div class="p-6 bg-base-200 rounded-xl border border-base-300 leading-relaxed text-sm md:text-base min-h-[150px]">
								${concert.body}</div>
						</div>
					</div>

					<input type="radio" name="interpark_tabs" role="tab"
						class="tab font-bold text-sm md:text-base whitespace-nowrap pb-3 text-base-content" aria-label="캐스팅정보" />
					<div role="tabpanel" class="tab-content bg-base-100 pt-6">
						<div
							class="text-xs md:text-sm text-primary bg-primary/10 p-4 rounded-xl border border-primary/20 mb-5 font-medium">
							💡 출연진 및 회차 일정은 제작사 사정에 따라 사전 공지 없이 변경될 수 있습니다.</div>
						<div class="overflow-x-auto border border-base-300 rounded-xl shadow-sm">
							<table class="table w-full text-center text-sm md:text-base">
								<thead>
									<tr class="bg-base-200 font-bold border-b border-base-300 text-xs md:text-sm">
										<th class="py-3.5">관람일</th>
										<th class="py-3.5">시간</th>
										<th class="py-3.5">출연 라인업</th>
									</tr>
								</thead>
								<tbody class="divide-y divide-base-200">
									<c:forEach var="s" items="${schedules}">
										<tr class="hover:bg-base-200/50">
											<td class="font-bold text-primary py-4">${s.performDate.substring(5, 10)}</td>
											<td>${s.performDate.substring(11, 16)}</td>
											<td class="text-left font-medium pl-6 md:pl-10">
												<c:choose>
													<c:when test="${not empty allScheduleData[s.id].artists}">
														<c:forEach var="artist" items="${allScheduleData[s.id].artists}" varStatus="status">
															${artist.name}(${artist.roleName})${!status.last ? ', ' : ''}
														</c:forEach>
													</c:when>
													<c:otherwise>
														<span class="opacity-40 text-xs">등록된 출연진이 없습니다.</span>
													</c:otherwise>
												</c:choose>
											</td>
										</tr>
									</c:forEach>
									<c:if test="${empty schedules}">
										<tr>
											<td colspan="3" class="py-8 text-center opacity-40 text-sm">등록된 공연 회차가 없습니다.</td>
										</tr>
									</c:if>
								</tbody>
							</table>
						</div>
					</div>
					<input type="radio" name="interpark_tabs" role="tab"
						class="tab font-bold text-sm md:text-base whitespace-nowrap pb-3 text-base-content"
						aria-label="관람후기 (${reviews.size()})" />
					<div role="tabpanel" class="tab-content bg-base-100 pt-6">
						<div class="flex items-center gap-6 p-6 bg-base-200 rounded-xl border border-base-300 mb-6">
							<div class="text-center shrink-0 bg-base-100 px-5 py-3 rounded-xl border border-base-300 shadow-sm">
								<div class="text-xs opacity-50 font-bold mb-0.5">평균평점</div>
								<div class="text-3xl md:text-4xl font-black text-primary">${concert.extra__avgRating}</div>
							</div>
							<div class="text-xs md:text-sm opacity-60 space-y-1.5 leading-relaxed">
								<p>• 클린한 게시판 규정에 어긋나는 욕설, 비방성 글은 블라인드 처리될 수 있습니다.</p>
								<p class="text-error font-semibold">• 티켓의 양도 및 거래 관련 글은 적발 시 사후 무통보 삭제 처리됩니다.</p>
							</div>
						</div>

						<div class="flex justify-between items-center mb-4">
							<h3 class="text-base md:text-lg font-black">
								전체 후기
								<span class="text-primary font-bold">${reviews.size()}개</span>
							</h3>
							<a href="../review/write?concertId=${concert.id}&type=REVIEW"
								class="btn btn-primary btn-sm md:btn-md rounded-lg px-4">후기 작성하기</a>
						</div>

						<div class="divide-y divide-base-200 border-t border-b border-base-300">
							<c:forEach var="review" items="${reviews}">
								<div class="py-4 hover:bg-base-200/30 px-3 transition-colors">
									<div class="flex justify-between items-center text-xs opacity-50 mb-1.5">
										<div class="flex items-center gap-3">
											<span class="badge bg-base-200 border-none font-bold">#${review.id}</span>
											<span class="font-bold text-base-content">${review.extra__writer}</span>
											<span class="text-amber-500 font-black">★ ${review.rating}.0</span>
										</div>
										<span>${review.regDate.substring(0, 10)}</span>
									</div>
									<a href="../review/detail?id=${review.id}"
										class="font-bold text-sm md:text-base hover:text-primary transition-colors block"> ${review.title} </a>
								</div>
							</c:forEach>
							<c:if test="${empty reviews}">
								<div class="py-12 text-center opacity-40 text-sm md:text-base">작성된 관람후기가 없습니다. 첫 후기를 남겨보세요!</div>
							</c:if>
						</div>
					</div>

					<input type="radio" name="interpark_tabs" role="tab"
						class="tab font-bold text-sm md:text-base whitespace-nowrap pb-3 text-base-content"
						aria-label="기대평 (${expects.size()})" />
					<div role="tabpanel" class="tab-content bg-base-100 pt-6">
						<div class="flex justify-between items-center mb-4">
							<h3 class="text-base md:text-lg font-black">
								공연 기대평
								<span class="text-secondary font-bold">${expects.size()}개</span>
							</h3>
							<a href="../review/write?concertId=${concert.id}&type=EXPECT"
								class="btn btn-sm btn-outline btn-secondary rounded-lg px-4 h-9">기대평 쓰기</a>
						</div>
						<div class="divide-y divide-base-200 border-t border-b border-base-300">
							<c:forEach var="expect" items="${expects}">
								<div class="py-4 hover:bg-base-200/30 px-3 transition-colors">
									<div class="flex justify-between items-center text-xs opacity-50 mb-1.5">
										<span class="font-bold">${expect.extra__writer}</span>
										<span>${expect.regDate.substring(0, 10)}</span>
									</div>
									<a href="../review/detail?id=${expect.id}" class="font-bold text-sm md:text-base hover:text-secondary block">
										${expect.title} </a>
								</div>
							</c:forEach>
							<c:if test="${empty expects}">
								<div class="py-12 text-center opacity-40 text-sm md:text-base">공연을 기다리는 설레는 마음을 적어주세요!</div>
							</c:if>
						</div>
					</div>
				</div>
			</div>

			<div class="lg:col-span-1 w-full lg:sticky lg:top-6">
				<div class="card bg-base-100 border border-base-300 shadow-md overflow-hidden rounded-2xl">
					<div class="p-4 space-y-4">

						<div>
							<div class="font-black text-xs mb-2 border-b border-base-200 pb-2">관람일 선택</div>
							<div id="calendar-view" class="grid grid-cols-7 gap-1 text-center"></div>
						</div>

						<div>
							<div class="font-black text-xs mb-2 border-b border-base-200 pb-2">회차 선택</div>
							<div id="time-list-container" class="space-y-1">
								<p class="text-xs text-center opacity-40 py-4">날짜를 먼저 선택해주세요.</p>
							</div>
						</div>

						<div>
							<div class="font-black text-xs mb-2 border-b border-base-200 pb-2">등급별 잔여석</div>
							<div id="seat-info-container" class="space-y-1 min-h-[60px]">
								<p class="text-xs text-center opacity-40 py-4">회차를 선택해주세요.</p>
							</div>
						</div>

						<div id="mini-casting-container"></div>

						<form action="../reservation/seatMap" method="GET">
							<input type="hidden" id="selected-schedule-id" name="concertId" value="" />
							<button type="submit" id="btn-booking" class="btn btn-primary w-full rounded-xl" disabled>예매하기 (좌석 선택)</button>
						</form>
					</div>
				</div>
			</div>
			
			<script>
// ⭐ Global 예매 가능 플래그 및 시작 시간 세팅
let isBookingOpen = ${isBookingOpen};
const bookingStartAtStr = "${concert.bookingStartAt}"; // 형식: "yyyy-MM-dd HH:mm:ss"

const concertSchedules = [
    <c:forEach var="item" items="${schedules}" varStatus="status">
    { id: ${item.id}, date: "${item.performDate}".split(" ")[0], time: "${item.performDate}".split(" ")[1].substring(0, 5) }${!status.last ? ',' : ''}
    </c:forEach>
];

const firstDateStr = concertSchedules.length > 0 ? concertSchedules[0].date : new Date().toISOString().split('T')[0];
let currentMonth = new Date(firstDateStr);
currentMonth.setDate(1);

function renderCalendar(date) {
    const year = date.getFullYear();
    const month = date.getMonth();
    const $calendar = $("#calendar-view");
    $calendar.empty();

    const monthStr = (month + 1 < 10 ? '0' : '') + (month + 1);
    $calendar.append('<div class="col-span-7 flex justify-between items-center mb-4 px-2 font-bold">' +
        '<button type="button" onclick="changeMonth(-1)">＜</button>' +
        '<span>' + year + '. ' + monthStr + '</span>' +
        '<button type="button" onclick="changeMonth(1)">＞</button>' +
    '</div>');

    ['일', '월', '화', '수', '목', '금', '토'].forEach(d => $calendar.append('<div class="text-xs opacity-50">' + d + '</div>'));

    const firstDay = new Date(year, month, 1).getDay();
    const lastDate = new Date(year, month + 1, 0).getDate();

    for (let i = 0; i < firstDay; i++) $calendar.append('<div></div>');

    for (let d = 1; d <= lastDate; d++) {
        const mm = (month + 1 < 10 ? '0' : '') + (month + 1);
        const dd = (d < 10 ? '0' : '') + d;
        const dateStr = year + '-' + mm + '-' + dd;
        const hasSchedule = concertSchedules.some(s => s.date === dateStr);
        
        const btnClass = hasSchedule 
            ? "btn btn-xs btn-ghost border border-base-300 hover:bg-primary hover:text-white" 
            : "btn btn-xs btn-ghost opacity-20 cursor-default";
        
        const onClick = hasSchedule ? 'onclick="onDateSelect(\'' + dateStr + '\')"' : "";
        $calendar.append('<button type="button" class="' + btnClass + '" ' + onClick + '>' + d + '</button>');
    }
}

function changeMonth(diff) {
    currentMonth.setMonth(currentMonth.getMonth() + diff);
    renderCalendar(currentMonth);
}

function onDateSelect(selectedDate) {
    const $container = $("#time-list-container");
    $container.empty();
    
    concertSchedules.filter(s => s.date === selectedDate).forEach(s => {
        $container.append('<button type="button" class="btn-schedule btn btn-sm w-full btn-outline mb-1" data-id="' + s.id + '">' + s.time + '</button>');
    });
}

const allScheduleData = ${allScheduleDataJson};

$(document).on("click", ".btn-schedule", function() {
    const id = $(this).data("id");
    const data = allScheduleData[id];

    if (data) {
        let html = "";
        data.remainSeats.forEach(s => {
            html += '<div class="flex justify-between text-xs p-2 bg-base-200 rounded-lg">' +
                    '<span>' + (s.extra__gradeName || '등급') + '석</span>' +
                    '<span>' + (s.extra__price ? s.extra__price.toLocaleString() : 0) + '원</span>' +
                    '</div>';
        });
        $("#seat-info-container").html(html);
        
        let castHtml = '<div class="text-xs mt-2 p-2 bg-base-200 rounded-lg">Cast: ' + data.artists.map(a => a.name).join(", ") + '</div>';
        $("#mini-casting-container").html(castHtml);
        
        $("#selected-schedule-id").val(id);
        
        // ⭐ 예매 활성화 분기처리: 예매오픈인 상태에서만 버튼 활성화
        if (isBookingOpen) {
            $("#btn-booking").prop("disabled", false);
            $("#btn-booking").text("예매하기 (좌석 선택)");
        } else {
            $("#btn-booking").prop("disabled", true);
            $("#btn-booking").text("예매 오픈 대기 중");
        }
    }
});

// ⭐ 2. 실시간 카운트다운 및 자동 오픈 엔진 엔진 함수
function initBookingCountdown() {
    if (isBookingOpen || !bookingStartAtStr) return;

    // IOS/사파리 호환성을 위해 대시(-)를 슬래시(/)로 치환 후 Date 변환
    const targetTime = new Date(bookingStartAtStr.replace(/-/g, '/'));

    const countdownInterval = setInterval(function() {
        const now = new Date();
        const diff = targetTime - now;

        // ⏱️ 오픈 시간이 도달했거나 경과한 경우 정각 자동 오픈 처리
        if (diff <= 0) {
            clearInterval(countdownInterval);
            isBookingOpen = true;

            // 1) 상단 배지 즉시 "티켓오픈"으로 전환
            $("#booking-status-area").html('<span class="badge badge-error text-white font-bold text-xs rounded px-2.5 py-1">티켓오픈</span>');

            // 2) 만약 사용자가 이미 날짜/회차를 클릭해서 선택해 둔 상태라면 예매 버튼 즉시 활성화
            if ($("#selected-schedule-id").val()) {
                $("#btn-booking").prop("disabled", false);
                $("#btn-booking").text("예매하기 (좌석 선택)");
            }
            return;
        }

        // 남은 시/분/초 변환 계산
        const days = Math.floor(diff / (1000 * 60 * 60 * 24));
        const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
        const seconds = Math.floor((diff % (1000 * 60)) / 1000);

        // 상단 카운트다운 텍스트 포맷팅
        let timerText = "⏱️ 예매 오픈까지 ";
        if (days > 0) timerText += days + "일 ";
        timerText += (hours < 10 ? "0" : "") + hours + ":" + 
                     (minutes < 10 ? "0" : "") + minutes + ":" + 
                     (seconds < 10 ? "0" : "") + seconds;

        $("#countdown-display").text(timerText);

        // 사용자가 날짜/회차를 선택하고 대기 중일 때 버튼 내부 텍스트에도 실시간 남은 시간 표시 가이드
        if ($("#selected-schedule-id").val() && !isBookingOpen) {
            $("#btn-booking").text("오픈 대기 중 (" + (hours < 10 ? "0" : "") + hours + ":" + (minutes < 10 ? "0" : "") + minutes + ":" + (seconds < 10 ? "0" : "") + seconds + ")");
        }
    }, 1000);
}

$(document).ready(() => {
    renderCalendar(currentMonth);
    initBookingCountdown(); // ⭐ 페이지 로드 즉시 카운트다운 작동
});
</script>
		</div>
	</div>

	<%@ include file="../common/foot.jspf"%>