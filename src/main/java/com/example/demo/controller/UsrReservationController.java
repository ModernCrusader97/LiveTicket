package com.example.demo.controller;

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
import com.example.demo.vo.Reservation;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Rq;
import com.example.demo.vo.Schedule;
import com.example.demo.vo.Seat;

@Controller
public class UsrReservationController {

    @Autowired
    private ReservationService reservationService;
    @Autowired
    private Rq rq;

    @RequestMapping("/usr/reservation/mylist")
    public String showMyList(Model model) {
        if (!rq.isLogined()) {
            rq.printHistoryBackNT("로그인 후 이용해주세요.");
            return null;
        }
        List<Reservation> myReservations = reservationService.getMyReservations(rq.getLoginedMemberId());
        model.addAttribute("myReservations", myReservations);
        return "usr/reservation/mylist";
    }

    @RequestMapping("/usr/reservation/seatMap")
    public String showSeatMap(Model model, Integer scheduleId) {
        rq.disableCache();

        if (!rq.isLogined()) {
            rq.printHistoryBackNT("로그인 후 이용해주세요.");
            return null;
        }
        if (Ut.isEmpty(scheduleId)) {
            rq.printHistoryBackNT("공연 회차 번호가 없습니다.");
            return null;
        }

        int alreadyReservedCount = reservationService.getReservedCount(rq.getLoginedMemberId(), scheduleId);
        model.addAttribute("alreadyReservedCount", alreadyReservedCount);
        model.addAttribute("maxLimit", 4);

        List<Seat> allSeats = reservationService.getSeatsByScheduleId(scheduleId);

        Map<String, List<Seat>> groupedSeats = new TreeMap<>();
        for (Seat seat : allSeats) {
            groupedSeats.computeIfAbsent(seat.getRowName(), k -> new ArrayList<>()).add(seat);
        }
        for (List<Seat> rowSeats : groupedSeats.values()) {
            rowSeats.sort(Comparator.comparingInt(Seat::getColNumber));
        }

        model.addAttribute("loginedMemberId", rq.getLoginedMemberId());
        model.addAttribute("groupedSeats", groupedSeats);
        model.addAttribute("seats", allSeats);
        model.addAttribute("scheduleId", scheduleId);

        return "usr/reservation/seatMap";
    }

    @RequestMapping("/usr/reservation/payment")
    public String showPayment(int scheduleId, String seatIds, Model model) {
        if (!rq.isLogined()) {
            rq.printHistoryBackNT("로그인 후 이용해주세요.");
            return null;
        }

        Schedule schedule = reservationService.getScheduleById(scheduleId);

        List<Integer> seatIdList = Arrays.stream(seatIds.split(","))
                .map(Integer::parseInt)
                .collect(Collectors.toList());

        List<Seat> selectedSeats = reservationService.getSeatsByIds(seatIdList);

        model.addAttribute("schedule", schedule);
        model.addAttribute("selectedSeats", selectedSeats);
        model.addAttribute("seatIds", seatIds);
        return "usr/reservation/payment";
    }

    @RequestMapping("/usr/reservation/doHold")
    public String doHold(int scheduleId, String seatIds) {
        if (!rq.isLogined()) {
            rq.printHistoryBackNT("로그인 후 이용해주세요.");
            return null;
        }
        if (Ut.isEmpty(seatIds)) {
            rq.printHistoryBackNT("선택된 좌석이 없습니다.");
            return null;
        }

        ResultData holdRd = reservationService.holdSeats(rq.getLoginedMemberId(), scheduleId, seatIds);
        if (holdRd.isFail()) {
            rq.printHistoryBackNT(holdRd.getMsg());
            return null;
        }

        String cleanIds = Arrays.stream(seatIds.split(","))
                .map(s -> s.split(":")[0])
                .collect(Collectors.joining(","));

        return "redirect:../reservation/payment?scheduleId=" + scheduleId + "&seatIds=" + cleanIds;
    }

    @PostMapping("/usr/reservation/doConfirm")
    @ResponseBody
    public String doConfirm(int scheduleId, String seatIds) {
        if (Ut.isEmpty(seatIds)) {
            return Ut.jsHistoryBack("F-1", "좌석 정보가 올바르지 않습니다.");
        }

        ResultData confirmRd = reservationService.confirmReservation(rq.getLoginedMemberId(), scheduleId, seatIds);
        if (confirmRd.isFail()) {
            return Ut.jsHistoryBack(confirmRd.getResultCode(), confirmRd.getMsg());
        }

        return Ut.jsReplace(confirmRd.getResultCode(), confirmRd.getMsg(), "../reservation/mylist");
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
