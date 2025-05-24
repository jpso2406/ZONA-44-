$(function () {

    $('#toggleSpinners').on('click', function () {

        $('#ibox1').children('.ibox-content').toggleClass('sk-loading');
        $('#ibox2').children('.ibox-content').toggleClass('sk-loading');

    })

})