<%@ page contentType="text/html; charset=UTF-8" isELIgnored="false"%>
<c:set var="pageTitle" value="등록 완료" scope="request"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../common/head.jspf"%>

<div class="max-w-lg mx-auto text-center py-16">
  <div class="text-6xl mb-6">🎉</div>
  <h1 class="text-3xl font-black text-white mb-2">공연 등록 완료!</h1>
  <p class="text-slate-400 mb-8">${msg}</p>

  <div class="bg-slate-900/60 rounded-xl border border-slate-800 p-5 mb-8 text-left">
    <p class="text-slate-500 text-xs mb-1">생성된 공연 ID</p>
    <p class="text-2xl font-mono font-bold text-cyan-400">#${id}</p>
  </div>

  <div class="flex flex-col gap-3">
    <a href="/admin/concert/detail?id=${id}" class="btn btn-primary btn-lg">등록된 공연 확인하기</a>
    <a href="/admin/concert/create" class="btn btn-ghost">다른 공연 등록</a>
    <a href="/admin/concert/list" class="btn btn-ghost text-slate-500">관리자 목록으로</a>
  </div>
</div>

<%@ include file="../common/foot.jspf"%>
