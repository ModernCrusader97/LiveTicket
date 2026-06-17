package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.example.demo.repository.ConcertRepository;
import com.example.demo.repository.ScheduleRepository;
import com.example.demo.vo.Artist;
import com.example.demo.vo.Concert;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Schedule;
import com.example.demo.vo.Seat;

@Service
public class ConcertService {

    @Autowired
    private ConcertRepository concertRepository;

    @Autowired
    private ScheduleRepository scheduleRepository;

    public ResultData<List<Concert>> getConcerts() {
        List<Concert> concerts = concertRepository.getConcerts(null, null, null, null);
        if (concerts.isEmpty()) {
            return ResultData.from("F-1", "공연 정보가 없습니다.");
        }
        return ResultData.from("S-1", "공연 목록 조회 성공", "concerts", concerts);
    }

    public List<Concert> getConcertsFiltered(String sort, String status, String keyword) {
        return concertRepository.getConcerts(sort, status, keyword, null);
    }

    public List<Concert> getTopConcertsByViewCount(int limit) {
        return concertRepository.getConcerts("viewCount", null, null, limit);
    }

    public List<Concert> getTopConcertsByBookingRate(int limit) {
        return concertRepository.getConcerts("bookingRate", null, null, limit);
    }

    public List<Concert> getUpcomingOpenConcerts(int limit) {
        return concertRepository.getConcerts("latest", "OPEN", null, limit);
    }

    public ResultData<Concert> getConcertById(long id) {
        Concert concert = concertRepository.getConcertById(id);
        if (concert == null) {
            return ResultData.from("F-1", id + "번 공연은 존재하지 않습니다.");
        }
        return ResultData.from("S-1", id + "번 공연 조회 성공", "concert", concert);
    }

    public List<Schedule> getSchedulesByConcertId(long concertId) {
        return scheduleRepository.getSchedulesByConcertId(concertId);
    }

    public Schedule getScheduleById(long scheduleId) {
        return scheduleRepository.getScheduleById(scheduleId);
    }

    public List<Artist> getArtistsByScheduleId(long scheduleId) {
        return scheduleRepository.getArtistsByScheduleId(scheduleId);
    }

    public List<Artist> getAllArtistsByConcertId(long concertId) {
        return scheduleRepository.getAllArtistsByConcertId(concertId);
    }

    public List<Artist> getAllArtists() {
        return concertRepository.getAllArtists();
    }

    public List<Seat> getRemainingSeats(long scheduleId) {
        return scheduleRepository.getRemainingSeats(scheduleId);
    }

    public Map<String, Object> getSalesStats(long scheduleId) {
        return scheduleRepository.getSalesStats(scheduleId);
    }

    public Map<String, Object> getSalesStatsByConcertId(long concertId) {
        return concertRepository.getSalesStatsByConcertId(concertId);
    }

    public void incrementViewCount(long id) {
        concertRepository.incrementViewCount(id);
    }

    public List<Map<String, Object>> getSeatGradesByScheduleId(long scheduleId) {
        return scheduleRepository.getSeatGradesByScheduleId(scheduleId);
    }

    @Scheduled(fixedRate = 60000)
    public void scheduledAutoUpdateConcertStatus() {
        try {
            concertRepository.autoOpenConcerts();
            concertRepository.autoCloseConcerts();
        } catch (Exception e) {
            System.err.println("콘서트 상태 자동 업데이트 오류: " + e.getMessage());
        }
    }
}
