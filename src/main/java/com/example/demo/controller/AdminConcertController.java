package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.service.ConcertAdminService;
import com.example.demo.service.ConcertService;
import com.example.demo.util.Ut;
import com.example.demo.vo.ResultData;

@Controller
public class AdminConcertController {

	@Autowired
	private ConcertAdminService concertAdminService;

	@Autowired
	private ConcertService concertService;

	@GetMapping("/admin/concert/create")
	public String showCreateForm(Model model) {
		// provide master concerts list so admin can add schedules under master if
		// needed
		ResultData masterListRd = concertService.getConcerts();
		if (masterListRd.isFail()) {
			model.addAttribute("masters", new ArrayList<>());
		} else {
			model.addAttribute("masters", masterListRd.getData1());
		}
		return "admin/concert/create";
	}

	@PostMapping("/admin/concert/create")
	public String doCreate(@RequestParam String title, @RequestParam(required = false) MultipartFile posterFile,
			@RequestParam(required = false) String performDate, @RequestParam(required = false) String startAt,
			@RequestParam(defaultValue = "0") int totalSeats, @RequestParam(defaultValue = "10") int maxRows,
			@RequestParam(defaultValue = "10") int maxCols, @RequestParam(defaultValue = "0") int price,
			@RequestParam(defaultValue = "0") long parentId, @RequestParam(required = false) String bookingStartAt,
			@RequestParam(required = false) String body, @RequestParam(required = false) List<String> gradeNames,
			@RequestParam(required = false) List<Integer> gradePrices,
			@RequestParam(required = false) List<Integer> gradeRowCounts,
			@RequestParam(defaultValue = "") String disabledSeatsStr,
			Model model) {

		ResultData rd = concertAdminService.createConcert(title, posterFile, performDate, startAt, totalSeats, maxRows,
				maxCols, price, parentId, bookingStartAt, body, gradeNames, gradePrices, gradeRowCounts,
				disabledSeatsStr);

		if (rd.isFail()) {
			model.addAttribute("msg", rd.getMsg());
			return "admin/concert/create";
		}

		model.addAttribute("msg", rd.getMsg());
		model.addAttribute("id", rd.getData1());
		return "admin/concert/create_done";
	}
}
