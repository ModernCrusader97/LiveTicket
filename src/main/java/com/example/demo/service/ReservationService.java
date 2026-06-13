package com.example.demo.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.repository.ReservationRepository;
import com.example.demo.vo.Reservation;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Schedule;
import com.example.demo.vo.Seat;

@Service
public class ReservationService {

    @Autowired
    private ReservationRepository reservationRepository;

    @Scheduled(fixedRate = 60000)
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void scheduledReleaseExpiredSeats() {
        try {
            reservationRepository.releaseExpiredSeats();
        } catch (Exception e) {
            System.err.println("만료 좌석 해제 중 오류 발생: " + e.getMessage());
        }
    }

    public List<Seat> getSeatsByScheduleId(int scheduleId) {
        return reservationRepository.getSeatsByScheduleId(scheduleId);
    }

    @Transactional
    public ResultData holdSeats(int memberId, int scheduleId, String seatData) {
        String[] seatInfos = seatData.split(",");

        int alreadyReservedCount = reservationRepository.getReservedCountByMemberId(memberId, scheduleId);
        if (alreadyReservedCount + seatInfos.length > 4) {
            return ResultData.from("F-2", "최대 4매까지만 가능합니다.");
        }

        List<Map<String, Object>> seatList = new ArrayList<>();
        for (String info : seatInfos) {
            String[] temp = info.split(":");
            Map<String, Object> seatMap = new HashMap<>();
            seatMap.put("id", Long.parseLong(temp[0]));
            seatMap.put("version", Integer.parseInt(temp[1]));
            seatList.add(seatMap);
        }

        int affectedRows = reservationRepository.updateSeatsToPendingBulk(memberId, scheduleId, seatList);
        if (affectedRows != seatInfos.length) {
            throw new RuntimeException("일부 좌석이 이미 선점되었거나 정보가 변경되었습니다. 다시 시도해주세요.");
        }

        return ResultData.from("S-1", "선택하신 " + affectedRows + "개 좌석이 모두 선점되었습니다.");
    }

    public List<Reservation> getMyReservations(int memberId) {
        return reservationRepository.getMyReservations(memberId);
    }

    @Transactional
    public ResultData confirmReservation(int memberId, int scheduleId, String seatIds) {
        List<Integer> seatIdList = Arrays.stream(seatIds.split(","))
                .map(Integer::parseInt)
                .collect(Collectors.toList());

        for (int seatId : seatIdList) {
            Seat seat = reservationRepository.getSeatWithPrice(seatId);
            if (seat == null) {
                throw new RuntimeException(seatId + "번 좌석 정보를 찾을 수 없습니다.");
            }

            int affectedRows = reservationRepository.updateSeatToReserved(seatId, memberId);
            if (affectedRows == 0) {
                throw new RuntimeException(seatId + "번 좌석 예매 중 오류가 발생했습니다. (점유 만료 등)");
            }

            int paidPrice = seat.getExtra__price();
            reservationRepository.saveReservation(memberId, scheduleId, seatId, paidPrice);
        }

        return ResultData.from("S-1", "예매 및 결제가 완료되었습니다.");
    }

    public int getReservedCount(int memberId, int scheduleId) {
        return reservationRepository.getReservedCountByMemberId(memberId, scheduleId);
    }

    public Schedule getScheduleById(int scheduleId) {
        return reservationRepository.getScheduleById(scheduleId);
    }

    public List<Seat> getSeatsByIds(List<Integer> seatIdList) {
        return reservationRepository.getSeatsByIds(seatIdList);
    }

    @Transactional
    public ResultData doCancel(int memberId, int reservationId) {
        Reservation reservation = reservationRepository.getReservationById(reservationId);

        if (reservation == null) {
            return ResultData.from("F-1", "존재하지 않는 예약입니다.");
        }
        if (reservation.getMemberId() != memberId) {
            return ResultData.from("F-2", "취소 권한이 없습니다.");
        }
        if ("CANCELLED".equals(reservation.getStatus())) {
            return ResultData.from("F-3", "이미 취소된 예약입니다.");
        }

        int seatUpdateRd = reservationRepository.releaseSeatAfterCancel(reservation.getSeatId());
        if (seatUpdateRd == 0) {
            throw new RuntimeException("좌석 상태를 변경할 수 없어 취소가 실패했습니다.");
        }

        reservationRepository.cancelReservation(reservationId, memberId);
        return ResultData.from("S-1", "예매가 정상적으로 취소되었습니다.");
    }
}
