$(document).ready(function () {

    $('.demo1').click(function () {
        swal({
            title: "Welcome in Alerts",
            text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        });
    });

    $('.demo2').click(function () {
        swal({
            title: "Good job!",
            text: "You clicked the button!",
            type: "success"
        });
    });

    $('.demo3').click(function () {
        swal({
            buttons: ["Stop", "Do it!"],
            title: "Are you sure?",
            text: "You will not be able to recover this imaginary file!",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, delete it!",
            closeOnConfirm: false
        },);
    });

    $('.demo4').click(function () {
        swal({
            dangerMode: true,
            buttons: true,
            title: "Are you sure?",
            text: "Your will not be able to recover this imaginary file!",
            type: "warning",
            showCancelButton: true,
            confirmButtonColor: "#DD6B55",
            confirmButtonText: "Yes, delete it!",
            cancelButtonText: "No, cancel plx!",
            closeOnConfirm: false,
            closeOnCancel: false
        });
    });

});