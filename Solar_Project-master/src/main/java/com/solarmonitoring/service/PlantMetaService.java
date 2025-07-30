package com.solarmonitoring.service;

import java.util.List;

import com.solarmonitoring.domain.PlantMetaVO;

public interface PlantMetaService {
	
	void insertPlant(PlantMetaVO plant);
	
    List<PlantMetaVO> getAllPlants();

	List<PlantMetaVO> getPlantsByLocation(String location); 
} 
  