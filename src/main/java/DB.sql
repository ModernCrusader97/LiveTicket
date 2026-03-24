DROP DATABASE IF EXISTS liveticket;
CREATE DATABASE liveticket;
USE liveticket;

# 2. Member (회원) 테이블
CREATE TABLE `member` (
    id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    login_id VARCHAR(50) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `role` V`am_jsp_2026_02``test``mysql`ARCHAR(20) DEFAULT 'ROLE_USER'
);

# 3. Concert (공연) 테이블
CREATE TABLE concert (
    id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    `description` TEXT,
    start_at DATETIME NOT NULL,
    booking_start_at DATETIME NOT NULL,
    total_seats INT UNSIGNED,
    MAX_ROWS INT UNSIGNED,
    max_cols INT UNSIGNED
);

# 4. Seat_Grade (좌석 등급) 테이블
CREATE TABLE seat_grade (
    id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    concert_id BIGINT UNSIGNED NOT NULL,
    grade_name VARCHAR(20) NOT NULL,
    price INT UNSIGNED NOT NULL
);

# 5. Seat (좌석) 테이블
CREATE TABLE seat (
    id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    concert_id BIGINT UNSIGNED NOT NULL,
    grade_id BIGINT UNSIGNED NOT NULL,
    row_name VARCHAR(10) NOT NULL,
    col_number INT UNSIGNED NOT NULL,
    `status` VARCHAR(20) DEFAULT 'AVAILABLE',
    `version` INT UNSIGNED DEFAULT 0
);

# 6. Reservation (예약) 테이블
CREATE TABLE reservation (
    id BIGINT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    member_id BIGINT UNSIGNED NOT NULL,
    seat_id BIGINT UNSIGNED NOT NULL UNIQUE,
    reserved_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    paid_price INT UNSIGNED NOT NULL,
    `status` VARCHAR(20) DEFAULT 'CONFIRMED'
);

# ==========================================
# 🧪 테스트용 더미 데이터 삽입 (Dummy Data)
# ==========================================

# 회원 데이터 (관리자 1명, 일반유저 1명)
INSERT INTO `member` SET login_id = 'admin', `password` = 'admin123', `name` = '관리자', `role` = 'ROLE_ADMIN';
INSERT INTO `member` SET login_id = 'user`information_schema``mysql`1', `password` = '1234', `name` = '홍길동', `role` = 'ROLE_USER';

# 공연 데이터 1개 (당장 내일 공연한다고 가정)
INSERT INTO concert SET 
    title = '2026 LiveTicket 그랜드 오픈 콘서트', 
    `description` = '라이브티켓 오픈 기념 최고의 아티스트들이 모입니다.',
    start_at = DATE_ADD(NOW(), INTERVAL 2 DAY), 
    booking_start_at = NOW(), 
    total_seats = 4, MAX_ROWS = 2, max_cols = 2;

# 좌석 등급 데이터 (VIP석, R석)
INSERT INTO seat_grade SET concert_id = 1, grade_name = 'VIP', price = 150000;
INSERT INTO seat_grade SET concert_id = 1, grade_name = 'R', price = 120000;

# 좌석 데이터 생성 (A열 VIP석 2개, B열 R석 2개)
INSERT INTO seat SET concert_id = 1, grade_id = 1, row_name = 'A', col_number = 1, `status` = 'AVAILABLE';
INSERT INTO seat SET concert_id = 1, grade_id = 1, row_name = 'A', col_number = 2, `status` = 'AVAILABLE';
INSERT INTO seat SET concert_id = 1, grade_id = 2, row_name = 'B', col_number = 1, `status` = 'AVAILABLE';
INSERT INTO seat SET concert_id = 1, grade_id = 2, row_name = 'B', col_number = 2, `status` = 'AVAILABLE';

# 더미 예약 데이터 1건 (유저1이 A열 1번 좌석을 이미 예약함)
UPDATE seat SET `status` = 'BOOKED' WHERE id = 1;
INSERT INTO reservation SET member_id = 2, seat_id = 1, paid_price = 150000;

SELECT * FROM `member`
SELECT * FROM `concert`
SELECT * FROM `reservation`
SELECT * FROM `seat`
SELECT * FROM `seat_grade`

SELECT A.*, M.name AS writerName
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id
WHERE A.id = ?