package com.solarmonitoring.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.solarmonitoring.domain.PlantMetaVO;
import com.solarmonitoring.service.PlantMetaService;

@RestController
@RequestMapping("/api/plants")
public class PlantMetaController {
	@Autowired
    private PlantMetaService service;

    @GetMapping
    public List<PlantMetaVO> getAllPlants() {
        return service.getAllPlants();
    }
 
    @PostMapping
    public ResponseEntity<Void> addPlant(@RequestBody PlantMetaVO plant) {
        service.insertPlant(plant);
        return ResponseEntity.ok().build();
    }
    

    @GetMapping(value = "/by-location", produces = MediaType.APPLICATION_JSON_VALUE)
    public List<PlantMetaVO> getPlantsByLocation(@RequestParam String location) {
    	System.out.println("location" + location);
    	// List<PlantMetaVO> plants = service.getPlantsByLocation(location); // location 포함 검색
        return service.getPlantsByLocation(location); 
        
    }
 

    
    
}
