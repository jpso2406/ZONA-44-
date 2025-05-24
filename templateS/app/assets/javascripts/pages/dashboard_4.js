$(document).ready(function () {


    var d1 = [[1262304000000, 6], [1264982400000, 3057], [1267401600000, 20434], [1270080000000, 31982], [1272672000000, 26602], [1275350400000, 27826], [1277942400000, 24302], [1280620800000, 24237], [1283299200000, 21004], [1285891200000, 12144], [1288569600000, 10577], [1291161600000, 10295]];
    var d2 = [[1262304000000, 5], [1264982400000, 200], [1267401600000, 1605], [1270080000000, 6129], [1272672000000, 11643], [1275350400000, 19055], [1277942400000, 30062], [1280620800000, 39197], [1283299200000, 37000], [1285891200000, 27000], [1288569600000, 21000], [1291161600000, 17000]];

    var data1 = [
        { label: "Data 1", data: d1, color: '#17a084' },
        { label: "Data 2", data: d2, color: '#127e68' }
    ];
    $.plot($("#flot-chart1"), data1, {
        xaxis: {
            tickDecimals: 0
        },
        series: {
            lines: {
                show: true,
                fill: true,
                fillColor: {
                    colors: [{
                        opacity: 1
                    }, {
                        opacity: 1
                    }]
                },
            },
            points: {
                width: 0.1,
                show: false
            },
        },
        grid: {
            show: false,
            borderWidth: 0
        },
        legend: {
            show: false,
        }
    });

    var lineData = {
        labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
        datasets: [
            {
                label: "Net Margin",
                backgroundColor: "rgba(26,179,148,0.5)",
                borderColor: "rgba(26,179,148,0.7)",
                pointBackgroundColor: "rgba(26,179,148,1)",
                pointBorderColor: "#fff",
                data: [16,19,19,16,16,14,15,15,17,17,19,19]
            },
            {
                label: "Total Revenue",
                backgroundColor: "rgba(220,220,220,0.5)",
                borderColor: "rgba(220,220,220,1)",
                pointBackgroundColor: "rgba(220,220,220,1)",
                pointBorderColor: "#fff",
                data: [21,24,24,21,21,23,23,25,25,23,23,27,27,25,25,23,23,25,25,23,25,25,27]
            }
        ]
    };

    var lineOptions = {
        scales: {
            xAxes: [{
                ticks: {
                    fontColor: '#7a848fbf', // Color of x-axis labels
                },
                gridLines: {
                    color: '#91a6bd1f', // Color of x-axis grid lines]
                    zeroLineColor: 'rgba(145, 166, 189, 0.1)', // Color of y-axis base line
                },
            }],
            yAxes: [{
                ticks: {
                    fontColor: '#7a848fbf', // Color of y-axis labels
                },
                gridLines: {
                    color: 'transparent', // Color of x-axis grid lines]
                    zeroLineColor: 'transparent', // Color of y-axis base line
                },
            }],
        },
        legend: {
            labels: {
                fontColor: '#7a848fbf', // Change legend text color
            }
        },
        responsive: true
    };


    var ctx = document.getElementById("lineChart").getContext("2d");
    new Chart(ctx, { type: 'line', data: lineData, options: lineOptions });

});