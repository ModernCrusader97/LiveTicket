package com.example.demo.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.LinkedHashMap;
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

        // Group by grade first, then by rowName within each grade
        Comparator<String> rowComparator = (a, b) -> {
            try { return Integer.compare(Integer.parseInt(a), Integer.parseInt(b)); }
            catch (NumberFormatException e) { return a.compareTo(b); }
        };

        Map<Long, Map<String, Object>> zoneMap = new LinkedHashMap<>();
        for (Seat seat : allSeats) {
            long gradeId = seat.getGradeId();
            if (!zoneMap.containsKey(gradeId)) {
                Map<String, Object> zone = new LinkedHashMap<>();
                zone.put("gradeName", seat.getExtra__gradeName());
                zone.put("gradePrice", seat.getExtra__price());
                zone.put("rows", new TreeMap<>(rowComparator));
                zoneMap.put(gradeId, zone);
            }
            @SuppressWarnings("unchecked")
            Map<String, List<Seat>> rows = (Map<String, List<Seat>>) zoneMap.get(gradeId).get("rows");
            rows.computeIfAbsent(seat.getRowName(), k -> new ArrayList<>()).add(seat);
        }
        for (Map<String, Object> zone : zoneMap.values()) {
            @SuppressWarnings("unchecked")
            Map<String, List<Seat>> rows = (Map<String, List<Seat>>) zone.get("rows");
            for (List<Seat> rowSeats : rows.values()) {
                rowSeats.sort(Comparator.comparingInt(Seat::getColNumber));
            }
        }
        List<Map<String, Object>> seatZones = new ArrayList<>(zoneMap.values());

        model.addAttribute("loginedMemberId", rq.getLoginedMemberId());
        model.addAttribute("seatZones", seatZones);
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
