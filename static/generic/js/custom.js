var container = $('.book-a-table form').length > 0 ? $('.book-a-table form').parent() : "body";
$(function () {
    $('input[name="date"]').datepicker({
        format: 'mm/dd/yyyy',
        container: container,
        todayHighlight: true,
        autoclose: true,
        orientation: 'top'
    });

    $('#timePicker').timepicker({
        timeFormat: 'h:mm p',
        interval: 30,
        minTime: '10',
        maxTime: '10:00pm',
        defaultTime: '11',
        startTime: '10:00',
        dynamic: false,
        dropdown: true,
        scrollbar: true
    });
});