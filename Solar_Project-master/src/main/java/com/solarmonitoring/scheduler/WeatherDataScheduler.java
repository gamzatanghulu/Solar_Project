package com.solarmonitoring.scheduler;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Map;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.solarmonitoring.service.WeatherDataService;

@Component
public class WeatherDataScheduler {
	private final WeatherDataService weatherDataService;

    public WeatherDataScheduler(WeatherDataService weatherDataService) {
        this.weatherDataService = weatherDataService;
    }
    
    //전국 날씨 받기 위해 지역별 코드 저장
    private static final Map<String, String> STATION_LIST = Map.ofEntries(
        Map.entry("속초", "90"),
        Map.entry("북춘천", "93"),
        Map.entry("철원", "95"),
        Map.entry("동두천", "98"),
        Map.entry("파주", "99"),
        Map.entry("대관령", "100"),
        Map.entry("춘천", "101"),
        Map.entry("백령도", "102"),
        Map.entry("북강릉", "104"),
        Map.entry("강릉", "105"),
        Map.entry("동해", "106"),
        Map.entry("서울", "108"),
        Map.entry("인천", "112"),
        Map.entry("원주", "114"),
        Map.entry("울릉도", "115"),
        Map.entry("수원", "119"),
        Map.entry("영월", "121"),
        Map.entry("충주", "127"),
        Map.entry("서산", "129"),
        Map.entry("울진", "130"),
        Map.entry("청주", "131"),
        Map.entry("대전", "133"),
        Map.entry("추풍령", "135"),
        Map.entry("안동", "136"),
        Map.entry("상주", "137"),
        Map.entry("포항", "138"),
        Map.entry("군산", "140"),
        Map.entry("대구", "143"),
        Map.entry("전주", "146"),
        Map.entry("울산", "152"),
        Map.entry("창원", "155"),
        Map.entry("광주", "156"),
        Map.entry("부산", "159"),
        Map.entry("통영", "162"),
        Map.entry("목포", "165"),
        Map.entry("여수", "168"),
        Map.entry("흑산도", "169"),
        Map.entry("완도", "170"),
        Map.entry("고창", "172"),
        Map.entry("순천", "174"),
        Map.entry("홍성", "177"),
        Map.entry("제주", "184"),
        Map.entry("고산", "185"),
        Map.entry("성산", "188"),
        Map.entry("서귀포", "189"),
        Map.entry("진주", "192"),
        Map.entry("강화", "201"),
        Map.entry("양평", "202"),
        Map.entry("이천", "203"),
        Map.entry("인제", "211"),
        Map.entry("홍천", "212"),
        Map.entry("태백", "216"),
        Map.entry("정선군", "217"),
        Map.entry("제천", "221"),
        Map.entry("보은", "226"),
        Map.entry("천안", "232"),
        Map.entry("보령", "235"),
        Map.entry("부여", "236"),
        Map.entry("금산", "238"),
        Map.entry("세종", "239"),
        Map.entry("부안", "243"),
        Map.entry("임실", "244"),
        Map.entry("정읍", "245"),
        Map.entry("남원", "247"),
        Map.entry("장수", "248"),
        Map.entry("고창군", "251"),
        Map.entry("영광군", "252"),
        Map.entry("김해시", "253"),
        Map.entry("순창군", "254"),
        Map.entry("북창원", "255"),
        Map.entry("양산시", "257"),
        Map.entry("보성군", "258"),
        Map.entry("강진군", "259"),
        Map.entry("장흥", "260"),
        Map.entry("해남", "261"),
        Map.entry("고흥", "262"),
        Map.entry("의령군", "263"),
        Map.entry("함양군", "264"),
        Map.entry("광양시", "266"),
        Map.entry("진도군", "268"),
        Map.entry("봉화", "271"),
        Map.entry("영주", "272"),
        Map.entry("문경", "273"),
        Map.entry("청송군", "276"),
        Map.entry("영덕", "277"),
        Map.entry("의성", "278"),
        Map.entry("구미", "279"),
        Map.entry("영천", "281"),
        Map.entry("경주시", "283"),
        Map.entry("거창", "284"),
        Map.entry("합천", "285"),
        Map.entry("밀양", "288"),
        Map.entry("산청", "289"),
        Map.entry("거제", "294"),
        Map.entry("남해", "295")
    );

	@Scheduled(cron = "0 30 9 * * *") // 매일 오전 9시 30분에 누적데이터 insert
    public void fetchAndSaveWeatherData() {
		
		// 어제날짜 기준 ( 어제하루치 데이터를 수집 )
		String dateStr = LocalDate.now().minusDays(1).format(DateTimeFormatter.ofPattern("yyyyMMdd"));

	    for (Map.Entry<String, String> entry : STATION_LIST.entrySet()) {
	    	// 공공데이터 API 호출해서 데이터 수집 및 DB insert 로직 작성
	    	weatherDataService.fetchAndSaveWeatherData(entry.getKey(), entry.getValue(), dateStr);
	        try {
	            Thread.sleep(1500); // 1.5초 딜레이 - API 과부하 방지
	        } catch (InterruptedException e) {
	            Thread.currentThread().interrupt();
	        }
	    }
        System.out.println("스케줄러 실행 - 공공데이터 API 호출 후 DB 저장 처리 수행");
		
		// 3일 전부터 어제까지
		/*
		 * for (int i = 3; i >= 1; i--) { String dateStr = LocalDate.now().minusDays(i)
		 * .format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		 * System.out.println("[날씨 수집] 날짜: " + dateStr);
		 * 
		 * for (Map.Entry<String, String> entry : STATION_LIST.entrySet()) {
		 * weatherDataService.fetchAndSaveWeatherData(entry.getKey(), entry.getValue(),
		 * dateStr); try { Thread.sleep(1500); // API 과부하 방지 } catch
		 * (InterruptedException e) { Thread.currentThread().interrupt(); } } }
		 * System.out.println("스케줄러 실행 완료 - 3일치 날씨데이터 수집 및 DB 저장");
		 */
    }
	
	// 미래날씨
	@Scheduled(cron = "0 0 * * * *")   // 매 정시마다
	public void generateAndInsertFutureWeatherData() {
	    for (String location : STATION_LIST.keySet()) {
	        weatherDataService.generateAndInsertFutureWeather(location, 72); // 72시간 예측
	        try {
	            Thread.sleep(1000);  // 과부하 방지
	        } catch (InterruptedException e) {
	            Thread.currentThread().interrupt();
	        }
	    }
	    System.out.println("스케줄러 실행 - 과거 기반 미래 날씨 데이터 생성 및 DB 저장 완료");
	}

}