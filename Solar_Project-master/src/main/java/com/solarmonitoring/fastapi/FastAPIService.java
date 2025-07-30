package com.solarmonitoring.fastapi;

public interface FastAPIService {
	Double getPredictedGeneration(Long plantId, String datetime);
}
