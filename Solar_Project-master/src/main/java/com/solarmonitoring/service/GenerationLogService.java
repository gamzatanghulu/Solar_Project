package com.solarmonitoring.service;

import java.util.List;

import com.solarmonitoring.domain.GenerationLogVO;
import com.solarmonitoring.domain.RealTimePlantVO;

public interface GenerationLogService {
	
	// 더미데이터 insert
	void insertLog(GenerationLogVO log);
	
    List<GenerationLogVO> getLogsByPlantId(Long plantId);
    
    List<GenerationLogVO> getLogsByRange(Long plantId, String start, String end);
    
    // 더미데이터 생성 로직 구현
    void generateDummyDataForAllPlants();
    
    // 실시간 지역 검색 발전량 측정
    public List<RealTimePlantVO> getRealtimeByRegion(String region);
    
}
