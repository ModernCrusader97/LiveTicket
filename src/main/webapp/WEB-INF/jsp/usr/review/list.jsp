<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="pageTitle" value="커뮤니티"></c:set>
<%@ include file="../common/head.jspf"%>

<section class="mt-8 px-4 max-w-6xl mx-auto">
    <div class="tabs tabs-boxed justify-center mb-8 bg-base-200 p-2">
        <a href="?type=EXPECT" class="tab tab-lg ${param.type != 'REVIEW' ? 'tab-active' : ''}">🌟 공연 기대평</a>
        <a href="?type=REVIEW" class="tab tab-lg ${param.type == 'REVIEW' ? 'tab-active' : ''}">🎤 실관람 후기</a>
    </div>

    <div class="flex justify-between items-end mb-6">
        <div>
            <h2 class="text-3xl font-black text-gray-800">
                ${param.type == 'REVIEW' ? '실관람 후기' : '공연 기대평'}
            </h2>
            <p class="text-gray-500 mt-2">팬들이 전하는 생생한 현장의 목소리</p>
        </div>
        <a href="write?type=${param.type != null ? param.type : 'EXPECT'}" class="btn btn-primary shadow-lg">
            <i class="fa-solid fa-pen-nib mr-2"></i> 글쓰기
        </a>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <c:forEach var="review" items="${reviews}">
            <div class="card bg-base-100 shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
                <div class="card-body p-6">
                    <div class="flex justify-between items-start mb-3">
                        <span class="badge badge-outline badge-sm text-gray-400">#${review.id}</span>
                        <c:if test="${review.type == 'REVIEW'}">
                            <div class="rating rating-xs">
                                <c:forEach begin="1" end="5" var="i">
                                    <input type="radio" class="mask mask-star-2 bg-orange-400" ${i <= review.rating ? 'checked' : ''} disabled />
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                    <h3 class="text-xs font-bold text-primary mb-1">${review.extra__concertTitle}</h3>
                    <a href="detail?id=${review.id}" class="card-title text-lg hover:text-primary transition-colors mb-2">${review.title}</a>
                    <p class="text-gray-500 line-clamp-2 text-sm mb-4">${review.body}</p>
                    <div class="flex justify-between items-center text-xs text-gray-400 border-t pt-4">
                        <span class="font-medium text-gray-600">${review.extra__writer}</span>
                        <span>${review.regDate.substring(0, 10)}</span>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</section>

<%@ include file="../common/foot.jspf"%>