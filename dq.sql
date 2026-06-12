DROP DATABASE IF EXISTS `liveticket`;

CREATE DATABASE `liveticket`;

USE `liveticket`;



# 1. 회원 테이블

CREATE TABLE `member` (

    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,

    regDate DATETIME NOT NULL,

    updateDate DATETIME NOT NULL,

    loginId CHAR(30) NOT NULL UNIQUE,

    loginPw CHAR(100) NOT NULL,

    `authLevel` SMALLINT(2) UNSIGNED DEFAULT 3 COMMENT '권한 레벨 (3=일반, 7=관리자)',

    `name` CHAR(20) NOT NULL,

    nickname CHAR(20) NOT NULL,

    cellphoneNum CHAR(20) NOT NULL,

    email CHAR(20) NOT NULL,

    delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,

    delDate DATETIME DEFAULT NULL

);



# 2. 게시판 관련

CREATE TABLE review (

    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,

    regDate DATETIME NOT NULL,

    updateDate DATETIME NOT NULL,

    memberId INT(10) UNSIGNED NOT NULL,

    concertId INT(10) UNSIGNED NOT NULL, -- 어떤 공연인가?

    title VARCHAR(100) NOT NULL,         -- 제목 (유지!)

    `body` TEXT NOT NULL,                -- 내용

    rating INT(1) UNSIGNED DEFAULT 0,    -- 별점 (0~5)

    `type` CHAR(20) NOT NULL,            -- EXPECT(기대평), REVIEW(후기)

    orderId INT(10) UNSIGNED NULL,       -- 실제 예매 번호 (후기일 때만)

    INDEX (concertId, `type`)

);

# 3. 공연 관련

CREATE TABLE concert (

    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,

    performDate DATETIME NOT NULL,

    startDate DATETIME NOT NULL,

    endDate DATETIME NOT NULL,

    title VARCHAR(100) NOT NULL,

    `body` TEXT,

    startAt DATETIME NOT NULL,

    bookingStartAt DATETIME NOT NULL,

    totalSeats INT UNSIGNED,

    maxRows INT UNSIGNED,

    reviewCount INT DEFAULT 0,

    totalRating INT DEFAULT 0,

    maxCols INT UNSIGNED

);

ALTER TABLE concert ADD COLUMN parentId INT(10) UNSIGNED DEFAULT 0 AFTER id;

ALTER TABLE concert ADD COLUMN posterImg VARCHAR(255) DEFAULT NULL AFTER title;



# 4. 좌석 등급

CREATE TABLE seatGrade (

    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,

    regDate DATETIME NOT NULL,

    updateDate DATETIME NOT NULL,

    concertId INT(10) UNSIGNED NOT NULL,

    `name` VARCHAR(20) NOT NULL,

    price INT UNSIGNED NOT NULL

);



# 5. 좌석

CREATE TABLE seat (

    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,

    regDate DATETIME NOT NULL,

    updateDate DATETIME NOT NULL,

    concertId INT(10) UNSIGNED NOT NULL,

    memberId INT(10) UNSIGNED,

    gradeId INT(10) UNSIGNED NOT NULL,

    rowName VARCHAR(10) NOT NULL,

    colNumber INT UNSIGNED NOT NULL,

    `status` VARCHAR(20) DEFAULT 'AVAILABLE',

    `version` INT UNSIGNED DEFAULT 0,

    heldAt DATETIME DEFAULT NULL

);



# 6. 예약

CREATE TABLE reservation (

    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,

    regDate DATETIME NOT NULL,

    updateDate DATETIME NOT NULL,

    memberId INT(10) UNSIGNED NOT NULL,

    `concertId` INT(10) UNSIGNED NOT NULL,

    seatId INT(10) UNSIGNED NOT NULL,

    paidPrice INT UNSIGNED NOT NULL,

    `status` VARCHAR(20) DEFAULT 'CONFIRMED'

);

# 아티스트 정보

CREATE TABLE artist (

    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,

    `name` VARCHAR(50) NOT NULL,

    profileImg VARCHAR(255)

);



CREATE TABLE concertCasting (

    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,

    concertId INT(10) UNSIGNED NOT NULL,

    artistId INT(10) UNSIGNED NOT NULL,

    roleName VARCHAR(50) NOT NULL

);

# ---------------------------------------------------------

# 테스트 데이터 입력 시작

# ---------------------------------------------------------



# 회원 데이터

INSERT INTO `member` (regDate, updateDate, loginId, loginPw, authLevel, `name`, nickname, cellphoneNum, email) VALUES 

(NOW(), NOW(), 'admin', 'admin', 7, '관리자', '최고관리자', '010-1111-2222', 'admin@test.com'),

