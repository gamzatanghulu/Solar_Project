package com.solarmonitoring.scheduler;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.solarmonitoring.service.GenerationLogService;

@Component
public class GenerationLogScheduler {
	
	private final GenerationLogService generationLogService;

    public GenerationLogScheduler(GenerationLogService generationLogService) {
        this.generationLogService = generationLogService;
    }
	
	@Scheduled(cron = "0 0 10 * * *") // 매일 오전 10시에 누적데이터 insert
    public void generateDailyDummyData() {
        // 더미 데이터 생성 로직 호출
        System.out.println("스케줄러 실행 - generation_log 더미데이터 생성 시작");
        generationLogService.generateDummyDataForAllPlants();
    }
}
