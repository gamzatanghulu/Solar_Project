package com.solarmonitoring.mapper;

import java.time.LocalDateTime;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.solarmonitoring.domain.WeatherDataVO;

public interface WeatherDataMapper {
	public void insertSolarWeatherData(WeatherDataVO data);

	public List<WeatherDataVO> selectAll();
	
	public WeatherDataVO getWeatherByLocationAndTime(@Param("location") String location, @Param("dateTime") LocalDateTime dateTime);

	public WeatherDataVO getCurrentWeather(String city);

	public WeatherDataVO findAvgWeatherByHour(@Param("location") String location, @Param("month") int month, @Param("hour") int hour);
}
