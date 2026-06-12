package com.example.demo.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.ConcertService;
import com.example.demo.service.ReviewService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Artist;
import com.example.demo.vo.Concert;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Review;
import com.example.demo.vo.Rq;
import com.example.demo.vo.Seat;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
public class UsrConcertController {
	
	@Autowired
    private ObjectMapper objectMapper;
	@Autowired
	private Rq rq;

	@Autowired
	private ReviewService reviewService;

	@Autowired
	private ConcertService concertService;

	@RequestMapping("/usr/concert/list")
	public String showList(Model model) {
		ResultData<List<Concert>> concertsRd = concertService.getConcerts();
		if (concertsRd.isFail()) {
			rq.printHistoryBackNT(concertsRd.getMsg());
			return null;
		}
		model.addAttribute("concerts", concertsRd.getData1());
		return "usr/concert/list";
	}

	@RequestMapping("/usr/concert/detail")
	public String showDetail(Integer id, Model model) {
		if (Ut.isEmpty(id)) {
			rq.printHistoryBackNT("콘서트 번호를 입력해주세요.");
			return null;
		}

		ResultData<Concert> concertRd = concertService.getConcertById(id);
		if (concertRd.isFail()) {
			rq.printHistoryBackNT(concertRd.getMsg());
			return null;
		}

		Concert currentConcert = concertRd.getData1();

		long masterId = currentConcert.getParentId() == 0 ? currentConcert.getId() : currentConcert.getParentId();
		List<Concert> schedules = concertService.getSchedulesByMasterId(masterId);


		List<Artist> mainArtists;
		if (currentConcert.getParentId() == 0) {
			mainArtists = concertService.getAllArtistsByMasterId(masterId);
		} else {
			mainArtists = concertService.getArtistsByConcertId(id);
		}

		List<Seat> remainSeats = concertService.getRemainingSeats(id);

		List<Review> reviews = reviewService.getReviewsByType((int)masterId, "REVIEW");
		List<Review> expects = reviewService.getReviewsByType((int)masterId, "EXPECT");

	
		int aggregatedReviewCount = 0;
		int aggregatedTotalRating = 0;
		for (Review r : reviews) {
			if (r != null && "REVIEW".equals(r.getType())) {
				aggregatedReviewCount++;
				aggregatedTotalRating += r.getRating();
			}
		}
		double aggregatedAvg = 0.0;
		if (aggregatedReviewCount > 0) {
			aggregatedAvg = Math.round((aggregatedTotalRating / (double) aggregatedReviewCount) * 10d) / 10d; // 1 decimal place like existing behavior
		}

		currentConcert.setReviewCount(aggregatedReviewCount);
		currentConcert.setTotalRating(aggregatedTotalRating);
		currentConcert.setExtra__avgRating(aggregatedAvg);

		boolean isBookingOpen = false;
		if (currentConcert.getBookingStartAt() != null) {
			String nowStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
			isBookingOpen = nowStr.compareTo(currentConcert.getBookingStartAt()) >= 0;
		}
		
		Map<Long, Map<String, Object>> allScheduleData = new HashMap<>();
	    
	    for (Concert schedule : schedules) {
	        Map<String, Object> data = new HashMap<>();
	        data.put("remainSeats", concertService.getRemainingSeats(schedule.getId()));
	        data.put("artists", concertService.getArtistsByConcertId(schedule.getId()));
	        allScheduleData.put(schedule.getId(), data);
	    }
	    
	    String allScheduleDataJson = "{}";
        try {
            allScheduleDataJson = objectMapper.writeValueAsString(allScheduleData);
        } catch (JsonProcessingException e) {
            e.printStackTrace(); // 에러 로그 출력
        }
        
	    model.addAttribute("allScheduleDataJson", allScheduleDataJson);
	    model.addAttribute("allScheduleData", allScheduleData);
		model.addAttribute("concert", currentConcert);
		model.addAttribute("schedules", schedules);
		model.addAttribute("artists", mainArtists);
		model.addAttribute("remainSeats", remainSeats);
		model.addAttribute("reviews", reviews);
		model.addAttribute("expects", expects);
		model.addAttribute("isBookingOpen", isBookingOpen);

		return "usr/concert/detail";
	}

}