package com.solarmonitoring.controller;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.solarmonitoring.domain.GenerationLogVO;
import com.solarmonitoring.domain.PlantMetaVO;
import com.solarmonitoring.domain.PowerOutputVO;
import com.solarmonitoring.domain.WeatherDataVO;
import com.solarmonitoring.service.GenerationLogService;
import com.solarmonitoring.service.PlantMetaService;
import com.solarmonitoring.service.PowerOutputService;
import com.solarmonitoring.service.WeatherDataService;

@RestController
@RequestMapping("/api/test")
public class TestController {
	@Autowired private GenerationLogService generationLogService;
    @Autowired private PlantMetaService plantMetaService;
    @Autowired private WeatherDataService weatherDataService;
    @Autowired private PowerOutputService powerOutputservice;
    
    // [API 테스트용]
    // ---------------------- 1. plant_meta ----------------------
    @PostMapping("/plant/test-insert")
    public ResponseEntity<String> insertPlantMeta() {
        PlantMetaVO plant = new PlantMetaVO();
        plant.setPlantName("대전 1호");
        plant.setLocationName("대전");
        plant.setLatitude(36.35);
        plant.setLongitude(127.38);
        plant.setAltitude(52.5);
        plant.setAzimuth(180.0);
        plant.setTilt(30.0);
        plant.setInstalledCapacity(100.0);
        plant.setSupplyVoltage(220.0);
        plant.setPanelType("mono");
        plant.setInstalledDate(2022);
        plant.setIsActive(true);
        plant.setComment("테스트용 발전소");
        plantMetaService.insertPlant(plant);
        return ResponseEntity.ok("plant_meta inserted");
    }

    @GetMapping("/plant/test-select")
    public List<PlantMetaVO> selectPlantMeta() {
        return plantMetaService.getAllPlants();
    }

    // ---------------------- 2. generation_log ----------------------
    @PostMapping("/generation/test-insert")
    public ResponseEntity<String> insertGenerationLog() {
        GenerationLogVO log = new GenerationLogVO();
        log.setPlantId(1L); // 실제 존재하는 plant_meta.id
        log.setLogDatetime(LocalDateTime.now());
        log.setGenerationKw(new BigDecimal("123.45"));
        log.setVoltage(new BigDecimal("220.00"));
        log.setCurrent(new BigDecimal("5.50"));
        log.setPanelTemperature(new BigDecimal("35.50"));
        log.setSolarIrradiance(new BigDecimal("800.00"));

        generationLogService.insertLog(log);
        return ResponseEntity.ok("generation_log inserted");
    }

    @GetMapping("/generation/test-select/{plantId}")
    public List<GenerationLogVO> selectGenerationLog(@PathVariable Long plantId) {
        return generationLogService.getLogsByPlantId(plantId);
    }

    // ---------------------- 3. solar_power_output ----------------------
    @PostMapping("/power/test-insert")
    public ResponseEntity<String> insertPowerOutput() {
        PowerOutputVO output = new PowerOutputVO();
        output.setLocation("대전");
        output.setDateTime(LocalDateTime.now());
        output.setPredictedOutput(80.5);
        output.setActualOutput(78.2);
        output.setModelUsed("LSTM v1");

        powerOutputservice.insertPowerOutput(output);
        return ResponseEntity.ok("solar_power_output inserted");
    }

    @GetMapping("/power/test-select")
    public List<PowerOutputVO> selectPowerOutput() {
        return powerOutputservice.getAllPowerOutput();
    }
    

    // ---------------------- 4. weather_data ----------------------
    @PostMapping("/weather/test-insert")
    public ResponseEntity<String> insertWeatherData() {
        WeatherDataVO weather = new WeatherDataVO();
        weather.setLocation("울산");
        weather.setDateTime(LocalDateTime.now());
        weather.setTemperature(25.5);
        weather.setHumidity(55.0);
        weather.setWindSpeed(3.2);
        weather.setCloudCoverage(345.4);
        weather.setSolarIrradiance(850.0);
        weatherDataService.insertWeatherData(weather);
        return ResponseEntity.ok("weather_data inserted");
    }

    @GetMapping("/weather/test-select")
    public List<WeatherDataVO> selectWeatherData() {
        return weatherDataService.getAllWeatherData();
    }
}
