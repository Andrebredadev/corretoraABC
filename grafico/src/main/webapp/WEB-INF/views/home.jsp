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
  var dataPoints1 = [], dataPoints2 = [];
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
}
</script>
</head>
<body>
<div id="chartContainer" style="height: 450px; width: 100%;"></div>
</body>
</html>