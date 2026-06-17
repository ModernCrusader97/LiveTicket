DROP DATABASE IF EXISTS liveticket;

CREATE DATABASE liveticket;

USE liveticket;



# 1. 회원 테이블

CREATE TABLE member (
    id          INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate     DATETIME NOT NULL,
    updateDate  DATETIME NOT NULL,
    loginId     CHAR(30) NOT NULL UNIQUE,
    loginPw     CHAR(100) NOT NULL,
    authLevel   SMALLINT(2) UNSIGNED DEFAULT 3 COMMENT '권한 레벨 (3=일반, 7=관리자)',
    name        CHAR(20) NOT NULL,
    nickname    CHAR(20) NOT NULL,
    cellphoneNum CHAR(20) NOT NULL,
    email       CHAR(20) NOT NULL,
    delStatus   TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
    delDate     DATETIME DEFAULT NULL
);



# 2. 공연 마스터 테이블 (리스트 노출 / 상세 정보용)

CREATE TABLE concert (
    id              INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate         DATETIME NOT NULL,
    updateDate      DATETIME NOT NULL,
    startDate       DATETIME,
    endDate         DATETIME,
    title           VARCHAR(100) NOT NULL,
    posterImg       VARCHAR(255) DEFAULT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'DRAFT' COMMENT '공연 상태 (DRAFT/OPEN/PAUSED/CLOSED)',
    body            TEXT,
    bookingStartAt  DATETIME NOT NULL,
    reviewCount     INT DEFAULT 0,
    totalRating     INT DEFAULT 0,
    viewCount       INT NOT NULL DEFAULT 0
);



# 3. 회차 테이블 (실제 예매 대상 — 공연당 1개 이상)

CREATE TABLE schedule (
    id          INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    concertId   INT NOT NULL,                          -- concert.id 참조
    title       VARCHAR(255),
    performDate VARCHAR(30),
    startAt     VARCHAR(30),
    totalSeats  INT DEFAULT 0,
    maxRows     INT DEFAULT 10,
    maxCols     INT DEFAULT 10,
    body        TEXT,
    status      VARCHAR(20) DEFAULT 'DRAFT',
    regDate     DATETIME,
    updateDate  DATETIME
);



# 4. 게시판 — 후기 / 기대평

CREATE TABLE review (
    id          INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate     DATETIME NOT NULL,
    updateDate  DATETIME NOT NULL,
    memberId    INT(10) UNSIGNED NOT NULL,
    concertId   INT(10) UNSIGNED NOT NULL,           -- concert.id 참조 (마스터)
    title       VARCHAR(100) NOT NULL,
    body        TEXT NOT NULL,
    rating      INT(1) UNSIGNED DEFAULT 0,           -- 별점 (0~5)
    type        CHAR(20) NOT NULL,                   -- EXPECT(기대평), REVIEW(후기)
    orderId     INT(10) UNSIGNED NULL,               -- 실제 예매 번호 (후기일 때만)
    INDEX (concertId, type)
);



# 5. 좌석 등급 (회차별)

CREATE TABLE seatGrade (
    id          INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate     DATETIME NOT NULL,
    updateDate  DATETIME NOT NULL,
    scheduleId  INT NOT NULL,                        -- schedule.id 참조
    name        VARCHAR(20) NOT NULL,
    price       INT UNSIGNED NOT NULL
);



# 6. 좌석 (회차별)

CREATE TABLE seat (
    id          INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate     DATETIME NOT NULL,
    updateDate  DATETIME NOT NULL,
    scheduleId  INT NOT NULL,                        -- schedule.id 참조
    memberId    INT(10) UNSIGNED,
    gradeId     INT(10) UNSIGNED NOT NULL,
    rowName     VARCHAR(10) NOT NULL,
    colNumber   INT UNSIGNED NOT NULL,
    status      VARCHAR(20) DEFAULT 'AVAILABLE',
    version     INT UNSIGNED DEFAULT 0,
    heldAt      DATETIME DEFAULT NULL
);



