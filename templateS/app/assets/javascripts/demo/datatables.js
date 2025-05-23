// Upgrade button class name
$.fn.dataTable.Buttons.defaults.dom.button.className = 'btn btn-white btn-sm';



$(document).ready(function () {
    $('.dataTables-example').DataTable({
        pageLength: 15,
        responsive: true,
        dom: 'Bfrtip',
        buttons: [
            { extend: 'copy' },
            { extend: 'csv' },
            { extend: 'excel', title: 'ExampleFile' },
            { extend: 'pdf', title: 'ExampleFile' },

            {
                extend: 'print',
                customize: function (win) {
                    $(win.document.body).addClass('bg-white');
                    $(win.document.body).css('font-size', '10px');

                    $(win.document.body).find('table')
                        .addClass('compact')
                        .css('font-size', 'inherit');
                }
            }
        ]
    });

});