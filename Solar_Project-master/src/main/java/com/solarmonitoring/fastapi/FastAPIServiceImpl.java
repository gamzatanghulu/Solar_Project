package com.solarmonitoring.fastapi;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class FastAPIServiceImpl implements FastAPIService {

    @Autowired
    private RestTemplate restTemplate;
    
    private final String fastApiBaseUrl = "http://localhost:8000/api";

	@Override
	public Double getPredictedGeneration(Long plantId, String datetime) {
		String url = fastApiBaseUrl + "/predict_generation";

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("plant_id", plantId);
        requestBody.put("datetime", datetime);

        try {
            // FastAPI는 POST 요청에 JSON 바디를 받는다고 가정
            Map<String, Object> response = restTemplate.postForObject(url, requestBody, Map.class);
            if (response != null && response.containsKey("predicted_generation_kw")) {
                return Double.valueOf(response.get("predicted_generation_kw").toString());
            } else {
                // 예측 결과가 없거나 오류 발생 시 기본값 반환
                return 0.0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
	}

}
