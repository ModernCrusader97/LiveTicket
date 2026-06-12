<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="${review.type == 'REVIEW' ? '후기 상세보기' : '기대평 상세보기'}"></c:set>
<%@ include file="../common/head.jspf"%>

<section class="mt-8 px-4 pb-20">
    <div class="max-w-4xl mx-auto">
        <div class="bg-base-200 p-6 rounded-t-3xl border-b border-dashed border-gray-300 flex justify-between items-center">
            <div>
                <span class="badge badge-primary mb-2">${review.type == 'REVIEW' ? '실관람 후기' : '공연 기대평'}</span>
                <h2 class="text-2xl font-black text-gray-800">${review.extra__concertTitle}</h2>
            </div>
            
            <c:if test="${review.type == 'REVIEW'}">
                <div class="text-right">
                    <div class="text-sm text-gray-500 mb-1">평점 (${review.rating}점)</div>
                    <div class="rating rating-md">
                        <c:forEach begin="1" end="5" var="i">
                            <input type="radio" 
                                   name="rating-detail" 
                                   class="mask mask-star-2 bg-orange-400" 
                                   ${i == review.rating ? 'checked' : ''} 
                                   disabled />
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </div>

        <div class="bg-white p-8 rounded-b-3xl shadow-lg border border-gray-100">
            <div class="flex justify-between items-end mb-8 pb-4 border-b">
                <div>
                    <h1 class="text-3xl font-bold mb-4">${review.title}</h1>
                    <div class="flex items-center gap-4 text-sm text-gray-400">
                        <span class="font-bold text-gray-600">작성자: ${review.extra__writer}</span>
                        <span>작성일: ${review.regDate.substring(0, 16)}</span>
                    </div>
                </div>
                <div class="text-gray-400 text-sm">
                    번호: ${review.id}
                </div>
            </div>

            <div class="min-h-[300px] leading-relaxed text-lg text-gray-700 whitespace-pre-wrap">${review.body}</div>

            <div class="flex justify-between mt-12 pt-6 border-t">
                <button class="btn btn-ghost" type="button" onClick="history.back();">
                    <i class="fa-solid fa-arrow-left mr-2"></i> 목록으로
                </button>
                
                <div class="flex gap-2">
                    <c:if test="${review.memberId == rq.loginedMemberId}">
                        <a class="btn btn-outline btn-warning" href="modify?id=${review.id}">수정</a>
                        <a class="btn btn-outline btn-error" 
                           href="doDelete?id=${review.id}" 
                           onclick="if(!confirm('정말 삭제하시겠습니까?')) return false;">삭제</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="../common/foot.jspf"%>