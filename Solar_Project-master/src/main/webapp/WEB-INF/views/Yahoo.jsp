<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/luxon"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-luxon"></script>
<meta charset="UTF-8" />
<title>태양광 발전소 지도</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
* {
	box-sizing: border-box;
}

body {
	margin: 0;
	font-family: 'Segoe UI', 'Pretendard', sans-serif;
	display: flex;
	background-color: #f4f6f8;
	justify-content: center;
	align-items: center;
}

.left-container {
	display: flex;
	flex-direction: column;
	gap: 20px;
	align-items: center; /* 필요 시 중앙 정렬 */
}

.map-container {
	margin-top: 200px;
	position: relative;
	width: 400px; /* 원하는 고정 크기 */
	height: 500px; /* 원하는 고정 크기 */
	background-image:
		url('${pageContext.request.contextPath}/resources/img/한반도.png');
	background-size: contain;
	background-repeat: no-repeat;
	background-position: left center;
}

#container {
	display: flex;
	gap: 40px;
	align-items: flex-start;
	padding: 20px;
}

.info-panelweather {
	position: absolute;
	width: 400px;
	height: 300px;
	padding: 30px;
}

.info-panelweather h2 {
	position: relative;
	font-size: 22px;
	border-bottom: 2px solid #007bff;
	padding-bottom: 5px;
	margin: 0px;
}

.info-panelweather p {
	font-size: 16px;
	margin: 5px 0;
}

.info-panel h2 {
	position: relative;
	font-size: 22px;
	border-bottom: 2px solid #007bff;
	padding-bottom: 5px;
	margin: 0px;
}

.info-panel p {
	font-size: 16px;
	margin: 5px 0;
}

.region {
	position: absolute;
	padding: 6px 12px;
	border-radius: 14px;
	font-size: 13px;
	font-weight: bold;
	color: white;
	cursor: pointer;
	display: flex;
	align-items: center;
	gap: 6px;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
	transition: all 0.2s ease;
}

.region i {
	font-size: 14px;
}

.region:hover {
	transform: scale(1.1);
	z-index: 10;
}

/* 지역별 색상 */
.서울 {
	background-color: #3b82f6;
}

.경기 {
	background-color: #22c55e;
}

.강원 {
	background-color: #22d3ee;
}

.충북 {
	background-color: #ef4444;
}

.충남 {
	background-color: #a855f7;
}

.전북 {
	background-color: #b45309;
}

.전남 {
	background-color: #ec4899;
}

.경북 {
	background-color: #6b7280;
}

.대구 {
	background-color: #84cc16;
}

.경남 {
	background-color: #06b6d4;
}

.울산 {
	background-color: #60a5fa;
}

.부산 {
	background-color: #f87171;
}

.제주 {
	background-color: #f97316;
}

/* CSS 디자인 */
#plantInfoContainer {
	max-width: 200px;
	font-family: 'Segoe UI', 'Noto Sans KR', sans-serif;
}

#plantInfo {
	background-color: #f9f9fc;
	border: 1px solid #dcdcec;
	border-radius: 12px;
	padding: 20px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
}



.plant-item {
	margin-bottom: 15px;
	padding: 10px;
	border-left: 4px solid #007bff;
	background-color: #fff;
	border-radius: 6px;
}

.plant-name {
	font-weight: bold;
	font-size: 14px;
	color: #222;
}

.plant-details {
	font-size: 12px;
	color: #666;
	margin-top: 4px;
}

#pagination {
	display: flex;
	justify-content: center;
	align-items: center;
	margin-top: 15px;
	gap: 10px;
}

#pagination button {
	padding: 6px 12px;
	border: none;
	background-color: #007bff;
	color: white;
	border-radius: 5px;
	cursor: pointer;
}

#pagination button:disabled {
	background-color: #ccc;
	cursor: default;
}

.containerright {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
	width: 820px;
	margin-top: 20px;
}

.info-box {
	background-color: #f9f9fc;
	border-radius: 12px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
	padding: 20px;
	min-height: 250px;
}

