<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/luxon"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-luxon"></script>

<meta charset="UTF-8" />
<title>태양광 발전소 지도</title>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
@import url("https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.8/dist/web/static/pretendard.css");
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

#clock{
	margin:20px 0px;
}

.left-container {
	display: flex;
	flex-direction: column;
	gap: 20px;
	align-items: center; /* 필요 시 중앙 정렬 */
}

.map-container {
	position: relative;
	width: 430px; /* 원하는 고정 크기 */
	height: 600px; /* 원하는 고정 크기 */
	background-image:
		url('${pageContext.request.contextPath}/resources/img/map.png');
	background-size: contain;
	background-repeat: no-repeat;
	background-position: left center;
}

#container {
	display: grid;
	grid-template-columns: 300px 1100px 300px;
	gap: 20px;
	padding: 20px;
}

.info-panelweather {
	position: relative;
	width: 100%;
	padding: 15px;
	background-color: #f9f9fc;
	border-radius: 16px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	min-height: 100px;
	margin : 20px 0px;
	border: 0.5px solid #ccc;
}

.info-panelweather .clock {
  padding: 20px 24px;
}

.info-panelweather .clock #clock {
  font-size: 18.5px;
  font-weight: bold;
  color: #222;
  padding: 11px 0;
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



.info-box {
	background-color: #f9f9fc;
	border-radius: 12px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
	padding: 20px;
	min-height: 250px;
	border: 0.5px solid #ccc;
	width: 100%;
}

.info-box2 {
	background-color: #f9f9fc;
	border-radius: 12px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
	padding: 20px;
	min-height: 502px;
	max-height: 502px;
	border: 0.5px solid #ccc;
}

#utilizationRanking {
	min-height: 664px;
	max-height: 664px;
}
.info-box, .info-box2 {
	width: 100%; /* 부모 셀 크기 맞춤 */
}

.div-loding {
	position: relative;
}

.info-box2 h2 {
	margin-top: 0;
	font-size: 22px;
	border-bottom: 2px solid #007bff;
	padding-bottom: 8px;
	margin-bottom: 12px;
}

.info-box h2 {
	margin-top: 0;
	font-size: 22px;
	border-bottom: 2px solid #007bff;
	padding-bottom: 8px;
	margin-bottom: 12px;
}

.containerright {
	display: grid;
	margin-top: 20px;
	grid-template-columns: 1fr;
	gap:20px;
}

.containermid {
	display: grid;
	margin-top: 20px;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
}


 #graph24h label {
   font-weight: 600;
   margin-right: 10px;
 }

 #graph24h input[type="date"] {
   padding: 8px 12px;
   border-radius: 8px;
   border: 1px solid #ccc;
   font-size: 14px;
 }

 #graph24h button {
   padding: 8px 16px;
   margin-left: 12px;
   border: none;
   border-radius: 8px;
   background-color: #007bff;
   color: white;
   font-weight: bold;
   cursor: pointer;
   transition: background-color 0.2s ease;
 }

 #graph24h button:hover {
   background-color: #45a049;
 }

 #graph24h h2 {
   margin-top: 24px;
   margin-bottom: 16px;
   font-size: 20px;
   font-weight: bold;
   color: #333;
 }

 #graph24h canvas#generationChart {
   display: block;
   margin: 0 auto;
 }
 
.plant-status-card {
  background-color: #fafafb;
  border-radius: 12px;
  padding: 16px 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  width: auto;
  margin-top: 12px;
  margin-bottom: 12px;
}

.plant-status-card p {
  margin: 8px 0;
  font-size: 14px;
  color: #333;
}

#generation-summary-card {
  background-color: #fafafb;
  border-radius: 12px;
  padding: 16px 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  width: auto;
  margin-top: 12px;
  margin-bottom: 12px;
}

#env-summary-card {
  background-color: #fafafb;
  border-radius: 12px;
  padding: 16px 20px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  width: auto;
  margin-top: 12px;
  margin-bottom: 12px;
}

#generation-summary-card p {
  margin: 8px 0;
  font-size: 14px;
  color: #333;
}

#env-summary-card p {
  margin: 8px 0;
  font-size: 14px;
  color: #333;
}
canvas {
	width:100% !important;
	height:auto;
	max-width: 100%;
}

.loading-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(245, 245, 245, 0.7);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 10;
  border-radius: 12px;
}

.spinner {
  border: 4px solid #ccc;
  border-top: 4px solid #007bff;
  border-radius: 50%;
  width: 30px;
  height: 30px;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

#generationDiv {
  width: 100% !important;
  height: 500px !important;  /* ✅ 기존보다 큼직하게 */
  background: white;
  border-radius: 12px;
  box-shadow: 0 4px 8px rgba(0,0,0,0.06);
  padding: 12px;
}

 /* 모달 스타일 */
    .modal {
      display: none;
      position: fixed;
      top: 0; left: 0;
      width: 100vw; height: 100vh;
      background: rgba(0, 0, 0, 0.5);
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }


    .modal-content {
      background: white;
      padding: 20px;
      border-radius: 12px;
      width: 90%;
      max-width: 1000px;
    }

    .modal-close {
      float: right;
      cursor: pointer;
      font-size: 18px;
    }

    iframe {
      width: 100%;
      height: 700px;
      border: none;
    }



  .ranking-list {
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .ranking-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background: #f0f4f8;
    border-radius: 10px;
    padding: 11px 20px;
    margin-bottom: 8px;
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    transition: background 0.2s;
  }

  .ranking-item:hover {
    background: #e0ebf5;
  }

  .rank {
  	font-size: 18px;
	  font-weight: bold;
	  color: #1d72b8;
	  width: 60px;
	  display: flex;
	  align-items: center;
  }
  
  .rank2 {
    font-size: 18px;
    font-weight: bold;
    color: #1d72b8;
    width: 40px;
  }

  .region-name {
    flex-grow: 1;
  font-size: 16px;
  font-weight: 500;
  margin-left: 10px;
  }

  .efficiency {
    font-size: 16px;
    font-weight: bold;
    color: #444;
  }
  
/* 기본 순위 동그라미 */
.circle-number {
  display: inline-block;
  width: 28px;
  height: 28px;
  line-height: 28px;
  border-radius: 50%;
  background-color: #1d72b8;
  color: white;
  font-weight: bold;
  font-size: 15px;
  text-align: center;
}

/* 1등 */
.circle-number.gold {
  background-color: #FFD700;
  color: #333;
}

/* 2위 - 은색 */
.circle-number.silver {
  background-color: #C0C0C0;
  color: #333;
}

/* 3위 - 동색 */
.circle-number.bronze {
  background-color: #CD7F32;
  color: #fff;
}

