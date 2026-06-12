package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor

public class Seat {
    private long id;
    private String regDate;
    private String updateDate;
    private long concertId;
    private long gradeId;
    private String rowName;
    private int colNumber;
    private String status;
    private int version;
    private String heldAt;
    private Integer memberId;

    private String extra__gradeName;
    private int extra__price;
}