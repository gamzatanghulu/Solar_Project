# 태양광 발전량 예측 24시간 모니터링 대시보드
## 💡 프로젝트 개요
실시간 발전 현황과 예측 데이터를 시각화하여 **태양광 발전소의 효율적인 운영**을 지원하는 대시보드 시스템입니다.  
24시간 단위 예측치와 실제 발전량을 비교 분석하며, 지역별 날씨 정보도 함께 제공합니다.

## ⚙️ 기술 스택

| 분류 | 기술 | 설명 |
|------|------|------|
| **Frontend** | JSP, HTML/CSS, JavaScript, Chart.js, jQuery, Kakao Maps API | 실시간 그래프, 지도 기반 UI 구성 및 사용자 인터랙션 |
| **Backend** | Spring Boot, MyBatis, FastAPI (Python) | 발전소 메타/로그 처리, 예측 서버 API 연동 |
| **Database** | MySQL | 발전소 메타데이터 및 발전량/예측값 저장 |
| **데이터 연동** | 기상청 OpenAPI, JSON 예측 데이터 | 날씨 및 기온/일사량 데이터 수집, 예측 결과 연동 |
| **배포 환경** | STS3, Tomcat, JDK 17, Windows | Spring 환경 개발 및 JSP 웹 서버 운영 환경 |

## 📁 프로젝트 구조
```
📁Solar_Project/
├── 📁src/
│   └── 📁main/
│       ├── 📁java/
│       │   └── 📁com/solarmonitoring/
│       │       ├── 📁controller/         # REST API Controller
│       │       ├── 📁domain/             # VO 클래스 (DTO 포함)
│       │       ├── 📁fastapi/            # FastAPI 연동 서비스 클래스
│       │       ├── 📁mapper/             # MyBatis 인터페이스
│       │       ├── 📁scheduler/          # 정기 스케줄링 작업
│       │       └── 📁service/            # 비즈니스 로직 처리
│       └── 📁resources/
│           ├── 📁mapper/                 # MyBatis XML SQL 매핑 파일
│           ├── 📑application.properties  # DB 연결 및 설정 파일
│           └── 📑log4j.xml               # 로깅 설정
├── 📁sql/                                 # DB 테이블 및 초기 데이터
│   ├── 📑generation_log.sql               # 발전량 로그 테이블
│   ├── 📑plant_meta.sql                   # 발전소 메타 정보
│   ├── 📑solar_power_output.sql           # 발전소별 발전량
│   └── 📑solar_weather_data.sql           # 날씨 데이터 테이블
├── 📁python-api/                          # FastAPI 서버 및 예측 코드
│   ├── 🐍weather_api.py                   # 실시간 날씨 데이터 수집 API
│   ├── 🐍24Hplant.py                      # 24시간 발전량 조회 API
│   └── 📑requirements.txt                 # Python 패키지 목록
├── 📑pom.xml                              # Maven 의존성 관리 파일
```                         


## ❗ 주요 기능

### 1. 실시간 대시보드 및 모니터링 (Spring MVC + JS)
#### 초기화면 구성
- 현재 시간 및 날씨 정보
- 실시간 발전량, 기온, 일사량
- 발전소 목록 및 현황
- 지역별 설비이용률 순위
- 지난 발전량 그래프
#### 지도 기반 발전소 탐색 기능
- 지도를 클릭하면 해당 지역의 발전소 데이터를 팝업으로 시각화
- 데이터 로딩 전에는 로딩 애니메이션을 통해 사용자 편의성 강화
#### 날씨 및 기온 데이터 시각화
- 선택 지역의 기온, 습도, 체감온도, 날씨 정보를 실시간 확인
- 일사량, 발전량, 기온 변화는 그래프로 시각적으로 제공
- 최대/평균 기온 및 발전량을 함께 표시
#### 발전소 정보 및 랭킹 제공
- 지역별 발전소 목록 출력
- 설비 이용률 기준 Top 10 발전소 순위 제공
- 해당 지역의 발전소 용량, 연간 발전량, 전국 대비 비율 제공
#### 지난 발전량 조회 기능
- 날씨 선택 -> 그래프 그리기 버튼 클릭 -> 해당일 발전량 그래프 출력
- 비동기 방식으로 빠른 응답 및 로딩 경험 제공

### 2. 수요 예측 기능 (Python)
- weather_api.py : 실시간 날씨
- 24Hplant.py : 지난 태양광 발전량



## 📷 주요 화면

<table>
  <tr>
    <td align="center"><b>전국 지도 (SVG)</b></td>
    <td align="center"><b>발전량 그래프</b></td>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/73a4d4c6-69fe-4b76-97ec-54bc83414d49" width="300" />
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/7fe78f3f-6956-4ede-a6e3-e22b365b75e9" width="450" />
    </td>
  </tr>
</table>


## 🛠 프로젝트 실행 방법
### 1️⃣ 환경 준비

- JDK 11 이상 설치
- Python 3.8 이상 설치
- MySQL 또는 MariaDB 설치 및 데이터베이스 생성
- Maven 설치
- 개발 도구: STS (Spring Tool Suite), IntelliJ (Java), VSCode (Python 등)

### 2️⃣ 프로젝트 클론
```
git clone https://github.com/사용자명/프로젝트명.git
cd 프로젝트명
```
### 3️⃣ 데이터베이스 세팅
- src/main/resources/sql/ 디렉토리 내 SQL 파일을 사용해 DB 테이블 및 초기 데이터 구성:
```
# 테이블 및 데이터 예시
source sql/plant_meta.sql;
source sql/generation_log.sql;
source sql/solar_power_output.sql;
source sql/solar_weather_data.sql;
```
- DB 접속 설정: src/main/resources/application.properties 파일 수정

```
spring.datasource.url=jdbc:mysql://localhost:3306/your_db_name
spring.datasource.username=your_db_user
spring.datasource.password=your_db_password
```

### 4️⃣ API 키 설정
- 기상청 및 OpenWeatherMap API 키를 발급받아 application.properties에 추가
- weather.api.key=여기에_발급받은_키를_입력하세요

### 5️⃣ Java Spring Boot 서버 실행

```
# 프로젝트 빌드
mvn clean install
```
```
# 서버 실행
mvn spring-boot:run
```
### 6️⃣ Python FastAPI 서버 실행
```
# FastAPI 코드 디렉토리로 이동
cd python-api  # 또는 fastapi_backend
```

- 가상환경 생성 (선택)
```
python -m venv venv
```
- 가상환경 활성화
```
# Windows
venv\Scripts\activate
# macOS/Linux
source venv/bin/activate
```

- 의존성 설치
```
pip install -r requirements.txt
```

- FastAPI 서버 실행
```
uvicorn 24Hplant:app --reload --host 0.0.0.0 --port 8000
```

🔹 주의: 24Hplant:app은 실제 FastAPI 엔트리포인트에 맞게 수정 필요합니다 (파일명:앱객체명).

### 7️⃣ 웹 접속 주소
구분	주소
```
🌐 Java 서버 (JSP 대시보드)	http://localhost:8080
🔧 FastAPI Swagger Docs	http://localhost:8000/docs
```




## 📽 프로젝트 시연 영상
https://github.com/user-attachments/assets/991c289c-6b11-4a7b-b163-5f2f9e6c8802


