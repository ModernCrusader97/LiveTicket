package com.example.demo.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Concert;

@Mapper
public interface ConcertRepository {

    List<Concert> getConcerts();

    Concert getConcertById(long id);

    List<Map<String, Object>> getRemainingSeats(long concertId);
}
