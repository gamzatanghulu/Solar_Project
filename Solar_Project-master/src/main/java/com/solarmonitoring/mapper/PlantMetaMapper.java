package com.solarmonitoring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.solarmonitoring.domain.PlantMetaVO;

public interface PlantMetaMapper {
	
	void insertPlantMeta(PlantMetaVO plant);
	
    List<PlantMetaVO> selectAllPlants();
    
    List<PlantMetaVO> getActivePlantsWithLocation();

	List<PlantMetaVO> getPlantsByLocation(@Param("location") String location); 
} 
