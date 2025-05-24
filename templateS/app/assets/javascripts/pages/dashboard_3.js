$(document).ready(function () {

    var lineData = {
        labels: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
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
                label: "Revenue",
                backgroundColor: "rgba(220,220,220,0.5)",
                borderColor: "rgba(220,220,220,1)",
                pointBackgroundColor: "rgba(220,220,220,1)",
                pointBorderColor: "#fff",
                data: [21,24,24,21,21,23,23,25,25,23,23,27,27,25,25,23,23,25,25,23,25,25,27]
            }
        ],
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