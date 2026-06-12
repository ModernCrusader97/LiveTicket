<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<title>C.A.S.T. - 공연 및 좌석 커스텀 관리자</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://cdn.jsdelivr.net/npm/daisyui@4.12.23/dist/full.min.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="/resource/common.css" />
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
/* 비활성화된 통로 스타일 */
.seat-blocked {
	background-color: transparent !important;
	border: 1px dashed #334155 !important;
	opacity: 0.3;
}
</style>
</head>
<body class="p-8">

	<div class="max-w-7xl mx-auto">
		<div class="flex items-center gap-4 mb-8 border-b border-blue-900 pb-4">
			<h1 class="text-3xl font-bold tracking-wider text-cyan-400" style="text-shadow: 0 0 10px #00f0ff;">C.A.S.T. 공연 및
				좌석 매트릭스 등록</h1>
		</div>

		<c:if test="${not empty msg}">
			<div class="alert alert-error mb-4 shadow-lg neon-border">${msg}</div>
		</c:if>

		<div class="grid grid-cols-1 lg:grid-cols-12 gap-8">

			<form action="/admin/concert/create" method="post" enctype="multipart/form-data"
				class="lg:col-span-5 space-y-4 bg-slate-900/50 p-6 rounded-xl border border-slate-800" onsubmit="prepareSubmit()">
				<input type="hidden" name="disabledSeatsStr" id="disabledSeatsStr" value="">

				<div class="form-control">
					<label class="label">
						<span class="label-text text-slate-400">공연명</span>
					</label>
					<input type="text" name="title" class="input input-bordered input-primary bg-slate-950 text-white" required>
				</div>

				<div class="grid grid-cols-2 gap-4">
					<div class="form-control">
						<label class="label">
							<span class="label-text text-slate-400">공연 일시</span>
						</label>
						<input type="text" name="performDate" placeholder="YYYY-MM-DD" class="input input-bordered bg-slate-950">
					</div>
					<div class="form-control">
						<label class="label">
							<span class="label-text text-slate-400">시작 시간</span>
						</label>
						<input type="text" name="startAt" placeholder="YYYY-MM-DD HH:mm:ss" class="input input-bordered bg-slate-950">
					</div>
				</div>

				<div class="grid grid-cols-3 gap-2">
					<div class="form-control">
						<label class="label">
							<span class="label-text text-slate-400">가로 열 수 (Cols)</span>
						</label>
						<input type="number" name="maxCols" id="maxCols" value="12"
							class="input input-bordered bg-slate-950 text-center font-bold text-cyan-400" oninput="renderLivePreview()">
					</div>
					<div class="form-control">
						<label class="label">
							<span class="label-text text-slate-400">대표 가격</span>
						</label>
						<input type="number" name="price" value="0" class="input input-bordered bg-slate-950">
					</div>
					<div class="form-control">
						<label class="label">
							<span class="label-text text-slate-400">마스터 ID</span>
						</label>
						<select name="parentId" class="select select-bordered bg-slate-950">
							<option value="0">단독/마스터</option>
							<c:forEach var="m" items="${masters}">
								<option value="${m.id}">${m.title}</option>
							</c:forEach>
						</select>
					</div>
				</div>

				<div class="form-control">
					<label class="label">
						<span class="label-text text-slate-400">티켓 오픈 일시</span>
					</label>
					<input type="text" name="bookingStartAt" placeholder="YYYY-MM-DD HH:mm:ss"
						class="input input-bordered bg-slate-950">
				</div>

				<div class="form-control">
					<label class="label">
						<span class="label-text text-slate-400">포스터 파일</span>
					</label>
					<input type="file" name="posterFile" class="file-input file-input-bordered file-input-primary bg-slate-950 w-full">
				</div>

				<div class="divider border-slate-800">좌석 등급 구역 매핑</div>

				<div id="grades" class="space-y-3 max-h-60 overflow-y-auto pr-2">
					<div class="grade p-3 bg-slate-950 rounded-lg border border-slate-800 flex gap-2 items-end">
						<div class="w-1/3">
							<label class="text-xs text-slate-500">등급명</label>
							<input type="text" name="gradeNames" value="VIP" class="input input-xs input-bordered w-full"
								oninput="renderLivePreview()">
						</div>
						<div class="w-1/3">
							<label class="text-xs text-slate-500">가격</label>
							<input type="number" name="gradePrices" value="150000" class="input input-xs input-bordered w-full">
						</div>
						<div class="w-1/3">
							<label class="text-xs text-slate-500">배정 행(Rows)</label>
							<input type="number" name="gradeRowCounts" value="4"
								class="input input-xs input-bordered w-full font-bold text-emerald-400" oninput="renderLivePreview()">
						</div>
					</div>
				</div>

				<div class="flex gap-2 pt-2">
					<button type="button" class="btn btn-outline btn-xs btn-accent flex-1" onclick="addGrade()">+ 등급 구역 추가</button>
					<button type="submit" class="btn btn-primary btn-sm px-6 text-white tracking-widest shadow-lg shadow-cyan-500/20">공연
						매트릭스 생성</button>
				</div>
			</form>

			<div class="lg:col-span-7 bg-slate-950 p-6 rounded-xl border border-slate-800 flex flex-col">
				<div class="flex justify-between items-center mb-4">
					<h2 class="text-lg font-semibold text-slate-300">STAGE MATRIX PREVIEW</h2>
					<span class="text-xs text-slate-500">💡 좌석을 클릭하면 비활성화(통로/구역 제외) 상태로 토글됩니다.</span>
				</div>

				<div
					class="w-full bg-slate-800 text-center py-1 text-xs tracking-widest text-slate-400 rounded mb-8 shadow-inner font-bold border border-slate-700">
					S C R E E N / S T A G E</div>

				<div id="preview-matrix-container"
					class="flex-grow flex flex-col gap-2 overflow-auto justify-center items-center p-4 min-h-[350px] bg-slate-900/30 rounded-lg border border-dashed border-slate-800">
				</div>
			</div>

		</div>
	</div>

