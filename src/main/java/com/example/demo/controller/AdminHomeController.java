package com.example.demo.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.service.ConcertService;
import com.example.demo.vo.Concert;
import com.example.demo.vo.ResultData;

@Controller
public class AdminHomeController {

    @Autowired
    private ConcertService concertService;

    @RequestMapping("/admin/home/main")
    public String showMain(Model model) {
        ResultData<List<Concert>> rd = concertService.getConcerts();
        List<Concert> concerts = rd.isSuccess() ? rd.getData1() : List.of();
        model.addAttribute("concerts", concerts);

        long openCount = concerts.stream().filter(c -> "OPEN".equals(c.getStatus())).count();
        long draftCount = concerts.stream().filter(c -> "DRAFT".equals(c.getStatus())).count();
        long closedCount = concerts.stream().filter(c -> "CLOSED".equals(c.getStatus())).count();
        int totalViews = concerts.stream().mapToInt(Concert::getViewCount).sum();

        model.addAttribute("openCount", openCount);
        model.addAttribute("draftCount", draftCount);
        model.addAttribute("closedCount", closedCount);
        model.addAttribute("totalViews", totalViews);

        return "admin/home/main";
    }
}
