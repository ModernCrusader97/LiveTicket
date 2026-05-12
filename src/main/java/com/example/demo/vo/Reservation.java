package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@Data
@NoArgsConstructor
@Builder

public class Reservation {
	
	private long id;
    private String regDate;   
    private String updateDate; 
    private long memberId;
    private long seatId;
    private int paidPrice;
    private String status;

    private String extra__concertTitle;
    private String extra__seatInfo;
}
