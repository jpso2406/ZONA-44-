$(document).ready(function () {
    $('.animation_select').click(function () {
        $('#animation_box').removeAttr('class').attr('class', '');
        var animation = $(this).attr("data-animation");
        $('#animation_box').addClass('animated');
        $('#animation_box').addClass(animation);
        return false;
    });

    var graph2 = new Rickshaw.Graph({
        element: document.querySelector("#rickshaw_multi"),
        renderer: 'area',
        stroke: true,
        series: [{
            data: [{ x: 0, y: 2 }, { x: 1, y: 5 }, { x: 2, y: 8 }, { x: 3, y: 4 }, { x: 4, y: 8 }],
            color: '#1ab394',
            stroke: '#17997f'
        }, {
            data: [{ x: 0, y: 13 }, { x: 1, y: 15 }, { x: 2, y: 17 }, { x: 3, y: 12 }, { x: 4, y: 10 }],
            color: '#eeeeee',
            stroke: '#d7d7d7'
        }]
    });
    graph2.renderer.unstack = true;
    graph2.render();
});