<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ include file="../common/head.jspf"%>

<section class="mt-8 px-4 mb-20">
    <div class="max-w-2xl mx-auto">
        <div class="card bg-base-100 shadow-xl border">
            <div class="card-body">
                <h2 class="card-title text-2xl font-bold mb-4">
                    <i class="fa-solid fa-ticket text-primary"></i> 예매 내역 확인
                </h2>
                <div class="divider"></div>

                <div class="bg-gray-50 p-4 rounded-lg mb-6">
                    <p class="text-sm text-gray-500">공연 정보</p>
                    <p class="text-xl font-bold">${schedule.extra__concertTitle}</p>
                    <p class="text-gray-600">${schedule.performDate}</p>
                </div>

                <div class="mb-6">
                    <p class="text-sm text-gray-500 mb-2">선택한 좌석</p>
                    <div class="space-y-2">
                        <c:set var="totalPrice" value="0" />
                        <c:forEach var="seat" items="${selectedSeats}">
                            <div class="flex justify-between items-center p-3 border rounded-md bg-white">
                                <div>
                                    <span class="badge badge-outline mr-2">${seat.extra__gradeName}</span>
                                    <span class="font-medium">${seat.rowName}열 ${seat.colNumber}번</span>
                                </div>
                                <span class="font-bold">
                                    <fmt:formatNumber value="${seat.extra__price}" pattern="#,###" />원
                                </span>
                            </div>
                            <c:set var="totalPrice" value="${totalPrice + seat.extra__price}" />
                        </c:forEach>
                    </div>
                </div>

                <div class="divider"></div>

                <div class="flex justify-between items-center mb-8">
                    <span class="text-lg font-semibold">총 결제 금액</span>
                    <span class="text-3xl font-black text-primary">
                        <fmt:formatNumber value="${totalPrice}" pattern="#,###" />원
                    </span>
                </div>

                <div class="flex flex-col gap-3">
                    <form action="doConfirm" method="POST" onsubmit="if(confirm('정말로 예매하시겠습니까?')) return true; return false;">
                        <input type="hidden" name="scheduleId" value="${schedule.id}">
                        <input type="hidden" name="seatIds" value="${seatIds}">
                        <button type="submit" class="btn btn-primary btn-lg w-full">결제 및 예매 확정</button>
                    </form>
                    
                    <a href="javascript:history.back();" class="btn btn-ghost">좌석 다시 선택</a>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="../common/foot.jspf"%>