package com.example.demo.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.vo.Concert;
import com.example.demo.vo.Reservation;
import com.example.demo.vo.Seat;

@Mapper
public interface ReservationRepository {

	void releaseExpiredSeats();

	List<Seat> getSeatsByConcertId(@Param("concertId") long concertId);

	int updateSeatsToPendingBulk(@Param("memberId") int memberId, @Param("concertId") int concertId,
			@Param("seatList") List<Map<String, Object>> seatList);

	List<Reservation> getMyReservations(@Param("memberId") int memberId);

	int updateSeatToReserved(@Param("seatId") long seatId, @Param("memberId") int memberId);

	void insertReservation(@Param("memberId") int memberId, @Param("seatId") long seatId);

	int getReservedCountByMemberId(int memberId, int concertId);

	Concert getConcertById(int concertId);

	List<Seat> getSeatsByIds(List<Integer> seatIdList);

	void saveReservation(int memberId, int concertId, int seatId, int paidPrice);

	Seat getSeatWithPrice(int seatId);

	Reservation getReservationById(@Param("id") int id);

	int releaseSeatAfterCancel(@Param("seatId") long seatId);

	int cancelReservation(@Param("id") int id, @Param("memberId") int memberId);
}