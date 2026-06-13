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
    private String title;
    private String posterImg;
    private String startDate;
    private String endDate;
    private String bookingStartAt;
    private String body;
    private int reviewCount;
    private int totalRating;
    private String status;
    private String regDate;
    private String updateDate;

    private double extra__avgRating;
    private double extra__bookingRate;
    private int viewCount;
}
