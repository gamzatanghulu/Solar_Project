package com.solarmonitoring.domain;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class WeatherDataVO { 
	private Long id;
	private String location;
	private LocalDateTime dateTime;
	private Double temperature;
    private Double humidity;
    private Double windSpeed;
    private Double cloudCoverage;
    private Double solarIrradiance;
	private LocalDateTime createdAt;
	// weatherapi
	private String city;
	private Double temp;
	@JsonProperty("feels_like")
	private Double feels_like;
	private String weather;
}
