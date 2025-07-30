package com.solarmonitoring.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.solarmonitoring.domain.GenerationLogVO;
import com.solarmonitoring.domain.PlantMetaVO;
import com.solarmonitoring.domain.RealTimePlantVO;
import com.solarmonitoring.domain.WeatherDataVO;
import com.solarmonitoring.mapper.GenerationLogMapper;
import com.solarmonitoring.mapper.PlantMetaMapper;
import com.solarmonitoring.mapper.WeatherDataMapper;

@Service
public class GenerationLogServiceImpl implements GenerationLogService {

	@Autowired
    private GenerationLogMapper mapper;
	
	@Autowired
	private PlantMetaMapper plantMapper;
	
	@Autowired
	private WeatherDataMapper weatherMapper;

    @Override
    public void insertLog(GenerationLogVO log) {
    	// 더미데이터 insert
        mapper.insertLog(log);
    }

    @Override
    public List<GenerationLogVO> getLogsByPlantId(Long plantId) {
        return mapper.getLogsByPlantId(plantId);
    }

    @Override
    public List<GenerationLogVO> getLogsByRange(Long plantId, String start, String end) {
        return mapper.getLogsByDatetimeRange(plantId, start, end);
    }
    
    
    public List<RealTimePlantVO> getRealtimeByRegion(String region) {
        return mapper.selectLatestLogsByRegion(region);
    }
    
    

	@Override
	public void generateDummyDataForAllPlants() {
		List<PlantMetaVO> plantList = plantMapper.getActivePlantsWithLocation(); // location_name 있는 것만 추출
		//LocalDateTime start = LocalDateTime.now().minusDays(1).withHour(0).withMinute(0).withSecond(0).withNano(0);
		
		//LocalDateTime start = LocalDateTime.now().minusDays(3).withHour(0).withMinute(0).withSecond(0).withNano(0);
		//LocalDateTime end = LocalDateTime.now().withHour(23).withMinute(0).withSecond(0).withNano(0);
		
		LocalDateTime start = LocalDate.now().atStartOfDay(); // 2025-06-24 00:00:00
		LocalDateTime end = start.withHour(23);   
		long hours = java.time.Duration.between(start, end).toHours();
		for (int h = 0; h <= hours; h++) {
		    LocalDateTime targetTime = start.plusHours(h);
	        for (PlantMetaVO plant : plantList) {
	            try {
	            	WeatherDataVO weather = weatherMapper.getWeatherByLocationAndTime(plant.getRegion(), targetTime);
	            	
	            	if (weather != null) {
						/*
						 * Double irradiance = weather.getSolarIrradiance(); if (irradiance == null ||
						 * irradiance <= 0) { continue; // 일사량 없으면 스킵 }
						 */
	            	    // Double irradiance = weather.getSolarIrradiance() == null ? 0.0 : weather.getSolarIrradiance();
	            		Double irradiance = weather.getSolarIrradiance();
	            		if (irradiance == null || irradiance <= 0.0) {
	            		    // 평균값 대체 로직
	            		    int hour = targetTime.getHour();
	            		    irradiance = mapper.getAverageIrradianceByLocationAndHour(plant.getRegion(), hour);
	            		    if (irradiance == null) {
	            		        System.out.println("평균 일사량도 없음 → 0으로 처리: " + plant.getRegion() + ", 시간: " + hour);
	            		        irradiance = 0.0;
	            		    } else {
	            		        System.out.println("평균 일사량으로 대체: " + irradiance + " (" + plant.getRegion() + ", " + hour + "시)");
	            		    }
	            		}
	                    Double humidity = weather.getHumidity() == null ? 0.0 : weather.getHumidity();
	                    Double windSpeed = weather.getWindSpeed() == null ? 0.0 : weather.getWindSpeed();
	                    Double temperature = weather.getTemperature() == null ? 0.0 : weather.getTemperature();
	                    
	                    // 효율 계산
	                    double baseEfficiency = 0.18;
	                    double humidityFactor = 1 - (humidity / 100.0) * 0.05; // 습도 0~100 → 1~0.0
	                    double windFactor = 1 + Math.min(windSpeed / 10.0, 1.0) * 0.03; // 예: 3.5m/s → +3.5%
	                    double efficiency = baseEfficiency * humidityFactor * windFactor;
	                    double irradianceW = irradiance * 1000;  // kW/m² → W/m² 변환
	                    // 반올림하지 말고 소수점 3자리까지 저장해보기
	                    double generationKw = irradianceW * efficiency / 1000;
	                    generationKw = Math.round(generationKw * 1000.0) / 1000.0; // 소수점 셋째 자리까지
	                    double voltage = Math.round((220 + irradiance * 10) * 100.0) / 100.0;
	                    double current = voltage != 0 ? Math.round((generationKw * 1000 / voltage) * 100.0) / 100.0 : 0;
	                    
	                    // 패널 온도 계산
	                    double panelTemp = Math.round((temperature + (irradiance / 1000) * 10 - windSpeed * 0.5) * 100.0) / 100.0;
	
	                    GenerationLogVO log = new GenerationLogVO();
	                    log.setPlantId(plant.getId());
	                    log.setLogDatetime(targetTime);
	                    log.setGenerationKw(BigDecimal.valueOf(generationKw));
	                    log.setVoltage(BigDecimal.valueOf(voltage));
	                    log.setCurrent(BigDecimal.valueOf(current));
	                    log.setPanelTemperature(BigDecimal.valueOf(panelTemp));
	                    log.setSolarIrradiance(BigDecimal.valueOf(irradiance));
	                    System.out.println("[" + targetTime + "] 일사량: " + irradiance + " → 발전량: " + generationKw);
	                    //Thread.sleep(200); // 200ms 대기 (0.2초)
	                    mapper.insertLog(log);
	                    System.out.println("Inserted dummy data for plant_id: " + plant.getId());
	                } else {
	                	System.out.println("날씨 데이터 없음 → 스킵: " + plant.getRegion() +
	                		    ", 시간 = " + targetTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
	                    continue;
	                }
	            } catch (Exception e) {
	                System.err.println("Error inserting dummy data for plant_id: " + plant.getId());
	                e.printStackTrace();
	            }
		    }
		}
	}


}
