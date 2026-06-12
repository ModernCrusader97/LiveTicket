package com.example.demo.service;

import java.io.File;
import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.repository.ConcertRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.ResultData;

@Service
public class ConcertAdminService {

	@Autowired
	private ConcertRepository concertRepository;

	@Value("${custom.upload.path:src/main/resources/static/img}")
	private String uploadPath;

	@Transactional
	public ResultData createConcert(String title, MultipartFile posterFile, String performDate, String startAt,
			int totalSeats, int maxRows, int maxCols, int price, long parentId, String bookingStartAt, String body,
			List<String> seatGradeNames, List<Integer> seatGradePrices, List<Integer> gradeRowCounts,
			String disabledSeatsStr) {

		if (Ut.isEmpty(title)) {
			return ResultData.from("F-1", "공연명을 입력해주세요.");
		}

		String posterFileName = null;
		if (posterFile != null && !posterFile.isEmpty()) {
			posterFileName = savePosterFile(posterFile);
		}

		// 비활성화 좌석 파싱을 위한 리스트 준비
		List<String> disabledList = java.util.Arrays.asList(disabledSeatsStr.split(","));

		concertRepository.insertConcert(title, posterFileName, performDate, startAt, totalSeats, maxRows, maxCols,
				price, parentId, bookingStartAt, body);

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

	private String savePosterFile(MultipartFile file) {
		try {
			File dir = new File(uploadPath);
			if (!dir.exists()) {
				dir.mkdirs();
			}
			String origin = file.getOriginalFilename();
			String ext = "";
			if (origin != null && origin.contains(".")) {
				ext = origin.substring(origin.lastIndexOf('.'));
			}
			String filename = System.currentTimeMillis() + ext;
			File dest = new File(dir, filename);
			file.transferTo(dest);
			return filename;
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}
}
