<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="예매 가능한 공연 목록"></c:set>

<%@ include file="../common/head.jspf"%>

<section class="mt-8 text-xl px-4">
    <div class="container mx-auto">
        <div class="overflow-x-auto">
            <table class="table table-zebra w-full">
                <thead>
                    <tr class="text-center">
                        <th>공연번호</th>
                        <th>공연명</th>
                        <th>공연일시</th>
                        <th>예매오픈일</th>
                        <th>비고</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty concerts}">
                            <tr>
                                <td colspan="5" class="text-center py-10 text-gray-400">현재 오픈된 공연이 없습니다.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="concert" items="${concerts}">
                                <tr class="hover text-center">
                                    <td>${concert.id}</td>
                                    <td class="font-bold text-left">${concert.title}</td>
                                    <td>
                                        <fmt:parseDate value="${concert.startAt.replace('T', ' ')}" pattern="yyyy-MM-dd HH:mm" var="parsedStartAt" />
                                        <fmt:formatDate value="${parsedStartAt}" pattern="yyyy년 MM월 dd일 HH:mm" />
                                    </td>
                                    <td>
                                        <fmt:parseDate value="${concert.bookingStartAt.replace('T', ' ')}" pattern="yyyy-MM-dd HH:mm" var="parsedBookingAt" />
                                        <fmt:formatDate value="${parsedBookingAt}" pattern="yyyy년 MM월 dd일 HH:mm" />
                                    </td>
                                    <td>
                                        <a href="../concert/detail?id=${concert.id}" class="btn btn-sm btn-ghost btn-outline">상세보기 및 예매</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</section>

<%@ include file="../common/foot.jspf"%>