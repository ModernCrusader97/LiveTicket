<%@ page contentType="text/html; charset=UTF-8" isELIgnored="true"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<html>
<head>
<title>C.A.S.T. - 공연 마스터 관리</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.23/dist/full.min.css" rel="stylesheet" type="text/css" />
<style>
body {
	background-color: #0b0f19;
	color: #e2e8f0;
}

.neon-border {
	border: 1px solid #00f0ff;
	box-shadow: 0 0 10px rgba(0, 240, 255, 0.2);
}

.seat-block {
	transition: all 0.2s ease;
}

.seat-blocked {
	background-color: transparent !important;
	border: 1px dashed #334155 !important;
	opacity: 0.3;
}

::-webkit-scrollbar {
	width: 6px;
	height: 6px;
}

::-webkit-scrollbar-track {
	background: #0f172a;
}

::-webkit-scrollbar-thumb {
	background: #1e293b;
	border-radius: 3px;
}
</style>
</head>
<body class="p-6">

<nav class="fixed top-0 left-0 right-0 z-50 bg-slate-900/95 border-b border-amber-900/40 h-12 flex items-center px-6 gap-5 text-sm backdrop-blur">
  <a href="/admin/concert/list" class="text-amber-400 font-black tracking-widest">C.A.S.T <span style="background:#1e293b;border:1px solid #f59e0b55;color:#f59e0b;padding:1px 8px;border-radius:999px;font-size:11px;font-family:monospace">ADMIN</span></a>
  <a href="/admin/concert/list" class="text-slate-400 hover:text-amber-400 transition-colors">공연 목록</a>
  <a href="/admin/concert/create" class="text-amber-400 font-semibold">+ 공연 등록</a>