<div class="p-6 bg-slate-900 text-slate-100 rounded-xl border border-slate-800">
    <h3 class="text-base font-bold mb-4 flex items-center gap-2">
        <span class="w-2 h-4 bg-cyan-500 rounded-sm"></span> 좌석 등역 및 포맷 설정
    </h3>
    
    <div class="grid grid-cols-3 gap-4 p-4 bg-slate-950 rounded-lg mb-6 border border-slate-800 text-sm">
        <div>
            <label class="block text-xs text-slate-400 mb-1">행 표기 방식</label>
            <select id="rowNameType" class="w-full bg-slate-800 border border-slate-700 rounded px-2 py-1" onchange="renderLivePreview()">
                <option value="ALPHA">알파벳 (A, B, C...)</option>
                <option value="NUM">숫자 (1, 2, 3...)</option>
            </select>
        </div>
        <div>
            <label class="block text-xs text-slate-400 mb-1">행 시작 문자/숫자</label>
            <input type="text" id="rowStartChar" value="A" class="w-full bg-slate-800 border border-slate-700 rounded px-2 py-1 text-center" oninput="renderLivePreview()" placeholder="A 또는 1">
        </div>
        <div>
            <label class="block text-xs text-slate-400 mb-1">최대 열(Column) 수</label>
            <input type="number" id="maxCols" value="10" class="w-full bg-slate-800 border border-slate-700 rounded px-2 py-1 text-center" oninput="renderLivePreview()">
        </div>
    </div>

    <div id="grade-list-container" class="space-y-3 mb-4">
        <div class="grade flex items-center gap-2 p-3 bg-slate-800 rounded border border-slate-700">
            <div class="flex flex-col gap-1">
                <button type="button" class="btn-move-up p-1 text-xs bg-slate-700 hover:bg-slate-600 rounded">▲</button>
                <button type="button" class="btn-move-down p-1 text-xs bg-slate-700 hover:bg-slate-600 rounded">▼</button>
            </div>
            <input type="text" name="gradeNames" value="VIP석" class="bg-slate-900 border border-slate-700 rounded px-2 py-1 text-sm w-32" oninput="renderLivePreview()">
            <input type="number" name="gradeRowCounts" value="3" class="bg-slate-900 border border-slate-700 rounded px-2 py-1 text-sm w-20 text-center" oninput="renderLivePreview()"> <span class="text-sm text-slate-400">행</span>
            <button type="button" class="btn-delete-grade ml-auto bg-rose-600/20 text-rose-400 border border-rose-500/30 px-2 py-1 rounded text-xs hover:bg-rose-600/40">삭제</button>
        </div>
    </div>
    
    <button type="button" onclick="addGradeRow()" class="w-full py-2 bg-slate-800 hover:bg-slate-700 border border-slate-700 text-sm rounded-lg font-medium">+ 등역 추가</button>
