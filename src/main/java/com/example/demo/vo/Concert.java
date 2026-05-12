package com.example.demo.vo;

import java.time.LocalDateTime;

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
    private String performDate;
    private String startDate;
    private String endDate;
    private String title;
    private int totalSeats;
    private int maxRows;
    private int maxCols;
    private String body;

    private int reviewCount;
	private int totalRating;
}
