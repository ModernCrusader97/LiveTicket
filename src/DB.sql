# 데이터베이스 생성
DROP DATABASE IF EXISTS `Spring_26_04`;
CREATE DATABASE `Spring_26_04`;
USE `Spring_26_04`;


# 게시글 테이블 생성
CREATE TABLE `article` (
    `id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `regDate` DATETIME NOT NULL,
    `updateDate` DATETIME NOT NULL,
    `memberId`  INT UNSIGNED NOT NULL,
    `title` CHAR(100) NOT NULL,
    `body` CHAR(100) NOT NULL
);
/*
- id
- regDate
- updateDate
- loginId
- loginPw
- name
- nickname
- cellphoneNum
- email
*/
# 회원 테이블 생성
CREATE TABLE `member`(
	`id` INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
	`updateDate` DATETIME NOT NULL,
	`regDate` DATETIME NOT NULL,
	`loginId` CHAR(100) NOT NULL,
	`loginPw` CHAR(100) NOT NULL,
	`authLevel` SMALLINT(2) UNSIGNED DEFAULT 3 COMMENT '권한 레벨 (3=일반,7=관리자)',
	`name` CHAR(100) NOT NULL,
	nickname CHAR(20) NOT NULL,
	cellphoneNum CHAR(20) NOT NULL,
	email CHAR(20) NOT NULL,
	delStatus TINYINT(1) UNSIGNED DEFAULT 0 NOT NULL COMMENT '탈퇴 여부 (0=탈퇴 전, 1=탈퇴 후)',
	delDate DATETIME COMMENT '탈퇴 날짜'
);

# 게시글 데이터 삽입
INSERT INTO `article`
SET `regDate` = NOW(),
	`updateDate` = NOW(),
	`memberId` =1,
	`title` = '제목1',
	`body` = '내용1';
	
INSERT INTO `article`
SET `regDate` = NOW(),
	`updateDate` = NOW(),
	`memberId` =1,
	`title` = '제목2',
	`body` = '내용2';

INSERT INTO `article`
SET `regDate` = NOW(),
	`updateDate` = NOW(),
	`memberId` =2,
	`title` = '제목3',
	`body` = '내용3';

# 회원 데이터 삽입
INSERT INTO `member`
SET `regDate` = NOW(),
	`updateDate` = NOW(),
	`loginId` = 'admin',
	`loginPw` = 'admin',
	`authLevel` = 7,
	`name` = '관리자',
	nickname = '관리자_별명',
	cellphoneNum = '01012341234',
	email = 'abc@gmail.com';

INSERT INTO `member`
SET `regDate` = NOW(),
	`updateDate` = NOW(),
	`loginId` = 'test1',
	`loginPw` = 'test1',
	`name` = '회원1',
	nickname = '회원1_별명',
	cellphoneNum = '01012345678',
	email = 'def@gmail.com';
	
INSERT INTO `member`
SET `regDate` = NOW(),
	`updateDate` = NOW(),
	`loginId` = 'test2',
	`loginPw` = 'test2',
	`name` = '회원2',
	nickname = '회원2_별명',
	cellphoneNum = '01045671234',
	email = 'eeee@gmail.com';	
	

SELECT * FROM `article`;
	
SELECT * FROM `member`;

SELECT LAST_INSERT_ID();

/*
# 테스트
SELECT *
FROM article
ORDER BY id DESC;

SELECT *
FROM `member`
WHERE loginId = 'test3';

SELECT A.*, M.name AS e_w
FROM article AS A
INNER JOIN `member` AS M
ON A.memberId = M.id;
# article 생성(대량) => 해당 쿼리 실행 시 article 생성
INSERT INTO article
SET regDate = NOW(),
/*
title = CONCAT('제목', SUBSTRING(RAND() * 1000 FROM 1 FOR 2)),
`body` = CONCAT('내용', SUBSTRING(RAND() * 1000 FROM 1 FOR 2));
*/
/*
memberId = CEILING(RAND() * 2),
title = CONCAT('제목', RAND()),
`body` = CONCAT('내용', RAND());

# member 생성(대량) => 해당 쿼리 실행 시 member 생성
INSERT INTO MEMBER
SET regDate = NOW(),
loginId = CONCAT('loginId', SUBSTRING(RAND() * 1000 FROM 1 FOR 2)),
loginPw = CONCAT('loginPw', SUBSTRING(RAND() * 1000 FROM 1 FOR 2)),
`name` = CONCAT('name', SUBSTRING(RAND() * 1000 FROM 1 FOR 2));
*/


SELECT * FROM `member` WHERE loginId = 'test1';

SELECT COUNT(*) > 0
FROM `member`
WHERE loginId = 'test1';

SELECT COUNT(*) > 0
FROM `member`
WHERE loginId = 'test3';

SELECT SUBSTRING(RAND() * 1000 FROM 1 FOR 2);

UPDATE article
SET updateDate = NOW(),
title = '수정1',
`body` = 'test1'
WHERE id = 1;

SELECT COUNT(*)
FROM article
WHERE id = 5;


UPDATE article
SET updateDate = NOW(),
`body` = 'test3'
WHERE id = 3;

SELECT *
FROM article;

SELECT *
FROM `member`;

UPDATE article
SET memberId = 1
WHERE memberId NOT IN (SELECT id FROM `member`);
