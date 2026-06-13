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

import com.example.demo.service.ConcertService;
import com.example.demo.service.ReviewService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Artist;
import com.example.demo.vo.Concert;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Review;
import com.example.demo.vo.Rq;
import com.example.demo.vo.Schedule;
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
    public String showList(Model model,
                           String sort,
                           String status,
                           String keyword) {
        List<Concert> concerts = concertService.getConcertsFiltered(sort, status, keyword);
        model.addAttribute("concerts", concerts);
        model.addAttribute("sort", sort);
        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
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

        concertService.incrementViewCount(id);
        Concert concert = concertRd.getData1();
        List<Schedule> schedules = concertService.getSchedulesByConcertId(id);

        List<Artist> mainArtists = concertService.getAllArtistsByConcertId(id);

        List<Review> reviews = reviewService.getReviewsByType(id, "REVIEW");
        List<Review> expects = reviewService.getReviewsByType(id, "EXPECT");

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
            aggregatedAvg = Math.round((aggregatedTotalRating / (double) aggregatedReviewCount) * 10d) / 10d;
        }

        concert.setReviewCount(aggregatedReviewCount);
        concert.setTotalRating(aggregatedTotalRating);
        concert.setExtra__avgRating(aggregatedAvg);

        boolean isBookingOpen = false;
        if (concert.getBookingStartAt() != null) {
            String nowStr = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            isBookingOpen = nowStr.compareTo(concert.getBookingStartAt()) >= 0;
        }

        Map<Long, Map<String, Object>> allScheduleData = new HashMap<>();
        for (Schedule schedule : schedules) {
            Map<String, Object> data = new HashMap<>();
            data.put("remainSeats", concertService.getRemainingSeats(schedule.getId()));
            data.put("artists", concertService.getArtistsByScheduleId(schedule.getId()));
            allScheduleData.put(schedule.getId(), data);
        }

        String allScheduleDataJson = "{}";
        try {
            allScheduleDataJson = objectMapper.writeValueAsString(allScheduleData);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }

        model.addAttribute("allScheduleDataJson", allScheduleDataJson);
        model.addAttribute("allScheduleData", allScheduleData);
        model.addAttribute("concert", concert);
        model.addAttribute("schedules", schedules);
        model.addAttribute("artists", mainArtists);
        model.addAttribute("reviews", reviews);
        model.addAttribute("expects", expects);
        model.addAttribute("isBookingOpen", isBookingOpen);

        return "usr/concert/detail";
    }
}