.info-box h2 {
	margin-top: 0;
	font-size: 22px;
	border-bottom: 2px solid #007bff;
	padding-bottom: 8px;
	margin-bottom: 12px;
}
</style>
</head>
<body>


	<div id="container">
		<div class="left-container">
			<div class="info-panelweather" id="infoPanelweather">
				<h2>날씨 정보</h2>
				<p>지역을 클릭하면 현재 날씨가 표시됩니다.</p>
			</div>
			<!-- 날씨 div 끝 -->


			<div class="map-container">
				<div class="region 서울" style="top: 15%; left: 15%;" data-region="서울">
					서울</div>
				<div class="region 경기" style="top: 22%; left: 20%;" data-region="경기">
					경기</div>
				<div class="region 강원" style="top: 15%; left: 30%;" data-region="강원">
					강원</div>
				<div class="region 충북" style="top: 31%; left: 23%;" data-region="충북">
					충북</div>
				<div class="region 충남" style="top: 38%; left: 12%;" data-region="충남">
					충남</div>
				<div class="region 전북" style="top: 50%; left: 15%;" data-region="전북">
					전북</div>
				<div class="region 전남" style="top: 65%; left: 13%;" data-region="전남">
					전남</div>
				<div class="region 경북" style="top: 37%; left: 36%;" data-region="경북">
					경북</div>
				<div class="region 대구" style="top: 45%; left: 31%;" data-region="대구">
					대구</div>
				<div class="region 경남" style="top: 58%; left: 30%;" data-region="경남">
					경남</div>
				<div class="region 울산" style="top: 52%; left: 42%;" data-region="울산">
					울산</div>
				<div class="region 부산" style="top: 60%; left: 40%;" data-region="부산">
					부산</div>
				<div class="region 제주" style="top: 92%; left: 8%;" data-region="제주">
					제주</div>
			</div>



			<div id="plantInfoContainer">
				<h2 id="plantTitle">발전소 목록</h2>
				<div id="plantInfo">
					<p>지역을 클릭하면 발전소 목록이 표시됩니다.</p>
				</div>
				<div id="pagination" style="display: none;">
					<button id="prevPage">이전</button>
					<span id="pageInfo">1 / 1</span>
					<button id="nextPage">다음</button>
				</div>
			</div>
		</div>



		<div class="containerright">
			<div class="info-box" id="graph24h">
			  <label for="startTime">시작 시간:</label>
			  <input type="datetime-local" id="startTime" name="startTime">
			  <button id="btnDrawGraph">그래프 그리기</button>
			  <h2 id="title">지난 태양광 발전량</h2>
			  <canvas id="generationChart" width="400" height="250"></canvas>
			</div>

			<div class="info-box">
				<h2>72시간 예측 태양광 발전량</h2>
				<div id="graph72h">
					<canvas id="forecastChart" width="400" height="250"></canvas>
				</div>
			</div>
			
			
			
			
			

			<div class="info-box">
				<h2>24시간 태양광 발전량</h2>
				<div id="graphPast">여기에 그래프 영역</div>
			</div>

			<div class="info-box" id=plantInfoBox>
				<div class="info-panel" id="infoPanel">
					<h2>발전소 정보</h2>
					<p>지역을 클릭하면 정보가 표시됩니다.</p>
				</div>
			</div>

		</div>
	</div>

	<script>
	
	