</div>

<div id="preview-matrix-container" class="mt-6 p-4 bg-slate-950 border border-slate-800 rounded-xl flex flex-col items-center overflow-x-auto"></div>

<script>
// 비활성화된 좌석을 추적하는 공간 (기존 유지)
const blockedSeats = new Set(); 

// --- [기능 3 & 4] 행 이름을 가변 포맷에 맞춰 변환해주는 헬퍼 엔진 ---
function getRowLabel(type, startChar, index) {
    // index는 0부터 시작 (0이면 첫 번째 행)
    if (type === "NUM") {
        const startNum = parseInt(startChar) || 1;
        return (startNum + index).toString();
    } else {
        // 알파벳 변환 로직 (A=65, Z=90)
        let baseCharCode = 65; // 기본값 'A'
        if (startChar && startChar.length > 0) {
            const cleanChar = startChar.trim().toUpperCase();
            baseCharCode = cleanChar.charCodeAt(0);
        }
        
        // Z(90)를 넘어갔을 때 AA, AB 형태로 확장되도록 설계된 정밀 알고리希
        let targetCode = baseCharCode + index;
        let label = "";
        while (targetCode >= 65) {
            let remainder = (targetCode - 65) % 26;
            label = String.fromCharCode(65 + remainder) + label;
            targetCode = Math.floor((targetCode - 65) / 26) + 64;
        }
        return label;
    }
}

// --- [기능 1] 등급 삭제 기능 ---
$(document).on('click', '.btn-delete-grade', function() {
    if ($('.grade').length <= 1) {
        alert("최소 하나의 등급은 존재해야 합니다.");
        return;
    }
    $(this).closest('.grade').remove();
    renderLivePreview(); // 구조가 바뀌었으므로 프리뷰 리렌더링
});

// --- [기능 2] 등급 순서 변경 (위로 / 아래로) ---
$(document).on('click', '.btn-move-up', function() {
    const current = $(this).closest('.grade');
    const previous = current.prev('.grade');
    if (previous.length > 0) {
        current.insertBefore(previous);
        renderLivePreview();
    }
});

$(document).on('click', '.btn-move-down', function() {
    const current = $(this).closest('.grade');
    const next = current.next('.grade');
    if (next.length > 0) {
        current.insertAfter(next);
        renderLivePreview();
    }
});

// 새 등급 행 추가 함수
function addGradeRow() {
    const container = $("#grade-list-container");
    const newRow = $(`
        <div class="grade flex items-center gap-2 p-3 bg-slate-800 rounded border border-slate-700">
            <div class="flex flex-col gap-1">
                <button type="button" class="btn-move-up p-1 text-xs bg-slate-700 hover:bg-slate-600 rounded">▲</button>
                <button type="button" class="btn-move-down p-1 text-xs bg-slate-700 hover:bg-slate-600 rounded">▼</button>
            </div>
            <input type="text" name="gradeNames" value="일반석" class="bg-slate-900 border border-slate-700 rounded px-2 py-1 text-sm w-32" oninput="renderLivePreview()">
            <input type="number" name="gradeRowCounts" value="5" class="bg-slate-900 border border-slate-700 rounded px-2 py-1 text-sm w-20 text-center" oninput="renderLivePreview()"> <span class="text-sm text-slate-400">행</span>
            <button type="button" class="btn-delete-grade ml-auto bg-rose-600/20 text-rose-400 border border-rose-500/30 px-2 py-1 rounded text-xs hover:bg-rose-600/40">삭제</button>
        </div>
    `);
    container.append(newRow);
    renderLivePreview();
}

