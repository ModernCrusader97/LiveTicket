package com.example.demo.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.service.ConcertService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Concert;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;
import com.example.demo.vo.Seat;

@Controller
public class UsrConcertController {
	@Autowired
	private Rq rq;
	
	@Autowired
	private ConcertService concertService;
	@RequestMapping("/usr/concert/list")
    public String showList(Model model) {
		
		ResultData<List<Concert>> concertsRd = concertService.getConcerts();
		if (concertsRd.isFail()) {
			rq.printHistoryBackNT( concertsRd.getMsg());
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
            rq.printHistoryBackNT( concertRd.getMsg());
        }
        
        List<Seat> remainSeats = concertService.getRemainingSeats(id);
        
        model.addAttribute("concert", concertRd.getData1());
        model.addAttribute("remainSeats", remainSeats);
        
        return "usr/concert/detail";
    }
}