(NOW(), NOW(), 'test1', 'test1', 3, '이종석', '실관람객종석', '010-3333-4444', 'test1@test.com'),

(NOW(), NOW(), 'test2', 'test2', 3, '김유저', '뮤지컬덕후', '010-5555-6666', 'test2@test.com');

SELECT * FROM concert;



# ---------------------------------------------------------

# 2. 공연 데이터 (Master형 공연 2개 + 하위 회차형 공연 4개)

# ---------------------------------------------------------

# [공연 1] 디어 에반 핸슨 - 상위 마스터 (parentId = 0, 리스트 노출용)

INSERT INTO concert SET id = 1, parentId = 0, performDate = '2026-08-01 00:00:00', startDate = '2026-08-01 00:00:00', 

endDate = '2026-09-30 23:59:59', title = '뮤지컬 <디어 에반 핸슨>', posterImg = '/img/poster_evan.png', `body` = '당신은 발견될 것이다. 최고의 감동 뮤지컬 디어 에반 핸슨.', 

startAt = NOW(), bookingStartAt = '2026-05-01 14:00:00', totalSeats = 0, maxRows = 0, maxCols = 0;



# [공연 1의 하위 회차] - 1회차 (8/1 19:00) -> 실제 예매 대상

INSERT INTO concert SET id = 3, parentId = 1, performDate = '2026-08-01 19:00:00', startDate = '2026-08-01 00:00:00', 

endDate = '2026-09-30 23:59:59', title = '뮤지컬 <디어 에반 핸슨> - 1회차', posterImg = '/img/poster_evan.png', `body` = '1회차 토요일 저녁 공연', 

startAt = NOW(), bookingStartAt = '2026-05-01 14:00:00', totalSeats = 4, maxRows = 2, maxCols = 2;



# [공연 1의 하위 회차] - 2회차 (8/2 14:00) -> 실제 예매 대상

INSERT INTO concert SET id = 4, parentId = 1, performDate = '2026-08-02 14:00:00', startDate = '2026-08-01 00:00:00', 

endDate = '2026-09-30 23:59:59', title = '뮤지컬 <디어 에반 핸슨> - 2회차', posterImg = '/img/poster_evan.png', `body` = '2회차 일요일 낮 공연', 

startAt = NOW(), bookingStartAt = '2026-05-01 14:00:00', totalSeats = 4, maxRows = 2, maxCols = 2;



# [공연 1의 하위 회차] - 3회차 (8/2 19:00) -> 티켓 오픈 전 제한 테스트용 (bookingStartAt을 미래 시간으로 설정)

INSERT INTO concert SET id = 5, parentId = 1, performDate = '2026-08-02 19:00:00', startDate = '2026-08-01 00:00:00',

 endDate = '2026-09-30 23:59:59', title = '뮤지컬 <디어 에반 핸슨> - 3회차', posterImg = '/img/poster_evan.png', `body` = '3회차 일요일 저녁 공연', 

 startAt = NOW(), bookingStartAt = '2026-07-31 14:00:00', totalSeats = 4, maxRows = 2, maxCols = 2;





# [공연 2] 신과 함께_저승편 - 상위 마스터 (parentId = 0, 리스트 노출용)

INSERT INTO concert SET id = 2, parentId = 0, performDate = '2026-06-13 00:00:00', startDate = '2026-06-13 00:00:00', 

endDate = '2026-07-05 23:59:59', title = '창작가무극 <신과 함께_저승편>', posterImg = '/img/poster_god.png', `body` = '죽는다고 다 끝난 게 아니다. 네이버 웹툰 원작의 전석 매진 신화.', 

startAt = NOW(), bookingStartAt = NOW(), totalSeats = 4, maxRows = 2, maxCols = 2;



# [공연 2의 하위 회차] - 1회차 (6/13 19:00)

INSERT INTO concert SET id = 6, parentId = 2, performDate = '2026-06-13 19:00:00', startDate = '2026-06-13 00:00:00', 

endDate = '2026-07-05 23:59:59', title = '창작가무극 <신과 함께_저승편> - 1회차', posterImg = '/img/poster_god.png', `body` = '개막 첫 공연', 

startAt = NOW(), bookingStartAt = NOW(), totalSeats = 4, maxRows = 2, maxCols = 2;



INSERT INTO artist (id, `name`, profileImg) VALUES

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

# 4. 회차별 캐스팅 매핑 데이터 (★ 회차마다 배우가 다르게 매칭되는 핵심)

# ---------------------------------------------------------

# 에반핸슨 1회차(id=3): 박강현(에반), 김선영(하이디), 조민호(코너)

INSERT INTO concertCasting (concertId, artistId, roleName) VALUES 

(3, 1, '에반 핸슨'), (3, 4, '하이디 핸슨'), (3, 6, '코너 머피');