</nav>
<div style="height:48px"></div>

	<div class="max-w-[1400px] mx-auto">
		<div class="flex items-center justify-between mb-6 border-b border-blue-900 pb-4">
			<h1 class="text-3xl font-bold tracking-wider text-cyan-400">공연 마스터 & 회차 통합 등록</h1>
			<span class="text-xs bg-cyan-950 border border-cyan-500/30 px-3 py-1 rounded-full text-cyan-400 font-mono">INTEGRATED
				v1.0</span>
		</div>

		<form id="concertForm" action="/admin/concert/create" method="post" enctype="multipart/form-data"
			onsubmit="return prepareSubmit()">
			<input type="hidden" name="disabledSeatsStr" id="disabledSeatsStr" value="">
			<input type="hidden" name="schedulesData" id="schedulesData" value="">
			<div id="hiddenFileContainer" class="hidden"></div>

			<div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">

				<div class="bg-slate-900/40 p-5 rounded-xl border border-slate-800 flex flex-col gap-4">
					<h3 class="text-lg font-bold text-cyan-400 mb-1">🎭 1. 공연 기본 정보 및 좌석 등급</h3>

					<div class="form-control">
						<label class="label pt-0">
							<span class="label-text text-slate-400 font-medium">공연 타이틀</span>
						</label>
						<input type="text" name="title" placeholder="공연 타이틀"
							class="input input-bordered input-primary bg-slate-950 text-white w-full" required>
					</div>

					<div class="grid grid-cols-2 gap-4">
						<div class="form-control">
							<label class="label">
								<span class="label-text text-slate-400 text-xs">예매 시작일시</span>
							</label>
							<input type="datetime-local" name="bookingStartAt"
								class="input input-sm input-bordered bg-slate-950 text-center font-mono">
						</div>
						<div class="form-control">
							<label class="label">
								<span class="label-text text-emerald-400 text-xs font-bold">자동 계산 가격 범위</span>
							</label>
							<input type="text" id="priceRangeDisplay" readonly
								class="input input-sm input-bordered w-full bg-slate-900 text-center font-bold text-emerald-400"
								placeholder="0원 ~ 0원">
						</div>
					</div>

					<input type="file" name="posterFile"
						class="file-input file-input-sm file-input-bordered file-input-primary bg-slate-950 w-full" required>

					<div class="divider border-slate-800/60 my-1">좌석 구조 및 등급</div>

					<div class="grid grid-cols-3 gap-2 bg-slate-950/80 p-3 rounded-lg border border-slate-800">
						<div>
							<label class="block text-[10px] text-slate-500 mb-1 text-center">행 표기 방식</label>
							<select id="rowNameType"
								class="w-full bg-slate-900 border border-slate-700 rounded px-2 py-1.5 text-xs text-white"
								onchange="renderLivePreview()">
								<option value="ALPHA">알파벳 (A,B,C)</option>
								<option value="NUM">숫자 (1,2,3)</option>
							</select>
						</div>
						<div>
							<label class="block text-[10px] text-slate-500 mb-1 text-center">시작 문자/번호</label>
							<input type="text" id="rowStartChar" value="A"
								class="w-full bg-slate-900 border border-slate-700 rounded px-2 py-1.5 text-center text-xs text-white"
								oninput="renderLivePreview()">
						</div>
						<div>
							<label class="block text-[10px] text-slate-500 mb-1 text-center">가로 열 수</label>
							<input type="number" name="maxCols" id="maxCols" value="12"
								class="w-full bg-slate-900 border border-slate-700 rounded px-2 py-1.5 text-center text-xs text-cyan-400"
								oninput="renderLivePreview()">
						</div>
					</div>

					<div id="grade-list-container" class="space-y-2 mt-2">
						<div class="grade p-3 bg-slate-950 rounded border border-slate-800 flex items-center gap-3">
							<div class="flex-1">
								<input type="text" name="gradeNames" value="VIP석"
									class="input input-sm input-bordered w-full bg-slate-900 text-sm" oninput="renderLivePreview()">
							</div>
							<div class="w-24">
								<input type="number" name="gradePrices" value="150000"
									class="input input-sm input-bordered w-full bg-slate-900 text-sm text-center" oninput="calculatePriceRange()">
							</div>
							<div class="w-16">
								<input type="number" name="gradeRowCounts" value="3"
									class="input input-sm input-bordered w-full text-center font-bold text-emerald-400 bg-slate-900"
									oninput="renderLivePreview()">
							</div>
							<button type="button" class="btn-delete-grade bg-rose-950 text-rose-400 px-2 h-8 rounded text-xs">삭제</button>
						</div>
					</div>
					<button type="button" onclick="addGradeRow()"
						class="w-full py-2 bg-slate-800 hover:bg-slate-700 text-sm rounded text-slate-300 mt-2">+ 구역 추가</button>
				</div>

				<div class="bg-slate-950 p-5 rounded-xl border border-slate-800 flex flex-col">
					<h3 class="text-lg font-bold text-emerald-400 mb-4">💺 좌석 배치도 미리보기</h3>
					<div id="preview-matrix-container" class="flex-grow overflow-auto flex flex-col items-center"></div>
				</div>
			</div>

			<div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
				<div class="bg-slate-900/40 p-5 rounded-xl border border-slate-800">
					<h3 class="text-lg font-bold text-purple-400 mb-4">🧑‍🎤 2. 신규 출연진 등록</h3>

					<input type="file" id="newArtistFile" class="hidden" onchange="previewArtistImage(this)">

					<div class="flex gap-3 bg-slate-950 p-4 rounded-lg items-center">
						<div id="artistPreviewBox" onclick="$('#newArtistFile').click()"
							class="cursor-pointer w-20 h-20 bg-slate-900 border border-slate-700 rounded-full flex items-center justify-center text-[10px] text-slate-500 text-center overflow-hidden hover:border-purple-500 transition-colors">
							프사 클릭</div>

						<div class="flex-1 space-y-2">
							<input type="text" id="newArtistName" placeholder="이름" class="input input-sm w-full bg-slate-900 text-white">
							<input type="text" id="newArtistNote" placeholder="설명(한줄 소개)"
								class="input input-sm w-full bg-slate-900 text-white">
							<button type="button" onclick="registerArtistInline()"
								class="btn btn-sm w-full bg-purple-700 text-white border-none">추가</button>
						</div>
					</div>
				</div>
				<div class="bg-slate-900/40 p-5 rounded-xl border border-slate-800">
					<h3 class="text-lg font-bold text-amber-400 mb-4">📅 3. 회차별 스케줄</h3>
					<div id="schedule-timeline-container" class="space-y-3"></div>
					<button type="button" onclick="addScheduleTimeline()" class="btn btn-sm mt-3 w-full">+ 회차 추가</button>
				</div>
			</div>

			<button type="submit" class="w-full btn btn-primary h-16 text-lg font-bold tracking-widest">🚀 공연 마스터 패키지 최종
				등록</button>
		</form>
	</div>

	<script>