// --- 좌석 매트릭스 렌더링 엔진 (요청 사항 반영 수정판) ---
function renderLivePreview() {
    const container = $("#preview-matrix-container");
    container.empty();

    const maxCols = parseInt($("#maxCols").val()) || 0;
    const gradeElements = $(".grade");
    
    // 글로벌 포맷 조건 가져오기
    const rowNameType = $("#rowNameType").val();
    const rowStartChar = $("#rowStartChar").val() || (rowNameType === "NUM" ? "1" : "A");

    if (maxCols <= 0 || gradeElements.length === 0) {
        container.html("<span class='text-slate-600 text-sm'>좌석 설정 데이터를 구성 중입니다...</span>");
        return;
    }

    const colorChips = [
        'bg-cyan-500/20 text-cyan-400 border-cyan-500/40', 
        'bg-purple-500/20 text-purple-400 border-purple-500/40', 
        'bg-amber-500/20 text-amber-400 border-amber-500/40', 
        'bg-emerald-500/20 text-emerald-400 border-emerald-500/40'
    ];

    // 상단 열 제어 버튼 배치
    const colControlRow = $('<div class="flex gap-1 justify-center w-full mb-3 ml-12"></div>');
    for (let c = 1; c <= maxCols; c++) {
        const colBtn = $(`<div class="w-8 h-5 flex items-center justify-center text-[9px] text-slate-400 bg-slate-800 rounded cursor-pointer hover:bg-slate-600 select-none border border-slate-700">C\${c}</div>`);
        colBtn.on('click', function() { toggleColumn(c); });
        colControlRow.append(colBtn);
    }
    container.append(colControlRow);

    // 구역 전체를 관통하는 통합 유효 행 카운터 (통로를 만났을 때 유연한 당김용)
    let globalActiveRowIndex = 0;

    gradeElements.each(function(gradeIdx) {
        const gradeName = $(this).find("input[name='gradeNames']").val() || "구역";
        const rows = parseInt($(this).find("input[name='gradeRowCounts']").val()) || 0;
        const colorClass = colorChips[gradeIdx % colorChips.length];

        if(rows <= 0) return;

        const sectionHeader = $(`<div class="text-xs text-slate-500 font-bold self-start mt-4 mb-1 ml-12">\${gradeName} AREA</div>`);
        container.append(sectionHeader);

        for (let r = 1; r <= rows; r++) {
            // 현재 행이 전부 비활성화 상태인지 체크
            let isRowCompletelyBlocked = true;
            for(let c = 1; c <= maxCols; c++) {
                if(!blockedSeats.has(gradeIdx + "_" + r + "_" + c)) {
                    isRowCompletelyBlocked = false;
                    break;
                }
            }

            const rowWrapper = $('<div class="flex gap-1 justify-center w-full items-center mb-1"></div>');
            
            // 왼쪽 행 컨트롤 버튼 제어 지점
            const rowBtn = $(`<div class="w-10 h-7 flex items-center justify-center text-[9px] text-slate-400 bg-slate-800 rounded cursor-pointer hover:bg-slate-600 select-none mr-2 border border-slate-700">R\${r}</div>`);
            rowBtn.on('click', function() { toggleRow(gradeIdx, r, maxCols); });
            rowWrapper.append(rowBtn);

            // 포맷 설정에 따른 실시간 가변 행 네임 추출
            // 통로가 되어 당겨지더라도 설정한 포맷 규칙(`getRowLabel`)을 철저히 계산합니다.
            const calculatedRowName = getRowLabel(rowNameType, rowStartChar, globalActiveRowIndex);

            let displayCol = 1; 

            for (let c = 1; c <= maxCols; c++) {
                const seatId = gradeIdx + "_" + r + "_" + c;
                const isBlocked = blockedSeats.has(seatId);
                
                let seatText = '';
                let seatClass = '';

                if (isBlocked) {
                    seatClass = 'seat-blocked';
                } else {
                    seatClass = colorClass;
                    seatText = calculatedRowName + '-' + displayCol; // 변환된 행 이름 결합
                    displayCol++; 
                }

                const seatBtn = $(`
                    <div data-id="\${seatId}" class="seat-block w-8 h-7 flex items-center justify-center text-[9px] font-bold rounded border cursor-pointer select-none \${seatClass}">
                        \${seatText}
                    </div>
                `);

                seatBtn.on('click', function() {
                    const id = $(this).data('id');
                    if (blockedSeats.has(id)) blockedSeats.delete(id);
                    else blockedSeats.add(id);
                    renderLivePreview(); 
                });

                rowWrapper.append(seatBtn);
            }
            container.append(rowWrapper);

            // 해당 줄이 살아있는 좌석 줄이었을 때만 가변 문자 인덱스 증가
            if (!isRowCompletelyBlocked) {
                globalActiveRowIndex++;
            }
        }
    });
}

// 초기 호출부 및 행/열 토글 함수들은 기존 소스 사용 유지...
$(document).ready(function() {
    renderLivePreview();
});
</script>

</body>
</html>