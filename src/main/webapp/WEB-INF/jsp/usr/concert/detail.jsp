<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="공연 상세 정보"></c:set>

<%@ include file="../common/head.jspf"%>

<section class="mt-8 text-xl px-4">
    <div class="container mx-auto">
        <div class="card bg-base-200 shadow-xl mb-8">
            <div class="card-body">
                <h2 class="card-title text-3xl font-bold text-primary">${concert.title}</h2>
                <div class="divider"></div>
                <p class="text-lg mb-4"><span class="badge badge-outline mr-2">공연 설명</span> ${concert.description}</p>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-base">
                    <div class="flex items-center">
                        <span class="font-semibold w-24">공연 일시</span>
                        <fmt:parseDate value="${concert.startAt.replace('T', ' ')}" pattern="yyyy-MM-dd HH:mm" var="dt" />
                        <fmt:formatDate value="${dt}" pattern="yyyy년 MM월 dd일 HH:mm" />
                    </div>
                    <div class="flex items-center">
                        <span class="font-semibold w-24">예매 오픈</span>
                        <fmt:parseDate value="${concert.bookingStartAt.replace('T', ' ')}" pattern="yyyy-MM-dd HH:mm" var="bt" />
                        <fmt:formatDate value="${bt}" pattern="yyyy년 MM월 dd일 HH:mm" />
                    </div>
                </div>
            </div>
        </div>

        <div class="mb-6">
            <h3 class="text-2xl font-bold mb-4 italic">Grade & Remaining Seats</h3>
            <div class="overflow-x-auto">
                <table class="table w-full text-center">
                    <thead>
                        <tr>
                            <th>좌석 등급</th>
                            <th>가격</th>
                            <th>남은 좌석</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty remainSeats}">
                                <tr>
                                    <td colspan="3" class="py-4">좌석 정보가 없습니다.</td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="seat" items="${remainSeats}">
                                    <tr>
                                        <td class="font-bold">${seat.grade_name}석</td>
                                        <td><fmt:formatNumber value="${seat.price}" type="number" />원</td>
                                        <td>
                                            <div class="badge badge-error badge-outline gap-2 p-3">
                                                <span class="font-bold">${seat.remain_count}</span> 석 남음
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="flex justify-end gap-2 mb-10">
            <button class="btn btn-outline" onclick="history.back();">뒤로가기</button>
            <a href="../reservation/seatMap?concertId=${concert.id}" class="btn btn-primary px-8">
                좌석 선택 및 예매하기
            </a>
        </div>
    </div>
</section>

<%@ include file="../common/foot.jspf"%>