# 7. 예매 (회차별)

CREATE TABLE reservation (
    id          INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate     DATETIME NOT NULL,
    updateDate  DATETIME NOT NULL,
    memberId    INT(10) UNSIGNED NOT NULL,
    scheduleId  INT NOT NULL,                        -- schedule.id 참조
    seatId      INT(10) UNSIGNED NOT NULL,
    paidPrice   INT UNSIGNED NOT NULL,
    status      VARCHAR(20) DEFAULT 'CONFIRMED'
);



# 8. 아티스트 정보

CREATE TABLE artist (
    id          INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    name        VARCHAR(50) NOT NULL,
    profileImg  VARCHAR(255)
);



# 9. 캐스팅 매핑 (회차별 배우)

CREATE TABLE concertCasting (
    id          INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    scheduleId  INT NOT NULL,                        -- schedule.id 참조
    artistId    INT(10) UNSIGNED NOT NULL,
    roleName    VARCHAR(50) NOT NULL
);



# ---------------------------------------------------------
# 테스트 데이터 입력 시작
# ---------------------------------------------------------



# 1. 회원 데이터

INSERT INTO member (regDate, updateDate, loginId, loginPw, authLevel, name, nickname, cellphoneNum, email) VALUES
(NOW(), NOW(), 'admin', 'admin', 7, '관리자',   '최고관리자', '010-1111-2222', 'admin@test.com'),
(NOW(), NOW(), 'test1', 'test1', 3, '이종석',   '실관람객종석', '010-3333-4444', 'test1@test.com'),
(NOW(), NOW(), 'test2', 'test2', 3, '김유저',   '뮤지컬덕후',  '010-5555-6666', 'test2@test.com');



# ---------------------------------------------------------
# 2. 공연 마스터 데이터 (리스트에 노출되는 상위 공연 2개)
# ---------------------------------------------------------

# [공연 1] 뮤지컬 디어 에반 핸슨

INSERT INTO concert SET
    id = 1,
    regDate = NOW(), updateDate = NOW(),
    startDate = '2026-08-01 00:00:00',
    endDate   = '2026-09-30 23:59:59',
    title     = '뮤지컬 <디어 에반 핸슨>',
    posterImg = '/img/poster_evan.png',
    status    = 'OPEN',
    body      = '당신은 발견될 것이다. 최고의 감동 뮤지컬 디어 에반 핸슨.',
    bookingStartAt = '2026-05-01 14:00:00';


# [공연 2] 창작가무극 신과 함께_저승편

INSERT INTO concert SET
    id = 2,
    regDate = NOW(), updateDate = NOW(),
    startDate = '2026-06-13 00:00:00',
    endDate   = '2026-07-05 23:59:59',
    title     = '창작가무극 <신과 함께_저승편>',
    posterImg = '/img/poster_god.png',
    status    = 'OPEN',
    body      = '죽는다고 다 끝난 게 아니다. 네이버 웹툰 원작의 전석 매진 신화.',
    bookingStartAt = NOW();



# ---------------------------------------------------------
# 3. 회차 데이터 (실제 예매 대상)
# ---------------------------------------------------------

# 에반핸슨 1회차 (8/1 19:00) — 예매 가능

INSERT INTO schedule SET
    id = 3, concertId = 1,
    title = '뮤지컬 <디어 에반 핸슨> - 1회차',
    performDate = '2026-08-01 19:00:00',
    startAt     = '2026-08-01 19:00:00',
    totalSeats = 4, maxRows = 2, maxCols = 2,
    body   = '1회차 토요일 저녁 공연',
    status = 'OPEN',
    regDate = NOW(), updateDate = NOW();


# 에반핸슨 2회차 (8/2 14:00) — 예매 가능

