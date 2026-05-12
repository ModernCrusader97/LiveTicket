package com.example.demo.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Concert;
import com.example.demo.vo.Seat;

@Mapper
public interface ConcertRepository {

    List<Concert> getConcerts();

    Concert getConcertById(long id);

    List<Seat> getRemainingSeats(long concertId);
}
