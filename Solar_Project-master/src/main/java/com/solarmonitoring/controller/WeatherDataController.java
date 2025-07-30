package com.solarmonitoring.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.solarmonitoring.domain.FastApiVO;
import com.solarmonitoring.domain.WeatherDataVO;
import com.solarmonitoring.service.WeatherDataService;
 
@Controller
@RequestMapping("/api/weather")
public class WeatherDataController {
	@Autowired 
	private WeatherDataService service;

    @GetMapping("/all")
    @ResponseBody
    public List<WeatherDataVO> getAllWeatherData() {
    	// API 테스트시 POST용 예시 JSON (참고)
//    	{
//    		  "location": "울산",
//    		  "dateTime": "2025-06-14T14:00:00",
//    		  "temperature": 29.5,
//    		  "humidity": 55.3,
//    		  "windSpeed": 3.2,
//    		  "cloudCoverage": 20.0,
//    		  "solarIrradiance": 700.0
//    	}
        return service.getAllWeatherData(); 
    }
    
    @PostMapping
    @ResponseBody
    public ResponseEntity<Void> insertWeatherData(@RequestBody WeatherDataVO data) {
    	service.insertWeatherData(data);
        return ResponseEntity.ok().build();
    }
    
    private RestTemplate restTemplate = new RestTemplate();
    private final String fastApiUrl = "http://127.0.0.1:8000/weather?city={city}";
    
    
    
	/*
	 * @GetMapping("/local") public WeatherDataVO
	 * getCurrentWeather(@RequestParam("city") String city) {
	 * System.out.println("aaaa = "+city); // FastAPI 호출해서 VO 반환 return
	 * restTemplate.getForObject(fastApiUrl, WeatherDataVO.class); }
	 */
    
    
    
    
    
    @GetMapping("/local")
    public String getCurrentWeather(@RequestParam("city") String city,Model model) throws UnsupportedEncodingException {
        Map<String, String> cityMap = new HashMap<>();
        cityMap.put("서울", "Seoul");
        cityMap.put("부산", "Busan");
        cityMap.put("대구", "Daegu");
        cityMap.put("인천", "Incheon");
        cityMap.put("광주", "Gwangju");
        cityMap.put("대전", "Daejeon");
        cityMap.put("울산", "Ulsan");
        cityMap.put("세종", "Sejong");
        cityMap.put("경기", "Gyeonggi-do");
        cityMap.put("강원", "Gangwon-do");
        cityMap.put("충북", "Chungcheongbuk-do");
        cityMap.put("충남", "Chungcheongnam-do");
        cityMap.put("전북", "Jeollabuk-do");
        cityMap.put("전남", "Jeollanam-do");
        cityMap.put("경북", "Gyeongsangbuk-do");
        cityMap.put("경남", "Gyeongsangnam-do");
        cityMap.put("제주", "Jeju-do");

        String englishCity = cityMap.getOrDefault(city, city);
        
        
        
        String url = "http://localhost:8000/api/weather/local?city=" + URLEncoder.encode(englishCity, StandardCharsets.UTF_8);
        WeatherDataVO weather = restTemplate.getForObject(url, WeatherDataVO.class);
        
        model.addAttribute("weather",weather);
        System.out.println("getCurrentWeather 호출1 - city: " + city + ", englishCity: " + englishCity);
        
        return "dashboard" ;
    }
    
    @GetMapping(value = "/local/json", produces = "application/json")
    @ResponseBody
    public FastApiVO getCurrentWeatherJson(@RequestParam("city") String city) {
        Map<String, String> cityMap = new HashMap<>();
        cityMap.put("서울", "Seoul");
        cityMap.put("부산", "Busan");
        cityMap.put("대구", "Daegu");
        cityMap.put("인천", "Incheon");
        cityMap.put("광주", "Gwangju");
        cityMap.put("대전", "Daejeon");
        cityMap.put("울산", "Ulsan");
        cityMap.put("세종", "Sejong");
        cityMap.put("경기", "Gyeonggi-do");
        cityMap.put("강원", "Gangwon-do");
        cityMap.put("충북", "Chungcheongbuk-do");
        cityMap.put("충남", "Chungcheongnam-do");
        cityMap.put("전북", "Jeollabuk-do");
        cityMap.put("전남", "Jeollanam-do");
        cityMap.put("경북", "Gyeongsangbuk-do");
        cityMap.put("경남", "Gyeongsangnam-do");
        cityMap.put("제주", "Jeju-do");

        String englishCity = cityMap.getOrDefault(city, city);
        String url = "http://localhost:8000/api/weather/local?city=" + URLEncoder.encode(englishCity, StandardCharsets.UTF_8);

        HttpHeaders headers = new HttpHeaders();
        headers.set("Accept", MediaType.APPLICATION_JSON_VALUE);  // JSON 응답 원함 명시

        HttpEntity<String> entity = new HttpEntity<>(headers);
        System.out.println("getCurrentWeather 호출2 - city: " + city + ", englishCity: " + englishCity);

        ResponseEntity<FastApiVO> response = restTemplate.exchange(
                url,
                HttpMethod.GET,
                entity,
                FastApiVO.class
        );

        return response.getBody();
    }
    
    
    
    
    

    
    
    // JSP 렌더링용 메서드도 추가 가능
    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        // 날씨 데이터를 서비스에서 불러와 모델에 넣기
        List<WeatherDataVO> weatherList = service.getAllWeatherData();
        model.addAttribute("weatherList", weatherList);
        return "dashboard";  
    }
    
    
}
