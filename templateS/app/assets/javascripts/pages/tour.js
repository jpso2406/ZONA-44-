

$(document).ready(function () {

    // Define the tour!
    var tour = {
        id: "my-intro",
        steps: [
            {
                target: "#step1",
                title: "Title of my step",
                content: "Introduce new users to your product by walking them through it step by step.",
                placement: "top",
                yOffset: 10
            },
            {
                target: '#step2',
                title: "Title of my step",
                content: "Content of my step",
                placement: "top",
                zindex: 9999
            },
            {
                target: '#step3',
                title: "Title of my step",
                content: "Introduce new users to your product by walking them through it step by step.",
                placement: 'bottom',
                zindex: 999
            },
            {
                target: '#step4',
                title: "Title of my step",
                content: "Introduce new users to your product by walking them through it step by step.",
                placement: 'top',
                zindex: 999
            }
        ],
        showPrevButton: true
    };

    // Start the tour!

    $('.startTour').click(function () {
        hopscotch.startTour(tour);
    })

});