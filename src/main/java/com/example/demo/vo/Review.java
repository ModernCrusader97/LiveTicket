package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@Data
@NoArgsConstructor
@Builder
public class Review {
    private int id;
    private String regDate;
    private String updateDate;
    private int memberId;
    private int concertId;
    private String body;
    private String title;
    private int rating;
    private String type; // EXPECT, REVIEW
    private Integer orderId;
    
    private String extra__concertTitle; 
    private String extra__writer;
    
    private boolean extra__canDelete;
    private boolean extra__canModify;
}
