package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.demo.service.ConcertAdminService;
import com.example.demo.service.ConcertService;
import com.example.demo.vo.Concert;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Schedule;

@Controller
public class AdminConcertController {

    @Autowired
    private ConcertAdminService concertAdminService;

    @Autowired
    private ConcertService concertService;

    @GetMapping("/admin/concert/create")
    public String showCreateForm(Model model) {
        return "admin/concert/create";
    }

    @PostMapping("/admin/concert/create")
    public String doCreate(
            @RequestParam String title,
            @RequestParam(required = false) MultipartFile posterFile,
            @RequestParam(required = false) String bookingStartAt,
            @RequestParam(required = false) String body,
            @RequestParam(defaultValue = "0") int totalSeats,
            @RequestParam(defaultValue = "10") int maxRows,
            @RequestParam(defaultValue = "10") int maxCols,
            @RequestParam(defaultValue = "0") int price,
            @RequestParam(required = false) List<String> gradeNames,
            @RequestParam(required = false) List<Integer> gradePrices,
            @RequestParam(required = false) List<Integer> gradeRowCounts,
            @RequestParam(defaultValue = "") String disabledSeatsStr,
            @RequestParam(required = false) String schedulesData,
            @RequestParam(required = false) List<String> newArtistNames,
            @RequestParam(required = false) List<String> newArtistNotes,
            @RequestParam(required = false) List<String> newArtistTempIds,
            @RequestParam(required = false) MultipartFile[] artistFiles,
            Model model) {

        ResultData rd = concertAdminService.createConcert(title, posterFile,
                bookingStartAt, body, totalSeats, maxRows, maxCols, price,
                gradeNames, gradePrices, gradeRowCounts, disabledSeatsStr, schedulesData,
                newArtistNames, newArtistNotes, newArtistTempIds, artistFiles);

        if (rd.isFail()) {
            model.addAttribute("msg", rd.getMsg());
            return "admin/concert/create";
        }

        model.addAttribute("msg", rd.getMsg());
        model.addAttribute("id", rd.getData1());
        return "admin/concert/create_done";
    }

    @GetMapping("/admin/concert/list")
    public String showList(Model model) {
        ResultData rd = concertService.getConcerts();
        model.addAttribute("concerts", rd.isFail() ? new ArrayList<>() : rd.getData1());
        return "admin/concert/list";
    }

    @GetMapping("/admin/concert/detail")
    public String showDetail(@RequestParam long id, Model model) {
        ResultData concertRd = concertService.getConcertById(id);
        if (concertRd.isFail()) {
            model.addAttribute("msg", concertRd.getMsg());
            return "admin/concert/not_found";
        }

        Concert concert = (Concert) concertRd.getData1();
        List<Schedule> schedules = concertService.getSchedulesByConcertId(id);

        model.addAttribute("concert", concert);
        model.addAttribute("schedules", schedules);

        // Aggregate sales stats across all schedules
        Map<String, Object> stats = concertService.getSalesStatsByConcertId(id);
        if (stats == null) {
            model.addAttribute("reservedCount", 0);
            model.addAttribute("revenue", 0);
            model.addAttribute("totalSeats", 0);
        } else {
            int totalSeats = stats.get("totalSeats") == null ? 0 : ((Number) stats.get("totalSeats")).intValue();
            int reservedCount = stats.get("reservedCount") == null ? 0 : ((Number) stats.get("reservedCount")).intValue();
            long revenue = stats.get("revenue") == null ? 0L : ((Number) stats.get("revenue")).longValue();
            double bookingRate = totalSeats > 0 ? (reservedCount * 100.0 / totalSeats) : 0.0;
            model.addAttribute("reservedCount", reservedCount);
            model.addAttribute("revenue", revenue);
            model.addAttribute("totalSeats", totalSeats);
            model.addAttribute("bookingRate", String.format("%.1f", bookingRate));
        }

        return "admin/concert/detail";
    }

    @GetMapping("/admin/concert/edit")
    public String showEditForm(@RequestParam long id, Model model) {
        ResultData concertRd = concertService.getConcertById(id);
        if (concertRd.isFail()) {
            model.addAttribute("msg", concertRd.getMsg());
            return "admin/concert/not_found";
        }
        model.addAttribute("concert", concertRd.getData1());
        model.addAttribute("schedules", concertService.getSchedulesByConcertId(id));
        return "admin/concert/edit";
    }

    @PostMapping("/admin/concert/modify")
    public String doModify(
            @RequestParam long id,
            @RequestParam String title,
            @RequestParam(required = false) MultipartFile posterFile,
            @RequestParam(required = false) String bookingStartAt,
            @RequestParam(required = false) String body,
            Model model) {

        ResultData rd = concertAdminService.updateConcert(id, title, posterFile, bookingStartAt, body);
        if (rd.isFail()) {
            model.addAttribute("msg", rd.getMsg());
            return "admin/concert/edit";
        }
        return "redirect:/admin/concert/detail?id=" + id;
    }

    @PostMapping("/admin/schedule/modify")
    public String doModifySchedule(
            @RequestParam long scheduleId,
            @RequestParam long concertId,
            @RequestParam String title,
            @RequestParam(required = false) String performDate,
            @RequestParam(required = false) String startAt,
            @RequestParam(required = false) Integer totalSeats,
            @RequestParam(required = false) Integer maxRows,
            @RequestParam(required = false) Integer maxCols,
            @RequestParam(required = false) Integer price,
            @RequestParam(required = false) String body,
            @RequestParam(required = false) List<String> gradeNames,
            @RequestParam(required = false) List<Integer> gradePrices,
            @RequestParam(required = false) List<Integer> gradeRowCounts,
            @RequestParam(required = false) String disabledSeatsStr,
            Model model) {

        ResultData rd = concertAdminService.updateSchedule(scheduleId, title, performDate, startAt,
                totalSeats, maxRows, maxCols, price, body, gradeNames, gradePrices, gradeRowCounts, disabledSeatsStr);
        if (rd.isFail()) {
            model.addAttribute("msg", rd.getMsg());
            return "admin/concert/edit";
        }
        return "redirect:/admin/concert/detail?id=" + concertId;
    }

    @PostMapping("/admin/concert/statusChange")
    public String changeConcertStatus(@RequestParam long id, @RequestParam String status, Model model) {
        ResultData rd = concertAdminService.changeConcertStatus(id, status);
        if (rd.isFail()) {
            model.addAttribute("msg", rd.getMsg());
        }
        return "redirect:/admin/concert/detail?id=" + id;
    }

    @PostMapping("/admin/schedule/statusChange")
    public String changeScheduleStatus(@RequestParam long scheduleId, @RequestParam long concertId,
            @RequestParam String status, Model model) {
        ResultData rd = concertAdminService.changeScheduleStatus(scheduleId, status);
        if (rd.isFail()) {
            model.addAttribute("msg", rd.getMsg());
        }
        return "redirect:/admin/concert/detail?id=" + concertId;
    }
}
