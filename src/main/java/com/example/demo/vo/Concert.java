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
    private String regDate;
    private String updateDate;
    private String title;
    private String startAt;
    private String bookingStartAt;
    private int totalSeats;
    private int maxRows;
    private int maxCols;
    private String description;
}
