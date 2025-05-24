$(document).ready(function () {

    // Initial diff1
    $(".diff-wrapper").prettyTextDiff({
        diffContainer: ".diff1"
    });


    // Initial diff2
    $(".diff-wrapper2").prettyTextDiff({
        originalContent: $('#original').val(),
        changedContent: $('#changed').val(),
        diffContainer: ".diff2"
    });

    // Run diff on textarea change
    $(".diff-textarea").on('change keyup', function () {
        $(".diff-wrapper2").prettyTextDiff({
            originalContent: $('#original').val(),
            changedContent: $('#changed').val(),
            diffContainer: ".diff2"
        });

    });

});