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
			return Ut.jsHistoryBack(concertsRd.getResultCode() , concertsRd.getMsg());
		}

        model.addAttribute("concerts", concertsRd.getData1());
        return "usr/concert/list";
    }

    @RequestMapping("/usr/concert/detail")
    public String showDetail(Integer id, Model model) {
        if (Ut.isEmpty(id)) {
        	
        	return Ut.jsHistoryBack("F-1", "콘서트 번호를 입력해주세요.");
        }

        // 2. 서비스 호출 및 검증
        ResultData<Concert> concertRd = concertService.getConcertById(id);
        
        if (concertRd.isFail()) {            
            return Ut.jsHistoryBack(concertRd.getResultCode(), concertRd.getMsg());
        }
        
        List<Map<String, Object>> remainSeats = concertService.getRemainingSeats(id);
        
        // 4. 모델에 담아 JSP로 전달
        model.addAttribute("concert", concertRd.getData1());
        model.addAttribute("remainSeats", remainSeats);
        
        return "usr/concert/detail";
    }
}