# 에반핸슨 2회차(id=4): 임규형(에반), 신영숙(하이디), 조민호(코너) -> 캐스팅 변경 반영

INSERT INTO concertCasting (concertId, artistId, roleName) VALUES 

(4, 2, '에반 핸슨'), (4, 5, '하이디 핸슨'), (4, 6, '코너 머피');



# 에반핸슨 3회차(id=5): 나현우(에반), 신영숙(하이디), 조민호(코너)

INSERT INTO concertCasting (concertId, artistId, roleName) VALUES 

(5, 3, '에반 핸슨'), (5, 5, '하이디 핸슨'), (5, 6, '코너 머피');



# 신과함께 1회차(id=6): 이기완, 윤태호, 백형훈 출연

INSERT INTO concertCasting (concertId, artistId, roleName) VALUES 

(6, 7, '진기한/자홍 등'), (6, 8, '해원맥 등'), (6, 9, '강림 등');



# 에반핸슨 1회차(id=3) 좌석 정보

INSERT INTO seatGrade (regDate, updateDate, concertId, `name`, price) VALUES (NOW(), NOW(), 3, 'VIP', 160000), (NOW(), NOW(), 3, 'R', 130000);

INSERT INTO seat (regDate, updateDate, concertId, gradeId, rowName, colNumber, `status`) VALUES 

(NOW(), NOW(), 3, 1, 'A', 1, 'AVAILABLE'), (NOW(), NOW(), 3, 1, 'A', 2, 'AVAILABLE'),

(NOW(), NOW(), 3, 2, 'B', 1, 'AVAILABLE'), (NOW(), NOW(), 3, 2, 'B', 2, 'AVAILABLE');



# 에반핸슨 2회차(id=4) 좌석 정보

INSERT INTO seatGrade (regDate, updateDate, concertId, `name`, price) VALUES (NOW(), NOW(), 4, 'VIP', 160000), (NOW(), NOW(), 4, 'R', 130000);

INSERT INTO seat (regDate, updateDate, concertId, gradeId, rowName, colNumber, `status`) VALUES 

(NOW(), NOW(), 4, 1, 'A', 1, 'AVAILABLE'), (NOW(), NOW(), 4, 1, 'A', 2, 'AVAILABLE'),

(NOW(), NOW(), 4, 2, 'B', 1, 'AVAILABLE'), (NOW(), NOW(), 4, 2, 'B', 2, 'AVAILABLE');



# 이종석(memberId=2)이 에반핸슨 1회차(concertId=3)의 A-1 좌석을 확정 예매함 -> 후기 작성 가능!

INSERT INTO reservation (id, regDate, updateDate, memberId, concertId, seatId, paidPrice, `status`) VALUES 

(100, NOW(), NOW(), 2, 3, 1, 160000, 'CONFIRMED');

UPDATE seat SET `status` = 'SOLD', memberId = 2 WHERE id = 1;



# 이종석(memberId=2)이 에반핸슨 2회차(concertId=4)의 A-2 좌석을 예매했다가 취소함 -> 후기 작성 목록에서 제외되어야 함!

INSERT INTO reservation (id, regDate, updateDate, memberId, concertId, seatId, paidPrice, `status`) VALUES 

(101, NOW(), NOW(), 2, 4, 6, 160000, 'CANCELLED'); -- status 가 CONFIRMED 가 아니므로 취소표 상태



# ---------------------------------------------------------

# 7. 리뷰 및 기대평 샘플 데이터

# ---------------------------------------------------------

# 기대평 데이터 (상위 마스터 아이디 혹은 하위 아이디 둘 다 연동 가능하나, 보통 마스터에 묶어 보여줍니다)

INSERT INTO review (regDate, updateDate, memberId, concertId, title, `body`, rating, `type`, orderId) VALUES 

(NOW(), NOW(), 3, 1, '박강현 배우님 첫공 너무 기대돼요!!', '에반핸슨 라인업 대박입니다 꼭 티켓팅 성공하길', 0, 'EXPECT', NULL);





INSERT INTO review (regDate, updateDate, memberId, concertId, title, `body`, rating, `type`, orderId) VALUES 

(NOW(), NOW(), 2, 3, '진짜 인생 뮤지컬을 만났습니다.', 'A열 시야 최고였고 박강현 성량에 귀 녹았습니다.', 5, 'REVIEW', 100);
UPDATE concert
SET reviewCount = reviewCount + 1,
totalRating = totalRating + 5
WHERE id = 3


INSERT INTO seatGrade (regDate, updateDate, concertId, `name`, price) VALUES (NOW(), NOW(), 6, 'VIP', 160000), (NOW(), NOW(), 6, 'R', 130000);

INSERT INTO seat (regDate, updateDate, concertId, gradeId, rowName, colNumber, `status`) VALUES 

