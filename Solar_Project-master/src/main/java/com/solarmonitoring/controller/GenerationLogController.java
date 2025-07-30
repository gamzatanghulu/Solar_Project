package com.solarmonitoring.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.solarmonitoring.domain.GenerationLogVO;
import com.solarmonitoring.domain.RealTimePlantVO;
import com.solarmonitoring.service.GenerationLogService;

@RestController
@RequestMapping("/api/generation")
public class GenerationLogController {
	@Autowired
	private GenerationLogService service;

	@PostMapping
	public void insert(@RequestBody GenerationLogVO log) {
		service.insertLog(log);
	}

	@GetMapping("/{plantId}")
	public List<GenerationLogVO> getLogs(@PathVariable Long plantId) {
		return service.getLogsByPlantId(plantId);
	}

	@GetMapping("/{plantId}/range")
	public List<GenerationLogVO> getLogsInRange(@PathVariable Long plantId, @RequestParam String start,
			@RequestParam String end) {
		return service.getLogsByRange(plantId, start, end);
	}

	@Mapper
	public interface GenerationLogMapper {
		List<RealTimePlantVO> selectLatestLogsByRegion(@Param("region") String region);
	}

	/*
	 * @GetMapping("/realtime") public List<RealTimePlantVO>
	 * getRealtimeByRegion(@RequestParam String region) {
	 * 
	 * return service.getRealtimeByRegion(region); }
	 */

	
	
	
	private final RestTemplate restTemplate = new RestTemplate();
	private static final String FASTAPI_BASE_URL = "http://127.0.0.1:5000/api/solar/24h";

	@GetMapping("/chart-data")
	public ResponseEntity<String> getChartData(
	        @RequestParam String region,
	        @RequestParam String start_date,
	        @RequestParam String end_date) {

	    try {
	        String url = FASTAPI_BASE_URL
	                   + "?region=" + region   // ✅ 인코딩 하지 마세요
	                   + "&start_date=" + start_date
	                   + "&end_date=" + end_date;

	        RestTemplate restTemplate = new RestTemplate();
	        ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

	        return ResponseEntity.ok(response.getBody());

	    } catch (Exception e) {
	        e.printStackTrace();
	        return ResponseEntity.status(500)
	            .body("{\"error\":\"FastAPI 호출 실패: " + e.getMessage() + "\"}");
	    }
	}
	
    // ✅ 실시간 발전량 FastAPI URL (예측 + 실제)
    private static final String REALTIME_FASTAPI_URL = "http://127.0.0.1:5000/api/generation/realtime";

    // ✅ 실시간 발전량 데이터 요청 (최근 24시간, 예측 + 실제)
    @GetMapping("/realtime")
    public ResponseEntity<String> getRealtimeGeneration(@RequestParam String region) {
        try {
            // 지역명은 URL에 직접 사용하므로 인코딩 안 함 (한글 가능)
            String url = REALTIME_FASTAPI_URL + "?region=" + region;

            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

            return ResponseEntity.ok(response.getBody());
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500)
                .body("{\"error\":\"FastAPI 호출 실패: " + e.getMessage() + "\"}");
        }
    }

	

}