INSERT INTO schedule SET
    id = 4, concertId = 1,
    title = '뮤지컬 <디어 에반 핸슨> - 2회차',
    performDate = '2026-08-02 14:00:00',
    startAt     = '2026-08-02 14:00:00',
    totalSeats = 4, maxRows = 2, maxCols = 2,
    body   = '2회차 일요일 낮 공연',
    status = 'OPEN',
    regDate = NOW(), updateDate = NOW();


# 에반핸슨 3회차 (8/2 19:00) — 티켓 오픈 전 (bookingStartAt 미래 설정으로 잠금 테스트)

INSERT INTO schedule SET
    id = 5, concertId = 1,
    title = '뮤지컬 <디어 에반 핸슨> - 3회차',
    performDate = '2026-08-02 19:00:00',
    startAt     = '2026-08-02 19:00:00',
    totalSeats = 4, maxRows = 2, maxCols = 2,
    body   = '3회차 일요일 저녁 공연',
    status = 'DRAFT',
    regDate = NOW(), updateDate = NOW();


# 신과함께 1회차 (6/13 19:00) — 예매 가능

INSERT INTO schedule SET
    id = 6, concertId = 2,
    title = '창작가무극 <신과 함께_저승편> - 1회차',
    performDate = '2026-06-13 19:00:00',
    startAt     = '2026-06-13 19:00:00',
    totalSeats = 4, maxRows = 2, maxCols = 2,
    body   = '개막 첫 공연',
    status = 'OPEN',
    regDate = NOW(), updateDate = NOW();



# ---------------------------------------------------------
# 4. 아티스트 데이터
# ---------------------------------------------------------

INSERT INTO artist (id, name, profileImg) VALUES
(1, '박강현', '/img/men.png'),
(2, '임규형', '/img/men.png'),
(3, '나현우', '/img/men.png'),
(4, '김선영', '/img/women.png'),
(5, '신영숙', '/img/women.png'),
(6, '조민호', '/img/men.png'),
(7, '이기완', '/img/men.png'),
(8, '윤태호', '/img/men.png'),
(9, '백형훈', '/img/men.png');



# ---------------------------------------------------------
# 5. 캐스팅 데이터 (회차별 배우 다르게 매핑)
# ---------------------------------------------------------

# 에반핸슨 1회차 (scheduleId=3): 박강현(에반), 김선영(하이디), 조민호(코너)
INSERT INTO concertCasting (scheduleId, artistId, roleName) VALUES
(3, 1, '에반 핸슨'), (3, 4, '하이디 핸슨'), (3, 6, '코너 머피');

# 에반핸슨 2회차 (scheduleId=4): 임규형(에반), 신영숙(하이디), 조민호(코너)
INSERT INTO concertCasting (scheduleId, artistId, roleName) VALUES
(4, 2, '에반 핸슨'), (4, 5, '하이디 핸슨'), (4, 6, '코너 머피');

# 에반핸슨 3회차 (scheduleId=5): 나현우(에반), 신영숙(하이디), 조민호(코너)
INSERT INTO concertCasting (scheduleId, artistId, roleName) VALUES
(5, 3, '에반 핸슨'), (5, 5, '하이디 핸슨'), (5, 6, '코너 머피');

# 신과함께 1회차 (scheduleId=6): 이기완, 윤태호, 백형훈
INSERT INTO concertCasting (scheduleId, artistId, roleName) VALUES
(6, 7, '진기한/자홍 등'), (6, 8, '해원맥 등'), (6, 9, '강림 등');



# ---------------------------------------------------------
# 6. 좌석 등급 & 좌석 데이터 (회차별)
# ---------------------------------------------------------

# 에반핸슨 1회차 (scheduleId=3)
INSERT INTO seatGrade (id, regDate, updateDate, scheduleId, name, price) VALUES
(1, NOW(), NOW(), 3, 'VIP', 160000),
(2, NOW(), NOW(), 3, 'R',   130000);

