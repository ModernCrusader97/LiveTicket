package com.example.demo.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder

public class Artist {
	private long id;
	private long masterId;
	private String name;
	private String roleName;
	private String profileImg;
}
