# 기존 데이터 초기화 (주의: 데이터가 모두 지워집니다)
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
    maxCols INT UNSIGNED
);

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

# ---------------------------------------------------------
# 테스트 데이터 입력 시작
# ---------------------------------------------------------

# 회원 데이터
INSERT INTO `member` SET regDate = NOW(), updateDate = NOW(), loginId = 'admin', loginPw = 'admin', `authLevel` = 7, `name` = '관리자', nickname = '관리자', cellphoneNum = '01011112222', email = 'admin@test.com';
INSERT INTO `member` SET regDate = NOW(), updateDate = NOW(), loginId = 'test1', loginPw = 'test1', `authLevel` = 3, `name` = '이종석', nickname = '종석닉네임', cellphoneNum = '01033334444', email = 'test1@test.com';

# 공연 데이터
INSERT INTO concert SET performDate = NOW(), startDate = NOW(), endDate = NOW()+2 ,title = '2026 임영웅 콘서트', `body` = '최고의 감동을 선사합니다.', startAt = '2026-05-10 19:00:00', bookingStartAt = NOW(), totalSeats = 4, maxRows = 2, maxCols = 2;

# 좌석 등급
INSERT INTO seatGrade SET regDate = NOW(), updateDate = NOW(), concertId = 1, `name` = 'VIP', price = 150000;
INSERT INTO seatGrade SET regDate = NOW(), updateDate = NOW(), concertId = 1, `name` = 'R', price = 120000;

# 좌석 데이터
INSERT INTO seat SET regDate = NOW(), updateDate = NOW(), concertId = 1, gradeId = 1, rowName = 'A', colNumber = 1;
INSERT INTO seat SET regDate = NOW(), updateDate = NOW(), concertId = 1, gradeId = 1, rowName = 'A', colNumber = 2;
INSERT INTO seat SET regDate = NOW(), updateDate = NOW(), concertId = 1, gradeId = 2, rowName = 'B', colNumber = 1;
INSERT INTO seat SET regDate = NOW(), updateDate = NOW(), concertId = 1, gradeId = 2, rowName = 'B', colNumber = 2;

