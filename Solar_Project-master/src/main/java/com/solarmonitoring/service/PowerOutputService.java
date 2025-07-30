package com.solarmonitoring.service;

import java.time.LocalDateTime;
import java.util.List;

import com.solarmonitoring.domain.PowerOutputVO;

public interface PowerOutputService {
	
	List<PowerOutputVO> getAllPowerOutput();
	
    void insertPowerOutput(PowerOutputVO data);

	boolean updateActualOutput(Long plantId, LocalDateTime dateTime, Double actualOutput);

	List<PowerOutputVO> getPredictedOutputByHours(String region, int hours);

	List<PowerOutputVO> getWeatherPredictionByRegion(String region, int hours);
}
