package com.example.demo.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.repository.ConcertRepository;
import com.example.demo.repository.ReservationRepository;
import com.example.demo.repository.ScheduleRepository;
import com.example.demo.util.FileUtil;
import com.example.demo.util.Ut;
import com.example.demo.vo.Artist;
import com.example.demo.vo.Concert;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Schedule;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class ConcertAdminService {

    @Autowired
    private ConcertRepository concertRepository;

    @Autowired
    private ScheduleRepository scheduleRepository;

    @Autowired
    private ReservationRepository reservationRepository;

    @Value("${custom.upload.path:src/main/resources/static/img}")
    private String uploadPath;

    private static final int MAX_SEAT_DIMENSION = 200;

    @Transactional
    public ResultData createConcert(String title, MultipartFile posterFile,
            String bookingStartAt, String body,
            int totalSeats, int maxRows, int maxCols, int price,
            List<String> seatGradeNames, List<Integer> seatGradePrices, List<Integer> gradeRowCounts,
            String disabledSeatsStr, String schedulesData,
            List<String> newArtistNames, List<String> newArtistNotes,
            List<String> newArtistTempIds, MultipartFile[] artistFiles) {

        if (Ut.isEmpty(title)) {
            return ResultData.from("F-1", "공연명을 입력해주세요.");
        }

        String posterFileName = null;
        if (posterFile != null && !posterFile.isEmpty()) {
            posterFileName = FileUtil.saveFile(posterFile, uploadPath);
        }

        // Insert new artists first and build tempId → realId map
        Map<String, Long> tempIdToRealId = new HashMap<>();
        if (newArtistNames != null && !newArtistNames.isEmpty()) {
            for (int i = 0; i < newArtistNames.size(); i++) {
                String aName = newArtistNames.get(i);
                String aNote = (newArtistNotes != null && i < newArtistNotes.size()) ? newArtistNotes.get(i) : null;
                String tempId = (newArtistTempIds != null && i < newArtistTempIds.size()) ? newArtistTempIds.get(i) : "NEW_" + (i + 1);
                MultipartFile aFile = (artistFiles != null && i < artistFiles.length) ? artistFiles[i] : null;

                String profileImg = null;
                if (aFile != null && !aFile.isEmpty()) {
                    profileImg = FileUtil.saveFile(aFile, uploadPath);
                }

                Artist artist = Artist.builder().name(aName).profileImg(profileImg).build();
                concertRepository.insertArtist(artist);
                tempIdToRealId.put(tempId, artist.getId());
            }
        }

        // Parse schedules JSON
        List<Map<String, Object>> schedules = new ArrayList<>();
        if (!Ut.isEmpty(schedulesData)) {
            try {
                schedules = new ObjectMapper().readValue(schedulesData, new TypeReference<List<Map<String, Object>>>() {});
            } catch (Exception e) {
                return ResultData.from("F-2", "스케줄 파싱 실패: " + e.getMessage());
            }
        }
        if (schedules.isEmpty()) {
            return ResultData.from("F-3", "최소 1개의 회차를 등록해야 합니다.");
        }

        // Compute master concert date range from schedules
        String calculatedStartDate = schedules.stream()
                .map(s -> s.get("performDate"))
                .filter(d -> d != null)
                .map(Object::toString)
                .min(String::compareTo)
                .orElse(null);
        String calculatedEndDate = schedules.stream()
                .map(s -> s.get("performDate"))
                .filter(d -> d != null)
                .map(Object::toString)
                .max(String::compareTo)
                .orElse(null);

        // Create master concert
        Concert concert = Concert.builder()
                .title(title)
                .posterImg(posterFileName)
                .startDate(calculatedStartDate)
                .endDate(calculatedEndDate)
                .bookingStartAt(bookingStartAt)
                .body(body)
                .status("DRAFT")
                .build();
        concertRepository.insertConcert(concert);
        long masterId = concert.getId();

        // Parse disabled seats safely
        List<String> disabledList = parseDisabledSeats(disabledSeatsStr);

        // Validate seat dimension to prevent DoS
        int safeMaxCols = Math.min(maxCols, MAX_SEAT_DIMENSION);

        // Create schedules with seats and castings
        for (Map<String, Object> sch : schedules) {
            String schPerformDate = sch.getOrDefault("performDate", "").toString();
            String schTitle = sch.getOrDefault("title", "").toString();
            String schBody = sch.getOrDefault("body", "").toString();

            Schedule schedule = Schedule.builder()
                    .concertId(masterId)
                    .title(Ut.isEmpty(schTitle) ? title : schTitle)
                    .performDate(schPerformDate)
                    .startAt(null)
                    .totalSeats(totalSeats)
                    .maxRows(maxRows)
                    .maxCols(safeMaxCols)
                    .price(price)
                    .body(schBody)
                    .status("DRAFT")
                    .build();
            scheduleRepository.insertSchedule(schedule);
            long scheduleId = schedule.getId();

            // Create seat grades and seats
            if (seatGradeNames != null && !seatGradeNames.isEmpty()) {
                createSeatsForSchedule((int) scheduleId, seatGradeNames, seatGradePrices, gradeRowCounts, safeMaxCols, disabledList);
            }

            // Create castings
            Object castingsObj = sch.get("castings");
            if (castingsObj instanceof List) {
                @SuppressWarnings("unchecked")
                List<Map<String, Object>> castings = (List<Map<String, Object>>) castingsObj;
                for (Map<String, Object> cast : castings) {
                    String artistIdStr = String.valueOf(cast.getOrDefault("artistId", ""));
                    String roleName = String.valueOf(cast.getOrDefault("roleName", ""));
                    if (Ut.isEmpty(artistIdStr) || Ut.isEmpty(roleName)) continue;

                    long realArtistId;
                    if (artistIdStr.startsWith("NEW_")) {
                        Long mapped = tempIdToRealId.get(artistIdStr);
                        if (mapped == null) continue;
                        realArtistId = mapped;
                    } else {
                        try {
                            realArtistId = Long.parseLong(artistIdStr);
                        } catch (NumberFormatException e) {
                            continue;
                        }
                    }

                    Map<String, Object> castingParams = new HashMap<>();
                    castingParams.put("scheduleId", scheduleId);
                    castingParams.put("artistId", realArtistId);
                    castingParams.put("roleName", roleName);
                    scheduleRepository.insertConcertCasting(castingParams);
                }
            }
        }

        return ResultData.from("S-1", "공연 등록 완료", "id", masterId);
    }

    private void createSeatsForSchedule(int scheduleId, List<String> seatGradeNames,
            List<Integer> seatGradePrices, List<Integer> gradeRowCounts,
            int maxCols, List<String> disabledList) {
        for (int i = 0; i < seatGradeNames.size(); i++) {
            String gradeName = seatGradeNames.get(i);
            int gradePrice = (seatGradePrices != null && i < seatGradePrices.size()) ? seatGradePrices.get(i) : 0;
            int rowsForGrade = (gradeRowCounts != null && i < gradeRowCounts.size()) ? gradeRowCounts.get(i) : 0;

            // Clamp row count to prevent DoS
            rowsForGrade = Math.min(rowsForGrade, MAX_SEAT_DIMENSION);

            Map<String, Object> gradeParams = new HashMap<>();
            gradeParams.put("scheduleId", scheduleId);
            gradeParams.put("name", gradeName);
            gradeParams.put("price", gradePrice);
            scheduleRepository.insertSeatGrade(gradeParams);
            int gradeId = ((Number) gradeParams.get("id")).intValue();

            for (int r = 1; r <= rowsForGrade; r++) {
                for (int c = 1; c <= maxCols; c++) {
                    String seatKey = i + "_" + r + "_" + c;
                    String status = disabledList.contains(seatKey) ? "BLOCKED" : "AVAILABLE";
                    Map<String, Object> seatParams = new HashMap<>();
                    seatParams.put("scheduleId", scheduleId);
                    seatParams.put("gradeId", gradeId);
                    seatParams.put("row", r);
                    seatParams.put("col", c);
                    seatParams.put("status", status);
                    scheduleRepository.insertSeat(seatParams);
                }
            }
        }
    }

    public ResultData changeConcertStatus(long id, String status) {
        if (Ut.isEmpty(status)) {
            return ResultData.from("F-1", "상태를 지정해주세요.");
        }
        String s = status.toUpperCase();
        if (!s.equals("DRAFT") && !s.equals("OPEN") && !s.equals("PAUSED") && !s.equals("CLOSED")) {
            return ResultData.from("F-2", "허용되지 않는 상태값입니다.");
        }
        concertRepository.updateConcertStatus(id, s);
        return ResultData.from("S-1", "공연 상태가 변경되었습니다.");
    }

    public ResultData changeScheduleStatus(long scheduleId, String status) {
        if (Ut.isEmpty(status)) {
            return ResultData.from("F-1", "상태를 지정해주세요.");
        }
        String s = status.toUpperCase();
        if (!s.equals("DRAFT") && !s.equals("OPEN") && !s.equals("PAUSED") && !s.equals("CLOSED")) {
            return ResultData.from("F-2", "허용되지 않는 상태값입니다.");
        }
        scheduleRepository.updateScheduleStatus(scheduleId, s);
        return ResultData.from("S-1", "회차 상태가 변경되었습니다.");
    }

    @Transactional
    public ResultData updateConcert(long id, String title, MultipartFile posterFile,
            String bookingStartAt, String body) {
        if (Ut.isEmpty(title)) {
            return ResultData.from("F-1", "공연명을 입력해주세요.");
        }

        Concert existing = concertRepository.getConcertById(id);
        if (existing == null) {
            return ResultData.from("F-2", "존재하지 않는 공연입니다.");
        }

        String posterFileName = null;
        if (posterFile != null && !posterFile.isEmpty()) {
            posterFileName = FileUtil.saveFile(posterFile, uploadPath);
        }

        Concert updated = Concert.builder()
                .id(id)
                .title(title)
                .posterImg(posterFileName != null ? posterFileName : existing.getPosterImg())
                .startDate(existing.getStartDate())
                .endDate(existing.getEndDate())
                .bookingStartAt(bookingStartAt)
                .body(body)
                .build();
        concertRepository.updateConcert(updated);
        return ResultData.from("S-1", "공연 정보가 수정되었습니다.");
    }

    @Transactional
    public ResultData updateSchedule(long scheduleId, String title, String performDate, String startAt,
            Integer totalSeats, Integer maxRows, Integer maxCols, Integer price, String body,
            List<String> seatGradeNames, List<Integer> seatGradePrices, List<Integer> gradeRowCounts,
            String disabledSeatsStr) {

        Schedule existing = scheduleRepository.getScheduleById(scheduleId);
        if (existing == null) {
            return ResultData.from("F-1", "존재하지 않는 회차입니다.");
        }

        Schedule updated = Schedule.builder()
                .id(scheduleId)
                .concertId(existing.getConcertId())
                .title(title)
                .performDate(performDate)
                .startAt(startAt)
                .totalSeats(totalSeats != null ? totalSeats : existing.getTotalSeats())
                .maxRows(maxRows != null ? maxRows : existing.getMaxRows())
                .maxCols(maxCols != null ? Math.min(maxCols, MAX_SEAT_DIMENSION) : existing.getMaxCols())
                .price(price != null ? price : existing.getPrice())
                .body(body)
                .build();
        scheduleRepository.updateSchedule(updated);

        if (seatGradeNames != null && !seatGradeNames.isEmpty()) {
            int confirmed = reservationRepository.countConfirmedByScheduleId(scheduleId);
            if (confirmed > 0) {
                return ResultData.from("F-3", "이미 예매된 좌석이 있어 좌석 구조를 변경할 수 없습니다.");
            }
            if ("OPEN".equalsIgnoreCase(existing.getStatus())) {
                return ResultData.from("F-4", "판매중인 상태에서는 좌석 구조를 변경할 수 없습니다. 먼저 PAUSED로 변경하세요.");
            }

            scheduleRepository.deleteSeatGradesByScheduleId((int) scheduleId);
            scheduleRepository.deleteSeatsByScheduleId((int) scheduleId);

            int safeMaxCols = Math.min(updated.getMaxCols(), MAX_SEAT_DIMENSION);
            List<String> disabledList = parseDisabledSeats(disabledSeatsStr);
            createSeatsForSchedule((int) scheduleId, seatGradeNames, seatGradePrices, gradeRowCounts, safeMaxCols, disabledList);
        }

        return ResultData.from("S-1", "회차 정보가 수정되었습니다.");
    }

    private List<String> parseDisabledSeats(String disabledSeatsStr) {
        if (Ut.isEmpty(disabledSeatsStr)) {
            return new ArrayList<>();
        }
        return Arrays.asList(disabledSeatsStr.split(","));
    }
}