// --- 가격 계산 로직 ---
function calculatePriceRange() {
    let prices = [];
    $('input[name="gradePrices"]').each(function() {
        let val = parseInt($(this).val());
        if (!isNaN(val)) prices.push(val);
    });

    if (prices.length > 0) {
        let min = Math.min(...prices);
        let max = Math.max(...prices);
        $('#priceRangeDisplay').val(min.toLocaleString() + '원 ~ ' + max.toLocaleString() + '원');
    } else {
        $('#priceRangeDisplay').val('0원');
    }
}

// --- 좌석 및 UI 관리 로직 ---
const blockedSeats = new Set();
const artistPool = [];
let scheduleCount = 0;
let inlineArtistIdx = 0;
let tempArtistFile = null;

// 초기 더미 아티스트
if (artistPool.length === 0) {
    artistPool.push({id: "1", name: "박강현", isNew: false});
    artistPool.push({id: "2", name: "임규형", isNew: false});
}

// 1. 프로필 이미지 미리보기
function previewArtistImage(input) {
    if (input.files && input.files[0]) {
        tempArtistFile = input.files[0];
        const reader = new FileReader();
        reader.onload = function(e) {
            $('#artistPreviewBox').css({
                'background-image': 'url(' + e.target.result + ')',
                'background-size': 'cover',
                'background-position': 'center'
            }).text('');
        }
        reader.readAsDataURL(input.files[0]);
    }
}

// 2. 출연진 즉시 등록 (풀 업데이트)
function registerArtistInline() {
    const name = $('#newArtistName').val().trim();
    const note = $('#newArtistNote').val().trim();
    if(!name) { alert('출연진 이름을 입력하세요.'); return; }

    inlineArtistIdx++;
    const tempId = "NEW_" + inlineArtistIdx;
    artistPool.push({ id: tempId, name: name + " (신규)", isNew: true, note: note });

    if (tempArtistFile) {
        const fileInput = document.getElementById('newArtistFile');
        fileInput.id = "file_" + tempId;
        fileInput.name = "artistFiles"; // server expects MultipartFile[] artistFiles
        $('#hiddenFileContainer').append(fileInput);

        const fresh = document.createElement('input');
        fresh.type = 'file';
        fresh.id = 'newArtistFile';
        fresh.className = 'hidden';
        fresh.onchange = function() { previewArtistImage(this); };
        document.getElementById('artistPreviewBox').insertAdjacentElement('afterend', fresh);
    } else {
        const placeholder = document.createElement('input');
        placeholder.type = 'hidden';
        placeholder.name = 'artistFiles';
        placeholder.value = '';
        $('#hiddenFileContainer').append(placeholder);
    }

    $('#hiddenFileContainer').append('<input type="hidden" name="newArtistNames" value="' + escapeHtml(name) + '">');
    $('#hiddenFileContainer').append('<input type="hidden" name="newArtistNotes" value="' + escapeHtml(note) + '">');
    $('#hiddenFileContainer').append('<input type="hidden" name="newArtistTempIds" value="' + tempId + '">');

    refreshAllCastingSelects();

    $('#newArtistName, #newArtistNote').val('');
    $('#artistPreviewBox').css('background-image', 'none').text('프사 클릭');
    tempArtistFile = null;
    alert('[' + name + '] 아티스트가 추가되었습니다. 우측 스케줄에서 배역을 매핑하세요!');
}

