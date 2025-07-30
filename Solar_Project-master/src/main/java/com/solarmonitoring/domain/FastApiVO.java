package com.solarmonitoring.domain;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class FastApiVO {
	 private String city;
	    private Double temp;
	    
	    @JsonProperty("feels_like")
	    private Double feels_like;

	    private Double humidity;
	    private String weather;
}
