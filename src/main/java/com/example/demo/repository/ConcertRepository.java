package com.example.demo.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.vo.Artist;
import com.example.demo.vo.Concert;

@Mapper
public interface ConcertRepository {

    List<Concert> getConcerts(
            @Param("sort") String sort,
            @Param("status") String status,
            @Param("keyword") String keyword,
            @Param("limit") Integer limit);

    Concert getConcertById(long id);

    void insertConcert(Concert concert);

    void updateConcert(Concert concert);

    void updateConcertStatus(long id, String status);

    Map<String, Object> getSalesStatsByConcertId(long concertId);

    void incrementViewCount(long id);

    void autoOpenConcerts();

    void autoCloseConcerts();

    // Artist management (global, not schedule-specific)
    void insertArtist(Artist artist);
    List<Artist> getAllArtists();
}
