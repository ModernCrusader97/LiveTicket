package com.example.demo.service;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.repository.ConcertRepository;
import com.example.demo.util.Ut;
import com.example.demo.util.FileUtil;
import com.example.demo.vo.ResultData;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class ConcertAdminService {

	@Autowired
	private ConcertRepository concertRepository;

	@Autowired
	private com.example.demo.repository.ReservationRepository reservationRepository;

	@Value("${custom.upload.path:src/main/resources/static/img}")
	private String uploadPath;

	@Transactional
	public ResultData createConcert(String title, MultipartFile posterFile, String performDate, String startAt,
			int totalSeats, int maxRows, int maxCols, int price, long parentId, String bookingStartAt, String body,
			List<String> seatGradeNames, List<Integer> seatGradePrices, List<Integer> gradeRowCounts,
			String disabledSeatsStr, String schedulesData, List<String> newArtistNames, List<String> newArtistNotes,
			List<String> newArtistTempIds, MultipartFile[] artistFiles) {

		if (Ut.isEmpty(title)) {
			return ResultData.from("F-1", "공연명을 입력해주세요.");
		}

		String posterFileName = null;
		if (posterFile != null && !posterFile.isEmpty()) {
			posterFileName = FileUtil.saveFile(posterFile, uploadPath);
		}

		// 비활성화 좌석 파싱을 위한 리스트 준비
		List<String> disabledList = java.util.Arrays.asList(disabledSeatsStr.split(","));
		// Handle new artist inserts first (if any)
		Map<String, Integer> tempIdToRealId = new HashMap<>();
		if (newArtistNames != null && !newArtistNames.isEmpty()) {
			for (int i = 0; i < newArtistNames.size(); i++) {
				String aName = newArtistNames.get(i);
				String aNote = (newArtistNotes != null && newArtistNotes.size() > i) ? newArtistNotes.get(i) : null;
				String tempId = (newArtistTempIds != null && newArtistTempIds.size() > i) ? newArtistTempIds.get(i)
						: "NEW_" + (i + 1);
				MultipartFile afile = (artistFiles != null && artistFiles.length > i) ? artistFiles[i] : null;
				String profileImg = null;
				if (afile != null && !afile.isEmpty()) {
					profileImg = FileUtil.saveFile(afile, uploadPath);
				}
				concertRepository.insertArtist(aName, profileImg);
				int artistId = concertRepository.getLastInsertId();
				tempIdToRealId.put(tempId, artistId);
			}
		}

		ObjectMapper om = new ObjectMapper();
		List<Map<String, Object>> schedules = new ArrayList<>();
		if (schedulesData != null && !schedulesData.trim().isEmpty()) {
			try {
				schedules = om.readValue(schedulesData, new TypeReference<List<Map<String, Object>>>() {
				});
			} catch (Exception e) {
				e.printStackTrace();
				return ResultData.from("F-2", "스케줄 파싱 실패: " + e.getMessage());
			}
		}

		String calculatedStartDate = null;
		String calculatedEndDate = null;

		if (schedules != null && !schedules.isEmpty()) {
			calculatedStartDate = schedules.stream().map(s -> s.get("performDate").toString()).min(String::compareTo)
					.orElse(null);

			calculatedEndDate = schedules.stream().map(s -> s.get("performDate").toString()).max(String::compareTo)
					.orElse(null);
		}

		// If schedules provided -> create master concert (parentId should be 0)
		if (schedules != null && !schedules.isEmpty() && parentId == 0) {

			// [핵심 로직 2] 마스터 공연 생성: 계산된 startDate, endDate 주입 (performDate는 null)
			concertRepository.insertConcert(title, posterFileName, null, calculatedStartDate, calculatedEndDate,
					startAt, totalSeats, maxRows, maxCols, price, 0, bookingStartAt, body);
			int masterId = concertRepository.getLastInsertId();

			// for each schedule create a child concert and seats + castings
			for (Map<String, Object> sch : schedules) {
				String schTitle = sch.getOrDefault("title", "").toString();
				String schPerformDate = sch.getOrDefault("performDate", "").toString();
				String schBody = sch.getOrDefault("body", "").toString();

				// [핵심 로직 3] 하위(회차) 공연 생성: startDate, endDate 자리에 null 주입
				concertRepository.insertConcert((schTitle != null && !schTitle.isEmpty()) ? schTitle : title,
						posterFileName, schPerformDate, null, null, startAt, totalSeats, maxRows, maxCols, price,
						masterId, bookingStartAt, schBody);
				int childId = concertRepository.getLastInsertId();
				
				// seat grades and seats per child
				if (seatGradeNames != null && !seatGradeNames.isEmpty()) {
					for (int i = 0; i < seatGradeNames.size(); i++) {
						String gradeName = seatGradeNames.get(i);
						int gradePrice = seatGradePrices.get(i);
						concertRepository.insertSeatGrade(childId, gradeName, gradePrice);
						int gradeId = concertRepository.getLastInsertId();

						int rowsForGrade = gradeRowCounts.get(i);
						for (int r = 1; r <= rowsForGrade; r++) {
							for (int c = 1; c <= maxCols; c++) {
								String seatKey = i + "_" + r + "_" + c;
								String status = "AVAILABLE";
								if (disabledList.contains(seatKey)) {
									status = "BLOCKED";
								}
								concertRepository.insertSeat(childId, gradeId, r, c, status);
							}
						}
					}
				}

				// castings
				Object castingsObj = sch.get("castings");
				if (castingsObj instanceof List) {
					List<Map<String, Object>> castings = (List<Map<String, Object>>) castingsObj;
					for (Map<String, Object> cast : castings) {
						String artistIdStr = String.valueOf(cast.getOrDefault("artistId", ""));
						String roleName = String.valueOf(cast.getOrDefault("roleName", ""));
						if (artistIdStr == null || artistIdStr.isEmpty() || roleName == null || roleName.isEmpty())
							continue;
						int realArtistId = -1;
						if (artistIdStr.startsWith("NEW_")) {
							Integer mapped = tempIdToRealId.get(artistIdStr);
							if (mapped == null)
								continue;
							realArtistId = mapped;
						} else {
							try {
								realArtistId = Integer.parseInt(artistIdStr);
							} catch (Exception e) {
								continue;
							}
						}
						concertRepository.insertConcertCasting(childId, realArtistId, roleName);
					}
				}
			}

			return ResultData.from("S-1", "공연 마스터 + 회차 등록 완료", "id", masterId);
		}

		// 기존 단일 공연 등록 플로우 (parentId may be non-zero => create single concert and seats)
		concertRepository.insertConcert(title, posterFileName, performDate, null, null, 
				startAt, totalSeats, maxRows, maxCols, price, parentId, bookingStartAt, body);

		int concertId = concertRepository.getLastInsertId();

		if (seatGradeNames != null && !seatGradeNames.isEmpty()) {
			for (int i = 0; i < seatGradeNames.size(); i++) {
				String gradeName = seatGradeNames.get(i);
				int gradePrice = seatGradePrices.get(i);
				concertRepository.insertSeatGrade(concertId, gradeName, gradePrice);
				int gradeId = concertRepository.getLastInsertId();

				int rowsForGrade = gradeRowCounts.get(i);
				for (int r = 1; r <= rowsForGrade; r++) {
					for (int c = 1; c <= maxCols; c++) {
						// "등급인덱스_행_열" 조합 키 생성 (예: "0_1_3")
						String seatKey = i + "_" + r + "_" + c;
						String status = "AVAILABLE";

						if (disabledList.contains(seatKey)) {
							status = "BLOCKED"; // 통로나 죽은 자리는 BLOCKED 처리
						}

						concertRepository.insertSeat(concertId, gradeId, r, c, status);
					}
				}
			}
		}

		return ResultData.from("S-1", "공연 등록 완료", "id", concertId);
	}

	// helper: create seats and grades for a concert
	private void createSeats(int concertId, List<String> seatGradeNames, List<Integer> seatGradePrices,
			List<Integer> gradeRowCounts, int maxCols, String disabledSeatsStr) {
		List<String> disabledList = Arrays
				.asList((disabledSeatsStr == null) ? new String[] {} : disabledSeatsStr.split(","));

		for (int i = 0; i < seatGradeNames.size(); i++) {
			String gradeName = seatGradeNames.get(i);
			int gradePrice = (seatGradePrices != null && seatGradePrices.size() > i) ? seatGradePrices.get(i) : 0;
			concertRepository.insertSeatGrade(concertId, gradeName, gradePrice);
			int gradeId = concertRepository.getLastInsertId();

			int rowsForGrade = (gradeRowCounts != null && gradeRowCounts.size() > i) ? gradeRowCounts.get(i) : 0;
			for (int r = 1; r <= rowsForGrade; r++) {
				for (int c = 1; c <= maxCols; c++) {
					String seatKey = i + "_" + r + "_" + c;
					String status = "AVAILABLE";
					if (disabledList.contains(seatKey)) {
						status = "BLOCKED";
					}
					concertRepository.insertSeat(concertId, gradeId, r, c, status);
				}
			}
		}
	}

	public ResultData changeConcertStatus(long id, String status) {
		// basic validation
		if (Ut.isEmpty(status)) {
			return ResultData.from("F-1", "상태를 지정해주세요.");
		}

		// allow only known statuses
		String s = status.toUpperCase();
		if (!s.equals("DRAFT") && !s.equals("OPEN") && !s.equals("PAUSED") && !s.equals("CLOSED")) {
			return ResultData.from("F-2", "허용되지 않는 상태값입니다.");
		}

		concertRepository.updateConcertStatus(id, s);
		return ResultData.from("S-1", "공연 상태가 변경되었습니다.");
	}

	@Transactional
	public ResultData updateConcert(long id, String title, MultipartFile posterFile, String performDate, String startAt,
			Integer totalSeats, Integer maxRows, Integer maxCols, Integer price, String bookingStartAt, String body,
			List<String> seatGradeNames, List<Integer> seatGradePrices, List<Integer> gradeRowCounts,
			String disabledSeatsStr) {

		if (Ut.isEmpty(title)) {
			return ResultData.from("F-1", "공연명을 입력해주세요.");
		}

		String posterFileName = null;
		if (posterFile != null && !posterFile.isEmpty()) {
			posterFileName = FileUtil.saveFile(posterFile, uploadPath);
		}

		// Use existing values if null provided for counts
		int ts = (totalSeats == null) ? 0 : totalSeats;
		int mr = (maxRows == null) ? 0 : maxRows;
		int mc = (maxCols == null) ? 0 : maxCols;
		int pr = (price == null) ? 0 : price;

		concertRepository.updateConcert(id, title, posterFileName, performDate, startAt, ts, mr, mc, pr, bookingStartAt,
				body);

		// If seat structure provided -> replace seat grades and seats
		if (seatGradeNames != null && !seatGradeNames.isEmpty()) {
			// safety: don't allow structure change if confirmed reservations exist
			int confirmed = reservationRepository.countConfirmedByConcertId(id);
			if (confirmed > 0) {
				return ResultData.from("F-3", "이미 예매된 좌석이 있어 좌석 구조를 변경할 수 없습니다.");
			}

			// safety: don't allow structure change if concert status is OPEN (판매중)
			com.example.demo.vo.Concert existing = concertRepository.getConcertById(id);
			if (existing != null && "OPEN".equalsIgnoreCase(existing.getStatus())) {
				return ResultData.from("F-4", "공연이 판매중인 상태에서는 좌석 구조를 변경할 수 없습니다. 먼저 판매중지(PAUSED)로 변경하세요.");
			}

			// delete previous grades & seats
			concertRepository.deleteSeatGradesByConcertId((int) id);
			concertRepository.deleteSeatsByConcertId((int) id);

			List<String> disabledList = java.util.Arrays
					.asList((disabledSeatsStr == null) ? new String[] {} : disabledSeatsStr.split(","));

			for (int i = 0; i < seatGradeNames.size(); i++) {
				String gradeName = seatGradeNames.get(i);
				int gradePrice = (seatGradePrices != null && seatGradePrices.size() > i) ? seatGradePrices.get(i) : 0;
				concertRepository.insertSeatGrade((int) id, gradeName, gradePrice);
				int gradeId = concertRepository.getLastInsertId();

				int rowsForGrade = (gradeRowCounts != null && gradeRowCounts.size() > i) ? gradeRowCounts.get(i) : 0;
				for (int r = 1; r <= rowsForGrade; r++) {
					for (int c = 1; c <= mc; c++) {
						String seatKey = i + "_" + r + "_" + c;
						String status = "AVAILABLE";
						if (disabledList.contains(seatKey)) {
							status = "BLOCKED";
						}
						concertRepository.insertSeat((int) id, gradeId, r, c, status);
					}
				}
			}
		}

		return ResultData.from("S-1", "공연 정보가 수정되었습니다.");
	}
}
