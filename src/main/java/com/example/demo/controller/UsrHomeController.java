package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.service.ConcertService;
import com.example.demo.service.ReviewService;
import com.example.demo.vo.Concert;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Review;

@Controller
public class UsrHomeController {

    @Autowired
    private ConcertService concertService;

    @Autowired
    private ReviewService reviewService;

    @RequestMapping("/usr/home/main")
    public String showMain(Model model) {
        ResultData<List<Concert>> concertsRd = concertService.getConcerts();
        if (concertsRd.isSuccess()) {
            model.addAttribute("concerts", concertsRd.getData1());
        }
        List<Review> bestReviews = reviewService.getForPrintReviewsByType("REVIEW");
        model.addAttribute("bestReviews", bestReviews);
        return "/usr/home/main";
    }

    @RequestMapping("/")
    public String showMain2() {
        return "redirect:/usr/home/main";
    }
}
