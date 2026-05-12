package com.example.demo.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.ReservationService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Concert;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;
import com.example.demo.vo.Seat;

@Controller
public class UsrReservationController {
	@Autowired
	private ReservationService reservationService;
	@Autowired
	private Rq rq;


	@RequestMapping("/usr/reservation/mylist")
	public String showMyList(Model model){
		if (!rq.isLogined()) {
			rq.printHistoryBackNT("로그인 후 이용해주세요.");
			return null;
		}

		List<Map<String, Object>> myReservations = reservationService.getMyReservations(rq.getLoginedMemberId());
		model.addAttribute("myReservations", myReservations);

		return "usr/reservation/mylist";
	}

	@RequestMapping("/usr/reservation/seatMap")
	public String showSeatMap(Model model, Integer concertId) {
		rq.disableCache();
		
		if (!rq.isLogined()) {
			rq.printHistoryBackNT("로그인 후 이용해주세요.");
			return null;
		}

		if (Ut.isEmpty(concertId)) {
			rq.printHistoryBackNT("공연 번호가 없습니다.");
			return null;
		}

		int alreadyReservedCount = reservationService.getReservedCount(rq.getLoginedMemberId(), concertId);


		model.addAttribute("alreadyReservedCount", alreadyReservedCount);
		model.addAttribute("maxLimit", 4);

		List<Seat> seats = reservationService.getSeatsByConcertId(concertId);

		List<Seat> allSeats = reservationService.getSeatsByConcertId(concertId);

		Map<String, List<Seat>> groupedSeats = new TreeMap<>();

		for (Seat seat : allSeats) {
			String rowName = seat.getRowName();
			if (!groupedSeats.containsKey(rowName)) {
				groupedSeats.put(rowName, new ArrayList<>());
			}
			groupedSeats.get(rowName).add(seat);
		}

		for (List<Seat> rowSeats : groupedSeats.values()) {
			rowSeats.sort(Comparator.comparingInt(Seat::getColNumber));
		}
		model.addAttribute("loginedMemberId", rq.getLoginedMemberId());
		model.addAttribute("groupedSeats", groupedSeats);
		model.addAttribute("seats", seats);
		model.addAttribute("concertId", concertId);

		return "usr/reservation/seatMap";
	}

	@RequestMapping("/usr/reservation/payment")
	public String showPayment(int concertId, String seatIds, Model model) {

		if (!rq.isLogined()) {
			rq.printHistoryBackNT("로그인 후 이용해주세요.");
	        return null;
	    }
		Concert concert = reservationService.getConcertById(concertId);

		List<Integer> seatIdList = Arrays.stream(seatIds.split(",")).map(Integer::parseInt)
				.collect(Collectors.toList());

		List<Seat> selectedSeats = reservationService.getSeatsByIds(seatIdList);

		// 3. JSP에 데이터 전달
		model.addAttribute("concert", concert);
		model.addAttribute("selectedSeats", selectedSeats);
		model.addAttribute("seatIds", seatIds);

		return "usr/reservation/payment";
	}

	@RequestMapping("/usr/reservation/doHold")
	public String doHold(int concertId, String seatIds) {
		// 1. 기본 검증
		if (!rq.isLogined()) {
			rq.printHistoryBackNT("로그인 후 이용해주세요.");
			return null;
		}

		if (Ut.isEmpty(seatIds)) {
			rq.printHistoryBackNT("선택된 좌석이 없습니다.");
			return null;
		}

		ResultData holdRd = reservationService.holdSeats(rq.getLoginedMemberId(), concertId, seatIds);

		if (holdRd.isFail()) {
			rq.printHistoryBackNT( holdRd.getMsg());
			return null;
		}

		String cleanIds = Arrays.stream(seatIds.split(",")).map(s -> s.split(":")[0]).collect(Collectors.joining(","));

		return "redirect:../reservation/payment?concertId=" + concertId + "&seatIds=" + cleanIds;
	}
	
	@PostMapping("/usr/reservation/doConfirm")
	@ResponseBody
	public String doConfirm(int concertId, String seatIds) {
	    if (Ut.isEmpty(seatIds)) {
	        return Ut.jsHistoryBack("F-1", "좌석 정보가 올바르지 않습니다.");
	    }

	    ResultData confirmRd = reservationService.confirmReservation(rq.getLoginedMemberId(), concertId, seatIds);

	    if (confirmRd.isFail()) {
	        return Ut.jsHistoryBack(confirmRd.getResultCode(), confirmRd.getMsg());
	    }

	    return Ut.jsReplace(confirmRd.getResultCode(),confirmRd.getMsg(),  "../reservation/mylist");
	}
	
	@RequestMapping("/usr/reservation/doCancel")
	@ResponseBody
	public String doCancel(int id) {
	    ResultData cancelRd = reservationService.doCancel(rq.getLoginedMemberId(), id);

	    if (cancelRd.isFail()) {
	        return Ut.jsHistoryBack(cancelRd.getResultCode(), cancelRd.getMsg());
	    }

	    return Ut.jsReplace(cancelRd.getResultCode(), cancelRd.getMsg(), "../reservation/mylist");
	}
}