# 태양광 발전량 예측 24시간 모니터링 대시보드
## 💡 프로젝트 개요
최근 재생 에너지의 비중이 점점 높아지면서, 태양광 발전은 날씨나 시간에 따라 출력이 크게 달라지는 특성이 있습니다. 

이런 출력 변동성은 전력 운영에 직접적인 영향을 주게 되고, 
이에 따라 발전소 운영자나 태양광 에너지를 사용하는 소비자 입장에서 보다 효율적인 전력 수급 계획을 세우고, 적절한 유지보수를 하기 위한 관리가 중요해졌습니다.


이런 필요성에 따라 태양광 발전량을 지역별로 예측하고 시각화할 수 있는 시스템을 만들게 되었습니다.

## 🛠️ 개발 환경 및 기술 스택
- 개발 기간: 2025년 6월 13일 ~ 2025년 7월 1일
- 개발자: 김인아(팀장), 김준영, 정현정
- 프레임워크: JAVA, MySQL, Spring MVC, JS, Python, FastAPI

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

### 3. 데이터베이스 구성 (MySQL)
- 주요 테이블
  - generation_log : 실시간으로 수집되는 발전소 데이터
  - plant_meta : 발전소 메타 정보 (지역, 위치 등)
  - solar_power_output : 예측 결과와 실제 발전량 정보
  - solar_weather_data : 기온,습도, 풍속, 강수량 등 날씨 정보



## 📽 프로젝트 시연 영상
https://github.com/user-attachments/assets/991c289c-6b11-4a7b-b163-5f2f9e6c8802


