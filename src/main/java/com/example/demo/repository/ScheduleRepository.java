package com.example.demo.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Artist;
import com.example.demo.vo.Schedule;
import com.example.demo.vo.Seat;

@Mapper
public interface ScheduleRepository {

    void insertSchedule(Schedule schedule);

    Schedule getScheduleById(long id);

    List<Schedule> getSchedulesByConcertId(long concertId);

    void updateSchedule(Schedule schedule);

    void updateScheduleStatus(long id, String status);

    // Seat grades (owned by schedule)
    void insertSeatGrade(Map<String, Object> params);

    void insertSeat(Map<String, Object> params);

    void deleteSeatGradesByScheduleId(int scheduleId);

    void deleteSeatsByScheduleId(int scheduleId);

    List<Map<String, Object>> getSeatGradesByScheduleId(long scheduleId);

    List<Seat> getRemainingSeats(long scheduleId);

    Map<String, Object> getSalesStats(long scheduleId);

    // Castings
    void insertConcertCasting(Map<String, Object> params);

    List<Artist> getArtistsByScheduleId(long scheduleId);

    List<Artist> getAllArtistsByConcertId(long concertId);
}
