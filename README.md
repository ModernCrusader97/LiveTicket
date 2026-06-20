# LiveTicket - 콘서트 티켓 예매 시스템

🌐 **Live Demo:** https://liveticket.lazzy.chat

AI 코딩 툴(Claude Code)을 활용해 개발한 1인 백엔드 프로젝트입니다.

---

## PRD (Product Requirements Document)

### 개요
LiveTicket은 콘서트 티켓 예매 및 관리를 위한 웹 서비스입니다. Spring Boot 기반 SSR(Server-Side Rendering) 방식으로 구현했으며, 이후 React 프론트엔드를 추가한 cast-react로 발전시켰습니다.

### 타겟 유저
- 콘서트 티켓을 예매하려는 일반 사용자
- 콘서트 정보를 등록하고 관리하는 관리자

### 주요 기능
| 기능 | 설명 |
|------|------|
| 회원가입 / 로그인 | 세션 기반 인증, 인터셉터로 접근 제어 |
| 콘서트 목록 | 공연 목록 조회, 검색 |
| 콘서트 상세 | 공연 정보, 일정별 잔여석 확인 |
| 티켓 예매 | 일정 선택 후 예매 신청 |
| 예매 내역 | 내 예매 목록 조회 및 취소 |
| 후기 | 공연 후기 작성 / 조회 |
| 관리자 | 콘서트 등록 / 수정 / 삭제 |

### 기술 스택
- **Backend:** Spring Boot, MyBatis, MySQL
- **Frontend:** JSP, HTML/CSS/JS (SSR)
- **Auth:** 세션 기반 인증, 인터셉터
- **Deploy:** Spring Boot WAR 배포, nginx reverse proxy, HTTPS

### 개발 방식
AI 코딩 툴(Claude Code)을 활용하여 요구사항 정의부터 배포까지 1인 개발

---

## 실행 방법

```bash
# 빌드 및 실행 (WAR)
mvn package
java -jar target/demo-0.0.1-SNAPSHOT.war

# 또는 개발 모드
./mvnw spring-boot:run
```

## 환경 설정

```yaml
spring:
  datasource:
    url: jdbc:mysql://127.0.0.1:3306/liveticket
    username: root
    password:
```
