var container = $('.book-a-table form').length > 0 ? $('.book-a-table form').parent() : "body";
$(function () {
    $('#datepicker').datepicker({
        format: 'yyyy-mm-dd',
        container: container,
        todayHighlight: true,
        autoclose: true,
        orientation: 'top'
    });

    $('#timePicker').timepicker({
        timeFormat: 'H:mm',
        interval: 30,
        minTime: '10',
        maxTime: '22:00',
        defaultTime: '11',
        startTime: '10:00',
        dynamic: false,
        dropdown: true,
        scrollbar: true
    });
});