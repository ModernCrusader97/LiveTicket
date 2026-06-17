<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="pageTitle" value="좌석 선택"></c:set>
<%@ include file="../common/head.jspf"%>

<style>
.seat-btn {
	width: 2.25rem !important; /* w-9와 동일한 크기 */
	height: 2.25rem !important;
	min-height: 2.25rem !important;
	padding: 0 !important;
	display: inline-flex !important;
	align-items: center;
	justify-content: center;
	font-size: 0.75rem;
	border-radius: 0.5rem;
	transition: all 0.2s;
}

.seat-btn.AVAILABLE {
	background-color: transparent !important;
	border: 1px solid #22c55e !important;
	color: #22c55e !important;
}

.seat-btn.AVAILABLE:hover {
	color: white !important;
}

.seat-btn.BLOCKED {
	background-color: transparent !important;
	border: 1px dashed #374151 !important;
	color: #374151 !important;
	cursor: not-allowed !important;
}

/* 임시 점유 상태 */
.seat-btn.PENDING {
	background-color: #fbbd23 !important;
	color: white !important;
	border: none !important;
	cursor: not-allowed !important;
	opacity: 0.6;
}

/* 판매 완료 상태 */
.seat-btn.RESERVED {
	background-color: #4b5563 !important;
	color: #9ca3af !important;
	border: none !important;
	cursor: not-allowed !important;
}

