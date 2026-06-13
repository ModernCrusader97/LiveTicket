package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Schedule {
    private long id;
    private long concertId;
    private String title;
    private String performDate;
    private String startAt;
    private int totalSeats;
    private int maxRows;
    private int maxCols;
    private int price;
    private String body;
    private String status;
    private String regDate;
    private String updateDate;

    // joined from concert table
    private String extra__concertTitle;
    private String extra__posterImg;
    private String extra__bookingStartAt;
    private String extra__concertStartDate;
    private String extra__concertEndDate;
}
