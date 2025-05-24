

$(document).ready(function () {

    $('#iconExample1').click(function (e) {
        e.preventDefault();

        Tinycon.setBubble(1);

        Tinycon.setOptions({
            background: '#f03d25'
        });
    });

    $('#iconExample2').click(function (e) {
        e.preventDefault();

        Tinycon.setBubble(1000);

        Tinycon.setOptions({
            background: '#f03d25'
        });
    });

    $('#iconExample3').click(function (e) {
        e.preventDefault();

        Tinycon.setBubble('In');

        Tinycon.setOptions({
            background: '#f03d25'
        });
    });

    $('#iconExample4').click(function (e) {
        e.preventDefault();

        Tinycon.setOptions({
            background: '#e0913b'
        });
        Tinycon.setBubble(8);

    });

});