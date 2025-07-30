package com.solarmonitoring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.solarmonitoring.domain.GenerationLogVO;
import com.solarmonitoring.domain.RealTimePlantVO;

public interface GenerationLogMapper {
	
	// 새로운 발전량 기록 추가
	// 발전소에서 실시간 측정한 발전량 데이터를 저장할 때 사용
	void insertLog(GenerationLogVO log);
	
	// 특정 발전소의 모든 발전 로그를 조회
    List<GenerationLogVO> getLogsByPlantId(Long plantId);
    
    // 특정 발전소의 발전 로그 중에서 특정 기간 사이의 데이터 조회(예 : 5월 한달치만 보고싶을 때)
    List<GenerationLogVO> getLogsByDatetimeRange(Long plantId, String start, String end);
    
    // 발전소 plant_id 값 가져오기
    List<Long> getAllActivePlantIds();
    
    // 실시간 발전량
    List<RealTimePlantVO> selectLatestLogsByRegion(@Param("region") String region);
    
    // 일사량 null 일때 처리
    Double getAverageIrradianceByLocationAndHour(@Param("location") String location, @Param("hour") int hour);

    
}
