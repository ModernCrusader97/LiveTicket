<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="리뷰 작성"></c:set>
<%@ include file="../common/head.jspf"%>

<section class="mt-8 px-4 pb-20">
	<div class="max-w-3xl mx-auto">
		<form action="doWrite" method="POST" onsubmit="return submitWriteForm(this);">
			<input type="hidden" name="type" value="${param.type}">
			<input type="hidden" name="concertId" id="selectedConcertId">
			<input type="hidden" name="orderId" id="selectedOrderId">

			<div class="bg-white rounded-3xl shadow-xl p-8 border border-gray-100">
				<div class="flex items-center gap-4 mb-8 pb-8 border-b border-dashed">
					<div class="w-16 h-16 bg-primary/10 rounded-2xl flex items-center justify-center text-primary text-2xl font-black">
						${param.type == 'REVIEW' ? 'R' : 'E'}</div>
					<div>
						<h2 class="text-2xl font-black">${param.type == 'REVIEW' ? '실관람 후기 작성' : '공연 기대평 작성'}</h2>
						<p class="text-gray-400 text-sm">리뷰 대상을 먼저 선택해주세요.</p>
					</div>
				</div>

				<div class="form-control mb-6">
					<label class="label">
						<span class="label-text font-bold text-lg">리뷰 대상 공연</span>
					</label>
					<div class="flex gap-2">
						<input type="text" id="displayConcertTitle" readonly placeholder="우측 버튼을 눌러 공연을 선택하세요"
							class="input input-bordered w-full bg-gray-50 cursor-default" />
						<button type="button" onclick="choice_modal.showModal()" class="btn btn-neutral">선택하기</button>
					</div>
				</div>

				<c:if test="${param.type == 'REVIEW'}">
					<div class="form-control mb-6">
						<label class="label">
							<span class="label-text font-bold">평점</span>
						</label>
						<div class="rating rating-lg">
							<input type="radio" name="rating" value="1" class="mask mask-star-2 bg-orange-400" />
							<input type="radio" name="rating" value="2" class="mask mask-star-2 bg-orange-400" />
							<input type="radio" name="rating" value="3" class="mask mask-star-2 bg-orange-400" />
							<input type="radio" name="rating" value="4" class="mask mask-star-2 bg-orange-400" checked />
							<input type="radio" name="rating" value="5" class="mask mask-star-2 bg-orange-400" />
						</div>
					</div>
				</c:if>

				<div class="form-control mb-6">
					<label class="label">
						<span class="label-text font-bold">제목</span>
					</label>
					<input type="text" name="title" class="input input-bordered w-full" placeholder="제목을 입력하세요" />
				</div>

				<div class="form-control mb-8">
					<label class="label">
						<span class="label-text font-bold">내용</span>
					</label>
					<textarea name="body" class="textarea textarea-bordered h-64 text-base" placeholder="현장의 감동을 공유해주세요"></textarea>
				</div>

				<div class="flex justify-end gap-2">
					<button type="button" onclick="history.back();" class="btn btn-ghost">취소</button>
					<button type="submit" class="btn btn-primary btn-wide font-bold">등록하기</button>
				</div>
			</div>
		</form>
	</div>
</section>

<dialog id="choice_modal" class="modal">
<div class="modal-box max-w-2xl">
	<h3 class="font-black text-xl mb-6">${param.type == 'REVIEW' ? '내 예매 내역' : '전체 공연 검색'}</h3>

	<div class="form-control mb-4">
		<input type="text" id="searchKeyword" onkeyup="filterList()" placeholder="공연명 검색..."
			class="input input-bordered w-full" />
	</div>

	<div class="overflow-y-auto max-h-96">
		<table class="table w-full">
			<tbody id="searchTableBody">
				<c:choose>
					<c:when test="${param.type == 'REVIEW'}">
						<c:forEach var="res" items="${myReservations}">
							<tr class="hover cursor-pointer"
								onclick="selectTarget(${res.concertId}, '${res.extra__concertTitle}', ${res.id})">
								<td>
									<div class="font-bold">${res.extra__concertTitle}</div>
									<div class="text-xs text-gray-400">예매일: ${res.regDate}</div>
								</td>
								<td class="text-right">
									<span class="badge badge-primary">선택</span>
								</td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<c:forEach var="concert" items="${allConcerts}">
							<tr class="hover cursor-pointer" onclick="selectTarget(${concert.id}, '${concert.title}', null)">
								<td>
									<div class="font-bold">${concert.title}</div>
								</td>
								<td class="text-right">
									<span class="badge">선택</span>
								</td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
	</div>
</div>
<form method="dialog" class="modal-backdrop">
	<button>close</button>
</form>
</dialog>

<script>
    window.addEventListener('DOMContentLoaded', () => {
        const currentType = "${param.type}";
        const initialConcertId = "${selectedConcert != null ? selectedConcert.id : ''}";
        
        if (initialConcertId !== '') {
            
            if (currentType === 'REVIEW') {
                let matchedOrderId = "";
                
                <c:if test="${param.type == 'REVIEW'}">
                    <c:forEach var="res" items="${myReservations}">
                        if (!matchedOrderId && "${res.concertId}" === initialConcertId) {
                            matchedOrderId = "${res.id}";
                        }
                    </c:forEach>
                </c:if>
                
                if (matchedOrderId !== "") {
                    document.getElementById('selectedOrderId').value = matchedOrderId;
                } else {
                    alert("해당 공연의 유효한 예매 내역(CONFIRMED)이 발견되지 않았습니다. 기대평으로 작성하시거나 확인 후 다시 이용해주세요.");
                    history.back();
                    return;
                }
            }
            

            const displayInput = document.getElementById('displayConcertTitle');
            const hiddenInput = document.getElementById('selectedConcertId');
            
            if(hiddenInput && !hiddenInput.value) hiddenInput.value = initialConcertId;
            if(displayInput && !displayInput.value) displayInput.value = "${selectedConcert != null ? selectedConcert.title : ''}";
        }
    });

    function selectTarget(concertId, title, orderId) {
        document.getElementById('selectedConcertId').value = concertId;
        document.getElementById('selectedOrderId').value = orderId || "";
        document.getElementById('displayConcertTitle').value = title;
        choice_modal.close();
    }


    function filterList() {
        const kw = document.getElementById('searchKeyword').value.toLowerCase();
        const rows = document.querySelectorAll('#searchTableBody tr');
        rows.forEach(row => {
            const text = row.innerText.toLowerCase();
            row.style.display = text.includes(kw) ? '' : 'none';
        });
    }

    // 폼 전송 전 유효성 검사
    function submitWriteForm(form) {
        if (!form.concertId.value) { 
            alert('리뷰 대상을 선택해주세요.'); 
            return false; 
        }
        
        // 관람 후기인데 수동으로 대상을 변경하다가 orderId가 누락되는 경우 방어
        if (form.type.value === 'REVIEW' && !form.orderId.value) {
            alert('실관람 후기는 실제 예매 내역이 연동되어야 작성할 수 있습니다.');
            return false;
        }
        
        if (form.title.value.trim().length == 0) { 
            alert('제목을 입력해주세요.'); 
            return false; 
        }
        if (form.body.value.trim().length == 0) { 
            alert('내용을 입력해주세요.'); 
            return false; 
        }
        return true;
    }
</script>