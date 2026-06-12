package com.example.demo.controller;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.ConcertService;
import com.example.demo.service.ReservationService;
import com.example.demo.service.ReviewService;
import com.example.demo.util.Ut;
import com.example.demo.vo.Concert;
import com.example.demo.vo.Reservation;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Review;
import com.example.demo.vo.Rq;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class UsrReviewController {

	@Autowired
	private Rq rq;

	@Autowired
	private ConcertService concertService;

	@Autowired
	private ReservationService reservationService;

	@Autowired
	private ReviewService reviewService;

	// 액션메서드
	@RequestMapping("/usr/review/detail")
	public String showDetail(HttpServletRequest req, Model model, int id) {

		Rq rq = (Rq) req.getAttribute("rq");
		Review review = reviewService.getForPrintReview(rq.getLoginedMemberId(), id);

		model.addAttribute("review", review);

		return "usr/review/detail";
	}

	@RequestMapping("/usr/review/modify")
	public String showModify(HttpServletRequest req, Model model, int id) {
		Rq rq = (Rq) req.getAttribute("rq");

		Review review = reviewService.getForPrintReview(rq.getLoginedMemberId(), id);
		if (review == null) {
			return Ut.jsHistoryBack("F-1", Ut.f("%d번 게시글은 없어", id));
		}
		model.addAttribute("review", review);

		return "/usr/review/modify";
	}

	@RequestMapping("/usr/review/doModify")
	@ResponseBody
	public String doModify(HttpServletRequest req, int id, String title, String body, int rating) {

		Rq rq = (Rq) req.getAttribute("rq");

		Review review = reviewService.getReviewById(id);

		if (review == null) {
			return Ut.jsHistoryBack("F-1", Ut.f("%d번 게시글은 없음", id));
		}

		ResultData userCanModifyRd = reviewService.userCanModify(rq.getLoginedMemberId(), review);

		if (userCanModifyRd.isFail()) {
			return Ut.jsHistoryBack(userCanModifyRd.getResultCode(), userCanModifyRd.getMsg());
		}

		if (userCanModifyRd.isSuccess()) {
			reviewService.modifyReview(id, title, body, rating);
		}
		review = reviewService.getReviewById(id);

		return Ut.jsReplace(userCanModifyRd.getResultCode(), userCanModifyRd.getMsg(), "../review/detail?id=" + id);
	}

	@RequestMapping("/usr/review/doDelete")
	@ResponseBody
	public String doDelete(HttpServletRequest req, int id) {
		Rq rq = (Rq) req.getAttribute("rq");

		Review review = reviewService.getReviewById(id);

		if (review == null) {
			return Ut.jsHistoryBack("F-1", Ut.f("%d번 게시글은 없음", id));
		}

		ResultData userCanDeleteRd = reviewService.userCanDelete(rq.getLoginedMemberId(), review);
		if (userCanDeleteRd.isFail()) {
			return Ut.jsHistoryBack(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg());
		}

		if (userCanDeleteRd.isSuccess()) {
			reviewService.deleteReview(id);
		}

		return Ut.jsReplace(userCanDeleteRd.getResultCode(), userCanDeleteRd.getMsg(), "../review/list");
	}

	@RequestMapping("/usr/review/list")
	public String showList(Model model, @RequestParam(defaultValue = "EXPECT") String type) {

		List<Review> reviews = reviewService.getForPrintReviewsByType(type);

		List<Concert> concerts = concertService.getConcerts().getData1();

		model.addAttribute("reviews", reviews);
		model.addAttribute("concerts", concerts);
		model.addAttribute("type", type); // 현재 어떤 탭인지 알려주기 위해 추가

		return "/usr/review/list";
	}

	@RequestMapping("/usr/review/write")
	public String showWrite(Model model, @RequestParam(defaultValue = "EXPECT") String type, Integer concertId) {
		if (!rq.isLogined()) {
			rq.printHistoryBackNT("로그인 후 이용해주세요.");
			return null;
		}
		var allConcertsRd = concertService.getConcerts();
		model.addAttribute("allConcerts", allConcertsRd.getData1());

		if (concertId != null) {

			Concert selectedConcert = concertService.getConcertById(concertId).getData1();
			model.addAttribute("selectedConcert", selectedConcert);
		}

		if (rq.isLogined()) {

	        List<Reservation> allMyReservations = reservationService.getMyReservations(rq.getLoginedMemberId());


	        List<Reservation> confirmedReservations = allMyReservations.stream()
	                .filter(r -> "CONFIRMED".equals(r.getStatus()))
	                .collect(Collectors.toList());

	        model.addAttribute("myReservations", confirmedReservations);
	    }

		return "usr/review/write";
	}

	@RequestMapping("/usr/review/doWrite")
	@ResponseBody
	public String doWrite(int concertId, String title, String body, @RequestParam(defaultValue = "0") int rating,
			String type, Integer orderId) {
		if (!rq.isLogined()) {
			rq.printHistoryBackNT("로그인 후 이용해주세요.");
			return null;
		}
		if (Ut.isEmpty(title)) {
			return Ut.jsHistoryBack("F-1", "제목을 입력해주세요.");
		}
		if (Ut.isEmpty(body)) {
			return Ut.jsHistoryBack("F-2", "내용을 입력해주세요.");
		}

		ResultData writeRd = reviewService.writeReview(rq.getLoginedMemberId(), concertId, title, body, rating, type,
				orderId);

		int id = (int) writeRd.getData1();

		return Ut.jsReplace(writeRd.getResultCode(), writeRd.getMsg(), "../review/detail?id=" + id);
	}

}