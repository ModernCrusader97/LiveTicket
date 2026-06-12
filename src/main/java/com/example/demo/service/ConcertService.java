package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.repository.ConcertRepository;
import com.example.demo.vo.Artist;
import com.example.demo.vo.Concert;
import com.example.demo.vo.ResultData;
import com.example.demo.vo.Seat;

@Service
public class ConcertService {

	@Autowired
	private ConcertRepository concertRepository;

	public ResultData<List<Concert>> getConcerts() {
		List<Concert> concerts = concertRepository.getConcerts();

		if (concerts.isEmpty()) {
			return ResultData.from("F-1", "공연 정보가 없습니다.");
		}

		return ResultData.from("S-1", "공연 목록 조회 성공", "concerts", concerts);
	}

	public ResultData<Concert> getConcertById(long id) {
		Concert concert = concertRepository.getConcertById(id);

		if (concert == null) {
			return ResultData.from("F-1", id + "번 공연은 존재하지 않습니다.");
		}

		return ResultData.from("S-1", id + "번 공연 조회 성공", "concert", concert);
	}

	public List<Concert> getSchedulesByMasterId(long masterId) {
		return concertRepository.getSchedulesByMasterId(masterId);
	}

	public List<Artist> getArtistsByConcertId(long concertId) {
		return concertRepository.getArtistsByConcertId(concertId);
	}

	public List<Seat> getRemainingSeats(long concertId) {
        return concertRepository.getRemainingSeats(concertId);
    }

	public List<Artist> getAllArtistsByMasterId(long masterId) {
		return concertRepository.getAllArtistsByMasterId(masterId);

	}
}