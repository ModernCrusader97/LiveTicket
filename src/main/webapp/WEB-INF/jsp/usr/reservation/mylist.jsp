<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:set var="pageTitle" value="마이페이지 - 내 예약 목록"></c:set>

<%@ include file="../common/head.jspf"%>

<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now}" pattern="yyyy-MM-dd HH:mm:ss" var="nowStr" />

<section class="mt-8 px-4 mb-20">
    <div class="container mx-auto">
        <div class="flex justify-between items-end mb-6">
            <h2 class="text-2xl font-bold">🎫 내 예약 목록</h2>
            <a href="../home/main" class="btn btn-sm btn-outline">메인으로 이동</a>
        </div>

        <c:choose>
            <c:when test="${empty myReservations}">
                <div class="bg-base-100 shadow-xl rounded-xl py-20 text-center text-gray-400 text-lg border">
                    예약된 내역이 없습니다.
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="res" items="${myReservations}">
                    <div class="card bg-base-100 shadow-xl mb-6 border border-slate-200">
                        <div class="card-body p-6">
                            <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                                <div>
                                    <h3 class="text-xl font-black text-gray-200">
                                        <c:if test="${res.status == 'CANCELLED'}">
                                            <span class="text-gray-400 line-through mr-2">[취소됨]</span>
                                        </c:if>
                                        ${res.extra__concertTitle}
                                    </h3>
                                    <fmt:parseDate value="${res.regDate}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedRegDate" />
                                    <p class="text-sm text-slate-500 mt-1">
                                        <i class="far fa-calendar-alt mr-1"></i>
                                        <fmt:formatDate value="${parsedRegDate}" pattern="yyyy-MM-dd HH:mm" />
                                    </p>
                                </div>
                                
                                <div class="flex items-center gap-4 w-full md:w-auto justify-between md:justify-end">
                                    <div class="text-right mr-4">
                                        <div class="badge badge-primary badge-outline">${res.extra__gradeName}석</div>
                                        <div class="font-bold mt-1 text-lg">${res.extra__rowName}열 ${res.extra__colNumber}번</div>
                                    </div>
                                    
                                    <div class="flex gap-2">
                                        <c:choose>
                                            <c:when test="${res.status == 'CANCELLED'}">
                                                <button class="btn btn-disabled btn-sm">취소 완료</button>
                                            </c:when>
                                            <c:otherwise>
                                                <c:if test="${res.extra__concertDate > nowStr}">
                                                    <a href="../reservation/doCancel?id=${res.id}" 
                                                       onclick="if(!confirm('정말 예매를 취소하시겠습니까?\n취소 후에는 되돌릴 수 없습니다.')) return false;"
                                                       class="btn btn-error btn-outline btn-sm">예매 취소</a>
                                                </c:if>
                                                
                                                <c:if test="${res.extra__concertDate <= nowStr}">
                                                    <a href="../review/write?type=REVIEW&concertId=${res.extra__masterConcertId}&orderId=${res.id}"
                                                       class="btn btn-success btn-sm text-white font-bold shadow-sm">
                                                        ✍️ 후기 쓰기
                                                    </a>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="divider my-3"></div>
                            
                            <div class="flex justify-between items-center text-sm">
                                <span class="text-slate-400 font-mono">No. ${res.id}</span>
                                <span class="font-bold ${res.status == 'CANCELLED' ? 'text-gray-400' : 'text-primary'}">
                                    <c:choose>
                                        <c:when test="${res.status == 'CANCELLED'}">취소됨</c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${res.extra__concertDate <= nowStr}">📸 관람 완료</c:when>
                                                <c:otherwise>결제완료</c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<%@ include file="../common/foot.jspf"%>