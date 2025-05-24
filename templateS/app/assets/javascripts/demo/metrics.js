$(document).ready(function () {

    var sparklineCharts = function () {
        $("#sparkline1").sparkline([34, 43, 43, 35, 44, 32, 44, 52], {
            type: 'line',
            width: '100%',
            height: '60',
            lineColor: '#1ab394',
            fillColor: "transparent"
        });

        $("#sparkline2").sparkline([24, 43, 43, 55, 44, 62, 44, 72], {
            type: 'line',
            width: '100%',
            height: '60',
            lineColor: '#1ab394',
            fillColor: "transparent"
        });

        $("#sparkline3").sparkline([74, 43, 23, 55, 54, 32, 24, 12], {
            type: 'line',
            width: '100%',
            height: '60',
            lineColor: '#ed5565',
            fillColor: "transparent"
        });

        $("#sparkline4").sparkline([24, 43, 33, 55, 64, 72, 44, 22], {
            type: 'line',
            width: '100%',
            height: '60',
            lineColor: '#ed5565',
            fillColor: "transparent"
        });

        $("#sparkline5").sparkline([1, 4], {
            type: 'pie',
            height: '140',
            sliceColors: ['#1ab394', 'rgba(145, 166, 189, 0.1)']
        });

        $("#sparkline6").sparkline([5, 3], {
            type: 'pie',
            height: '140',
            sliceColors: ['#1ab394', 'rgba(145, 166, 189, 0.1)']
        });

        $("#sparkline7").sparkline([2, 2], {
            type: 'pie',
            height: '140',
            sliceColors: ['#ed5565', 'rgba(145, 166, 189, 0.1)']
        });

        $("#sparkline8").sparkline([2, 3], {
            type: 'pie',
            height: '140',
            sliceColors: ['#ed5565', 'rgba(145, 166, 189, 0.1)']
        });
    };

    var sparkResize;

    $(window).resize(function (e) {
        clearTimeout(sparkResize);
        sparkResize = setTimeout(sparklineCharts, 500);
    });

    sparklineCharts();


});