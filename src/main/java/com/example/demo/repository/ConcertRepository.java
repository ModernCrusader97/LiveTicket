package com.example.demo.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Artist;
import com.example.demo.vo.Concert;

@Mapper
public interface ConcertRepository {

    List<Concert> getConcerts();

    Concert getConcertById(long id);

    void insertConcert(Concert concert);

    void updateConcert(Concert concert);

    void updateConcertStatus(long id, String status);

    Map<String, Object> getSalesStatsByConcertId(long concertId);

    void incrementViewCount(long id);

    // Artist management (global, not schedule-specific)
    void insertArtist(Artist artist);
}
