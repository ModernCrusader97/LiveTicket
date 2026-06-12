<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="리뷰 수정"></c:set>
<%@ include file="../common/head.jspf"%>

<section class="mt-8 px-4 pb-20">
	<div class="max-w-3xl mx-auto">
		<form action="doModify" method="POST" onsubmit="return submitModifyForm(this);">
			<input type="hidden" name="id" value="${review.id}">
			<input type="hidden" name="type" value="${review.type}">

			<div class="bg-white rounded-3xl shadow-xl p-8 border border-gray-100">
				<div class="flex items-center gap-4 mb-8 pb-8 border-b border-dashed">
					<div
						class="w-16 h-16 bg-secondary/10 rounded-2xl flex items-center justify-center text-secondary text-2xl font-black">
						${review.type == 'REVIEW' ? 'R' : 'E'}</div>
					<div>
						<h2 class="text-2xl font-black">${review.type == 'REVIEW' ? '실관람 후기 수정' : '공연 기대평 수정'}</h2>
						<p class="text-gray-400 text-sm">#${review.id}번 게시글을 수정합니다.</p>
					</div>
				</div>

				<div class="form-control mb-6">
					<label class="label">
						<span class="label-text font-bold text-lg">리뷰 대상 공연</span>
					</label>
					<input type="text" value="${review.extra__concertTitle}" readonly
						class="input input-bordered w-full bg-gray-100 cursor-not-allowed font-medium text-gray-500" />
				</div>

				<c:if test="${review.type == 'REVIEW'}">
					<div class="form-control mb-6">
						<label class="label">
							<span class="label-text font-bold">평점</span>
						</label>
						<div class="rating rating-lg">
							<input type="radio" name="rating" value="1" class="mask mask-star-2 bg-orange-400"
								${review.rating == 1 ? 'checked' : ''} />
							<input type="radio" name="rating" value="2" class="mask mask-star-2 bg-orange-400"
								${review.rating == 2 ? 'checked' : ''} />
							<input type="radio" name="rating" value="3" class="mask mask-star-2 bg-orange-400"
								${review.rating == 3 ? 'checked' : ''} />
							<input type="radio" name="rating" value="4" class="mask mask-star-2 bg-orange-400"
								${review.rating == 4 ? 'checked' : ''} />
							<input type="radio" name="rating" value="5" class="mask mask-star-2 bg-orange-400"
								${review.rating == 5 ? 'checked' : ''} />
						</div>
					</div>
				</c:if>
				
				<div class="form-control mb-6">
					<label class="label">
						<span class="label-text font-bold">제목</span>
					</label>
					<input type="text" name="title" class="input input-bordered w-full" value="${review.title}" placeholder="제목을 입력하세요" />
				</div>

				<div class="form-control mb-8">
					<label class="label">
						<span class="label-text font-bold">내용</span>
					</label>
					<textarea name="body" class="textarea textarea-bordered h-64 text-base" placeholder="내용을 입력해주세요">${review.body}</textarea>
				</div>

				<div class="flex justify-end gap-2">
					<button type="button" onclick="history.back();" class="btn btn-ghost">취소</button>
					<button type="submit" class="btn btn-secondary btn-wide font-bold">수정완료</button>
				</div>
			</div>
		</form>
	</div>
</section>

<script>
	function submitModifyForm(form) {
		if (form.title.value.trim().length == 0) {
			alert('제목을 입력해주세요.');
			form.title.focus();
			return false;
		}
		if (form.body.value.trim().length == 0) {
			alert('내용을 입력해주세요.');
			form.body.focus();
			return false;
		}
		return true;
	}
</script>

<%@ include file="../common/foot.jspf"%>