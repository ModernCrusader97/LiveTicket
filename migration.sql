-- ============================================================
-- LiveTicket: concert/schedule 테이블 분리 마이그레이션
-- 실행 전 반드시 DB 백업 필수!
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

-- 1. schedule 테이블 생성 (기존 child concert 행 이관)
CREATE TABLE IF NOT EXISTS `schedule` (
    id        INT          NOT NULL AUTO_INCREMENT,
    concertId INT          NOT NULL,
    title     VARCHAR(255),
    performDate VARCHAR(30),
    startAt   VARCHAR(30),
    totalSeats INT          DEFAULT 0,
    maxRows   INT          DEFAULT 10,
    maxCols   INT          DEFAULT 10,
    price     INT          DEFAULT 0,
    body      TEXT,
    status    VARCHAR(20)  DEFAULT 'DRAFT',
    regDate   DATETIME,
    updateDate DATETIME,
    PRIMARY KEY (id)
);

-- 2. 기존 child concert (parentId != 0) → schedule 이관 (ID 보존)
INSERT INTO `schedule` (id, concertId, title, performDate, startAt, totalSeats, maxRows, maxCols, price, body, status, regDate, updateDate)
SELECT id, parentId, title, performDate, startAt, totalSeats, maxRows, maxCols, price, body,
       IFNULL(status, 'DRAFT'), regDate, updateDate
FROM concert
WHERE parentId != 0;

-- 3. review.concertId: child concert ID → master concert ID로 변환
UPDATE review r
    INNER JOIN concert c ON r.concertId = c.id AND c.parentId != 0
SET r.concertId = c.parentId;

-- 4. seatGrade: concertId → scheduleId 컬럼 이름 변경
ALTER TABLE seatGrade CHANGE COLUMN concertId scheduleId INT NOT NULL;

-- 5. seat: concertId → scheduleId 컬럼 이름 변경
ALTER TABLE seat CHANGE COLUMN concertId scheduleId INT NOT NULL;

-- 6. concertCasting: concertId → scheduleId 컬럼 이름 변경
ALTER TABLE concertCasting CHANGE COLUMN concertId scheduleId INT NOT NULL;

-- 7. reservation: concertId → scheduleId 컬럼 이름 변경
ALTER TABLE reservation CHANGE COLUMN concertId scheduleId INT NOT NULL;

-- 8. concert 테이블에서 child concert 행 삭제
DELETE FROM concert WHERE parentId != 0;

-- 9. concert 테이블에서 불필요한 컬럼 제거
ALTER TABLE concert
    DROP COLUMN parentId,
    DROP COLUMN performDate,
    DROP COLUMN startAt,
    DROP COLUMN totalSeats,
    DROP COLUMN maxRows,
    DROP COLUMN maxCols,
    DROP COLUMN price;

-- status는 concert 레벨에 유지 (시리즈 전체 상태)

SET FOREIGN_KEY_CHECKS = 1;
