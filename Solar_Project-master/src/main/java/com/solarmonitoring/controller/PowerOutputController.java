package com.solarmonitoring.controller;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.solarmonitoring.domain.PowerOutputVO;
import com.solarmonitoring.fastapi.FastAPIService;
import com.solarmonitoring.service.PowerOutputService;

@RestController
@RequestMapping("/api/power-output")
public class PowerOutputController {
	@Autowired
    private PowerOutputService service;

    @GetMapping
    public List<PowerOutputVO> getAll() {
        return service.getAllPowerOutput();
    }

    @PostMapping
    public ResponseEntity<Void> insert(@RequestBody PowerOutputVO data) {
        service.insertPowerOutput(data);
        return ResponseEntity.ok().build();
        //return ResponseEntity.ok("Prediction saved");
    }
    
    // 실제 발전량 업데이트용 PUT 메서드 추가
    @PutMapping("/actual")
    public ResponseEntity<Void> updateActualOutput(@RequestBody PowerOutputVO data) {
    	LocalDateTime dateTimeHourOnly = data.getDateTime().withMinute(0).withSecond(0).withNano(0);
        boolean updated = service.updateActualOutput(data.getPlantId(), dateTimeHourOnly, data.getActualOutput());
        if (updated) {
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    // 24시간 예측 그래프
    @GetMapping(value = "/region-predictions", produces = "application/json")
    public List<PowerOutputVO> getPredictions(@RequestParam String region, @RequestParam(defaultValue = "24") int hours) {
        return service.getPredictedOutputByHours(region, hours);
    }
    
    // 지역별 기온,일사량,예측 발전량
    @GetMapping(value = "/region-weather-prediction", produces = "application/json")
    public List<PowerOutputVO> getWeatherPrediction(@RequestParam String region, @RequestParam(defaultValue = "24") int hours) {
        return service.getWeatherPredictionByRegion(region, hours);
    }
    
}
