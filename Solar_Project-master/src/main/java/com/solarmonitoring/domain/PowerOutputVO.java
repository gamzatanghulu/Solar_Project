package com.solarmonitoring.domain;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class PowerOutputVO {
	private Long id;
	private Long plantId;
    private String location;
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime dateTime;
    private Double predictedOutput;
    private Double actualOutput;
    private String modelUsed;
    private LocalDateTime createdAt;
    
    private Double actual_generation_kw;
    
    private String region;
    private String locationName;
    private Double totalPredictedOutput;
    
    private Double temperature;
    private Double solarIrradiance;
}
