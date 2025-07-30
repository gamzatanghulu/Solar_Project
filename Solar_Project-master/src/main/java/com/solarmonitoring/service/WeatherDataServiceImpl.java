package com.solarmonitoring.service;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.solarmonitoring.domain.WeatherDataVO;
import com.solarmonitoring.mapper.WeatherDataMapper;

@Service
public class WeatherDataServiceImpl implements WeatherDataService {
	
	@Autowired
    private WeatherDataMapper mapper; 
	
	// fastapi 날씨
	private RestTemplate restTemplate = new RestTemplate();
    private final String fastApiUrl = "http://127.0.0.1:8000/weather?city={city}";
	
	@Override
	public void fetchAndSaveWeatherData(String location, String stnId, String dateStr) {
	    String url = "http://apis.data.go.kr/1360000/AsosHourlyInfoService/getWthrDataList";
	    // 인코딩된 서비스키
	    String serviceKeyEncoded = "8MKSzvAYUdvxxFyP3cZQwm4rpNPvWkQjdblENx33fbgSNhvGOrSjo42Wi2YQkpU%2B1v7ouq896gWnbP%2BCEga%2BwQ%3D%3D";
	    UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(url)
	            .queryParam("serviceKey", serviceKeyEncoded)
	            .queryParam("pageNo", "1")
	            .queryParam("numOfRows", "24")
	            .queryParam("dataType", "JSON")
	            .queryParam("dataCd", "ASOS")
	            .queryParam("dateCd", "HR")
	            .queryParam("startDt", dateStr)
	            .queryParam("startHh", "00")
	            .queryParam("endDt", dateStr)
	            .queryParam("endHh", "23")
	            .queryParam("stnIds", stnId);

	    RestTemplate restTemplate = new RestTemplate();
	    HttpHeaders headers = new HttpHeaders();
	    headers.set("Accept", "application/json");
	    headers.set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)");
	    headers.set("Content-Type", "application/json");
	    HttpEntity<String> entity = new HttpEntity<>(headers);
	    
	    URI apiUrl;
	    try {
	        apiUrl = new URI(builder.build(false).toUriString());
	    } catch (URISyntaxException e) {
	        System.err.println("URI 생성 중 오류: " + e.getMessage());
	        e.printStackTrace();
	        return;
	    }
	    
	    ResponseEntity<String> response = restTemplate.exchange(
	    	apiUrl,
	        HttpMethod.GET,
	        entity,
	        String.class
	    );

	    String body = response.getBody();
	    System.out.println("응답 결과: " + body);
	    System.out.println("최종 요청 URL: " + builder.build(false).toUriString());

	    try {
	        ObjectMapper objectMapper = new ObjectMapper();
	        JsonNode root = objectMapper.readTree(body);
	        JsonNode items = root.path("response").path("body").path("items").path("item");

	        if (items.isMissingNode() || !items.isArray()) {
	            System.out.println("[" + location + "] " + dateStr + ": 데이터 없음");
	            return;
	        }

	        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

	        for (JsonNode node : items) {
	            WeatherDataVO data = new WeatherDataVO();
	            data.setLocation(location);
	            data.setDateTime(LocalDateTime.parse(node.path("tm").asText(), dtf));
	            data.setTemperature(node.path("ta").isNull() ? null : node.path("ta").asDouble());
	            data.setHumidity(node.path("hm").isNull() ? null : node.path("hm").asDouble());
	            data.setWindSpeed(node.path("ws").isNull() ? null : node.path("ws").asDouble());
	            data.setCloudCoverage(node.path("dc10Tca").isNull() ? null : node.path("dc10Tca").asDouble());

	            JsonNode solarNode = node.path("icsr");
	            if (solarNode.isMissingNode() || solarNode.isNull() || solarNode.asText().isEmpty()) {
	                data.setSolarIrradiance(null);
	            } else {
	                data.setSolarIrradiance(solarNode.asDouble());
	            }

	            data.setCreatedAt(LocalDateTime.now());

	            mapper.insertSolarWeatherData(data);
	        }
	        System.out.println("[" + location + "] " + dateStr + ": 저장 완료");

	    } catch (Exception e) {
	        System.err.println("[" + location + "] " + dateStr + ": 에러 발생 - " + e.getMessage());
	        e.printStackTrace();
	    }
	}


	@Override
	public List<WeatherDataVO> getAllWeatherData() {
		return mapper.selectAll();
	}

	@Override
	public void insertWeatherData(WeatherDataVO data) {
		mapper.insertSolarWeatherData(data);
	}
	
	@Override
	public void generateAndInsertFutureWeather(String location, int hours) {
	    LocalDateTime now = LocalDateTime.now();

	    for (int i = 1; i <= hours; i++) {
	    	LocalDateTime futureTime = now.plusHours(i).withMinute(0).withSecond(0).withNano(0);
	        int hour = futureTime.getHour();
	        int month = futureTime.getMonthValue();

	        // 과거 동일 시간대 평균값 가져오기
	        WeatherDataVO avg = mapper.findAvgWeatherByHour(location, month, hour);

	        if (avg != null) {
	            try {
	                WeatherDataVO futureData = new WeatherDataVO();
	                futureData.setLocation(location);
	                futureData.setDateTime(futureTime);
	                futureData.setTemperature(avg.getTemperature());
	                futureData.setHumidity(avg.getHumidity());
	                futureData.setWindSpeed(avg.getWindSpeed());
	                futureData.setCloudCoverage(avg.getCloudCoverage());
	                futureData.setSolarIrradiance(avg.getSolarIrradiance());
	                futureData.setCreatedAt(LocalDateTime.now());

	                mapper.insertSolarWeatherData(futureData);
	            } catch (Exception e) {
	                System.err.println("미래 날씨 데이터 삽입 실패: " + e.getMessage());
	                e.printStackTrace();
	            }
	        }
	    }
	}
	

}