document.addEventListener('DOMContentLoaded', () => {
	const data = {
		'서울': { count: '563개소', capacity: '120MW', production: '230,000MWh' },
		'경기': { count: '16,405개소', capacity: '3,600MW', production: '5,200,000MWh' },
		'강원': { count: '10,900개소', capacity: '2,500MW', production: '3,000,000MWh' },
		'충북': { count: '6,700개소', capacity: '1,200MW', production: '1,950,000MWh' },
		'충남': { count: '8,300개소', capacity: '1,800MW', production: '2,300,000MWh' },
		'전북': { count: '7,200개소', capacity: '1,500MW', production: '2,100,000MWh' },
		'전남': { count: '9,100개소', capacity: '2,100MW', production: '2,800,000MWh' },
		'경북': { count: '12,400개소', capacity: '3,100MW', production: '4,100,000MWh' },
		'대구': { count: '12,400개소', capacity: '3,100MW', production: '4,100,000MWh' },
		'경남': { count: '11,500개소', capacity: '2,900MW', production: '3,900,000MWh' },
		'울산': { count: '11,500개소', capacity: '2,900MW', production: '3,900,000MWh' },
		'부산': { count: '3,200개소', capacity: '800MW', production: '1,200,000MWh' },
		'제주': { count: '4,500개소', capacity: '1,000MW', production: '1,500,000MWh' },
	};


			const infoPanel = document.getElementById('infoPanel');
			const infoPanelweather = document.getElementById('infoPanelweather');
			
			const cityMap = {
			  서울: "Seoul",
			  부산: "Busan",
			  경기: "Gyeonggi-do",
			  강원: "Gangwon-do",
			  충북: "Chungcheongbuk-do",
			  충남: "Chungcheongnam-do",
			  전북: "Jeollabuk-do",
			  전남: "Jeollanam-do",
			  경북: "Gyeongsangbuk-do",
			  경남: "Gyeongsangnam-do",
			  제주: "Jeju-do"
			};



			document.querySelectorAll('.region').forEach(region => {
				  region.addEventListener('click', () => {
				    const name = region.dataset.region;
				    selectedRegion = region.dataset.region;
				    
				    console.log('클릭된 지역:', name);
				    console.log('선택된 지역:', selectedRegion);
				    
				    
				    getPlantList(name);
				    
				    getPlantList(selectedRegion);
				    /* draw72hForecastGraph(name); */
					
				    const startTime = document.getElementById('startTime').value;
    				const endTime = getEndTimeFromStart(startTime);
				    
				    
    				draw24hGraph(name, startTime, endTime);
    				
    				
				    if (!data[name]) {
				      infoPanel.innerHTML = '<p>데이터가 없습니다.</p>';
				      return;
				    }

				    let html =
				      '<h2>' + name + ' 발전소 정보</h2>' +
				      '<p><strong>발전소 개수 : </strong> ' + data[name].count + '</p>' +
				      '<p><strong>발전소 용량 : </strong> ' + data[name].capacity + '</p>' +
				      '<p><strong>연간 발전량 : </strong> ' + data[name].production + '</p>';
				      
				    let html2 =
					      '<h2>' + name + ' 현재 날씨 정보</h2>' +
					      '<div id="currentWeather"></div>';

				    infoPanel.innerHTML = html;
				    //infoPanelweather.innerHTML = html2;
				    //fetchOpenWeather(name);
				    
				    document.getElementById('plantTitle').textContent = name + ' 발전소 목록';
				    
				    // 페이징 초기화
				    currentPage = 1;
				  });
				});


	      async function fetchOpenWeather(regionName) {
	    	  try {
	    	    const response = await fetch('/api/weather/local/json?city=' + encodeURIComponent(regionName));

	    	    if (!response.ok) {
	    	      throw new Error('네트워크 응답 오류: ' + response.status);
	    	    }

	    	    const contentType = response.headers.get('content-type');
	    	    if (!contentType || !contentType.includes('application/json')) {
	    	      throw new Error('응답이 JSON이 아닙니다. content-type: ' + contentType);
	    	    }

	    	    const data = await response.json();

	    	    const currentWeather = document.getElementById('currentWeather');
	    	    console.log(data);
	    	    currentWeather.innerHTML =
	    	    	  '<p><strong>기온 : </strong>' + data.temp + '℃</p>' +
	    	    	  '<p><strong>습도 : </strong>' + data.humidity + '%</p>' +
	    	    	  '<p><strong>체감 온도 :</strong> ' + data.feels_like + '℃</p>' +
	    	    	  '<p><strong>날씨 : </strong>' + data.weather + '</p>';
	    	  } catch (error) {
	    	    console.error('fetchOpenWeather 에러:', error);
	    	    const currentWeather = document.getElementById('currentWeather');
	    	    currentWeather.innerHTML = '<p>날씨 정보를 불러오는 데 실패했습니다.</p>';
	    	  }
	    	}
	      
	      
	      
	      
  			  
	      
	   // JavaScript 페이징 포함
		  	let allPlants = [];
		  	let currentPage = 1;
		  	const itemsPerPage = 3;

		  	function renderPlantsPage(page) {
		  		
		  		
		  	    if (!Array.isArray(allPlants) || allPlants.length === 0) {
		  	        $('#plantInfo').html('<p>등록된 발전소가 없습니다.</p>');
		  	        $('#pagination').hide();
		  	        return;
		  	    }
		  		
		  	    const totalPages = Math.ceil(allPlants.length / itemsPerPage);
		  	    const start = (page - 1) * itemsPerPage;
		  	    const end = start + itemsPerPage;
		  	    const items = allPlants.slice(start, end);
		  	    

		  	    let html = '';
		  	    
		  	    items.forEach(p => {
		  	        html += 
		  	            '<div class="plant-item"><div class="plant-name">' + p.plantName + '</div><div class="plant-details">' + p.locationName + ', 용량: ' + p.installedCapacity + 'kW</div></div>';
		  	    });
		  	    html += '</div><div class="plant-details">Total : ' + allPlants.length + '</div>';

		  	    $('#plantInfo').html(html);
		  	    $('#pageInfo').text(`${page} / ${totalPages}`);
		  	    $('#prevPage').prop('disabled', page <= 1);
		  	    $('#nextPage').prop('disabled', page >= totalPages);
		  	    $('#pagination').show();
		  	} 

		  	$('#prevPage').click(() => {
		  	    if (currentPage > 1) {
		  	        currentPage--;
		  	        renderPlantsPage(currentPage);
		  	    }
		  	});

		  	$('#nextPage').click(() => {
		  	    if (currentPage < Math.ceil(allPlants.length / itemsPerPage)) {
		  	        currentPage++;
		  	        renderPlantsPage(currentPage);
		  	    }
		  	});

		  	function getPlantList(name) {
		  	    let Nname = '';
		  	    
		  	    console.log(Nname + name);
		  	    
		  	    if (['부산', '대구', '울산', '광주', '인천'].includes(name)) {
		  	        Nname = name + '광역시';
		  	    } else if (name === '서울') {
		  	        Nname = name + '특별시';
		  	    } else if (name ==='경남') {
		  	        Nname = '경상남도';
		  	    } else if (name ==='경북') {
		  	        Nname = '경상북도';
		  	    } else if (name ==='전남') {
		  	        Nname = '전라남도';
		  	    } else if (name ==='충북') {
		  	        Nname = '충청북도';
		  	    } else if (name ==='충남') {
		  	        Nname = '충청남도';
		  	    } else {
		  	    	Nname = name;
		  	    }

		  	    $.ajax({
		  	        url: '/api/plants/by-location?location=' + encodeURIComponent(Nname),
		  	        method: 'GET',
		  	        dataType: 'json',
		  	        success: function (plants) {
		  	            if (plants.length === 0) {
		  	                $('#plantInfo').html('<p>등록된 발전소가 없습니다.</p>');
		  	                $('#pagination').hide();
		  	                return;
		  	            }

		  	            allPlants = plants;
		  	            currentPage = 1;
		  	            renderPlantsPage(currentPage);
		  	        },
		  	        error: function () {
		  	            $('#plantInfo').html('<p>발전소 데이터를 불러오는 데 실패했습니다.</p>');
		  	            $('#pagination').hide();
		  	        }
		  	    });
		  	}
	      
	      
	      // 지난 태양광 발전량
		  	function draw24hGraph(region, startTime, endTime) {
		  	  $.ajax({
		  	    url: "/api/generation/chart-data",
		  	    type: "GET",
		  	    data: { 
		  	    	region: region,
					startTime: startTime,  // ISO 8601 포맷 예: 2025-06-20T10:00
					endTime: endTime
		  	    },
		  	    	
		  	    success: function (data) {
		  	    	let parsedData = typeof data === 'string' ? JSON.parse(data) : data;
		  	    	console.log("24h data:", parsedData);  // 데이터 로그 출력
		  	    	console.log("시작시간" + startTime);
		  	    	console.log("endTime" + endTime);
		  	    	
		  	    	
		  	    	if (!parsedData || parsedData.length === 0) {
		  	        	alert("데이터가 없습니다.");
		  	        	return;
		  	      }

		  	      const labels = parsedData.map(item => item.log_datetime);
		  	      const values = parsedData.map(item => item.generation_kw);

		  	      
		  	      document.getElementById("title").innerText = `${region} ${startTime} ~ ${endTime} 발전량 (kW)`;

		  	      const ctx = document.getElementById('generationChart').getContext('2d');

		  	      if (window.generationChartInstance) {
		  	        window.generationChartInstance.destroy();
		  	      }

		  	      window.generationChartInstance = new Chart(ctx, {
		  	        type: 'line',
		  	        data: {
		  	          labels: labels,
		  	          datasets: [{
		  	            label: '발전량 (kW)',
		  	            data: values,
		  	            backgroundColor: 'rgba(54, 162, 235, 0.2)',
		  	            borderColor: 'rgba(54, 162, 235, 1)',
		  	            borderWidth: 2,
		  	            fill: true,
		  	            tension: 0.4
		  	          }]
		  	        },
		  	        options: {
		  	          responsive: true,
		  	          scales: {
		  	            x: { title: { display: true, text: '시간' } },
		  	            y: { title: { display: true, text: '발전량 (kW)' } }
		  	          }
		  	        }
		  	      });
		  	    },
		  	    error: function (xhr, status, err) {
		  	      console.error("24시간 발전량 그래프 에러:", err);
		  	      alert("24시간 발전량 데이터 호출 실패");
		  	    }
		  	  });
		  	}
	      
	      
		  	let selectedRegion = null; // 전역변수로 선택된 지역명 저장

		  	function setDefaultStartTime() {
		  	  const now = new Date();
		  	  now.setMinutes(0, 0, 0);	// 1시간 단위로 고정
		  	  const defaultStart = new Date(now.getTime() - 24 * 60 * 60 * 1000); // 24시간 전

		  	  const toDatetimeLocal = (date) => {
		  	    const pad = (n) => n.toString().padStart(2, '0');
		  	    return date.getFullYear() + '-' +
		  	      pad(date.getMonth() + 1) + '-' +
		  	      pad(date.getDate()) + 'T' +
		  	      pad(date.getHours()) + ':' +
		  	      pad(date.getMinutes());
		  	  };

		  	  document.getElementById('startTime').value = toDatetimeLocal(defaultStart);
		  	}

		  	// 시작시간 + 24시간 계산 함수
		  	function getEndTimeFromStart(startTimeStr) {
		  	  const startDate = new Date(startTimeStr);
		  	  const endDate = new Date(startDate.getTime() + 24 * 60 * 60 * 1000);
		  	  const pad = (n) => n.toString().padStart(2, '0');

		  	  return endDate.getFullYear() + '-' +
		  	    pad(endDate.getMonth() + 1) + '-' +
		  	    pad(endDate.getDate()) + 'T' +
		  	    pad(endDate.getHours()) + ':' +
		  	    pad(endDate.getMinutes());
		  	}
			setDefaultStartTime();

		  	  document.getElementById('btnDrawGraph').addEventListener('click', () => {
		  	    if (!selectedRegion) {
		  	      alert("지역을 먼저 선택하세요.");
		  	      return;
		  	    }

		  	    const startTime = document.getElementById('startTime').value;
		  	    if (!startTime) {
		  	      alert("시작 시간을 입력하세요.");
		  	      return;
		  	    }

		  	    const endTime = getEndTimeFromStart(startTime);

		  	  	draw24hGraph(selectedRegion, startTime, endTime);
		  	  });
		  	
	      

		  	
		  	
		  	
		  	/* 
		  	// 72시간 태양광 발전소 예측
		  	function draw72hForecastGraph(region) {
		  	  fetch('/api/generation/forecast72h?region=' + region)  // ❌ encodeURIComponent 제거
		  	    .then(response => response.text())  // ✅ 응답을 문자열로 먼저 받기
		  	    .then(raw => {
		  	      let data;
		  	      try {
		  	        data = typeof raw === 'string' ? JSON.parse(raw) : raw;
		  	      } catch (e) {
		  	        console.error("JSON 파싱 실패:", e);
		  	        alert("72시간 예측 데이터를 읽는 데 실패했습니다.");
		  	        return;
		  	      }

		  	      if (!data || data.length === 0) {
		  	        alert("예측 데이터가 없습니다.");
		  	        return;
		  	      }

		  	      const labels = data.map(item => item.date_time);
		  	      const predicted = data.map(item => item.total_predicted);
		  	      const actual = data.map(item => item.total_actual);

		  	      const ctx = document.getElementById('forecastChart').getContext('2d');

		  	      if (window.forecastChartInstance) {
		  	        window.forecastChartInstance.destroy();
		  	      }

		  	      window.forecastChartInstance = new Chart(ctx, {
		  	        type: 'line',
		  	        data: {
		  	          labels,
		  	          datasets: [
		  	            {
		  	              label: '예측 발전량 (kWh)',
		  	              data: predicted,
		  	              borderColor: 'orange',
		  	              backgroundColor: 'rgba(255, 165, 0, 0.2)',
		  	              tension: 0.3
		  	            },
		  	            {
		  	              label: '실제 발전량 (kWh)',
		  	              data: actual,
		  	              borderColor: 'green',
		  	              backgroundColor: 'rgba(0, 128, 0, 0.2)',
		  	              tension: 0.3
		  	            }
		  	          ]
		  	        },
		  	        options: {
		  	          responsive: true,
		  	          scales: {
		  	            x: {
		  	              type: 'time',
		  	              time: {
		  	                unit: 'hour',
		  	                tooltipFormat: 'MM-DD HH:mm'
		  	              }
		  	            },
		  	            y: {
		  	              title: {
		  	                display: true,
		  	                text: '발전량 (kWh)'
		  	              }
		  	            }
		  	          },
		  	          plugins: {
		  	            title: {
		  	              display: true,
		  	              text: region + ' 지역의 72시간 발전량 예측 vs 실제'
		  	            }
		  	          }
		  	        }
		  	      });
		  	    })
		  	    .catch(error => {
		  	      console.error("72시간 예측 그래프 에러:", error);
		  	      alert("72시간 예측 데이터를 불러오지 못했습니다.");
		  	    });
		  	}

 */

	      
	      
});
</script>

</body>
</html>
