package com.solarmonitoring.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import static java.util.Map.entry;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.solarmonitoring.domain.PowerOutputVO;
import com.solarmonitoring.mapper.PowerOutputMapper;

@Service
public class PowerOutputServiceImpl implements PowerOutputService {
	
	@Autowired
    private PowerOutputMapper mapper;

	@Override
	public List<PowerOutputVO> getAllPowerOutput() {
		return mapper.selectAll();
	}

	@Override
	public void insertPowerOutput(PowerOutputVO data) {
		mapper.insertPowerOutput(data);
	}

	@Override
	public boolean updateActualOutput(Long plantId, LocalDateTime dateTime, Double actualOutput) {
		// 실제 발전량 업데이트 쿼리 실행
	    int affectedRows = mapper.updateActualOutput(plantId, dateTime, actualOutput);
	    return affectedRows > 0;
	}

	private static final Map<String, String> regionToProvinceMap = Map.ofEntries(
		// 서울
	    entry("서울", "서울"),

	    // 경기
	    entry("수원", "경기"), entry("동두천", "경기"), entry("파주", "경기"),
	    entry("양평", "경기"), entry("이천", "경기"), entry("강화", "경기"),

	    // 인천
	    entry("인천", "인천"), entry("백령도", "인천"), entry("울릉도", "인천"),

	    // 강원
	    entry("속초", "강원"), entry("북춘천", "강원"), entry("철원", "강원"), entry("대관령", "강원"),
	    entry("춘천", "강원"), entry("북강릉", "강원"), entry("강릉", "강원"), entry("동해", "강원"),
	    entry("원주", "강원"), entry("영월", "강원"), entry("인제", "강원"), entry("홍천", "강원"),
	    entry("태백", "강원"), entry("정선군", "강원"),

	    // 충북
	    entry("충주", "충북"), entry("제천", "충북"), entry("보은", "충북"), entry("청주", "충북"),
	    entry("추풍령", "충북"), entry("충청북도", "충북"),

	    // 충남
	    entry("서산", "충남"), entry("천안", "충남"), entry("보령", "충남"), entry("부여", "충남"),
	    entry("금산", "충남"), entry("홍성", "충남"), entry("충청남도", "충남"),

	    // 세종 (충남 근처로 그룹화)
	    entry("세종", "충남"),

	    // 대전 (충북과 충남 사이, 여기선 충남으로 처리)
	    entry("대전", "충남"),

	    // 전북
	    entry("군산", "전북"), entry("전주", "전북"), entry("임실", "전북"), entry("정읍", "전북"),
	    entry("남원", "전북"), entry("장수", "전북"), entry("부안", "전북"), entry("고창", "전북"),
	    entry("고창군", "전북"), entry("순창군", "전북"),

	    // 전남
	    entry("광주", "전남"), // 광주는 전남으로 분류
	    entry("목포", "전남"), entry("여수", "전남"), entry("흑산도", "전남"), entry("완도", "전남"),
	    entry("순천", "전남"), entry("보성군", "전남"), entry("강진군", "전남"), entry("장흥", "전남"),
	    entry("해남", "전남"), entry("고흥", "전남"), entry("광양시", "전남"), entry("진도군", "전남"),

	    // 경북
	    entry("안동", "경북"), entry("상주", "경북"), entry("포항", "경북"), entry("영주", "경북"),
	    entry("문경", "경북"), entry("청송군", "경북"), entry("영덕", "경북"), entry("의성", "경북"),
	    entry("구미", "경북"), entry("영천", "경북"), entry("경주시", "경북"), entry("봉화", "경북"),

	    // 대구
	    entry("대구", "대구"),

	    // 경남
	    entry("창원", "경남"), entry("북창원", "경남"), entry("양산시", "경남"), entry("김해시", "경남"),
	    entry("진주", "경남"), entry("의령군", "경남"), entry("함양군", "경남"), entry("산청", "경남"),
	    entry("거창", "경남"), entry("합천", "경남"), entry("밀양", "경남"), entry("거제", "경남"),
	    entry("남해", "경남"), entry("통영", "경남"),

	    // 울산
	    entry("울산", "울산"),

	    // 부산
	    entry("부산", "부산"),

	    // 제주
	    entry("제주", "제주"), entry("고산", "제주"), entry("성산", "제주"), entry("서귀포", "제주")														
	);

	@Override
	public List<PowerOutputVO> getPredictedOutputByHours(String region, int hours) {
		// 상세 지역들을 광역 지역 기준으로 필터링
	    List<String> detailedRegions = regionToProvinceMap.entrySet().stream()
	        .filter(entry -> entry.getValue().equals(region))
	        .map(Map.Entry::getKey)
	        .collect(Collectors.toList());
	    System.out.println(detailedRegions);
		return mapper.selectRegionPowerOutputByHours(detailedRegions, hours);
	}

	@Override
	public List<PowerOutputVO> getWeatherPredictionByRegion(String region, int hours) {
		// 상세 지역들을 광역 지역 기준으로 필터링
	    List<String> detailedRegions = regionToProvinceMap.entrySet().stream()
	        .filter(entry -> entry.getValue().equals(region))
	        .map(Map.Entry::getKey)
	        .collect(Collectors.toList());
	    System.out.println(detailedRegions);
		return mapper.selectWeatherPredictionByRegion(detailedRegions, hours);
	}

}
