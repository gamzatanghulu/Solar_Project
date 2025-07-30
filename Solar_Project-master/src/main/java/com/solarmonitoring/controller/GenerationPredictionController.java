package com.solarmonitoring.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.solarmonitoring.fastapi.FastAPIService;

@Controller
@RequestMapping("/view")
public class GenerationPredictionController {
	@Autowired
    private FastAPIService fastAPIService;
	
	@GetMapping("/predict")
    public String showPrediction(@RequestParam Long plantId, @RequestParam String datetime, Model model) {
        Double predictedGeneration = fastAPIService.getPredictedGeneration(plantId, datetime);
        model.addAttribute("predictedGeneration", predictedGeneration);
        return "dashboard";  // /WEB-INF/views/dashboard.jsp
    }
}
