package com.example.demo.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Artist;
import com.example.demo.vo.Concert;
import com.example.demo.vo.Seat;

@Mapper
public interface ConcertRepository {

    List<Concert> getConcerts();

    Concert getConcertById(long id);

    List<Concert> getSchedulesByMasterId(long masterId);

    List<Artist> getArtistsByConcertId(long concertId);

    List<Seat> getRemainingSeats(long concertId);

	List<Artist> getAllArtistsByMasterId(long masterId);

    // New admin methods
    void insertConcert(String title, String posterImg, String performDate, String startAt, int totalSeats, int maxRows, int maxCols, int price, long parentId, String bookingStartAt, String body);

    int getLastInsertId();

    void insertSeatGrade(int concertId, String name, int price);

    void insertSeat(int concertId, int gradeId, int row, int col, String status);
}