/* 내가 선택한 상태 */
.seat-btn.SELECTED {
	background-color: #570df8 !important;
	color: white !important;
	border: none !important;
	transform: scale(1.1);
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.seat-row {
	display: flex;
	align-items: center;
	justify-content: center;
	margin-bottom: 0.75rem;
	gap: 0.5rem;
}

.row-label {
	width: 30px;
	text-align: center;
	font-weight: bold;
	color: #94a3b8;
	margin-right: 1rem;
}

.aisle {
	width: 25px;
}
</style>
<div class="flex-grow bg-slate-900 rounded-3xl p-8 shadow-2xl border border-slate-700 overflow-x-auto">
	<div class="w-full bg-slate-700 text-slate-400 text-center py-2 rounded-md mb-16 font-bold tracking-[1em]">STAGE</div>

	<div class="seating-area flex flex-col items-center">
		<c:forEach var="zone" items="${seatZones}" varStatus="zoneStatus">
			<div class="text-[10px] text-slate-500 font-mono font-bold self-start mt-3 mb-1" style="margin-left:46px">
				${zone.gradeName} ZONE
			</div>
			<c:forEach var="rowEntry" items="${zone.rows}">
				<div class="seat-row">
					<span class="row-label">${rowEntry.key}</span>

					<c:forEach var="seat" items="${rowEntry.value}" varStatus="colStatus">
						<c:set var="isAvailable" value="${seat.status == 'AVAILABLE'}" />
						<c:set var="isMine" value="${seat.status == 'PENDING' && seat.memberId == loginedMemberId}" />
						<c:choose>
							<c:when test="${isAvailable || isMine}">
								<button type="button" id="seat-${seat.id}"
								    class="seat-btn ${isMine ? 'SELECTED' : 'AVAILABLE'}"
									data-id="${seat.id}" data-version="${seat.version}"
									data-row="${seat.rowName}" data-col="${seat.colNumber}"
									data-grade="${seat.extra__gradeName}" data-price="${seat.extra__price}"
									onclick="toggleSeat(this, ${seat.id}, '${seat.rowName}', ${seat.colNumber}, '${seat.extra__gradeName}', ${seat.extra__price}, ${seat.version})">
									${seat.colNumber}</button>
							</c:when>
							<c:otherwise>
								<button type="button" class="seat-btn ${seat.status}" disabled>
									<c:choose>
										<c:when test="${seat.status == 'RESERVED'}">✕</c:when>
										<c:when test="${seat.status == 'BLOCKED'}"></c:when>
										<c:otherwise>⏳</c:otherwise>
									</c:choose>
								</button>
							</c:otherwise>
						</c:choose>

						<%-- 통로 구현 --%>
						<c:if test="${seat.colNumber == 5 || seat.colNumber == 10}">
							<div class="aisle"></div>
						</c:if>
					</c:forEach>
				</div>
			</c:forEach>
			<c:if test="${!zoneStatus.last}">
				<div class="w-full my-2" style="border-top: 1px solid rgba(71,85,105,0.4);"></div>
			</c:if>
		</c:forEach>
	</div>

</div>

<div class="flex flex-wrap justify-center gap-4 mt-10 text-xs" id="grade-legend"></div>
<div class="flex flex-wrap justify-center gap-5 mt-4 text-xs text-slate-400">
	<div class="flex items-center gap-1.5"><span class="w-3.5 h-3.5 rounded bg-primary"></span>내가 선택</div>
	<div class="flex items-center gap-1.5"><span class="w-3.5 h-3.5 rounded bg-yellow-500"></span>임시 점유</div>
	<div class="flex items-center gap-1.5"><span class="w-3.5 h-3.5 rounded bg-gray-600"></span>판매 완료</div>
</div>

<script>
(function() {
    const GRADE_PALETTES = [
        { border:'#22d3ee', text:'#22d3ee', hover:'rgba(34,211,238,0.85)' },
        { border:'#a855f7', text:'#a855f7', hover:'rgba(168,85,247,0.85)' },
        { border:'#f59e0b', text:'#f59e0b', hover:'rgba(245,158,11,0.85)' },
        { border:'#f87171', text:'#f87171', hover:'rgba(248,113,113,0.85)' },
        { border:'#34d399', text:'#34d399', hover:'rgba(52,211,153,0.85)'  },
    ];

    const grades = [];
    document.querySelectorAll('.seat-btn[data-grade]').forEach(btn => {
        const g = btn.dataset.grade;
        if (g && !grades.includes(g)) grades.push(g);
    });

    document.querySelectorAll('.seat-btn.AVAILABLE, .seat-btn.SELECTED').forEach(btn => {
        const idx = grades.indexOf(btn.dataset.grade);
        if (idx < 0) return;
        const p = GRADE_PALETTES[idx % GRADE_PALETTES.length];
        btn.style.borderColor = p.border;
        btn.style.color = p.text;
        btn.dataset.hoverColor = p.hover;
        btn.addEventListener('mouseenter', function() {
            if (this.classList.contains('AVAILABLE')) {
                this.style.backgroundColor = p.hover;
                this.style.color = '#fff';
            }
        });
        btn.addEventListener('mouseleave', function() {
            if (this.classList.contains('AVAILABLE') && !this.classList.contains('SELECTED')) {
                this.style.backgroundColor = 'transparent';
                this.style.color = p.text;
            }
        });
    });

    const legend = document.getElementById('grade-legend');
    grades.forEach((g, idx) => {
        const p = GRADE_PALETTES[idx % GRADE_PALETTES.length];
        legend.innerHTML += `<div class="flex items-center gap-1.5">
            <span class="w-3.5 h-3.5 rounded border" style="border-color:${p.border};background:transparent"></span>
            <span style="color:${p.text}">${g}</span>
        </div>`;
    });
})();
</script>
</div>

<div class="w-full lg:w-96">
	<div class="card bg-base-100 shadow-2xl border border-gray-200 sticky top-10">
		<div class="card-body p-6">
			<h2 class="card-title text-2xl font-black flex justify-between items-center">
				선택한 좌석
				<div class="badge badge-secondary" id="selected-count-badge">0</div>
			</h2>

			<div class="divider my-2"></div>

			<div id="selected-list" class="min-h-[200px] py-4 space-y-3">
				<p class="text-gray-400 text-center mt-12">
					배치도에서 좌석을
					<br>
					클릭해주세요.
				</p>
			</div>

			<div class="divider my-2"></div>

			<div class="flex justify-between items-center mb-6">
				<span class="font-bold text-gray-500">총 결제 금액</span>
				<span id="total-price" class="text-3xl font-black text-primary">0원</span>
			</div>

			<form action="doHold" method="POST" onsubmit="return submitHoldForm(this);">
				<input type="hidden" name="scheduleId" value="${param.scheduleId}">
				<input type="hidden" name="seatIds" id="hiddenSeatIds">

				<button id="submit-btn" class="btn btn-primary btn-lg w-full shadow-lg" disabled>
					<span id="btn-text">좌석을 선택해주세요</span>
				</button>
			</form>

			<div class="mt-4 text-xs text-gray-400 text-center">* 좌석 점유 후 5분 내 미결제 시 자동 취소됩니다.</div>
		</div>
	</div>
</div>

</div>
</div>
</section>

<script>
    // 서버에서 전달받은 값 세팅
    const MAX_LIMIT = ${maxLimit}; // 1인당 총 예매 제한 (4)
    const ALREADY_COUNT = ${alreadyReservedCount}; // 내가 이미 산 티켓 수
    let selectedSeats = []; // 현재 페이지에서 선택한 좌석들

    function toggleSeat(btn, id, row, col, grade, price, version){
        const index = selectedSeats.findIndex(s => s.id === id);

        if (index > -1) {
            // 1. 이미 선택된 경우 -> 해제
            selectedSeats.splice(index, 1);
            btn.classList.remove('SELECTED');
            btn.classList.add('AVAILABLE');
        } else {
            // 2. 새로 선택하는 경우 -> 제한 체크
            if (ALREADY_COUNT + selectedSeats.length >= MAX_LIMIT) {
                alert(`인당 최대 \${MAX_LIMIT}매까지만 예매 가능합니다.\n(회원님은 이미 \${ALREADY_COUNT}매를 예매하셨습니다.)`);
                return;
            }
            
            selectedSeats.push({ id, row, col, grade, price, version });
            btn.classList.remove('AVAILABLE');
            btn.classList.add('SELECTED');
        }

        renderUI();
    }

    function renderUI() {
        const listEl = document.getElementById('selected-list');
        const priceEl = document.getElementById('total-price');
        const badgeEl = document.getElementById('selected-count-badge');
        const btn = document.getElementById('submit-btn');
        const btnText = document.getElementById('btn-text');

        if (selectedSeats.length === 0) {
            listEl.innerHTML = '<p class="text-gray-400 text-center mt-12">배치도에서 좌석을<br>클릭해주세요.</p>';
            priceEl.innerText = '0원';
            badgeEl.innerText = '0';
            btn.disabled = true;
            btnText.innerText = '좌석을 선택해주세요';
            return;
        }

        // 목록 생성
        let html = '';
        let total = 0;
        selectedSeats.forEach(s => {
            html += `
                <div class="flex justify-between items-center bg-slate-50 p-3 rounded-lg border border-slate-100 animate__animated animate__fadeIn">
                    <div>
                        <span class="text-xs font-bold text-primary block">\${s.grade}석</span>
                        <span class="font-bold">\${s.row}열 \${s.col}번</span>
                    </div>
                    <span class="font-bold text-slate-700">\${s.price.toLocaleString()}원</span>
                </div>
            `;
            total += s.price;
        });

        listEl.innerHTML = html;
        priceEl.innerText = total.toLocaleString() + '원';
        badgeEl.innerText = selectedSeats.length;
        btn.disabled = false;
        btnText.innerText = `\${selectedSeats.length}석 점유 및 결제하기`;
    }

    function submitHoldForm(form) {
        const data = selectedSeats.map(s => `\${s.id}:\${s.version}`).join(',');
        document.getElementById('hiddenSeatIds').value = data;
        return true;
    }
    window.onload = function(event) {
    	window.onpageshow = function(event) {
    	    if (event.persisted || (window.performance && window.performance.navigation.type == 2)) {
    	        window.location.reload();
    	    }
    	};
    	document.querySelectorAll('.seat-btn.SELECTED').forEach(btn => {
            const id = parseInt(btn.dataset.id);
            const row = btn.dataset.row;
            const col = parseInt(btn.dataset.col);
            const grade = btn.dataset.grade;
            const price = parseInt(btn.dataset.price);
            const version = parseInt(btn.dataset.version);

            selectedSeats.push({ id, row, col, grade, price, version });
        });

        renderUI();
        
    };
</script>

<%@ include file="../common/foot.jspf"%>