(NOW(), NOW(), 6, 3, 'A', 1, 'AVAILABLE'), (NOW(), NOW(), 6, 3, 'A', 2, 'AVAILABLE'),

(NOW(), NOW(), 6, 4, 'B', 1, 'AVAILABLE'), (NOW(), NOW(), 6, 4, 'B', 2, 'AVAILABLE');

# 1. 꼬여버린 기존 좌석 데이터 초기화 (다른 데이터는 건드리지 않음)

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE `seatGrade`;

TRUNCATE TABLE `seat`;

SET FOREIGN_KEY_CHECKS = 1;



# ---------------------------------------------------------

# 2. 에반핸슨 1회차(id=3) 좌석 데이터 (gradeId: 1, 2로 고정)

# ---------------------------------------------------------

INSERT INTO seatGrade (id, regDate, updateDate, concertId, `name`, price) VALUES 

(1, NOW(), NOW(), 3, 'VIP', 160000), 

(2, NOW(), NOW(), 3, 'R', 130000);



INSERT INTO seat (regDate, updateDate, concertId, gradeId, rowName, colNumber, `status`) VALUES 

(NOW(), NOW(), 3, 1, 'A', 1, 'AVAILABLE'), (NOW(), NOW(), 3, 1, 'A', 2, 'AVAILABLE'),

(NOW(), NOW(), 3, 2, 'B', 1, 'AVAILABLE'), (NOW(), NOW(), 3, 2, 'B', 2, 'AVAILABLE');



# ---------------------------------------------------------

# 3. 에반핸슨 2회차(id=4) 좌석 데이터 (gradeId: 3, 4로 고정)

# ---------------------------------------------------------

INSERT INTO seatGrade (id, regDate, updateDate, concertId, `name`, price) VALUES 

(3, NOW(), NOW(), 4, 'VIP', 160000), 

(4, NOW(), NOW(), 4, 'R', 130000);



INSERT INTO seat (regDate, updateDate, concertId, gradeId, rowName, colNumber, `status`) VALUES 

(NOW(), NOW(), 4, 3, 'A', 1, 'AVAILABLE'), (NOW(), NOW(), 4, 3, 'A', 2, 'AVAILABLE'),

(NOW(), NOW(), 4, 4, 'B', 1, 'AVAILABLE'), (NOW(), NOW(), 4, 4, 'B', 2, 'AVAILABLE');



# ---------------------------------------------------------

# 4. 신과함께 1회차(id=6) 좌석 데이터 (gradeId: 5, 6으로 고정)

# ---------------------------------------------------------

INSERT INTO seatGrade (id, regDate, updateDate, concertId, `name`, price) VALUES 

(5, NOW(), NOW(), 6, 'VIP', 150000), 

(6, NOW(), NOW(), 6, 'R', 120000);



INSERT INTO seat (regDate, updateDate, concertId, gradeId, rowName, colNumber, `status`) VALUES 

(NOW(), NOW(), 6, 5, 'A', 1, 'AVAILABLE'), (NOW(), NOW(), 6, 5, 'A', 2, 'AVAILABLE'),

(NOW(), NOW(), 6, 6, 'B', 1, 'AVAILABLE'), (NOW(), NOW(), 6, 6, 'B', 2, 'AVAILABLE');



# 예매 취소 내역 롤백 (에반핸슨 1회차 A-1 예약 연동 복구)

UPDATE seat SET `status` = 'SOLD', memberId = 2 WHERE id = 1;

    

SELECT * FROM concert WHERE parentId = 0;

SELECT * FROM concert WHERE parentId = 1 OR id = 1 ORDER BY performDate ASC;



SELECT CC.roleName, A.name, A.profileImg 

FROM concertCasting CC

JOIN artist A ON CC.artistId = A.id

WHERE CC.concertId = 4;



SELECT * FROM reservation WHERE memberId = 2 AND `status` = 'CONFIRMED';



# 1. 테스트할 공연(마스터 id=1 및 오픈 전 회차 id=5)의 오픈 시간을 현재 시간 + 2분으로 변경

UPDATE concert 

SET bookingStartAt = DATE_ADD(NOW(), INTERVAL 2 MINUTE) 

WHERE id IN (1, 5);



# 2. 반영된 예매 오픈 시간과 현재 DB 시간 확인하기

SELECT id, title, bookingStartAt, NOW() AS `현재DB시간`

FROM concert 

WHERE id IN (1, 5); 

# 1. 디어 에반 핸슨 1회차(id=3)의 공연 시간을 '어제'로 변경 (관람 완료 상태 만들기)
UPDATE concert 
SET performDate = DATE_SUB(NOW(), INTERVAL 1 DAY) 
WHERE id = 3;