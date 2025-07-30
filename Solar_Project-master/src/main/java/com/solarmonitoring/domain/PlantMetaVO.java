package com.solarmonitoring.domain;

import java.time.Year;

import lombok.Data;

@Data
public class PlantMetaVO {
	private Long id;
    private String plantName;
    private String locationName;
    private Double latitude;
    private Double longitude;
    private Double altitude;
    private Double azimuth;
    private Double tilt;
    private Double installedCapacity;
    private Double supplyVoltage;
    private String panelType;
    private Integer installedDate;
    private Boolean isActive;
    private String comment; 
    private String region;  
}
