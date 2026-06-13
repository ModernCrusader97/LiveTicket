<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="pageTitle" value="찾을 수 없음" scope="request"/>
<%@ include file="../common/head.jspf"%>

<div class="max-w-lg mx-auto text-center py-20">
  <div class="text-6xl mb-6">🔍</div>
  <h1 class="text-2xl font-bold text-white mb-3">공연을 찾을 수 없습니다</h1>
  <c:if test="${not empty msg}">
    <p class="text-slate-400 mb-6">${msg}</p>
  </c:if>
  <a href="/admin/concert/list" class="btn btn-primary">← 목록으로 돌아가기</a>
</div>

<%@ include file="../common/foot.jspf"%>
