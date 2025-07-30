package com.solarmonitoring.service;

import java.util.List;

import com.solarmonitoring.domain.WeatherDataVO;

public interface WeatherDataService { 
	// 스케쥴러 수집
	public void fetchAndSaveWeatherData(String location, String stnId, String dateStr);
	
	public void generateAndInsertFutureWeather(String location, int hours);

	public List<WeatherDataVO> getAllWeatherData();

	public void insertWeatherData(WeatherDataVO data);
}
