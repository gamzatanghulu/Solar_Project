package com.solarmonitoring.domain;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.Data;

@Data
public class GenerationLogVO {
	private Long id;
    private Long plantId;
    private LocalDateTime logDatetime;
    private BigDecimal generationKw;
    private BigDecimal voltage;
    private BigDecimal current;
    private BigDecimal panelTemperature;
    private BigDecimal solarIrradiance;
    
}
