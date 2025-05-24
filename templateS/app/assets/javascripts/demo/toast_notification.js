// 

$(function () {

    let toast1 = $('.toast1');
    let toast2 = $('.toast2');
    toast1.toast({
        delay: 5000,
        animation: true
    });
    toast2.toast({
        delay: 5000,
        animation: true
    });



    $('#showtoast').on('click', function (e) {
        e.preventDefault();
        toast1.toast('show');

    })


    $('#showleftbottom').on('click', function (e) {
        e.preventDefault();
        toast2.toast('show');

    })

    $("#sparkline1").sparkline([24, 43, 43, 35, 44, 32, 44, 62], {
        type: 'line',
        width: '100%',
        height: '50',
        lineColor: '#1ab394',
        fillColor: "transparent"
    });

})