INSERT INTO seat (regDate, updateDate, scheduleId, gradeId, rowName, colNumber, status) VALUES
(NOW(), NOW(), 3, 1, 'A', 1, 'AVAILABLE'),
(NOW(), NOW(), 3, 1, 'A', 2, 'AVAILABLE'),
(NOW(), NOW(), 3, 2, 'B', 1, 'AVAILABLE'),
(NOW(), NOW(), 3, 2, 'B', 2, 'AVAILABLE');


# 에반핸슨 2회차 (scheduleId=4)
INSERT INTO seatGrade (id, regDate, updateDate, scheduleId, name, price) VALUES
(3, NOW(), NOW(), 4, 'VIP', 160000),
(4, NOW(), NOW(), 4, 'R',   130000);

INSERT INTO seat (regDate, updateDate, scheduleId, gradeId, rowName, colNumber, status) VALUES
(NOW(), NOW(), 4, 3, 'A', 1, 'AVAILABLE'),
(NOW(), NOW(), 4, 3, 'A', 2, 'AVAILABLE'),
(NOW(), NOW(), 4, 4, 'B', 1, 'AVAILABLE'),
(NOW(), NOW(), 4, 4, 'B', 2, 'AVAILABLE');


# 신과함께 1회차 (scheduleId=6)
INSERT INTO seatGrade (id, regDate, updateDate, scheduleId, name, price) VALUES
(5, NOW(), NOW(), 6, 'VIP', 150000),
(6, NOW(), NOW(), 6, 'R',   120000);

INSERT INTO seat (regDate, updateDate, scheduleId, gradeId, rowName, colNumber, status) VALUES
(NOW(), NOW(), 6, 5, 'A', 1, 'AVAILABLE'),
(NOW(), NOW(), 6, 5, 'A', 2, 'AVAILABLE'),
(NOW(), NOW(), 6, 6, 'B', 1, 'AVAILABLE'),
(NOW(), NOW(), 6, 6, 'B', 2, 'AVAILABLE');



# ---------------------------------------------------------
# 7. 예매 데이터
# ---------------------------------------------------------

# 이종석(memberId=2)이 에반핸슨 1회차(scheduleId=3) A-1 좌석 확정 예매 → 후기 작성 가능
INSERT INTO reservation (id, regDate, updateDate, memberId, scheduleId, seatId, paidPrice, status) VALUES
(100, NOW(), NOW(), 2, 3, 1, 160000, 'CONFIRMED');

UPDATE seat SET status = 'RESERVED', memberId = 2 WHERE id = 1;


# 이종석(memberId=2)이 에반핸슨 2회차(scheduleId=4) A-2 좌석 예매 후 취소 → 후기 작성 목록 제외
INSERT INTO reservation (id, regDate, updateDate, memberId, scheduleId, seatId, paidPrice, status) VALUES
(101, NOW(), NOW(), 2, 4, 6, 160000, 'CANCELLED');



# ---------------------------------------------------------
# 8. 리뷰 / 기대평 샘플 데이터
# ---------------------------------------------------------

# 기대평 — 뮤지컬 디어 에반 핸슨 (concertId=1 마스터)
INSERT INTO review (regDate, updateDate, memberId, concertId, title, body, rating, type, orderId) VALUES
(NOW(), NOW(), 3, 1, '박강현 배우님 첫공 너무 기대돼요!!', '에반핸슨 라인업 대박입니다 꼭 티켓팅 성공하길', 0, 'EXPECT', NULL);


# 관람 후기 — 에반핸슨 1회차 관람 후 (concertId=1 마스터, orderId=100)
INSERT INTO review (regDate, updateDate, memberId, concertId, title, body, rating, type, orderId) VALUES
(NOW(), NOW(), 2, 1, '진짜 인생 뮤지컬을 만났습니다.', 'A열 시야 최고였고 박강현 성량에 귀 녹았습니다.', 5, 'REVIEW', 100);

UPDATE concert SET reviewCount = reviewCount + 1, totalRating = totalRating + 5 WHERE id = 1;
