package com.solarmonitoring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.solarmonitoring.domain.PlantMetaVO;
import com.solarmonitoring.mapper.PlantMetaMapper;

@Service
public class PlantMetaServiceImpl implements PlantMetaService {

	@Autowired
    private PlantMetaMapper mapper;
	
	@Override
	public void insertPlant(PlantMetaVO plant) {
		mapper.insertPlantMeta(plant);
	}

	@Override
	public List<PlantMetaVO> getAllPlants() {
		return mapper.selectAllPlants();
	}
	
	@Override
	public List<PlantMetaVO> getPlantsByLocation(String location){
		
		return mapper.getPlantsByLocation(location);
	} 

}