#iframeLoading {
	position: absolute;
    top: 0; left: 0;
    width: 100%; height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: rgba(255, 255, 255, 0.8);
    font-size: 28px;
   	font-weight:bold;
    z-index: 100;
}
</style>
</head>
<body>
	<!-- <div id="loading-overlay"></div>
	<div id="loading-spinner"></div> -->
	
	<div id="container">
		<div class="left-container">
			<div class="info-panelweather">
				<div class="clock">
					<h2>현재 시간</h2>
					<p id="clock"></p>
					<div id="infoPanelweather">
						<h2>현재 날씨 정보</h2>
						<p style="text-align: center; padding: 20px; color: #666;">지역을 클릭하면 현재 날씨가 표시됩니다.</p>
					</div>
				</div>
			</div>


			<div class="map-container">
				<div class="region 서울" style="top: 19%; left: 23%;" data-region="서울">
					서울</div>
				<div class="region 경기" style="top: 25%; left: 27%;" data-region="경기">
					경기</div>
				<div class="region 강원" style="top: 18%; left: 55%;" data-region="강원">
					강원</div>
				<div class="region 충북" style="top: 34%; left: 37%;" data-region="충북">
					충북</div>
				<div class="region 충남" style="top: 39%; left: 20%;" data-region="충남">
					충남</div>
				<div class="region 전북" style="top: 54%; left: 28%;" data-region="전북">
					전북</div>
				<div class="region 전남" style="top: 70%; left: 25%;" data-region="전남">
					전남</div>
				<div class="region 경북" style="top: 43%; left: 62%;" data-region="경북">
					경북</div>
				<div class="region 대구" style="top: 53%; left: 58%;" data-region="대구">
					대구</div>
				<div class="region 경남" style="top: 62%; left: 50%;" data-region="경남">
					경남</div>
				<div class="region 울산" style="top: 58%; left: 73%;" data-region="울산">
					울산</div>
				<div class="region 부산" style="top: 63%; left: 64%;" data-region="부산">
					부산</div>
				<div class="region 제주" style="top: 94%; left: 13%;" data-region="제주">
					제주</div>
			</div>
		</div>


		<!-- 모달 -->
		<div id="modal" class="modal">
		  <div class="modal-content">
		    <span class="modal-close" onclick="closeModal()">✖</span>
		    <div id="iframeLoading" style="text-align: center; padding: 20px;">
		      로딩 중...
		    </div>
		    <iframe id="modalFrame" onload="hideIframeLoading()"></iframe>
		  </div>
		</div>

		<div class="containermid">
			
			<div class="info-box2 div-loding">
			  <div id="graphPast">
			    <h2 id="realtimeTitle">실시간 발전량</h2>
				<div id="predictionChart24-placeholder" style="text-align: center; padding: 20px; color: #666;">
				    지역을 클릭하면 정보가 표시됩니다.
				</div>
				<!-- 데이터 없음 메시지 -->
				<div id="predictionChart24-no-data" style="display: none; text-align: center; padding: 20px; color: #666;">
					데이터가 없습니다.
				</div>
				<div id="generation-summary-card" style="display: none;"></div>
				<canvas id="predictionChart24"></canvas>
				<div class="loading-overlay" id="predictionChartLoader" style="display: none;">
				    <div class="spinner"></div>
				</div>
			  </div>
			</div>
			

			<div class="info-box2 div-loding">
				<div id="graph72h">
					<h2>실시간 기온, 일사량, 발전량</h2>
					<!-- 초기 안내 문구 -->
					<div id="predictionChartWeather-placeholder" style="text-align: center; padding: 20px; color: #666;">
					    지역을 클릭하면 정보가 표시됩니다.
					</div>
					<!-- 데이터 없음 메시지 -->
					<div id="predictionChartWeather-no-data" style="display: none; text-align: center; padding: 20px; color: #666;">
					    데이터가 없습니다.
					</div>
					<div id="env-summary-card" style="display: none;"></div>
					<canvas id="predictionChartWeather"></canvas>
					<div class="loading-overlay" id="weatherChartLoader" style="display: none;">
					    <div class="spinner"></div>
					</div>
				</div>
			</div>

			
			<div class="info-box div-loding" id="graph24h">
			  <input type="date" id="startTime" name="startTime" onkeydown="return false;">
			  <button id="btnDrawGraph">그래프 그리기</button>
			  <h2 id="title">지난 태양광 발전량</h2>
			  <div id="generationDiv">
				  <!-- 초기 안내 문구 -->
			 	  <div id="graph24h-placeholder" style="text-align: center; padding: 20px; color: #666;">
				    날짜를 선택하면 정보가 표시됩니다.
			 	  </div>
				  <div id="graph24h-no-data" style="display: none; text-align: center; padding: 20px; color: #666;">
				  	데이터가 없습니다.
				  </div>
				  <canvas id="generationChart"></canvas>
				  <div class="loading-overlay" id="draw24ChartLoader" style="display: none;">
					   <div class="spinner"></div>
				  </div>
			  </div>
			</div>

			<div class="info-box" id="plantInfoBox">
				<div class="info-panel" id="infoPanel">
					<h2>발전소 현황</h2>
					<p style="text-align: center; padding: 20px; color: #666;">지역을 클릭하면 정보가 표시됩니다.</p>
				</div>
				<canvas id="pieChart" width="500" height="500" style="width:500px; height:500px;"></canvas>
			</div>

		</div>
		<div class="containerright">
			<div class="info-box2">
				<h2 id="plantTitle">발전소 목록</h2>
				<div id="plantInfo">
					<p style="text-align: center; padding: 20px; color: #666;">지역을 클릭하면 발전소 목록이 표시됩니다.</p>
				</div>
				<div id="pagination" style="display: none;">
					<button id="prevPage">이전</button>
					<span id="pageInfo">1 / 1</span>
					<button id="nextPage">다음</button>
				</div>
			</div>
			
			<div class="info-box2" id="utilizationRanking">
				<h2>지역별 설비이용률 순위</h2>
				<ul class="ranking-list" id="rankingList"></ul>
			</div>
		</div>
	</div>

<script>
	document.querySelectorAll('.region').forEach(region => {
	  region.addEventListener('click', () => {
	    const regionName = region.dataset.region;
	    openModal("http://127.0.0.1:5000/api/generation/graph-page/" + regionName);
	  });
	});
	
	function openModal(src) {
		const timestamp = new Date().getTime();  // 현재 시간(ms) 구하기
	  	const urlWithTimestamp = src + "?t=" + timestamp;  // 쿼리파라미터 추가

	  	document.getElementById("iframeLoading").style.display = "flex";
	  	document.getElementById("modalFrame").src = urlWithTimestamp;
	  	document.getElementById("modal").style.display = "flex";
	}
	function closeModal() {
	  document.getElementById("modal").style.display = "none";
	  document.getElementById("modalFrame").src = "";
	}
	function hideIframeLoading() {
	  document.getElementById("iframeLoading").style.display = "none";
	}
</script>



<script>
// 시간 출력
function updateClock() {
   	const now = new Date();
   	const formatted = now.toLocaleString(); // "2025. 6. 19. 오후 10:42:15"
   	document.getElementById("clock").innerText = formatted;
}
updateClock(); // 최초 1번 실행
setInterval(updateClock, 1000); // 1초마다 갱신

function showLoading() {
  $('#loading-overlay').show();
  $('#loading-spinner').show();
}

function hideLoading() {
  $('#loading-overlay').hide();
  $('#loading-spinner').hide();
}

