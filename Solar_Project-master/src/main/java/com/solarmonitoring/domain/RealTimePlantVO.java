package com.solarmonitoring.domain;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.Data;

@Data
public class RealTimePlantVO {
	
    private Long plantId;
    private String plantName;
    private String location;
    private BigDecimal generationKw;
    private LocalDateTime logDatetime;
}