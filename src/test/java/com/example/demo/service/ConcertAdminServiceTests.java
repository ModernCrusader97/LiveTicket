package com.example.demo.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.doReturn;
import static org.mockito.Mockito.verify;

import java.util.Arrays;

import com.example.demo.repository.ConcertRepository;
import com.example.demo.repository.ReservationRepository;
import com.example.demo.vo.Concert;
import com.example.demo.vo.ResultData;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

@SpringBootTest
public class ConcertAdminServiceTests {

    @Autowired
    private ConcertAdminService concertAdminService;

    @MockBean
    private ConcertRepository concertRepository;

    @MockBean
    private ReservationRepository reservationRepository;

    @Test
    void changeConcertStatus_allows_valid_status_and_updates_repository() {
        ResultData rd = concertAdminService.changeConcertStatus(1L, "OPEN");
        assertThat(rd.isFail()).isFalse();
        verify(concertRepository).updateConcertStatus(1L, "OPEN");
    }

    @Test
    void updateConcert_blocks_when_confirmed_reservations_exist() {
        doReturn(5).when(reservationRepository).countConfirmedByConcertId(3L);

        ResultData rd = concertAdminService.updateConcert(3L, "Title", null, null, null, 0, 0, 0, 0, null, "",
                Arrays.asList("VIP"), Arrays.asList(100000), Arrays.asList(1), "");

        assertThat(rd.isFail()).isTrue();
        assertThat(rd.getMsg()).contains("이미 예매된 좌석");
    }

    @Test
    void updateConcert_blocks_when_concert_is_open() {
        doReturn(0).when(reservationRepository).countConfirmedByConcertId(4L);
        Concert c = new Concert();
        c.setId(4);
        c.setStatus("OPEN");
        doReturn(c).when(concertRepository).getConcertById(4L);

        ResultData rd = concertAdminService.updateConcert(4L, "Title", null, null, null, 0, 0, 0, 0, null, "",
                Arrays.asList("VIP"), Arrays.asList(100000), Arrays.asList(1), "");

        assertThat(rd.isFail()).isTrue();
        assertThat(rd.getMsg()).contains("판매중인 상태");
    }

}
