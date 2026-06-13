-- MySQL dump 10.13  Distrib 8.0.46, for Linux (x86_64)
--
-- Host: localhost    Database: liveticket
-- ------------------------------------------------------
-- Server version	8.0.46-0ubuntu0.24.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `liveticket`
--

/*!40000 DROP DATABASE IF EXISTS `liveticket`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `liveticket` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `liveticket`;

--
-- Table structure for table `artist`
--

DROP TABLE IF EXISTS `artist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `artist` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `profileImg` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artist`
--

LOCK TABLES `artist` WRITE;
/*!40000 ALTER TABLE `artist` DISABLE KEYS */;
INSERT INTO `artist` (`id`, `name`, `profileImg`) VALUES (1,'박강현','/img/men.png'),(2,'임규형','/img/men.png'),(3,'나현우','/img/men.png'),(4,'김선영','/img/women.png'),(5,'신영숙','/img/women.png'),(6,'조민호','/img/men.png'),(7,'이기완','/img/men.png'),(8,'윤태호','/img/men.png'),(9,'백형훈','/img/men.png');
/*!40000 ALTER TABLE `artist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `concert`
--

DROP TABLE IF EXISTS `concert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concert` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `regDate` datetime NOT NULL,
  `updateDate` datetime NOT NULL,
  `startDate` datetime DEFAULT NULL,
  `endDate` datetime DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `posterImg` varchar(255) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'DRAFT' COMMENT '공연 상태 (DRAFT/OPEN/PAUSED/CLOSED)',
  `body` text,
  `bookingStartAt` datetime NOT NULL,
  `reviewCount` int DEFAULT '0',
  `totalRating` int DEFAULT '0',
  `viewCount` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `concert`
--

LOCK TABLES `concert` WRITE;
/*!40000 ALTER TABLE `concert` DISABLE KEYS */;
INSERT INTO `concert` (`id`, `regDate`, `updateDate`, `startDate`, `endDate`, `title`, `posterImg`, `status`, `body`, `bookingStartAt`, `reviewCount`, `totalRating`, `viewCount`) VALUES (1,'0000-00-00 00:00:00','0000-00-00 00:00:00','2026-08-01 00:00:00','2026-09-30 23:59:59','뮤지컬 <디어 에반 핸슨>','/img/poster_evan.png','DRAFT','당신은 발견될 것이다. 최고의 감동 뮤지컬 디어 에반 핸슨.','2026-06-13 01:30:59',0,0,6),(2,'0000-00-00 00:00:00','0000-00-00 00:00:00','2026-06-13 00:00:00','2026-07-05 23:59:59','창작가무극 <신과 함께_저승편>','/img/poster_god.png','DRAFT','죽는다고 다 끝난 게 아니다. 네이버 웹툰 원작의 전석 매진 신화.','2026-06-13 01:28:59',0,0,1);
/*!40000 ALTER TABLE `concert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `concertCasting`
--

DROP TABLE IF EXISTS `concertCasting`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `concertCasting` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `scheduleId` int NOT NULL,
  `artistId` int unsigned NOT NULL,
  `roleName` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `concertCasting`
--

LOCK TABLES `concertCasting` WRITE;
/*!40000 ALTER TABLE `concertCasting` DISABLE KEYS */;
INSERT INTO `concertCasting` (`id`, `scheduleId`, `artistId`, `roleName`) VALUES (1,3,1,'에반 핸슨'),(2,3,4,'하이디 핸슨'),(3,3,6,'코너 머피'),(4,4,2,'에반 핸슨'),(5,4,5,'하이디 핸슨'),(6,4,6,'코너 머피'),(7,5,3,'에반 핸슨'),(8,5,5,'하이디 핸슨'),(9,5,6,'코너 머피'),(10,6,7,'진기한/자홍 등'),(11,6,8,'해원맥 등'),(12,6,9,'강림 등');
/*!40000 ALTER TABLE `concertCasting` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `regDate` datetime NOT NULL,
  `updateDate` datetime NOT NULL,
  `loginId` char(30) NOT NULL,
  `loginPw` char(100) NOT NULL,
  `authLevel` smallint unsigned DEFAULT '3' COMMENT '권한 레벨 (3=일반, 7=관리자)',
  `name` char(20) NOT NULL,
  `nickname` char(20) NOT NULL,
  `cellphoneNum` char(20) NOT NULL,
  `email` char(20) NOT NULL,
  `delStatus` tinyint unsigned NOT NULL DEFAULT '0',
  `delDate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `loginId` (`loginId`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
INSERT INTO `member` (`id`, `regDate`, `updateDate`, `loginId`, `loginPw`, `authLevel`, `name`, `nickname`, `cellphoneNum`, `email`, `delStatus`, `delDate`) VALUES (1,'2026-06-13 01:28:59','2026-06-13 01:28:59','admin','admin',7,'관리자','최고관리자','010-1111-2222','admin@test.com',0,NULL),(2,'2026-06-13 01:28:59','2026-06-13 01:28:59','test1','test1',3,'이종석','실관람객종석','010-3333-4444','test1@test.com',0,NULL),(3,'2026-06-13 01:28:59','2026-06-13 01:28:59','test2','test2',3,'김유저','뮤지컬덕후','010-5555-6666','test2@test.com',0,NULL);
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservation`
--

DROP TABLE IF EXISTS `reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservation` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `regDate` datetime NOT NULL,
  `updateDate` datetime NOT NULL,
  `memberId` int unsigned NOT NULL,
  `scheduleId` int NOT NULL,
  `seatId` int unsigned NOT NULL,
  `paidPrice` int unsigned NOT NULL,
  `status` varchar(20) DEFAULT 'CONFIRMED',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservation`
--

LOCK TABLES `reservation` WRITE;
/*!40000 ALTER TABLE `reservation` DISABLE KEYS */;
INSERT INTO `reservation` (`id`, `regDate`, `updateDate`, `memberId`, `scheduleId`, `seatId`, `paidPrice`, `status`) VALUES (100,'2026-06-13 01:28:59','2026-06-13 01:28:59',2,3,1,160000,'CONFIRMED'),(101,'2026-06-13 01:28:59','2026-06-13 01:28:59',2,4,6,160000,'CANCELLED');
/*!40000 ALTER TABLE `reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `regDate` datetime NOT NULL,
  `updateDate` datetime NOT NULL,
  `memberId` int unsigned NOT NULL,
  `concertId` int unsigned NOT NULL,
  `title` varchar(100) NOT NULL,
  `body` text NOT NULL,
  `rating` int unsigned DEFAULT '0',
  `type` char(20) NOT NULL,
  `orderId` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `concertId` (`concertId`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` (`id`, `regDate`, `updateDate`, `memberId`, `concertId`, `title`, `body`, `rating`, `type`, `orderId`) VALUES (1,'2026-06-13 01:28:59','2026-06-13 01:28:59',3,1,'박강현 배우님 첫공 너무 기대돼요!!','에반핸슨 라인업 대박입니다 꼭 티켓팅 성공하길',0,'EXPECT',NULL),(2,'2026-06-13 01:28:59','2026-06-13 01:28:59',2,1,'진짜 인생 뮤지컬을 만났습니다.','A열 시야 최고였고 박강현 성량에 귀 녹았습니다.',5,'REVIEW',100);
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedule`
--

DROP TABLE IF EXISTS `schedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `concertId` int NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `performDate` varchar(30) DEFAULT NULL,
  `startAt` varchar(30) DEFAULT NULL,
  `totalSeats` int DEFAULT '0',
  `maxRows` int DEFAULT '10',
  `maxCols` int DEFAULT '10',
  `price` int DEFAULT '0',
  `body` text,
  `status` varchar(20) DEFAULT 'DRAFT',
  `regDate` datetime DEFAULT NULL,
  `updateDate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedule`
--

LOCK TABLES `schedule` WRITE;
/*!40000 ALTER TABLE `schedule` DISABLE KEYS */;
INSERT INTO `schedule` (`id`, `concertId`, `title`, `performDate`, `startAt`, `totalSeats`, `maxRows`, `maxCols`, `price`, `body`, `status`, `regDate`, `updateDate`) VALUES (3,1,'뮤지컬 <디어 에반 핸슨> - 1회차','2026-06-12 01:28:59','2026-06-13 01:28:59',4,2,2,0,'1회차 토요일 저녁 공연','DRAFT','0000-00-00 00:00:00','0000-00-00 00:00:00'),(4,1,'뮤지컬 <디어 에반 핸슨> - 2회차','2026-08-02 14:00:00','2026-06-13 01:28:59',4,2,2,0,'2회차 일요일 낮 공연','DRAFT','0000-00-00 00:00:00','0000-00-00 00:00:00'),(5,1,'뮤지컬 <디어 에반 핸슨> - 3회차','2026-08-02 19:00:00','2026-06-13 01:28:59',4,2,2,0,'3회차 일요일 저녁 공연','DRAFT','0000-00-00 00:00:00','0000-00-00 00:00:00'),(6,2,'창작가무극 <신과 함께_저승편> - 1회차','2026-06-13 19:00:00','2026-06-13 01:28:59',4,2,2,0,'개막 첫 공연','DRAFT','0000-00-00 00:00:00','0000-00-00 00:00:00');
/*!40000 ALTER TABLE `schedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seat`
--

DROP TABLE IF EXISTS `seat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seat` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `regDate` datetime NOT NULL,
  `updateDate` datetime NOT NULL,
  `scheduleId` int NOT NULL,
  `memberId` int unsigned DEFAULT NULL,
  `gradeId` int unsigned NOT NULL,
  `rowName` varchar(10) NOT NULL,
  `colNumber` int unsigned NOT NULL,
  `status` varchar(20) DEFAULT 'AVAILABLE',
  `version` int unsigned DEFAULT '0',
  `heldAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seat`
--

LOCK TABLES `seat` WRITE;
/*!40000 ALTER TABLE `seat` DISABLE KEYS */;
INSERT INTO `seat` (`id`, `regDate`, `updateDate`, `scheduleId`, `memberId`, `gradeId`, `rowName`, `colNumber`, `status`, `version`, `heldAt`) VALUES (1,'2026-06-13 01:28:59','2026-06-13 01:28:59',3,2,1,'A',1,'RESERVED',0,NULL),(2,'2026-06-13 01:28:59','2026-06-13 01:28:59',3,NULL,1,'A',2,'AVAILABLE',0,NULL),(3,'2026-06-13 01:28:59','2026-06-13 01:28:59',3,NULL,2,'B',1,'AVAILABLE',0,NULL),(4,'2026-06-13 01:28:59','2026-06-13 01:28:59',3,NULL,2,'B',2,'AVAILABLE',0,NULL),(5,'2026-06-13 01:28:59','2026-06-13 01:28:59',4,NULL,3,'A',1,'AVAILABLE',0,NULL),(6,'2026-06-13 01:28:59','2026-06-13 01:28:59',4,NULL,3,'A',2,'AVAILABLE',0,NULL),(7,'2026-06-13 01:28:59','2026-06-13 01:28:59',4,NULL,4,'B',1,'AVAILABLE',0,NULL),(8,'2026-06-13 01:28:59','2026-06-13 01:28:59',4,NULL,4,'B',2,'AVAILABLE',0,NULL),(9,'2026-06-13 01:28:59','2026-06-13 01:28:59',6,NULL,5,'A',1,'AVAILABLE',0,NULL),(10,'2026-06-13 01:28:59','2026-06-13 01:28:59',6,NULL,5,'A',2,'AVAILABLE',0,NULL),(11,'2026-06-13 01:28:59','2026-06-13 01:28:59',6,NULL,6,'B',1,'AVAILABLE',0,NULL),(12,'2026-06-13 01:28:59','2026-06-13 01:28:59',6,NULL,6,'B',2,'AVAILABLE',0,NULL);
/*!40000 ALTER TABLE `seat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seatGrade`
--

DROP TABLE IF EXISTS `seatGrade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `seatGrade` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `regDate` datetime NOT NULL,
  `updateDate` datetime NOT NULL,
  `scheduleId` int NOT NULL,
  `name` varchar(20) NOT NULL,
  `price` int unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seatGrade`
--

LOCK TABLES `seatGrade` WRITE;
/*!40000 ALTER TABLE `seatGrade` DISABLE KEYS */;
INSERT INTO `seatGrade` (`id`, `regDate`, `updateDate`, `scheduleId`, `name`, `price`) VALUES (1,'2026-06-13 01:28:59','2026-06-13 01:28:59',3,'VIP',160000),(2,'2026-06-13 01:28:59','2026-06-13 01:28:59',3,'R',130000),(3,'2026-06-13 01:28:59','2026-06-13 01:28:59',4,'VIP',160000),(4,'2026-06-13 01:28:59','2026-06-13 01:28:59',4,'R',130000),(5,'2026-06-13 01:28:59','2026-06-13 01:28:59',6,'VIP',150000),(6,'2026-06-13 01:28:59','2026-06-13 01:28:59',6,'R',120000);
/*!40000 ALTER TABLE `seatGrade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'liveticket'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-13  3:36:19
