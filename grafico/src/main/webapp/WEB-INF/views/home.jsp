<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>   

<!DOCTYPE HTML>
<html>
<head>
<script type="text/javascript" src="https://canvasjs.com/assets/script/jquery-1.11.1.min.js"></script>
<script type="text/javascript" src="https://canvasjs.com/assets/script/canvasjs.stock.min.js"></script>
<script type="text/javascript">
window.onload = function () {
  var dataPoints1 = []; 
  var dataPoints2 = [];
  var stockChart = new CanvasJS.StockChart("chartContainer",{
    exportEnabled: true,
    title:{
      text:"Home Broker"
    },
    subtitles: [{
      text: "Açòes da Magazine Luisa"
    }],
    charts: [{
      axisX: {
        crosshair: {
          enabled: true,
          snapToDataPoint: true
        }
      },
      axisY: {
        prefix: "R$",
        lineThickness: 0
      },
      data: [{
        name: "Price (in BRL)",
        yValueFormatString: "R$#,###.##",
        type: "candlestick",
        dataPoints : dataPoints1
      }]
    }],
    navigator: {
      data: [{
        dataPoints: dataPoints2
      }],
      slider: {
        minimum: new Date(2019, 09, 10),
        maximum: new Date(2020, 04, 13)
      }
    }
  });
  $.getJSON("https://api.jsonbin.io/b/5f5aa6ad7243cd7e8239e194", function(data) {
    var lowestCloseDate = data[0].Date, lowestClosingPrice = data[0].Close;
    for(var i = 0; i < data.length; i++) {
      if(data[i].Close < lowestClosingPrice) {
        lowestClosingPrice = data[i].Close;
        lowestCloseDate = data[i].Date;
      }
    }
    for(var i = 0; i < data.length; i++){
      dataPoints1.push({x: new Date(data[i].Date), y: [Number(data[i].Open), Number(data[i].High), Number(data[i].Low), Number(data[i].Close)]});
      dataPoints2.push({x: new Date(data[i].Date), y: Number(data[i].Close)});
      if(data[i].Date === lowestCloseDate){
        dataPoints1[i].indexLabel = "Lowest Closing";
        dataPoints1[i].indexLabelFontColor = "red";
        dataPoints1[i].indexLabelOrientation = "vertical"
      }
    }
    stockChart.render();
  });

  var dataPoints = [];
  var dps1 = [], dps2 = [], dps3 = [];
  var emaChart = new CanvasJS.StockChart("stockChartContainer", {
    exportEnabled: true,
    title: {
      text:"Grafico EMA"
    },
    subtitles: [{
      text:"EMA Magazine Luisa"
    }],
    
    charts: [{
      axisX: {
        crosshair: {
          enabled: true,
          snapToDataPoint: true,
          valueFormatString: "MMM YYYY"
        }
      },

      legend: {
          cursor: "pointer",
          verticalAlign: "top",
          horizontalAlign: "right",          
          itemclick: function (e) {
            if (typeof (e.dataSeries.visible) === "undefined" || e.dataSeries.visible) {
              e.dataSeries.visible = false;
            } else {
              e.dataSeries.visible = true;
            }
            e.chart.render();
          }
        },
      
      axisY: {
        title: "BRL",
        prefix: "R$",        
        crosshair: {          
          enabled: true,
          snapToDataPoint: true,
          valueFormatString: "R$#,###.00",
        }
      },
      axisY2: {
          title: "BRL",
          prefix: "R$",        
          crosshair: {          
            enabled: true,
            snapToDataPoint: true,
            valueFormatString: "R$#,###.00",
          }
        },
      data: [{
        type: "line",
        xValueFormatString: "MMM YYYY",
        yValueFormatString: "R$#,###.##",
        dataPoints : dps1
      }]
        
    }],
    navigator: {
      slider: {
        minimum: new Date(2010, 00, 01),
        maximum: new Date(2018, 00, 01)
      }
    }
  });
  $.getJSON("https://api.jsonbin.io/b/5f5aa6ad7243cd7e8239e194", function(data) {
    for(var i = 0; i < data.length; i++){     
      dps1.push({x: new Date(data[i].Date), y: [Number(data[i].Open), Number(data[i].High), Number(data[i].Low), Number(data[i].Close)]});
      dps2.push({x: new Date(data[i].Date), y: [Number(data[i].Open), Number(data[i].High), Number(data[i].Low), Number(data[i].Close)]});
      dps3.push({x: new Date(data[i].Date), y: [Number(data[i].Open), Number(data[i].High), Number(data[i].Low), Number(data[i].Close)]});      
    }
    emaChart.render();
 	var ema8 = calculateEMA(dps1, 8);
    emaChart.charts[0].addTo("data", {type: "line", name: "EMA 8", showInLegend: true, yValueFormatString: "R$#,###.##", dataPoints: ema8});
    
    var ema17 = calculateEMA(dps2, 17)
    emaChart.charts[0].addTo("data", {type: "line", name: "EMA 17", showInLegend: true, yValueFormatString: "R$#,###.##", dataPoints: ema17});

    var ema34 = calculateEMA(dps3, 34)
    emaChart.charts[0].addTo("data", {type: "line", name: "EMA 34", showInLegend: true, yValueFormatString: "R$#,###.##", dataPoints: ema34}); 
    
  });  
  
  function calculateEMA(dps,count) {
    var k = 2/(count + 1);
    var emaDps = [{x: dps[0].x, y: dps[0].y.length ? dps[0].y[3] : dps[0].y}];
    for (var i = 1; i < dps.length; i++) {
      emaDps.push({x: dps[i].x, y: (dps[i].y.length ? dps[i].y[3] : dps[i].y) * k + emaDps[i - 1].y * (1 - k)});
    }
    return emaDps;
  }
} 
</script>
</head>
<body>
<div id="chartContainer" style="height: 450px; width: 100%;"></div>
<div id="stockChartContainer" style="height: 450px; width: 100%;"></div>
</body>
</html>