// 안전한 HTML 이스케이프 (간단한 구현)
function escapeHtml(str) {
    return String(str).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

function refreshAllCastingSelects() {
    $('.casting-artist-select').each(function() {
        const currentVal = $(this).val();
        $(this).empty().append('<option value="">-- 출연진 선택 --</option>');
        artistPool.forEach(a => $(this).append('<option value="' + a.id + '">' + a.name + '</option>'));
        if(currentVal) $(this).val(currentVal);
    });
}

// 3. 스케줄(회차) 타임라인 동적 생성
function addScheduleTimeline() {
    scheduleCount++;
    const container = $('#schedule-timeline-container');
    
    var cardHtml = '';
    cardHtml += '<div class="schedule-card p-4 bg-slate-900/80 rounded-lg border border-slate-700 shadow-lg mb-4" data-index="' + scheduleCount + '">';
    cardHtml += '<div class="flex justify-between items-center mb-3 border-b border-slate-800 pb-2">';
    cardHtml += '<span class="text-sm font-bold text-amber-400"># 회차 ' + scheduleCount + '</span>';
    cardHtml += '<button type="button" class="text-slate-500 hover:text-rose-400 text-xs font-bold" onclick="$(this).closest(\'.schedule-card\').remove();">삭제</button>';
    cardHtml += '</div>';
    cardHtml += '<div class="grid grid-cols-1 md:grid-cols-2 gap-3 mb-3">';
    cardHtml += '<input type="text" name="schedules[' + scheduleCount + '].title" placeholder="회차 제목 (예: 1회차 공연)" class="bg-slate-950 border border-slate-700 rounded px-3 py-2 text-sm text-white placeholder-slate-500 sc-title">';
    cardHtml += '<input type="datetime-local" name="schedules[' + scheduleCount + '].performDate" class="bg-slate-950 border border-slate-700 rounded px-3 py-2 text-sm text-white sc-date">';
    cardHtml += '<input type="text" name="schedules[' + scheduleCount + '].description" placeholder="회차 설명" class="col-span-1 md:col-span-2 bg-slate-950 border border-slate-700 rounded px-3 py-2 text-sm text-white placeholder-slate-500 sc-body">';
    cardHtml += '</div>';
    cardHtml += '<div class="bg-slate-950/50 p-2 rounded border border-slate-800">';
    cardHtml += '<div class="flex justify-between items-center mb-2">';
    cardHtml += '<span class="text-xs text-slate-400 font-medium ml-1">캐스팅 배역 설정</span>';
    cardHtml += '<button type="button" class="px-2 py-1 bg-slate-800 hover:bg-slate-700 text-[10px] text-slate-300 rounded" onclick="addCastingRow(this)">+ 배역 추가</button>';
    cardHtml += '</div>';
    cardHtml += '<div class="schedule-casting-box space-y-1.5"></div>';
    cardHtml += '</div>';
    cardHtml += '</div>';
    const card = $(cardHtml);
    
    container.append(card);
    addCastingRow(card.find('.schedule-casting-box'));
}

function addCastingRow(element) {
    const box = $(element).hasClass('schedule-casting-box') ? $(element) : $(element).closest('.schedule-card').find('.schedule-casting-box');
    
    var rowHtml = '';
    rowHtml += '<div class="casting-row flex gap-2 items-center bg-slate-900 p-1.5 rounded border border-slate-800">';
    rowHtml += '<select class="casting-artist-select bg-slate-950 border border-slate-700 rounded px-2 py-1 text-xs text-white flex-1"></select>';
    rowHtml += '<input type="text" class="casting-role-input bg-slate-950 border border-slate-700 rounded px-2 py-1 text-xs text-cyan-400 w-32 text-center" placeholder="배역">';
    rowHtml += '<button type="button" class="text-slate-500 hover:text-rose-500 text-sm px-1 font-bold" onclick="$(this).parent().remove();">×</button>';
    rowHtml += '</div>';
    const row = $(rowHtml);
    
    row.find('.casting-artist-select').append('<option value="">-- 출연진 선택 --</option>');
    artistPool.forEach(a => row.find('.casting-artist-select').append('<option value="' + a.id + '">' + a.name + '</option>'));
    
    box.append(row);
}

// 4. 전송 패키징
function prepareSubmit() {
    $('#disabledSeatsStr').val(Array.from(blockedSeats).join(','));
    const schedulesList = [];
    let isValid = true;

    $('.schedule-card').each(function() {
        const scDate = $(this).find('.sc-date').val().trim();
        const scBody = $(this).find('.sc-body').val().trim();
        if(!scDate) { alert("일시를 입력해주세요。"); isValid = false; return false; }
        
        const castingsList = [];
        $(this).find('.casting-row').each(function() {
            const artistId = $(this).find('.casting-artist-select').val();
            const roleName = $(this).find('.casting-role-input').val().trim();
            if(artistId && roleName) castingsList.push({ artistId: artistId, roleName: roleName });
        });
        const scTitle = $(this).find('.sc-title').val().trim();
        schedulesList.push({ title: scTitle, performDate: scDate, body: scBody, castings: castingsList });
    });

    if(!isValid) return false;
    if(schedulesList.length === 0) { alert("최소 1개의 일정을 등록해야 합니다。"); return false; }

    $('#schedulesData').val(JSON.stringify(schedulesList));
    return true;
}

// 5. 좌석 매트릭스 엔진
function getRowLabel(type, startChar, index) {
    if (type === "NUM") {
        return ((parseInt(startChar) || 1) + index) + "";
    } else {
        const base = (startChar && startChar.trim()) ? startChar.trim().toUpperCase().charCodeAt(0) : 65;
        let targetCode = base + index;
        let label = "";
        while (targetCode >= 65) {
            let remainder = (targetCode - 65) % 26;
            label = String.fromCharCode(65 + remainder) + label;
            targetCode = Math.floor((targetCode - 65) / 26) + 64;
        }
        return label;
    }
}

function toggleRow(gradeIdx, r, maxCols) {
    let allBlocked = true;
    for(let c=1; c<=maxCols; c++) { if(!blockedSeats.has(gradeIdx + "_" + r + "_" + c)) { allBlocked = false; break; } }
    for(let c=1; c<=maxCols; c++) { const id = gradeIdx + "_" + r + "_" + c; if(allBlocked) blockedSeats.delete(id); else blockedSeats.add(id); }
    renderLivePreview();
}

function toggleColumn(c) {
    const gradeElements = $(".grade");
    let allBlocked = true;
    gradeElements.each(function(idx) {
        const rows = parseInt($(this).find("input[name='gradeRowCounts']").val()) || 0;
        for(let r=1; r<=rows; r++) { if(!blockedSeats.has(idx + "_" + r + "_" + c)) allBlocked = false; }
    });
    gradeElements.each(function(idx) {
        const rows = parseInt($(this).find("input[name='gradeRowCounts']").val()) || 0;
        for(let r=1; r<=rows; r++) { const id = idx + "_" + r + "_" + c; if(allBlocked) blockedSeats.delete(id); else blockedSeats.add(id); }
    });
    renderLivePreview();
}

// grade 삭제 핸들러
$(document).on('click', '.btn-delete-grade', function() {
    if ($('.grade').length <= 1) { alert("최소 하나의 구역은 있어야 합니다。"); return; }
    $(this).closest('.grade').remove(); calculatePriceRange(); renderLivePreview();
});

function addGradeRow() {
    $("#grade-list-container").append(`
        <div class="grade p-3 bg-slate-950 rounded border border-slate-800 flex items-center gap-3 mt-2">
            <div class="flex-1"><input type="text" name="gradeNames" value="일반석" class="input input-sm input-bordered w-full bg-slate-900 text-sm" oninput="renderLivePreview()"></div>
            <div class="w-24"><input type="number" name="gradePrices" value="100000" class="input input-sm input-bordered w-full bg-slate-900 text-sm text-center" oninput="calculatePriceRange()"></div>
            <div class="w-16"><input type="number" name="gradeRowCounts" value="3" class="input input-sm input-bordered w-full text-center font-bold text-emerald-400 bg-slate-900" oninput="renderLivePreview()"></div>
            <button type="button" class="btn-delete-grade bg-rose-950 text-rose-400 px-2 h-8 rounded text-xs">삭제</button>
        </div>
    `);
    calculatePriceRange();
    renderLivePreview();
}

function renderLivePreview() {
    const container = $("#preview-matrix-container").empty();
    const maxCols = parseInt($("#maxCols").val()) || 0;
    const gradeElements = $(".grade");
    const rowNameType = $("#rowNameType").val();
    const rowStartChar = $("#rowStartChar").val() || (rowNameType === "NUM" ? "1" : "A");

    if (maxCols <= 0 || gradeElements.length === 0) { container.html("<span class='text-slate-600 text-xs'>설정 대기 중...</span>"); return; }
    const colorChips = ['bg-cyan-500/20 text-cyan-400 border-cyan-500/40', 'bg-purple-500/20 text-purple-400 border-purple-500/40', 'bg-amber-500/20 text-amber-400 border-amber-500/40'];

    const colControlRow = $('<div class="flex gap-1 justify-center w-full mb-2 ml-8"></div>');
    for (let c = 1; c <= maxCols; c++) {
        const colBtn = $('<div class="w-7 h-5 flex items-center justify-center text-[9px] text-slate-500 bg-slate-800 rounded cursor-pointer hover:bg-slate-700 select-none border border-slate-700">' + c + '</div>');
        colBtn.on('click', function() { toggleColumn(c); });
        colControlRow.append(colBtn);
    }
    container.append(colControlRow);

    let globalActiveRowIndex = 0;
    gradeElements.each(function(gradeIdx) {
        const $grade = $(this);
        const gradeName = $grade.find("input[name='gradeNames']").val() || "구역";
        const rows = parseInt($grade.find("input[name='gradeRowCounts']").val()) || 0;
        const colorClass = colorChips[gradeIdx % colorChips.length];
        if(rows <= 0) return;

        container.append('<div class="text-[10px] text-slate-500 font-mono font-bold self-start mt-2 mb-1 ml-10">' + gradeName + ' ZONE</div>');

        for (let r = 1; r <= rows; r++) {
            let isRowCompletelyBlocked = true;
            for(let c = 1; c <= maxCols; c++) { if(!blockedSeats.has(gradeIdx + "_" + r + "_" + c)) { isRowCompletelyBlocked = false; break; } }

            const rowWrapper = $('<div class="flex gap-1 justify-center w-full items-center mb-1"></div>');

            const calculatedRowName = getRowLabel(rowNameType, rowStartChar, globalActiveRowIndex);
            const rowBtn = $('<div class="w-8 h-6 flex items-center justify-center text-[9px] text-slate-500 bg-slate-800 rounded cursor-pointer hover:bg-slate-700 select-none mr-2 border border-slate-700">' + calculatedRowName + '</div>');
            rowBtn.on('click', function() { toggleRow(gradeIdx, r, maxCols); });
            rowWrapper.append(rowBtn);

            let displayCol = 1;

            for (let c = 1; c <= maxCols; c++) {
                const seatId = gradeIdx + "_" + r + "_" + c;
                const isBlocked = blockedSeats.has(seatId);
                let seatClass = isBlocked ? 'seat-blocked' : (colorClass + ' seat-block');
                let seatText = isBlocked ? '' : calculatedRowName + displayCol++;

                const seatBtn = $('<div class="w-7 h-6 flex items-center justify-center text-[9px] font-bold rounded border cursor-pointer select-none ' + seatClass + '">' + seatText + '</div>');
                seatBtn.on('click', function() {
                    if (blockedSeats.has(seatId)) blockedSeats.delete(seatId); else blockedSeats.add(seatId);
                    renderLivePreview(); 
                });
                rowWrapper.append(seatBtn);
            }
            container.append(rowWrapper);
            if (!isRowCompletelyBlocked) globalActiveRowIndex++;
        }
    });
}

$(document).ready(function() {
    addScheduleTimeline();
    renderLivePreview();
    calculatePriceRange(); 
});
    </script>
</body>
</html>
</html>