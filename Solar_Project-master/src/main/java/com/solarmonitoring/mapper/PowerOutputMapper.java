package com.solarmonitoring.mapper;

import java.time.LocalDateTime;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.solarmonitoring.domain.PowerOutputVO;

public interface PowerOutputMapper {
	
	void insertPowerOutput(PowerOutputVO data);
	
    List<PowerOutputVO> selectAll();

	int updateActualOutput(@Param("plantId") Long plantId, @Param("dateTime") LocalDateTime dateTime, @Param("actualOutput") Double actualOutput);

	List<PowerOutputVO> selectRegionPowerOutputByHours(@Param("regions") List<String> regions, @Param("hours") int hours);

	List<PowerOutputVO> selectWeatherPredictionByRegion(@Param("regions") List<String> regions, @Param("hours") int hours);
}