function hide24hGraph() {
    const canvas = document.getElementById('generationChart');
    const summary = document.getElementById('generation-summary-card');
    const noData = document.getElementById('graph24h-no-data');
    const placeholder = document.getElementById('graph24h-placeholder');
    document.getElementById("title").innerText = "지난 태양광 발전량";

    // 그래프 숨기기
    if (canvas) {
        canvas.style.display = 'none';
    }

    // 요약 카드 숨기기
    if (summary) {
        summary.style.display = 'none';
        summary.innerHTML = '';
    }

    // '데이터 없음' 메시지 숨기기
    if (noData) {
        noData.style.display = 'none';
    }

    // 기본 안내 문구 다시 표시 (선택)
    if (placeholder) {
        placeholder.style.display = 'block';
    }

    // 차트 인스턴스 제거 (메모리 정리)
    if (window.generationChartInstance) {
        window.generationChartInstance.destroy();
        window.generationChartInstance = null;
    }
}


document.addEventListener('DOMContentLoaded', () => {
	// 날짜 선택 시 어제 날짜 까지만
	const today = new Date();
	today.setDate(today.getDate() - 1); // 하루 전으로 이동
	
	const yyyy = today.getFullYear();
	const mm = String(today.getMonth() + 1).padStart(2, '0');
	const dd = String(today.getDate()).padStart(2, '0');
	const maxDate = yyyy + "-" + mm + '-' + dd;

	document.getElementById('startTime').setAttribute('max', maxDate);

	const data = {
		'전국': {count: '175,436 개소', capacity: '27,471MW', production: '28,106,620MWh'},
		'서울': { count: '563개소', capacity: '50MW', production: '56,293MWh' },
		'경기': { count: '17,518‬개소', capacity: '3,050‬MW', production: '1,665,111MWh' },
		'강원': { count: '10,913개소', capacity: '1,932MW', production: '2,153,275MWh' },
		'충북': { count: '13,482개소', capacity: '1,575MW', production: '1,542,741MWh' },
		'충남': { count: '23,722‬개소', capacity: '3,810MW', production: '3,564,656MWh' },
		'전북': { count: '35,699개소', capacity: '4,538MW', production: '5,279,191MWh' },
		'전남': { count: '30,473‬개소', capacity: '6,316MW', production: '6,690,570MWh' },
		'경북': { count: '27,367개소', capacity: '3,732MW', production: '3,803,140MWh' },
		'대구': { count: '2,823개소', capacity: '404MW', production: '352,486MWh' },
		'경남': { count: '13,863개소', capacity: '1,964MW', production: '1,939,988MWh' },
		'울산': { count: '752개소', capacity: '148MW', production: '114,979MWh' },
		'부산': { count: '1,180 개소', capacity: '266MW', production: '239,890MWh' },
		'제주': { count: '1,741개소', capacity: '566MW', production: '648,512MWh' },
	};
	const regionColors = { '서울': '#3b82f6', '경기': '#22c55e', '강원': '#22d3ee', '충북': '#ef4444', '충남': '#a855f7', '전북': '#b45309', 
							'전남': '#ec4899', '경북': '#6b7280', '대구': '#84cc16', '경남': '#06b6d4', '울산': '#60a5fa', '부산': '#f87171', 
							'제주': '#f97316' };
	
	// 설비이용률 순위
	const periodHours = 8760; // 1년 시간

	const entries = Object.entries(data)
	  .filter(([region]) => region !== '전국')  // 전국은 제외
	  .map(([region, val]) => {
	    // 숫자만 추출 (콤마, 공백, MW, MWh 제거)
	    const capacityMW = parseFloat(val.capacity.replace(/[^\d.]/g, '')); // MW
	    const productionMWh = parseFloat(val.production.replace(/[^\d.]/g, '')); // MWh
	    const utilization = (productionMWh / (capacityMW * periodHours)) * 100;
	    return {
	      region,
	      utilization: parseFloat(utilization.toFixed(2)) // 소수점 2자리 숫자
	    };
	});
	
	const sorted = entries.sort((a, b) => b.utilization - a.utilization); // utilization으로 정렬
	const rankingList = document.getElementById('rankingList');
	const top10 = sorted.slice(0, 10);
	
	top10.forEach((item, index) => {
	  const li = document.createElement('li');
	  li.className = 'ranking-item';
	  li.innerHTML = "";
	  
	  var rankClass = 'circle-number';
	  
	  if(index === 0) rankClass += ' gold';
	  else if(index === 1) rankClass += ' silver';
	  else if(index === 2) rankClass += ' bronze';
	  
	  li.innerHTML +=
		    '<div class="rank">' +
		      '<span class="' + rankClass + '">' + (index + 1) + '</span>' +
		    '</div>';
		    
	  li.innerHTML += "<div class=\"region-name\">" + item.region + "</div>";
	  li.innerHTML += "<div class=\"efficiency\">" + item.utilization.toLocaleString() + " %</div>";
	  rankingList.appendChild(li);
    });

	/* const stationMap = {
			  '북춘천': '93', '백령도': '102', '북강릉': '104', '서울': '108', '인천': '112',
			  '울릉도': '115', '수원': '119', '청주': '131', '대전': '133', '안동': '136',
			  '포항': '138', '대구': '143', '전주': '146', '울산': '152', '창원': '155',
			  '광주': '156', '부산': '159', '목포': '165', '여수': '168', '흑산도': '169',
			  '홍성': '177', '제주': '184', '서귀포':'189', '속초': '90', '홍천': '212',
			  '태백': '216', '철원': '95', '정선군': '217', '동두천': '98', '제천': '221',
			  '파주': '99', '보은': '226', '대관령': '100', '천안': '232', '춘천': '101',
			  '보령': '235', '부여': '236', '금산': '238', '강릉': '105', '세종': '239',
			  '동해': '106', '부안': '243', '임실': '244', '정읍': '245', '원주': '114',
			  '남원': '247', '장수': '248', '고창군': '251', '영월': '121', '영광군': '252',
			  '충주': '127', '김해시': '253', '서산': '129', '순창군': '254', '울진': '130',
			  '북창원': '255', '양산시': '257', '보성군': '258', '추풍령': '135', '강진군': '259',
			  '장흥': '260', '상주': '137', '해남': '261', '고흥': '262', '군산': '140',
			  '의령군': '263', '함양군': '264', '광양시': '266', '진도군': '268', '봉화': '271',
			  '영주': '272', '문경': '273', '통영': '162', '청송군': '276', '영덕': '277',
			  '의성': '278', '구미': '279', '완도': '170', '영천': '281', '고창': '172',
			  '경주시': '283', '순천': '174', '거창': '284', '합천': '285', '밀양': '288',
			  '고산': '185', '산청': '289', '성산': '188', '거제': '294', '남해': '295',
			  '진주': '192', '강화': '201', '양평': '202', '이천': '203', '인제': '211'
			};
	
		const gyeongnam  = [
			  '울산', '창원', '북창원', '양산시', '김해시', '통영', '진주', '산청', '거제',
			  '밀양', '의령군', '함양군', '합천', '남해', '거창', '성산'
		];
		const gyeonggi = [
			  '인천', '수원', '동두천', '파주', '강화', '양평', '이천'
		];

		const gangwon = [
		  '북춘천', '춘천', '속초', '홍천', '태백', '철원', '정선군', '강릉', '동해', '대관령', '원주', '영월', '인제'
		];

		const chungbuk = [
		  '청주', '제천', '충주', '보은'
		];

		const chungnam = [
		  '대전', '세종', '천안', '홍성', '보령', '서산', '부여', '금산'
		];

		const jeonbuk = [
		  '전주', '군산', '부안', '임실', '정읍', '남원', '장수', '고창군', '순창군', '고창'
		];

		const jeonnam = [
		  '광주', '목포', '여수', '흑산도', '완도', '진도군', '강진군', '장흥', '해남', '고흥', '보성군', '영광군', '순천', '광양시'
		];

		const gyeongbuk = [
		  '안동', '포항', '대구', '울진', '추풍령', '상주', '봉화', '영주', '문경', '청송군', '영덕', '의성', '구미', '영천', '경주시'
		]; */
			
			
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

/* 			// 세부지역 없는 도시 목록
			const noSubRegions = ["서울", "부산", "제주"]; */

/* 			// 세부지역 배열 
			const regionSubRegions = {
			  경기: gyeonggi,
			  강원: gangwon,
			  충북: chungbuk,
			  충남: chungnam,
			  전북: jeonbuk,
			  전남: jeonnam,
			  경북: gyeongbuk,
			  경남: gyeongnam
			}; */
			
/* 
			document.querySelectorAll('.region').forEach(region => {
			  region.addEventListener('click', () => {
			    const name = region.dataset.region;
			    console.log('클릭된 지역:', name);

			    getPlantList(name);

			    if (!data[name]) {
			      infoPanel.innerHTML = '<p>데이터가 없습니다.</p>';
			      return;
			    }

			    let html = 
			      '<h2>' + name + ' 발전소 정보</h2>' +
			      '<p><strong>발전소 개수:</strong> ' + data[name].count + '</p>' +
			      '<p><strong>발전소 용량:</strong> ' + data[name].capacity + '</p>' +
			      '<p><strong>연간 발전량:</strong> ' + data[name].production + '</p>' +
			      '<h2>현재 날씨 정보</h2>' +
			      '<div id="currentWeather">로딩중...</div>' +
			      '<h2>' + name + ' 어제 날씨 정보</h2>';

			    if (noSubRegions.includes(name)) {
			      // 세부지역 없으면 select 없이 바로 날씨 정보
			      html += '<p id="weatherInfo">로딩중...</p>' +
			        '<div id="chartContainer" style="width: 450px; height: 300px; margin-top: 20px;">' +
			          '<canvas id="tempChart"></canvas>' +
			        '</div>';
			      infoPanel.innerHTML = html;

			      fetchWeather(name);
			      fetchOpenWeather(name);

			    } else {
			      // 세부지역 있는 경우 select 생성
			      html += 
			        '<select id="subRegionSelect">' +
			          '<option value="">지역을 선택하세요</option>' +
			        '</select>' +
			        '<div id="weatherInfo"></div>' +
			        '<div id="chartContainer" style="width: 450px; height: 300px; margin-top: 20px;">' +
			          '<canvas id="tempChart"></canvas>' +
			        '</div>';
			      infoPanel.innerHTML = html;

			      const selectEl = document.getElementById('subRegionSelect');
			      regionSubRegions[name].forEach(sub => {
			        const option = document.createElement('option');
			        option.value = sub;
			        option.textContent = sub;
			        selectEl.appendChild(option);
			      });

			      selectEl.addEventListener('change', (e) => {
			        const selectedSub = e.target.value;
			        const weatherInfoDiv = document.getElementById('weatherInfo');
			        if (!selectedSub) {
			          weatherInfoDiv.innerHTML = '';
			          return;
			        }
			        fetchWeather(selectedSub);
			      });

			      fetchOpenWeather(name);
			    }
			  });
			}); */
			
		const infoPanel = document.getElementById('infoPanel');
		const infoPanelweather = document.getElementById('infoPanelweather');
			
		document.querySelectorAll('.region').forEach(region => {
			  region.addEventListener('click', () => {
				
				// 지난 발전량 - 초기화해주기
				hide24hGraph();
				// 어제로 설정
				const today = new Date();
			    today.setDate(today.getDate() - 1); 
			    const yyyy = today.getFullYear();
			    const mm = String(today.getMonth() + 1).padStart(2, '0');
			    const dd = String(today.getDate()).padStart(2, '0');
			    const yesterdayStr = yyyy + "-" + mm + "-" + dd;

			    document.getElementById('startTime').value = yesterdayStr;
				
				// 설비이용률 크기 조정
				document.getElementById("utilizationRanking").style.minHeight = "700px";	  
				document.getElementById("utilizationRanking").style.maxHeight = "700px";	  
			    const name = region.dataset.region;
			    selectedRegion = region.dataset.region;
				    
			    updatePieChart(name);

			    getPlantList(name);
			    console.log('선택된 지역:', selectedRegion);

			    const startTime = document.getElementById('startTime').value;
   				const endTime = getEndTimeFromStart(startTime);
				    
   				// 24시간 예측 호출
				fetchPrediction(name, 24, 'predictionChartLoader');

				// 기온,일사량별 발전량 예측 호출
				fetchPredictionWeather(name, 'weatherChartLoader');
    				
			    if (!data[name]) {
			      infoPanel.innerHTML = '<p>데이터가 없습니다.</p>';
			      return;
			    }

			    /* let html =
			      '<h2>' + name + ' 발전소 현황</h2>' +
			      '<p><strong>발전소 개수 : </strong> ' + data[name].count + '</p>' +
			      '<p><strong>발전소 용량 : </strong> ' + data[name].capacity + '</p>' +
			      '<p><strong>연간 발전량 : </strong> ' + data[name].production + '</p>'; */
			    let html =
			      '<h2>' + name + ' 발전소 현황</h2>' +
			      '<div class="plant-status-card">' +
			      '<p><strong>발전소 용량 : </strong> ' + data[name].capacity + '</p>' +
			      '<p><strong>연간 발전량 : </strong> ' + data[name].production + '</p></div>';
				      
			    let html2 =
				      '<h2>' + name + ' 현재 날씨 정보</h2>' +
				      '<div id="currentWeather"></div>';

			    infoPanel.innerHTML = html;
			    infoPanelweather.innerHTML = html2;
			    fetchOpenWeather(name);
				    
			    document.getElementById('plantTitle').textContent = name + ' 발전소 목록';
				    
			    // 페이징 초기화
			    currentPage = 1;
			  });
		});
			
	      // 발전소 정보 차트
	      let pieChart = null;

	      const pastelColors = [
	        '#cce5ff', '#d5e8d4', '#fff2cc', '#f8cecc', '#e1d5e7',
	        '#f5f5f5', '#d9ead3', '#ead1dc', '#d0e0e3', '#f9cb9c',
	        '#c9daf8', '#b6d7a8', '#ffe599'
	      ];
	      
	      const highlightColor = '#f97316'; // 선택된 지역 강조 색상
	      
	      function updatePieChart(regionName) {
	        const ctx = document.getElementById('pieChart').getContext('2d');
	      
	        const labels = [];
	        const dataValues = [];
	        const backgroundColors = [];
	        const borderWidths = [];
	        const offsets = [];
	      
	        const pastelPool = [...pastelColors];
	        const exaggerationFactor = 6; // 선택 지역을 이만큼 크게
	      
	        // 원본 값 저장 → 툴팁에서 쓰기
	        const originalValues = {};
	      
	        Object.entries(data).forEach(([region, regionData]) => {
	          if (region === '전국') return;
	      
	          let value = parseFloat(regionData.production.replace(/[^\d.]/g, ""));
	          if (isNaN(value)) return;
	      
	          originalValues[region] = value;
	      
	          labels.push(region);
	      
	          if (region === regionName) {
	            value = value * exaggerationFactor;  // ✅ 과장 처리
	            backgroundColors.push(highlightColor);
	            borderWidths.push(2);
	            offsets.push(10);
	          } else {
	            backgroundColors.push(pastelPool.shift() || '#ccc');
	            borderWidths.push(1);
	            offsets.push(0);
	          }
	      
	          dataValues.push(value);
	        });
	      
	        if (pieChart) pieChart.destroy();
	      
	        pieChart = new Chart(ctx, {
	          type: 'doughnut',
	          data: {
	            labels: labels,
	            datasets: [{
	              data: dataValues,
	              backgroundColor: backgroundColors,
	              borderColor: '#fff',
	              borderWidth: borderWidths,
	              offset: offsets,
	              hoverOffset: 20
	            }]
	          },
	          options: {
	            responsive: false,
	            plugins: {
	              legend: {
	                position: 'bottom'
	              },
	              title: {
	                display: true,
	                text: regionName + "의 연간 발전량 비율"
	              },
	              tooltip: {
	                callbacks: {
	                  label: function (context) {
	                    const label = context.label;
	                    const realValue = originalValues[label] || 0;
	                    return label + ': ' + realValue.toLocaleString() + ' MWh';
	                  }
	                }
	              }
	            }
	          }
	        });
	      }
		
		// 24시간, 72시간 예측 그래프
		function drawPredictionGraph(data, hours, region, loadingId) {
			const chartContainerId = 'predictionChart24';
			const canvas = document.getElementById(chartContainerId);
			const container = canvas.parentElement;
			const noDataId = chartContainerId + '-no-data';
			const placeholderId = chartContainerId + '-placeholder';
			const summaryElem = document.getElementById('generation-summary-card');
			const msgElem = document.getElementById(noDataId);
			const placeholderElem = document.getElementById(placeholderId);
			
			if (loadingId) {
			    const loader = document.getElementById(loadingId);
			    if (loader) loader.style.display = 'none';
			}
		
			// 항상 영역 유지: 캔버스 visibility로 제어
			canvas.style.visibility = 'visible';
			canvas.style.display = 'block';
		
			// 데이터 없을 경우 처리
			if (!data || data.length === 0) {
				canvas.style.visibility = 'hidden';
				summaryElem.innerHTML = '';
				summaryElem.style.display = 'none';
		
				if (window.predictionChart24 instanceof Chart) {
					window.predictionChart24.destroy();
					window.predictionChart24 = null;
				}
		
				if (!document.getElementById(noDataId)) {
					const msg = document.createElement('div');
					msg.id = noDataId;
					msg.textContent = '데이터가 없습니다.';
					msg.style.textAlign = 'center';
					msg.style.padding = '20px';
					msg.style.color = '#666';
					container.appendChild(msg);
				} else {
					msgElem.style.display = 'block';
				}
		
				if (placeholderElem) placeholderElem.style.display = 'none';
				return;
			}
		
			// 기존 메시지 제거
			if (msgElem) msgElem.style.display = 'none';
			if (placeholderElem) placeholderElem.style.display = 'none';
			canvas.style.visibility = 'visible';
			summaryElem.style.display = 'block';
		
			// 1. 유효한 데이터 필터링 (null 제거)
			const validData = data.filter(d => d.totalPredictedOutput != null);
		
			// 2. 중복된 시간 제거 (가장 첫 번째 값만 유지)
			const seen = new Set();
			const uniqueData = validData.filter(d => {
				if (seen.has(d.dateTime)) return false;
				seen.add(d.dateTime);
				return true;
			});
		
			// 3. 시간순 정렬
			uniqueData.sort((a, b) => new Date(a.dateTime) - new Date(b.dateTime));
		
			// 4. 라벨 및 값 생성
			const labels = uniqueData.map(item => new Date(item.dateTime));
			const outputValues = uniqueData.map(item => Math.max(item.totalPredictedOutput, 0)); // 음수 방지
		
			// 5. 요약 카드 내용
			const maxOutput = Math.max(...outputValues);
			const avgOutput = outputValues.reduce((sum, val) => sum + val, 0) / outputValues.length;
			summaryElem.innerHTML =
				'<p><strong>' + region + ' 최대 발전량 : </strong>' + maxOutput.toFixed(2) + ' kW</p>' +
				'<p><strong>' + region + ' 평균 발전량 : </strong>' + avgOutput.toFixed(2) + ' kW</p>';
		
			// 기존 차트 제거
			if (window.predictionChart24 instanceof Chart) {
				window.predictionChart24.destroy();
			}
		
			// 6. 차트 생성
			const ctx = canvas.getContext('2d');
			
			// ✅ 선형 그라디언트
			const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
			gradient.addColorStop(0, 'rgba(75, 192, 192, 0.4)');
			gradient.addColorStop(1, 'rgba(75, 192, 192, 0)');
			
			window.predictionChart24 = new Chart(ctx, {
				type: 'line',
				data: {
					labels: labels,
					datasets: [{
						label: '예측 발전량 (kW)',
						data: outputValues,
						borderColor: 'rgba(75, 192, 192, 1)',
						backgroundColor: gradient,
						fill: true,
						tension: 0.4, // 부드러운 곡선
						pointRadius: 4,
						pointHoverRadius: 6,
						pointBackgroundColor: 'rgba(75, 192, 192, 1)',
						pointBorderColor: '#fff',
						pointHoverBorderColor: 'rgba(255, 255, 255, 1)'
					}]
				},
				options: {
				    responsive: true,
				    maintainAspectRatio: true,  // ✅ 비율 유지!
				    plugins: {
				        title: {
				            display: true,
				            text: region + ' 실시간 발전량 (' + hours + '시간)',
				            font: {
				                size: 18,
				                weight: 'bold'
				            },
				            padding: { top: 10, bottom: 20 }
				        },
				        tooltip: {
				        	mode: 'index',
				            intersect: false,
				            callbacks: {
				                title: function (context) {
				                    const date = new Date(context[0].parsed.x); // X축 시간
				                    const formatted =
				                        date.getMonth() + 1 + '월 ' +
				                        date.getDate() + '일 ' +
				                        date.getHours().toString().padStart(2, '0') + '시';
				                    return formatted; // 예: "6월 24일 15시"
				                },
				                label: function (context) {
				                    const value = context.parsed.y.toFixed(2);
				                    return "발전량 " + value + " kW";
				                }
				            }
				        },
				        legend: {
				            display: false
				        }
				    },
				    scales: {
				        x: {
				            type: 'time',
				            time: {
				                unit: 'hour',
				                displayFormats: {
				                    hour: 'HH:mm'
				                },
				                tooltipFormat: 'MMM dd HH:mm'
				            },
				            title: {
				                display: true,
				                text: '시간',
				                font: { size: 14 }
				            },
				            grid: {
				                color: 'rgba(200,200,200,0.2)'
				            }
				        },
				        y: {
				            beginAtZero: true,
				            grid: {
				                color: 'rgba(200,200,200,0.2)'
				            }
				        }
				    },
				    interaction: {
				        mode: 'index',
				        intersect: false
				    }
				}

			});

/* 		}

	
		window.predictionChart24 = predictionChart; */
	}

	
	// 기온, 일사량, 발전량 예측 그래프
	let weatherChartInstance = null; // 기존 차트 저장용 전역 변수
	
	function formatTime(dateTimeStr) {
	    const date = new Date(dateTimeStr);
	    return date.getHours().toString().padStart(2, '0') + ':' +
	           date.getMinutes().toString().padStart(2, '0');
	}

	function renderWeatherChart(data, region, loadingId) {
	    // ✅ 1. 중복 시간 제거
	    const seen = {};
	    const filteredData = data.filter(function(d) {
	        const time = d.dateTime.substring(11, 16);
	        if (seen[time]) return false;
	        seen[time] = true;
	        return true;
	    });

	    // ✅ 2. 음수/이상치 제거
	    const cleanedData = filteredData.filter(function(d) {
	        return (
	            typeof d.temperature === 'number' && d.temperature >= -50 && d.temperature <= 60 &&
	            typeof d.solarIrradiance === 'number' &&
	            typeof d.predictedOutput === 'number'
	        );
	    });

	    const chartContainerId = 'predictionChartWeather';
	    const canvas = document.getElementById(chartContainerId);
	    const placeholder = document.getElementById(chartContainerId + '-placeholder');
	    const noDataMessage = document.getElementById(chartContainerId + '-no-data');
	    const summaryElem = document.getElementById('env-summary-card');

	    // 초기 처리
	    if (placeholder) placeholder.style.display = 'none';

	    if (!cleanedData || cleanedData.length === 0) {
	        canvas.style.visibility = 'hidden';
	        summaryElem.innerHTML = '';
	        summaryElem.style.display = 'none';
	        if (noDataMessage) noDataMessage.style.display = 'block';

	        if (weatherChartInstance) {
	            weatherChartInstance.destroy();
	            weatherChartInstance = null;
	        }
	        return;
	    }

	    if (noDataMessage) noDataMessage.style.display = 'none';
	    canvas.style.visibility = 'visible';
	    summaryElem.style.display = 'block';

	    // ✅ 데이터 추출
	    const labels = cleanedData.map(d => d.dateTime.substring(11, 16));
	    const temperature = cleanedData.map(d => d.temperature);
	    const irradiance = cleanedData.map(d => d.solarIrradiance);
	    const predictedOutput = cleanedData.map(d => d.predictedOutput);
	   	console.log(predictedOutput + "::");
	    const ctx = canvas.getContext('2d');

	    // ✅ 통계 계산
	    const validTemps = temperature.filter(v => typeof v === 'number');
	    const avgTemp = validTemps.length > 0 ? validTemps.reduce((a, b) => a + b, 0) / validTemps.length : 0;
	    const maxTemp = validTemps.length > 0 ? Math.max(...validTemps) : 0;

	    const maxIrradiance = Math.max(...irradiance.filter(v => typeof v === 'number' && v >= 0), 0);
	    const maxOutput = Math.max(...predictedOutput.filter(v => typeof v === 'number' && v >= 0), 0);
	    const maxOutputObj = cleanedData.find(d => d.predictedOutput === maxOutput);
	    const maxOutputTime = maxOutputObj ? maxOutputObj.dateTime : '-';

	    summaryElem.innerHTML =
	        '<p><strong>최고 기온 : </strong>' + maxTemp.toFixed(1) + '°C</p>' +
	        '<p><strong>평균 기온 : </strong>' + avgTemp.toFixed(1) + '°C</p>' +
	        '<p><strong>최대 일사량 : </strong>' + maxIrradiance.toFixed(1) + ' W/m²</p>' +
	        '<p><strong>최대 발전량 : </strong>' + maxOutput.toFixed(1) + ' kW (' + formatTime(maxOutputTime) + ')</p>';

	    if (maxIrradiance > 800 && avgTemp < 30) {
	        summaryElem.innerHTML += '<p style="color:#1976D2;">☀️ 발전 조건이 매우 양호한 날입니다.</p>';
	    }
	  	
	  	// 기존 차트 제거 (중복 생성 방지)
	  	if (weatherChartInstance) {
	    	weatherChartInstance.destroy();
	  	}
	
	  	// 새 차트 생성
	  	weatherChartInstance = new Chart(ctx, {
	    	type: 'bar',
	    	data: {
	      		labels: labels,
	      		datasets: [
	        		{
			          type: 'bar',
			          label: '예측 발전량 (kWh)',
			          data: predictedOutput,
			          backgroundColor: 'rgba(54, 162, 235, 0.7)',
			          yAxisID: 'y',
		        	},
			        {
			          type: 'line',
			          label: '기온 (℃)',
			          data: temperature,
			          borderColor: 'rgba(255, 99, 132, 1)',
			          backgroundColor: 'rgba(255, 99, 132, 0.2)',
			          yAxisID: 'y1',
			          tension: 0.3
			        },
			        {
			          type: 'line',
			          label: '일사량 (W/m²)',
			          data: irradiance,
			          borderColor: 'rgba(255, 206, 86, 1)',
			          backgroundColor: 'rgba(255, 206, 86, 0.2)',
			          yAxisID: 'y2',
			          tension: 0.3
			        }
	      		]
			},
	    	options: {
	      		responsive: true,
			    interaction: {
			      	mode: 'index',
			        intersect: false,
			    },
	      		stacked: false,
		        plugins: {
			        title: {
			          display: true,
			          text: region + ' 지역 24시간 예측 발전량 및 기상 정보'
			        }
		      },
	      	scales: {
		        y: {
		          type: 'linear',
		          display: true,
		          position: 'left',
		          title: {
		            display: true,
		            text: '예측 발전량 (kWh)'
		          }
		        },
		        y1: {
		          type: 'linear',
		          display: true,
		          position: 'right',
		          title: {
		            display: true,
		            text: '기온 (℃)'
		          },
		          grid: {
		            drawOnChartArea: false,
		          }
		        },
		        y2: {
		          type: 'linear',
		          display: true,
		          position: 'right',
		          offset: true,
		          title: {
		            display: true,
		            text: '일사량 (W/m²)'
		          },
		          grid: {
		            drawOnChartArea: false,
		          }
		        }
	      	}
	    }
	  });
  	  if (loadingId) {
  	  	const loader = document.getElementById(loadingId);
  	  	if (loader) loader.style.display = 'none';
  	  }
	}


	/* // 어제 날씨 차트
	let tempChartInstance = null;
	
	function showTemperatureChart(regionName, hourlyTemps) {
		  const ctx = document.getElementById('tempChart').getContext('2d');
			
		  // 만약 이전 차트가 이미 있으면 destory하여 겹침 문제를 방지
		  if (tempChartInstance) {
		    tempChartInstance.destroy();
		  }

		  const labels = hourlyTemps.map(entry => {
		    // "2025-06-17 15:00" 형태 -> 시각만 추출
		    return entry.tm.split(' ')[1].slice(0, 2) + '시';
		  });

		  const temps = hourlyTemps.map(entry => Number(entry.ta));

		  tempChartInstance = new Chart(ctx, {
		    type: 'line',
		    data: {
		      labels: labels,
		      datasets: [{
		        label: `${regionName} - 전날 시간별 기온 (℃)`,
		        data: temps,
		        backgroundColor: 'rgba(78, 121, 167, 0.5)',
		        borderColor: 'rgba(78, 121, 167, 1)',
		        borderWidth: 2,
		        tension: 0.3,
		        fill: true,
		      }]
		    },
		    options: {
		      scales: {
		        y: {
		          beginAtZero: false,
		          suggestedMin: -10,
		          suggestedMax: 40
		        }
		      }
		    }
		  });
		} */

/* 	      // 공공데이터api
	      async function fetchWeather(regionName) {
	        const stationCode = stationMap[regionName];
	        const weatherInfoDiv = document.getElementById('weatherInfo');

	        if (!stationCode) {
	          weatherInfoDiv.innerHTML = '<p>해당 지역의 기상 코드가 없습니다.</p>';
	          return;
	        }

	        const now = new Date();
	        now.setDate(now.getDate() - 1);
	        const base_date = now.toISOString().slice(0, 10).replace(/-/g, '');
	        const startHh = '00';
	        const endHh = '23';

	        const serviceKey = 'tXVh19w8g7gA%2Fyg%2BcBeduu5tszcEPd3QJn5OTWX5DsvR%2BKWGffkCpPdVY%2BxKTKeLzdfxIqEvKyKOSVz6V4203Q%3D%3D';

	        const url =
				  "https://apis.data.go.kr/1360000/AsosHourlyInfoService/getWthrDataList?" +
				  "serviceKey=" + serviceKey +
				  "&pageNo=1&numOfRows=24&dataType=JSON" +
				  "&dataCd=ASOS&dateCd=HR" +
				  "&startDt=" + base_date + "&startHh=" + startHh +
				  "&endDt=" + base_date + "&endHh=" + endHh +
				  "&stnIds=" + stationCode;
	        
	        console.log(url);

	        try {
	          const response = await fetch(url);
	          if (!response.ok) throw new Error('네트워크 오류');
	          const json = await response.json();

	          // 데이터가 정상적으로 들어왔다고 가정하고, 대표적인 시간대 데이터(예: 12시)만 뽑기
	          const items = json.response.body.items.item;
	          if (!items || items.length === 0) {
	            weatherInfoDiv.innerHTML = '<p>날씨 데이터가 없습니다.</p>';
	            return;
	          }
	          

	          // 예시: 12시 데이터
	          const noonData = items.find(item => item.tm.includes('12'));
	          const dataToShow = noonData || items[0];

	          // 주요 데이터 추출 (기온, 습도, 강수량, 풍속)
	          const temp = dataToShow.ta ?? '0'; // 기온(℃)
	          const humidity = dataToShow.hm ?? '0'; // 습도(%)
	          const rainfall = dataToShow.rn ?? '0'; // 강수량(mm)
	          const windSpeed = dataToShow.ws ?? '0'; // 풍속(m/s)
	          


	          weatherInfoDiv.innerHTML =
	        	  '<p>기온: ' + (items[0].ta || '0') + '℃</p>' +
	        	  '<p>습도: ' + (items[0].hm || '0') + '%</p>' +
	        	  '<p>강수량: ' + (items[0].rn || '0') + 'mm</p>' +
	        	  '<p>풍속: ' + (items[0].ws || '0') + 'm/s</p>';

	        	// showTemperatureChart 함수에 전체 items 넘기기
	        	showTemperatureChart(regionName, items);

	        } catch (error) {
	          weatherInfoDiv.innerHTML = '<p>날씨 정보를 가져오는 데 실패했습니다.</p>';
	          console.error(error);
	        }
	      
	      } */
	      
	      // openweatherapi 
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
	    	    	  '<p><strong>기온 🌡️ : </strong>' + data.temp + '℃</p>' +
	    	    	  '<p><strong>습도 💧 : </strong>' + data.humidity + '%</p>' +
	    	    	  '<p><strong>체감 온도 🧍‍♂️ :</strong> ' + data.feels_like + '℃</p>' +
	    	    	  '<p><strong>날씨 🌤️ : </strong>' + data.weather + '</p>';
	    	  } catch (error) {
	    	    console.error('fetchOpenWeather 에러:', error);
	    	    const currentWeather = document.getElementById('currentWeather');
	    	    currentWeather.innerHTML = '<p style="text-align: center; padding: 20px; color: #666;">날씨 정보를 불러오는 데 실패했습니다.</p>';
	    	  }
	    	}
	      
  			  
	      
	   // JavaScript 페이징 포함
		  	let allPlants = [];
		  	let currentPage = 1;
		  	const itemsPerPage = 3;

		  	function renderPlantsPage(page) {
		  		
		  		
		  	    if (!Array.isArray(allPlants) || allPlants.length === 0) {
		  	        $('#plantInfo').html('<p style="text-align: center; padding: 20px; color: #666;">등록된 발전소가 없습니다.</p>');
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
		  	                $('#plantInfo').html('<p style="text-align: center; padding: 20px; color: #666;">등록된 발전소가 없습니다.</p>');
		  	                $('#pagination').hide();
		  	                return;
		  	            }

		  	            allPlants = plants;
		  	            currentPage = 1;
		  	            renderPlantsPage(currentPage);
		  	        },
		  	        error: function () {
		  	            $('#plantInfo').html('<p style="text-align: center; padding: 20px; color: #666;">발전소 데이터를 불러오는 데 실패했습니다.</p>');
		  	            $('#pagination').hide();
		  	        }
		  	    });
		  	}
	      
	      
		  	 // 지난 태양광 발전량
		  	function draw24hGraph(region, startTime, endTime, loadingId) {
	            const chartContainerId = 'graph24h';
	    		const canvas = document.getElementById("generationChart");
	    		const placeholder = document.getElementById(chartContainerId + '-placeholder');
	    		const noDataDiv = document.getElementById(chartContainerId + '-no-data');
	    		const loadingOverlay = document.getElementById("draw24ChartLoader");
	    		
	    		if (loadingOverlay) loadingOverlay.style.display = 'flex';
	    		
			    $.ajax({
			        url: "/api/generation/chart-data",
			        type: "GET",
			        data: { 
			            region: region,
			            start_date: startTime,
			            end_date: endTime
			        },
			        success: function (data) {
			        	if (loadingOverlay) loadingOverlay.style.display = 'none';
			            if (placeholder) placeholder.style.display = 'none';
			            const parsedData = typeof data === 'string' ? JSON.parse(data) : data;
			
			            if (!parsedData || parsedData.length === 0) {
			            	if (noDataDiv) noDataDiv.style.display = 'block';
			                if (canvas) canvas.style.display = 'none';
			                //document.getElementById("title").innerText = region + "의 발전량 (kW)";
			                return;
			            }
			            document.getElementById("title").innerText = region ? region + "의 발전량 (kW)" : '지난 태양광 발전량';
						
			            if (noDataDiv) noDataDiv.style.display = 'none';
			            if (canvas) canvas.style.display = 'block';
			
			            const labels = parsedData.map(item => item.log_datetime);
			            const values = parsedData.map(item => item.generation_kw);
			
			            const ctx = canvas.getContext('2d');
			            if (window.generationChartInstance) {
			                window.generationChartInstance.destroy();
			            }
			
			            window.generationChartInstance = new Chart(ctx, {
			                type: 'bar',
			                data: {
			                    labels: labels,
			                    datasets: [{
			                        label: '발전량 (kW)',
			                        data: values,
			                        backgroundColor: 'rgba(54, 162, 235, 0.7)',
			                        borderRadius: 6,
			                        barThickness: 20
			                    }]
			                },
			                options: {
			                    responsive: true,
			                    maintainAspectRatio: false,
			                    scales: {
			                        x: {
			                            title: {
			                                display: true,
			                                text: '시간',
			                                font: { size: 14 }
			                            },
			                            ticks: {
			                                callback: function(value) {
			                                    const label = this.getLabelForValue(value);
			                                    return label.substring(11, 16); // HH:mm
			                                },
			                                font: { size: 12 }
			                            },
			                            grid: { color: '#eee' }
			                        },
			                        y: {
			                            beginAtZero: true,
			                            ticks: { font: { size: 12 } },
			                            grid: { color: '#eee' }
			                        }
			                    },
			                    plugins: {
			                        legend: {
			                            labels: {
			                                font: { size: 14, weight: 'bold' },
			                                color: '#333'
			                            }
			                        },
			                        tooltip: {
			                            callbacks: {
			                                title: function(context) {
			                                    return context[0].label.substring(11, 16) + '시';
			                                }
			                            }
			                        }
			                    }
			                }
			            });
			        },
			        error: function (xhr, status, err) {
			        	if (loadingOverlay) loadingOverlay.style.display = 'none';
			            if (noDataDiv) noDataDiv.style.display = 'block';
			            if (canvas) canvas.style.display = 'none';
			            console.error("24시간 발전량 그래프 에러:", err);
			            //alert("24시간 발전량 데이터 호출 실패");
			        }
			    });
			}
			
			function setDefaultStartTime() {
			    const now = new Date();
			    now.setHours(0, 0, 0, 0);
			    const defaultStart = new Date(now.getTime() - 24 * 60 * 60 * 1000); // 하루 전
			
			    const toDateInputFormat = (date) => {
			        const pad = (n) => n.toString().padStart(2, '0');
			        return date.getFullYear() + '-' + pad(date.getMonth() + 1) + '-' + pad(date.getDate());
			    };
			
			    document.getElementById('startTime').value = toDateInputFormat(defaultStart);
			}
			
			function getEndTimeFromStart(startTimeStr) {
			    const startDate = new Date(startTimeStr);
			    const endDate = new Date(startDate.getTime() + 24 * 60 * 60 * 1000);
			    const pad = (n) => n.toString().padStart(2, '0');
			    return endDate.getFullYear() + '-' + pad(endDate.getMonth() + 1) + '-' + pad(endDate.getDate());
			}
			
			setDefaultStartTime();
			
			let selectedRegion = null;
			
			document.getElementById('btnDrawGraph').addEventListener('click', () => {
			    if (!selectedRegion) {
			        alert("지역을 먼저 선택하세요.");
			        return;
			    }
			
			    const startTime = document.getElementById('startTime').value;
			    if (!startTime) {
			        alert("날짜를 선택해주세요.");
			        return;
			    }
			
			    const endTime = getEndTimeFromStart(startTime);
			    draw24hGraph(selectedRegion, startTime, endTime, 'draw24ChartLoader');
			});

	      
		  	  // 24, 72시간 예측 그래프
		  	  function fetchPrediction(region, hours, loadingId) {
			  		const canvas = document.getElementById('predictionChart24');
			  	    const summaryElem = document.getElementById('generation-summary-card');
			  	    const noDataMessage = document.getElementById('predictionChart24-no-data');
			  	    const placeholder = document.getElementById('predictionChart24-placeholder');
			  	    
			  	  	if (canvas) canvas.style.visibility = 'hidden';
				  	if (summaryElem) summaryElem.style.display = 'none';
				  	if (noDataMessage) noDataMessage.style.display = 'none';
				  	if (placeholder) placeholder.style.display = 'none';
			  	  
		  		  	if (loadingId) {
					    document.getElementById(loadingId).style.display = 'flex';
					} else {
					    showLoading(); // 전체화면 로딩 (fallback)
					}
		  		  	
			  		$.ajax({
				  		url: '/api/power-output/region-predictions',
				    	type: 'GET',
				    	data: {
				      		region: region,
				      		hours: hours
				    	},
				    	headers: {
				    	    'Accept': 'application/json'   // JSON 요청 명시
				    	},
			    		success: function(data) {
			    			if (loadingId) {
			    		        document.getElementById(loadingId).style.display = 'none';
			    		    } else {
			    		        hideLoading();
			    		    }
			    			console.log('데이터 출력 : ' , data);
				      		drawPredictionGraph(data, hours, region, loadingId);
				    	},
				    	error: function(xhr, status, error) {
				    		if (loadingId) {
				    	        document.getElementById(loadingId).style.display = 'none';
				    	    } else {
				    	        hideLoading();
				    	    }
				      		console.error('예측 오류:', error);
				    	}
				  });
			  }
		  	  
		  	// 기온,일사량,발전량 예측 그래프
		  	function fetchPredictionWeather(region, loadingId) {
		  		const canvas = document.getElementById('predictionChartWeather');
			  	const summaryElem = document.getElementById('env-summary-card');
			  	const noDataMessage = document.getElementById('predictionChartWeather-no-data');
			  	const placeholder = document.getElementById('predictionChartWeather-placeholder');
			  	
			    if (canvas) canvas.style.visibility = 'hidden';
			    if (summaryElem) summaryElem.style.display = 'none';
			    if (noDataMessage) noDataMessage.style.display = 'none';
			    if (placeholder) placeholder.style.display = 'none';
		  		
		  		if (loadingId) {
		  		    document.getElementById(loadingId).style.display = 'flex';
		  		} else {
		  		    showLoading(); // 전체화면 로딩 (fallback)
		  		}
		  	  	$.ajax({
		  	    	url: '/api/power-output/region-weather-prediction',
		  	    	method: 'GET',
		  	    	data: {
		  	      		region: region,
		  	      		hours: 24
		  	    	},
		  	    	headers: {
			    	    'Accept': 'application/json'   // JSON 요청 명시
			    	},
		  	    	success: function(data) {
		  	    		if (loadingId) {
		  	    	        document.getElementById(loadingId).style.display = 'none';
		  	    	    } else {
		  	    	        hideLoading();
		  	    	    }		  	    		
		  	      		renderWeatherChart(data, region, loadingId);  // Chart.js 렌더링 함수 호출
		  	    	},
		  	    	error: function(xhr, status, error) {
		  	    		if (loadingId) {
		  	    	        document.getElementById(loadingId).style.display = 'none';
		  	    	    } else {
		  	    	        hideLoading();
		  	    	    }
		  	      		console.error('날씨 기반 예측 불러오기 실패', error);
		  	    	}
		  	  	});
		  	}


	      
	      
});
</script>

</body>
</html>
