package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder

public class Concert {
	private long id;
	private long parentId;

    private String performDate;
    private String startDate;
    private String endDate;
    private String title;
    private String bookingStartAt;
    private String startAt;
    private int totalSeats;
    private int maxRows;
    private int maxCols;
    private int price;
    private String body;
    private int rating;
    private int reviewCount;
	private int totalRating;
	private String posterImg;

	private double extra__avgRating;

    private String status; // DRAFT, OPEN, PAUSED, CLOSED

}
